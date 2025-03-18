local AddOnName, KeystonePercentageHelper = ...;
local _G = _G;
local pairs, unpack, select = pairs, unpack, select
local floor = math.floor
local format = string.format

local AceAddon = LibStub("AceAddon-3.0")
KeystonePercentageHelper = AceAddon:NewAddon(KeystonePercentageHelper, AddOnName, "AceConsole-3.0", "AceEvent-3.0");

-- Initialize changelog
KeystonePercentageHelper.Changelog = {}

KeystonePercentageHelper.constants = {
    mediaPath = "Interface\\AddOns\\" .. AddOnName .. "\\media\\"
}

KeystonePercentageHelper.lastRoutesUpdate = "1.4" -- Set to true when routes have been updated

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

KeystonePercentageHelper.LSM = LibStub('LibSharedMedia-3.0');

local L = KeystonePercentageHelper.L;

KeystonePercentageHelper.DUNGEONS = {}

KeystonePercentageHelper.currentDungeonID = 0
KeystonePercentageHelper.currentSection = 1

function KeystonePercentageHelper:OnInitialize()
    -- Initialize the database first
    self.db = LibStub("AceDB-3.0"):New("KeystonePercentageHelperDB", self.defaults, "Default")
    
    -- Then load expansion dungeons
    self:LoadExpansionDungeons()

    -- Generating the changelog
    self:GenerateChangelog()

    -- Check for new season
    self:CheckForNewSeason()
    
    -- Check for new routes
    self:CheckForNewRoutes()
    
    -- Create overlay frame
    self.overlayFrame = CreateFrame("Frame", "KeystonePercentageHelperOverlay", UIParent, "BackdropTemplate")
    self.overlayFrame:SetFrameStrata("FULLSCREEN_DIALOG")
    self.overlayFrame:SetAllPoints()
    self.overlayFrame:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile = true, tileSize = 16,
    })
    self.overlayFrame:SetBackdropColor(0, 0, 0, 0.7)

    -- Create plus sign
    local lineThickness = 2

    -- Horizontal line
    local horizontalLine = self.overlayFrame:CreateLine()
    horizontalLine:SetThickness(lineThickness)
    horizontalLine:SetColorTexture(1, 1, 1, 0.1)
    horizontalLine:SetStartPoint("LEFT")
    horizontalLine:SetEndPoint("RIGHT")

    -- Vertical line
    local verticalLine = self.overlayFrame:CreateLine()
    verticalLine:SetThickness(lineThickness)
    verticalLine:SetColorTexture(1, 1, 1, 0.1)
    verticalLine:SetStartPoint("TOP")
    verticalLine:SetEndPoint("BOTTOM")

    self.overlayFrame:Hide()

    -- Create main display frame
    self.displayFrame = CreateFrame("Frame", "KeystonePercentageHelperFrame", UIParent)
    self.displayFrame:SetSize(200, 20)
    self.displayFrame:SetPoint(self.db.profile.general.position, UIParent, self.db.profile.general.position, self.db.profile.general.xOffset, self.db.profile.general.yOffset)
    
    -- Create text for display frame
    self.displayFrame.text = self.displayFrame:CreateFontString(nil, "OVERLAY")
    self.displayFrame.text:SetPoint("CENTER")
    self.displayFrame.text:SetFont(self.LSM:Fetch('font', self.db.profile.text.font), self.db.profile.general.fontSize, "OUTLINE")
    
    -- Create anchor frame
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
    
    -- Create anchor frame text
    local text = self.anchorFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("CENTER")
    text:SetText(L["ANCHOR_TEXT"])
    
    -- Create validate button
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

    -- Create cancel button
    local cancelButton = CreateFrame("Button", nil, self.anchorFrame, "UIPanelButtonTemplate")
    cancelButton:SetSize(80, 30)
    cancelButton:SetPoint("BOTTOMLEFT", self.anchorFrame, "BOTTOMLEFT", 10, -40)
    cancelButton:SetText(L["CANCEL"])
    
    local function CancelPositioning()
        self.anchorFrame:Hide()
        self.overlayFrame:Hide()
        -- Show the settings panel and navigate to our addon
        Settings.OpenToCategory("Keystone Percentage Helper")
    end
    
    cancelButton:SetScript("OnClick", CancelPositioning)

    -- Handle ESC key
    self.anchorFrame:SetScript("OnKeyDown", function(_, key)
        if key == "ESCAPE" then
            CancelPositioning()
        end
    end)
    self.anchorFrame:EnableKeyboard(true)

    -- Handle combat
    local combatFrame = CreateFrame("Frame")
    combatFrame.wasShown = false
    combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
    combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    combatFrame:SetScript("OnEvent", function(_, event)
        if event == "PLAYER_REGEN_DISABLED" then
            if self.anchorFrame:IsShown() then
                combatFrame.wasShown = true
                self.anchorFrame:Hide()
                self.overlayFrame:Hide()
            end
        elseif event == "PLAYER_REGEN_ENABLED" and combatFrame.wasShown then
            combatFrame.wasShown = false
            self.anchorFrame:Show()
            self.overlayFrame:Show()
        end
    end)

    -- Apply ElvUI skin if available
    if ElvUI then
        local E = unpack(ElvUI)
        if E and E.Skins then
            E:GetModule('Skins'):HandleButton(validateButton)
            E:GetModule('Skins'):HandleButton(cancelButton)
        end
    end
    
    self.anchorFrame:EnableMouse(true)
    self.anchorFrame:SetMovable(true)
    self.anchorFrame:RegisterForDrag("LeftButton")
    self.anchorFrame:SetScript("OnDragStart", function() self.anchorFrame:StartMoving() end)
    self.anchorFrame:SetScript("OnDragStop", function()
        self.anchorFrame:StopMovingOrSizing()
        -- Update position based on anchor
        local point, _, relativePoint, xOffset, yOffset = self.anchorFrame:GetPoint()
        self.db.profile.general.position = point
        self.db.profile.general.xOffset = xOffset
        self.db.profile.general.yOffset = yOffset
        self:Refresh()
    end)
    
    self.anchorFrame:Hide()
    
    -- Register options
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
end

