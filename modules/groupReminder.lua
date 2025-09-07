local AddOnName, KeystonePercentageHelper = ...
local L = KeystonePercentageHelper.L

-- Minimal Group Reminder with simple options: enable, showPopup, showChat
-- Triggers on 'inviteaccepted' only and filters to Mythic+ activities

-- Inject defaults
KeystonePercentageHelper.defaults = KeystonePercentageHelper.defaults or { profile = {} }
KeystonePercentageHelper.defaults.profile.groupReminder = KeystonePercentageHelper.defaults.profile.groupReminder or {
    enabled = true,
    showPopup = true,
    showChat = true,
    -- line visibility
    showDungeonName = true,
    showGroupName = true,
    showGroupDescription = true,
    showAppliedRole = true,
    suppressQuickJoinToast = true,
}

-- Internal helpers
local function IsMythicPlusActivity(activityID)
    local t = C_LFGList.GetActivityInfoTable and C_LFGList.GetActivityInfoTable(activityID)
    if t and t.isMythicPlusActivity ~= nil then
        return not not t.isMythicPlusActivity
    end
    return false
end

-- Track the role used at application time by searchResultID
KeystonePercentageHelper.groupReminderRoleByResult = KeystonePercentageHelper.groupReminderRoleByResult or {}

-- Hook ApplyToGroup once to capture the role flags used for each application
if C_LFGList and C_LFGList.ApplyToGroup and not KeystonePercentageHelper._KPH_HookedApplyToGroup then
    KeystonePercentageHelper._KPH_HookedApplyToGroup = true
    local _KPH_Orig_ApplyToGroup = C_LFGList.ApplyToGroup
    C_LFGList.ApplyToGroup = function(searchResultID, tank, heal, dps, comment)
        if KeystonePercentageHelper and KeystonePercentageHelper.groupReminderRoleByResult then
            if tank then
                KeystonePercentageHelper.groupReminderRoleByResult[searchResultID] = "Tank"
            elseif heal then
                KeystonePercentageHelper.groupReminderRoleByResult[searchResultID] = "Healer"
            elseif dps then
                KeystonePercentageHelper.groupReminderRoleByResult[searchResultID] = "Damage"
            else
                KeystonePercentageHelper.groupReminderRoleByResult[searchResultID] = "-"
            end
        end
        return _KPH_Orig_ApplyToGroup(searchResultID, tank, heal, dps, comment)
    end
end

local function GetAppliedRoleText(addon, searchResultID)
    -- Prefer the role actually assigned in the group (after join)
    if type(UnitGroupRolesAssigned) == "function" then
        local assigned = UnitGroupRolesAssigned("player")
        if assigned == "TANK" then return TANK end
        if assigned == "HEALER" then return HEALER end
        if assigned == "DAMAGER" then return DAMAGER end
    end

    -- Prefer role captured at application time
    local role = addon.groupReminderRoleByResult and addon.groupReminderRoleByResult[searchResultID]
    if role then
        if role == "Tank" then return TANK end
        if role == "Healer" then return HEALER end
        if role == "Damage" then return DAMAGER end
        return role
    end
    -- Fallback to current LFG role flags
    local tank, heal, dps = GetLFGRoles()
    if tank then return TANK end
    if heal then return HEALER end
    if dps then return DAMAGER end
    return "-"
end

local function BuildMessages(db, titleText, zoneText, groupName, groupComment, roleText)
    -- Build body (without header) once
    local bodyLines = {}
    if db.showDungeonName then table.insert(bodyLines, L["KPH_GR_DUNGEON"] .. " " .. (zoneText or "-")) end
    if db.showGroupName then table.insert(bodyLines, L["KPH_GR_GROUP"] .. " " .. (groupName or "-")) end
    if db.showGroupDescription then table.insert(bodyLines, L["KPH_GR_DESCRIPTION"] .. " " .. (groupComment or "-")) end
    if db.showAppliedRole then table.insert(bodyLines, L["KPH_GR_ROLE"] .. " " .. (roleText or "-")) end
    local body = table.concat(bodyLines, "\n")

    -- Popup message: gold header + blank line + body
    local popupMsg
    if body ~= "" then
        popupMsg = "|cffffd700" .. L["KPH_GR_HEADER"] .. "|r\n\n" .. body
    else
        popupMsg = "|cffffd700" .. L["KPH_GR_HEADER"] .. "|r"
    end

    return popupMsg, body
