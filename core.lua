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

KeystonePercentageHelper.DUNGEONS = {}

-- Load expansion-specific dungeon data
local function LoadExpansionDungeons()
    -- War Within dungeons
    for id, data in pairs(KeystonePercentageHelper.WW_DUNGEONS or {}) do
        KeystonePercentageHelper.DUNGEONS[id] = data
    end
    -- Shadowlands dungeons
    for id, data in pairs(KeystonePercentageHelper.SL_DUNGEONS or {}) do
        KeystonePercentageHelper.DUNGEONS[id] = data
    end
    -- BFA dungeons
    for id, data in pairs(KeystonePercentageHelper.BFA_DUNGEONS or {}) do
        KeystonePercentageHelper.DUNGEONS[id] = data
    end
    -- Cataclysm dungeons
    for id, data in pairs(KeystonePercentageHelper.CATACLYSM_DUNGEONS or {}) do
        KeystonePercentageHelper.DUNGEONS[id] = data
    end
end

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
            advancedOptionsEnabled = false,
        },
        text = {
            font = "Friz Quadrata TT",
        },
        color = {
            inProgress = {r = 1, g = 1, b = 1, a = 1},
            finished = {r = 0, g = 1, b = 0, a = 1},
            missing = {r = 1, g = 0, b = 0, a = 1}
        },
        advanced = {}
    }
}

-- Load expansion-specific defaults
for k, v in pairs(KeystonePercentageHelper.WW_DEFAULTS or {}) do
    KeystonePercentageHelper.defaults.profile.advanced[k] = v
end
for k, v in pairs(KeystonePercentageHelper.SL_DEFAULTS or {}) do
    KeystonePercentageHelper.defaults.profile.advanced[k] = v
end
for k, v in pairs(KeystonePercentageHelper.BFA_DEFAULTS or {}) do
    KeystonePercentageHelper.defaults.profile.advanced[k] = v
end
for k, v in pairs(KeystonePercentageHelper.CATACLYSM_DEFAULTS or {}) do
    KeystonePercentageHelper.defaults.profile.advanced[k] = v
end

