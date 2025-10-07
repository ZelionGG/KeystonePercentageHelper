local AddOnName, KeystonePolaris = ...
local _G = _G
local pairs, ipairs, select, strsplit = pairs, ipairs, select, strsplit

-- Localization
local L = KeystonePolaris.L

-- ===============================
-- Defaults
-- ===============================
KeystonePolaris.defaults = KeystonePolaris.defaults or { profile = {} }
KeystonePolaris.defaults.profile.mobIndicator = {
    enabled      = false,
    texture      = "Azerite-PointingArrow", -- Provided by user
    size         = 24,                      -- Default suggestion
    position     = "TOP",
    xOffset      = 0,
    yOffset      = 0,
    tintEnabled  = false,
    tint         = { r = 1, g = 1, b = 1, a = 1 },
    autoAdvance  = true,
}

-- ===============================
-- Internal state
-- ===============================
-- Cache of marker frames by unit token
KeystonePolaris.nameplateMarkerFrames = KeystonePolaris.nameplateMarkerFrames or {}

-- Ticker for periodic updates during M+
KeystonePolaris.mobIndicatorTicker = KeystonePolaris.mobIndicatorTicker or nil

-- MDT route/pull state for indicators
KeystonePolaris.mdtIndicator = KeystonePolaris.mdtIndicator or {
    loaded = false,
    pulls = nil,                 -- array of pulls (from MDT preset.value.pulls)
    currentPullIndex = 1,        -- managed locally (auto-advance togglable)
    maxPulls = 0,
    allNpcIds = {},              -- set of NPC IDs for pulls 1..currentPullIndex
    currentPullNpcIds = {},      -- set of NPC IDs for current pull only
    dungeonIdx = nil,            -- remember current dungeon index
    dungeonEnemies = nil,        -- cached enemies table for current dungeon
    requiredCounts = {},         -- map: npcId -> required clone count for current pull
    selectedUnits = {},          -- set: unit token -> true (units chosen to highlight this tick)
}

--

--

-- ===============================
-- MDT Presence Check
-- ===============================
function KeystonePolaris:CheckForMDTForIndicators()
    local loaded = false
    if C_AddOns and C_AddOns.IsAddOnLoaded then
        loaded = C_AddOns.IsAddOnLoaded("MythicDungeonTools")
    elseif IsAddOnLoaded then
        loaded = IsAddOnLoaded("MythicDungeonTools")
    end

    -- Fallback: check globals in case addon API check fails
    if not loaded then
        loaded = (_G.MDT ~= nil)
    end

    self.mdtIndicator.loaded = not not loaded
end

-- ===============================
-- Nameplate iteration
-- ===============================
function KeystonePolaris:UpdateAllNameplateMarkers()
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
function KeystonePolaris:UpdateMarkerPosition(unit)
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

-- Apply texture or atlas to the marker texture
local function applyMarkerTexture(frame, tex)
    local applied = false
    if type(tex) == "number" then
        frame.tex:SetTexture(tex)
        frame.tex:SetTexCoord(0, 1, 0, 1)
        applied = true
    elseif type(tex) == "string" then
        local isAtlas = (C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(tex)) and true or false
        if isAtlas and frame.tex.SetAtlas then
            frame.tex:SetAtlas(tex, false) -- keep our frame size
            applied = true
        else
            frame.tex:SetTexture(tex)
            frame.tex:SetTexCoord(0, 1, 0, 1)
            applied = true
        end
    end
    if not applied then
        -- Fallback icon
        frame.tex:SetTexture(450928)
        frame.tex:SetTexCoord(0, 1, 0, 1)
    end
end

