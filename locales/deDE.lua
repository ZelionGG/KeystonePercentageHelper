local AddonName, Engine = ...;

local LibStub = LibStub;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddonName, "deDE", false, false);
if not L then return end

-- TRANSLATION REQUIRED

-- Dungeon Group
L["DUNGEONS"] = "Dungeons"
L["CURRENT_SEASON"] = "Aktuelle Saison"
L["NEXT_SEASON"] = "Nächste Saison"
L["EXPANSION_DF"] = "Dragonflight"
L["EXPANSION_CATA"] = "Cataclysm"
L["EXPANSION_WW"] = "The War Within"
L["EXPANSION_SL"] = "Shadowlands"
L["EXPANSION_BFA"] = "Battle for Azeroth"
L["EXPANSION_LEGION"] = "Legion"

-- The War Within
-- Ara-Kara, Stadt der Echos
L["AKCE_BOSS1"] = "Avanoxx"
L["AKCE_BOSS2"] = "Anub'zekt"
L["AKCE_BOSS3"] = "Ki'katal die Ernterin"

-- Stadt der Fäden
L["CoT_BOSS1"] = "Orator Krix'vizk"
L["CoT_BOSS2"] = "Fänge der Königin"
L["CoT_BOSS3"] = "Das Koaglamat"
L["CoT_BOSS4"] = "Izo, die große Verbinderin"

-- Metbrauerei Glutbräu
L["CBM_BOSS1"] = "Braumeister Aldryr"
L["CBM_BOSS2"] = "I'pa"
L["CBM_BOSS3"] = "Benk Sumsebrumm"
L["CBM_BOSS4"] = "Goldie Barontasch"

-- Dunkelflammenspalt
L["DFC_BOSS1"] = "Alter Wachsbart"
L["DFC_BOSS2"] = "Lohenzar"
L["DFC_BOSS3"] = "Der Kerzenkönig"
L["DFC_BOSS4"] = "Die Finsternis"

-- Die Biokuppel Al'dani
L["EDAD_BOSS1"] = "Azhiccar"
L["EDAD_BOSS2"] = "Taah'bat und A'wazj"
L["EDAD_BOSS3"] = "Seelenschreiberin"

-- Operation: Schleuse
L["OFG_BOSS1"] = "Große M.A.M.A."
L["OFG_BOSS2"] = "Demolierungsduo"
L["OFG_BOSS3"] = "Sumpfgesicht"
L["OFG_BOSS4"] = "Giesel Gigaschock"

-- Priorat der heiligen Flamme
L["PotSF_BOSS1"] = "Hauptmann Talschrei"
L["PotSF_BOSS2"] = "Baron Braunspyß"
L["PotSF_BOSS3"] = "Priorin Murrbet"

-- Die Morgenbringer
L["TDB_BOSS1"] = "Sprecherin Schattenkrone"
L["TDB_BOSS2"] = "Anub'ikkaj"
L["TDB_BOSS3"] = "Rasha'nan"

-- Die Brutstätte
L["TR_BOSS1"] = "Kyrioss"
L["TR_BOSS2"] = "Sturmwache Gorren"
L["TR_BOSS3"] = "Leerensteinmonstrosität"

-- Das Steingewölbe
L["TSV_BOSS1"] = "I.N.G.A."
L["TSV_BOSS2"] = "Skarmorak"
L["TSV_BOSS3"] = "Meistermaschinisten"
L["TSV_BOSS4"] = "Leerensprecher Eirich"

-- Shadowlands
-- Die Nebel von Tirna Scithe
L["MoTS_BOSS1"] = "Ingra Maloch"
L["MoTS_BOSS2"] = "Nebelruferin"
L["MoTS_BOSS3"] = "Tred'ova"

--Theater der Schmerzen
L["ToP_BOSS1"] = "Ein Affront der Herausforderer"
L["ToP_BOSS2"] = "Bluthack"
L["ToP_BOSS3"] = "Xav der Unbesiegte"
L["ToP_BOSS4"] = "Kul'tharok"
L["ToP_BOSS5"] = "Mordretha, die Unendliche Kaiserin"

-- Die Nekrotische Schneise
L["NW_BOSS1"] = "Pestknochen"
L["NW_BOSS2"] = "Amarth der Ernter"
L["NW_BOSS3"] = "Chirurg Fleischnaht"
L["NW_BOSS4"] = "Nalthor der Eisbinder"

-- Halle der Sühne
L["HoA_BOSS1"] = "Halkias, der Sündenbefleckte Goliath"
L["HoA_BOSS2"] = "Echelon"
L["HoA_BOSS3"] = "Hochadjudikatorin Aleez"
L["HoA_BOSS4"] = "Oberster Kämmerer"

