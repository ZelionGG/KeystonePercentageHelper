local AddonName, Engine = ...;

local LibStub = LibStub;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddonName, "frFR", false, false);
if not L then return end

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
L["AKCE_BOSS1"] = "Avanoxx"
L["AKCE_BOSS2"] = "Anub'zekt"
L["AKCE_BOSS3"] = "Ki'katal la Moissoneuse"

-- City of Threads
L["CoT_BOSS1"] = "Mandataire Krix'vizk"
L["CoT_BOSS2"] = "Crocs de la Reine"
L["CoT_BOSS3"] = "La Coaglamation"
L["CoT_BOSS4"] = "Izo le Grand Faisceau"

-- Cinderbrew Meadery
L["CBM_BOSS1"] = "Maître brasseur Aldryr"
L["CBM_BOSS2"] = "I'pa"
L["CBM_BOSS3"] = "Benk Bourdon"
L["CBM_BOSS4"] = "Goldie Baronnie"

-- Darkflame Cleft
L["DFC_BOSS1"] = "Vieux Barbecire"
L["DFC_BOSS2"] = "Blazikon"
L["DFC_BOSS3"] = "Le roi-bougie"
L["DFC_BOSS4"] = "Les Ténèbres"

-- Eco-Dome Al'Dani
L["EDAD_BOSS1"] = "Azhiccar"
L["EDAD_BOSS2"] = "Taah'bat and A'wazj"
L["EDAD_BOSS3"] = "Soul-Scribe"

-- Operation: Floodgate
L["OFG_BOSS1"] = "Grand-M.A.M.A."
L["OFG_BOSS2"] = "Duo de démolition"
L["OFG_BOSS3"] = "Face de marais"
L["OFG_BOSS4"] = "Geezle Gigazap"

-- Priory of the Sacred Flames
L["PotSF_BOSS1"] = "Capitaine Dailcri"
L["PotSF_BOSS2"] = "Baron Braunpique"
L["PotSF_BOSS3"] = "Prieuresse Murrpray"

-- The Dawnbreaker
L["TDB_BOSS1"] = "Mandataire Couronne d'ombre"
L["TDB_BOSS2"] = "Anub'ikkaj"
L["TDB_BOSS3"] = "Rasha'nan"

-- The Rookery
L["TR_BOSS1"] = "Kyrioss"
L["TR_BOSS2"] = "Garde de la tempête Gorren"
L["TR_BOSS3"] = "Monstruosité de pierre du Vide"

-- The Stonevault
L["TSV_BOSS1"] = "E.D.N.A."
L["TSV_BOSS2"] = "Skarmorak"
L["TSV_BOSS3"] = "Maîtres machinistes"
L["TSV_BOSS4"] = "Orateur du Vide Eirich"

-- Dragonflight

-- Shadowlands
-- Mists of Tirna Scithe
L["MoTS_BOSS1"] = "Ingra Maloch"
L["MoTS_BOSS2"] = "Mandebrume"
L["MoTS_BOSS3"] = "Tred'ova"

-- Theater of Pain
L["ToP_BOSS1"] = "L'affrontement"
L["ToP_BOSS2"] = "Trancheboyau"
L["ToP_BOSS3"] = "Xav l'invaincu"
L["ToP_BOSS4"] = "Kul'tharok"
L["ToP_BOSS5"] = "Mordretha, l'impératrice immortelle"

-- The Necrotic Wake
L["NW_BOSS1"] = "Chancros"
L["NW_BOSS2"] = "Amarth"
L["NW_BOSS3"] = "Docteur Sutur"
L["NW_BOSS4"] = "Nalthor le Lieur-de-Givre"

-- Halls of Atonement
L["HoA_BOSS1"] = "Halkias, le goliath vicié"
L["HoA_BOSS2"] = "Échelon"
L["HoA_BOSS3"] = "Grande adjudicatrice Alize"
L["HoA_BOSS4"] = "Grand chambellan"

-- Tazavesh: Streets of Wonder
L["TSoW_BOSS1"] = "Zo'phex la sentinelle"
L["TSoW_BOSS2"] = "Grandiose Ménagerie"
L["TSoW_BOSS3"] = "Courrier chaotique"
L["TSoW_BOSS4"] = "Oasis d’Au'myza"
L["TSoW_BOSS5"] = "So'azmi"

-- Tazavesh: So'leah's Gambit
L["TSLG_BOSS1"] = "Hylbrande"
L["TSLG_BOSS2"] = "Chronocapitaine Harpagone"
L["TSLG_BOSS3"] = "So'leah"


-- Battle for Azeroth
-- Operation: Mechagon - Workshop
L["OMGW_BOSS1"] = "Cogne-Chariottes"
L["OMGW_BOSS2"] = "K.U.-J.0."
L["OMGW_BOSS3"] = "Jardin du Machiniste"
L["OMGW_BOSS4"] = "Roi Mécagone"

-- Siege of Boralus
L["SoB_BOSS1"] = "Crochesang"
L["SoB_BOSS2"] = "Capitaine de l’effroi Boisclos"
L["SoB_BOSS3"] = "Hadal Sombrabysse"
L["SoB_BOSS4"] = "Viq'Goth"

-- The MOTHERLODE!!
L["TML_BOSS1"] = "Disperseur de foule automatique"
L["TML_BOSS2"] = "Azerokk"
L["TML_BOSS3"] = "Rixxa Fluxifuge"
L["TML_BOSS4"] = "Nabab Razzbam"