function KeystonePercentageHelper:ToggleConfig()
    Settings.OpenToCategory("Keystone Percentage Helper")
end

_G.KeystonePercentageHelper_OnAddonCompartmentClick = function()
    KeystonePercentageHelper:ToggleConfig()
end

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

function KeystonePercentageHelper:InitiateDungeon()
    local currentDungeonId = C_ChallengeMode.GetActiveChallengeMapID()
    if currentDungeonId == nil or currentDungeonId == self.currentDungeonID then return end
    
    self.currentDungeonID = currentDungeonId
    self.currentSection = 1
    
    -- Sort dungeon data by percentage
    if self.DUNGEONS[self.currentDungeonID] then
        table.sort(self.DUNGEONS[self.currentDungeonID], function(left, right)
            return left[2] < right[2]
        end)
    end
end

function KeystonePercentageHelper:GetCurrentPercentage()
    local steps = select(3, C_Scenario.GetStepInfo())
    local criteriaInfo = C_ScenarioInfo.GetCriteriaInfo(steps) or {}
    local percent, total, current = criteriaInfo.quantity, criteriaInfo.totalQuantity, criteriaInfo.quantityString
    
    if current then
        current = tonumber(string.sub(current, 1, string.len(current) - 1)) or 0
        local currentPercent = (current / total) * 100 
        return currentPercent or 0
    end
    
    return 0
end

function KeystonePercentageHelper:GetDungeonData()
    if not self.DUNGEONS[self.currentDungeonID] or not self.DUNGEONS[self.currentDungeonID][self.currentSection] then
        return nil
    end
    
    local dungeonData = self.DUNGEONS[self.currentDungeonID][self.currentSection]
    return dungeonData[1], dungeonData[2], dungeonData[3], dungeonData[4]
end