local function ensureMarkerFrame(self, unit)
    local frame = self.nameplateMarkerFrames[unit]
    local db = self.db.profile.mobIndicator

    -- Reuse existing named frame if present to avoid CreateFrame name conflicts
    local globalName = "KPL_MDTMarker_" .. unit
    if not frame then
        frame = _G[globalName]
        if frame then
            self.nameplateMarkerFrames[unit] = frame
        end
    end

    if not frame then
        frame = CreateFrame("Frame", globalName, UIParent)
        frame:SetSize(db.size or 24, db.size or 24)
        frame:SetFrameStrata("MEDIUM")
        frame:SetIgnoreParentAlpha(true)
        frame:EnableMouse(false)

        frame.tex = frame:CreateTexture(nil, "OVERLAY")
        frame.tex:SetAllPoints()
        applyMarkerTexture(frame, db.texture or 450928)

        if db.tintEnabled then
            local c = db.tint or { r = 1, g = 1, b = 1, a = 1 }
            frame.tex:SetVertexColor(c.r or 1, c.g or 1, c.b or 1, c.a or 1)
        else
            frame.tex:SetVertexColor(1, 1, 1, 1)
        end

        self.nameplateMarkerFrames[unit] = frame
    else
        -- Update size/texture/tint live
        frame:SetSize(db.size or 24, db.size or 24)
        applyMarkerTexture(frame, db.texture or 450928)
        if db.tintEnabled then
            local c = db.tint or { r = 1, g = 1, b = 1, a = 1 }
            frame.tex:SetVertexColor(c.r or 1, c.g or 1, c.b or 1, c.a or 1)
        else
            frame.tex:SetVertexColor(1, 1, 1, 1)
        end
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
function KeystonePolaris:UpdateNameplateMarker(unit)
    -- Only in active M+
    if not C_ChallengeMode.IsChallengeModeActive() then return end

    -- Only when nameplates are visible (has a nameplate frame)
    if not C_NamePlate.GetNamePlateForUnit(unit) then
        self:RemoveNameplateMarker(unit)
        return
    end

    -- Only hostile
    if not isUnitHostile(unit) then
        self:RemoveNameplateMarker(unit)
        return
    end

    -- MDT available and target set constructed
    if not (self.mdtIndicator.loaded and self.mdtIndicator.selectedUnits) then
        self:RemoveNameplateMarker(unit)
        return
    end

    if self.mdtIndicator.selectedUnits[unit] then
        local frame = ensureMarkerFrame(self, unit)
        self:UpdateMarkerPosition(unit)
        frame:Show()
    else
        self:RemoveNameplateMarker(unit)
    end
end

function KeystonePolaris:RemoveNameplateMarker(unit)
    local frame = self.nameplateMarkerFrames[unit]
    if frame then
        frame:Hide()
    end
end

local function clearAllMarkers(self)
    for unit, frame in pairs(self.nameplateMarkerFrames) do
        frame:Hide()
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

function KeystonePolaris:RebuildIndicatorTargetSet()
    local DungeonTools = _G.MDT
    local m = self.mdtIndicator
    m.allNpcIds = {}
    m.currentPullNpcIds = {}
    m.pulls = nil
    m.maxPulls = 0
    
    if not DungeonTools then
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
        end
    end

    -- Ensure currentPullIndex in bounds
    if m.currentPullIndex < 1 then m.currentPullIndex = 1 end
    if m.currentPullIndex > m.maxPulls then m.currentPullIndex = m.maxPulls end

    -- Persist dungeon context for later mapping
    m.dungeonIdx = dungeonIdx
    m.dungeonEnemies = dungeonEnemies

    -- Build sets: all pulls up to current, and current pull only
    for i = 1, m.currentPullIndex do
        collectNpcIdsFromPull(pulls[i], m.allNpcIds, dungeonEnemies)
    end
    collectNpcIdsFromPull(pulls[m.currentPullIndex], m.currentPullNpcIds, dungeonEnemies)

    -- Build required counts for the current pull (WeakAura-compatible)
    self:BuildCurrentPullNpcCounts()
end

-- Build per-NPC required counts for the CURRENT pull, based on MDT enemy indices and clone tables
function KeystonePolaris:BuildCurrentPullNpcCounts()
    local m = self.mdtIndicator
    wipe(m.requiredCounts)
    local pull = m.pulls and m.pulls[m.currentPullIndex]
    if type(pull) ~= "table" or type(m.dungeonEnemies) ~= "table" then return end

    for enemyIdx, clones in pairs(pull) do
        if type(enemyIdx) == "number" and type(clones) == "table" then
            local enemy = m.dungeonEnemies[enemyIdx]
            local npcId = enemy and (enemy.id or enemy.npcID or enemy.npcId or enemy.creatureId)
            npcId = tonumber(npcId)
            if npcId then
                local count = 0
                for _ in pairs(clones) do count = count + 1 end
                if count > 0 then
                    m.requiredCounts[npcId] = (m.requiredCounts[npcId] or 0) + count
                end
            end
        end
    end
