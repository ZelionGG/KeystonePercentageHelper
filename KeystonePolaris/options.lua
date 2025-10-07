local AddOnName, KeystonePolaris = ...;

local _G = _G;
local pairs, unpack, select = pairs, unpack, select
local format = string.format
local gsub = string.gsub
local strsplit = strsplit

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

-- ---------------------------------------------------------------------------
-- Helper utilities
-- ---------------------------------------------------------------------------
-- Shallow-clone a table. If the WoW utility `CopyTable` exists we use it,
-- otherwise fall back to manual copy. This is needed so that changing the
-- `order` field for one AceConfig option group does not overwrite the value
-- used in another section.
local function CloneTable(tbl)
    if type(CopyTable) == "function" then return CopyTable(tbl) end
    local t = {}
    for k, v in pairs(tbl) do t[k] = v end
    return t
end

-- Insert dungeon option groups into an AceConfig args table in alphabetical
-- order. Every option is cloned from `sharedOptions[key]`, placed after the
-- section headers (offset with `baseOrder`), and assigned its own `order` so
-- AceConfig displays them deterministically.
--   addon        : reference to KeystonePolaris for helper calls
--   dungeonKeys  : array of dungeon string keys (short names)
--   sharedOptions: table containing pre-built option groups for each dungeon
--   targetArgs   : the args table we are populating (e.g., dungeonArgs)
--   baseOrder    : numeric order to start from (usually 3)
local function InsertSortedDungeonOptions(addon, dungeonKeys, sharedOptions, targetArgs, baseOrder)
    local sortable = {}
    for _, key in ipairs(dungeonKeys) do
        local mapId = addon:GetDungeonIdByKey(key)
        local name = (mapId and select(1, C_ChallengeMode.GetMapUIInfo(mapId))) or key
        table.insert(sortable, { key = key, name = name })
    end
    table.sort(sortable, function(a, b) return a.name < b.name end)

    for idx, entry in ipairs(sortable) do
        local opt = CloneTable(sharedOptions[entry.key])
        opt.order = baseOrder + idx
        targetArgs[entry.key] = opt
    end
end

local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName, true);
KeystonePolaris.L = L

KeystonePolaris.defaults = {
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
            lastVersionCheck = "",
            rolesEnabled = {
                LEADER = true,
                TANK = true,
                HEALER = true,
                DAMAGER = true
            },
            -- Main display content options
            mainDisplay = {
                showCurrentPercent = true,            -- Show overall current enemy forces percent
                showCurrentPullPercent = true,        -- Show current MDT pull percent (if MDT is available)
                multiLine = true,                     -- Display extras on new lines instead of a single line
                showRequiredText = true,              -- Show the required/remaining text base
                requiredLabel = L["REQUIRED_DEFAULT"], -- Label for the required base value when numeric
                showSectionRequiredText = false,       -- Show the required/remaining text base
                sectionRequiredLabel = L["SECTION_REQUIRED_DEFAULT"], -- Label for the required base value when numeric
                currentLabel = L["CURRENT_DEFAULT"],   -- Label for current percent
                pullLabel = L["PULL_DEFAULT"],         -- Label for current pull percent
                formatMode = "percent",               -- Display format: "percent" or "count"
                prefixColor = { r = 1, g = 0.7960784, b = 0.2, a = 1 }, -- Color for prefixes (labels) (default: #ffcb33)
                singleLineSeparator = " | ",           -- Separator for single-line layout
                textAlign = "CENTER",                  -- Horizontal font alignment: LEFT, CENTER, RIGHT
                showProjected = false                   -- Append projected values next to Current/Required
            }
        },
        text = {font = "Friz Quadrata TT"},
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
    {id = "TWW", name = "EXPANSION_WW", order = 4}, -- The War Within
    -- {id = "DF", name = "EXPANSION_DF", order = 5},         -- Dragonflight
    {id = "SL", name = "EXPANSION_SL", order = 6}, -- Shadowlands
    {id = "BFA", name = "EXPANSION_BFA", order = 7}, -- Battle for Azeroth
    -- {id = "LEGION", name = "EXPANSION_LEGION", order = 8}, -- Legion
    -- {id = "WOD", name = "EXPANSION_WOD", order = 9},       -- Warlords of Draenor
    -- {id = "MOP", name = "EXPANSION_MOP", order = 10},      -- Mists of Pandaria
    {id = "CATACLYSM", name = "EXPANSION_CATA", order = 11} -- Cataclysm
    -- {id = "TBC", name = "EXPANSION_TBC", order = 12} -- The Burning Crusade
    -- {id = "Vanilla", name = "EXPANSION_VANILLA", order = 12} -- Vanilla WoW
}

local portal = C_CVar.GetCVar("portal")
if portal == "US" then
    KeystonePolaris.SEASON_START_DATES = {
        ["2024-09-10"] = "TWW_1", -- TWW Season 1 start date
        ["2025-03-04"] = "TWW_2", -- TWW Season 2 start date
        ["2025-08-12"] = "TWW_3"  -- TWW Season 3 start date
    }
elseif portal == "EU" then
    KeystonePolaris.SEASON_START_DATES = {
        ["2024-09-10"] = "TWW_1", -- TWW Season 1 start date
        ["2025-03-05"] = "TWW_2", -- TWW Season 2 start date
        ["2025-08-13"] = "TWW_3"  -- TWW Season 3 start date
    }
else
    KeystonePolaris.SEASON_START_DATES = {
        ["2024-09-10"] = "TWW_1", -- TWW Season 1 start date
        ["2025-03-05"] = "TWW_2", -- TWW Season 2 start date
        ["2025-08-13"] = "TWW_3"  -- TWW Season 3 start date
    }
end

-- Load defaults from all expansions
for _, expansion in ipairs(expansions) do
    local defaults = KeystonePolaris[expansion.id .. "_DEFAULTS"]
    if defaults then
        for k, v in pairs(defaults) do
            KeystonePolaris.defaults.profile.advanced[k] = v
        end
    end
end

function KeystonePolaris:LoadExpansionDungeons()
    -- Process dungeon data and generate tables for all expansions
    for _, expansion in ipairs(expansions) do
        local dungeonData = self[expansion.id .. "_DUNGEON_DATA"]
        if dungeonData then
            -- Generate the tables for this expansion
            self:GenerateExpansionTables(expansion.id, dungeonData)

            -- Initialize advanced settings for each dungeon
            for shortName, _ in pairs(dungeonData) do
                -- Ensure the advanced settings table exists for this dungeon
                if not self.db.profile.advanced[shortName] then
                    self.db.profile.advanced[shortName] = {}
                end

                -- Initialize with defaults if needed
                local defaults = self[expansion.id .. "_DEFAULTS"][shortName]
                if defaults then
                    for key, value in pairs(defaults) do
                        if self.db.profile.advanced[shortName][key] == nil then
                            self.db.profile.advanced[shortName][key] = value
                        end
                    end
                end
            end

            -- Load dungeons into the main DUNGEONS table
            local dungeons = self[expansion.id .. "_DUNGEONS"]
            if dungeons then
                for id, data in pairs(dungeons) do
                    self.DUNGEONS[id] = data
                end
            end
        end
    end
end

function KeystonePolaris:GetDungeonIdByKey(dungeonKey)
    -- Check each expansion's dungeon IDs table
    for _, expansion in ipairs(expansions) do
        local dungeonIds = self[expansion.id .. "_DUNGEON_IDS"]
        if dungeonIds and dungeonIds[dungeonKey] then
            return dungeonIds[dungeonKey]
        end
    end
    return nil
end

function KeystonePolaris:GetDungeonKeyById(dungeonId)
    -- Check each expansion's dungeon IDs table
    for _, expansion in ipairs(expansions) do
        local dungeonIds = self[expansion.id .. "_DUNGEON_IDS"]
        if dungeonIds then
            for dungeonKey, id in pairs(dungeonIds) do
                if id == dungeonId then return dungeonKey end
            end
        end
    end
    return nil
end

function KeystonePolaris:IsCurrentSeasonDungeon(dungeonId)
    -- Get the current date
    local currentDate = date("%Y-%m-%d")

    -- Find the most recent season
    local mostRecentSeasonDate = nil
    local currentSeasonId = nil

    for seasonDate, _ in pairs(self.SEASON_START_DATES) do
        if seasonDate <= currentDate and
            (not mostRecentSeasonDate or seasonDate > mostRecentSeasonDate) then
            currentSeasonId = self.SEASON_START_DATES[seasonDate]
            mostRecentSeasonDate = seasonDate
        end
    end

    if currentSeasonId then
        local seasonDungeonsTabName = currentSeasonId .. "_DUNGEONS"
        local seasonDungeons = self[seasonDungeonsTabName]

        if seasonDungeons then return seasonDungeons[dungeonId] or false end
    end

    return false
end

