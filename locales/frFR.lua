local AddonName, Engine = ...;

local LibStub = LibStub;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddonName, "frFR", true, false); ---@class XIV_DatabarLocale

-- Dungeons Group
L["DUNGEONS"] = "Donjons"
L["CURRENT_SEASON"] = "Saison actuelle"
L["NEXT_SEASON"] = "Prochaine saison"
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

-- Cinderbrew Meadery
L["CBM"] = "Hydromelerie de Brassecendre"
L["CBM_BOSS1"] = "Maître brasseur Aldryr"
L["CBM_BOSS2"] = "I'pa"
L["CBM_BOSS3"] = "Benk Bourdon"
L["CBM_BOSS4"] = "Goldie Baronnie"

-- Darkflame Cleft
L["DFC"] = "Faille de Flamme-Noire"
L["DFC_BOSS1"] = "Vieux Barbecire"
L["DFC_BOSS2"] = "Blazikon"
L["DFC_BOSS3"] = "Le roi-bougie"
L["DFC_BOSS4"] = "Les Ténèbres"

-- Operation: Floodgate
-- To Translate
L["OFG"] = "Operation: Floodgate"
L["OFG_BOSS1"] = "Big M.O.M.M.A."
L["OFG_BOSS2"] = "Demolition Duo"
L["OFG_BOSS3"] = "Swampface"
L["OFG_BOSS4"] = "Geezle Gigazap"

-- Priory of the Sacred Flames
L["PotSF"] = "Prieuré de la Flamme sacrée"
L["PotSF_BOSS1"] = "Capitaine Dailcri"
L["PotSF_BOSS2"] = "Baron Braunpique"
L["PotSF_BOSS3"] = "Prieuresse Murrpray"

-- The Dawnbreaker
L["TDB"] = "Le Brise-Aube"
L["TDB_BOSS1"] = "Mandataire Couronne d'ombre"
L["TDB_BOSS2"] = "Anub'ikkaj"
L["TDB_BOSS3"] = "Rasha'nan"

-- The Rookery
L["TR"] = "La colonie"
L["TR_BOSS1"] = "Kyrioss"
L["TR_BOSS2"] = "Garde de la tempête Gorren"
L["TR_BOSS3"] = "Monstruosité de pierre du Vide"

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

-- Theater of Pain
L["ToP"] = "Theater of Pain"
L["ToP_BOSS1"] = "L'affrontement"
L["ToP_BOSS2"] = "Trancheboyau"
L["ToP_BOSS3"] = "Xav l'invaincu"
L["ToP_BOSS4"] = "Kul'tharok"
L["ToP_BOSS5"] = "Mordretha, l'impératrice immortelle"

-- The Necrotic Wake
L["NW"] = "Sillage nécrotique"
L["NW_BOSS1"] = "Chancros"
L["NW_BOSS2"] = "Amarth"
L["NW_BOSS3"] = "Docteur Sutur"
L["NW_BOSS4"] = "Nalthor le Lieur-de-Givre"

-- Battle for Azeroth
-- Operation: Mechagon - Workshop
L["OMGW"] = "Operation: Mécagone - l'Atelier"
L["OMGW_BOSS1"] = "Cogne-Chariottes"
L["OMGW_BOSS2"] = "K.U.-J.0."
L["OMGW_BOSS3"] = "Jardin du Machiniste"
L["OMGW_BOSS4"] = "Roi Mécagone"

-- Siege of Boralus
L["SoB"] = "Siege of Boralus"
L["SoB_BOSS1"] = "Crochesang"
L["SoB_BOSS2"] = "Capitaine de l’effroi Boisclos"
L["SoB_BOSS3"] = "Hadal Sombrabysse"
L["SoB_BOSS4"] = "Viq'Goth"

-- The MOTHERLODE!!
L["TML"] = "The MOTHERLODE!!"
L["TML_BOSS1"] = "Disperseur de foule automatique"
L["TML_BOSS2"] = "Azerokk"
L["TML_BOSS3"] = "Rixxa Fluxifuge"
L["TML_BOSS4"] = "Nabab Razzbam"

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
L["Changelog"] = "Mises à jour"
L["Version"] = "Version"
L["Important"] = "Important"
L["New"] = "Nouveau"
L["Bugfixes"] = "Corrections de bugs"
L["Improvment"] = "Améliorations"
L["%month%-%day%-%year%"] = "%day%-%month%-%year%"
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
L["VALIDATE"] = "Valider"
L["CANCEL"] = "Annuler"
L["POSITION"] = "Position"
L["TOP"] = "Haut"
L["CENTER"] = "Centre"
L["TOPLEFT"] = "Haut gauche"
L["TOPRIGHT"] = "Haut droit"
L["BOTTOM"] = "Bas"
L["BOTTOMLEFT"] = "Bas gauche"
L["BOTTOMRIGHT"] = "Bas droit"
L["LEFT"] = "Gauche"
L["RIGHT"] = "Droite"
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