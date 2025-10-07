local AddOnName, KeystonePolaris = ...
local _G = _G
local pairs, select, strsplit, format = pairs, select, strsplit, string.format

-- Get localization table
local L = KeystonePolaris.L

-- Quiet MDT presence check for UI gating (no prints, no side-effects)
local function IsMDTAvailable()
    local loaded = false
    if C_AddOns and C_AddOns.IsAddOnLoaded then
        loaded = C_AddOns.IsAddOnLoaded("MythicDungeonTools")
    elseif IsAddOnLoaded then
        loaded = IsAddOnLoaded("MythicDungeonTools")
    end
    if not loaded then
        loaded = (_G.MDT ~= nil)
    end
    return not not loaded
end

-- Initialize the mob percentages module
function KeystonePolaris:InitializeMobPercentages()
    -- Create a frame for nameplate hooks
    self.mobPercentFrame = CreateFrame("Frame")

    -- Register events
    self.mobPercentFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    self.mobPercentFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    self.mobPercentFrame:RegisterEvent("CHALLENGE_MODE_START")
    self.mobPercentFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

    -- Set up event handler
    self.mobPercentFrame:SetScript("OnEvent", function(_, event, ...)
        if event == "NAME_PLATE_UNIT_ADDED" then
            local unit = ...
            self:UpdateNameplate(unit)
        elseif event == "NAME_PLATE_UNIT_REMOVED" then
            local unit = ...
            self:RemoveNameplate(unit)
        elseif event == "CHALLENGE_MODE_START" or event == "PLAYER_ENTERING_WORLD" then
            self:CheckForMDT()
            -- Update all existing nameplates
            self:UpdateAllNameplates()
        end
    end)

    -- Create a cache for nameplate text frames
    self.nameplateTextFrames = {}

    -- Check if MDT is available
    self:CheckForMDT()

    -- Update all existing nameplates
    self:UpdateAllNameplates()
end

-- Update all existing nameplates
function KeystonePolaris:UpdateAllNameplates()
    -- Only proceed if the feature is enabled
    if not self.db.profile.mobPercentages.enabled then return end

    -- Get all visible nameplates
    for i = 1, 40 do
        local unit = "nameplate" .. i
        if UnitExists(unit) then
            self:UpdateNameplate(unit)
        end
    end
end