function KeystonePolaris:IsNextSeasonDungeon(dungeonId)
    -- Get the current date
    local currentDate = date("%Y-%m-%d")

    -- Find the next season (first season that starts after current date)
    local nextSeasonDate = nil
    local nextSeasonId = nil

    for seasonDate, _ in pairs(self.SEASON_START_DATES) do
        if seasonDate > currentDate and
            (not nextSeasonDate or seasonDate < nextSeasonDate) then
            nextSeasonId = self.SEASON_START_DATES[seasonDate]
            nextSeasonDate = seasonDate
        end
    end

    if nextSeasonId then
        local nextSeasonDungeonsTabName = nextSeasonId .. "_DUNGEONS"
        local nextSeasonDungeons = self[nextSeasonDungeonsTabName]

        if nextSeasonDungeons then
            return nextSeasonDungeons[dungeonId] or false
        end
    end

    return false
end

function KeystonePolaris:GetPositioningOptions()
    local self = KeystonePolaris
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
                get = function()
                    return self.db.profile.general.position
                end,
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
                get = function()
                    return self.db.profile.general.xOffset
                end,
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
                get = function()
                    return self.db.profile.general.yOffset
                end,
                set = function(_, value)
                    self.db.profile.general.yOffset = value
                    self:Refresh()
                end
            }
        }
    }
end

function KeystonePolaris:GetFontOptions()
    local self = KeystonePolaris
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
                max = 64,
                step = 1,
                get = function()
                    return self.db.profile.general.fontSize
                end,
                set = function(_, value)
                    self.db.profile.general.fontSize = value
                    self:Refresh()
                end
            }
        }
    }
end

function KeystonePolaris:GetColorOptions()
    local self = KeystonePolaris
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
                name = L["FINISHED_COLOR"],
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

-- Main display options: control which values to show and layout
function KeystonePolaris:GetMainDisplayOptions()
    local self = KeystonePolaris
    -- Local helper for MDT availability
    local function IsMDTAvailable()
        if C_AddOns and C_AddOns.IsAddOnLoaded then
            return C_AddOns.IsAddOnLoaded("MythicDungeonTools") or (_G.MDT ~= nil) or (_G.MethodDungeonTools ~= nil)
        end
        return (_G and (_G.MDT or _G.MethodDungeonTools))
    end
    return {
        name = L["MAIN_DISPLAY"],
        type = "group",
        inline = true,
        order = 5.75,
        args = {
            formatMode = {
                name = L["FORMAT_MODE"],
                desc = L["FORMAT_MODE_DESC"],
                type = "select",
                order = 0,
                values = function()
                    local percentLabel = L["PERCENTAGE"]
                    local countLabel = L["COUNT"]
                    return { percent = percentLabel, count = countLabel }
                end,
                get = function()
                    return self.db.profile.general.mainDisplay.formatMode or "percent"
                end,
                set = function(_, value)
                    self.db.profile.general.mainDisplay.formatMode = value == "count" and "count" or "percent"
                    if self.UpdatePercentageText then self:UpdatePercentageText() end
                    if self.ApplyTextLayout then self:ApplyTextLayout() end
                    if self.AdjustDisplayFrameSize then self:AdjustDisplayFrameSize() end
                end
            },
            separator0 = {
                type = "header",
                name = "",
                order = 0.05
            },
            prefixColor = {
                name = L["PREFIX_COLOR"],
                desc = L["PREFIX_COLOR_DESC"],
                type = "color",
                order = 0.1,
                width = "full",
                hasAlpha = false,
                get = function()
                    local c = self.db.profile.general.mainDisplay.prefixColor or (self.defaults and self.defaults.profile.general.mainDisplay.prefixColor) or {r=1,g=0.7960784,b=0.2,a=1}
                    return c.r, c.g, c.b, c.a
                end,
                set = function(_, r, g, b, a)
                    local c = self.db.profile.general.mainDisplay.prefixColor
                    c.r, c.g, c.b, c.a = r, g, b, a
                    if self.UpdatePercentageText then self:UpdatePercentageText() end
                end
            },
            showRequiredText = {
                name = L["SHOW_REQUIRED_PREFIX"],
                desc = L["SHOW_REQUIRED_PREFIX_DESC"],
                type = "toggle",
                order = 0.25,
                width = 1.4,
                get = function() return self.db.profile.general.mainDisplay.showRequiredText end,
                set = function(_, value)
                    self.db.profile.general.mainDisplay.showRequiredText = value
                    self:UpdatePercentageText()
                end
            },
            requiredLabel = {
                name = L["LABEL"],
                desc = L["REQUIRED_LABEL_DESC"],
                type = "input",
                order = 0.5,
                width = 1,
                get = function() return self.db.profile.general.mainDisplay.requiredLabel end,
                set = function(_, value)
                    local text = type(value) == "string" and value or ""
                    text = (text ~= "" and text) or L["REQUIRED_DEFAULT"]
                    self.db.profile.general.mainDisplay.requiredLabel = text
                    self:UpdatePercentageText()
                end,
                disabled = function()
                    return not self.db.profile.general.mainDisplay.showRequiredText
                end
            },
            showSectionRequiredText = {
                name = L["SHOW_SECTION_REQUIRED_PREFIX"],
                desc = L["SHOW_SECTION_REQUIRED_PREFIX_DESC"],
                type = "toggle",
                order = 0.55,
                width = 1.4,
                get = function() return self.db.profile.general.mainDisplay.showSectionRequiredText end,
                set = function(_, value)
                    self.db.profile.general.mainDisplay.showSectionRequiredText = value
                    self:UpdatePercentageText()
                end
            },
            sectionRequiredLabel = {
                name = L["LABEL"],
                desc = L["SECTION_REQUIRED_LABEL_DESC"],
                type = "input",
                order = 0.60,
                width = 1,
                get = function() return self.db.profile.general.mainDisplay.sectionRequiredLabel end,
                set = function(_, value)
                    local text = type(value) == "string" and value or ""
                    text = (text ~= "" and text) or L["SECTION_REQUIRED_DEFAULT"]
                    self.db.profile.general.mainDisplay.sectionRequiredLabel = text
                    self:UpdatePercentageText()
                end,
                disabled = function()
                    return not self.db.profile.general.mainDisplay.showSectionRequiredText
                end
            },
            showCurrentPercent = {
                name = L["SHOW_CURRENT_PERCENT"],
                desc = L["SHOW_CURRENT_PERCENT_DESC"],
                type = "toggle",
                order = 1,
                width = 1.4,
                get = function() return self.db.profile.general.mainDisplay.showCurrentPercent end,
                set = function(_, value)
                    self.db.profile.general.mainDisplay.showCurrentPercent = value
                    self:UpdatePercentageText()
                end
            },
            currentLabel = {
                name = L["LABEL"],
                desc = L["CURRENT_LABEL_DESC"],
                type = "input",
                order = 1.1,
                width = 1,
                get = function() return self.db.profile.general.mainDisplay.currentLabel end,
                set = function(_, value)
                    local text = type(value) == "string" and value or ""
                    text = (text ~= "" and text) or L["CURRENT_DEFAULT"]
                    self.db.profile.general.mainDisplay.currentLabel = text
                    self:UpdatePercentageText()
                end,
                disabled = function()
                    return not self.db.profile.general.mainDisplay.showCurrentPercent
                end
            },
            showCurrentPullPercent = {
                name = L["SHOW_CURRENT_PULL_PERCENT"],
                desc = L["SHOW_CURRENT_PULL_PERCENT_DESC"],
                type = "toggle",
                order = 2,
                width = 1.4,
                get = function() return self.db.profile.general.mainDisplay.showCurrentPullPercent end,
                set = function(_, value)
                    self.db.profile.general.mainDisplay.showCurrentPullPercent = value
                    self:UpdatePercentageText()
                end,
                disabled = function()
                    return not IsMDTAvailable()
                end
            },
            pullLabel = {
                name = L["LABEL"],
                desc = L["PULL_LABEL_DESC"],
                type = "input",
                order = 2.1,
                width = 1,
                get = function() return self.db.profile.general.mainDisplay.pullLabel end,
                set = function(_, value)
                    local text = type(value) == "string" and value or ""
                    text = (text ~= "" and text) or L["PULL_DEFAULT"]
                    self.db.profile.general.mainDisplay.pullLabel = text
                    self:UpdatePercentageText()
                end,
                disabled = function()
                    return not self.db.profile.general.mainDisplay.showCurrentPullPercent or not IsMDTAvailable()
                end
            },
            multiLine = {
                name = L["USE_MULTI_LINE_LAYOUT"],
                desc = L["USE_MULTI_LINE_LAYOUT_DESC"],
                type = "toggle",
                order = 3,
                width = 1.4,
                get = function() return self.db.profile.general.mainDisplay.multiLine end,
                set = function(_, value)
                    self.db.profile.general.mainDisplay.multiLine = value
                    -- Immediate refresh
                    if self.UpdatePercentageText then self:UpdatePercentageText() end
                    if self.ApplyTextLayout then self:ApplyTextLayout() end
                    if self.AdjustDisplayFrameSize then self:AdjustDisplayFrameSize() end
                    -- Notify AceConfig to repaint controls bound to this value
                    local ACR = LibStub and LibStub("AceConfigRegistry-3.0", true)
                    if ACR and AddOnName then ACR:NotifyChange(AddOnName) end
                    -- Multi-frame re-apply to avoid sticky states
                    local function reapply()
                        if self.displayFrame and self.displayFrame.text then
                            if self.UpdatePercentageText then self:UpdatePercentageText() end
                            if self.ApplyTextLayout then self:ApplyTextLayout() end
                            if self.AdjustDisplayFrameSize then self:AdjustDisplayFrameSize() end
                            local t = self.displayFrame.text
                            t:SetText(t:GetText())
                        end
                    end
                    C_Timer.After(0.03, reapply)
                    C_Timer.After(0.08, reapply)
                    C_Timer.After(0.15, reapply)
                end
            },
            singleLineSeparator = {
                name = L["SINGLE_LINE_SEPARATOR"],
                desc = L["SINGLE_LINE_SEPARATOR_DESC"],
                type = "input",
                order = 3.1,
                width = 1,
                get = function() return self.db.profile.general.mainDisplay.singleLineSeparator end,
                set = function(_, value)
                    self.db.profile.general.mainDisplay.singleLineSeparator = tostring(value or " | ")
                    self:UpdatePercentageText()
                end,
                disabled = function()
                    return self.db.profile.general.mainDisplay.multiLine
                end
            },
            textAlign = {
                name = L["FONT_ALIGN"],
                desc = L["FONT_ALIGN_DESC"],
                type = "select",
                order = 3.2,
                values = {
                    LEFT = L["LEFT"],
                    CENTER = L["CENTER"],
                    RIGHT = L["RIGHT"],
                },
                get = function() return self.db.profile.general.mainDisplay.textAlign end,
                set = function(_, value)
                    self.db.profile.general.mainDisplay.textAlign = value
                    -- Immediate layout apply and text reflow
                    if self.ApplyTextLayout then self:ApplyTextLayout() end
                    if self.displayFrame and self.displayFrame.text then
                        local t = self.displayFrame.text
                        t:SetText(t:GetText())
                    end
                    -- Re-render text then re-apply layout and size
                    if self.UpdatePercentageText then self:UpdatePercentageText() end
                    if self.ApplyTextLayout then self:ApplyTextLayout() end
                    if self.AdjustDisplayFrameSize then self:AdjustDisplayFrameSize() end

                    -- Multi-frame re-apply for select UI timing
                    local function reapply()
                        if self.displayFrame and self.displayFrame.text then
                            if self.ApplyTextLayout then self:ApplyTextLayout() end
                            local t = self.displayFrame.text
                            t:SetText(t:GetText())
                            if self.AdjustDisplayFrameSize then self:AdjustDisplayFrameSize() end
                        end
                    end
                    C_Timer.After(0.03, reapply)
                    C_Timer.After(0.08, reapply)
                    C_Timer.After(0.15, reapply)

                    -- Hidden toggle workaround: flip multiLine off/on to force UI reflow without changing final setting
                    local origMulti = self.db.profile.general.mainDisplay.multiLine
                    local ACR = LibStub and LibStub("AceConfigRegistry-3.0", true)
                    local function setMulti(val)
                        self.db.profile.general.mainDisplay.multiLine = val
                        if ACR and AddOnName then ACR:NotifyChange(AddOnName) end
                    end
                    -- Flip off/on around the layout reapply
                    setMulti(not origMulti)
                    reapply()
                    -- Restore with repeated assertions
                    C_Timer.After(0.05, function()
                        setMulti(origMulti)
                        reapply()
                    end)
                    C_Timer.After(0.10, function()
                        setMulti(origMulti)
                        reapply()
                    end)
                    C_Timer.After(0.20, function()
                        setMulti(origMulti)
                        reapply()
                    end)
                end,
                disabled = function()
                    return not self.db.profile.general.mainDisplay.multiLine
                end
            },
            showProjected = {
                name = L["SHOW_PROJECTED"],
                desc = L["SHOW_PROJECTED_DESC"],
                type = "toggle",
                order = 3.25,
                width = 1.6,
                get = function() return self.db.profile.general.mainDisplay.showProjected end,
                set = function(_, value)
                    self.db.profile.general.mainDisplay.showProjected = value
                    if self.UpdatePercentageText then self:UpdatePercentageText() end
                    if self.ApplyTextLayout then self:ApplyTextLayout() end
                    if self.AdjustDisplayFrameSize then self:AdjustDisplayFrameSize() end
                end
            },
        }
    }
