local AddonName, Engine = ...;

local LibStub = LibStub;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddonName, "frFR", true, false); ---@class XIV_DatabarLocale

-- Dungeons Group
L["DUNGEONS"] = "Donjons"
L["CURRENT_SEASON"] = "Saison actuelle"
L["EXPANSION_DF"] = "Dragonflight"
L["EXPANSION_CATA"] = "Cataclysm"
L["EXPANSION_WW"] = "The War Within"
L["EXPANSION_SL"] = "Shadowlands"
L["EXPANSION_BFA"] = "Battle for Azeroth"
L["EXPANSION_LEGION"] = "Legion"

-- The War Within
-- Ara-Kara, City of Echoes
L["AKCE"] = "Ara-Kara, la cité des Échos"
L["AKCE_BOSS1"] = "Avanoxx"
L["AKCE_BOSS2"] = "Anub'zekt"
L["AKCE_BOSS3"] = "Ki'katal la Moissoneuse"

-- City of Threads
L["CoT"] = "Cité des Fils"
L["CoT_BOSS1"] = "Mandataire Krix'vizk"
L["CoT_BOSS2"] = "Crocs de la Reine"
L["CoT_BOSS3"] = "La Coaglamation"
L["CoT_BOSS4"] = "Izo le Grand Faisceau"

-- The Dawnbreaker
L["TDB"] = "Le Brise-Aube"
L["TDB_BOSS1"] = "Mandataire Couronne d'ombre"
L["TDB_BOSS2"] = "Anub'ikkaj"
L["TDB_BOSS3"] = "Rasha'nan"

-- The Stonevault
L["TSV"] = "La Cavepierre"
L["TSV_BOSS1"] = "E.D.N.A."
L["TSV_BOSS2"] = "Skarmorak"
L["TSV_BOSS3"] = "Maîtres machinistes"
L["TSV_BOSS4"] = "Orateur du Vide Eirich"

-- Dragonflight

-- Shadowlands
-- Mists of Tirna Scithe
L["MoTS"] = "Brumes de Tirna Scithe"
L["MoTS_BOSS1"] = "Ingra Maloch"
L["MoTS_BOSS2"] = "Mandebrume"
L["MoTS_BOSS3"] = "Tred'ova"

-- The Necrotic Wake
L["NW"] = "Sillage nécrotique"
L["NW_BOSS1"] = "Chancros"
L["NW_BOSS2"] = "Amarth"
L["NW_BOSS3"] = "Docteur Sutur"
L["NW_BOSS4"] = "Nalthor le Lieur-de-Givre"

-- Battle for Azeroth
-- Siege of Boralus
L["SoB"] = "Siege of Boralus"
L["SoB_BOSS1"] = "Crochesang"
L["SoB_BOSS2"] = "Capitaine de l’effroi Boisclos"
L["SoB_BOSS3"] = "Hadal Sombrabysse"
L["SoB_BOSS4"] = "Viq'Goth"

-- Cataclysm
-- Grim Batol
L["GB"] = "Grim Batol"
L["GB_BOSS1"] = "Général Umbriss"
L["GB_BOSS2"] = "Maître-forge Throngus"
L["GB_BOSS3"] = "Drahga Brûle-Ombre"
L["GB_BOSS4"] = "Erudax, le Duc d'en bas"

-- UI Strings
L["OPTIONS"] = "Options"
L["GENERAL_SETTINGS"] = "Paramètres généraux"
L["DEFAULT_PERCENTAGES"] = "Pourcentages par défaut"
L["ADVANCED_SETTINGS"] = "Routes personnalisées"
L["TANK_GROUP_HEADER"] = "Pourcentages des boss"
L["ENABLE_ADVANCED_OPTIONS"] = "Activer les routes personnalisées"
L["ADVANCED_OPTIONS_DESC"] = "Cela permet de configurer des pourcentages personnalisés à atteindre avant chaque boss et de choisir si le groupe doit être informé"
L["INFORM_GROUP"] = "Informer le groupe"
L["INFORM_GROUP_SHORT"] = "Informer (%s)"
L["INFORM_GROUP_DESC"] = "Envoyer des messages dans le chat lorsque du pourcentage est manquant"
L["MESSAGE_CHANNEL"] = "Canal de discussion"
L["MESSAGE_CHANNEL_DESC"] = "Sélectionnez le canal de discussion à utiliser pour les notifications"
L["PARTY"] = "Groupe"
L["SAY"] = "Dire"
L["YELL"] = "Crier"
L["PERCENTAGE"] = "Pourcentage"
L["PERCENTAGE_DESC"] = "Ajuster la taille du texte"
L["FONT"] = "Police"
L["FONT_SIZE"] = "Taille de la police"
L["FONT_SIZE_DESC"] = "Ajuster la taille du texte"
L["POSITIONING"] = "Positionnement"
L["COLORS"] = "Couleurs"
L["IN_PROGRESS"] = "En cours"
L["FINISHED"] = "Terminé"
L["MISSING"] = "Manquant"
L["GENERAL"] = "Général"
L["ANCHOR_POSITION"] = "Position d'ancrage"
L["TOP"] = "Haut"
L["CENTER"] = "Centre"
L["BOTTOM"] = "Bas"
L["X_OFFSET"] = "Décalage X"
L["Y_OFFSET"] = "Décalage Y"
L["SHOW_ANCHOR"] = "Afficher l'ancrage"
L["ANCHOR_TEXT"] = "< Déplacer KPH >"
L["RESET_DUNGEON"] = "Réinitialiser aux valeurs par défaut"
L["RESET_DUNGEON_DESC"] = "Réinitialiser tous les pourcentages des boss de ce donjon à leurs valeurs par défaut"
L["RESET_DUNGEON_CONFIRM"] = "Êtes-vous sûr de vouloir réinitialiser tous les pourcentages des boss de ce donjon à leurs valeurs par défaut ?"
L["RESET_ALL_DUNGEONS"] = "Réinitialiser tous les donjons"
L["RESET_ALL_DUNGEONS_DESC"] = "Réinitialiser tous les donjons à leurs valeurs par défaut"
L["RESET_ALL_DUNGEONS_CONFIRM"] = "Êtes-vous sûr de vouloir réinitialiser tous les donjons à leurs valeurs par défaut ?"