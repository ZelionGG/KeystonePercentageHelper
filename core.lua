local AddOnName, KeystonePercentageHelper = ...;
local _G = _G;
-- Cache frequently used global functions for better performance
local pairs, unpack, select = pairs, unpack, select

-- Initialize Ace3 libraries
local AceAddon = LibStub("AceAddon-3.0")
KeystonePercentageHelper = AceAddon:NewAddon(KeystonePercentageHelper, AddOnName, "AceConsole-3.0", "AceEvent-3.0");

-- Initialize changelog
KeystonePercentageHelper.Changelog = {}

-- Define constants
KeystonePercentageHelper.constants = {
    mediaPath = "Interface\\AddOns\\" .. AddOnName .. "\\media\\"
}

-- Track the last routes update version for prompting users
KeystonePercentageHelper.lastRoutesUpdate = "1.7.2" -- Set to true when routes have been updated

-- Table to store dungeons with changed routes
KeystonePercentageHelper.CHANGED_ROUTES_DUNGEONS = {
    ["AKCE"] = true,
    ["EDAD"] = true,
    ["HoA"] = true,
    ["PotSF"] = true,
    ["TSLG"] = true,
    ["TSoW"] = true
}

-- Initialize Ace3 configuration libraries
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

-- Initialize LibSharedMedia for font and texture support
KeystonePercentageHelper.LSM = LibStub('LibSharedMedia-3.0');

-- Get localization table
local L = KeystonePercentageHelper.L;

-- Initialize dungeons table to store all dungeon data
KeystonePercentageHelper.DUNGEONS = {}

-- Track current dungeon and section
KeystonePercentageHelper.currentDungeonID = 0
KeystonePercentageHelper.currentSection = 1

