local AddOnName, KeystonePercentageHelper = ...
local _G = _G
local pairs, select, strsplit, format = pairs, select, strsplit, string.format

-- Get localization table
local L = KeystonePercentageHelper.L

-- Initialize the mob percentages module
function KeystonePercentageHelper:InitializeMobPercentages()
    -- Create a frame for nameplate hooks
    self.mobPercentFrame = CreateFrame("Frame")
    
    -- Register events
    self.mobPercentFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    self.mobPercentFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    self.mobPercentFrame:RegisterEvent("CHALLENGE_MODE_START")
    self.mobPercentFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.mobPercentFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    self.mobPercentFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
    
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
        elseif event == "PLAYER_TARGET_CHANGED" then
            self:UpdateTargetPercentage()
        elseif event == "UPDATE_MOUSEOVER_UNIT" then
            self:UpdateMouseoverPercentage()
        end
    end)
    
    -- Create a cache for nameplate text frames
    self.nameplateTextFrames = {}
    
    -- Create frames for target and mouseover
    self:CreateTargetFrame()
    self:CreateMouseoverFrame()
    
    -- Check if MDT is available
    self:CheckForMDT()
    
    -- Update all existing nameplates
    self:UpdateAllNameplates()
end

-- Update all existing nameplates
function KeystonePercentageHelper:UpdateAllNameplates()
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

-- Create a frame for showing percentage on target
function KeystonePercentageHelper:CreateTargetFrame()
    if not self.targetPercentFrame then
        self.targetPercentFrame = CreateFrame("Frame", nil, UIParent)
        self.targetPercentFrame:SetSize(100, 20)
        self.targetPercentFrame:SetPoint("BOTTOM", TargetFrame, "TOP", 0, 5)
        
        self.targetPercentFrame.text = self.targetPercentFrame:CreateFontString(nil, "OVERLAY")
        self.targetPercentFrame.text:SetPoint("CENTER")
        self.targetPercentFrame.text:SetFont(self.LSM:Fetch('font', self.db.profile.text.font), 
            self.db.profile.mobPercentages.fontSize or 8, "OUTLINE")
        
        self.targetPercentFrame:Hide()
    end
end

-- Create a frame for showing percentage on mouseover
function KeystonePercentageHelper:CreateMouseoverFrame()
    if not self.mouseoverPercentFrame then
        self.mouseoverPercentFrame = CreateFrame("Frame", nil, UIParent)
        self.mouseoverPercentFrame:SetSize(100, 20)
        self.mouseoverPercentFrame:SetPoint("BOTTOMLEFT", GameTooltip, "TOPLEFT", 0, 5)
        
        self.mouseoverPercentFrame.text = self.mouseoverPercentFrame:CreateFontString(nil, "OVERLAY")
        self.mouseoverPercentFrame.text:SetPoint("LEFT")
        self.mouseoverPercentFrame.text:SetFont(self.LSM:Fetch('font', self.db.profile.text.font), 
            self.db.profile.mobPercentages.fontSize or 8, "OUTLINE")
        
        self.mouseoverPercentFrame:Hide()
    end
end

-- Update percentage display for current target
function KeystonePercentageHelper:UpdateTargetPercentage()
    if not self.mdtLoaded or not self.targetPercentFrame then return end
    if not C_ChallengeMode.IsChallengeModeActive() then 
        self.targetPercentFrame:Hide()
        return 
    end
    
    -- Only show for hostile targets
    if not UnitExists("target") or (UnitReaction("target", "player") and UnitReaction("target", "player") > 4) then
        self.targetPercentFrame:Hide()
        return
    end
    
    -- Get the NPC ID from the GUID
    local guid = UnitGUID("target")
    if not guid then 
        self.targetPercentFrame:Hide()
        return 
    end
    
    local _, _, _, _, _, npcID = strsplit("-", guid)
    if not npcID then 
        self.targetPercentFrame:Hide()
        return 
    end
    
    -- Get MDT data
    local DungeonTools = MDT or MethodDungeonTools
    if not DungeonTools or not DungeonTools.GetEnemyForces then
        self.targetPercentFrame:Hide()
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
        local percentText = ""
        
        -- Show percentage
        if self.db.profile.mobPercentages.showPercent then
            percentText = format("%.2f%%", weight)
        end
        
        -- Show count if enabled
        if self.db.profile.mobPercentages.showCount then
            if percentText ~= "" then
                percentText = percentText .. " | "
            end
            percentText = percentText .. count
            
            -- Show total if enabled
            if self.db.profile.mobPercentages.showTotal then
                if isTeeming then
                    percentText = percentText .. "/" .. maxTeeming
                else
                    percentText = percentText .. "/" .. max
                end
            end
        end
        
        -- Format text according to user preference
        local formattedText = format(self.db.profile.mobPercentages.customFormat, percentText)
        
        -- Update and show the text
        self.targetPercentFrame.text:SetText(formattedText)
        self.targetPercentFrame:Show()
    else
        self.targetPercentFrame:Hide()
    end