function KeystonePercentageHelper:GetAdvancedOptions()
    -- Create shared dungeon options
    local sharedDungeonOptions = {}
    for dungeonKey, dungeonId in pairs(self.WW_DUNGEON_IDS) do
        sharedDungeonOptions[dungeonKey] = self:CreateDungeonOptions(dungeonKey, 0)
    end
    for dungeonKey, dungeonId in pairs(self.SL_DUNGEON_IDS) do
        sharedDungeonOptions[dungeonKey] = self:CreateDungeonOptions(dungeonKey, 0)
    end
    for dungeonKey, dungeonId in pairs(self.BFA_DUNGEON_IDS) do
        sharedDungeonOptions[dungeonKey] = self:CreateDungeonOptions(dungeonKey, 0)
    end
    for dungeonKey, dungeonId in pairs(self.CATACLYSM_DUNGEON_IDS) do
        sharedDungeonOptions[dungeonKey] = self:CreateDungeonOptions(dungeonKey, 0)
    end

    -- Create current season options
    local currentSeasonOptions = {}
    local currentSeasonDungeons = {}
    
    -- Collect all current season dungeons
    for dungeonKey, dungeonId in pairs(self.WW_DUNGEON_IDS) do
        if self:IsCurrentSeasonDungeon(dungeonId) then
            table.insert(currentSeasonDungeons, {key = dungeonKey, id = dungeonId})
        end
    end
    for dungeonKey, dungeonId in pairs(self.SL_DUNGEON_IDS) do
        if self:IsCurrentSeasonDungeon(dungeonId) then
            table.insert(currentSeasonDungeons, {key = dungeonKey, id = dungeonId})
        end
    end
    for dungeonKey, dungeonId in pairs(self.BFA_DUNGEON_IDS) do
        if self:IsCurrentSeasonDungeon(dungeonId) then
            table.insert(currentSeasonDungeons, {key = dungeonKey, id = dungeonId})
        end
    end
    for dungeonKey, dungeonId in pairs(self.CATACLYSM_DUNGEON_IDS) do
        if self:IsCurrentSeasonDungeon(dungeonId) then
            table.insert(currentSeasonDungeons, {key = dungeonKey, id = dungeonId})
        end
    end
    
    -- Sort dungeons alphabetically by their localized names
    table.sort(currentSeasonDungeons, function(a, b)
        return L[a.key] < L[b.key]
    end)
    
    -- Create options in sorted order
    for i, dungeon in ipairs(currentSeasonDungeons) do
        local dungeonKey = dungeon.key
        -- Create a new option with the correct order
        currentSeasonOptions[dungeonKey] = self:CreateDungeonOptions(dungeonKey, i + 1)  -- +1 because defaultPercentages is order 0
    end

    -- Add current season dungeons to args table
    local dungeonArgs = {
        defaultPercentages = {
            order = 0,
            type = "description",
            fontSize = "medium",
            name = function()
                local text = "Default percentages:\n\n"
                
                -- Show dungeons in the same sorted order as the options
                for _, dungeon in ipairs(currentSeasonDungeons) do
                    local dungeonKey = dungeon.key
                    local defaults
                    if self.WW_DUNGEON_IDS[dungeonKey] then
                        defaults = self.WW_DEFAULTS[dungeonKey]
                    elseif self.SL_DUNGEON_IDS[dungeonKey] then
                        defaults = self.SL_DEFAULTS[dungeonKey]
                    elseif self.BFA_DUNGEON_IDS[dungeonKey] then
                        defaults = self.BFA_DEFAULTS[dungeonKey]
                    elseif self.CATACLYSM_DUNGEON_IDS[dungeonKey] then
                        defaults = self.CATACLYSM_DEFAULTS[dungeonKey]
                    end
                    
                    if defaults then
                        text = text .. string.format("|cffffd700%s|r:\n", L[dungeonKey])
                        if defaults.BossOne then
                            text = text .. string.format("  %s: %.2f%%\n", L[dungeonKey.."_BOSS1"], defaults.BossOne)
                        end
                        if defaults.BossTwo then
                            text = text .. string.format("  %s: %.2f%%\n", L[dungeonKey.."_BOSS2"], defaults.BossTwo)
                        end
                        if defaults.BossThree then
                            text = text .. string.format("  %s: %.2f%%\n", L[dungeonKey.."_BOSS3"], defaults.BossThree)
                        end
                        if defaults.BossFour then
                            text = text .. string.format("  %s: %.2f%%\n", L[dungeonKey.."_BOSS4"], defaults.BossFour)
                        end
                        text = text .. "\n"
                    end
                end
                
                return text
            end
        }
    }
    
    -- Add dungeon options in sorted order
    for _, dungeon in ipairs(currentSeasonDungeons) do
        local dungeonKey = dungeon.key
        dungeonArgs[dungeonKey] = currentSeasonOptions[dungeonKey]
    end

    return {
        name = L["ADVANCED_SETTINGS"],
        type = "group",
        childGroups = "tree",
        order = 2,
        args = {
            header = {
                name = L["TANK_GROUP_HEADER"],
                type = "header",
                order = 1,
            },
            enabled = {
                name = L["ENABLE_ADVANCED_OPTIONS"],
                desc = L["ADVANCED_OPTIONS_DESC"],
                type = "toggle",
                order = 2,
                get = function() return self.db.profile.general.advancedOptionsEnabled end,
                set = function(_, value)
                    self.db.profile.general.advancedOptionsEnabled = value
                    self:UpdateDungeonData()
                end
            },
            dungeons = {
                name = L["CURRENT_SEASON"],
                type = "group",
                childGroups = "tree",
                order = 3,
                args = dungeonArgs
            },
            war_within = {
                name = L["EXPANSION_WW"],
                type = "group",
                childGroups = "tree",
                order = 4,
                args = {
                    AKCE = sharedDungeonOptions.AKCE,
                    CoT = sharedDungeonOptions.CoT,
                    TSV = sharedDungeonOptions.TSV,
                    TDB = sharedDungeonOptions.TDB
                }
            },
            dragonflight = {
                name = L["EXPANSION_DF"],
                type = "group",
                childGroups = "tree",
                order = 5,
                args = {}
            },
            shadowlands = {
                name = L["EXPANSION_SL"],
                type = "group",
                childGroups = "tree",
                order = 6,
                args = {
                    MoTS = sharedDungeonOptions.MoTS,
                    NW = sharedDungeonOptions.NW
                }
            },
            bfa = {
                name = L["EXPANSION_BFA"],
                type = "group",
                childGroups = "tree",
                order = 7,
                args = {
                    SoB = sharedDungeonOptions.SoB
                }
            },
            cataclysm = {
                name = L["EXPANSION_CATA"],
                type = "group",
                childGroups = "tree",
                order = 8,
                args = {
                    GB = sharedDungeonOptions.GB
                }
            }
        }
    }