-- Update a nameplate with percentage text
function KeystonePolaris:UpdateNameplate(unit)
    -- Only process hostile nameplates in Mythic+ dungeons
    if not C_ChallengeMode.IsChallengeModeActive() then
        return
    end

    if UnitReaction(unit, "player") and UnitReaction(unit, "player") > 4 then
        return
    end

    -- Get the NPC ID from the GUID
    local guid = UnitGUID(unit)
    if not guid then
        return
    end

    local _, _, _, _, _, npcID = strsplit("-", guid)
    if not npcID then
        return
    end

    -- Check if MDT is loaded
    if not self.mdtLoaded then
        return
    end

    -- Create or get the text frame for this nameplate
    local textFrame = self.nameplateTextFrames[unit]
    if not textFrame then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
        if not nameplate then
            return
        end

        -- Create the frame parented to UIParent (not the nameplate) to avoid clipping/occlusion when plates stack
        textFrame = CreateFrame("Frame", "KPL_PercentFrame_"..unit, UIParent)
        textFrame:SetSize(80, 30) -- Larger size to ensure visibility
        textFrame:SetFrameStrata("MEDIUM") -- Use high strata to be above stacked nameplates
        textFrame:SetIgnoreParentAlpha(true) -- Prevent parent alpha fading from hiding the text

        textFrame.text = textFrame:CreateFontString(nil, "OVERLAY")
        textFrame.text:SetPoint("CENTER")
        textFrame.text:SetFont(self.LSM:Fetch('font', self.db.profile.text.font),
            self.db.profile.mobPercentages.fontSize or 8, "OUTLINE")
        textFrame.text:SetTextColor(self.db.profile.mobPercentages.textColor.r or 1, self.db.profile.mobPercentages.textColor.g or 1, self.db.profile.mobPercentages.textColor.b or 1, self.db.profile.mobPercentages.textColor.a or 1)

        self.nameplateTextFrames[unit] = textFrame
    end

    -- Always update position to ensure visibility
    self:UpdateNameplatePosition(unit)

    -- Get MDT data
    local DungeonTools = MDT or MethodDungeonTools
    if not DungeonTools or not DungeonTools.GetEnemyForces then
        textFrame:Hide()
        return
    end

    -- Get enemy forces data from MDT
    local isTeeming = self:IsTeeming()
    local count, max, maxTeeming, teemingCount = DungeonTools:GetEnemyForces(tonumber(npcID))

    -- Use teeming count if applicable
    if (teemingCount and isTeeming) or not count then
        count = teemingCount
    end

    -- Calculate percentage
    local weight
    if count and ((isTeeming and maxTeeming) or (not isTeeming and max)) then
        if isTeeming then
            weight = count / maxTeeming
        else
            weight = count / max
        end
        weight = weight * 100
    end

    -- Update text based on user preferences
    if weight and weight > 0 then
        -- Percent only string (for explicit placeholder usage)
        local percentOnly = ""
        if self.db.profile.mobPercentages.showPercent then
            percentOnly = format("%.2f%%", weight)
        end

        -- Backward-compatible combined string (percent + count[/max])
        local combinedText = percentOnly
        if self.db.profile.mobPercentages.showCount and count then
            if combinedText ~= "" then
                combinedText = combinedText .. " | "
            end
            combinedText = combinedText .. count

            if self.db.profile.mobPercentages.showTotal then
                if isTeeming then
                    combinedText = combinedText .. "/" .. (maxTeeming or "")
                else
                    combinedText = combinedText .. "/" .. (max or "")
                end
            end
        end

        -- Build replacement values for new placeholders
        local countStr = ""
        if self.db.profile.mobPercentages.showCount and count then
            countStr = tostring(count)
        end

        local maxStr = ""
        -- Only show total when both Show Count and Show Total are enabled (consistent with combined text behavior)
        if self.db.profile.mobPercentages.showCount and self.db.profile.mobPercentages.showTotal then
            if isTeeming and maxTeeming then
                maxStr = tostring(maxTeeming)
            elseif max then
                maxStr = tostring(max)
            end
        end

        -- Determine which base text to feed into %s
        local fmt = self.db.profile.mobPercentages.customFormat or "(%s)"

        -- Choose base content for %s depending on whether explicit placeholders are present
        local hasExplicitPlaceholders = (
            fmt:find("%c", 1, true) ~= nil or fmt:find("%t", 1, true) ~= nil
        )
        local base = hasExplicitPlaceholders and percentOnly or combinedText

        -- Protect literal %% so we can restore them later
        local PCT = "\1PCT\2"
        fmt = fmt:gsub("%%%%", PCT)

        -- Substitute placeholders
        -- % tokens
        fmt = fmt:gsub("%%c", countStr):gsub("%%t", maxStr)
        -- Percent text
        fmt = fmt:gsub("%%s", function() return base end)
        -- Restore literal percent signs
        fmt = fmt:gsub(PCT, function() return "%" end)

        -- Cleanup formatting and ensure non-empty fallback
        fmt = self:CleanupMobPercentFormat(fmt)
        if fmt == "" then
            if percentOnly ~= "" then
                fmt = "(" .. percentOnly .. ")"
            else
                textFrame:Hide()
                return
            end
        end

        -- Update and show the text
        textFrame.text:SetText(fmt)
        textFrame:Show()
    else
        textFrame:Hide()
    end
end

-- Helper: cleanup orphan separators/spaces in formatted mob percentage text
function KeystonePolaris:CleanupMobPercentFormat(s)
    if not s or s == "" then return "" end

    -- Remove combos like " - /", " | /" or "/ |"
    s = s:gsub("%s*[|/%-]%s*/%s*", " ")
    s = s:gsub("%s*/%s*[|/%-]%s*", " ")

    -- Trim leading/trailing pipes, slashes or hyphens with optional spaces
    s = s:gsub("^%s*[|/%-]%s*", "")
    s = s:gsub("%s*[|/%-]%s*$", "")

    -- Remove trailing or leading lone slash or hyphen
    s = s:gsub("%s*[/-]%s*$", "")
    s = s:gsub("^%s*[/-]%s*", "")

    -- Collapse multiple spaces and trim
    s = s:gsub("%s+", " ")
    s = s:gsub("^%s+", ""):gsub("%s+$", "")

    -- Final pass: remove separators adjacent to parentheses
    s = s:gsub("%s*[|/%-]%s*%)", ")") -- remove trailing sep before )
    s = s:gsub("%(%s*[|/%-]%s*", "(") -- remove leading sep after (
    s = s:gsub("%s+%)", ")") -- remove space before )

    return s
