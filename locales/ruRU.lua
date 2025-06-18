local AddonName, Engine = ...;

local LibStub = LibStub;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddonName, "ruRU", false, false);
if not L then return end

-- Last translated May 16th, 2025 year.
-- Translation by Hollicsh (https://github.com/Hollicsh)

-- Dungeons Group
L["DUNGEONS"] = "Подземелья"
L["CURRENT_SEASON"] = "Текущий сезон"
L["NEXT_SEASON"] = "Следующий сезон"
L["EXPANSION_DF"] = "Драконы"
L["EXPANSION_CATA"] = "Катаклизм"
L["EXPANSION_WW"] = "Война Внутри"
L["EXPANSION_SL"] = "Темные Земли"
L["EXPANSION_BFA"] = "Битва за Азерот"
L["EXPANSION_LEGION"] = "Легион"

-- The War Within
-- Ara-Kara, City of Echoes
L["AKCE_BOSS1"] = "Аванокс"
L["AKCE_BOSS2"] = "Ануб'зект"
L["AKCE_BOSS3"] = "Ки'катал Жница"

-- City of Threads
L["CoT_BOSS1"] = "Оратор Крикс'визк"
L["CoT_BOSS2"] = "Клыки королевы"
L["CoT_BOSS3"] = "Сгустолиция"
L["CoT_BOSS4"] = "Изо Великая Сращивательница"

-- Cinderbrew Meadery
L["CBM_BOSS1"] = "Хмелевар Алдрир"
L["CBM_BOSS2"] = "И'па"
L["CBM_BOSS3"] = "Бенк Жужжикс"
L["CBM_BOSS4"] = "Голди Барондон"

-- Darkflame Cleft
L["DFC_BOSS1"] = "Старый Воскобород"
L["DFC_BOSS2"] = "Пламекон"
L["DFC_BOSS3"] = "Свечной Король"
L["DFC_BOSS4"] = "Тьма"

-- Operation: Floodgate
L["OFG_BOSS1"] = "Большая МАМА"
L["OFG_BOSS2"] = "Пара подрывников"
L["OFG_BOSS3"] = "Торфоморд"
L["OFG_BOSS4"] = "Гизл Гигабжик"

-- Priory of the Sacred Flames
L["PotSF_BOSS1"] = "Капитан Дейлкрай"
L["PotSF_BOSS2"] = "Барон Браунпайк"
L["PotSF_BOSS3"] = "Настоятельница Муррпрэй"

-- The Dawnbreaker
L["TDB_BOSS1"] = "Проповедница Темная Корона"
L["TDB_BOSS2"] = "Ануб'иккадж"
L["TDB_BOSS3"] = "Раша'нан"

-- The Rookery
L["TR_BOSS1"] = "Кириосс"
L["TR_BOSS2"] = "Бурестраж Горрен"
L["TR_BOSS3"] = "Чудище камня Бездны"

-- The Stonevault
L["TSV_BOSS1"] = "ЗАЗУ"
L["TSV_BOSS2"] = "Скарморак"
L["TSV_BOSS3"] = "Главные механики"
L["TSV_BOSS4"] = "Вестник Бездны Эйрих"

-- Shadowlands
-- Mists of Tirna Scithe
L["MoTS_BOSS1"] = "Ингра Малох"
L["MoTS_BOSS2"] = "Призывательница Туманов"
L["MoTS_BOSS3"] = "Тред'ова"

--Theater of Pain
L["ToP_BOSS1"] = "Оскорбление претендентов"
L["ToP_BOSS2"] = "Кроворуб"
L["ToP_BOSS3"] = "Ксав Несломленный"
L["ToP_BOSS4"] = "Кул'тарок"
L["ToP_BOSS5"] = "Мордрета, Вечная Императрица"

-- The Necrotic Wake
L["NW_BOSS1"] = "Чумокост"
L["NW_BOSS2"] = "Амарт Жнец"
L["NW_BOSS3"] = "Хирург Трупошов"
L["NW_BOSS4"] = "Налтор Криомант"

-- TO TRANSLATE
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
-- END TO TRANSLATE


-- Battle for Azeroth
-- Operation: Mechagon - Workshop
L["OMGW_BOSS1"] = "Меха-месиво"
L["OMGW_BOSS2"] = "КУ-ДЖ0"
L["OMGW_BOSS3"] = "Сад машиниста"
L["OMGW_BOSS4"] = "Король Мехагон"

-- Siege of Boralus
L["SoB_BOSS1"] = "Сержант Бейнбридж"
L["SoB_BOSS2"] = "Жуткий капитан Локвуд"
L["SoB_BOSS3"] = "Хадал Черная Бездна"
L["SoB_BOSS4"] = "Вик'Гот"

-- The MOTHERLODE!!
L["TML_BOSS1"] = "Платный разгонятель толпы"
L["TML_BOSS2"] = "Азерокк"
L["TML_BOSS3"] = "Рикса Огневерт"
L["TML_BOSS4"] = "Шеф Разданк"

-- Legion

-- Cataclysm
-- Grim Batol
L["GB_BOSS1"] = "Генерал Умбрисс"
L["GB_BOSS2"] = "Начальник кузни Тронг"
L["GB_BOSS3"] = "Драгх Горячий Мрак"
L["GB_BOSS4"] = "Властитель недр Эрудакс"

-- UI Strings
L["FINISHED"] = "Процент подземелья выполнен"
L["SECTION_DONE"] = "Часть подземелья завершена"
L["DONE"] = "Процент части подземелья выполнен"
L["DUNGEON_DONE"] = "Подземелье завершено"
L["OPTIONS"] = "Настройки"
L["GENERAL_SETTINGS"] = "Общие настройки"
L["Changelog"] = "Список изменений"
L["Version"] = "Версия"
L["Important"] = "Важное"
L["New"] = "Новое"
L["Bugfixes"] = "Исправление ошибок"
L["Improvment"] = "Улучшения"
L["%month%-%day%-%year%"] = "%day%-%month%-%year%"
L["DEFAULT_PERCENTAGES"] = "Проценты по умолчанию"
L["ADVANCED_SETTINGS"] = "Пользовательские маршруты"
L["TANK_GROUP_HEADER"] = "Проценты босса"
L["ROLES_ENABLED"] = "Требуемая роль(и)"
L["ROLES_ENABLED_DESC"] = "Выберите, какие роли будут видеть процент, и сообщите об этом группе"
L["LEADER"] = "Лидер"
L["TANK"] = "Танк"
L["HEALER"] = "Целитель"
L["DPS"] = "Дамагер"
L["ENABLE_ADVANCED_OPTIONS"] = "Включить пользовательские маршруты"
L["ADVANCED_OPTIONS_DESC"] = "Это позволит Вам устанавливать индивидуальные проценты, которые необходимо набрать перед каждым боссом, и выбирать, хотите ли Вы информировать группу о каких-либо пропущенных процентах"
L["INFORM_GROUP"] = "Сообщать группе"
L["INFORM_GROUP_DESC"] = "Отправлять сообщения в чат, когда не хватает процентов"
L["MESSAGE_CHANNEL"] = "Канал чата"
L["MESSAGE_CHANNEL_DESC"] = "Выберите, какой канал чата использовать для уведомлений"
L["PARTY"] = "Группа"
L["SAY"] = "Сказать"
L["YELL"] = "Крик"
L["PERCENTAGE"] = "Процент"
L["PERCENTAGE_DESC"] = "Настроить размер текста"
L["FONT"] = "Шрифт"
L["FONT_SIZE"] = "Размер шрифта"
L["FONT_SIZE_DESC"] = "Настроить размер текста"
L["POSITIONING"] = "Позиционирование"
L["COLORS"] = "Цвета"
L["IN_PROGRESS"] = "В процессе"
L["FINISHED"] = "Готово"
L["MISSING"] = "Не хватает"
L["GENERAL"] = "Общее"
L["ANCHOR_POSITION"] = "Положение крепления"
L["VALIDATE"] = "Подтвердить"
L["CANCEL"] = "Отмена"
L["POSITION"] = "Положение"
L["TOP"] = "Сверху"
L["CENTER"] = "Центр"
L["BOTTOM"] = "Снизу"
L["X_OFFSET"] = "Смещение по оси X"
L["Y_OFFSET"] = "Смещение по оси Y"
L["SHOW_ANCHOR"] = "Показать позиционирование крепления"
L["ANCHOR_TEXT"] = "< Переместить KPH >"
L["RESET_DUNGEON"] = "Сброс настроек по умолчанию"
L["RESET_DUNGEON_DESC"] = "Сбросить все процентные значения боссов в этом подземелье по умолчанию"
L["RESET_DUNGEON_CONFIRM"] = "Вы уверены, что хотите сбросить все процентные значения боссов в этом подземелье по умолчанию?"
L["RESET_ALL_DUNGEONS"] = "Сбросить все подземелья"
L["RESET_ALL_DUNGEONS_DESC"] = "Сбросить все подземелья до значений по умолчанию"
L["RESET_ALL_DUNGEONS_CONFIRM"] = "Вы уверены, что хотите сбросить все подземелья до значений по умолчанию?"
L["NEW_SEASON_RESET_PROMPT"] = "Начался новый сезон M+. Хотите сбросить все значения подземелий по умолчанию?"
L["YES"] = "Да"
L["NO"] = "Нет"
L["WE_STILL_NEED"] = "Нам всё ещё нужно"
L["NEW_ROUTES_RESET_PROMPT"] = "В этой версии были обновлены маршруты подземелий по умолчанию. Хотите сбросить текущие маршруты подземелий на новые значения по умолчанию?"
L["RESET_ALL"] = "Сбросить все подземелья"
L["RESET_CHANGED_ONLY"] = "Сбросить только измененные"
L["CHANGED_ROUTES_DUNGEONS_LIST"] = "Обновлены маршруты следующих подземелий:"

-- Export/Import
L["EXPORT_DUNGEON"] = "Экспорт подземелья"
L["EXPORT_DUNGEON_DESC"] = "Экспорт пользовательских процентов для этого подземелья"
L["IMPORT_DUNGEON"] = "Импорт подземелья"
L["IMPORT_DUNGEON_DESC"] = "Импорт пользовательских процентов для этого подземелья"
L["EXPORT_ALL_DUNGEONS"] = "Экспорт всех подземелий"
L["EXPORT_ALL_DUNGEONS_DESC"] = "Экспорт настроек для всех подземелий."
L["EXPORT_ALL_DIALOG_TEXT"] = "Скопируйте строку ниже, чтобы поделиться своими процентными значениями для всех подземелий:"
L["IMPORT_ALL_DUNGEONS"] = "Импортировать все подземелья"
L["IMPORT_ALL_DUNGEONS_DESC"] = "Импортировать настройки для всех подземелий."
L["IMPORT_ALL_DIALOG_TEXT"] = "Вставьте строку ниже, чтобы импортировать пользовательские проценты для всех подземелий:"
L["EXPORT_SECTION"] = "Раздел экспорта"
L["EXPORT_SECTION_DESC"] = "Экспортировать все настройки подземелья для %s."
L["EXPORT_SECTION_DIALOG_TEXT"] = "Скопируйте строку ниже, чтобы поделиться своими процентами для %s:"
L["IMPORT_SECTION"] = "Раздел импорта"
L["IMPORT_SECTION_DESC"] = "Импортировать все настройки подземелья для %s."
L["IMPORT_SECTION_DIALOG_TEXT"] = "Вставьте строку ниже, чтобы импортировать пользовательские проценты для %s:"
L["EXPORT_DIALOG_TITLE"] = "Экспорт процентов подземелий"
L["EXPORT_DIALOG_TEXT"] = "Скопировать строку ниже, чтобы поделиться своими процентами:"
L["IMPORT_DIALOG_TITLE"] = "Импорт процентов подземелий"
L["IMPORT_DIALOG_TEXT"] = "Вставить экспортированную строку ниже:"
L["IMPORT_SUCCESS"] = "Импортирован пользовательский маршрут для %s."
L["IMPORT_ALL_SUCCESS"] = "Импортированный пользовательский маршрут для всех подземелий."
L["IMPORT_ALL_ERROR"] = "Неверная строка импорта."
L["IMPORT_ERROR"] = "Неверная строка импорта"
L["IMPORT_DIFFERENT_DUNGEON"] = "Импортированы настройки для %s. Запуск параметров для этого подземелья."
