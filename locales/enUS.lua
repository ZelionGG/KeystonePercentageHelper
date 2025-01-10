local AddonName, Engine = ...;

local LibStub = LibStub;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddonName, "enUS", true, false); ---@class XIV_DatabarLocale

-- Dungeons Group
L["DUNGEONS"] = "Current Season"
L["CURRENT_SEASON"] = "Current Season"
L["EXPANSION_DF"] = "Dragonflight"
L["EXPANSION_CATA"] = "Cataclysm"
L["EXPANSION_WW"] = "The War Within"
L["EXPANSION_SL"] = "Shadowlands"
L["EXPANSION_BFA"] = "Battle for Azeroth"

-- The War Within
-- Ara-Kara, City of Echoes
L["AKCE"] = "|T5899326:16:16:0:0|t Ara-Kara, City of Echoes"
L["AKCE_BOSS1"] = "Avanoxx"
L["AKCE_BOSS2"] = "Anub'zekt"
L["AKCE_BOSS3"] = "Ki'katal the Harvester"

-- City of Threads
L["CoT"] = "|T5899328:16:16:0:0|t City of Threads"
L["CoT_BOSS1"] = "Orator Krix'vizk"
L["CoT_BOSS2"] = "Fangs of the Queen"
L["CoT_BOSS3"] = "The Coaglamation"
L["CoT_BOSS4"] = "Izo, the Grand Splicer"

-- The Dawnbreaker
L["TDB"] = "|T5899330:16:16:0:0|t The Dawnbreaker"
L["TDB_BOSS1"] = "Speaker Shadowcrown"
L["TDB_BOSS2"] = "Anub'ikkaj"
L["TDB_BOSS3"] = "Rasha'nan"

-- The Stonevault
L["TSV"] = "|T5899333:16:16:0:0|t The Stonevault"
L["TSV_BOSS1"] = "E.D.N.A."
L["TSV_BOSS2"] = "Skarmorak"
L["TSV_BOSS3"] = "Master Machinists"
L["TSV_BOSS4"] = "Void Speaker Eirich"


-- Dragonflight


-- Shadowlands
-- Mists of Tirna Scithe
L["MoTS"] = "|T3601531:16:16:0:0|t Mists of Tirna Scithe"
L["MoTS_BOSS1"] = "Ingra Maloch"
L["MoTS_BOSS2"] = "Mistcaller"
L["MoTS_BOSS3"] = "Tred'ova"

-- The Necrotic Wake
L["NW"] = "|T3601560:16:16:0:0|t The Necrotic Wake"
L["NW_BOSS1"] = "Blightbone"
L["NW_BOSS2"] = "Amarth"
L["NW_BOSS3"] = "Surgeon Stitchflesh"
L["NW_BOSS4"] = "Nalthor the Rimebinder"


-- Battle for Azeroth
-- Siege of Boralus
L["SoB"] = "|T2011139:16:16:0:0|t Siege of Boralus"
L["SoB_BOSS1"] = "Chopper Redhook"
L["SoB_BOSS2"] = "Dread Captain Lockwood"
L["SoB_BOSS3"] = "Hadal Darkfathom"
L["SoB_BOSS4"] = "Viq'Goth"


-- Cataclysm
-- Grim Batol
L["GB"] = "|T409596:16:16:0:0|t Grim Batol"
L["GB_BOSS1"] = "General Umbriss"
L["GB_BOSS2"] = "Forgemaster Throngus"
L["GB_BOSS3"] = "Drahga Shadowburner"
L["GB_BOSS4"] = "Erudax, the Duke of Below"

-- UI Strings
L["ADVANCED_SETTINGS"] = "Advanced Settings"
L["TANK_GROUP_HEADER"] = "Boss Percentages"
L["ENABLE_ADVANCED_OPTIONS"] = "Enable Advanced Options"
L["ADVANCED_OPTIONS_DESC"] = "This will overwrite all other options"
L["INFORM_GROUP"] = "Inform Group"
L["INFORM_GROUP_SHORT"] = "Inform (%s)"
L["INFORM_GROUP_DESC"] = "Send a message to the group when reaching %s's percentage"
L["PERCENTAGE"] = "Percentage"
L["PERCENTAGE_DESC"] = "Set the percentage needed for %s"
L["RESET_DUNGEON"] = "Reset to Defaults"
L["RESET_DUNGEON_DESC"] = "Reset all boss percentages in this dungeon to their default values"
L["RESET_DUNGEON_CONFIRM"] = "Are you sure you want to reset all boss percentages in this dungeon to their default values?"