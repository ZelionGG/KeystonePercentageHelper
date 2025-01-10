local AddOnName, KeystonePercentageHelper = ...;
local _G = _G;
local pairs, unpack, select = pairs, unpack, select
local floor = math.floor
local AceAddon, AceAddonMinor = _G.LibStub('AceAddon-3.0')
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

KeystonePercentageHelper.LSM = LibStub('LibSharedMedia-3.0');

KeystonePercentageHelper.constants = {
    mediaPath = "Interface\\AddOns\\" .. AddOnName .. "\\media\\"
}

AceAddon:NewAddon(KeystonePercentageHelper, AddOnName, "AceConsole-3.0", "AceEvent-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName, true);
local options

KeystonePercentageHelper.DUNGEONS = {
    -- {bossID, neededPercent, shouldInfom, haveInformed}
    [503] = {{1, 32.78, false, false}, {2, 78.76,  false, false}, {3, 100,   true,  false}}, -- [AKCE] Ara-Kara, City of Echoes
    [502] = {{1, 31.54, false, false}, {2, 56.60,  false, false}, {3, 87.60, false, false},  {4, 100,   true, false}}, -- [CoT] City of Threads
    [507] = {{1, 39.68, false, false}, {2, 45.83,  false, false}, {3, 81.26, true,  false},  {4, 100,   true, false}}, -- [GB] Grim Batol
    [375] = {{1, 33.10, false, false}, {2, 63.45,  false, false}, {3, 100,   true,  false}}, -- [MoTS] Mists of Tirna Scithe
    [353] = {{1, 37.04, false, false}, {2, 54.66,  false, false}, {3, 100,   true,  false},  {4, 100,   true, false}}, -- [SoB] Siege of Boralus
    [505] = {{1, 29.78, false, false}, {2, 93.48,  false, false}, {3, 100,   true,  false}}, -- [TDB] The Dawnbreaker
    [376] = {{1, 22.59, false, false}, {2, 76.81,  true, false},  {3, 100,   true,  false},  {4, 100,   true, false}}, -- [NW] The Necrotic Wake
    [501] = {{1, 26.79, false, false}, {2, 54.40,  false, false}, {3, 75.66, false, false},  {4, 100, true, false}}, -- [TSV] The Stonevault
}

KeystonePercentageHelper.currentDungeonID = 0
KeystonePercentageHelper.currentSection = 1

KeystonePercentageHelper.defaults = {
    profile = {
        general = {
            enabled = true,
            fontSize = 12,
            position = "CENTER",
            xOffset = 0,
            yOffset = 0,
            informGroup = true,
        },
        text = {
            font = "Friz Quadrata TT",
        },
        color = {
            inProgress = {r = 1, g = 1, b = 1, a = 1},
            finished = {r = 0, g = 1, b = 0, a = 1},
            missing = {r = 1, g = 0, b = 0, a = 1}
        }
    }
}

function KeystonePercentageHelper:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("KeystonePercentageHelperDB", self.defaults, "Default")
    self.LSM:Register(self.LSM.MediaType.FONT, 'Friz Quadrata TT',
                      self.constants.mediaPath .. "FrizQuadrata.ttf")
    
    options = {
        name = "Keystone Percentage Helper",
        type = "group",
        args = {
            general = {
                name = "General Settings",
                type = "group",
                order = 1,
                args = {
                    enabled = {
                        name = "Enable",
                        desc = "Enable/disable the addon",
                        type = "toggle",
                        order = 1,
                        get = function() return self.db.profile.general.enabled end,
                        set = function(_, value)
                            self.db.profile.general.enabled = value
                            self:Refresh()
                        end
                    },
                    font = {
                        name = "Font",
                        type = "select",
                        dialogControl = 'LSM30_Font',
                        order = 2,
                        values = AceGUIWidgetLSMlists.font,
                        style = "dropdown",
                        get = function()
                            return self.db.profile.text.font
                        end,
                        set = function(_, value)
                            self.db.profile.text.font = value
                            self:Refresh()
                        end
                    },
                    fontSize = {
                        name = "Font Size",
                        desc = "Adjust the size of the text",
                        type = "range",
                        order = 3,
                        min = 8,
                        max = 24,
                        step = 1,
                        get = function() return self.db.profile.general.fontSize end,
                        set = function(_, value)
                            self.db.profile.general.fontSize = value
                            self:Refresh()
                        end
                    },
                    informGroup = {
                        name = "Inform Group",
                        desc = "Send messages to the party chat when reaching important percentage thresholds",
                        type = "toggle",
                        order = 4,
                        get = function() return self.db.profile.general.informGroup end,
                        set = function(_, value)
                            self.db.profile.general.informGroup = value
                        end
                    },
                    positioning = self:GetPositioningOptions(),
                    colors = self:GetColorOptions()
                }
            }
        }
    }
    
    AceConfig:RegisterOptionsTable(AddOnName, options)
    AceConfigDialog:AddToBlizOptions(AddOnName, "Keystone Percentage Helper")

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
    
    local channel = "PARTY"
    local percentageStr = string.format("%.2f%%", percentage)
    if percentageStr == "0.00%" then return end
    SendChatMessage("[KPH]: We still need " .. percentageStr, channel)
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
            self.displayFrame.text:SetText("Done")
        elseif remainingPercent <= 0 and isBossKilled then
            color = self.db.profile.color.finished
            self.displayFrame.text:SetText("Finished")
            self.currentSection = self.currentSection + 1
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
    
    -- Update font size and font
    self.displayFrame.text:SetFont(self.LSM:Fetch('font', self.db.profile.text.font), self.db.profile.general.fontSize, "OUTLINE")
    
    -- Update text color
    local color = self.db.profile.color.inProgress
    self.displayFrame.text:SetTextColor(color.r, color.g, color.b, color.a)
    
    -- Show/hide based on enabled state
    if self.db.profile.general.enabled then
        self.displayFrame:Show()
    else
        self.displayFrame:Hide()
    end
end

function KeystonePercentageHelper:GetColorOptions()
    return {
        name = "Colors",
        type = "group",
        inline = true,
        order = 2,
        args = {
            inProgressColor = {
                name = "In progress",
                type = "color",
                hasAlpha = true,
                order = 1,
                get = function()
                    local color = KeystonePercentageHelper.db.profile.color.inProgress
                    return color.r, color.g, color.b, color.a
                end,
                set = function(_, r, g, b, a)
                    local color = KeystonePercentageHelper.db.profile.color.inProgress
                    color.r, color.g, color.b, color.a = r, g, b, a
                    KeystonePercentageHelper:Refresh()
                end
            },
            finishedColor = {
                name = "Finished",
                type = "color",
                hasAlpha = true,
                order = 2,
                get = function()
                    local color = KeystonePercentageHelper.db.profile.color.finished
                    return color.r, color.g, color.b, color.a
                end,
                set = function(_, r, g, b, a)
                    local color = KeystonePercentageHelper.db.profile.color.finished
                    color.r, color.g, color.b, color.a = r, g, b, a
                    KeystonePercentageHelper:Refresh()
                end
            },
            missingColor = {
                name = "Missing",
                type = "color",
                hasAlpha = true,
                order = 3,
                get = function()
                    local color = KeystonePercentageHelper.db.profile.color.missing
                    return color.r, color.g, color.b, color.a
                end,
                set = function(_, r, g, b, a)
                    local color = KeystonePercentageHelper.db.profile.color.missing
                    color.r, color.g, color.b, color.a = r, g, b, a
                    KeystonePercentageHelper:Refresh()
                end
            }
        }
    }
end

function KeystonePercentageHelper:GetPositioningOptions()
    return {
        name = "Positioning",
        type = "group",
        inline = true,
        order = 1,
        args = {
            position = {
                name = "Anchor Position",
                type = "select",
                order = 1,
                values = {
                    ["TOP"] = "Top",
                    ["CENTER"] = "Center",
                    ["BOTTOM"] = "Bottom"
                },
                get = function() return KeystonePercentageHelper.db.profile.general.position end,
                set = function(_, value)
                    KeystonePercentageHelper.db.profile.general.position = value
                    KeystonePercentageHelper:Refresh()
                end
            },
            xOffset = {
                name = "X Offset",
                type = "range",
                order = 2,
                min = -500,
                max = 500,
                step = 1,
                get = function() return KeystonePercentageHelper.db.profile.general.xOffset end,
                set = function(_, value)
                    KeystonePercentageHelper.db.profile.general.xOffset = value
                    KeystonePercentageHelper:Refresh()
                end
            },
            yOffset = {
                name = "Y Offset",
                type = "range",
                order = 3,
                min = -500,
                max = 500,
                step = 1,
                get = function() return KeystonePercentageHelper.db.profile.general.yOffset end,
                set = function(_, value)
                    KeystonePercentageHelper.db.profile.general.yOffset = value
                    KeystonePercentageHelper:Refresh()
                end
            }
        }
    }
end