-- Tazavesh: Wundersame Straßen
L["TSoW_BOSS1"] = "Zo'phex der Wächter"
L["TSoW_BOSS2"] = "Die Große Menagerie"
L["TSoW_BOSS3"] = "Postraumfiasko"
L["TSoW_BOSS4"] = "Myzas Oase"
L["TSoW_BOSS5"] = "So'azmi"

-- Tazavesh: So’leahs Schachzug
L["TSLG_BOSS1"] = "Hylbrand"
L["TSLG_BOSS2"] = "Zeitkäpt'n Hakenschwanz"
L["TSLG_BOSS3"] = "So'leah"


-- Battle for Azeroth
-- Operation: Mechagon - Werkstatt
L["OMGW_BOSS1"] = "Der Platinprügler"
L["OMGW_BOSS2"] = "K.U.-J.0."
L["OMGW_BOSS3"] = "Der Garten des Maschinisten"
L["OMGW_BOSS4"] = "König Mechagon"

-- Die Belagerung von Boralus
L["SoB_BOSS1"] = "Rothaken der Häcksler"
L["SoB_BOSS2"] = "Schreckenskapitänin Luebke"
L["SoB_BOSS3"] = "Hadal Dunkelgrund"
L["SoB_BOSS4"] = "Viq'Goth, Schrecken der Tiefe"

-- Das RIESENFLÖZ!!
L["TML_BOSS1"] = "Münzbetriebener Meuteverprügler"
L["TML_BOSS2"] = "Azerokk"
L["TML_BOSS3"] = "Rixxa Fluxflamme"
L["TML_BOSS4"] = "Mogul Ratztunk"

-- Legion

-- Cataclysm
-- Grim Batol
L["GB_BOSS1"] = "General Umbriss"
L["GB_BOSS2"] = "Schmiedemeister Throngus"
L["GB_BOSS3"] = "Drahga Schattenbrenner"
L["GB_BOSS4"] = "Erudax, der Herzog der Tiefe"