end

-- Update percentage display for mouseover unit
function KeystonePercentageHelper:UpdateMouseoverPercentage()
    if not self.mdtLoaded or not self.mouseoverPercentFrame then return end
    if not C_ChallengeMode.IsChallengeModeActive() then 
        self.mouseoverPercentFrame:Hide()
        return 
    end
    
    -- Only show for hostile units
    if not UnitExists("mouseover") or (UnitReaction("mouseover", "player") and UnitReaction("mouseover", "player") > 4) then
        self.mouseoverPercentFrame:Hide()
        return
    end
    
    -- Get the NPC ID from the GUID
    local guid = UnitGUID("mouseover")
    if not guid then 
        self.mouseoverPercentFrame:Hide()
        return 
    end
    
    local _, _, _, _, _, npcID = strsplit("-", guid)
    if not npcID then 
        self.mouseoverPercentFrame:Hide()
        return 
    end
    
    -- Get MDT data
    local DungeonTools = MDT or MethodDungeonTools
    if not DungeonTools or not DungeonTools.GetEnemyForces then
        self.mouseoverPercentFrame:Hide()
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
        local percentText = ""
        
        -- Show percentage
        if self.db.profile.mobPercentages.showPercent then
            percentText = format("%.2f%%", weight)
        end
        
        -- Show count if enabled
        if self.db.profile.mobPercentages.showCount then
            if percentText ~= "" then
                percentText = percentText .. " | "
            end
            percentText = percentText .. count
            
            -- Show total if enabled
            if self.db.profile.mobPercentages.showTotal then
                if isTeeming then
                    percentText = percentText .. "/" .. maxTeeming
                else
                    percentText = percentText .. "/" .. max
                end
            end
        end
        
        -- Update position relative to tooltip
        self.mouseoverPercentFrame:ClearAllPoints()
        self.mouseoverPercentFrame:SetPoint("BOTTOMLEFT", GameTooltip, "TOPLEFT", 0, 5)
        
        -- Format text according to user preference
        local formattedText = format(self.db.profile.mobPercentages.customFormat, percentText)
        
        -- Update and show the text
        self.mouseoverPercentFrame.text:SetText(formattedText)
        self.mouseoverPercentFrame:Show()
    else
        self.mouseoverPercentFrame:Hide()
    end
end

-- Update a nameplate with percentage text
function KeystonePercentageHelper:UpdateNameplate(unit)
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
        
        -- Create the frame with a parent to ensure visibility
        textFrame = CreateFrame("Frame", "KPH_PercentFrame_"..unit, nameplate)
        textFrame:SetSize(80, 30) -- Larger size to ensure visibility
        textFrame:SetFrameStrata(self.db.profile.mobPercentages.frameStrata or "HIGH") -- Set higher strata to ensure it's above other elements
        
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
        local percentText = ""
        
        -- Show percentage
        if self.db.profile.mobPercentages.showPercent then
            percentText = format("%.2f%%", weight)
        end
        
        -- Show count if enabled
        if self.db.profile.mobPercentages.showCount then
            if percentText ~= "" then
                percentText = percentText .. " | "
            end
            percentText = percentText .. count
            
            -- Show total if enabled
            if self.db.profile.mobPercentages.showTotal then
                if isTeeming then
                    percentText = percentText .. "/" .. maxTeeming
                else
                    percentText = percentText .. "/" .. max
                end
            end
        end
        
        -- Format text according to user preference
        local formattedText = format(self.db.profile.mobPercentages.customFormat, percentText)
        
        -- Update and show the text
        textFrame.text:SetText(formattedText)
        textFrame:Show()
    else
        textFrame:Hide()
    end