end

function KeystonePercentageHelper:CreateDungeonOptions(dungeonKey, order)
    local numBosses = #self.DUNGEONS[self:GetDungeonIdByKey(dungeonKey)]
    local options = {
        name = L[dungeonKey] or dungeonKey,
        type = "group",
        order = order,
        args = {
            reset = {
                order = 0,
                type = "execute",
                name = L["RESET_DUNGEON"],
                desc = L["RESET_DUNGEON_DESC"],
                func = function()
                    local dungeonId = self:GetDungeonIdByKey(dungeonKey)
                    if dungeonId and self.DUNGEONS[dungeonId] then
                        -- Reset all boss percentages and inform group settings for this dungeon to defaults
                        if not self.db.profile.advanced[dungeonKey] then
                            self.db.profile.advanced[dungeonKey] = {}
                        end

                        -- Get the appropriate defaults
                        local defaults
                        if self.WW_DUNGEON_IDS[dungeonKey] then
                            defaults = self.WW_DEFAULTS[dungeonKey]
                        elseif self.SL_DUNGEON_IDS[dungeonKey] then
                            defaults = self.SL_DEFAULTS[dungeonKey]
                        elseif self.BFA_DUNGEON_IDS[dungeonKey] then
                            defaults = self.BFA_DEFAULTS[dungeonKey]
                        elseif self.CATACLYSM_DUNGEON_IDS[dungeonKey] then
                            defaults = self.CATACLYSM_DEFAULTS[dungeonKey]
                        end

                        if defaults then
                            for key, value in pairs(defaults) do
                                self.db.profile.advanced[dungeonKey][key] = value
                            end
                        end
                        
                        -- Update the display
                        self:UpdateDungeonData()
                        LibStub("AceConfigRegistry-3.0"):NotifyChange("KeystonePercentageHelper")
                    end
                end,
                confirm = true,
                confirmText = L["RESET_DUNGEON_CONFIRM"],
            },
            header = {
                name = L["TANK_GROUP_HEADER"],
                type = "header",
                order = 1,
            },
        }
    }
    
    for i = 1, numBosses do
        local bossNumStr = i == 1 and "One" or i == 2 and "Two" or i == 3 and "Three" or "Four"
        local bossName = L[dungeonKey.."_BOSS"..i] or ("Boss "..i)
        
        -- Create a group for each boss line
        options.args["boss"..i] = {
            type = "group",
            name = bossName,
            inline = true,
            order = i + 2,
            args = {
                percent = {
                    name = L["PERCENTAGE"],
                    type = "range",
                    min = 0,
                    max = 100,
                    step = 0.01,
                    order = 1,
                    width = 1,
                    get = function() return self.db.profile.advanced[dungeonKey]["Boss"..bossNumStr] end,
                    set = function(_, value)
                        self.db.profile.advanced[dungeonKey]["Boss"..bossNumStr] = value
                        self:UpdateDungeonData()
                    end
                },
                inform = {
                    name = L["INFORM_GROUP"],
                    type = "toggle",
                    order = 2,
                    width = 1,
                    get = function() return self.db.profile.advanced[dungeonKey]["Boss" .. bossNumStr .. "Inform"] end,
                    set = function(_, value)
                        self.db.profile.advanced[dungeonKey]["Boss" .. bossNumStr .. "Inform"] = value
                        self:UpdateDungeonData()
                    end
                }
            }
        }
    end
    return options
end