end

-- Remove nameplate text when nameplate is removed
function KeystonePolaris:RemoveNameplate(unit)
    local textFrame = self.nameplateTextFrames[unit]
    if textFrame then
        textFrame:Hide()
        self.nameplateTextFrames[unit] = nil
    end
end

-- Get options for mob percentages display
function KeystonePolaris:GetMobPercentagesOptions()
    return {
        name = L["MOB_PERCENTAGES"],
        type = "group",
        order = 4,
        args = {
            mdtWarning = {
                name = function()
                    return IsMDTAvailable() and L["MDT_FOUND"] or L["MDT_WARNING"]
                end,
                type = "description",
                order = 0,
                fontSize = "medium",
            },
            mobIndicatorHeader = {
                name = L["MOB_PERCENTAGES"],
                type = "header",
                order = 1,
            },
            enable = {
                name = L["ENABLE"],
                desc = L["ENABLE_MOB_PERCENTAGES_DESC"],
                type = "toggle",
                width = "full",
                order = 2,
                get = function() return self.db.profile.mobPercentages.enabled end,
                set = function(_, value)
                    self.db.profile.mobPercentages.enabled = value
                    if value then
                        self:InitializeMobPercentages()
                    else
                        -- Disable the feature
                        if self.mobPercentFrame then
                            self.mobPercentFrame:UnregisterAllEvents()
                        end
                        -- Hide all existing nameplate texts
                        for unit, frame in pairs(self.nameplateTextFrames) do
                            frame:Hide()
                        end
                        wipe(self.nameplateTextFrames)
                    end
                end,
                disabled = function()
                    return not IsMDTAvailable()
                end
            },
            displayOptions = {
                name = L["DISPLAY_OPTIONS"],
                type = "group",
                inline = true,
                order = 3,
                disabled = function()
                    return not IsMDTAvailable()
                end,
                args = {
                    showPercent = {
                        name = L["SHOW_PERCENTAGE"],
                        desc = L["SHOW_PERCENTAGE_DESC"],
                        type = "toggle",
                        order = 1,
                        width = "full",
                        get = function() return self.db.profile.mobPercentages.showPercent end,
                        set = function(_, value)
                            self.db.profile.mobPercentages.showPercent = value
                            -- Update all nameplates
                            for unit, _ in pairs(self.nameplateTextFrames) do
                                self:UpdateNameplate(unit)
                            end
                        end,
                        disabled = function()
                            return (not self.db.profile.mobPercentages.enabled) or (not IsMDTAvailable())
                        end
                    },
                    showCount = {
                        name = L["SHOW_COUNT"],
                        desc = L["SHOW_COUNT_DESC"],
                        type = "toggle",
                        order = 2,
                        width = "full",
                        get = function() return self.db.profile.mobPercentages.showCount end,
                        set = function(_, value)
                            self.db.profile.mobPercentages.showCount = value
                            -- Update all nameplates
                            for unit, _ in pairs(self.nameplateTextFrames) do
                                self:UpdateNameplate(unit)
                            end
                        end,
                        disabled = function()
                            return (not self.db.profile.mobPercentages.enabled) or (not IsMDTAvailable())
                        end
                    },
                    showTotal = {
                        name = L["SHOW_TOTAL"],
                        desc = L["SHOW_TOTAL_DESC"],
                        type = "toggle",
                        order = 3,
                        width = "full",
                        get = function() return self.db.profile.mobPercentages.showTotal end,
                        set = function(_, value)
                            self.db.profile.mobPercentages.showTotal = value
                            -- Update all nameplates
                            for unit, _ in pairs(self.nameplateTextFrames) do
                                self:UpdateNameplate(unit)
                            end
                        end,
                        disabled = function()
                            return (not self.db.profile.mobPercentages.enabled) or (not self.db.profile.mobPercentages.showCount) or (not IsMDTAvailable())
                        end
                    },
                    customFormat = {
                        name = L["CUSTOM_FORMAT"],
                        desc = L["CUSTOM_FORMAT_DESC"],
                        type = "input",
                        order = 4,
                        width = 1.5, -- Réduit la largeur pour faire de la place au bouton
                        get = function()
                            local v = self.db.profile.mobPercentages.customFormat
                            if not v or v == "" then return "(%s)" end
                            return v
                        end,
                        set = function(_, value)
                            local v = (value or ""):gsub("^%s+", ""):gsub("%s+$", "")
                            if v == "" then v = "(%s)" end
                            self.db.profile.mobPercentages.customFormat = v
                            -- Update all nameplates
                            for unit, _ in pairs(self.nameplateTextFrames) do
                                self:UpdateNameplate(unit)
                            end
                        end,
                        disabled = function()
                            return (not self.db.profile.mobPercentages.enabled) or (not IsMDTAvailable())
                        end
                    },
                    resetCustomFormat = {
                        name = L["RESET_TO_DEFAULT"],
                        desc = L["RESET_FORMAT_DESC"],
                        type = "execute",
                        order = 5,
                        width = 0.5, -- Bouton plus petit
                        func = function()
                            self.db.profile.mobPercentages.customFormat = "(%s)" -- Valeur par défaut
                            -- Update all nameplates
                            for unit, _ in pairs(self.nameplateTextFrames) do
                                self:UpdateNameplate(unit)
                            end
                        end,
                        disabled = function()
                            return (not self.db.profile.mobPercentages.enabled) or (not IsMDTAvailable())
                        end
                    },
                }
            },
            appearanceOptions = {
                name = L["APPEARANCE_OPTIONS"],
                type = "group",
                inline = true,
                order = 4,
                disabled = function()
                    return not IsMDTAvailable()
                end,
                args = {
                    fontSize = {
                        name = L["MOB_PERCENTAGE_FONT_SIZE"],
                        desc = L["MOB_PERCENTAGE_FONT_SIZE_DESC"],
                        type = "range",
                        order = 1,
                        min = 6,
                        max = 32,
                        step = 1,
                        get = function() return self.db.profile.mobPercentages.fontSize end,
                        set = function(_, value)
                            self.db.profile.mobPercentages.fontSize = value
                            -- Update all existing nameplate texts
                            for unit, frame in pairs(self.nameplateTextFrames) do
                                frame.text:SetFont(self.LSM:Fetch('font', self.db.profile.text.font), value, "OUTLINE")
                            end
                        end,
                        disabled = function()
                            return (not self.db.profile.mobPercentages.enabled) or (not IsMDTAvailable())
                        end
                    },
                    textColor = {
                        name = L["TEXT_COLOR"],
                        desc = L["TEXT_COLOR_DESC"],
                        type = "color",
                        order = 2,
                        hasAlpha = true,
                        get = function() return self.db.profile.mobPercentages.textColor.r, self.db.profile.mobPercentages.textColor.g, self.db.profile.mobPercentages.textColor.b, self.db.profile.mobPercentages.textColor.a end,
                        set = function(_, r, g, b, a)
                            self.db.profile.mobPercentages.textColor = {r = r, g = g, b = b, a = a}
                            -- Update all existing nameplate texts
                            for unit, frame in pairs(self.nameplateTextFrames) do
                                frame.text:SetTextColor(r, g, b, a)
                            end
                        end,
                        disabled = function()
                            return (not self.db.profile.mobPercentages.enabled) or (not IsMDTAvailable())
                        end
                    },
                    position = {
                        name = L["MOB_PERCENTAGE_POSITION"],
                        desc = L["MOB_PERCENTAGE_POSITION_DESC"],
                        type = "select",
                        order = 4,
                        values = {
                            RIGHT = L["RIGHT"],
                            LEFT = L["LEFT"],
                            TOP = L["TOP"],
                            BOTTOM = L["BOTTOM"]
                        },
                        get = function() return self.db.profile.mobPercentages.position end,
                        set = function(_, value)
                            self.db.profile.mobPercentages.position = value
                            -- Update all existing nameplate texts
                            for unit, frame in pairs(self.nameplateTextFrames) do
                                self:UpdateNameplatePosition(unit)
                            end
                        end,
                        disabled = function()
                            return (not self.db.profile.mobPercentages.enabled) or (not IsMDTAvailable())
                        end
                    },
                    xOffset = {
                        name = L["X_OFFSET"],
                        desc = L["X_OFFSET_DESC"],
                        type = "range",
                        order = 5,
                        min = -100,
                        max = 100,
                        step = 1,
                        get = function() return self.db.profile.mobPercentages.xOffset end,
                        set = function(_, value)
                            self.db.profile.mobPercentages.xOffset = value
                            -- Update all existing nameplate texts
                            for unit, frame in pairs(self.nameplateTextFrames) do
                                self:UpdateNameplatePosition(unit)
                            end
                        end,
                        disabled = function()
                            return (not self.db.profile.mobPercentages.enabled) or (not IsMDTAvailable())
                        end
                    },
                    yOffset = {
                        name = L["Y_OFFSET"],
                        desc = L["Y_OFFSET_DESC"],
                        type = "range",
                        order = 6,
                        min = -100,
                        max = 100,
                        step = 1,
                        get = function() return self.db.profile.mobPercentages.yOffset end,
                        set = function(_, value)
                            self.db.profile.mobPercentages.yOffset = value
                            -- Update all existing nameplate texts
                            for unit, frame in pairs(self.nameplateTextFrames) do
                                self:UpdateNameplatePosition(unit)
                            end
                        end,
                        disabled = function()
                            return (not self.db.profile.mobPercentages.enabled) or (not IsMDTAvailable())
                        end
                    },
                }
            }
        }
    }
