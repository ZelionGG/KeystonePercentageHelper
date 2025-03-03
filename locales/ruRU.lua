local AddonName, Engine = ...;

local LibStub = LibStub;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddonName, "ruRU", false, false);
if not L then return end

-- Translated January 14th, 2025 year.
-- Translation by Hollicsh (https://github.com/Hollicsh)

-- Dungeons Group
L["DUNGEONS"] = "Подземелья"
L["CURRENT_SEASON"] = "Текущий сезон"
L["CURRENT_SEASON_DUNGEONS"] = "Подземелья текущего сезона"
L["NEXT_SEASON"] = "Следующий сезон"
L["NEXT_SEASON_DUNGEONS"] = "Подземелья следующего сезона"
L["EXPANSION_DF"] = "Драконы"
L["EXPANSION_CATA"] = "Катаклизм"
L["EXPANSION_WW"] = "Война Внутри"
L["EXPANSION_SL"] = "Темные Земли"
L["EXPANSION_BFA"] = "Битва за Азерот"
L["EXPANSION_LEGION"] = "Легион"

-- The War Within
-- Ara-Kara, City of Echoes
L["AKCE"] = "Ара-Кара, Город Отголосков"
L["AKCE_BOSS1"] = "Аванокс"
L["AKCE_BOSS2"] = "Ануб'зект"
L["AKCE_BOSS3"] = "Ки'катал Жница"

-- City of Threads
L["CoT"] = "Город Нитей"
L["CoT_BOSS1"] = "Оратор Крикс'визк"
L["CoT_BOSS2"] = "Клыки королевы"
L["CoT_BOSS3"] = "Сгустолиция"
L["CoT_BOSS4"] = "Изо Великай Сращивательница"

-- Cinderbrew Meadery
L["CBM"] = "Искроварня"
L["CBM_BOSS1"] = "Хмелевар Алдрир"
L["CBM_BOSS2"] = "И'па"
L["CBM_BOSS3"] = "Бенк Жужжикс"
L["CBM_BOSS4"] = "Голди Барондон"

-- Darkflame Cleft
L["DFC"] = "Расселина Темного Пламени"
L["DFC_BOSS1"] = "Старый Воскобород"
L["DFC_BOSS2"] = "Пламекон"
L["DFC_BOSS3"] = "Свечной Король"
L["DFC_BOSS4"] = "Тьма"

-- Operation: Floodgate
L["OFG"] = "Операция: Шлюз"
L["OFG_BOSS1"] = "Большая МАМА"
L["OFG_BOSS2"] = "Пара подрывников"
L["OFG_BOSS3"] = "Торфоморд"
L["OFG_BOSS4"] = "Гизл Гигабжик"

-- Priory of the Sacred Flames
L["PotSF"] = "Приорат Священного Пламени"
L["PotSF_BOSS1"] = "Капитан Дейлкрай"
L["PotSF_BOSS2"] = "Барон Браунпайк"
L["PotSF_BOSS3"] = "Настоятельница Муррпрэй"

-- The Dawnbreaker
L["TDB"] = "Сияющий Рассвет"
L["TDB_BOSS1"] = "Проповедница Темная Корона"
L["TDB_BOSS2"] = "Ануб'иккадж"
L["TDB_BOSS3"] = "Раша'нан"

-- The Rookery
L["TR"] = "Гнездовье"
L["TR_BOSS1"] = "Кириосс"
L["TR_BOSS2"] = "Бурестраж Горрен"
L["TR_BOSS3"] = "Чудище камня Бездны"

-- The Stonevault
L["TSV"] = "Каменный Свод"
L["TSV_BOSS1"] = "ЗАЗУ"
L["TSV_BOSS2"] = "Скарморак"
L["TSV_BOSS3"] = "Главные механики"
L["TSV_BOSS4"] = "Вестник Бездны Эйрих"

-- Shadowlands
-- Mists of Tirna Scithe
L["MoTS"] = "Туманы Тирна Скитта"
L["MoTS_BOSS1"] = "Ингра Малох"
L["MoTS_BOSS2"] = "Призывательница Туманов"
L["MoTS_BOSS3"] = "Тред'ова"

--Theater of Pain
L["ToP"] = "Театр Боли"
L["ToP_BOSS1"] = "Оскорбление претендентов"
L["ToP_BOSS2"] = "Кроворуб"
L["ToP_BOSS3"] = "Ксав Несломленный"
L["ToP_BOSS4"] = "Кул'тарок"
L["ToP_BOSS5"] = "Мордрета, Вечная Императрица"

-- The Necrotic Wake
L["NW"] = "Смертельная Тризна"
L["NW_BOSS1"] = "Чумокост"
L["NW_BOSS2"] = "Амарт Жнец"
L["NW_BOSS3"] = "Хирург Трупошов"
L["NW_BOSS4"] = "Налтор Криомант"


-- Battle for Azeroth
-- Operation: Mechagon - Workshop
L["OMGW"] = "Операция Мехагон - Мастерская"
L["OMGW_BOSS1"] = "Меха-месиво"
L["OMGW_BOSS2"] = "КУ-ДЖ0"
L["OMGW_BOSS3"] = "Сад машиниста"
L["OMGW_BOSS4"] = "Король Мехагон"

-- Siege of Boralus
L["SoB"] = "Осада Боралуса"
L["SoB_BOSS1"] = "Сержант Бейнбридж"
L["SoB_BOSS2"] = "Жуткий капитан Локвуд"
L["SoB_BOSS3"] = "Хадал Черная Бездна"
L["SoB_BOSS4"] = "Вик'Гот"

-- The MOTHERLODE!!
L["TML"] = "ЗОЛОТАЯ ЖИЛА!!!"
L["TML_BOSS1"] = "Платный разгонятель толпы"
L["TML_BOSS2"] = "Азерокк"
L["TML_BOSS3"] = "Рикса Огневерт"
L["TML_BOSS4"] = "Шеф Разданк"

-- Legion

-- Cataclysm
-- Grim Batol
L["GB"] = "Грим Батол"
L["GB_BOSS1"] = "Генерал Умбрисс"
L["GB_BOSS2"] = "Начальник кузни Тронг"
L["GB_BOSS3"] = "Драгх Горячий Мрак"
L["GB_BOSS4"] = "Властитель недр Эрудакс"

-- UI Strings
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

-- Export/Import
L["EXPORT_DUNGEON"] = "Экспорт подземелья"
L["EXPORT_DUNGEON_DESC"] = "Экспорт пользовательских процентов для этого подземелья"
L["IMPORT_DUNGEON"] = "Импорт подземелья"
L["IMPORT_DUNGEON_DESC"] = "Импорт пользовательских процентов для этого подземелья"
-- To translate
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
-- End to translate
L["EXPORT_DIALOG_TITLE"] = "Экспорт процентов подземелий"
L["EXPORT_DIALOG_TEXT"] = "Скопировать строку ниже, чтобы поделиться своими процентами:"
L["IMPORT_DIALOG_TITLE"] = "Импорт процентов подземелий"
L["IMPORT_DIALOG_TEXT"] = "Вставить экспортированную строку ниже:"
L["IMPORT_SUCCESS"] = "Импортирован пользовательский маршрут для %s."
-- To translate
L["IMPORT_ALL_SUCCESS"] = "Imported custom route for all dungeons."
L["IMPORT_ALL_ERROR"] = "Invalid import string."
-- End to translate
L["IMPORT_ERROR"] = "Неверная строка импорта"
L["IMPORT_DIFFERENT_DUNGEON"] = "Импортированы настройки для %s. Запуск параметров для этого подземелья."
