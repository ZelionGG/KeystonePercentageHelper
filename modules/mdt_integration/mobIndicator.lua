local AddOnName, KeystonePercentageHelper = ...
local _G = _G
local pairs, ipairs, select, strsplit = pairs, ipairs, select, strsplit

-- Localization
local L = KeystonePercentageHelper.L

-- ===============================
-- Defaults
-- ===============================
KeystonePercentageHelper.defaults = KeystonePercentageHelper.defaults or { profile = {} }
KeystonePercentageHelper.defaults.profile.mobIndicator = {
    enabled      = false,
    texture      = 450928,            -- Provided by user
    size         = 24,                -- Default suggestion
    position     = "TOP",
    xOffset      = 0,
    yOffset      = 12,
    tintEnabled  = false,
    tint         = { r = 1, g = 1, b = 1, a = 1 },
    autoAdvance  = true,
    debug        = false,
}

-- ===============================
-- Internal state
-- ===============================
-- Cache of marker frames by unit token
KeystonePercentageHelper.nameplateMarkerFrames = KeystonePercentageHelper.nameplateMarkerFrames or {}

-- Ticker for periodic updates during M+
KeystonePercentageHelper.mobIndicatorTicker = KeystonePercentageHelper.mobIndicatorTicker or nil

-- MDT route/pull state for indicators
KeystonePercentageHelper.mdtIndicator = KeystonePercentageHelper.mdtIndicator or {
    loaded = false,
    pulls = nil,                 -- array of pulls (from MDT preset.value.pulls)
    currentPullIndex = 1,        -- managed locally (auto-advance togglable)
    maxPulls = 0,
    allNpcIds = {},              -- set of NPC IDs for pulls 1..currentPullIndex
    currentPullNpcIds = {},      -- set of NPC IDs for current pull only
    dungeonIdx = nil,            -- remember current dungeon index
    dungeonEnemies = nil,        -- cached enemies table for current dungeon
}

-- Simple debug helpers
local function tableCountKeys(t)
    local c = 0
    if t then for _ in pairs(t) do c = c + 1 end end
    return c
end

local function findEnemyIndicesByNpcId(dungeonEnemies, npcId)
    local indices = {}
    if type(dungeonEnemies) == "table" and npcId then
        for i, enemy in ipairs(dungeonEnemies) do
            local eid = enemy and (enemy.id or enemy.npcID or enemy.npcId or enemy.creatureId)
            if tonumber(eid) == npcId then table.insert(indices, i) end
        end
    end
    return indices
end

local function pullHasEnemyIndex(rawPull, idx)
    if type(rawPull) ~= "table" or type(idx) ~= "number" then return false end
    local function extractIndex(e)
        if type(e) == "number" then return e end
        if type(e) == "table" then
            local v = e.index or e.enemyIndex or e.enemyIdx or e[1]
            if type(v) == "number" then return v end
        end
        return nil
    end

    local function check(e)
        local v = extractIndex(e)
        if v and v == idx then return true end
        if type(e) == "table" then
            for _, sub in ipairs(e) do
                local sv = extractIndex(sub)
                if sv and sv == idx then return true end
            end
        end
        return false
    end

    -- Array-like entries
    for _, entry in ipairs(rawPull) do
        if check(entry) then return true end
    end
    -- Keyed entries
    for k, v in pairs(rawPull) do
        if type(k) ~= "number" then
            if check(v) then return true end
        end
    end
    return false
end

function KeystonePercentageHelper:MI_Debug(msg)
    local db = self.db and self.db.profile and self.db.profile.mobIndicator
    if db and db.debug then
        self:Print("[MobIndicator] " .. tostring(msg))
    end
end

-- ===============================
-- MDT Presence Check
-- ===============================
function KeystonePercentageHelper:CheckForMDTForIndicators()
    local loaded = false
    if C_AddOns and C_AddOns.IsAddOnLoaded then
        loaded = C_AddOns.IsAddOnLoaded("MythicDungeonTools") or C_AddOns.IsAddOnLoaded("MethodDungeonTools")
    elseif IsAddOnLoaded then
        loaded = IsAddOnLoaded("MythicDungeonTools") or IsAddOnLoaded("MethodDungeonTools")
    end

    -- Fallback: check globals in case addon API check fails
    if not loaded then
        loaded = (_G.MDT ~= nil) or (_G.MethodDungeonTools ~= nil)
    end

    self.mdtIndicator.loaded = not not loaded
    self:MI_Debug("MDT loaded = " .. tostring(self.mdtIndicator.loaded))