end

-- Update the position of a nameplate text frame
function KeystonePolaris:UpdateNameplatePosition(unit)
    local frame = self.nameplateTextFrames[unit]
    if not frame then return end

    local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
    if not nameplate then return end

    local position = self.db.profile.mobPercentages.position or "RIGHT"
    local xOffset = self.db.profile.mobPercentages.xOffset or 0
    local yOffset = self.db.profile.mobPercentages.yOffset or 0

    -- Adjust text alignment based on position
    frame.text:ClearAllPoints()
    if position == "RIGHT" then
        -- If position is RIGHT, align text to LEFT (closer to nameplate)
        frame.text:SetPoint("LEFT", frame, "LEFT")
    elseif position == "LEFT" then
        -- If position is LEFT, align text to RIGHT (closer to nameplate)
        frame.text:SetPoint("RIGHT", frame, "RIGHT")
    else
        -- For other positions (TOP, BOTTOM, etc.), center the text
        frame.text:SetPoint("CENTER", frame, "CENTER")
    end

    frame:ClearAllPoints()

    -- Use more precise anchor points to avoid overlap with nameplate text
    if position == "RIGHT" then
        -- Anchor to the right edge of the nameplate
        frame:SetPoint("LEFT", nameplate, "RIGHT", xOffset, yOffset)
    elseif position == "LEFT" then
        -- Anchor to the left edge of the nameplate
        frame:SetPoint("RIGHT", nameplate, "LEFT", xOffset, yOffset)
    elseif position == "TOP" then
        -- Anchor to the top edge of the nameplate
        frame:SetPoint("BOTTOM", nameplate, "TOP", xOffset, yOffset)
    elseif position == "BOTTOM" then
        -- Anchor to the bottom edge of the nameplate
        frame:SetPoint("TOP", nameplate, "BOTTOM", xOffset, yOffset)
    else
        -- For other positions, use the original method
        frame:SetPoint(position, nameplate, position, xOffset, yOffset)
    end
