local AddOnName, KeystonePercentageHelper = ...;

local _G = _G;
local pairs, unpack, select = pairs, unpack, select
local format = string.format
local gsub = string.gsub
local strsplit = strsplit

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName, true);
KeystonePercentageHelper.L = L

KeystonePercentageHelper.defaults = {
    profile = {
        general = {
            fontSize = 12,
            position = "CENTER",
            xOffset = 0,
            yOffset = 0,
            informGroup = true,
            informChannel = "PARTY",
            advancedOptionsEnabled = false,
            lastSeasonCheck = "",
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

-- List of expansions and their corresponding data
local expansions = {
    {id = "TWW", name = "EXPANSION_WW", order = 4},        -- The War Within
    --{id = "DF", name = "EXPANSION_DF", order = 5},         -- Dragonflight
    {id = "SL", name = "EXPANSION_SL", order = 6},         -- Shadowlands
    {id = "BFA", name = "EXPANSION_BFA", order = 7},       -- Battle for Azeroth
    --{id = "LEGION", name = "EXPANSION_LEGION", order = 8}, -- Legion
    --{id = "WOD", name = "EXPANSION_WOD", order = 9},       -- Warlords of Draenor
    --{id = "MOP", name = "EXPANSION_MOP", order = 10},      -- Mists of Pandaria
    {id = "CATACLYSM", name = "EXPANSION_CATA", order = 11}, -- Cataclysm
    --{id = "TBC", name = "EXPANSION_TBC", order = 12} -- The Burning Crusade
    --{id = "Vanilla", name = "EXPANSION_VANILLA", order = 12} -- Vanilla WoW
}

KeystonePercentageHelper.SEASON_START_DATES = {
    ["2024-09-10"] = true,  -- TWW Season 1 start date
    --["2025-03-08"] = true,  -- TWW Season 2 start date
}

-- Load defaults from all expansions
for _, expansion in ipairs(expansions) do
    local defaults = KeystonePercentageHelper[expansion.id .. "_DEFAULTS"]
    if defaults then
        for k, v in pairs(defaults) do
            KeystonePercentageHelper.defaults.profile.advanced[k] = v
        end
    end
end

function KeystonePercentageHelper:GetDungeonKeyById(dungeonId)
    -- Check all expansions for the dungeon ID
    for _, expansion in ipairs(expansions) do
        local dungeonIds = self[expansion.id .. "_DUNGEON_IDS"]
        if dungeonIds then
            for key, id in pairs(dungeonIds) do
                if id == dungeonId then
                    return key
                end
            end
        end
    end
    return nil
end

function KeystonePercentageHelper:LoadExpansionDungeons()
    -- Load dungeons from all expansions
    for _, expansion in ipairs(expansions) do
        local dungeons = KeystonePercentageHelper[expansion.id .. "_DUNGEONS"]
        if dungeons then
            for id, data in pairs(dungeons) do
                KeystonePercentageHelper.DUNGEONS[id] = data
            end
        end
    end
end

function KeystonePercentageHelper:GetDungeonIdByKey(dungeonKey)
    -- Check each expansion's dungeon IDs table
    for _, expansion in ipairs(expansions) do
        local dungeonIds = self[expansion.id .. "_DUNGEON_IDS"]
        if dungeonIds and dungeonIds[dungeonKey] then
            return dungeonIds[dungeonKey]
        end
    end
    return nil
end

function KeystonePercentageHelper:GetPositioningOptions()
    local self = KeystonePercentageHelper
    return {
        name = L["POSITIONING"],
        type = "group",
        inline = true,
        args = {
            showAnchor = {
                name = L["SHOW_ANCHOR"],
                type = "execute",
                order = 1,
                width = 2,
                func = function()
                    if self.anchorFrame then
                        self.anchorFrame:Show()
                        self.overlayFrame:Show()
                        -- Hide the WoW settings frame
                        HideUIPanel(SettingsPanel)
                    end
                end
            },
            position = {
                name = L["POSITION"],
                type = "select",
                order = 2,
                values = {
                    TOP = L["TOP"],
                    CENTER = L["CENTER"],
                    BOTTOM = L["BOTTOM"]
                },
                get = function() return self.db.profile.general.position end,
                set = function(_, value)
                    self.db.profile.general.position = value
                    self:Refresh()
                end
            },
            xOffset = {
                name = L["X_OFFSET"],
                type = "range",
                order = 3,
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
                name = L["Y_OFFSET"],
                type = "range",
                order = 4,
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

function KeystonePercentageHelper:GetFontOptions()
    local self = KeystonePercentageHelper
    return {
        name = L["FONT"],
        type = "group",
        inline = true,
        order = 5.5,
        args = {
            font = {
                name = L["FONT"],
                type = "select",
                dialogControl = 'LSM30_Font',
                order = 1,
                values = AceGUIWidgetLSMlists.font,
                style = "dropdown",
                get = function() return self.db.profile.text.font end,
                set = function(_, value)
                    self.db.profile.text.font = value
                    self:Refresh()
                end
            },
            fontSize = {
                name = L["FONT_SIZE"],
                desc = L["FONT_SIZE_DESC"],
                type = "range",
                order = 2,
                min = 8,
                max = 24,
                step = 1,
                get = function() return self.db.profile.general.fontSize end,
                set = function(_, value)
                    self.db.profile.general.fontSize = value
                    self:Refresh()
                end
            }
        }
    }
end

function KeystonePercentageHelper:GetColorOptions()
    local self = KeystonePercentageHelper
    return {
        name = L["COLORS"],
        type = "group",
        inline = true,
        order = 6,
        args = {
            inProgress = {
                name = L["IN_PROGRESS"],
                type = "color",
                order = 1,
                hasAlpha = true,
                get = function()
                    local color = self.db.profile.color.inProgress
                    return color.r, color.g, color.b, color.a
                end,
                set = function(_, r, g, b, a)
                    local color = self.db.profile.color.inProgress
                    color.r, color.g, color.b, color.a = r, g, b, a
                    self:Refresh()
                end
            },
            finished = {
                name = L["FINISHED"],
                type = "color",
                order = 2,
                hasAlpha = true,
                get = function()
                    local color = self.db.profile.color.finished
                    return color.r, color.g, color.b, color.a
                end,
                set = function(_, r, g, b, a)
                    local color = self.db.profile.color.finished
                    color.r, color.g, color.b, color.a = r, g, b, a
                    self:Refresh()
                end
            },
            missing = {
                name = L["MISSING"],
                type = "color",
                order = 3,
                hasAlpha = true,
                get = function()
                    local color = self.db.profile.color.missing
                    return color.r, color.g, color.b, color.a
                end,
                set = function(_, r, g, b, a)
                    local color = self.db.profile.color.missing
                    color.r, color.g, color.b, color.a = r, g, b, a
                    self:Refresh()
                end
            }
        }
    }
end

function KeystonePercentageHelper:GetOtherOptions()
    return {
        name = L["OPTIONS"],
        type = "group",
        inline = true,
        order = 10,
        args = {
            informGroup = {
                name = L["INFORM_GROUP"],
                desc = L["INFORM_GROUP_DESC"],
                type = "toggle",
                order = 10,
                get = function() return self.db.profile.general.informGroup end,
                set = function(_, value)
                    self.db.profile.general.informGroup = value
                end
            },
            informChannel = {
                name = L["MESSAGE_CHANNEL"],
                desc = L["MESSAGE_CHANNEL_DESC"],
                type = "select",
                order = 11,
                values = {
                    PARTY = L["PARTY"],
                    SAY = L["SAY"],
                    YELL = L["YELL"]
                },
                disabled = function() return not self.db.profile.general.informGroup end,
                get = function() return self.db.profile.general.informChannel end,
                set = function(_, value)
                    self.db.profile.general.informChannel = value
                end
            },
            enabled = {
                name = L["ENABLE_ADVANCED_OPTIONS"],
                desc = L["ADVANCED_OPTIONS_DESC"],
                type = "toggle",
                width = "full",
                order = 12,
                get = function() return self.db.profile.general.advancedOptionsEnabled end,
                set = function(_, value)
                    self.db.profile.general.advancedOptionsEnabled = value
                    self:UpdateDungeonData()
                end
            }
        }
    }
end

function KeystonePercentageHelper:GetAdvancedOptions()
    local self = KeystonePercentageHelper
    -- Helper function to get dungeon name with icon
    local function GetDungeonNameWithIcon(dungeonKey)
        local icon = self.dungeonIcons and self.dungeonIcons[dungeonKey] or ""
        return '|T' .. icon .. ":20:20:0:0|t " .. L[dungeonKey]
    end

    -- Helper function to format dungeon text
    local function FormatDungeonText(self, dungeonKey, defaults)
        local text = ""
        if defaults then
            text = text .. "|cffffd700" .. GetDungeonNameWithIcon(dungeonKey) .. "|r:\n"
            local bossNum = 1
            while defaults["Boss" .. self:GetBossNumberString(bossNum)] do
                local bossKey = "Boss" .. self:GetBossNumberString(bossNum)
                local informKey = bossKey .. "Inform"
                text = text .. string.format("  %s: |cff40E0D0%.2f%%|r - Inform group: %s\n",
                    L[dungeonKey .. "_BOSS" .. bossNum],
                    defaults[bossKey],
                    defaults[informKey] and '|cff00ff00Yes|r' or '|cffff0000No|r')
                bossNum = bossNum + 1
            end
            text = text .. "\n"
        end
        return text
    end

    -- Create shared dungeon options
    local sharedDungeonOptions = {}
    for _, expansion in ipairs(expansions) do
        local dungeonIds = self[expansion.id .. "_DUNGEON_IDS"]
        if dungeonIds then
            for dungeonKey, dungeonId in pairs(dungeonIds) do
                sharedDungeonOptions[dungeonKey] = self:CreateDungeonOptions(dungeonKey, 0)
            end
        end
    end

    -- Create expansion-specific dungeon args
    local function CreateExpansionDungeonArgs(dungeonIds, defaults)
        local args = {
            defaultPercentages = {
                order = 0,
                type = "description",
                fontSize = "medium",
                name = function()
                    local text = L["DEFAULT_PERCENTAGES"] .. ":\n\n"
                    for dungeonKey, _ in pairs(dungeonIds or {}) do
                        if defaults and defaults[dungeonKey] then
                            text = text .. FormatDungeonText(self, dungeonKey, defaults[dungeonKey])
                        end
                    end
                    return text
                end
            }
        }
        
        -- Add dungeon options
        if dungeonIds then
            for dungeonKey, _ in pairs(dungeonIds) do
                args[dungeonKey] = sharedDungeonOptions[dungeonKey]
            end
        end
        
        return args
    end

    -- Create current season options
    local currentSeasonDungeons = {}
    
    -- Collect all current season dungeons
    for _, expansion in ipairs(expansions) do
        local dungeonIds = self[expansion.id .. "_DUNGEON_IDS"]
        if dungeonIds then
            for dungeonKey, dungeonId in pairs(dungeonIds) do
                if self:IsCurrentSeasonDungeon(dungeonId) then
                    table.insert(currentSeasonDungeons, {key = dungeonKey, id = dungeonId})
                end
            end
        end
    end
    
    -- Sort dungeons alphabetically by their localized names
    table.sort(currentSeasonDungeons, function(a, b)
        return L[a.key] < L[b.key]
    end)

    -- Create current season dungeon args
    local dungeonArgs = {
        defaultPercentages = {
            order = 0,
            type = "description",
            fontSize = "medium",
            name = function()
                local text = L["DEFAULT_PERCENTAGES"] .. ":\n\n"
                for _, dungeon in ipairs(currentSeasonDungeons) do
                    local dungeonKey = dungeon.key
                    local defaults
                    for _, expansion in ipairs(expansions) do
                        if self[expansion.id .. "_DUNGEON_IDS"][dungeonKey] then
                            defaults = self[expansion.id .. "_DEFAULTS"][dungeonKey]
                            break
                        end
                    end
                    
                    text = text .. FormatDungeonText(self, dungeonKey, defaults)
                end
                return text
            end
        }
    }
    
    -- Add current season dungeon options
    for _, dungeon in ipairs(currentSeasonDungeons) do
        dungeonArgs[dungeon.key] = sharedDungeonOptions[dungeon.key]
    end

    -- Create next season dungeon args
    local nextSeasonDungeons = {}
    
    -- Collect all next season dungeons
    for _, expansion in ipairs(expansions) do
        local dungeonIds = self[expansion.id .. "_DUNGEON_IDS"]
        if dungeonIds then
            for dungeonKey, dungeonId in pairs(dungeonIds) do
                if self:IsNextSeasonDungeon(dungeonId) then
                    table.insert(nextSeasonDungeons, {key = dungeonKey, id = dungeonId})
                end
            end
        end
    end
    
    -- Sort dungeons alphabetically by their localized names
    table.sort(nextSeasonDungeons, function(a, b)
        return L[a.key] < L[b.key]
    end)

    -- Create next season dungeon args
    local nextSeasonDungeonArgs = {
        defaultPercentages = {
            order = 0,
            type = "description",
            fontSize = "medium",
            name = function()
                local text = L["DEFAULT_PERCENTAGES"] .. ":\n\n"
                for _, dungeon in ipairs(nextSeasonDungeons) do
                    local dungeonKey = dungeon.key
                    local defaults
                    for _, expansion in ipairs(expansions) do
                        if self[expansion.id .. "_DUNGEON_IDS"][dungeonKey] then
                            defaults = self[expansion.id .. "_DEFAULTS"][dungeonKey]
                            break
                        end
                    end
                    
                    text = text .. FormatDungeonText(self, dungeonKey, defaults)
                end
                return text
            end
        }
    }
    
    -- Add next season dungeon options
    for _, dungeon in ipairs(nextSeasonDungeons) do
        nextSeasonDungeonArgs[dungeon.key] = sharedDungeonOptions[dungeon.key]
    end

    -- Create expansion sections
    local args = {
        resetAll = {
            order = 1,
            type = "execute",
            name = L["RESET_ALL_DUNGEONS"],
            desc = L["RESET_ALL_DUNGEONS_DESC"],
            confirm = true,
            confirmText = L["RESET_ALL_DUNGEONS_CONFIRM"],
            func = function()
                -- Reset all dungeons to their defaults
                self:ResetAllDungeons()
            end
        },
        dungeons = {
            name = "|cff40E0D0" .. L["CURRENT_SEASON"] .. "|r",
            type = "group",
            childGroups = "tree",
            order = 3,
            args = dungeonArgs
        },
        nextseason = {
            name = "|cffff5733" .. L["NEXT_SEASON"] .. "|r",
            type = "group",
            childGroups = "tree",
            order = 4,
            args = nextSeasonDungeonArgs
        }
    }

    -- Add expansion sections
    for _, expansion in ipairs(expansions) do
        local sectionKey = expansion.id:lower()
        args[sectionKey] = {
            name = "|cffffffff" .. L[expansion.name] .. "|r",
            type = "group",
            childGroups = "tree",
            order = expansion.order + 4,  -- Shift expansion orders to after next season
            args = CreateExpansionDungeonArgs(self[expansion.id .. "_DUNGEON_IDS"], self[expansion.id .. "_DEFAULTS"])
        }
    end

    return {
        name = L["ADVANCED_SETTINGS"],
        type = "group",
        childGroups = "tree",
        order = 2,
        args = args
    }
end

function KeystonePercentageHelper:CreateDungeonOptions(dungeonKey, order)
    local numBosses = #self.DUNGEONS[self:GetDungeonIdByKey(dungeonKey)]
    local options = {
        name = function()
            local icon = self.dungeonIcons and self.dungeonIcons[dungeonKey] or ""
            return '|T' .. icon .. ":16:16:0:0|t " .. (L[dungeonKey] or dungeonKey)
        end,
        type = "group",
        order = order,
        args = {
            dungeonHeader = {
                order = 0,
                type = "description",
                fontSize = "large",
                name = function()
                    local icon = self.dungeonIcons and self.dungeonIcons[dungeonKey] or ""
                    return "|T" .. icon .. ":20:20:0:0|t |cff40E0D0" .. (L[dungeonKey] or dungeonKey) .. "|r"
                end,
            },
            dungeonSecondHeader = {
                type = "header",
                name = "",
                order = 1,
            },
            reset = {
                order = 2,
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
                        for _, expansion in ipairs(expansions) do
                            if self[expansion.id .. "_DUNGEON_IDS"][dungeonKey] then
                                defaults = self[expansion.id .. "_DEFAULTS"][dungeonKey]
                                break
                            end
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
                order = 3,
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
            order = i + 3,  -- Start boss orders at 4 (after header)
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

function KeystonePercentageHelper:ToggleConfig()
    Settings.OpenToCategory("Keystone Percentage Helper")
end

function KeystonePercentageHelper:CreateColorString(text, db)
    local hex = db.r and db.g and db.b and self:RGBToHex(db.r, db.g, db.b) or
                    "|cffffffff"

    local string = hex .. text .. "|r"
    return string
end

function KeystonePercentageHelper:RGBToHex(r, g, b, header, ending)
    r = r <= 1 and r >= 0 and r or 1
    g = g <= 1 and g >= 0 and g or 1
    b = b <= 1 and b >= 0 and b or 1

    local hex = format('%s%02x%02x%02x%s', header or '|cff', r * 255, g * 255,
                       b * 255, ending or '')
    return hex
end

function KeystonePercentageHelper:GenerateChangelog()
    self.changelogOptions = {
        type = "group",
        childGroups = "select",
        name = L["Changelog"],
        args = {}
    }

    if not self.Changelog or type(self.Changelog) ~= "table" then
        return
    end

    local function orange(string)
        if type(string) ~= "string" then string = tostring(string) end
        string = self:CreateColorString(string, {r = 0.859, g = 0.388, b = 0.203})
        return string
    end

    local function renderChangelogLine(line)
        line = gsub(line, "%[[^%[]+%]", orange)
        return line
    end

    -- Remove the "no changelog" entry if we have actual entries
    self.changelogOptions.args.noChangelog = nil

    for version, data in pairs(self.Changelog) do
        if type(data) == "table" and data.version_string and data.release_date then
            local versionString = data.version_string
            local dateTable = {strsplit("/", data.release_date)}
            local dateString = data.release_date
            if #dateTable == 3 then
                dateString = L["%month%-%day%-%year%"]
                dateString = gsub(dateString, "%%year%%", dateTable[1])
                dateString = gsub(dateString, "%%month%%", dateTable[2])
                dateString = gsub(dateString, "%%day%%", dateTable[3])
            end

            self.changelogOptions.args[tostring(version)] = {
                order = 10000 - version,
                name = versionString,
                type = "group",
                args = {
                    version = {
                        order = 2,
                        type = "description",
                        name = L["Version"] .. " " .. orange(versionString) ..
                            " - |cffbbbbbb" .. dateString .. "|r",
                        fontSize = "large"
                    }
                }
            }

            local page = self.changelogOptions.args[tostring(version)].args

            -- Checking localized "Important" category
            local important_localized = {}
            if data.important and data.important[GetLocale()] and next(data.important[GetLocale()]) then
                important_localized = data.important[GetLocale()]
            elseif data.important and data.important["enUS"] then
                important_localized = data.important["enUS"]
            end

            if important_localized and #important_localized > 0 then
                page.importantHeader = {
                    order = 3,
                    type = "header",
                    name = orange(L["Important"])
                }
                page.important = {
                    order = 4,
                    type = "description",
                    name = function()
                        local text = ""
                        for index, line in ipairs(important_localized) do
                            text = text .. index .. ". " ..
                                       renderChangelogLine(line) .. "\n"
                        end
                        return text .. "\n"
                    end,
                    fontSize = "medium"
                }
            end

            -- Checking localized "New" category
            local new_localized = {}
            if data.new and data.new[GetLocale()] and next(data.new[GetLocale()]) then
                new_localized = data.new[GetLocale()]
            elseif data.new and data.new["enUS"] then
                new_localized = data.new["enUS"]
            end

            if new_localized and #new_localized > 0 then
                page.newHeader = {
                    order = 5,
                    type = "header",
                    name = orange(L["New"])
                }
                page.new = {
                    order = 6,
                    type = "description",
                    name = function()
                        local text = ""
                        for index, line in ipairs(new_localized) do
                            text = text .. index .. ". " ..
                                       renderChangelogLine(line) .. "\n"
                        end
                        return text .. "\n"
                    end,
                    fontSize = "medium"
                }
            end

            -- Checking localized "Bugfix" category
            local bugfix_localized = {}
            if data.bugfix and data.bugfix[GetLocale()] and next(data.bugfix[GetLocale()]) then
                bugfix_localized = data.bugfix[GetLocale()]
            elseif data.bugfix and data.bugfix["enUS"] then
                bugfix_localized = data.bugfix["enUS"]
            end

            if bugfix_localized and #bugfix_localized > 0 then
                page.bugfixHeader = {
                    order = 7,
                    type = "header",
                    name = orange(L["Bugfixes"])
                }
                page.bugfix = {
                    order = 8,
                    type = "description",
                    name = function()
                        local text = ""
                        for index, line in ipairs(bugfix_localized) do
                            text = text .. index .. ". " ..
                                       renderChangelogLine(line) .. "\n"
                        end
                        return text .. "\n"
                    end,
                    fontSize = "medium"
                }
            end

            -- Checking localized "Improvment" category
            local improvment_localized = {}
            if data.improvment and data.improvment[GetLocale()] and next(data.improvment[GetLocale()]) then
                improvment_localized = data.improvment[GetLocale()]
            elseif data.improvment and data.improvment["enUS"] then
                improvment_localized = data.improvment["enUS"]
            end

            if improvment_localized and #improvment_localized > 0 then
                page.improvmentHeader = {
                    order = 7,
                    type = "header",
                    name = orange(L["Improvment"])
                }
                page.improvment = {
                    order = 8,
                    type = "description",
                    name = function()
                        local text = ""
                        for index, line in ipairs(improvment_localized) do
                            text = text .. index .. ". " ..
                                       renderChangelogLine(line) .. "\n"
                        end
                        return text .. "\n"
                    end,
                    fontSize = "medium"
                }
            end
        end
    end
end

function KeystonePercentageHelper:GetBossNumberString(num)
    local numbers = {
        [1] = "One",
        [2] = "Two",
        [3] = "Three",
        [4] = "Four",
        [5] = "Five",
        [6] = "Six",
        [7] = "Seven",
        [8] = "Eight",
        [9] = "Nine",
        [10] = "Ten"
    }
    return numbers[num] or tostring(num)
end

function KeystonePercentageHelper:ResetAllDungeons()
    local self = KeystonePercentageHelper
    -- Reset all dungeons to their defaults
    for _, expansion in ipairs(expansions) do
        local dungeonIds = self[expansion.id .. "_DUNGEON_IDS"]
        if dungeonIds then
            for dungeonKey, _ in pairs(dungeonIds) do
                -- Get the appropriate defaults
                local defaults
                for _, expansion in ipairs(expansions) do
                    if self[expansion.id .. "_DUNGEON_IDS"][dungeonKey] then
                        defaults = self[expansion.id .. "_DEFAULTS"][dungeonKey]
                        break
                    end
                end

                if defaults then
                    if not self.db.profile.advanced[dungeonKey] then
                        self.db.profile.advanced[dungeonKey] = {}
                    end
                    for key, value in pairs(defaults) do
                        self.db.profile.advanced[dungeonKey][key] = value
                    end
                end
            end
        end
    end
    
    -- Update the display
    self:UpdateDungeonData()
    LibStub("AceConfigRegistry-3.0"):NotifyChange("KeystonePercentageHelper")
end

function KeystonePercentageHelper:CheckForNewSeason()
    local self = KeystonePercentageHelper
    local currentDate = date("%Y-%m-%d", time())
    
    -- If this is first load (lastSeasonCheck is empty), just set the date and don't show popup
    if self.db.profile.lastSeasonCheck == "" then
        self.db.profile.lastSeasonCheck = currentDate
        return
    end
    
    -- Find the most recent season start date
    local mostRecentSeasonDate = nil
    for seasonDate, _ in pairs(self.SEASON_START_DATES) do
        if seasonDate <= currentDate and (not mostRecentSeasonDate or seasonDate > mostRecentSeasonDate) then
            mostRecentSeasonDate = seasonDate
        end
    end
    
    -- If last check was before the most recent season start, show popup
    if mostRecentSeasonDate and self.db.profile.lastSeasonCheck < mostRecentSeasonDate and not InCombatLockdown() then    
        StaticPopupDialogs["KPH_NEW_SEASON"] = {
            text = "|cffffd100Keystone Percentage Helper|r\n\n" .. L["NEW_SEASON_RESET_PROMPT"] .. "\n\n",
            button1 = YES,
            button2 = NO,
            OnAccept = function()
                -- Reset only current season dungeon values
                self:ResetCurrentSeasonDungeons()
                self.db.profile.lastSeasonCheck = currentDate
            end,
            OnCancel = function()
                self.db.profile.lastSeasonCheck = currentDate
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
            showAlert = true,
            title = "Keystone Percentage Helper",
        }
        StaticPopup_Show("KPH_NEW_SEASON")
    end
end

function KeystonePercentageHelper:ResetCurrentSeasonDungeons()
    local self = KeystonePercentageHelper
    -- Reset only the current season dungeons to their defaults
    for dungeonId, _ in pairs(self.CURRENT_SEASON_DUNGEONS) do
        local dungeonKey = self:GetDungeonKeyById(dungeonId)
        if dungeonKey then
            -- Find the appropriate defaults for this dungeon
            local defaults
            for _, expansion in ipairs(expansions) do
                if self[expansion.id .. "_DUNGEON_IDS"][dungeonKey] then
                    defaults = self[expansion.id .. "_DEFAULTS"][dungeonKey]
                    break
                end
            end

            if defaults then
                if not self.db.profile.advanced[dungeonKey] then
                    self.db.profile.advanced[dungeonKey] = {}
                end
                for key, value in pairs(defaults) do
                    self.db.profile.advanced[dungeonKey][key] = value
                end
            end
        end
    end
    
    -- Update the display
    self:UpdateDungeonData()
    LibStub("AceConfigRegistry-3.0"):NotifyChange("KeystonePercentageHelper")
end