end

function KeystonePercentageHelper:ShowGroupReminder(searchResultID, title, zone, comment)
    local db = self.db and self.db.profile and self.db.profile.groupReminder
    if not db or not db.enabled then return end

    local roleText = GetAppliedRoleText(self, searchResultID)
    local popupMsg, body = BuildMessages(db, title, zone, title, comment, roleText)

    -- Popup
    if db.showPopup then
        if not StaticPopupDialogs["GroupReminderPopUp"] then
            StaticPopupDialogs["GroupReminderPopUp"] = {
                text = "%s",
                button1 = OKAY,
                timeout = 0,
                whileDead = true,
                hideOnEscape = true,
                preferredIndex = 3,
            }
        end
        StaticPopup_Show("GroupReminderPopUp", popupMsg)
    end

    -- Chat
    if db.showChat then
        local chatHeader = "|cffdb6233" .. L["KPH_GR_HEADER"] .. "|r :"
        if body ~= "" then
            print(chatHeader .. "\n" .. body)
        else
            print(chatHeader)
        end
    end
end

function KeystonePercentageHelper:InitializeGroupReminder()
    if self.groupReminderFrame then
        -- Ensure registration reflects current settings
        self:UpdateGroupReminderRegistration()
        return
    end

    self.groupReminderFrame = CreateFrame("Frame")
    self.groupReminderFrame:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")

    self.groupReminderFrame:SetScript("OnEvent", function(_, event, ...)
        if event ~= "LFG_LIST_APPLICATION_STATUS_UPDATED" then return end

        local searchResultID, newStatus = ...
        if not searchResultID or not newStatus then return end

        -- Capture role at application time
        if newStatus == "applied" then
            -- Removed role capture here, now handled by hooking ApplyToGroup
            return
        end

        -- Show reminder when the invite is accepted (joined)
        if newStatus ~= "inviteaccepted" then return end

        local srd = C_LFGList.GetSearchResultInfo and C_LFGList.GetSearchResultInfo(searchResultID)
        if not srd then return end

        -- Some APIs return multiple activityIDs; prefer the first when present
        local activityID = (srd.activityIDs and srd.activityIDs[1]) or srd.activityID
        if not activityID then return end

        if not IsMythicPlusActivity(activityID) then return end

        local activity = C_LFGList.GetActivityInfoTable and C_LFGList.GetActivityInfoTable(activityID)
        if not activity then return end

        print(activity.mapID)
        -- Hide Blizzard's LFG invite dialog if it's still visible (post-accept)
        if self.db.profile.groupReminder.suppressQuickJoinToast and type(LFGListInviteDialog) == "table" and LFGListInviteDialog.Hide then
            if LFGListInviteDialog:IsShown() then
                LFGListInviteDialog:Hide()
            end
        end

        local title = srd.name or ""
        local zone = activity.fullName or ""
        local comment = srd.comment or ""
        -- Delay slightly to allow group roster to update so UnitGroupRolesAssigned returns the accepted role
        C_Timer.After(0.2, function()
            self:ShowGroupReminder(searchResultID, title, zone, comment)
        end)

        -- Cleanup stored role for this application
        self.groupReminderRoleByResult[searchResultID] = nil
    end)
end

function KeystonePercentageHelper:DisableGroupReminder()
    if self.groupReminderFrame then
        self.groupReminderFrame:UnregisterAllEvents()
    end
end

