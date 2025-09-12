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

-- Teleport lookup from expansions data by mapID
function KeystonePercentageHelper:GetTeleportCandidatesForMapID(mapID)
    if not mapID then return nil end
    local candidates
    local expansions = {
        self.TWW_DUNGEON_DATA,
        self.SL_DUNGEON_DATA,
        self.BFA_DUNGEON_DATA,
        self.CATACLYSM_DUNGEON_DATA,
        self.LEGION_DUNGEON_DATA,
    }
    for _, data in ipairs(expansions) do
        if type(data) == "table" then
            for _, d in pairs(data) do
                if type(d) == "table" and d.mapID == mapID and d.teleportID ~= nil then
                    candidates = d.teleportID
                    break
                end
            end
        end
        if candidates then break end
    end
    return candidates
end

function KeystonePercentageHelper:GetTeleportSpellForMapID(mapID)
    local cands = self:GetTeleportCandidatesForMapID(mapID)
    if not cands then return nil end
    if type(cands) == "number" then
        return (IsSpellKnown and IsSpellKnown(cands)) and cands or nil
    elseif type(cands) == "table" then
        for _, id in ipairs(cands) do
            if IsSpellKnown and IsSpellKnown(id) then
                return id
            end
        end
    end
    return nil
end

-- Small secure frame opened from chat link to perform the protected cast on user click
local function EnsureTeleportClickFrame(self)
    if self.teleportClickFrame then return self.teleportClickFrame end
    local f = CreateFrame("Frame", "KPH_TeleportClickSecure", UIParent, "BackdropTemplate")
    f:SetSize(260, 80)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:SetClampedToScreen(true)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 32, edgeSize = 12,
        insets = { left = 8, right = 8, top = 8, bottom = 8 }
    })

    f.Title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.Title:SetPoint("TOP", 0, -12)
    f.Title:SetText(L["KPH_GR_TELEPORT"] or "Teleport to dungeon")

    -- Create a text-like secure button
    f.LinkButton = CreateFrame("Button", nil, f, "SecureActionButtonTemplate")
    f.LinkButton:SetPoint("CENTER", 0, -5)
    f.LinkButton:SetSize(200, 18)
    local fs = f.LinkButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    fs:SetPoint("LEFT")
    fs:SetText("|cff00aaff[" .. (L["KPH_GR_TELEPORT"] or "Teleport to dungeon") .. "]|r")
    f.LinkButtonText = fs

    f.Close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    f.Close:SetPoint("TOPRIGHT", 0, 0)

    f:Hide()
    self.teleportClickFrame = f
    return f
end

function KeystonePercentageHelper:ShowTeleportClickFrame(spellID)
    local f = EnsureTeleportClickFrame(self)
    local spellName
    if C_Spell and C_Spell.GetSpellName then
        spellName = C_Spell.GetSpellName(spellID)
    elseif GetSpellInfo then
        spellName = (GetSpellInfo(spellID))
    end
    if spellID and spellName and IsSpellKnown and IsSpellKnown(spellID) then
        f.LinkButton:SetAttribute("type", "macro")
        f.LinkButton:SetAttribute("macrotext", "/cast " .. spellName)
        f:Show()
    else
        f:Hide()
    end
end

-- Clickable chat link handler: opens secure click frame instead of casting directly
if not KeystonePercentageHelper._KPH_TeleportChatLinkHooked then
    KeystonePercentageHelper._KPH_TeleportChatLinkHooked = true
    local _KPH_Orig_SetItemRef = SetItemRef
    SetItemRef = function(link, text, button, chatFrame)
        if type(link) == "string" then
            local linkType, rest = strsplit(":", link, 2)
            if linkType == "kphteleport" then
                local spellID = tonumber(rest or "")
                if spellID then
                    if KeystonePercentageHelper and KeystonePercentageHelper.ShowTeleportClickFrame then
                        KeystonePercentageHelper:ShowTeleportClickFrame(spellID)
                    end
                end
                return
            end
        end
        return _KPH_Orig_SetItemRef(link, text, button, chatFrame)
    end
end

-- Styled popup UI with a text hyperlink (secure button) to teleport
local function GuessRoleKey(roleText)
    if type(roleText) ~= "string" then return nil end
    local up = string.upper(roleText)
    if up == "TANK" or roleText == TANK then return "TANK" end
    if up == "HEALER" or roleText == HEALER then return "HEALER" end
    if up == "DAMAGER" or up == "DAMAGE" or roleText == DAMAGER then return "DAMAGER" end
end