end

-- ===============================
-- Nameplate iteration
-- ===============================
function KeystonePercentageHelper:UpdateAllNameplateMarkers()
    if not (self.db and self.db.profile and self.db.profile.mobIndicator.enabled) then return end
    for i = 1, 40 do
        local unit = "nameplate" .. i
        if UnitExists(unit) then
            self:UpdateNameplateMarker(unit)
        end
    end
end

-- ===============================
-- Frame creation and positioning
-- ===============================
function KeystonePercentageHelper:UpdateMarkerPosition(unit)
    local frame = self.nameplateMarkerFrames[unit]
    if not frame then return end

    local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
    if not nameplate then return end

    local db = self.db.profile.mobIndicator
    local position = db.position or "TOP"
    local xOffset = db.xOffset or 0
    local yOffset = db.yOffset or 0

    frame:ClearAllPoints()
    if position == "RIGHT" then
        frame:SetPoint("LEFT", nameplate, "RIGHT", xOffset, yOffset)
    elseif position == "LEFT" then
        frame:SetPoint("RIGHT", nameplate, "LEFT", xOffset, yOffset)
    elseif position == "TOP" then
        frame:SetPoint("BOTTOM", nameplate, "TOP", xOffset, yOffset)
    elseif position == "BOTTOM" then
        frame:SetPoint("TOP", nameplate, "BOTTOM", xOffset, yOffset)
    else
        frame:SetPoint(position, nameplate, position, xOffset, yOffset)
    end
end

local function ensureMarkerFrame(self, unit)
    local frame = self.nameplateMarkerFrames[unit]
    local db = self.db.profile.mobIndicator

    if not frame then
        frame = CreateFrame("Frame", "KPH_MDTMarker_" .. unit, UIParent)
        frame:SetSize(db.size or 24, db.size or 24)
        frame:SetFrameStrata("TOOLTIP")
        frame:SetIgnoreParentAlpha(true)

        frame.tex = frame:CreateTexture(nil, "OVERLAY")
        frame.tex:SetAllPoints()
        -- Use a safe/visible texture during debug to rule out bad file IDs
        if db.debug then
            frame.tex:SetTexture("Interface\\Buttons\\WHITE8x8")
        else
            frame.tex:SetTexture(db.texture or 450928)
        end

        if db.tintEnabled then
            local c = db.tint or { r = 1, g = 1, b = 1, a = 1 }
            frame.tex:SetVertexColor(c.r or 1, c.g or 1, c.b or 1, c.a or 1)
        else
            frame.tex:SetVertexColor(1, 1, 1, 1)
        end

        -- Overlay a big letter when debug is enabled for maximum visibility
        frame.label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        frame.label:SetPoint("CENTER")
        frame.label:SetText("M")
        frame.label:SetTextColor(1, 0, 0, 1) -- red for visibility
        frame.label:Hide()

        self.nameplateMarkerFrames[unit] = frame
    else
        -- Update size/texture/tint live
        frame:SetSize(db.size or 24, db.size or 24)
        if db.debug then
            frame.tex:SetTexture("Interface\\Buttons\\WHITE8x8")
        else
            frame.tex:SetTexture(db.texture or 450928)
        end
        if db.tintEnabled then
            local c = db.tint or { r = 1, g = 1, b = 1, a = 1 }
            frame.tex:SetVertexColor(c.r or 1, c.g or 1, c.b or 1, c.a or 1)
        else
            frame.tex:SetVertexColor(1, 1, 1, 1)
        end
    end

    if frame.label then
        frame.label:SetShown(db.debug)
    end

    return frame
end

-- ===============================
-- Helpers
-- ===============================
local function getNpcIdFromUnit(unit)
    local guid = UnitGUID(unit)
    if not guid then return nil end
    local _, _, _, _, _, npcID = strsplit("-", guid)
    return npcID and tonumber(npcID) or nil
end

local function isUnitHostile(unit)
    local reaction = UnitReaction(unit, "player")
    return not reaction or reaction <= 4
end