end

function KeystonePolaris:GetOtherOptions()
    return {
        name = L["OPTIONS"],
        type = "group",
        inline = true,
        order = 10,
        args = {
            rolesEnabled = {
                name = L["ROLES_ENABLED"],
                desc = L["ROLES_ENABLED_DESC"],
                type = "multiselect",
                order = 2,
                values = {
                    LEADER = L["LEADER"],
                    TANK = L["TANK"],
                    HEALER = L["HEALER"],
                    DAMAGER = L["DPS"]
                },
                get = function(_, key)
                    return self.db.profile.general.rolesEnabled[key] or false
                end,
                set = function(_, key, state)
                    if state then
                        self.db.profile.general.rolesEnabled[key] = true
                    else
                        self.db.profile.general.rolesEnabled[key] = false
                    end
                    self:Refresh()
                end
            },
            informGroup = {
                name = L["INFORM_GROUP"],
                desc = L["INFORM_GROUP_DESC"],
                type = "toggle",
                order = 10,
                get = function()
                    return self.db.profile.general.informGroup
                end,
                set = function(_, value)
                    self.db.profile.general.informGroup = value
                end
            },
            informChannel = {
                name = L["MESSAGE_CHANNEL"],
                desc = L["MESSAGE_CHANNEL_DESC"],
                type = "select",
                order = 11,
                values = {PARTY = L["PARTY"], SAY = L["SAY"], YELL = L["YELL"]},
                disabled = function()
                    return not self.db.profile.general.informGroup
                end,
                get = function()
                    return self.db.profile.general.informChannel
                end,
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
                get = function()
                    return self.db.profile.general.advancedOptionsEnabled
                end,
                set = function(_, value)
                    self.db.profile.general.advancedOptionsEnabled = value
                    self:UpdateDungeonData()
                end
            }
        }
    }
end