function KeystonePercentageHelper:UpdateGroupReminderRegistration()
    local db = self.db and self.db.profile and self.db.profile.groupReminder
    if not db then return end
    if db.enabled then
        if not self.groupReminderFrame then
            self:InitializeGroupReminder()
            return
        end
        self.groupReminderFrame:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")
    else
        self:DisableGroupReminder()
    end
end

-- Ensure Blizzard UI related to group invites/toasts is visible again
function KeystonePercentageHelper:RestoreBlizzardJoinUI()
    if type(LFGListInviteDialog) == "table" and LFGListInviteDialog.Show then
        LFGListInviteDialog:Show()
    end
end

function KeystonePercentageHelper:GetGroupReminderOptions()
    local self = KeystonePercentageHelper
    return {
        name = "Group Reminder",
        type = "group",
        order = 1,
        args = {
            header = { order = 0, type = "header", name = "Group Reminder" },
            enable = {
                name = "Enable",
                type = "toggle",
                width = "full",
                order = 1,
                get = function() return self.db.profile.groupReminder.enabled end,
                set = function(_, value)
                    self.db.profile.groupReminder.enabled = value
                    if value then self:InitializeGroupReminder() else self:DisableGroupReminder() end
                end,
            },
            behavior = {
                name = "Options",
                type = "group",
                inline = true,
                order = 2,
                args = {
                    suppressQuickJoinToast = {
                        name = "Suppress Blizzard quick-join toast",
                        type = "toggle",
                        order = 0,
                        get = function() return self.db.profile.groupReminder.suppressQuickJoinToast end,
                        set = function(_, v)
                            self.db.profile.groupReminder.suppressQuickJoinToast = v
                            -- If turning suppression OFF while not in group, restore Blizzard UI now for future invites
                            if (not v) and (not IsInGroup()) and self.RestoreBlizzardJoinUI then
                                self:RestoreBlizzardJoinUI()
                            end
                        end,
                        disabled = function() return not self.db.profile.groupReminder.enabled end,
                    },
                    showPopup = {
                        name = "Show popup",
                        type = "toggle",
                        order = 1,
                        get = function() return self.db.profile.groupReminder.showPopup end,
                        set = function(_, v) self.db.profile.groupReminder.showPopup = v end,
                        disabled = function() return not self.db.profile.groupReminder.enabled end,
                    },
                    showChat = {
                        name = "Show chat message",
                        type = "toggle",
                        order = 2,
                        get = function() return self.db.profile.groupReminder.showChat end,
                        set = function(_, v) self.db.profile.groupReminder.showChat = v end,
                        disabled = function() return not self.db.profile.groupReminder.enabled end,
                    },
                    showDungeonName = {
                        name = "Show dungeon name",
                        type = "toggle",
                        order = 3,
                        get = function() return self.db.profile.groupReminder.showDungeonName end,
                        set = function(_, v) self.db.profile.groupReminder.showDungeonName = v end,
                        disabled = function() return not self.db.profile.groupReminder.enabled end,
                    },
                    showGroupName = {
                        name = "Show group name",
                        type = "toggle",
                        order = 4,
                        get = function() return self.db.profile.groupReminder.showGroupName end,
                        set = function(_, v) self.db.profile.groupReminder.showGroupName = v end,
                        disabled = function() return not self.db.profile.groupReminder.enabled end,
                    },
                    showGroupDescription = {
                        name = "Show group description",
                        type = "toggle",
                        order = 5,
                        get = function() return self.db.profile.groupReminder.showGroupDescription end,
                        set = function(_, v) self.db.profile.groupReminder.showGroupDescription = v end,
                        disabled = function() return not self.db.profile.groupReminder.enabled end,
                    },
                    showAppliedRole = {
                        name = "Show applied role",
                        type = "toggle",
                        order = 6,
                        get = function() return self.db.profile.groupReminder.showAppliedRole end,
                        set = function(_, v) self.db.profile.groupReminder.showAppliedRole = v end,
                        disabled = function() return not self.db.profile.groupReminder.enabled end,
                    },
                },
            },
        },
    }
end