-- UI Strings
L["MODULES"] = "Modules" -- To Translate
L["FINISHED"] = "Dungeon-Prozentsatz erreicht"
L["SECTION_DONE"] = "Abschnitt abgeschlossen"
L["DONE"] = "Abschnittsprozentsatz erreicht"
L["DUNGEON_DONE"] = "Dungeon abgeschlossen"
L["OPTIONS"] = "Optionen"
L["GENERAL_SETTINGS"] = "Allgemeine Einstellungen"
L["Changelog"] = "Änderungsprotokoll"
L["Version"] = "Version"
L["Important"] = "Wichtig"
L["New"] = "Neu"
L["Bugfixes"] = "Fehlerbehebungen"
L["Improvment"] = "Verbesserungen"
L["%month%-%day%-%year%"] = "%day%.%month%.%year%"   -- deutsches Datumsformat
L["DEFAULT_PERCENTAGES"] = "Standard-Prozentsätze"
L["ADVANCED_SETTINGS"] = "Benutzerdefinierte Routen"
L["TANK_GROUP_HEADER"] = "Boss-Prozentsätze"
L["ROLES_ENABLED"] = "Benötigte Rolle(n)"
L["ROLES_ENABLED_DESC"] = "Wähle, welche Rollen die Prozente sehen und die Gruppe informieren sollen"
L["LEADER"] = "Anführer"
L["TANK"] = "Tank"
L["HEALER"] = "Heiler"
L["DPS"] = "Schaden"
L["ENABLE_ADVANCED_OPTIONS"] = "Benutzerdefinierte Routen aktivieren"
L["ADVANCED_OPTIONS_DESC"] = "Ermöglicht es dir, eigene Prozentsätze festzulegen, die vor jedem Boss erreicht werden sollen, und zu wählen, ob die Gruppe über fehlende Prozente informiert wird"
L["INFORM_GROUP"] = "Gruppe informieren"
L["INFORM_GROUP_DESC"] = "Sendet Nachrichten in den Chat, wenn Prozente fehlen"
L["MESSAGE_CHANNEL"] = "Chat-Kanal"
L["MESSAGE_CHANNEL_DESC"] = "Wähle, welchen Chat-Kanal du für Benachrichtigungen verwenden möchtest"
L["PARTY"] = "Gruppe"
L["SAY"] = "Sagen"
L["YELL"] = "Schreien"
L["PERCENTAGE"] = "Prozentsatz"
L["PERCENTAGE_DESC"] = "Die Textgröße anpassen"
L["FONT"] = "Schriftart"
L["FONT_SIZE"] = "Textgröße"
L["FONT_SIZE_DESC"] = "Die Textgröße anpassen"
L["POSITIONING"] = "Positionierung"
L["COLORS"] = "Farben"
L["IN_PROGRESS"] = "In Arbeit"
L["MISSING"] = "Fehlend"
L["VALIDATE"] = "Bestätigen"
L["CANCEL"] = "Abbrechen"
L["POSITION"] = "Position"
L["TOP"] = "Oben"
L["CENTER"] = "Mitte"
L["BOTTOM"] = "Unten"
L["X_OFFSET"] = "X-Versatz"
L["Y_OFFSET"] = "Y-Versatz"
L["SHOW_ANCHOR"] = "Anker zur Positionierung anzeigen"
L["ANCHOR_TEXT"] = "< KPH Anker >"
L["RESET_DUNGEON"] = "Auf Standard zurücksetzen"
L["RESET_DUNGEON_DESC"] = "Setzt alle Boss-Prozentsätze in diesem Dungeon auf ihre Standardwerte zurück"
L["RESET_DUNGEON_CONFIRM"] = "Bist du sicher, dass du alle Boss-Prozentsätze in diesem Dungeon auf die Standardwerte zurücksetzen möchtest?"
L["RESET_ALL_DUNGEONS"] = "Alle Dungeons zurücksetzen"
L["RESET_ALL_DUNGEONS_DESC"] = "Setzt alle Dungeons auf ihre Standardwerte zurück"
L["RESET_ALL_DUNGEONS_CONFIRM"] = "Bist du sicher, dass du alle Dungeons auf die Standardwerte zurücksetzen möchtest?"
L["NEW_SEASON_RESET_PROMPT"] = "Eine neue Mythisch+-Saison hat begonnen. Möchtest du alle Dungeon-Werte auf die Standardwerte zurücksetzen?"
L["YES"] = "Ja"
L["NO"] = "Nein"
L["WE_STILL_NEED"] = "Es fehlen noch"
L["NEW_ROUTES_RESET_PROMPT"] = "Die Standardrouten der Dungeons wurden in dieser Version aktualisiert. Möchtest du deine aktuellen Dungeon-Routen auf die neuen Standardwerte zurücksetzen?"
L["RESET_ALL"] = "Alle zurücksetzen"
L["RESET_CHANGED_ONLY"] = "Nur geänderte zurücksetzen"
L["CHANGED_ROUTES_DUNGEONS_LIST"] = "Folgende Dungeons haben aktualisierte Routen:"-- Export/Import
L["EXPORT_DUNGEON"] = "Dungeon exportieren"
L["EXPORT_DUNGEON_DESC"] = "Benutzerdefinierte Prozentsätze für diesen Dungeon exportieren"
L["IMPORT_DUNGEON"] = "Dungeon importieren"
L["IMPORT_DUNGEON_DESC"] = "Benutzerdefinierte Prozentsätze für diesen Dungeon importieren"
L["EXPORT_ALL_DUNGEONS"] = "Alle Dungeons exportieren"
L["EXPORT_ALL_DUNGEONS_DESC"] = "Einstellungen für alle Dungeons exportieren."
L["EXPORT_ALL_DIALOG_TEXT"] = "Kopiere den untenstehenden Text, um deine benutzerdefinierten Prozentsätze für alle Dungeons zu teilen:"
L["IMPORT_ALL_DUNGEONS"] = "Alle Dungeons importieren"
L["IMPORT_ALL_DUNGEONS_DESC"] = "Einstellungen für alle Dungeons importieren."
L["IMPORT_ALL_DIALOG_TEXT"] = "Füge den untenstehenden Text ein, um benutzerdefinierte Prozentsätze für alle Dungeons zu importieren:"
L["EXPORT_SECTION"] = "Abschnitt exportieren"
L["EXPORT_SECTION_DESC"] = "Alle Dungeon-Einstellungen für %s exportieren."
L["EXPORT_SECTION_DIALOG_TEXT"] = "Kopiere den untenstehenden Text, um deine benutzerdefinierten Prozentsätze für %s zu teilen:"
L["IMPORT_SECTION"] = "Abschnitt importieren"
L["IMPORT_SECTION_DESC"] = "Alle Dungeon-Einstellungen für %s importieren."
L["IMPORT_SECTION_DIALOG_TEXT"] = "Füge den untenstehenden Text ein, um benutzerdefinierte Prozentsätze für %s zu importieren:"
L["EXPORT_DIALOG_TEXT"] = "Kopiere den untenstehenden Text, um deine benutzerdefinierten Prozentsätze zu teilen:"
L["IMPORT_DIALOG_TEXT"] = "Füge den exportierten Text unten ein:"
L["IMPORT_SUCCESS"] = "Benutzerdefinierte Route für %s importiert."
L["IMPORT_ALL_SUCCESS"] = "Benutzerdefinierte Routen für alle Dungeons importiert."
L["IMPORT_ERROR"] = "Ungültiger Import-Text"
L["IMPORT_DIFFERENT_DUNGEON"] = "Einstellungen für %s importiert. Optionen für diesen Dungeon werden geöffnet."