-- Called when the addon is first loaded
function KeystonePercentageHelper:OnInitialize()
    -- Initialize the database first with AceDB
    self.db = LibStub("AceDB-3.0"):New("KeystonePercentageHelperDB", self.defaults, "Default")

    -- Load dungeon data from expansion modules
    self:LoadExpansionDungeons()

    -- Generate changelog for display in options
    self:GenerateChangelog()

    -- Check if a new season has started
    self:CheckForNewSeason()

    -- Check if routes have been updated in a new version
    self:CheckForNewRoutes()

    -- Create overlay frame for positioning UI
    self.overlayFrame = CreateFrame("Frame", "KeystonePercentageHelperOverlay", UIParent, "BackdropTemplate")
    self.overlayFrame:SetFrameStrata("FULLSCREEN_DIALOG")
    self.overlayFrame:SetAllPoints()
    self.overlayFrame:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile = true, tileSize = 16,
    })
    self.overlayFrame:SetBackdropColor(0, 0, 0, 0.7)

    -- Create plus sign crosshair for positioning
    local lineThickness = 2

    -- Horizontal line for crosshair
    local horizontalLine = self.overlayFrame:CreateLine()
    horizontalLine:SetThickness(lineThickness)
    horizontalLine:SetColorTexture(1, 1, 1, 0.1)
    horizontalLine:SetStartPoint("LEFT")
    horizontalLine:SetEndPoint("RIGHT")

    -- Vertical line for crosshair
    local verticalLine = self.overlayFrame:CreateLine()
    verticalLine:SetThickness(lineThickness)
    verticalLine:SetColorTexture(1, 1, 1, 0.1)
    verticalLine:SetStartPoint("TOP")
    verticalLine:SetEndPoint("BOTTOM")

    self.overlayFrame:Hide()

    -- Create main display frame that shows percentage
    self.displayFrame = CreateFrame("Frame", "KeystonePercentageHelperFrame", UIParent)
    self.displayFrame:SetSize(200, 20)
    self.displayFrame:SetPoint(self.db.profile.general.position, UIParent, self.db.profile.general.position, self.db.profile.general.xOffset, self.db.profile.general.yOffset)

    -- Create text element for displaying percentage
    self.displayFrame.text = self.displayFrame:CreateFontString(nil, "OVERLAY")
    self.displayFrame.text:SetPoint("CENTER")
    self.displayFrame.text:SetFont(self.LSM:Fetch('font', self.db.profile.text.font), self.db.profile.general.fontSize, "OUTLINE")

    -- Create anchor frame for moving the display
    self.anchorFrame = CreateFrame("Frame", "KeystonePercentageHelperAnchorFrame", self.overlayFrame, "BackdropTemplate")
    self.anchorFrame:SetFrameStrata("TOOLTIP")
    self.anchorFrame:SetSize(200, 30)
    self.anchorFrame:SetPoint("CENTER", self.displayFrame, "CENTER", 0, 0)
    self.anchorFrame:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile = true, tileSize = 16, edgeSize = 1,
    })
    self.anchorFrame:SetBackdropColor(0, 0, 0, 0.5)
    self.anchorFrame:SetBackdropBorderColor(1, 1, 1, 1)

    -- Create text for the anchor frame
    local text = self.anchorFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("CENTER")
    text:SetText(L["ANCHOR_TEXT"])

    -- Create validate button to confirm position
    local validateButton = CreateFrame("Button", nil, self.anchorFrame, "UIPanelButtonTemplate")
    validateButton:SetSize(80, 30)
    validateButton:SetPoint("BOTTOMRIGHT", self.anchorFrame, "BOTTOMRIGHT", -10, -40)
    validateButton:SetText(L["VALIDATE"])
    validateButton:SetScript("OnClick", function()
        self.anchorFrame:Hide()
        self.overlayFrame:Hide()
        -- Show the settings panel and navigate to our addon
        Settings.OpenToCategory("Keystone Percentage Helper")
    end)

    -- Create cancel button to abort positioning
    local cancelButton = CreateFrame("Button", nil, self.anchorFrame, "UIPanelButtonTemplate")
    cancelButton:SetSize(80, 30)
    cancelButton:SetPoint("BOTTOMLEFT", self.anchorFrame, "BOTTOMLEFT", 10, -40)
    cancelButton:SetText(L["CANCEL"])

    -- Function to cancel positioning and return to settings
    local function CancelPositioning()
        self.anchorFrame:Hide()
        self.overlayFrame:Hide()
        -- Show the settings panel and navigate to our addon
        Settings.OpenToCategory("Keystone Percentage Helper")
    end

    cancelButton:SetScript("OnClick", CancelPositioning)

    -- Handle ESC key to cancel positioning
    self.anchorFrame:SetScript("OnKeyDown", function(_, key)
        if key == "ESCAPE" then
            CancelPositioning()
        end
    end)
    self.anchorFrame:EnableKeyboard(true)

    -- Handle combat state to hide positioning UI during combat
    local combatFrame = CreateFrame("Frame")
    combatFrame.wasShown = false
    combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
    combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    combatFrame:SetScript("OnEvent", function(_, event)
        if event == "PLAYER_REGEN_DISABLED" then
            -- Hide positioning UI when entering combat
            if self.anchorFrame:IsShown() then
                combatFrame.wasShown = true
                self.anchorFrame:Hide()
                self.overlayFrame:Hide()
            end
        elseif event == "PLAYER_REGEN_ENABLED" and combatFrame.wasShown then
            -- Restore positioning UI when leaving combat
            combatFrame.wasShown = false
            self.anchorFrame:Show()
            self.overlayFrame:Show()
        end
    end)

    -- Apply ElvUI skin if available for better integration
    if ElvUI then
        local E = unpack(ElvUI)
        if E and E.Skins then
            E:GetModule('Skins'):HandleButton(validateButton)
            E:GetModule('Skins'):HandleButton(cancelButton)
        end
    end

    -- Make anchor frame movable for positioning
    self.anchorFrame:EnableMouse(true)
    self.anchorFrame:SetMovable(true)
    self.anchorFrame:RegisterForDrag("LeftButton")
    self.anchorFrame:SetScript("OnDragStart", function() self.anchorFrame:StartMoving() end)
    self.anchorFrame:SetScript("OnDragStop", function()
        self.anchorFrame:StopMovingOrSizing()
        -- Update position based on anchor frame position
        local point, _, relativePoint, xOffset, yOffset = self.anchorFrame:GetPoint()
        self.db.profile.general.position = point
        self.db.profile.general.xOffset = xOffset
        self.db.profile.general.yOffset = yOffset
        self:Refresh()
    end)

    self.anchorFrame:Hide()

    -- Register options with Ace3 config system
    AceConfig:RegisterOptionsTable(AddOnName, {
        name = "Keystone Percentage Helper",
        type = "group",
        args = {
            general = {
                name = L["GENERAL_SETTINGS"],
                type = "group",
                order = 1,
                args = {
                    generalHeader = {
                        order = 0,
                        type = "header",
                        name = L["GENERAL_SETTINGS"],
                    },
                    positioning = self:GetPositioningOptions(),
                    font = self:GetFontOptions(),
                    colors = self:GetColorOptions(),
                    otherOptions = self:GetOtherOptions(),
                }
            },
            modules = {
                name = L["MODULES"],
                type = "group",
                order = 2,
                childGroups = "tree",
                args = {
                    mdtIntegration = {
                        name = L["MDT_INTEGRATION"],
                        type = "group",
                        order = 2,
                        args = {
                            mdtIntegrationHeader = {
                                order = 0,
                                type = "header",
                                name = L["MDT_INTEGRATION"],
                            },
                            mdtWarning = {
                                name = L["MDT_SECTION_WARNING"],
                                type = "description",
                                order = 1,
                                fontSize = "medium",
                            },
                            -- Information about MDT integration features
                            featuresHeader = {
                                order = 2,
                                type = "header",
                                name = L["MDT_INTEGRATION_FEATURES"],
                            },
                            mobPercentagesInfo = {
                                name = L["MOB_PERCENTAGES_INFO"],
                                type = "description",
                                order = 4,
                                fontSize = "medium",
                            },
                            --[[ mobIndicatorInfo = {
                                name = L["MOB_INDICATOR_INFO"],
                                type = "description",
                                order = 5,
                                fontSize = "medium",
                            }, ]]
                            mobPercentages = self:GetMobPercentagesOptions(),
                            --mobIndicator = self:GetMobIndicatorOptions(),
                        }
                    },
                }
            },
            advanced = self:GetAdvancedOptions()
        }
    })
    AceConfig:RegisterOptionsTable(AddOnName .. "_Changelog", self.changelogOptions)

    AceConfigDialog:AddToBlizOptions(AddOnName, "Keystone Percentage Helper")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_Changelog", L['Changelog'], "Keystone Percentage Helper")


    -- Register chat command and events
    self:RegisterChatCommand('kph', 'ToggleConfig')

    -- Create display after DB is initialized
    self:CreateDisplay()
    
    -- Initialize mob percentages module if enabled
    if self.db.profile.mobPercentages and self.db.profile.mobPercentages.enabled then
        self:InitializeMobPercentages()
    end

    -- After InitializeMobPercentages check
    --[[ if self.db.profile.mobIndicator and self.db.profile.mobIndicator.enabled then
        self:InitializeMobIndicator()
    end ]]
    end