end

-- Check if Mythic Dungeon Tools is loaded and available
function KeystonePolaris:CheckForMDT()
    -- Clear any existing nameplate texts when checking
    for unit, frame in pairs(self.nameplateTextFrames) do
        frame:Hide()
        self.nameplateTextFrames[unit] = nil
    end

    -- Check if MDT is loaded
    self.mdtLoaded = false

    local loaded = C_AddOns.IsAddOnLoaded("MythicDungeonTools")
    if loaded then
        self.mdtLoaded = true
    end
end

-- Check if the current affix is Teeming
function KeystonePolaris:IsTeeming()
    local _, affixes = C_ChallengeMode.GetActiveKeystoneInfo()
    if not affixes then return false end

    for _, affixID in ipairs(affixes) do
        if affixID == 5 then -- 5 is the Teeming affix ID
            return true
        end
    end
    return false
end

-- Add default settings for mob percentages
KeystonePolaris.defaults.profile.mobPercentages = {
    enabled = false,
    fontSize = 8,
    textColor = { r = 1, g = 1, b = 1, a = 1 },
    position = "RIGHT",
    showPercent = true,
    showCount = false,
    showTotal = false,
    xOffset = 0,
    yOffset = 0,
    customFormat = "(%s)" -- %s sera remplacé par le pourcentage
}
