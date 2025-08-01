local AddonName, Engine = ...;

local LibStub = LibStub;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddonName, "itIT", false, false);
if not L then return end

-- TRANSLATION REQUIRED

-- Dungeons Group
L["DUNGEONS"] = "Current Season"
L["CURRENT_SEASON"] = "Current Season"
L["NEXT_SEASON"] = "Next Season"
L["EXPANSION_DF"] = "Dragonflight"
L["EXPANSION_CATA"] = "Cataclysm"
L["EXPANSION_WW"] = "The War Within"
L["EXPANSION_SL"] = "Shadowlands"
L["EXPANSION_BFA"] = "Battle for Azeroth"
L["EXPANSION_LEGION"] = "Legion"

-- The War Within
-- Ara-Kara, City of Echoes
L["AKCE_BOSS1"] = "Avanoxx"
L["AKCE_BOSS2"] = "Anub'zekt"
L["AKCE_BOSS3"] = "Ki'katal the Harvester"

-- City of Threads
L["CoT_BOSS1"] = "Orator Krix'vizk"
L["CoT_BOSS2"] = "Fangs of the Queen"
L["CoT_BOSS3"] = "The Coaglamation"
L["CoT_BOSS4"] = "Izo, the Grand Splicer"

-- Cinderbrew Meadery
L["CBM_BOSS1"] = "Brew Master Aldryr"
L["CBM_BOSS2"] = "I'pa"
L["CBM_BOSS3"] = "Benk Buzzbee"
L["CBM_BOSS4"] = "Goldie Baronbottom"

-- Darkflame Cleft
L["DFC_BOSS1"] = "Ol' Waxbeard"
L["DFC_BOSS2"] = "Blazikon"
L["DFC_BOSS3"] = "The Candle King"
L["DFC_BOSS4"] = "The Darkness"

-- Eco-Dome Al'Dani
L["EDAD_BOSS1"] = "Azhiccar"
L["EDAD_BOSS2"] = "Taah'bat and A'wazj"
L["EDAD_BOSS3"] = "Soul-Scribe"

-- Operation: Floodgate
L["OFG_BOSS1"] = "Big M.O.M.M.A."
L["OFG_BOSS2"] = "Demolition Duo"
L["OFG_BOSS3"] = "Swampface"
L["OFG_BOSS4"] = "Geezle Gigazap"

-- Priory of the Sacred Flames
L["PotSF_BOSS1"] = "Captain Dailcry"
L["PotSF_BOSS2"] = "Baron Braunpyke"
L["PotSF_BOSS3"] = "Prioress Murrpray"

-- The Dawnbreaker
L["TDB_BOSS1"] = "Speaker Shadowcrown"
L["TDB_BOSS2"] = "Anub'ikkaj"
L["TDB_BOSS3"] = "Rasha'nan"

-- The Rookery
L["TR_BOSS1"] = "Kyrioss"
L["TR_BOSS2"] = "Stormguard Gorren"
L["TR_BOSS3"] = "Voidstone Monstrosity"

-- The Stonevault
L["TSV_BOSS1"] = "E.D.N.A."
L["TSV_BOSS2"] = "Skarmorak"
L["TSV_BOSS3"] = "Master Machinists"
L["TSV_BOSS4"] = "Void Speaker Eirich"

-- Shadowlands
-- Mists of Tirna Scithe
L["MoTS_BOSS1"] = "Ingra Maloch"
L["MoTS_BOSS2"] = "Mistcaller"
L["MoTS_BOSS3"] = "Tred'ova"

--Theater of Pain
L["ToP_BOSS1"] = "An Affront of Challengers"
L["ToP_BOSS2"] = "Gorechop"
L["ToP_BOSS3"] = "Xav the Unfallen"
L["ToP_BOSS4"] = "Kul'tharok"
L["ToP_BOSS5"] = "Mordretha, the Endless Empress"

-- The Necrotic Wake
L["NW_BOSS1"] = "Blightbone"
L["NW_BOSS2"] = "Amarth"
L["NW_BOSS3"] = "Surgeon Stitchflesh"
L["NW_BOSS4"] = "Nalthor the Rimebinder"