end

-- Choose which nameplates to highlight: prefer engaged units first; then fill remaining up to required count per NPC
function KeystonePolaris:ComputeSelectedUnits()
    local m = self.mdtIndicator
    wipe(m.selectedUnits)
    if not (m.requiredCounts and next(m.requiredCounts)) then return end

    local perNpcSelected = {}

    -- First pass: engaged units
    for i = 1, 40 do
        local unit = "nameplate" .. i
        if UnitExists(unit) and C_NamePlate.GetNamePlateForUnit(unit) and isUnitHostile(unit) then
            local npcId = getNpcIdFromUnit(unit)
            if npcId and m.requiredCounts[npcId] then
                local selected = perNpcSelected[npcId] or 0
                if UnitAffectingCombat(unit) and selected < m.requiredCounts[npcId] then
                    m.selectedUnits[unit] = true
                    perNpcSelected[npcId] = selected + 1
                end
            end
        end
    end

    -- Second pass: fill remaining with any remaining visible units (nearest preference can be added later)
    for i = 1, 40 do
        local unit = "nameplate" .. i
        if UnitExists(unit) and C_NamePlate.GetNamePlateForUnit(unit) and isUnitHostile(unit) and not m.selectedUnits[unit] then
            local npcId = getNpcIdFromUnit(unit)
            if npcId and m.requiredCounts[npcId] then
                local selected = perNpcSelected[npcId] or 0
                if selected < m.requiredCounts[npcId] then
                    m.selectedUnits[unit] = true
                    perNpcSelected[npcId] = selected + 1
                end
            end
        end
    end
end

-- ===============================
-- Auto-advance logic
-- ===============================
function KeystonePolaris:TryAutoAdvancePull()
    local db = self.db.profile.mobIndicator
    local m = self.mdtIndicator
    if not (db.autoAdvance and m.pulls and m.maxPulls and m.maxPulls > 0) then return end
    if m.currentPullIndex >= m.maxPulls then return end

    local MDT = _G.MDT
    if not MDT or not MDT.CountForces then return end

    -- Helpers mirroring the WeakAura
    local function getSteps()
        local _, _, numSteps = C_Scenario.GetStepInfo()
        return numSteps or 0
    end
    local function isDungeonFinished()
        return getSteps() < 1
    end
    local function isMythicPlus()
        local difficulty = select(3, GetInstanceInfo()) or -1
        return (difficulty == 8 and not isDungeonFinished())
    end
    local function getProgressInfo()
        if isMythicPlus() then
            local numSteps = getSteps()
            if numSteps > 0 and C_ScenarioInfo and C_ScenarioInfo.GetCriteriaInfo then
                local info = C_ScenarioInfo.GetCriteriaInfo(numSteps)
                if info and info.isWeightedProgress then return info end
            end
        end
    end
    local function getMaxQuantity()
        local info = getProgressInfo()
        return info and info.totalQuantity or nil
    end
    local function getForcePercentForEnemyCount(quantity)
        local maxQ = getMaxQuantity()
        if not maxQ or maxQ == 0 then return 100 end
        local q = tonumber(quantity) or 0
        return (q / maxQ) * 100
    end
    local function getEnemyForcesProgress()
        local info = getProgressInfo()
        if info and info.quantityString then
            local value = string.gsub(info.quantityString, "%%", "")
            return tonumber(value) or 0
        end
        return 0
    end

    local currentPull = m.currentPullIndex
    local stepSize = getForcePercentForEnemyCount(MDT:CountForces(currentPull))
    local currentProg = getEnemyForcesProgress()
    local left = (stepSize or 0) - (currentProg or 0)

    if left <= 0 then
        m.currentPullIndex = m.currentPullIndex + 1
        -- Rebuild sets with new index and recompute selection
        self:RebuildIndicatorTargetSet()
        self:ComputeSelectedUnits()
    end
