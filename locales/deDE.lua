local AddonName, Engine = ...;

local LibStub = LibStub;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddonName, "deDE", false, false);
if not L then return end

-- TRANSLATION REQUIRED

-- Dungeons Group
L["DUNGEONS"] = "Current Season"
L["CURRENT_SEASON"] = "Current Season"
L["CURRENT_SEASON_DUNGEONS"] = "Current Season Dungeons"
L["NEXT_SEASON"] = "Next Season"
L["NEXT_SEASON_DUNGEONS"] = "Next Season Dungeons"
L["EXPANSION_DF"] = "Dragonflight"
L["EXPANSION_CATA"] = "Cataclysm"
L["EXPANSION_WW"] = "The War Within"
L["EXPANSION_SL"] = "Shadowlands"
L["EXPANSION_BFA"] = "Battle for Azeroth"
L["EXPANSION_LEGION"] = "Legion"

-- The War Within
-- Ara-Kara, City of Echoes
L["AKCE"] = "Ara-Kara, City of Echoes"
L["AKCE_BOSS1"] = "Avanoxx"
L["AKCE_BOSS2"] = "Anub'zekt"
L["AKCE_BOSS3"] = "Ki'katal the Harvester"

-- City of Threads
L["CoT"] = "City of Threads"
L["CoT_BOSS1"] = "Orator Krix'vizk"
L["CoT_BOSS2"] = "Fangs of the Queen"
L["CoT_BOSS3"] = "The Coaglamation"
L["CoT_BOSS4"] = "Izo, the Grand Splicer"

-- Cinderbrew Meadery
L["CBM"] = "Cinderbrew Meadery"
L["CBM_BOSS1"] = "Brew Master Aldryr"
L["CBM_BOSS2"] = "I'pa"
L["CBM_BOSS3"] = "Benk Buzzbee"
L["CBM_BOSS4"] = "Goldie Baronbottom"

-- Darkflame Cleft
L["DFC"] = "Darkflame Cleft"
L["DFC_BOSS1"] = "Ol' Waxbeard"
L["DFC_BOSS2"] = "Blazikon"
L["DFC_BOSS3"] = "The Candle King"
L["DFC_BOSS4"] = "The Darkness"

-- Operation: Floodgate
L["OFG"] = "Operation: Floodgate"
L["OFG_BOSS1"] = "Big M.O.M.M.A."
L["OFG_BOSS2"] = "Demolition Duo"
L["OFG_BOSS3"] = "Swampface"
L["OFG_BOSS4"] = "Geezle Gigazap"

-- Priory of the Sacred Flames
L["PotSF"] = "Priory of the Sacred Flames"
L["PotSF_BOSS1"] = "Captain Dailcry"
L["PotSF_BOSS2"] = "Baron Braunpyke"
L["PotSF_BOSS3"] = "Prioress Murrpray"

-- The Dawnbreaker
L["TDB"] = "The Dawnbreaker"
L["TDB_BOSS1"] = "Speaker Shadowcrown"
L["TDB_BOSS2"] = "Anub'ikkaj"
L["TDB_BOSS3"] = "Rasha'nan"

-- The Rookery
L["TR"] = "The Rookery"
L["TR_BOSS1"] = "Kyrioss"
L["TR_BOSS2"] = "Stormguard Gorren"
L["TR_BOSS3"] = "Voidstone Monstrosity"

-- The Stonevault
L["TSV"] = "The Stonevault"
L["TSV_BOSS1"] = "E.D.N.A."
L["TSV_BOSS2"] = "Skarmorak"
L["TSV_BOSS3"] = "Master Machinists"
L["TSV_BOSS4"] = "Void Speaker Eirich"

-- Shadowlands
-- Mists of Tirna Scithe
L["MoTS"] = "Mists of Tirna Scithe"
L["MoTS_BOSS1"] = "Ingra Maloch"
L["MoTS_BOSS2"] = "Mistcaller"
L["MoTS_BOSS3"] = "Tred'ova"

--Theater of Pain
L["ToP"] = "Theater of Pain"
L["ToP_BOSS1"] = "An Affront of Challengers"
L["ToP_BOSS2"] = "Gorechop"
L["ToP_BOSS3"] = "Xav the Unfallen"
L["ToP_BOSS4"] = "Kul'tharok"
L["ToP_BOSS5"] = "Mordretha, the Endless Empress"

-- The Necrotic Wake
L["NW"] = "The Necrotic Wake"
L["NW_BOSS1"] = "Blightbone"
L["NW_BOSS2"] = "Amarth"
L["NW_BOSS3"] = "Surgeon Stitchflesh"
L["NW_BOSS4"] = "Nalthor the Rimebinder"


-- Battle for Azeroth
-- Operation: Mechagon - Workshop
L["OMGW"] = "Operation: Mechagon - Workshop"
L["OMGW_BOSS1"] = "Tussle Tonks"
L["OMGW_BOSS2"] = "K.U.-J.0."
L["OMGW_BOSS3"] = "Machinist's Garden"
L["OMGW_BOSS4"] = "King Mechagon"

-- Siege of Boralus
L["SoB"] = "Siege of Boralus"
L["SoB_BOSS1"] = "Chopper Redhook"
L["SoB_BOSS2"] = "Dread Captain Lockwood"
L["SoB_BOSS3"] = "Hadal Darkfathom"
L["SoB_BOSS4"] = "Viq'Goth"

-- The MOTHERLODE!!
L["TML"] = "The MOTHERLODE!!"
L["TML_BOSS1"] = "Coin-Operated Crowd Pummeler"
L["TML_BOSS2"] = "Azerokk"
L["TML_BOSS3"] = "Rixxa Fluxflame"
L["TML_BOSS4"] = "Mogul Razdunk"

-- Legion

-- Cataclysm
-- Grim Batol
L["GB"] = "Grim Batol"
L["GB_BOSS1"] = "General Umbriss"
L["GB_BOSS2"] = "Forgemaster Throngus"
L["GB_BOSS3"] = "Drahga Shadowburner"
L["GB_BOSS4"] = "Erudax, the Duke of Below"

-- UI Strings
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
L["ENABLE_ADVANCED_OPTIONS"] = "Enable custom routes"
L["ADVANCED_OPTIONS_DESC"] = "This will allow you to set custom percentages to reach before each bosses and to choose if you want to inform the group of any missed percentage"
L["INFORM_GROUP"] = "Inform Group"
L["INFORM_GROUP_SHORT"] = "Inform (%s)"
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