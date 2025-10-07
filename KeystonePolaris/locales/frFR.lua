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
L["MODULES"] = "Modules"
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
L["DEFAULT_PERCENTAGES_DESC"] = "Cette vue affiche les valeurs par défaut intégrées dans l’addon et ne reflète pas la configuration de vos routes personnalisées."
L["ROUTES_DISCLAIMER"] = "Par défaut, Keystone Polaris utilise les routes hebdomadaires de Raider.IO (Débutant). Les routes personnalisées vous permettent de définir vos propres routes. Pour activer ces routes, assurez-vous d'activer \"Routes personnalisées\" dans les paramètres généraux de l'addon."
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
L["MISSING"] = "Manquant"
L["FINISHED_COLOR"] = "Terminé"
L["VALIDATE"] = "Valider"
L["CANCEL"] = "Annuler"
L["POSITION"] = "Position"
L["TOP"] = "Haut"
L["CENTER"] = "Centre"
L["BOTTOM"] = "Bas"
L["X_OFFSET"] = "Décalage X"
L["Y_OFFSET"] = "Décalage Y"
L["SHOW_ANCHOR"] = "Afficher l'ancrage"
L["ANCHOR_TEXT"] = "< Déplacer KPL >"
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

-- Changelog
L["COPY_INSTRUCTIONS"] = "Sélectionner tout, puis Ctrl+C pour copier. Optionnel : DeepL https://www.deepl.com/translator"
L["SELECT_ALL"] = "Sélectionner tout"
L["TRANSLATE"] = "Traduire"
L["TRANSLATE_DESC"] = "Copier les notes de version qui vont apparaître dans une fenêtre popup pour les coller dans votre traducteur."

-- Mode Test
L["TEST_MODE"] = "Mode Test"
L["TEST_MODE_OVERLAY"] = "Keystone Polaris : Mode Test"
L["TEST_MODE_OVERLAY_HINT"] = "Aperçu simulé. Clic droit sur cet encart pour quitter le mode test et rouvrir les options."
L["TEST_MODE_DESC"] = "Affiche un aperçu en direct de votre configuration d'affichage sans être en donjon. Cela va :\n• Fermer le panneau d'options pour révéler l'aperçu\n• Afficher un voile et un encart d'aide au-dessus de l'affichage\n• Simuler l'entrée/sortie de combat toutes les 3 s pour afficher les valeurs projetées et le pourcentage du pull\nAstuce : Clic droit sur l'encart pour quitter le Mode Test et rouvrir les options."
L["TEST_MODE_DISABLED"] = "Mode Test désactivé automatiquement%s"
L["TEST_MODE_REASON_ENTERED_COMBAT"] = "entrée en combat"
L["TEST_MODE_REASON_STARTED_DUNGEON"] = "début du donjon"
L["TEST_MODE_REASON_CHANGED_ZONE"] = "changement de zone"

