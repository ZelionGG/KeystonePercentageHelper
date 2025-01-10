local AddonName, Engine = ...;

local LibStub = LibStub;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddonName, "frFR", true, false); ---@class XIV_DatabarLocale

-- Dungeon Names
L["AKCE"] = "|T5899326:24:24:0|t Ara-Kara, cité des échos"
L["CoT"] = "|T5899328:24:24:0|t Cité des fils"
L["GB"] = "|T237384:16:16:0:0|t Grim Batol"
L["MoTS"] = "|T3396722:16:16:0:0|t Brumes de Tirna Scithe"
L["NW"] = "|T3743738:16:16:0:0|t Sillage nécrotique"
L["SoB"] = "|T1778228:16:16:0:0|t Siège de Boralus"
L["TDB"] = "|T237387:16:16:0:0|t L'Aube-brisée"
L["TSV"] = "|T237388:16:16:0:0|t Le Caveau de pierre"

-- Dungeons group string
L["DUNGEONS"] = "Donjons"

-- Boss Names
-- Ara-Kara, City of Echoes
L["AKCE_BOSS1"] = "Avanoxx"
L["AKCE_BOSS2"] = "Anub'zekt"
L["AKCE_BOSS3"] = "Ki'katal le Moissonneur"

-- City of Threads
L["CoT_BOSS1"] = "Orateur Krix'vizk"
L["CoT_BOSS2"] = "Avant-garde de Tyr"
L["CoT_BOSS3"] = "Champ de bataille perdu dans le temps"
L["CoT_BOSS4"] = "Maraudeur chronologique"

-- Grim Batol
L["GB_BOSS1"] = "Chronoseigneur Deios"
L["GB_BOSS2"] = "Voleur de temps"
L["GB_BOSS3"] = "Fléau de Galakrond"
L["GB_BOSS4"] = "Iridikron"

-- Mists of Tirna Scithe
L["MoTS_BOSS1"] = "Ingra Maloch"
L["MoTS_BOSS2"] = "Mandebrume"
L["MoTS_BOSS3"] = "Tred'ova"

-- Siege of Boralus
L["SoB_BOSS1"] = "Croc-Rouge le Hachoir"
L["SoB_BOSS2"] = "Capitaine Locwood la Terreur"
L["SoB_BOSS3"] = "Hadal Sombreflot"
L["SoB_BOSS4"] = "Viq'Goth"

-- The Dawnbreaker
L["TDB_BOSS1"] = "Chronikar"
L["TDB_BOSS2"] = "Voies temporelles manifestées"
L["TDB_BOSS3"] = "Morchie"

-- The Necrotic Wake
L["NW_BOSS1"] = "Chancros"
L["NW_BOSS2"] = "Amarth"
L["NW_BOSS3"] = "Chirurgeon Suturemort"
L["NW_BOSS4"] = "Nalthor le Lieur-de-Givre"

-- The Stonevault
L["TSV_BOSS1"] = "Granyth"
L["TSV_BOSS2"] = "Braise"
L["TSV_BOSS3"] = "Fracasseur de cristal"
L["TSV_BOSS4"] = "Croc-magma"

-- UI Strings
L["ADVANCED_SETTINGS"] = "Paramètres avancés"
L["TANK_GROUP_HEADER"] = "Pourcentages des Boss"
L["ENABLE_ADVANCED_OPTIONS"] = "Activer les options avancées"
L["ADVANCED_OPTIONS_DESC"] = "Cela écrasera toutes les autres options"
L["INFORM_GROUP"] = "Informer le groupe"
L["INFORM_GROUP_DESC"] = "Envoyer un message au groupe lorsque le pourcentage de %s est atteint"
L["INFORM_GROUP_SHORT"] = "Informer (%s)"
L["PERCENTAGE"] = "Pourcentage"
L["PERCENTAGE_DESC"] = "Définir le pourcentage nécessaire pour %s"
L["RESET_DUNGEON"] = "Réinitialiser aux valeurs par défaut"
L["RESET_DUNGEON_DESC"] = "Réinitialiser tous les pourcentages de boss de ce donjon à leurs valeurs par défaut"
L["RESET_DUNGEON_CONFIRM"] = "Êtes-vous sûr de vouloir réinitialiser tous les pourcentages de boss de ce donjon à leurs valeurs par défaut ?"