function KeystonePolaris:GetAdvancedOptions()
    local self = KeystonePolaris
    -- Helper function to get dungeon name with icon
    local function GetDungeonNameWithIcon(dungeonKey)
        local mapId = self:GetDungeonIdByKey(dungeonKey)

        local name, _, _, texture
        if mapId then
            name, _, _, texture = C_ChallengeMode.GetMapUIInfo(mapId)
        end

        -- Fallbacks
        local icon = texture
        local displayName = name

        return '|T' .. icon .. ":20:20:0:0|t " .. displayName
    end

    -- Helper function to format dungeon text
    local function FormatDungeonText(self, dungeonKey, defaults)
        local text = ""
        if defaults then
            text = text .. "|cffffd700" .. GetDungeonNameWithIcon(dungeonKey) ..
                       "|r:\n"
            local bossNum = 1
            while defaults["Boss" .. self:GetBossNumberString(bossNum)] do
                local bossKey = "Boss" .. self:GetBossNumberString(bossNum)
                local informKey = bossKey .. "Inform"
                text = text ..
                           string.format(
                               "  %s: |cff40E0D0%.2f%%|r - " ..
                                   L["INFORM_GROUP"] .. ": %s\n",
                               L[dungeonKey .. "_BOSS" .. bossNum],
                               defaults[bossKey],
                               defaults[informKey] and '|cff00ff00' .. L["YES"] ..
                                   '|r' or '|cffff0000' .. L["NO"] .. '|r')
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
                sharedDungeonOptions[dungeonKey] =
                    self:CreateDungeonOptions(dungeonKey, 0)
            end
        end
    end

    -- Generic builder for section args (used for seasons and expansions)
    local function CreateGenericSectionArgs(sectionLabel, dungeonKeys, dungeonFilter, getDefaultsFn)
        local args = {
            disclaimer = {
                order = 0,
                type = "description",
                fontSize = "medium",
                name = L["ROUTES_DISCLAIMER"],
            },
            separator = {order = 1, type = "header", name = ""},
            export = {
                order = 1.25,
                type = "execute",
                name = L["EXPORT_SECTION"],
                desc = (L["EXPORT_SECTION_DESC"]):format(sectionLabel),
                func = function()
                    local addon = KeystonePolaris
                    local sectionData = {}
                    for _, dungeonKey in ipairs(dungeonKeys) do
                        if addon.db and addon.db.profile and addon.db.profile.advanced and addon.db.profile.advanced[dungeonKey] then
                            sectionData[dungeonKey] = addon.db.profile.advanced[dungeonKey]
                        end
                    end
                    addon:ExportDungeonSettings(sectionData, "section", sectionLabel)
                end
            },
            import = {
                order = 1.5,
                type = "execute",
                name = L["IMPORT_SECTION"],
                desc = (L["IMPORT_SECTION_DESC"]):format(sectionLabel),
                func = function()
                    KeystonePolaris:ShowImportDialog(sectionLabel, dungeonFilter)
                end
            },
            separatorDefaultPercentages = {
                order = 2,
                type = "header",
                name = L["DEFAULT_PERCENTAGES"],
            },
            defaultPercentages = {
                order = 2.5,
                type = "description",
                fontSize = "medium",
                name = L["DEFAULT_PERCENTAGES_DESC"],
            },
            separatorDefaultPercentagesText = {
                order = 2.8,
                type = "header",
                name = "",
            },
            defaultPercentagesText = {
                order = 3,
                type = "description",
                fontSize = "medium",
                name = function()
                    local text = ""
                    for _, dungeonKey in ipairs(dungeonKeys) do
                        local defaults = getDefaultsFn and getDefaultsFn(dungeonKey) or nil
                        text = text .. FormatDungeonText(self, dungeonKey, defaults)
                    end
                    return text
                end
            }
        }

        -- Add per-dungeon options (alphabetical by localized name)
        -- Start at order 4 to come after the defaults header/description/text
        InsertSortedDungeonOptions(self, dungeonKeys, sharedDungeonOptions, args, 4)
        return args
    end

    -- Create current season options
    local currentSeasonDungeons = {}

    -- Get the current date
    local currentDate = date("%Y-%m-%d")

    -- Find the most recent season
    local mostRecentSeasonDate = nil
    local currentSeasonId = nil

    for seasonDate, _ in pairs(self.SEASON_START_DATES) do
        if seasonDate <= currentDate and
            (not mostRecentSeasonDate or seasonDate > mostRecentSeasonDate) then
            currentSeasonId = self.SEASON_START_DATES[seasonDate]
            mostRecentSeasonDate = seasonDate
        end
    end

    if currentSeasonId then
        local seasonDungeonsTabName = currentSeasonId .. "_DUNGEONS"
        local seasonDungeons = self[seasonDungeonsTabName]

        if seasonDungeons then
            for _, expansion in ipairs(expansions) do
                local dungeonIds = self[expansion.id .. "_DUNGEON_IDS"]
                if dungeonIds then
                    for dungeonKey, dungeonId in pairs(dungeonIds) do
                        if seasonDungeons[dungeonId] then
                            table.insert(currentSeasonDungeons,
                                         {key = dungeonKey, id = dungeonId})
                        end
                    end
                end
            end
        end
    end

    -- Sort dungeons alphabetically by their localized names
    table.sort(currentSeasonDungeons, function(a, b)
        local mapIdA = a.id or self:GetDungeonIdByKey(a.key)
        local mapIdB = b.id or self:GetDungeonIdByKey(b.key)

        local nameA
        if mapIdA then nameA = select(1, C_ChallengeMode.GetMapUIInfo(mapIdA)) end
        nameA = nameA or a.key

        local nameB
        if mapIdB then nameB = select(1, C_ChallengeMode.GetMapUIInfo(mapIdB)) end
        nameB = nameB or b.key

        return nameA < nameB
    end)

    -- Create current season dungeon args (using generic builder)
    local dungeonArgs
    do
        local keys = {}
        local filter = {}
        for _, d in ipairs(currentSeasonDungeons) do
            table.insert(keys, d.key)
            filter[d.key] = true
        end

        local function getDefaultsFn(dungeonKey)
            for _, expansion in ipairs(expansions) do
                local ids = self[expansion.id .. "_DUNGEON_IDS"]
                if ids and ids[dungeonKey] then
                    local defaults = self[expansion.id .. "_DEFAULTS"]
                    return defaults and defaults[dungeonKey] or nil
                end
            end
            return nil
        end

        dungeonArgs = CreateGenericSectionArgs(L["CURRENT_SEASON"], keys, filter, getDefaultsFn)
    end

    -- Create next season dungeon args
    local nextSeasonDungeons = {}

    -- Get the current date
    local currentDate = date("%Y-%m-%d")

    -- Find the next season (first season that starts after current date)
    local nextSeasonDate = nil
    local nextSeasonId = nil

    for seasonDate, _ in pairs(self.SEASON_START_DATES) do
        if seasonDate > currentDate and
            (not nextSeasonDate or seasonDate < nextSeasonDate) then
            nextSeasonId = self.SEASON_START_DATES[seasonDate]
            nextSeasonDate = seasonDate
        end
    end

    if nextSeasonId then
        local nextSeasonDungeonsTabName = nextSeasonId .. "_DUNGEONS"
        local nextSeasonDungeonsTable = self[nextSeasonDungeonsTabName]

        if nextSeasonDungeonsTable then
            for _, expansion in ipairs(expansions) do
                local dungeonIds = self[expansion.id .. "_DUNGEON_IDS"]
                if dungeonIds then
                    for dungeonKey, dungeonId in pairs(dungeonIds) do
                        if nextSeasonDungeonsTable[dungeonId] then
                            table.insert(nextSeasonDungeons,
                                         {key = dungeonKey, id = dungeonId})
                        end
                    end
                end
            end
        end
    end

    -- Sort dungeons alphabetically by their localized names
    table.sort(nextSeasonDungeons, function(a, b)
        local mapIdA = a.id or self:GetDungeonIdByKey(a.key)
        local mapIdB = b.id or self:GetDungeonIdByKey(b.key)

        local nameA
        if mapIdA then nameA = select(1, C_ChallengeMode.GetMapUIInfo(mapIdA)) end
        nameA = nameA or a.key

        local nameB
        if mapIdB then nameB = select(1, C_ChallengeMode.GetMapUIInfo(mapIdB)) end
        nameB = nameB or b.key

        return nameA < nameB
    end)

    -- Create next season dungeon args (using generic builder)
    local nextSeasonDungeonArgs
    do
        local keys = {}
        local filter = {}
        for _, d in ipairs(nextSeasonDungeons) do
            table.insert(keys, d.key)
            filter[d.key] = true
        end

        local function getDefaultsFn(dungeonKey)
            for _, expansion in ipairs(expansions) do
                local ids = self[expansion.id .. "_DUNGEON_IDS"]
                if ids and ids[dungeonKey] then
                    local defaults = self[expansion.id .. "_DEFAULTS"]
                    return defaults and defaults[dungeonKey] or nil
                end
            end
            return nil
        end

        nextSeasonDungeonArgs = CreateGenericSectionArgs(L["NEXT_SEASON"], keys, filter, getDefaultsFn)
    end

    -- Create expansion sections
    local args = {
        disclaimer = {
            order = 0,
            type = "description",
            fontSize = "medium",
            name = L["ROUTES_DISCLAIMER"],
        },
        separator = {
            order = 1,
            type = "header",
            name = "",
        },
        resetAll = {
            order = 2,
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
        exportAllDungeons = {
            order = 3,
            type = "execute",
            name = L["EXPORT_ALL_DUNGEONS"],
            desc = L["EXPORT_ALL_DUNGEONS_DESC"],
            func = function()
                local addon = KeystonePolaris

                -- Collect all dungeon data
                local allDungeonData = {}
                for dungeonKey, _ in pairs(addon.db.profile.advanced) do
                    if type(addon.db.profile.advanced[dungeonKey]) == "table" then
                        allDungeonData[dungeonKey] =
                            addon.db.profile.advanced[dungeonKey]
                    end
                end

                -- Export all dungeon data
                addon:ExportDungeonSettings(allDungeonData, "all_dungeons")
            end
        },
        importAllDungeons = {
            order = 4,
            type = "execute",
            name = L["IMPORT_ALL_DUNGEONS"],
            desc = L["IMPORT_ALL_DUNGEONS_DESC"],
            func = function()
                local addon = KeystonePolaris
                addon:ShowImportDialog()
            end
        },
        dungeons = {
            name = "|cff40E0D0" .. L["CURRENT_SEASON"] .. "|r",
            type = "group",
            childGroups = "tree",
            order = 5,
            args = dungeonArgs
        }
    }

    -- Only add next season section if there are next season dungeons
    if nextSeasonId and #nextSeasonDungeons > 0 then
        args.nextseason = {
            name = "|cffff5733" .. L["NEXT_SEASON"] .. "|r",
            type = "group",
            childGroups = "tree",
            order = 4,
            args = nextSeasonDungeonArgs
        }
    end

    -- Create expansion sections
    for _, expansion in ipairs(expansions) do
        local sectionKey = expansion.id:lower()
        local dungeonIds = self[expansion.id .. "_DUNGEON_IDS"]
        local defaults = self[expansion.id .. "_DEFAULTS"]
        local keys = {}
        local filter = {}
        if dungeonIds then
            for dungeonKey, _ in pairs(dungeonIds) do
                table.insert(keys, dungeonKey)
                filter[dungeonKey] = true
            end
        end

        local function getDefaultsFn(dungeonKey)
            return defaults and defaults[dungeonKey] or nil
        end

        args[sectionKey] = {
            name = "|cffffffff" .. L[expansion.name] .. "|r",
            type = "group",
            childGroups = "tree",
            order = expansion.order + 4, -- Shift expansion orders to after next season
            args = CreateGenericSectionArgs(L[expansion.name], keys, filter, getDefaultsFn)
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

function KeystonePolaris:CreateDungeonOptions(dungeonKey, order)
    local self = KeystonePolaris
    local numBosses = #self.DUNGEONS[self:GetDungeonIdByKey(dungeonKey)]

    -- Ensure the advanced settings table exists for this dungeon
    if not self.db.profile.advanced[dungeonKey] then
        self.db.profile.advanced[dungeonKey] = {}

        -- Initialize with defaults if needed
        for _, expansion in ipairs(expansions) do
            if self[expansion.id .. "_DUNGEON_IDS"] and
                self[expansion.id .. "_DUNGEON_IDS"][dungeonKey] then
                local defaults = self[expansion.id .. "_DEFAULTS"][dungeonKey]
                if defaults then
                    for key, value in pairs(defaults) do
                        self.db.profile.advanced[dungeonKey][key] = value
                    end
                end
                break
            end
        end
    end

    local options = {
        name = function()
            local mapId = self:GetDungeonIdByKey(dungeonKey)

            local name, texture
            if mapId then
                name, _, _, texture, _ = C_ChallengeMode.GetMapUIInfo(mapId)
            end

            return '|T' .. texture .. ":16:16:0:0|t " .. (name)
        end,
        type = "group",
        order = order,
        args = {
            dungeonHeader = {
                order = 0,
                type = "description",
                fontSize = "large",
                name = function()
                    local mapId = self:GetDungeonIdByKey(dungeonKey)

                    local name, texture
                    if mapId then
                        name, _, _, texture, _ =
                            C_ChallengeMode.GetMapUIInfo(mapId)
                    end

                    return "|T" .. texture .. ":20:20:0:0|t |cff40E0D0" ..
                               (name) .. "|r"
                end
            },
            dungeonSecondHeader = {type = "header", name = "", order = 1},
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
                                defaults =
                                    self[expansion.id .. "_DEFAULTS"][dungeonKey]
                                break
                            end
                        end

                        if defaults then
                            for key, value in pairs(defaults) do
                                self.db.profile.advanced[dungeonKey][key] =
                                    value
                            end
                        end

                        -- Update the display
                        self:UpdateDungeonData()
                        LibStub("AceConfigRegistry-3.0"):NotifyChange(
                            "KeystonePolaris")
                    end
                end,
                confirm = true,
                confirmText = L["RESET_DUNGEON_CONFIRM"]
            },
            export = {
                order = 3,
                type = "execute",
                name = L["EXPORT_DUNGEON"],
                desc = L["EXPORT_DUNGEON_DESC"],
                func = function()
                    local addon = KeystonePolaris
                    local dungeonId = addon:GetDungeonIdByKey(dungeonKey)
                    if dungeonId and addon.DUNGEONS[dungeonId] and
                        addon.db.profile.advanced[dungeonKey] then
                        -- Create export string for single dungeon
                        local exportData = {
                            dungeon = dungeonKey,
                            data = addon.db.profile.advanced[dungeonKey]
                        }
                        local serialized =
                            LibStub("AceSerializer-3.0"):Serialize(exportData)
                        local compressed =
                            LibStub("LibDeflate"):CompressDeflate(serialized)
                        local encoded = LibStub("LibDeflate"):EncodeForPrint(
                                            compressed)

                        -- Show export dialog
                        StaticPopupDialogs["KPL_EXPORT_DIALOG"] = {
                            text = L["EXPORT_DIALOG_TEXT"],
                            button1 = OKAY,
                            hasEditBox = true,
                            editBoxWidth = 350,
                            maxLetters = 999999,
                            OnShow = function(dialog)
                                dialog.EditBox:SetText(encoded)
                                dialog.EditBox:HighlightText()
                                dialog.EditBox:SetFocus()
                            end,
                            EditBoxOnEscapePressed = function(editBox)
                                editBox:GetParent():Hide()
                            end,
                            timeout = 0,
                            whileDead = true,
                            hideOnEscape = true
                        }
                        StaticPopup_Show("KPL_EXPORT_DIALOG")
                    end
                end
            },
            import = {
                order = 3.5,
                type = "execute",
                name = L["IMPORT_DUNGEON"],
                desc = L["IMPORT_DUNGEON_DESC"],
                func = function()
                    local addon = KeystonePolaris

                    -- Create filter for this specific dungeon
                    local dungeonFilter = {}
                    dungeonFilter[dungeonKey] = true

                    StaticPopupDialogs["KPL_IMPORT_DIALOG"] = {
                        text = L["IMPORT_DIALOG_TEXT"],
                        button1 = OKAY,
                        button2 = CANCEL,
                        hasEditBox = true,
                        editBoxWidth = 350,
                        maxLetters = 999999,
                        OnAccept = function(dialog)
                            local importString = dialog.EditBox:GetText()
                            addon:ImportDungeonSettings(importString, nil,
                                                        dungeonFilter)
                        end,
                        EditBoxOnEscapePressed = function(editBox)
                            editBox:GetParent():Hide()
                        end,
                        timeout = 0,
                        whileDead = true,
                        hideOnEscape = true
                    }
                    StaticPopup_Show("KPL_IMPORT_DIALOG")
                end
            },
            header = {order = 4, type = "header", name = L["TANK_GROUP_HEADER"]}
        }
    }

    for i = 1, numBosses do
        local bossNumStr = self:GetBossNumberString(i)
        local bossName = L[dungeonKey .. "_BOSS" .. i] or ("Boss " .. i)

        -- Create a group for each boss line
        options.args["boss" .. i] = {
            type = "group",
            name = bossName,
            inline = true,
            order = i + 4, -- Start boss orders at 5 (after header)
            args = {
                percent = {
                    name = L["PERCENTAGE"],
                    type = "range",
                    min = 0,
                    max = 100,
                    step = 0.01,
                    order = 1,
                    width = 1,
                    get = function()
                        return self.db.profile.advanced[dungeonKey]["Boss" ..
                                   bossNumStr]
                    end,
                    set = function(_, value)
                        self.db.profile.advanced[dungeonKey]["Boss" ..
                            bossNumStr] = value
                        self:UpdateDungeonData()
                    end
                },
                inform = {
                    name = L["INFORM_GROUP"],
                    type = "toggle",
                    order = 2,
                    width = 1,
                    get = function()
                        return self.db.profile.advanced[dungeonKey]["Boss" ..
                                   bossNumStr .. "Inform"]
                    end,
                    set = function(_, value)
                        self.db.profile.advanced[dungeonKey]["Boss" ..
                            bossNumStr .. "Inform"] = value
                        self:UpdateDungeonData()
                    end
                }
            }
        }
    end
    return options
end

function KeystonePolaris:ToggleConfig()
    Settings.OpenToCategory("Keystone Polaris")
end

function KeystonePolaris:CreateColorString(text, db)
    local hex = db.r and db.g and db.b and self:RGBToHex(db.r, db.g, db.b) or
                    "|cffffffff"

    local string = hex .. text .. "|r"
    return string
end

function KeystonePolaris:RGBToHex(r, g, b, header, ending)
    r = r <= 1 and r >= 0 and r or 1
    g = g <= 1 and g >= 0 and g or 1
    b = b <= 1 and b >= 0 and b or 1

    local hex = format('%s%02x%02x%02x%s', header or '|cff', r * 255, g * 255,
                       b * 255, ending or '')
    return hex
end

-- Dedicated copy window for long texts (multi-line, scrollable)
function KeystonePolaris:ShowCopyPopup(text)
    if not self.copyPopup then
        local f = CreateFrame("Frame", "KeystonePolarisCopyPopup", UIParent, "BackdropTemplate")
        f:SetFrameStrata("FULLSCREEN_DIALOG")
        f:SetToplevel(true)
        f:SetSize(700, 500)
        f:SetPoint("CENTER")
        -- Style aligné sur l'overlay Test Mode: fond sombre + bordure 1px or
        f:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", tile = true, tileSize = 16, edgeSize = 1 })
        f:SetBackdropColor(0, 0, 0, 1)
        f:SetBackdropBorderColor(1, 0.82, 0, 1)
        -- Renforcer la bordure 1px sur tous les côtés (comme Test Mode)
        if not f.border then f.border = {} end
        local br, bgc, bb, ba = 1, 0.82, 0, 1
        if not f.border.top then f.border.top = f:CreateTexture(nil, "BORDER") end
        f.border.top:SetColorTexture(br, bgc, bb, ba)
        f.border.top:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
        f.border.top:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0)
        f.border.top:SetHeight(1)

        if not f.border.bottom then f.border.bottom = f:CreateTexture(nil, "BORDER") end
        f.border.bottom:SetColorTexture(br, bgc, bb, ba)
        f.border.bottom:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 0)
        f.border.bottom:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
        f.border.bottom:SetHeight(1)

        if not f.border.left then f.border.left = f:CreateTexture(nil, "BORDER") end
        f.border.left:SetColorTexture(br, bgc, bb, ba)
        f.border.left:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
        f.border.left:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 0)
        f.border.left:SetWidth(1)

        if not f.border.right then f.border.right = f:CreateTexture(nil, "BORDER") end
        f.border.right:SetColorTexture(br, bgc, bb, ba)
        f.border.right:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0)
        f.border.right:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
        f.border.right:SetWidth(1)

        local title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
        title:SetPoint("TOP", 0, -12)
        title:SetText("Keystone Polaris — " .. L["Changelog"])
        title:SetTextColor(1, 0.82, 0, 1)

        local instr = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        instr:SetPoint("TOPLEFT", 12, -40)
        instr:SetPoint("RIGHT", -12, 0)
        instr:SetJustifyH("LEFT")
        instr:SetText(L["COPY_INSTRUCTIONS"])
        -- Appliquer la police LSM si dispo, cohérente avec Test Mode
        local fontPath = self.LSM and self.LSM:Fetch('font', self.db and self.db.profile and self.db.profile.text and self.db.profile.text.font) or nil
        local baseSize = (self.db and self.db.profile and self.db.profile.general and self.db.profile.general.fontSize) or 12
        if fontPath then
            title:SetFont(fontPath, (baseSize or 12), "OUTLINE")
            instr:SetFont(fontPath, math.max(10, (baseSize or 12) - 6), "OUTLINE")
        end

        -- Séparateur sous le texte d'instruction
        local sep = f:CreateTexture(nil, "BORDER")
        sep:SetColorTexture(1, 0.82, 0, 0.25)
        sep:ClearAllPoints()
        sep:SetPoint("TOPLEFT", instr, "BOTTOMLEFT", 0, -10)
        sep:SetPoint("TOPRIGHT", instr, "BOTTOMRIGHT", 0, -10)
        sep:SetHeight(1)

        local scroll = CreateFrame("ScrollFrame", "KeystonePolarisCopyScroll", f, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", sep, "BOTTOMLEFT", 0, -10)
        scroll:SetPoint("BOTTOMRIGHT", -32, 44)

        local edit = CreateFrame("EditBox", "KeystonePolarisCopyEditBox", scroll)
        edit:SetMultiLine(true)
        edit:SetFontObject(ChatFontNormal)
        edit:SetAutoFocus(true)
        edit:SetWidth(scroll:GetWidth())
        edit:SetText("")
        scroll:SetScrollChild(edit)

        scroll:HookScript("OnSizeChanged", function(self, w)
            edit:SetWidth(w)
        end)

        local selectBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        selectBtn:SetSize(100, 22)
        selectBtn:SetPoint("BOTTOMLEFT", 12, 12)
        selectBtn:SetText(L["SELECT_ALL"])
        selectBtn:SetScript("OnClick", function()
            edit:SetFocus()
            edit:HighlightText()
        end)

        local closeBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        closeBtn:SetSize(80, 22)
        closeBtn:SetPoint("BOTTOMRIGHT", -12, 12)
        closeBtn:SetText(OKAY or "OK")
        closeBtn:SetScript("OnClick", function() f:Hide() end)

        f:SetScript("OnShow", function()
            edit:SetFocus()
            edit:HighlightText()
        end)
        f:SetScript("OnKeyDown", function(_, key)
            if key == "ESCAPE" then f:Hide() end
        end)
        f:EnableKeyboard(true)

        f.editBox = edit
        self.copyPopup = f
    end

    local f = self.copyPopup
    if f and f.editBox then
        f.editBox:SetText(text or "")
        f:Show()
        -- Assurer l'affichage au-dessus des StaticPopup (ex: KPL_MIGRATION)
        local maxPopupLevel = 0
        for i = 1, 4 do
            local p = _G["StaticPopup" .. i]
            if p and p:IsShown() then
                local lvl = p:GetFrameLevel() or 0
                if lvl > maxPopupLevel then maxPopupLevel = lvl end
                -- Si une StaticPopup est en FULLSCREEN_DIALOG, garder la même strata
                if p:GetFrameStrata() == "FULLSCREEN_DIALOG" then
                    f:SetFrameStrata("FULLSCREEN_DIALOG")
                end
            end
        end
        local myLvl = f:GetFrameLevel() or 0
        if maxPopupLevel >= myLvl then
            f:SetFrameLevel(maxPopupLevel + 2)
        end
        f:Raise()
    end
end

function KeystonePolaris:GenerateChangelog()
    self.changelogOptions = {
        type = "group",
        childGroups = "select",
        name = L["Changelog"],
        args = {}
    }

    if not self.Changelog or type(self.Changelog) ~= "table" then return end

    local function orange(string)
        if type(string) ~= "string" then string = tostring(string) end
        string = self:CreateColorString(string,
                                        {r = 0.859, g = 0.388, b = 0.203})
        return string
    end

    local function renderChangelogLine(line)
        line = gsub(line, "%[[^%[]+%]", orange)
        return line
    end

    -- Build a plain, colorless text block for a changelog entry (current locale with enUS fallback)
    local function buildPlainText(data)
        local function stripColors(s)
            if type(s) ~= "string" then s = tostring(s) end
            s = s:gsub("|c%x%x%x%x%x%x%x%x", "")
            s = s:gsub("|r", "")
            return s
        end
        local function resolve(list)
            if not list then return {} end
            if list[GetLocale()] and next(list[GetLocale()]) then
                return list[GetLocale()]
            end
            return list["enUS"] or {}
        end

        local chunks = {}
        local function appendSection(titleKey, list)
            local items = resolve(list)
            if items and #items > 0 then
                table.insert(chunks, (L and L[titleKey]) or titleKey)
                for _, line in ipairs(items) do
                    table.insert(chunks, "- " .. stripColors(line))
                end
                table.insert(chunks, "")
            end
        end

        if data and type(data) == "table" then
            if data.version_string and data.release_date then
                table.insert(chunks, (L and L["Version"] or "Version") .. ": " .. data.version_string ..
                    " (" .. data.release_date .. ")")
                table.insert(chunks, "")
            end
            appendSection("Important", data.important)
            appendSection("New", data.new)
            appendSection("Bugfixes", data.bugfix)
            appendSection("Improvment", data.improvment)
        end

        return table.concat(chunks, "\n")
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
                    translate = {
                        order = 1,
                        type = "execute",
                        name = L["TRANSLATE"],
                        desc = L["TRANSLATE_DESC"],
                        func = function()
                            local plain = buildPlainText(data)
                            if KeystonePolaris and KeystonePolaris.ShowCopyPopup then
                                KeystonePolaris:ShowCopyPopup(plain)
                            end
                        end,
                    },
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
            if data.important and data.important[GetLocale()] and
                next(data.important[GetLocale()]) then
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
            if data.new and data.new[GetLocale()] and
                next(data.new[GetLocale()]) then
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
            if data.bugfix and data.bugfix[GetLocale()] and
                next(data.bugfix[GetLocale()]) then
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
            if data.improvment and data.improvment[GetLocale()] and
                next(data.improvment[GetLocale()]) then
                improvment_localized = data.improvment[GetLocale()]
            elseif data.improvment and data.improvment["enUS"] then
                improvment_localized = data.improvment["enUS"]
            end

            if improvment_localized and #improvment_localized > 0 then
                page.improvmentHeader = {
                    order = 9,
                    type = "header",
                    name = orange(L["Improvment"])
                }
                page.improvment = {
                    order = 10,
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

function KeystonePolaris:GetBossNumberString(num)
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

function KeystonePolaris:ResetAllDungeons()
    local self = KeystonePolaris
    -- Reset all dungeons to their defaults
    for _, expansion in ipairs(expansions) do
        local dungeonIds = self[expansion.id .. "_DUNGEON_IDS"]
        if dungeonIds then
            for dungeonKey, _ in pairs(dungeonIds) do
                -- Get the appropriate defaults
                local defaults
                for _, expansion in ipairs(expansions) do
                    if self[expansion.id .. "_DUNGEON_IDS"][dungeonKey] then
                        defaults =
                            self[expansion.id .. "_DEFAULTS"][dungeonKey]
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
    LibStub("AceConfigRegistry-3.0"):NotifyChange("KeystonePolaris")
end

function KeystonePolaris:ResetCurrentSeasonDungeons(specificDungeons)
    local self = KeystonePolaris

    -- Get the current date
    local currentDate = date("%Y-%m-%d")

    -- Find the most recent season
    local mostRecentSeasonDate = nil
    local currentSeasonId = nil

    for seasonDate, _ in pairs(self.SEASON_START_DATES) do
        if seasonDate <= currentDate and
            (not mostRecentSeasonDate or seasonDate > mostRecentSeasonDate) then
            currentSeasonId = self.SEASON_START_DATES[seasonDate]
            mostRecentSeasonDate = seasonDate
        end
    end

    if currentSeasonId then
        local seasonDungeonsTabName = currentSeasonId .. "_DUNGEONS"
        local seasonDungeons = self[seasonDungeonsTabName]

        if seasonDungeons then
            -- Reset only the current season dungeons to their defaults
            for dungeonId, _ in pairs(seasonDungeons) do
                local dungeonKey = self:GetDungeonKeyById(dungeonId)
                if dungeonKey then
                    -- If specificDungeons is provided, only reset those dungeons
                    if specificDungeons and not specificDungeons[dungeonKey] then
                        -- Skip this dungeon as it's not in the list of dungeons to reset
                    else
                        -- Find the appropriate defaults for this dungeon
                        local defaults
                        for _, expansion in ipairs(expansions) do
                            if self[expansion.id .. "_DUNGEON_IDS"] and
                                self[expansion.id .. "_DUNGEON_IDS"][dungeonKey] then
                                defaults =
                                    self[expansion.id .. "_DEFAULTS"][dungeonKey]
                                break
                            end
                        end

                        if defaults then
                            if not self.db.profile.advanced[dungeonKey] then
                                self.db.profile.advanced[dungeonKey] = {}
                            end
                            for key, value in pairs(defaults) do
                                self.db.profile.advanced[dungeonKey][key] =
                                    value
                            end
                        end
                    end
                end
            end
        end
    end

    -- Update the display
    self:UpdateDungeonData()
    LibStub("AceConfigRegistry-3.0"):NotifyChange("KeystonePolaris")
end

function KeystonePolaris:CheckForNewSeason()
    local self = KeystonePolaris
    local currentDate = date("%Y-%m-%d")

    -- If this is first load (lastSeasonCheck is empty), just set the date and don't show popup
    if not self.db.profile.lastSeasonCheck or self.db.profile.lastSeasonCheck ==
        "" then
        self.db.profile.lastSeasonCheck = currentDate
        return
    end

    -- Find the most recent season start date
    local mostRecentSeasonDate = nil
    for seasonDate, _ in pairs(self.SEASON_START_DATES) do
        if seasonDate <= currentDate and
            (not mostRecentSeasonDate or seasonDate > mostRecentSeasonDate) then
            local seasonDungeonsTabName =
                self.SEASON_START_DATES[seasonDate] .. "_DUNGEONS"
            currentSeasonDungeons = self[seasonDungeonsTabName]
            mostRecentSeasonDate = seasonDate
        end
    end

    -- If last check was before the most recent season start, show popup
    if mostRecentSeasonDate and self.db.profile.lastSeasonCheck <
        mostRecentSeasonDate and not InCombatLockdown() then
        StaticPopupDialogs["KPL_NEW_SEASON"] = {
            text = "|cffffd100Keystone Polaris|r\n\n" ..
                L["NEW_SEASON_RESET_PROMPT"] .. "\n\n",
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
            title = "Keystone Polaris"
        }
        StaticPopup_Show("KPL_NEW_SEASON")
    end
end

function KeystonePolaris:CheckForNewRoutes()
    local currentVersion = C_AddOns.GetAddOnMetadata("KeystonePolaris",
                                                     "Version")
    local lastVersionCheck = self.db.profile.general.lastVersionCheck or ""
    local lastSeasonCheck = self.db.profile.lastSeasonCheck or ""
    local lastRoutesUpdate = self.lastRoutesUpdate or ""

    -- Get the current date
    local currentDate = date("%Y-%m-%d")

    -- If it's the first version check but the user already had a previous version installed
    -- (indicated by lastSeasonCheck being populated), and we need to prompt for route reset
    if lastVersionCheck == "" and self.db.profile.general.advancedOptionsEnabled and
        currentDate > lastSeasonCheck and not InCombatLockdown() then
        local changedDungeonsText = self:GetChangedDungeonsText()

        StaticPopupDialogs["KPL_NEW_ROUTES"] = {
            text = "|cffffd100Keystone Polaris|r\n\n" ..
                L["NEW_ROUTES_RESET_PROMPT"] .. "\n\n" .. changedDungeonsText,
            button1 = L["RESET_ALL"],
            button2 = L["NO"],
            button3 = (self.CHANGED_ROUTES_DUNGEONS and
                next(self.CHANGED_ROUTES_DUNGEONS)) and L["RESET_CHANGED_ONLY"] or
                nil,
            OnAccept = function()
                -- Reset all current season dungeon values
                self:ResetCurrentSeasonDungeons()
                self.db.profile.general.lastVersionCheck = currentVersion
            end,
            OnAlt = function()
                -- Reset only dungeons with changed routes
                self:ResetCurrentSeasonDungeons(self.CHANGED_ROUTES_DUNGEONS)
                self.db.profile.general.lastVersionCheck = currentVersion
            end,
            OnCancel = function()
                self.db.profile.general.lastVersionCheck = currentVersion
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
            showAlert = true,
            title = "Keystone Polaris"
        }
        StaticPopup_Show("KPL_NEW_ROUTES")
        return
        -- If it's the first initialization of the addon (both checks are empty), just store the current version
    elseif lastVersionCheck == "" and lastSeasonCheck == "" then
        self.db.profile.general.lastVersionCheck = currentVersion
        return
    end

    -- If the version has changed and we need to prompt for route reset
    local prevWasBeta = (lastVersionCheck ~= "" and lastVersionCheck:lower():find("beta", 1, true) ~= nil)
    if lastVersionCheck ~= currentVersion and
        self.db.profile.general.advancedOptionsEnabled and
        not InCombatLockdown() and
        currentDate > lastSeasonCheck and
        (((lastRoutesUpdate > lastVersionCheck or lastVersionCheck == "") and currentVersion >= lastRoutesUpdate) or prevWasBeta) then

        local changedDungeonsText = self:GetChangedDungeonsText()

        StaticPopupDialogs["KPL_NEW_ROUTES"] = {
            text = "|cffffd100Keystone Polaris|r\n\n" ..
                L["NEW_ROUTES_RESET_PROMPT"] .. "\n\n" .. changedDungeonsText,
            button1 = L["RESET_ALL"],
            button2 = L["NO"],
            button3 = (self.CHANGED_ROUTES_DUNGEONS and
                next(self.CHANGED_ROUTES_DUNGEONS)) and L["RESET_CHANGED_ONLY"] or
                nil,
            OnAccept = function()
                -- Reset all current season dungeon values
                self:ResetCurrentSeasonDungeons()
                self.db.profile.general.lastVersionCheck = currentVersion
            end,
            OnAlt = function()
                -- Reset only dungeons with changed routes
                self:ResetCurrentSeasonDungeons(self.CHANGED_ROUTES_DUNGEONS)
                self.db.profile.general.lastVersionCheck = currentVersion
            end,
            OnCancel = function()
                self.db.profile.general.lastVersionCheck = currentVersion
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
            showAlert = true,
            title = "Keystone Polaris"
        }
        StaticPopup_Show("KPL_NEW_ROUTES")
    else
        -- Update the version check without prompting
        self.db.profile.general.lastVersionCheck = currentVersion
    end
end

function KeystonePolaris:GetChangedDungeonsText()
    local self = KeystonePolaris
    local changedDungeonsText = ""

    -- Vérifier si la table CHANGED_ROUTES_DUNGEONS existe et n'est pas vide
    if self.CHANGED_ROUTES_DUNGEONS and next(self.CHANGED_ROUTES_DUNGEONS) then
        changedDungeonsText = L["CHANGED_ROUTES_DUNGEONS_LIST"] .. "\n"

        for dungeonKey, _ in pairs(self.CHANGED_ROUTES_DUNGEONS) do
            local displayName = self:GetDungeonDisplayName(dungeonKey) or
                                    dungeonKey
            changedDungeonsText = changedDungeonsText .. "- " .. displayName ..
                                      "\n"
        end
        changedDungeonsText = changedDungeonsText .. "\n"
    end

    return changedDungeonsText
end

function KeystonePolaris:GetDungeonDisplayName(dungeonKey)
    if not dungeonKey then return "Unknown Dungeon" end

    local mapId = self:GetDungeonIdByKey(dungeonKey)

    local name
    if mapId then
        name, _, _, _ = C_ChallengeMode.GetMapUIInfo(mapId)
        return name
    end

    -- Fallback: Try to make the key look presentable
    name = dungeonKey:gsub("_", " ")
    name = name:gsub("(%l)(%u)", "%1 %2") -- Add space between lower and upper case
    name = name:gsub("^%l", string.upper) -- Capitalize first letter
    return name
end

-- Global export function for dungeon settings
function KeystonePolaris:ExportDungeonSettings(dungeonData, exportType,
                                                        sectionName)
    -- Create export string
    local exportData = {
        type = exportType,
        section = sectionName,
        data = dungeonData
    }
    local serialized = LibStub("AceSerializer-3.0"):Serialize(exportData)
    local compressed = LibStub("LibDeflate"):CompressDeflate(serialized)
    local encoded = LibStub("LibDeflate"):EncodeForPrint(compressed)

    -- Determine dialog text based on export type
    local dialogText
    if exportType == "all_dungeons" then
        dialogText = L["EXPORT_ALL_DIALOG_TEXT"]
    elseif exportType == "section" then
        dialogText = (L["EXPORT_SECTION_DIALOG_TEXT"]):format(sectionName)
    else
        dialogText = L["EXPORT_DIALOG_TEXT"]
    end

    -- Show export dialog
    StaticPopupDialogs["KPL_EXPORT_DIALOG"] = {
        text = dialogText,
        button1 = OKAY,
        hasEditBox = true,
        editBoxWidth = 350,
        maxLetters = 999999,
        OnShow = function(dialog)
            dialog.EditBox:SetText(encoded)
            dialog.EditBox:HighlightText()
            dialog.EditBox:SetFocus()
        end,
        EditBoxOnEscapePressed = function(editBox)
            editBox:GetParent():Hide()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true
    }
    StaticPopup_Show("KPL_EXPORT_DIALOG")
end

-- Global import function for dungeon settings
function KeystonePolaris:ImportDungeonSettings(importString,
                                                        sectionName,
                                                        dungeonFilter)
    local addon = self
    local decoded = LibStub("LibDeflate"):DecodeForPrint(importString)
    if not decoded then
        print("|cffdb6233Keystone Polaris:|r " .. L["IMPORT_ERROR"])
        return false
    end

    local decompressed = LibStub("LibDeflate"):DecompressDeflate(decoded)
    if not decompressed then
        print("|cffdb6233Keystone Polaris:|r " .. L["IMPORT_ERROR"])
        return false
    end

    local success, importData = LibStub("AceSerializer-3.0"):Deserialize(
                                    decompressed)
    if not success then
        print("|cffdb6233Keystone Polaris:|r " .. L["IMPORT_ERROR"])
        return false
    end

    local importCount = 0

    -- Handle different import types
    if importData.type == "all_dungeons" and importData.data then
        -- Import all dungeon data (filtered by dungeonFilter if provided)
        for dungeonKey, dungeonData in pairs(importData.data) do
            if not dungeonFilter or dungeonFilter[dungeonKey] then
                local dungeonId = addon:GetDungeonIdByKey(dungeonKey)
                if dungeonId and addon.DUNGEONS[dungeonId] then
                    if not addon.db.profile.advanced[dungeonKey] then
                        addon.db.profile.advanced[dungeonKey] = {}
                    end
                    for k, v in pairs(dungeonData) do
                        addon.db.profile.advanced[dungeonKey][k] = v
                    end
                    importCount = importCount + 1
                end
            end
        end
    elseif importData.type == "section" and importData.data then
        -- Import section data (filtered by dungeonFilter if provided)
        for dungeonKey, dungeonData in pairs(importData.data) do
            if not dungeonFilter or dungeonFilter[dungeonKey] then
                local dungeonId = addon:GetDungeonIdByKey(dungeonKey)
                if dungeonId and addon.DUNGEONS[dungeonId] then
                    if not addon.db.profile.advanced[dungeonKey] then
                        addon.db.profile.advanced[dungeonKey] = {}
                    end
                    for k, v in pairs(dungeonData) do
                        addon.db.profile.advanced[dungeonKey][k] = v
                    end
                    importCount = importCount + 1
                end
            end
        end
    elseif importData.dungeon then
        -- Handle single dungeon import for backward compatibility
        local dungeonKey = importData.dungeon
        if not dungeonFilter or dungeonFilter[dungeonKey] then
            local dungeonId = addon:GetDungeonIdByKey(dungeonKey)
            if dungeonId and addon.DUNGEONS[dungeonId] then
                if not addon.db.profile.advanced[dungeonKey] then
                    addon.db.profile.advanced[dungeonKey] = {}
                end
                for k, v in pairs(importData.data) do
                    addon.db.profile.advanced[dungeonKey][k] = v
                end
                addon:UpdateDungeonData()
                LibStub("AceConfigRegistry-3.0"):NotifyChange(
                    "KeystonePolaris")
                print("|cffdb6233Keystone Polaris:|r " ..
                          L["IMPORT_SUCCESS"]:format(
                              addon:GetDungeonDisplayName(dungeonKey)))
                return true
            end
        end
        print("|cffdb6233Keystone Polaris:|r " .. L["IMPORT_ERROR"])
        return false
    else
        print("|cffdb6233Keystone Polaris:|r " .. L["IMPORT_ERROR"])
        return false
    end

    -- Update data and notify of changes
    if importCount > 0 then
        addon:UpdateDungeonData()
        LibStub("AceConfigRegistry-3.0"):NotifyChange("KeystonePolaris")

        -- Determine success message based on import type
        if importData.type == "all_dungeons" then
            print("|cffdb6233Keystone Polaris:|r " ..
                      (L["IMPORT_ALL_SUCCESS"]))
        elseif importData.type == "section" then
            print("|cffdb6233Keystone Polaris:|r " ..
                      (L["IMPORT_SUCCESS"]):format(sectionName))
        end
        return true
    else
        print("|cffdb6233Keystone Polaris:|r " .. (L["IMPORT_ERROR"]))
        return false
    end
end

-- Global function to create import dialog
function KeystonePolaris:ShowImportDialog(sectionName, dungeonFilter)
    local addon = self
    local dialogText

    if not sectionName then
        dialogText = L["IMPORT_ALL_DIALOG_TEXT"]
    else
        dialogText = (L["IMPORT_SECTION_DIALOG_TEXT"]):format(sectionName)
    end

    StaticPopupDialogs["KPL_IMPORT_DIALOG"] = {
        text = dialogText,
        button1 = OKAY,
        button2 = CANCEL,
        hasEditBox = true,
        editBoxWidth = 350,
        maxLetters = 999999,
        OnAccept = function(dialog)
            local importString = dialog.EditBox:GetText()
            addon:ImportDungeonSettings(importString, sectionName, dungeonFilter)
        end,
        EditBoxOnEscapePressed = function(editBox)
            editBox:GetParent():Hide()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true
    }
    StaticPopup_Show("KPL_IMPORT_DIALOG")
end

function KeystonePolaris:GenerateExpansionTables(expansionId,
                                                          dungeonData)
    -- Initialize the tables if they don't exist
    self[expansionId .. "_DUNGEONS"] = self[expansionId .. "_DUNGEONS"] or {}
    self[expansionId .. "_DEFAULTS"] = self[expansionId .. "_DEFAULTS"] or {}
    self[expansionId .. "_DUNGEON_IDS"] =
        self[expansionId .. "_DUNGEON_IDS"] or {}

    -- Clear existing data if any
    wipe(self[expansionId .. "_DUNGEONS"])
    wipe(self[expansionId .. "_DEFAULTS"])
    wipe(self[expansionId .. "_DUNGEON_IDS"])

    for shortName, dungeonData in pairs(dungeonData) do
        -- Generate DUNGEONS table
        local dungeonBosses = {}
        for i, bossData in ipairs(dungeonData.bosses) do
            -- Add haveInformed = false to each boss entry
            dungeonBosses[i] = {bossData[1], bossData[2], bossData[3], false}
        end
        self[expansionId .. "_DUNGEONS"][dungeonData.id] = dungeonBosses

        -- Generate DEFAULTS table
        local defaults = {}
        for i, bossData in ipairs(dungeonData.bosses) do
            local bossNumber = "Boss" .. self:GetBossNumberString(i)
            defaults[bossNumber] = bossData[2]
            defaults[bossNumber .. "Inform"] = bossData[3]
        end
        self[expansionId .. "_DEFAULTS"][shortName] = defaults

        -- Generate DUNGEON_IDS table
        self[expansionId .. "_DUNGEON_IDS"][shortName] = dungeonData.id
    end
end