-- Main Display
L["MAIN_DISPLAY"] = "Affichage principal"
L["SHOW_REQUIRED_PREFIX"] = "Afficher le préfixe devant le pourcentage requis"
L["SHOW_REQUIRED_PREFIX_DESC"] = "Quand la valeur de base est numérique (par exemple, 12.34%), ajoute un label devant (par exemple, 'Requis :'). Aucun préfixe n'est ajouté pour les états Terminé/Section/Donjon."
L["LABEL"] = "Préfixe"
L["REQUIRED_LABEL_DESC"] = "Préfixe affiché avant le pourcentage requis (par exemple, 'Requis: 12.34%').\n\nVider le champ pour remettre la valeur par défaut."
L["SHOW_CURRENT_PERCENT"] = "Afficher le pourcentage déjà atteint"
L["SHOW_CURRENT_PERCENT_DESC"] = "Affiche le pourcentage déjà atteint (du donjon)."
L["CURRENT_LABEL_DESC"] = "Préfixe affiché avant le pourcentage déjà atteint.\n\nVider le champ pour remettre la valeur par défaut."
L["SHOW_CURRENT_PULL_PERCENT"] = "Afficher le pourcentage en cours (MDT)"
L["SHOW_CURRENT_PULL_PERCENT_DESC"] = "Affiche le pourcentage en cours (MDT)."
L["PULL_LABEL_DESC"] = "Préfixe affiché avant le pourcentage en cours (MDT).\n\nVider le champ pour remettre la valeur par défaut."
L["USE_MULTI_LINE_LAYOUT"] = "Afficher sur plusieurs lignes"
L["USE_MULTI_LINE_LAYOUT_DESC"] = "Affiche chaque valeur sélectionnée sur une nouvelle ligne."
L["SINGLE_LINE_SEPARATOR"] = "Séparateur de ligne"
L["SINGLE_LINE_SEPARATOR_DESC"] = "Séparateur utilisé entre les éléments lorsqu'un affichage sur une ligne est utilisé."
L["FONT_ALIGN"] = "Alignement du texte"
L["FONT_ALIGN_DESC"] = "Alignement horizontal du texte affiché."
L["PREFIX_COLOR"] = "Couleur des préfixes"
L["PREFIX_COLOR_DESC"] = "Couleur appliquée aux libellés/préfixes (Requis, Actuel, En cours)."
L["MAX_WIDTH"] = "Largeur maximale (une ligne)"
L["MAX_WIDTH_DESC"] = "Largeur maximale en pixels pour l'affichage sur une ligne. 0 = automatique (sans retour à la ligne)."
L["REQUIRED_DEFAULT"] = "Requis :"
L["CURRENT_DEFAULT"] = "Actuel :"
L["SECTION_REQUIRED_DEFAULT"] = "Total requis pour la section:"
L["PULL_DEFAULT"] = "En cours :"

-- Section required prefix
L["SHOW_SECTION_REQUIRED_PREFIX"] = "Afficher le pourcentage total requis pour la section"
L["SHOW_SECTION_REQUIRED_PREFIX_DESC"] = "Affiche le pourcentage total requis pour la section actuelle sans prendre en compte la progression déjà effectuée."
L["SECTION_REQUIRED_LABEL_DESC"] = "Préfixe affiché avant la valeur requise pour la section.\n\nVider le champ pour remettre la valeur par défaut."
L["SECTION_REQUIRED_DEFAULT"] = "Total requis pour la section :"

L["FORMAT_MODE"] = "Format de texte"
L["FORMAT_MODE_DESC"] = "Sélectionnez comment afficher la progression du donjon."
L["COUNT"] = "Compte"

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
L["EXPORT_DIALOG_TEXT"] = "Copier la chaîne ci-dessous pour partager vos paramètres personnalisés pour le donjon :"
L["IMPORT_DIALOG_TEXT"] = "Coller la chaîne ci-dessous pour importer les paramètres personnalisés pour le donjon :"
L["IMPORT_SUCCESS"] = "Paramètres personnalisés importés pour %s."
L["IMPORT_ALL_SUCCESS"] = "Paramètres personnalisés pour tous les donjons importés."
L["IMPORT_ERROR"] = "Chaîne d'import non valide."
L["IMPORT_DIFFERENT_DUNGEON"] = "Paramètres personnalisés importés pour %s. Ouverture des options pour ce donjon."

-- MDT Integration
L["MDT_INTEGRATION_FEATURES"] = "Intégration MDT"
L["MOB_PERCENTAGES_INFO"] = "• |cff00ff00Pourcentage des monstres|r: Affiche le pourcentage de contribution des forces ennemies sur les barres d'informations dans les donjons Mythique+"
L["MOB_INDICATOR_INFO"] = "• |cff00ff00Indicateurs des monstres|r: Ajoute des icônes sur les barres d'informations pour montrer quels ennemis sont inclus dans votre route actuelle MDT."