-- ===============================
-- Update/Hiding logic
-- ===============================
function KeystonePercentageHelper:UpdateNameplateMarker(unit)
    -- Only in active M+
    if not C_ChallengeMode.IsChallengeModeActive() then return end

    -- Only when nameplates are visible (has a nameplate frame)
    if not C_NamePlate.GetNamePlateForUnit(unit) then
        self:RemoveNameplateMarker(unit)
        self:MI_Debug("No nameplate frame for unit " .. tostring(unit) .. ", hiding marker")
        return
    end

    -- Only hostile
    if not isUnitHostile(unit) then
        self:RemoveNameplateMarker(unit)
        return
    end

    -- MDT available and target set constructed
    if not (self.mdtIndicator.loaded and self.mdtIndicator.allNpcIds) then
        self:RemoveNameplateMarker(unit)
        return
    end

    local npcId = getNpcIdFromUnit(unit)
    if not npcId then
        self:RemoveNameplateMarker(unit)
        return
    end

    -- Show marker if NPC is in pulls up to current index
    if self.db and self.db.profile and self.db.profile.mobIndicator.debug then
        local inAll = self.mdtIndicator.allNpcIds[npcId] and true or false
        local inCur = self.mdtIndicator.currentPullNpcIds[npcId] and true or false
        local name = UnitName(unit)
        self:MI_Debug(string.format("Plate %s (npcId=%s): inAll=%s, inCurrent=%s", tostring(name), tostring(npcId), tostring(inAll), tostring(inCur)))
    end

    if self.mdtIndicator.allNpcIds[npcId] then
        local frame = ensureMarkerFrame(self, unit)
        self:UpdateMarkerPosition(unit)
        frame:Show()
    else
        if self.db and self.db.profile and self.db.profile.mobIndicator.debug then
            local m = self.mdtIndicator
            local indices = findEnemyIndicesByNpcId(m.dungeonEnemies, npcId)
            if #indices > 0 then
                local raw = m.pulls and m.pulls[m.currentPullIndex]
                local listed = false
                for _, idx in ipairs(indices) do
                    if pullHasEnemyIndex(raw, idx) then listed = true break end
                end
                self:MI_Debug(string.format("npcId %s exists in dungeonEnemies at indices [%s]; listedInCurrentPull=%s",
                    tostring(npcId), table.concat(indices, ","), tostring(listed)))
            else
                self:MI_Debug(string.format("npcId %s not found in dungeonEnemies (dungeonIdx=%s)", tostring(npcId), tostring(self.mdtIndicator.dungeonIdx)))
            end
        end
        self:RemoveNameplateMarker(unit)
    end
end

function KeystonePercentageHelper:RemoveNameplateMarker(unit)
    local frame = self.nameplateMarkerFrames[unit]
    if frame then
        frame:Hide()
        self.nameplateMarkerFrames[unit] = nil
    end
end

local function clearAllMarkers(self)
    for unit, frame in pairs(self.nameplateMarkerFrames) do
        frame:Hide()
        self.nameplateMarkerFrames[unit] = nil
    end
end

-- ===============================
-- MDT Pull parsing
-- ===============================
local function addNpcToSet(setTbl, npcId)
    if npcId then setTbl[npcId] = true end
end

local function resolveEntryToNpcId(entry, dungeonEnemies)
    local id
    if type(entry) == "table" then
        id = entry.id or entry.npcID or entry.npcId or entry.npcid or entry.creatureId
        if not id then
            -- Some MDT formats store enemy index under a named key
            local idx = entry.index or entry.enemyIndex or entry.enemyIdx
            if type(idx) ~= "number" then
                -- Fallback to first array slot
                idx = entry[1]
            end
            if type(idx) == "number" then
                if dungeonEnemies and dungeonEnemies[idx] then
                    local enemy = dungeonEnemies[idx]
                    id = (enemy and (enemy.id or enemy.npcID or enemy.npcId or enemy.creatureId))
                else
                    id = idx
                end
            end
        end
    elseif type(entry) == "number" then
        if dungeonEnemies and dungeonEnemies[entry] then
            local enemy = dungeonEnemies[entry]
            id = (enemy and (enemy.id or enemy.npcID or enemy.npcId or enemy.creatureId))
        else
            id = entry
        end
    end
    return tonumber(id)
end