function KeystonePercentageHelper:GetDungeonKeyById(dungeonId)
    -- Check War Within dungeons
    for key, id in pairs(self.WW_DUNGEON_IDS or {}) do
        if id == dungeonId then return key end
    end
    -- Check Shadowlands dungeons
    for key, id in pairs(self.SL_DUNGEON_IDS or {}) do
        if id == dungeonId then return key end
    end
    -- Check BFA dungeons
    for key, id in pairs(self.BFA_DUNGEON_IDS or {}) do
        if id == dungeonId then return key end
    end
    -- Check Cataclysm dungeons
    for key, id in pairs(self.CATACLYSM_DUNGEON_IDS or {}) do
        if id == dungeonId then return key end
    end
    return nil
end

function KeystonePercentageHelper:OnInitialize()
    LoadExpansionDungeons()
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
            },
            advanced = self:GetAdvancedOptions()
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
    
    -- Update dungeon data with advanced options if enabled
    self:UpdateDungeonData()
    
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
                get = function() return self.db.profile.color.inProgress.r, self.db.profile.color.inProgress.g, self.db.profile.color.inProgress.b, self.db.profile.color.inProgress.a end,
                set = function(_, r, g, b, a)
                    local color = self.db.profile.color.inProgress
                    color.r, color.g, color.b, color.a = r, g, b, a
                    self:Refresh()
                end
            },
            finishedColor = {
                name = "Finished",
                type = "color",
                hasAlpha = true,
                order = 2,
                get = function() return self.db.profile.color.finished.r, self.db.profile.color.finished.g, self.db.profile.color.finished.b, self.db.profile.color.finished.a end,
                set = function(_, r, g, b, a)
                    local color = self.db.profile.color.finished
                    color.r, color.g, color.b, color.a = r, g, b, a
                    self:Refresh()
                end
            },
            missingColor = {
                name = "Missing",
                type = "color",
                hasAlpha = true,
                order = 3,
                get = function() return self.db.profile.color.missing.r, self.db.profile.color.missing.g, self.db.profile.color.missing.b, self.db.profile.color.missing.a end,
                set = function(_, r, g, b, a)
                    local color = self.db.profile.color.missing
                    color.r, color.g, color.b, color.a = r, g, b, a
                    self:Refresh()
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
                get = function() return self.db.profile.general.position end,
                set = function(_, value)
                    self.db.profile.general.position = value
                    self:Refresh()
                end
            },
            xOffset = {
                name = "X Offset",
                type = "range",
                order = 2,
                min = -500,
                max = 500,
                step = 1,
                get = function() return self.db.profile.general.xOffset end,
                set = function(_, value)
                    self.db.profile.general.xOffset = value
                    self:Refresh()
                end
            },
            yOffset = {
                name = "Y Offset",
                type = "range",
                order = 3,
                min = -500,
                max = 500,
                step = 1,
                get = function() return self.db.profile.general.yOffset end,
                set = function(_, value)
                    self.db.profile.general.yOffset = value
                    self:Refresh()
                end
            }
        }
    }
end

function KeystonePercentageHelper:UpdateDungeonData()
    if self.db.profile.general.advancedOptionsEnabled then
        for dungeonId, dungeonData in pairs(self.DUNGEONS) do
            local dungeonKey = self:GetDungeonKeyById(dungeonId)
            if dungeonKey and self.db.profile.advanced[dungeonKey] then
                local advancedData = self.db.profile.advanced[dungeonKey]
                for i, bossData in ipairs(dungeonData) do
                    local bossNumStr = i == 1 and "One" or i == 2 and "Two" or i == 3 and "Three" or "Four"
                    bossData[2] = advancedData["Boss"..bossNumStr]
                    bossData[3] = advancedData["Boss" .. bossNumStr .. "Inform"]
                    bossData[4] = false -- Reset informed status
                end
            end
        end
    end
end

function KeystonePercentageHelper:GetDungeonIdByKey(dungeonKey)
    local dungeonIds = {
        ["AKCE"] = 503,
        ["CoT"] = 502,
        ["GB"] = 507,
        ["MoTS"] = 375,
        ["SoB"] = 353,
        ["TDB"] = 505,
        ["NW"] = 376,
        ["TSV"] = 501
    }
    return dungeonIds[dungeonKey]
end