-- MDT Integration
L["MDT_INTEGRATION_FEATURES"] = "Mythic Dungeon Tools Integration Features"
L["MOB_PERCENTAGES_INFO"] = "• |cff00ff00Mob Percentages|r: Shows enemy forces contribution percentage on nameplates in M+ dungeons."
L["MOB_INDICATOR_INFO"] = "• |cff00ff00Mobs Indicators|r: Marks nameplates to show which enemies are included in your current MDT route pull."

-- Mob Percentages
L["MOB_PERCENTAGES"] = "Mob Percentages"
L["ENABLE_MOB_PERCENTAGES"] = "Enable Mob Percentages"
L["ENABLE_MOB_PERCENTAGES_DESC"] = "Show percentage contribution of each mob in Mythic+ dungeons"
L["MOB_PERCENTAGE_FONT_SIZE"] = "Font Size"
L["MOB_PERCENTAGE_FONT_SIZE_DESC"] = "Set the font size for mob percentage text"
L["MOB_PERCENTAGE_POSITION"] = "Position"
L["MOB_PERCENTAGE_POSITION_DESC"] = "Set the position of the percentage text relative to the nameplate"
L["RIGHT"] = "Right"
L["LEFT"] = "Left"
L["TOP"] = "Top"
L["BOTTOM"] = "Bottom"
L["MDT_WARNING"] = "This feature requires Mythic Dungeon Tools (MDT) addon to be installed."
L["MDT_FOUND"] = "Mythic Dungeon Tools found. Mob percentages will use MDT data."
L["MDT_LOADED"] = "Mythic Dungeon Tools loaded successfully."
L["MDT_NOT_FOUND"] = "Mythic Dungeon Tools not found. Mob percentages will not be shown. Please install MDT for this feature to work."
L["MDT_INTEGRATION"] = "MDT Integration"
L["MDT_SECTION_WARNING"] = "This section requires Mythic Dungeon Tools (MDT) addon to be installed."
L["DISPLAY_OPTIONS"] = "Display Options"
L["APPEARANCE_OPTIONS"] = "Appearance Options"
L["SHOW_PERCENTAGE"] = "Show Percentage"
L["SHOW_PERCENTAGE_DESC"] = "Show the percentage value for each mob"
L["SHOW_COUNT"] = "Show Count"
L["SHOW_COUNT_DESC"] = "Show the count value for each mob"
L["SHOW_TOTAL"] = "Show Total"
L["SHOW_TOTAL_DESC"] = "Show the total count needed for 100%"
L["TEXT_COLOR"] = "Font Color"
L["TEXT_COLOR_DESC"] = "Set the color of the nameplate text"
L["CUSTOM_FORMAT"] = "Text Format"
L["CUSTOM_FORMAT_DESC"] = "Enter a custom format. Use %s for percentage, %c for count, and %t for total. Examples: (%s), %s | %c/%t, %c, etc."
L["RESET_TO_DEFAULT"] = "Reset"
L["RESET_FORMAT_DESC"] = "Reset the text format to the default value (parentheses)"

-- Mob Indicators
L["MOB_INDICATOR"] = "Mob Indicators"
L["ENABLE_MOB_INDICATORS"] = "Enable Mob Indicators"
L["ENABLE_MOB_INDICATORS_DESC"] = "Show an indicator for each mob included in the MDT route"
L["MOB_INDICATOR_TEXTURE_HEADER"] = "Indicator icon"
L["MOB_INDICATOR_TEXTURE"] = "Indicator icon (ID or Path)"
L["MOB_INDICATOR_TEXTURE_SIZE"] = "Size"
L["MOB_INDICATOR_TEXTURE_SIZE_DESC"] = "Set the texture size for the indicator icon"
L["MOB_INDICATOR_COLORING_HEADER"] = "Coloring"
L["MOB_INDICATOR_BEHAVIOR"] = "Behavior"
L["MOB_INDICATOR_AUTO_ADVANCE"] = "Auto-advance pull"
L["MOB_INDICATOR_AUTO_ADVANCE_DESC"] = "Auto-advance pull when no current-pull mobs are visible."
L["MOB_INDICATOR_TINT"] = "Tint the indicator"
L["MOB_INDICATOR_TINT_DESC"] = "Tint the indicator icon"
L["MOB_INDICATOR_TINT_COLOR"] = "Color"
L["MOB_INDICATOR_POSITION_HEADER"] = "Positioning"