-- Cataclysm
-- Grim Batol
L["GB_BOSS1"] = "Général Umbriss"
L["GB_BOSS2"] = "Maître-forge Throngus"
L["GB_BOSS3"] = "Drahga Brûle-Ombre"
L["GB_BOSS4"] = "Erudax, le Duc d'en bas"

-- UI Strings
L["FINISHED"] = "Pourcentage du donjon atteint"
L["SECTION_DONE"] = "Section de donjon terminée"
L["DONE"] = "Pourcentage de la section atteint"
L["DUNGEON_DONE"] = "Donjon terminé"
L["OPTIONS"] = "Options"
L["GENERAL_SETTINGS"] = "Paramètres généraux"
L["Changelog"] = "Mises à jour"
L["Version"] = "Version"
L["Important"] = "Important"
L["New"] = "Nouveau"
L["Bugfixes"] = "Corrections de bugs"
L["Improvment"] = "Améliorations"
L["%month%-%day%-%year%"] = "%day%/%month%/%year%"
L["DEFAULT_PERCENTAGES"] = "Pourcentages par défaut"
L["ADVANCED_SETTINGS"] = "Routes personnalisées"
L["TANK_GROUP_HEADER"] = "Pourcentages des boss"
L["ROLES_ENABLED"] = "Role(s) nécessaire(s)"
L["ROLES_ENABLED_DESC"] = "Sélectionnez les rôles qui pourront voir le pourcentage et informer le groupe."
L["LEADER"] = "Chef de groupe"
L["TANK"] = "Tank"
L["HEALER"] = "Soigneur"
L["DPS"] = "Dégâts"
L["ENABLE_ADVANCED_OPTIONS"] = "Activer les routes personnalisées"
L["ADVANCED_OPTIONS_DESC"] = "Cela permet de configurer des pourcentages personnalisés à atteindre avant chaque boss et de choisir si le groupe doit être informé"
L["INFORM_GROUP"] = "Informer le groupe"
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
L["NEW_SEASON_RESET_PROMPT"] = "Une nouvelle saison Mythique+ a commencé. Voulez-vous réinitialiser toutes les valeurs des donjons de la nouvelle saison à leurs valeurs par défaut ?"
L["YES"] = "Oui"
L["NO"] = "Non"
L["WE_STILL_NEED"] = "Il nous faut encore"
L["NEW_ROUTES_RESET_PROMPT"] = "Les routes par défaut des donjons ont changé dans cette version. Voulez-vous remettre à zero vos routes de donjons avec les nouvelles routes par défaut ?"
L["RESET_ALL"] = "Réinitialiser tous les donjons"
L["RESET_CHANGED_ONLY"] = "Réinitialiser uniquement ces donjons"
L["CHANGED_ROUTES_DUNGEONS_LIST"] = "Les donjons suivants ont des routes mises à jour :"

-- Export/Import
L["EXPORT_DUNGEON"] = "Exporter le donjon"
L["EXPORT_DUNGEON_DESC"] = "Exporter les paramètres personnalisés pour ce donjon"
L["IMPORT_DUNGEON"] = "Importer le donjon"
L["IMPORT_DUNGEON_DESC"] = "Importer les paramètres personnalisés pour ce donjon"
L["EXPORT_ALL_DUNGEONS"] = "Exporter tous les donjons"
L["EXPORT_ALL_DUNGEONS_DESC"] = "Exporter les paramètres personnalisés pour tous les donjons."
L["EXPORT_ALL_DIALOG_TEXT"] = "Copier la chaîne ci-dessous pour partager vos paramètres personnalisés pour tous les donjons :"
L["IMPORT_ALL_DUNGEONS"] = "Importer tous les donjons"
L["IMPORT_ALL_DUNGEONS_DESC"] = "Importer les paramètres personnalisés pour tous les donjons."
L["IMPORT_ALL_DIALOG_TEXT"] = "Coller la chaîne ci-dessous pour importer les paramètres personnalisés pour tous les donjons :"
L["EXPORT_SECTION"] = "Exporter la section"
L["EXPORT_SECTION_DESC"] = "Exporter tous les paramètres personnalisés pour %s."
L["EXPORT_SECTION_DIALOG_TEXT"] = "Copier la chaîne ci-dessous pour partager vos paramètres personnalisés pour %s :"
L["IMPORT_SECTION"] = "Importer la section"
L["IMPORT_SECTION_DESC"] = "Importer tous les paramètres personnalisés pour %s."
L["IMPORT_SECTION_DIALOG_TEXT"] = "Coller la chaîne ci-dessous pour importer les paramètres personnalisés pour %s :"
L["EXPORT_DIALOG_TITLE"] = "Exporter les paramètres personnalisés pour le donjon"
L["EXPORT_DIALOG_TEXT"] = "Copier la chaîne ci-dessous pour partager vos paramètres personnalisés pour le donjon :"
L["IMPORT_DIALOG_TITLE"] = "Importer les paramètres personnalisés pour le donjon"
L["IMPORT_DIALOG_TEXT"] = "Coller la chaîne ci-dessous pour importer les paramètres personnalisés pour le donjon :"
L["IMPORT_SUCCESS"] = "Paramètres personnalisés importés pour %s."
L["IMPORT_ALL_SUCCESS"] = "Paramètres personnalisés pour tous les donjons importés."
L["IMPORT_ALL_ERROR"] = "Chaîne d'import non valide."
L["IMPORT_ERROR"] = "Chaîne d'import non valide."
L["IMPORT_DIFFERENT_DUNGEON"] = "Paramètres personnalisés importés pour %s. Ouverture des options pour ce donjon."