-- Halls of Atonement
L["HoA_BOSS1"] = "Halkias, the Sin-Stained Goliath"
L["HoA_BOSS2"] = "Echelon"
L["HoA_BOSS3"] = "High Adjudicator Aleez"
L["HoA_BOSS4"] = "Lord Chamberlain"

-- Tazavesh: Streets of Wonder
L["TSoW_BOSS1"] = "Zo'phex the Sentinel"
L["TSoW_BOSS2"] = "The Grand Menagerie"
L["TSoW_BOSS3"] = "Mailroom Mayhem"
L["TSoW_BOSS4"] = "Myza's Oasis"
L["TSoW_BOSS5"] = "So'azmi"

-- Tazavesh: So'leah's Gambit
L["TSLG_BOSS1"] = "Hylbrande"
L["TSLG_BOSS2"] = "Timecap'n Hooktail"
L["TSLG_BOSS3"] = "So'leah"


-- Battle for Azeroth
-- Operation: Mechagon - Workshop
L["OMGW_BOSS1"] = "Tussle Tonks"
L["OMGW_BOSS2"] = "K.U.-J.0."
L["OMGW_BOSS3"] = "Machinist's Garden"
L["OMGW_BOSS4"] = "King Mechagon"

-- Siege of Boralus
L["SoB_BOSS1"] = "Chopper Redhook"
L["SoB_BOSS2"] = "Dread Captain Lockwood"
L["SoB_BOSS3"] = "Hadal Darkfathom"
L["SoB_BOSS4"] = "Viq'Goth"

-- The MOTHERLODE!!
L["TML_BOSS1"] = "Coin-Operated Crowd Pummeler"
L["TML_BOSS2"] = "Azerokk"
L["TML_BOSS3"] = "Rixxa Fluxflame"
L["TML_BOSS4"] = "Mogul Razdunk"

-- Legion

-- Cataclysm
-- Grim Batol
L["GB_BOSS1"] = "General Umbriss"
L["GB_BOSS2"] = "Forgemaster Throngus"
L["GB_BOSS3"] = "Drahga Shadowburner"
L["GB_BOSS4"] = "Erudax, the Duke of Below"

-- UI Strings
L["FINISHED"] = "Dungeon percentage done"
L["SECTION_DONE"] = "Section finished"
L["DONE"] = "Section percentage done"
L["DUNGEON_DONE"] = "Dungeon finished"
L["OPTIONS"] = "Options"
L["GENERAL_SETTINGS"] = "General Settings"
L["Changelog"] = "Changelog"
L["Version"] = "Version"
L["Important"] = "Important"
L["New"] = "New"
L["Bugfixes"] = "Bug fixes"
L["Improvment"] = "Improvements"
L["%month%-%day%-%year%"] = "%year%-%month%-%day%"
L["DEFAULT_PERCENTAGES"] = "Default percentages"
L["ADVANCED_SETTINGS"] = "Custom routes"
L["TANK_GROUP_HEADER"] = "Boss Percentages"
L["ROLES_ENABLED"] = "Role(s) required"
L["ROLES_ENABLED_DESC"] = "Select which roles will see the percentage and inform the group"
L["LEADER"] = "Leader"
L["TANK"] = "Tank"
L["HEALER"] = "Healer"
L["DPS"] = "Damage"
L["ENABLE_ADVANCED_OPTIONS"] = "Enable custom routes"
L["ADVANCED_OPTIONS_DESC"] = "This will allow you to set custom percentages to reach before each bosses and to choose if you want to inform the group of any missed percentage"
L["INFORM_GROUP"] = "Inform Group"
L["INFORM_GROUP_DESC"] = "Send messages to chat when percentage is missing"
L["MESSAGE_CHANNEL"] = "Chat Channel"
L["MESSAGE_CHANNEL_DESC"] = "Select which chat channel to use for notifications"
L["PARTY"] = "Party"
L["SAY"] = "Say"
L["YELL"] = "Yell"
L["PERCENTAGE"] = "Percentage"
L["PERCENTAGE_DESC"] = "Adjust the size of the text"
L["FONT"] = "Font"
L["FONT_SIZE"] = "Font Size"
L["FONT_SIZE_DESC"] = "Adjust the size of the text"
L["POSITIONING"] = "Positioning"
L["COLORS"] = "Colors"
L["IN_PROGRESS"] = "In progress"
L["FINISHED"] = "Finished"
L["MISSING"] = "Missing"
L["GENERAL"] = "General"
L["ANCHOR_POSITION"] = "Anchor Position"
L["VALIDATE"] = "Validate"
L["CANCEL"] = "Cancel"
L["POSITION"] = "Position"
L["TOP"] = "Top"
L["CENTER"] = "Center"
L["BOTTOM"] = "Bottom"
L["X_OFFSET"] = "X Offset"
L["Y_OFFSET"] = "Y Offset"
L["SHOW_ANCHOR"] = "Show Positioning Anchor"
L["ANCHOR_TEXT"] = "< KPH Mover >"
L["RESET_DUNGEON"] = "Reset to Defaults"
L["RESET_DUNGEON_DESC"] = "Reset all boss percentages in this dungeon to their default values"
L["RESET_DUNGEON_CONFIRM"] = "Are you sure you want to reset all boss percentages in this dungeon to their default values?"
L["RESET_ALL_DUNGEONS"] = "Reset All Dungeons"
L["RESET_ALL_DUNGEONS_DESC"] = "Reset all dungeons to their default values"
L["RESET_ALL_DUNGEONS_CONFIRM"] = "Are you sure you want to reset all dungeons to their default values?"
L["NEW_SEASON_RESET_PROMPT"] = "A new Mythic+ season has started. Would you like to reset all dungeon values to their defaults?"
L["YES"] = "Yes"
L["NO"] = "No"
L["WE_STILL_NEED"] = "We still need"
L["NEW_ROUTES_RESET_PROMPT"] = "The default dungeon routes have been updated in this version. Would you like to reset your current dungeon routes to the new defaults?"
L["RESET_ALL"] = "Reset All Dungeons"
L["RESET_CHANGED_ONLY"] = "Reset Changed Only"
L["CHANGED_ROUTES_DUNGEONS_LIST"] = "The following dungeons have updated routes:"