end

-- Open configuration panel when command is used
function KeystonePercentageHelper:ToggleConfig()
    Settings.OpenToCategory("Keystone Percentage Helper")
end

-- Handler for addon compartment button click
_G.KeystonePercentageHelper_OnAddonCompartmentClick = function()
    KeystonePercentageHelper:ToggleConfig()
end

-- Create or recreate the main display frame
function KeystonePercentageHelper:CreateDisplay()
    if not self.displayFrame then
        self.displayFrame = CreateFrame("Frame", "KeystonePercentageHelperDisplay", UIParent)
        self.displayFrame:SetSize(200, 30)

        -- Create percentage text
        self.displayFrame.text = self.displayFrame:CreateFontString(nil, "OVERLAY")
        self.displayFrame.text:SetFont(self.LSM:Fetch('font', self.db.profile.text.font), self.db.profile.general.fontSize, "OUTLINE")
        self.displayFrame.text:SetPoint("CENTER")
        self.displayFrame.text:SetText("0.0%") -- Set initial text

        -- Set position from saved variables
        self.displayFrame:ClearAllPoints()
        self.displayFrame:SetPoint(
            self.db.profile.general.position,
            UIParent,
            self.db.profile.general.position,
            self.db.profile.general.xOffset,
            self.db.profile.general.yOffset
        )
    end

    -- Ensure text is visible and settings are applied
    self:Refresh()
end

-- Initialize dungeon tracking when entering a dungeon
function KeystonePercentageHelper:InitiateDungeon()
    local currentDungeonId = C_ChallengeMode.GetActiveChallengeMapID()
    -- Return if not in a dungeon or already tracking this dungeon
    if currentDungeonId == nil or currentDungeonId == self.currentDungeonID then return end

    -- Set current dungeon and reset to first section
    self.currentDungeonID = currentDungeonId
    self.currentSection = 1

    -- Sort dungeon data by percentage to ensure proper progression
    if self.DUNGEONS[self.currentDungeonID] then
        table.sort(self.DUNGEONS[self.currentDungeonID], function(left, right)
            return left[2] < right[2]
        end)
    end
end

-- Get the current enemy forces percentage from the scenario UI
function KeystonePercentageHelper:GetCurrentPercentage()
    local steps = select(3, C_Scenario.GetStepInfo())
    local criteriaInfo = C_ScenarioInfo.GetCriteriaInfo(steps) or {}
    local percent, total, current = criteriaInfo.quantity, criteriaInfo.totalQuantity, criteriaInfo.quantityString

    if current then
        -- Extract percentage from the string (remove % symbol)
        current = tonumber(string.sub(current, 1, string.len(current) - 1)) or 0
        local currentPercent = (current / total) * 100
        return currentPercent or 0
    end

    return 0