end

-- ===============================
-- Ticker tick
-- ===============================
function KeystonePolaris:OnMobIndicatorTick()
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
    -- Compute selected nameplates for current pull (engaged first)
    self:ComputeSelectedUnits()
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
function KeystonePolaris:InitializeMobIndicator()
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
            self:ComputeSelectedUnits()
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
    self:ComputeSelectedUnits()
    self:UpdateAllNameplateMarkers()

    if C_ChallengeMode.IsChallengeModeActive() then
        startMobIndicatorTicker(self)
    else
        stopMobIndicatorTicker(self)
    end
end

-- ===============================
-- AceConfig Options Group
-- ===============================
function KeystonePolaris:GetMobIndicatorOptions()
    return {
        name = L["MOB_INDICATOR"],
        type = "group",
        order = 5,
        args = {
            intro = {
                name = function()
                    self:CheckForMDTForIndicators()
                    return self.mdtIndicator.loaded and L["MDT_FOUND"] or L["MDT_WARNING"]
                end,
                type = "description",
                order = 0,
                fontSize = "medium",
            },
            mobIndicatorHeader = {
                name = L["MOB_INDICATOR"],
                type = "header",
                order = 1,
            },
            enable = {
                name = L["ENABLE"],
                desc = L["ENABLE_MOB_INDICATORS_DESC"],
                type = "toggle",
                width = "full",
                order = 2,
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
                end,
                disabled = function()
                    self:CheckForMDTForIndicators()
                    return not self.mdtIndicator.loaded
                end
            },
            appearance = {
                name = L["APPEARANCE_OPTIONS"],
                type = "group",
                inline = true,
                order = 3,
                disabled = function()
                    self:CheckForMDTForIndicators()
                    return not self.mdtIndicator.loaded
                end,
                args = {
                    textureHeader = {
                        type = "header",
                        name = L["MOB_INDICATOR_TEXTURE_HEADER"],
                        order = 0,
                    },
                    texture = {
                        name = L["MOB_INDICATOR_TEXTURE"],
                        type = "input",
                        order = 1,
                        width = 1.5,
                        get = function() return tostring(self.db.profile.mobIndicator.texture or 450928) end,
                        set = function(_, v)
                            local id = tonumber(v)
                            if id then
                                self.db.profile.mobIndicator.texture = id
                            elseif type(v) == "string" and v ~= "" then
                                -- Accept texture path strings or atlas names
                                self.db.profile.mobIndicator.texture = v
                            else
                                return
                            end
                            for unit, _ in pairs(self.nameplateMarkerFrames) do
                                self:UpdateNameplateMarker(unit)
                            end
                            local ACR = LibStub and LibStub("AceConfigRegistry-3.0", true)
                            if ACR then ACR:NotifyChange(AddOnName) end
                        end,
                    },
                    texturePreview = {
                        name = " ",
                        type = "description",
                        order = 1.4,
                        width = 0.3,
                        image = function()
                            local tex = self.db.profile.mobIndicator.texture
                            if type(tex) == "string" and C_Texture and C_Texture.GetAtlasInfo then
                                local info = C_Texture.GetAtlasInfo(tex)
                                if info and info.file then
                                    return info.file
                                end
                            end
                            return tex
                        end,
                        imageCoords = function()
                            local tex = self.db.profile.mobIndicator.texture
                            if type(tex) == "string" and C_Texture and C_Texture.GetAtlasInfo then
                                local info = C_Texture.GetAtlasInfo(tex)
                                if info then
                                    return { info.leftTexCoord, info.rightTexCoord, info.topTexCoord, info.bottomTexCoord }
                                end
                            end
                            -- no coords for plain textures/ids
                            return nil
                        end,
                        imageWidth = 24,
                        imageHeight = 24,
                        disabled = function()
                            self:CheckForMDTForIndicators()
                            return not self.mdtIndicator.loaded
                        end,
                    },
                    resetTexture = {
                        name = L["RESET_TO_DEFAULT"],
                        type = "execute",
                        order = 1.5,
                        width = 0.6,
                        func = function()
                            local def = (KeystonePolaris.defaults and KeystonePolaris.defaults.profile and KeystonePolaris.defaults.profile.mobIndicator and KeystonePolaris.defaults.profile.mobIndicator.texture) or 450928
                            self.db.profile.mobIndicator.texture = def
                            for _, frame in pairs(self.nameplateMarkerFrames) do
                                if frame and frame.tex then
                                    applyMarkerTexture(frame, def)
                                end
                            end
                            local ACR = LibStub and LibStub("AceConfigRegistry-3.0", true)
                            if ACR then ACR:NotifyChange(AddOnName) end
                        end,
                    },
                    size = {
                        name = L["MOB_INDICATOR_TEXTURE_SIZE"],
                        desc = L["MOB_INDICATOR_TEXTURE_SIZE_DESC"],
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
                    coloringHeader = {
                        type = "header",
                        name = L["MOB_INDICATOR_COLORING_HEADER"],
                        order = 2.5,
                    },
                    --[[ _newlineAfterSize = {
                        type = "description",
                        name = " ",
                        order = 2.9,
                        width = "full",
                    }, ]]
                    tintEnabled = {
                        name = L["MOB_INDICATOR_TINT"],
                        desc = L["MOB_INDICATOR_TINT_DESC"],
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
                        name = L["MOB_INDICATOR_TINT_COLOR"],
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
                        disabled = function()
                            self:CheckForMDTForIndicators()
                            return (not self.mdtIndicator.loaded) or (not self.db.profile.mobIndicator.tintEnabled)
                        end
                    },
                    positionHeader = {
                        type = "header",
                        name = L["MOB_INDICATOR_POSITION_HEADER"],
                        order = 4.5,
                    },
                    --[[ _newlineAfterPositionHeader = {
                        type = "description",
                        name = " ",
                        order = 5.9,
                        width = "full",
                    }, ]]
                    position = {
                        name = L["POSITION"],
                        desc = L["POSITION"],
                        type = "select",
                        order = 5,
                        width = 0.8,
                        values = {
                            RIGHT = L["RIGHT"],
                            LEFT  = L["LEFT"],
                            TOP   = L["TOP"],
                            BOTTOM= L["BOTTOM"]
                        },
                        get = function() return self.db.profile.mobIndicator.position end,
                        set = function(_, v)
                            self.db.profile.mobIndicator.position = v
                            for unit, _ in pairs(self.nameplateMarkerFrames) do
                                self:UpdateMarkerPosition(unit)
                            end
                        end
                    },
                    --[[ _newlineAfterPosition = {
                        type = "description",
                        name = " ",
                        order = 5.9,
                        width = "full",
                    }, ]]
                    xOffset = {
                        name = L["X_OFFSET"],
                        desc = L["X_OFFSET_DESC"],
                        type = "range",
                        order = 6,
                        width = 0.8,
                        min = -500, max = 500, step = 1,
                        get = function() return self.db.profile.mobIndicator.xOffset end,
                        set = function(_, v)
                            self.db.profile.mobIndicator.xOffset = v
                            for unit, _ in pairs(self.nameplateMarkerFrames) do
                                self:UpdateMarkerPosition(unit)
                            end
                        end
                    },
                    yOffset = {
                        name = L["Y_OFFSET"],
                        desc = L["Y_OFFSET_DESC"],
                        type = "range",
                        order = 7,
                        width = 0.8,
                        min = -500, max = 500, step = 1,
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
                name = L["MOB_INDICATOR_BEHAVIOR"],
                type = "group",
                inline = true,
                order = 4,
                disabled = function()
                    self:CheckForMDTForIndicators()
                    return not self.mdtIndicator.loaded
                end,
                args = {
                    autoAdvance = {
                        name = L["MOB_INDICATOR_AUTO_ADVANCE"],
                        desc = L["MOB_INDICATOR_AUTO_ADVANCE_DESC"],
                        type = "toggle",
                        order = 1,
                        get = function() return self.db.profile.mobIndicator.autoAdvance end,
                        set = function(_, v) self.db.profile.mobIndicator.autoAdvance = v end
                    },
                }
            }
        }
    }
end