-- Export/Import
L["EXPORT_DUNGEON"] = "Export Dungeon"
L["EXPORT_DUNGEON_DESC"] = "Export custom percentages for this dungeon"
L["IMPORT_DUNGEON"] = "Import Dungeon"
L["IMPORT_DUNGEON_DESC"] = "Import custom percentages for this dungeon"
L["EXPORT_ALL_DUNGEONS"] = "Export All Dungeons"
L["EXPORT_ALL_DUNGEONS_DESC"] = "Export settings for all dungeons."
L["EXPORT_ALL_DIALOG_TEXT"] = "Copy the string below to share your custom percentages for all dungeons:"
L["IMPORT_ALL_DUNGEONS"] = "Import All Dungeons"
L["IMPORT_ALL_DUNGEONS_DESC"] = "Import settings for all dungeons."
L["IMPORT_ALL_DIALOG_TEXT"] = "Paste the string below to import custom percentages for all dungeons:"
L["EXPORT_SECTION"] = "Export Section"
L["EXPORT_SECTION_DESC"] = "Export all dungeon settings for %s."
L["EXPORT_SECTION_DIALOG_TEXT"] = "Copy the string below to share your custom percentages for %s:"
L["IMPORT_SECTION"] = "Import Section"
L["IMPORT_SECTION_DESC"] = "Import all dungeon settings for %s."
L["IMPORT_SECTION_DIALOG_TEXT"] = "Paste the string below to import custom percentages for %s:"
L["EXPORT_DIALOG_TITLE"] = "Export Dungeon Percentages"
L["EXPORT_DIALOG_TEXT"] = "Copy the string below to share your custom percentages:"
L["IMPORT_DIALOG_TITLE"] = "Import Dungeon Percentages"
L["IMPORT_DIALOG_TEXT"] = "Paste the exported string below:"
L["IMPORT_SUCCESS"] = "Imported custom route for %s."
L["IMPORT_ALL_SUCCESS"] = "Imported custom route for all dungeons."
L["IMPORT_ALL_ERROR"] = "Invalid import string."
L["IMPORT_ERROR"] = "Invalid import string"
L["IMPORT_DIFFERENT_DUNGEON"] = "Imported settings for %s. Opening options for that dungeon."