end

-- Remove nameplate text when nameplate is removed
function KeystonePercentageHelper:RemoveNameplate(unit)
    local textFrame = self.nameplateTextFrames[unit]
    if textFrame then
        textFrame:Hide()
        self.nameplateTextFrames[unit] = nil
    end
end

-- Get options for mob percentages display
function KeystonePercentageHelper:GetMobPercentagesOptions()
    return {
        name = L["MOB_PERCENTAGES"],
        type = "group",
        order = 4,
        args = {
            mdtWarning = {
                name = L["MDT_WARNING"],
                type = "description",
                order = 0,
                fontSize = "medium",
            },
            enable = {
                name = L["ENABLE_MOB_PERCENTAGES"],
                desc = L["ENABLE_MOB_PERCENTAGES_DESC"],
                type = "toggle",
                width = "full",
                order = 1,
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
                end
            },
            displayOptions = {
                name = L["DISPLAY_OPTIONS"] or "Display Options",
                type = "group",
                inline = true,
                order = 2,
                args = {
                    showPercent = {
                        name = L["SHOW_PERCENTAGE"] or "Show Percentage",
                        desc = L["SHOW_PERCENTAGE_DESC"] or "Show the percentage value for each mob",
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
                        disabled = function() return not self.db.profile.mobPercentages.enabled end
                    },
                    showCount = {
                        name = L["SHOW_COUNT"] or "Show Count",
                        desc = L["SHOW_COUNT_DESC"] or "Show the count value for each mob",
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
                        disabled = function() return not self.db.profile.mobPercentages.enabled end
                    },
                    showTotal = {
                        name = L["SHOW_TOTAL"] or "Show Total",
                        desc = L["SHOW_TOTAL_DESC"] or "Show the total count needed for 100%",
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
                        disabled = function() return not self.db.profile.mobPercentages.enabled or not self.db.profile.mobPercentages.showCount end
                    },
                    customFormat = {
                        name = L["CUSTOM_FORMAT"] or "Text Format",
                        desc = L["CUSTOM_FORMAT_DESC"] or "Enter a custom format for the text. Use %s to represent the percentage.",
                        type = "input",
                        order = 4,
                        width = 1.5, -- Réduit la largeur pour faire de la place au bouton
                        get = function() return self.db.profile.mobPercentages.customFormat end,
                        set = function(_, value) 
                            self.db.profile.mobPercentages.customFormat = value
                            -- Update all nameplates
                            for unit, _ in pairs(self.nameplateTextFrames) do
                                self:UpdateNameplate(unit)
                            end
                        end,
                        disabled = function() return not self.db.profile.mobPercentages.enabled end
                    },
                    resetCustomFormat = {
                        name = L["RESET_TO_DEFAULT"] or "Reset",
                        desc = L["RESET_FORMAT_DESC"] or "Reset the text format to the default value",
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
                        disabled = function() return not self.db.profile.mobPercentages.enabled end
                    },
                }
            },
            appearanceOptions = {
                name = L["APPEARANCE_OPTIONS"] or "Appearance Options",
                type = "group",
                inline = true,
                order = 3,
                args = {
                    fontSize = {
                        name = L["MOB_PERCENTAGE_FONT_SIZE"] or "Font Size",
                        desc = L["MOB_PERCENTAGE_FONT_SIZE_DESC"] or "Set the font size for mob percentage text",
                        type = "range",
                        order = 1,
                        min = 6,
                        max = 16,
                        step = 1,
                        get = function() return self.db.profile.mobPercentages.fontSize end,
                        set = function(_, value) 
                            self.db.profile.mobPercentages.fontSize = value
                            -- Update all existing nameplate texts
                            for unit, frame in pairs(self.nameplateTextFrames) do
                                frame.text:SetFont(self.LSM:Fetch('font', self.db.profile.text.font), value, "OUTLINE")
                            end
                        end,
                        disabled = function() return not self.db.profile.mobPercentages.enabled end
                    },
                    textColor = {
                        name = L["TEXT_COLOR"] or "Text Color",
                        desc = L["TEXT_COLOR_DESC"] or "Set the color of the mob percentage text",
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
                        disabled = function() return not self.db.profile.mobPercentages.enabled end
                    },
                    frameStrata = {
                        name = L["FRAME_STRATA"] or "Frame Strata",
                        desc = L["FRAME_STRATA_DESC"] or "Set the frame strata for the mob percentage text",
                        type = "select",
                        order = 3,
                        values = {
                            LOW = L["LOW"] or "Low",
                            MEDIUM = L["MEDIUM"] or "Medium",
                            HIGH = L["HIGH"] or "High",
                            DIALOG = L["DIALOG"] or "Dialog",
                            FULLSCREEN = L["FULLSCREEN"] or "Fullscreen",
                            FULLSCREEN_DIALOG = L["FULLSCREEN_DIALOG"] or "Fullscreen Dialog",
                            TOOLTIP = L["TOOLTIP"] or "Tooltip"
                        },
                        get = function() return self.db.profile.mobPercentages.frameStrata end,
                        set = function(_, value) 
                            self.db.profile.mobPercentages.frameStrata = value
                            -- Update all existing nameplate texts
                            for unit, frame in pairs(self.nameplateTextFrames) do
                                frame:SetFrameStrata(value)
                            end
                        end,
                        disabled = function() return not self.db.profile.mobPercentages.enabled end
                    },
                    position = {
                        name = L["MOB_PERCENTAGE_POSITION"] or "Position",
                        desc = L["MOB_PERCENTAGE_POSITION_DESC"] or "Set the position of the percentage text relative to the nameplate",
                        type = "select",
                        order = 4,
                        values = {
                            RIGHT = L["RIGHT"] or "Right",
                            LEFT = L["LEFT"] or "Left",
                            TOP = L["TOP"] or "Top",
                            BOTTOM = L["BOTTOM"] or "Bottom"
                        },
                        get = function() return self.db.profile.mobPercentages.position end,
                        set = function(_, value) 
                            self.db.profile.mobPercentages.position = value
                            -- Update all existing nameplate texts
                            for unit, frame in pairs(self.nameplateTextFrames) do
                                self:UpdateNameplatePosition(unit)
                            end
                        end,
                        disabled = function() return not self.db.profile.mobPercentages.enabled end
                    },
                    xOffset = {
                        name = L["X_OFFSET"] or "X Offset",
                        desc = L["X_OFFSET_DESC"] or "Adjust the horizontal position of the text",
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
                        disabled = function() return not self.db.profile.mobPercentages.enabled end
                    },
                    yOffset = {
                        name = L["Y_OFFSET"] or "Y Offset",
                        desc = L["Y_OFFSET_DESC"] or "Adjust the vertical position of the text",
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
                        disabled = function() return not self.db.profile.mobPercentages.enabled end
                    },
                }
            }
        }
    }
end

-- Update the position of a nameplate text frame
function KeystonePercentageHelper:UpdateNameplatePosition(unit)
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
function KeystonePercentageHelper:CheckForMDT()
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
        self:Print(L["MDT_LOADED"])
    else
        self:Print(L["MDT_NOT_FOUND"])
    end
end

-- Check if the current affix is Teeming
function KeystonePercentageHelper:IsTeeming()
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
KeystonePercentageHelper.defaults.profile.mobPercentages = {
    enabled = false,
    fontSize = 8,
    frameStrata = "HIGH",
    textColor = { r = 1, g = 1, b = 1, a = 1 },
    position = "RIGHT",
    showPercent = true,
    showCount = false,
    showTotal = false,
    xOffset = 0,
    yOffset = 0,
    customFormat = "(%s)" -- %s sera remplacé par le pourcentage
}