function KeystonePercentageHelper:InformGroup(percentage)
    if not self.db.profile.general.informGroup then return end
    
    local channel = self.db.profile.general.informChannel
    local percentageStr = string.format("%.2f%%", percentage)
    if percentageStr == "0.00%" then return end
    SendChatMessage("[KPH]: " .. L["WE_STILL_NEED"] .. " " .. percentageStr, channel)
end

function KeystonePercentageHelper:UpdatePercentageText()
    if not self.displayFrame then return end
    
    self:InitiateDungeon()
    
    local currentDungeonID = C_ChallengeMode.GetActiveChallengeMapID()
    if currentDungeonID == nil or not self.DUNGEONS[currentDungeonID] then 
        self.displayFrame.text:SetText("")
        return 
    end
    
    local currentPercentage = self:GetCurrentPercentage()
    
    while self.DUNGEONS[self.currentDungeonID][self.currentSection] and self.DUNGEONS[self.currentDungeonID][self.currentSection][2] <= 0 do
        self.currentSection = self.currentSection + 1
    end
    
    local bossID, neededPercent, shouldInfom, haveInformed = self:GetDungeonData()
    if not bossID then return end
    
    if C_ScenarioInfo.GetCriteriaInfo(bossID) then
        local isBossKilled = C_ScenarioInfo.GetCriteriaInfo(bossID).completed
        
        local remainingPercent = neededPercent - currentPercentage
        if remainingPercent < 0.05 and remainingPercent > 0.00 then 
            remainingPercent = 0.00
        end
        
        local displayPercent = string.format("%.2f%%", remainingPercent)
        local color = self.db.profile.color.inProgress
        
        if remainingPercent > 0 and isBossKilled then
            if shouldInfom and not haveInformed and self.db.profile.general.informGroup then
                self:InformGroup(remainingPercent)
                self.DUNGEONS[self.currentDungeonID][self.currentSection][4] = true
            end
            color = self.db.profile.color.missing
            self.displayFrame.text:SetText(displayPercent)
        elseif remainingPercent > 0 and not isBossKilled then
            self.displayFrame.text:SetText(displayPercent)
        elseif remainingPercent <= 0 and not isBossKilled then
            color = self.db.profile.color.finished
            self.displayFrame.text:SetText(L["Done"])
        elseif remainingPercent <= 0 and isBossKilled then
            color = self.db.profile.color.finished
            self.displayFrame.text:SetText(L["Finished"])
            self.currentSection = self.currentSection + 1
            if self.currentSection <= #self.DUNGEONS[self.currentDungeonID] then
                C_Timer.After(2, function()
                    local nextRequired = self.DUNGEONS[self.currentDungeonID][self.currentSection][2] - currentPercentage
                    if currentPercentage >= 100 then
                        color = self.db.profile.color.finished
                        self.displayFrame.text:SetText(L["Finished"])
                    else
                        color = self.db.profile.color.inProgress
                        if nextRequired <= 0 then
                            self.displayFrame.text:SetText(L["Done"])
                        else
                            self.displayFrame.text:SetText(string.format("%.2f%%", nextRequired))
                        end
                    end
                    self.displayFrame.text:SetTextColor(color.r, color.g, color.b, color.a)
                end)
            else
                self.displayFrame.text:SetText(L["Finished"])
            end
        end
        
        self.displayFrame.text:SetTextColor(color.r, color.g, color.b, color.a)
    end
end

function KeystonePercentageHelper:OnEnable()
    -- Ensure display exists and is visible
    self:CreateDisplay()
    self:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
    self:RegisterEvent("CHALLENGE_MODE_START")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    -- Force an initial update
    self:UpdatePercentageText()
end

function KeystonePercentageHelper:SCENARIO_CRITERIA_UPDATE()
    self:UpdatePercentageText()
end

function KeystonePercentageHelper:CHALLENGE_MODE_START()
    self:InitiateDungeon()
    self:UpdatePercentageText()
end

function KeystonePercentageHelper:PLAYER_ENTERING_WORLD()
    self:InitiateDungeon()
    self:UpdatePercentageText()
end

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
    self.displayFrame:Show()
end

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