end

-- Get data for the current section of the dungeon
function KeystonePercentageHelper:GetDungeonData()
    if not self.DUNGEONS[self.currentDungeonID] or not self.DUNGEONS[self.currentDungeonID][self.currentSection] then
        return nil
    end

    local dungeonData = self.DUNGEONS[self.currentDungeonID][self.currentSection]
    return dungeonData[1], dungeonData[2], dungeonData[3], dungeonData[4]
end

-- Send a chat message to inform the group about missing percentage
function KeystonePercentageHelper:InformGroup(percentage)
    if not self.db.profile.general.informGroup then return end

    local channel = self.db.profile.general.informChannel
    local percentageStr = string.format("%.2f%%", percentage)
    -- Don't send message if percentage is 0
    if percentageStr == "0.00%" then return end
    SendChatMessage("[KPH]: " .. L["WE_STILL_NEED"] .. " " .. percentageStr, channel)
end

-- Update the displayed percentage text based on dungeon progress
function KeystonePercentageHelper:UpdatePercentageText()
    if not self.displayFrame then return end

    -- Initialize dungeon tracking if needed
    self:InitiateDungeon()

    -- Check if we're in a supported dungeon
    local currentDungeonID = C_ChallengeMode.GetActiveChallengeMapID()
    if currentDungeonID == nil or not self.DUNGEONS[currentDungeonID] then
        self.displayFrame.text:SetText("")
        return
    end

    -- Get current enemy forces percentage
    local currentPercentage = self:GetCurrentPercentage()

    -- Skip sections that have 0 or negative percentage requirements
    while self.DUNGEONS[self.currentDungeonID][self.currentSection] and self.DUNGEONS[self.currentDungeonID][self.currentSection][2] <= 0 do
        self.currentSection = self.currentSection + 1
    end

    -- Get data for current section
    local bossID, neededPercent, shouldInfom, haveInformed = self:GetDungeonData()
    if not bossID then return end

    -- Check if criteria info is available for this boss
    if C_ScenarioInfo.GetCriteriaInfo(bossID) then
        -- Check if boss is killed
        local isBossKilled = C_ScenarioInfo.GetCriteriaInfo(bossID).completed

        -- Calculate remaining percentage needed
        local remainingPercent = neededPercent - currentPercentage
        -- Ensure remainingPercent never goes below zero
        if remainingPercent < 0 then
            remainingPercent = 0.00
        end
        -- Round very small values to 0 to avoid showing 0.01%
        if remainingPercent < 0.05 and remainingPercent > 0.00 then
            remainingPercent = 0.00
        end

        local displayPercent = string.format("%.2f%%", remainingPercent)
        local color = self.db.profile.color.inProgress

        if remainingPercent > 0 and isBossKilled then -- Boss has been killed but percentage is missing
            -- Inform group about missing percentage if enabled
            if shouldInfom and not haveInformed and self.db.profile.general.informGroup then
                self:InformGroup(remainingPercent)
                self.DUNGEONS[self.currentDungeonID][self.currentSection][4] = true
            end
            color = self.db.profile.color.missing
            self.displayFrame.text:SetText(displayPercent)
        elseif remainingPercent > 0 and not isBossKilled then -- Boss has not been killed yet and percentage is missing
            self.displayFrame.text:SetText(displayPercent)
        elseif remainingPercent <= 0 and not isBossKilled then -- Boss has not been killed yet but percentage is done
            color = self.db.profile.color.finished
            if(currentPercentage >= 100) then
                self.displayFrame.text:SetText(L["FINISHED"])
            else
                self.displayFrame.text:SetText(L["DONE"])
            end
        elseif remainingPercent <= 0 and isBossKilled then -- Boss has been killed and percentage is done
            color = self.db.profile.color.finished
            if(currentPercentage >= 100) then
                self.displayFrame.text:SetText(L["FINISHED"])
            else
                self.displayFrame.text:SetText(L["SECTION_DONE"])
            end
            self.currentSection = self.currentSection + 1
            if self.currentSection <= #self.DUNGEONS[self.currentDungeonID] then -- Next section exists
                C_Timer.After(2, function()
                    local nextRequired = self.DUNGEONS[self.currentDungeonID][self.currentSection][2] - currentPercentage
                        -- Ensure nextRequired never goes below zero
                        if nextRequired < 0 then
                            nextRequired = 0.00
                        end
                    if currentPercentage >= 100 then -- Percentage is already done for the dungeon
                        color = self.db.profile.color.finished
                        self.displayFrame.text:SetText(L["FINISHED"])
                    else -- Dungeon has not been completed
                        if nextRequired == 0 then
                            color = self.db.profile.color.finished
                            self.displayFrame.text:SetText(L["DONE"])
                        else
                            color = self.db.profile.color.inProgress
                            self.displayFrame.text:SetText(string.format("%.2f%%", nextRequired))
                        end
                    end
                    self.displayFrame.text:SetTextColor(color.r, color.g, color.b, color.a)
                end)
            else
                self.displayFrame.text:SetText(L["DUNGEON_DONE"]) -- Dungeon has been completed
            end
        end

        -- Apply text color based on status
        self.displayFrame.text:SetTextColor(color.r, color.g, color.b, color.a)
    end