-- Mob Percentages
L["MOB_PERCENTAGES"] = "Pourcentage des monstres"
L["ENABLE_MOB_PERCENTAGES"] = "Activer les pourcentages des monstres"
L["ENABLE_MOB_PERCENTAGES_DESC"] = "Affiche le pourcentage de contribution de chaque monstre dans les donjons Mythique+"
L["MOB_PERCENTAGE_FONT_SIZE"] = "Taille de la police"
L["MOB_PERCENTAGE_FONT_SIZE_DESC"] = "Taille de la police des pourcentages des monstres"
L["MOB_PERCENTAGE_POSITION"] = "Position"
L["MOB_PERCENTAGE_POSITION_DESC"] = "Position des pourcentages des monstres par rapport aux barres d'informations"
L["RIGHT"] = "Droite"
L["LEFT"] = "Gauche"
L["TOP"] = "Haut"
L["BOTTOM"] = "Bas"
L["MDT_WARNING"] = "Cette fonctionnalité nécessite l'installation de l'addon Mythic Dungeon Tools (MDT)."
L["MDT_FOUND"] = "Mythic Dungeon Tools trouvé. Les pourcentages des monstres utiliseront les données de MDT."
L["MDT_LOADED"] = "Mythic Dungeon Tools chargé avec succès."
L["MDT_NOT_FOUND"] = "Mythic Dungeon Tools non trouvé. Les pourcentages des monstres ne seront pas affichés. Veuillez installer MDT pour que cette fonctionnalité fonctionne."
L["MDT_INTEGRATION"] = "Intégration MDT"
L["MDT_SECTION_WARNING"] = "Cette section nécessite l'installation de l'addon Mythic Dungeon Tools (MDT)."
L["DISPLAY_OPTIONS"] = "Options d'affichage"
L["APPEARANCE_OPTIONS"] = "Options d'apparence"
L["SHOW_PERCENTAGE"] = "Afficher le pourcentage"
L["SHOW_PERCENTAGE_DESC"] = "Afficher la valeur du pourcentage pour chaque monstre"
L["SHOW_COUNT"] = "Afficher le nombre"
L["SHOW_COUNT_DESC"] = "Afficher la valeur du nombre pour chaque monstre"
L["SHOW_TOTAL"] = "Afficher le total"
L["SHOW_TOTAL_DESC"] = "Afficher le total de score des monstres"
L["TEXT_COLOR"] = "Couleur du texte"
L["TEXT_COLOR_DESC"] = "Couleur du texte"
L["CUSTOM_FORMAT"] = "Format du texte"
L["CUSTOM_FORMAT_DESC"] = "Saisissez un format personnalisé. Utilisez %s pour le pourcentage, %c pour le nombre, et %t pour le total. Exemples : (%s), %s | %c/%t, %c, etc."
L["RESET_TO_DEFAULT"] = "Réinitialiser"
L["RESET_FORMAT_DESC"] = "Réinitialiser le format du texte à la valeur par défaut (parenthèses)"

-- Mob Indicators
L["MOB_INDICATOR"] = "Indicateurs des monstres"
L["ENABLE_MOB_INDICATORS"] = "Activer les indicateurs des monstres"
L["ENABLE_MOB_INDICATORS_DESC"] = "Afficher un indicateur pour chaque monstre inclus dans la route MDT"
L["MOB_INDICATOR_TEXTURE_HEADER"] = "Icône de l'indicateur"
L["MOB_INDICATOR_TEXTURE"] = "Icône de l'indicateur (ID ou Chemin)"
L["MOB_INDICATOR_TEXTURE_SIZE"] = "Taille"
L["MOB_INDICATOR_TEXTURE_SIZE_DESC"] = "Taille de l'icône de l'indicateur"
L["MOB_INDICATOR_COLORING_HEADER"] = "Coloration"
L["MOB_INDICATOR_BEHAVIOR"] = "Comportement"
L["MOB_INDICATOR_AUTO_ADVANCE"] = "Avancer automatiquement"
L["MOB_INDICATOR_AUTO_ADVANCE_DESC"] = "Avancer automatiquement lorsqu'aucun monstre de la route actuelle n'est visible."
L["MOB_INDICATOR_TINT"] = "Tinter l'indicateur"
L["MOB_INDICATOR_TINT_DESC"] = "Tinter l'icône de l'indicateur"
L["MOB_INDICATOR_TINT_COLOR"] = "Couleur"
L["MOB_INDICATOR_POSITION_HEADER"] = "Positionnement"