local function EnsureGroupReminderStyledFrame(self)
    if self.groupReminderStyledFrame then return self.groupReminderStyledFrame end

    local f = CreateFrame("Frame", "KPH_GroupReminderStyled", UIParent, "BackdropTemplate")
    f:SetSize(420, 220)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:SetClampedToScreen(true)
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 32, edgeSize = 12,
        insets = { left = 8, right = 8, top = 8, bottom = 8 }
    })

    table.insert(UISpecialFrames, "KPH_GroupReminderStyled")

    f.Title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    f.Title:SetPoint("TOPLEFT", 16, -12)
    f.Title:SetText(L["KPH_GR_HEADER"] or "Group Reminder")

    f.Icon = f:CreateTexture(nil, "ARTWORK")
    f.Icon:SetSize(28, 28)
    f.Icon:SetPoint("TOPRIGHT", -16, -12)

    f.HeaderLine = f:CreateTexture(nil, "BORDER")
    f.HeaderLine:SetColorTexture(1, 0.6, 0.2, 0.9)
    f.HeaderLine:SetHeight(2)
    f.HeaderLine:SetPoint("TOPLEFT", 12, -44)
    f.HeaderLine:SetPoint("TOPRIGHT", -12, -44)

    f.BodyLines = {}
    local y = -60
    for i = 1, 4 do
        local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        fs:SetPoint("TOPLEFT", 16, y)
        fs:SetWidth(380)
        fs:SetJustifyH("LEFT")
        fs:SetText("")
        f.BodyLines[i] = fs
        y = y - 18
    end

    -- Text-like secure link for teleport
    f.TeleportLink = CreateFrame("Button", nil, f, "SecureActionButtonTemplate")
    f.TeleportLink:SetPoint("BOTTOMLEFT", 16, 12)
    f.TeleportLink:SetSize(200, 18)
    local tl = f.TeleportLink:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    tl:SetPoint("LEFT")
    tl:SetText("|cff00aaff[" .. (L["KPH_GR_TELEPORT"] or "Teleport to dungeon") .. "]|r")
    f.TeleportLinkText = tl

    f.Close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    f.Close:SetPoint("TOPRIGHT", 0, 0)

    f:Hide()
    self.groupReminderStyledFrame = f
    return f
end

function KeystonePercentageHelper:ShowStyledGroupReminderPopup(title, zone, groupName, groupComment, roleText, teleportSpellID)
    local db = self.db.profile.groupReminder
    local f = EnsureGroupReminderStyledFrame(self)
    f.Title:SetText(L["KPH_GR_HEADER"] or "Group Reminder")

    -- Role icon
    local roleKey = GuessRoleKey(roleText or "")
    if roleKey and GetTexCoordsForRoleSmallCircle then
        local l, r, t, b = GetTexCoordsForRoleSmallCircle(roleKey)
        f.Icon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-ROLES")
        f.Icon:SetTexCoord(l, r, t, b)
        f.Icon:Show()
    else
        f.Icon:SetTexture(136116)
        f.Icon:SetTexCoord(0, 1, 0, 1)
        f.Icon:Show()
    end

    local lines = {}
    if db.showDungeonName then table.insert(lines, (L["KPH_GR_DUNGEON"] or "Dungeon:") .. " " .. (zone or "-")) end
    if db.showGroupName then table.insert(lines, (L["KPH_GR_GROUP"] or "Group:") .. " " .. (groupName or "-")) end
    if db.showGroupDescription then table.insert(lines, (L["KPH_GR_DESCRIPTION"] or "Description:") .. " " .. (groupComment or "-")) end
    if db.showAppliedRole then table.insert(lines, (L["KPH_GR_ROLE"] or "Role:") .. " " .. (roleText or "-")) end

    for i = 1, 4 do
        local text = lines[i]
        local fs = f.BodyLines[i]
        if text then
            fs:SetText(text)
            fs:Show()
        else
            fs:SetText("")
            fs:Hide()
        end
    end

    -- Configure teleport link (secure button) only if spell is known
    if teleportSpellID and IsSpellKnown and IsSpellKnown(teleportSpellID) then
        local spellName
        if C_Spell and C_Spell.GetSpellName then
            spellName = C_Spell.GetSpellName(teleportSpellID)
        elseif GetSpellInfo then
            spellName = (GetSpellInfo(teleportSpellID))
        end
        if spellName then
            f.TeleportLink:SetAttribute("type", "macro")
            f.TeleportLink:SetAttribute("macrotext", "/cast " .. spellName)
            f.TeleportLink:Show()
        else
            f.TeleportLink:Hide()
        end
    else
        f.TeleportLink:Hide()
    end

    f:Show()
end

function KeystonePercentageHelper:ShowGroupReminder(searchResultID, title, zone, comment, activityMapID)
    local db = self.db and self.db.profile and self.db.profile.groupReminder
    if not db or not db.enabled then return end

    local roleText = GetAppliedRoleText(self, searchResultID)
    local popupMsg, body = BuildMessages(db, title, zone, title, comment, roleText)

    -- Resolve teleport spell for this dungeon
    local teleportSpellID = self:GetTeleportSpellForMapID(activityMapID)

    -- Popup
    if db.showPopup then
        self:ShowStyledGroupReminderPopup(title, zone, title, comment, roleText, teleportSpellID)
    end

    -- Chat
    if db.showChat then
        local chatHeader = "|cffdb6233" .. (L["KPH_GR_HEADER"] or "Group Reminder") .. "|r :"
        if body ~= "" then
            print(chatHeader .. "\n" .. body)
        else
            print(chatHeader)
        end
        if teleportSpellID and (not IsSpellKnown or IsSpellKnown(teleportSpellID)) then
            local linkText = L["KPH_GR_TELEPORT"] or "Teleport to dungeon"
            local link = string.format("|Hkphteleport:%d|h[%s]|h", teleportSpellID, linkText)
            print(link)
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

        -- Hide Blizzard's LFG invite dialog if it's still visible (post-accept)
        if self.db.profile.groupReminder.suppressQuickJoinToast and type(LFGListInviteDialog) == "table" and LFGListInviteDialog.Hide then
            if LFGListInviteDialog:IsShown() then
                LFGListInviteDialog:Hide()
            end
        end

        local title = srd.name or ""
        local zone = activity.fullName or ""
        local comment = srd.comment or ""
        local mapID = activity.mapID
        -- Delay slightly to allow group roster to update so UnitGroupRolesAssigned returns the accepted role
        C_Timer.After(0.2, function()
            self:ShowGroupReminder(searchResultID, title, zone, comment, mapID)
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