local function collectNpcIdsFromPull(pull, outSet, dungeonEnemies)
    if type(pull) ~= "table" then return end

    local function handle(entry)
        local id = resolveEntryToNpcId(entry, dungeonEnemies)
        if id then
            addNpcToSet(outSet, id)
        end
        -- One-level flattening for nested tables (array and keyed)
        if type(entry) == "table" then
            for _, sub in ipairs(entry) do
                local sid = resolveEntryToNpcId(sub, dungeonEnemies)
                addNpcToSet(outSet, sid)
            end
            for k, v in pairs(entry) do
                if type(k) ~= "number" then
                    local sid = resolveEntryToNpcId(v, dungeonEnemies)
                    addNpcToSet(outSet, sid)
                end
            end
        end
    end

    -- Array-like entries
    for _, entry in ipairs(pull) do
        handle(entry)
    end
    -- Keyed entries (metadata-safe: resolveEntryToNpcId will return nil and we won't recurse further)
    for k, v in pairs(pull) do
        if type(k) ~= "number" then
            handle(v)
        end
    end
end

function KeystonePercentageHelper:RebuildIndicatorTargetSet()
    local DungeonTools = _G.MDT or _G.MethodDungeonTools
    local m = self.mdtIndicator
    m.allNpcIds = {}
    m.currentPullNpcIds = {}
    m.pulls = nil
    m.maxPulls = 0
    
    if not DungeonTools then
        self:MI_Debug("RebuildTargetSet: MDT not available")
        return
    end
    
    -- Try to read current preset and pulls safely
    local ok, preset = pcall(function()
        if DungeonTools.GetCurrentPreset then
            return DungeonTools:GetCurrentPreset()
        elseif DungeonTools.GetPreset then
            -- Some versions expose a single active preset via GetPreset (no args)
            return DungeonTools:GetPreset()
        end
        return nil
    end)

    -- Resolve preset table across MDT versions
    local presetData = nil
    if ok and preset ~= nil then
        if type(preset) == "table" then
            presetData = preset
        elseif type(preset) == "number" then
            -- Some MDT versions return an index for the current preset
            local idx = preset
            local ok2, p = pcall(function()
                if DungeonTools.GetPreset then
                    return DungeonTools:GetPreset(idx)
                elseif DungeonTools.GetPresetByIndex then
                    return DungeonTools:GetPresetByIndex(idx)
                end
                return nil
            end)
            if ok2 and type(p) == "table" then
                presetData = p
            end
        end
    end

    local pulls
    local dungeonIdx
    local presetSelectedPull
    if presetData and type(presetData) == "table" then
        local v = presetData.value or presetData
        if v and type(v.pulls) == "table" then
            pulls = v.pulls
        elseif type(presetData.pulls) == "table" then
            pulls = presetData.pulls
        end
        -- Try to determine current dungeon index for enemy index translation
        dungeonIdx = (v and v.currentDungeonIdx) or presetData.currentDungeonIdx
        -- Try to read MDT-selected current pull index if exposed in preset
        presetSelectedPull = (v and (v.currentPull or v.currentPullIndex)) or presetData.currentPull or presetData.currentPullIndex
    end
    
    if type(pulls) ~= "table" then
        -- No route/pulls available
        self:MI_Debug("No pulls found in preset")
        return
    end

    -- Translate enemy indices to NPC IDs when possible
    local dungeonEnemies
    if dungeonIdx and DungeonTools.dungeonEnemies and type(DungeonTools.dungeonEnemies) == "table" then
        dungeonEnemies = DungeonTools.dungeonEnemies[dungeonIdx]
    end

    m.pulls = pulls
    m.maxPulls = #pulls

    -- If MDT exposes a selected pull index, prefer it (bounds-checked)
    if type(presetSelectedPull) == "number" then
        if presetSelectedPull >= 1 and presetSelectedPull <= m.maxPulls then
            m.currentPullIndex = presetSelectedPull
            self:MI_Debug("Using MDT-selected currentPullIndex: " .. tostring(m.currentPullIndex))
        end
    end

    -- Ensure currentPullIndex in bounds
    if m.currentPullIndex < 1 then m.currentPullIndex = 1 end
    if m.currentPullIndex > m.maxPulls then m.currentPullIndex = m.maxPulls end

    -- Persist dungeon context for later mapping/debug
    m.dungeonIdx = dungeonIdx
    m.dungeonEnemies = dungeonEnemies

    -- Build sets: all pulls up to current, and current pull only
    for i = 1, m.currentPullIndex do
        collectNpcIdsFromPull(pulls[i], m.allNpcIds, dungeonEnemies)
    end
    collectNpcIdsFromPull(pulls[m.currentPullIndex], m.currentPullNpcIds, dungeonEnemies)

    self:MI_Debug(string.format(
        "Pulls=%d, dungeonIdx=%s, enemiesTbl=%s, currentPull=%d, allCount=%d, curCount=%d",
        m.maxPulls,
        tostring(dungeonIdx),
        tostring(dungeonEnemies and true or false),
        m.currentPullIndex,
        tableCountKeys(m.allNpcIds),
        tableCountKeys(m.currentPullNpcIds)
    ))
    if self.db and self.db.profile and self.db.profile.mobIndicator.debug then
        local cnt = 0
        local sample = {}
        for npcId, _ in pairs(m.currentPullNpcIds) do
            cnt = cnt + 1
            if #sample < 8 then table.insert(sample, tostring(npcId)) end
        end
        if cnt > 0 then
            self:MI_Debug("Current pull NPC IDs (sample): " .. table.concat(sample, ", "))
        end
        -- Also log a small sample of raw entries and resolved IDs for the current pull
        local raw = pulls[m.currentPullIndex]
        if type(raw) == "table" then
            local shown = 0
            for idx, entry in ipairs(raw) do
                local rid = resolveEntryToNpcId(entry, dungeonEnemies)
                self:MI_Debug(string.format("PullEntry[%d]: type=%s -> resolvedNpcId=%s", idx, type(entry), tostring(rid)))
                shown = shown + 1
                if shown >= 6 then break end
            end
        end
    end
end

-- ===============================
-- Auto-advance logic
-- ===============================
function KeystonePercentageHelper:TryAutoAdvancePull()
    local db = self.db.profile.mobIndicator
    local m = self.mdtIndicator
    if not (db.autoAdvance and m.pulls and m.currentPullNpcIds and m.maxPulls and m.maxPulls > 0) then
        return
    end
    if m.currentPullIndex >= m.maxPulls then return end
    if not next(m.currentPullNpcIds) then return end

    local foundVisible = false
    for i = 1, 40 do
        local unit = "nameplate" .. i
        if UnitExists(unit) and isUnitHostile(unit) then
            local npcId = getNpcIdFromUnit(unit)
            if npcId and m.currentPullNpcIds[npcId] then
                foundVisible = true
                break
            end
        end
    end

    if not foundVisible then
        m.currentPullIndex = m.currentPullIndex + 1
        -- Rebuild sets with new index
        self:RebuildIndicatorTargetSet()
        self:MI_Debug("Auto-advanced to pull index " .. tostring(m.currentPullIndex))
    end
end

-- ===============================
-- Ticker tick
-- ===============================
function KeystonePercentageHelper:OnMobIndicatorTick()
    local enabled = self.db and self.db.profile and self.db.profile.mobIndicator.enabled
    if not enabled then return end

    if not C_ChallengeMode.IsChallengeModeActive() then
        clearAllMarkers(self)
        return
    end

    self:CheckForMDTForIndicators()

    if not self.mdtIndicator.loaded then
        clearAllMarkers(self)
        return
    end

    -- Rebuild target sets and refresh plates
    self:RebuildIndicatorTargetSet()
    self:UpdateAllNameplateMarkers()

    -- Try auto-advance if enabled
    self:TryAutoAdvancePull()
end

local function startMobIndicatorTicker(self)
    if self.mobIndicatorTicker then return end
    self.mobIndicatorTicker = C_Timer.NewTicker(0.5, function() self:OnMobIndicatorTick() end)
end

local function stopMobIndicatorTicker(self)
    if self.mobIndicatorTicker then
        self.mobIndicatorTicker:Cancel()
        self.mobIndicatorTicker = nil
    end
end

-- ===============================
-- Event bootstrap
-- ===============================
function KeystonePercentageHelper:InitializeMobIndicator()
    if self.mobIndicatorFrame then
        -- reinitialize: clear and re-register
        self.mobIndicatorFrame:UnregisterAllEvents()
    else
        self.mobIndicatorFrame = CreateFrame("Frame")
    end

    self.mobIndicatorFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    self.mobIndicatorFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    self.mobIndicatorFrame:RegisterEvent("CHALLENGE_MODE_START")
    self.mobIndicatorFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
    self.mobIndicatorFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

    self.mobIndicatorFrame:SetScript("OnEvent", function(_, event, ...)
        if self.db and self.db.profile and self.db.profile.mobIndicator.debug then
            self:MI_Debug("Event: " .. tostring(event))
        end
        if event == "NAME_PLATE_UNIT_ADDED" then
            local unit = ...
            self:UpdateNameplateMarker(unit)
        elseif event == "NAME_PLATE_UNIT_REMOVED" then
            local unit = ...
            self:RemoveNameplateMarker(unit)
        elseif event == "CHALLENGE_MODE_START" or event == "PLAYER_ENTERING_WORLD" then
            self.mdtIndicator.currentPullIndex = 1
            self:CheckForMDTForIndicators()
            self:RebuildIndicatorTargetSet()
            self:UpdateAllNameplateMarkers()
            if C_ChallengeMode.IsChallengeModeActive() then
                startMobIndicatorTicker(self)
            end
        elseif event == "CHALLENGE_MODE_COMPLETED" then
            stopMobIndicatorTicker(self)
            clearAllMarkers(self)
        end
    end)

    -- Initial boot
    self:CheckForMDTForIndicators()
    self:RebuildIndicatorTargetSet()
    self:UpdateAllNameplateMarkers()

    if C_ChallengeMode.IsChallengeModeActive() then
        startMobIndicatorTicker(self)
    else
        stopMobIndicatorTicker(self)
    end
    self:MI_Debug("InitializeMobIndicator complete")
end

-- ===============================
-- AceConfig Options Group
-- ===============================
function KeystonePercentageHelper:GetMobIndicatorOptions()
    return {
        name = L["MOB_INDICATOR"] or "Mob Indicator",
        type = "group",
        order = 5,
        args = {
            intro = {
                name = L["MDT_WARNING"] or "Requires Mythic Dungeon Tools.",
                type = "description",
                order = 0,
                fontSize = "medium",
            },
            enable = {
                name = L["ENABLE"] or "Enable",
                desc = L["ENABLE"] or "Enable",
                type = "toggle",
                width = "full",
                order = 1,
                get = function() return self.db.profile.mobIndicator.enabled end,
                set = function(_, value)
                    self.db.profile.mobIndicator.enabled = value
                    if value then
                        self:InitializeMobIndicator()
                    else
                        if self.mobIndicatorFrame then
                            self.mobIndicatorFrame:UnregisterAllEvents()
                        end
                        stopMobIndicatorTicker(self)
                        for unit, frame in pairs(self.nameplateMarkerFrames) do
                            frame:Hide()
                        end
                        wipe(self.nameplateMarkerFrames)
                    end
                end
            },
            appearance = {
                name = L["APPEARANCE_OPTIONS"] or "Appearance",
                type = "group",
                inline = true,
                order = 2,
                args = {
                    texture = {
                        name = L["TEXTURE"] or "Texture (ID or Path)",
                        desc = L["TEXTURE"] or "Texture (ID or Path)",
                        type = "input",
                        order = 1,
                        width = 1.0,
                        get = function() return tostring(self.db.profile.mobIndicator.texture or 450928) end,
                        set = function(_, v)
                            local id = tonumber(v)
                            if id then
                                self.db.profile.mobIndicator.texture = id
                            elseif type(v) == "string" and v ~= "" then
                                -- Accept texture path strings
                                self.db.profile.mobIndicator.texture = v
                            else
                                return
                            end
                            for unit, _ in pairs(self.nameplateMarkerFrames) do
                                self:UpdateNameplateMarker(unit)
                            end
                        end,
                    },
                    size = {
                        name = L["SIZE"] or "Size",
                        desc = L["SIZE"] or "Size",
                        type = "range",
                        order = 2,
                        min = 8, max = 64, step = 1,
                        get = function() return self.db.profile.mobIndicator.size end,
                        set = function(_, value)
                            self.db.profile.mobIndicator.size = value
                            for unit, frame in pairs(self.nameplateMarkerFrames) do
                                frame:SetSize(value, value)
                                self:UpdateMarkerPosition(unit)
                            end
                        end,
                    },
                    tintEnabled = {
                        name = L["TINT"] or "Tint",
                        desc = L["TINT"] or "Tint",
                        type = "toggle",
                        order = 3,
                        get = function() return self.db.profile.mobIndicator.tintEnabled end,
                        set = function(_, value)
                            self.db.profile.mobIndicator.tintEnabled = value
                            for unit, frame in pairs(self.nameplateMarkerFrames) do
                                if value then
                                    local c = self.db.profile.mobIndicator.tint
                                    frame.tex:SetVertexColor(c.r, c.g, c.b, c.a)
                                else
                                    frame.tex:SetVertexColor(1, 1, 1, 1)
                                end
                            end
                        end
                    },
                    tint = {
                        name = L["COLOR"] or "Color",
                        desc = L["COLOR"] or "Color",
                        type = "color",
                        order = 4,
                        hasAlpha = true,
                        get = function()
                            local c = self.db.profile.mobIndicator.tint
                            return c.r, c.g, c.b, c.a
                        end,
                        set = function(_, r, g, b, a)
                            self.db.profile.mobIndicator.tint = { r = r, g = g, b = b, a = a }
                            if self.db.profile.mobIndicator.tintEnabled then
                                for _, frame in pairs(self.nameplateMarkerFrames) do
                                    frame.tex:SetVertexColor(r, g, b, a)
                                end
                            end
                        end,
                        disabled = function() return not self.db.profile.mobIndicator.tintEnabled end
                    },
                    position = {
                        name = L["POSITION"] or "Position",
                        desc = L["POSITION"] or "Position",
                        type = "select",
                        order = 5,
                        values = {
                            RIGHT = L["RIGHT"] or "RIGHT",
                            LEFT  = L["LEFT"]  or "LEFT",
                            TOP   = L["TOP"]   or "TOP",
                            BOTTOM= L["BOTTOM"]or "BOTTOM",
                        },
                        get = function() return self.db.profile.mobIndicator.position end,
                        set = function(_, v)
                            self.db.profile.mobIndicator.position = v
                            for unit, _ in pairs(self.nameplateMarkerFrames) do
                                self:UpdateMarkerPosition(unit)
                            end
                        end
                    },
                    xOffset = {
                        name = L["X_OFFSET"] or "X Offset",
                        desc = L["X_OFFSET_DESC"] or "Horizontal offset",
                        type = "range",
                        order = 6,
                        min = -100, max = 100, step = 1,
                        get = function() return self.db.profile.mobIndicator.xOffset end,
                        set = function(_, v)
                            self.db.profile.mobIndicator.xOffset = v
                            for unit, _ in pairs(self.nameplateMarkerFrames) do
                                self:UpdateMarkerPosition(unit)
                            end
                        end
                    },
                    yOffset = {
                        name = L["Y_OFFSET"] or "Y Offset",
                        desc = L["Y_OFFSET_DESC"] or "Vertical offset",
                        type = "range",
                        order = 7,
                        min = -100, max = 100, step = 1,
                        get = function() return self.db.profile.mobIndicator.yOffset end,
                        set = function(_, v)
                            self.db.profile.mobIndicator.yOffset = v
                            for unit, _ in pairs(self.nameplateMarkerFrames) do
                                self:UpdateMarkerPosition(unit)
                            end
                        end
                    },
                }
            },
            behavior = {
                name = L["BEHAVIOR"] or "Behavior",
                type = "group",
                inline = true,
                order = 3,
                args = {
                    autoAdvance = {
                        name = L["AUTO_ADVANCE"] or "Auto-advance pull",
                        desc = L["AUTO_ADVANCE"] or "Auto-advance pull when no current-pull mobs are visible.",
                        type = "toggle",
                        order = 1,
                        get = function() return self.db.profile.mobIndicator.autoAdvance end,
                        set = function(_, v) self.db.profile.mobIndicator.autoAdvance = v end
                    },
                    debug = {
                        name = "Debug",
                        desc = "Enable debug logs for the Mob Indicator",
                        type = "toggle",
                        order = 2,
                        width = "full",
                        get = function() return self.db.profile.mobIndicator.debug end,
                        set = function(_, v) self.db.profile.mobIndicator.debug = v end
                    },
                }
            }
        }
    }
end