end

-- Called when the addon is enabled
function KeystonePercentageHelper:OnEnable()
    -- Ensure display exists and is visible
    self:CreateDisplay()

    -- Mythic+ mode triggers
    self:RegisterEvent("CHALLENGE_MODE_START")
    self:RegisterEvent("CHALLENGE_MODE_COMPLETED")

	-- Scenario triggers
	self:RegisterEvent("SCENARIO_POI_UPDATE")
	self:RegisterEvent("SCENARIO_CRITERIA_UPDATE")

    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    -- Force an initial update
    self:UpdatePercentageText()
end

-- Event handler for POI updates (boss positions)
function KeystonePercentageHelper:SCENARIO_POI_UPDATE()
    self:UpdatePercentageText()
end

-- Event handler for criteria updates (enemy forces percentage changes)
function KeystonePercentageHelper:SCENARIO_CRITERIA_UPDATE()
    self:UpdatePercentageText()
end

-- Event handler for starting a Mythic+ dungeon
function KeystonePercentageHelper:CHALLENGE_MODE_START()
    self.currentDungeonID = nil

    self:InitiateDungeon()
    self:UpdatePercentageText()
end

function KeystonePercentageHelper:CHALLENGE_MODE_COMPLETED()
    self.currentDungeonID = nil
end

-- Event handler for entering the world or changing zones
function KeystonePercentageHelper:PLAYER_ENTERING_WORLD()
    self:InitiateDungeon()
    self:UpdatePercentageText()
end

-- Refresh the display with current settings
function KeystonePercentageHelper:Refresh()
    if not self.displayFrame then return end

    -- Update frame position
    self.displayFrame:ClearAllPoints()
    self.displayFrame:SetPoint(
        self.db.profile.general.position,
        UIParent,
        self.db.profile.general.position,
        self.db.profile.general.xOffset,
        self.db.profile.general.yOffset
    )

    -- Update anchor frame position
    self.anchorFrame:ClearAllPoints()
    self.anchorFrame:SetPoint("CENTER", self.displayFrame, "CENTER", 0, 0)

    -- Update font size and font
    self.displayFrame.text:SetFont(self.LSM:Fetch('font', self.db.profile.text.font), self.db.profile.general.fontSize, "OUTLINE")

    -- Update text color
    local color = self.db.profile.color.inProgress
    self.displayFrame.text:SetTextColor(color.r, color.g, color.b, color.a)

    -- Update dungeon data with advanced options if enabled
    self:UpdateDungeonData()

    -- Show/hide based on enabled state
    local leaderEnabled   = self.db.profile.general.rolesEnabled.LEADER
    local isLeader        = UnitIsGroupLeader("player")
    local role            = UnitGroupRolesAssigned("player")   -- "TANK", "HEALER", "DAMAGER", ou "NONE"
    local roleEnabled     = self.db.profile.general.rolesEnabled[role]

    local shouldShow = (leaderEnabled and isLeader) or roleEnabled or role == "NONE"

    if not shouldShow then
        self.displayFrame:Hide()
        return
    end
    self.displayFrame:Show()
end

-- Update dungeon data with advanced options if enabled
function KeystonePercentageHelper:UpdateDungeonData()
    if self.db.profile.general.advancedOptionsEnabled then
        for dungeonId, dungeonData in pairs(self.DUNGEONS) do
            local dungeonKey = self:GetDungeonKeyById(dungeonId)
            if dungeonKey and self.db.profile.advanced[dungeonKey] then
                local advancedData = self.db.profile.advanced[dungeonKey]
                for i, bossData in ipairs(dungeonData) do
                    local bossNumStr = self:GetBossNumberString(i)
                    bossData[2] = advancedData["Boss"..bossNumStr]
                    bossData[3] = advancedData["Boss" .. bossNumStr .. "Inform"]
                    bossData[4] = false -- Reset informed status
                end
            end
        end
    end
end
