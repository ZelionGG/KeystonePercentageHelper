local AddonName, Engine = ...;

local LibStub = LibStub;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddonName, "ruRU", false, false);
if not L then return end

-- Last translated October 8th, 2025.
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

-- Eco-Dome Al'Dani
L["EDAD_BOSS1"] = "Ажиккар"
L["EDAD_BOSS2"] = "Таа'бат и А'вазж"
L["EDAD_BOSS3"] = "Переписчица душ"

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

-- Halls of Atonement
L["HoA_BOSS1"] = "Халкиас"
L["HoA_BOSS2"] = "Эшелон"
L["HoA_BOSS3"] = "Верховный адъюдикатор Ализа"
L["HoA_BOSS4"] = "Лорд-камергер"

-- Tazavesh: Streets of Wonder
L["TSoW_BOSS1"] = "Зо'фекс Часовой"
L["TSoW_BOSS2"] = "Алькруукс"
L["TSoW_BOSS3"] = "ПОЧТ-мейстер"
L["TSoW_BOSS4"] = "Зо'грон"
L["TSoW_BOSS5"] = "Со'азми"

-- Tazavesh: So'leah's Gambit
L["TSLG_BOSS1"] = "Хильбранд"
L["TSLG_BOSS2"] = "Хронокэп Крюкохвост"
L["TSLG_BOSS3"] = "Со'лея"

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
L["MODULES"] = "Модули"
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
L["DEFAULT_PERCENTAGES_DESC"] = "Здесь показаны встроенные параметры аддона по умолчанию, и они не отражают Вашу пользовательскую конфигурацию маршрутов."
L["ROUTES_DISCLAIMER"] = "По умолчанию Keystone Polaris использует еженедельные маршруты Raider.IO (для начинающих). Пользовательские маршруты позволяют Вам создавать собственные маршруты. Чтобы включить эти маршруты, убедитесь, что в общих настройках дополнения включена опция \"Пользовательские маршруты\""
L["ADVANCED_SETTINGS"] = "Пользовательские маршруты"
L["TANK_GROUP_HEADER"] = "Проценты босса"
L["ROLES_ENABLED"] = "Требуемая роль(и)"
L["ROLES_ENABLED_DESC"] = "Выберите, какие роли будут видеть процент, и сообщите об этом группе"
L["LEADER"] = "Лидер"
L["TANK"] = "Танк"
L["HEALER"] = "Целитель"
L["DPS"] = "Дамагер"
L["ENABLE"] = "Включить"
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
L["MISSING"] = "Не хватает"
L["FINISHED_COLOR"] = "Готово"
L["VALIDATE"] = "Подтвердить"
L["CANCEL"] = "Отмена"
L["POSITION"] = "Положение"
L["TOP"] = "Сверху"
L["CENTER"] = "Центр"
L["BOTTOM"] = "Снизу"
L["X_OFFSET"] = "Смещение по оси X"
L["Y_OFFSET"] = "Смещение по оси Y"
L["SHOW_ANCHOR"] = "Показать позиционирование крепления"
L["ANCHOR_TEXT"] = "< Переместить KPL >"
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

-- Changelog
L["COPY_INSTRUCTIONS"] = "Выделите всё, затем нажмите Ctrl+C, чтобы скопировать. Дополнительно: DeepL - https://www.deepl.com/translator"
L["SELECT_ALL"] = "Выбрать всё"
L["TRANSLATE"] = "Перевод"
L["TRANSLATE_DESC"] = "Скопируйте этот список изменений во всплывающее окно и вставьте его в свой переводчик."

-- Test Mode
L["TEST_MODE"] = "Тестовый режим"
L["TEST_MODE_OVERLAY"] = "Keystone Percentage Helper: Тестовый режим"
L["TEST_MODE_OVERLAY_HINT"] = "Предварительный просмотр имитируется. Щелкните ПКМ по этой подсказке, чтобы выйти из тестового режима и снова открыть настройки."
L["TEST_MODE_DESC"] = "Показать предварительный просмотр конфигурации Вашего дисплея в реальном времени, не находясь в подземелье. Это позволит:\n• Закрыть панель настроек, чтобы открыть предварительный просмотр\n• Показать затемнённое наложение и подсказку над дисплеем\n• Симулировать бой/вне боя каждые 3 сек., чтобы выявить прогнозируемые значения и процент пулла\nСовет: щелкните ПКМ по подсказке, чтобы выйти из тестового режима и заново открыть настройки."
L["TEST_MODE_DISABLED"] = "Тестовый режим отключен автоматически%s"
L["TEST_MODE_REASON_ENTERED_COMBAT"] = "вступил в бой"
L["TEST_MODE_REASON_STARTED_DUNGEON"] = "запущенное подземелье"
L["TEST_MODE_REASON_CHANGED_ZONE"] = "измененная зона"

-- Main Display
L["MAIN_DISPLAY"] = "Основное отображение"
L["SHOW_REQUIRED_PREFIX"] = "Показать требуемый текстовый префикс"
L["SHOW_REQUIRED_PREFIX_DESC"] = "Если базовое значение в виде числа (например, 12,34%), добавьте к нему метку (например, 'Требуется:'). Для состояний 'ГОТОВО', 'РАЗДЕЛ' или 'ПОДЗЕМЕЛЬЕ' префикс не добавляется."
L["LABEL"] = "Префикс"
L["REQUIRED_LABEL_DESC"] = "Метка, отображаемая перед требуемым числовым процентом (например, 'Требуется: 12,34%').\n\nОчистите поле, чтобы сбросить значение по умолчанию."
L["SHOW_CURRENT_PERCENT"] = "Показать текущий %"
L["SHOW_CURRENT_PERCENT_DESC"] = "Отображение текущего процента общей численности противника (из отслеживания сценариев)."
L["CURRENT_LABEL_DESC"] = "Метка отображается перед текущим процентным значением.\n\nОчистите поле, чтобы сбросить значение по умолчанию."
L["SHOW_CURRENT_PULL_PERCENT"] = "Показать текущий процент пулла (MDT)"
L["SHOW_CURRENT_PULL_PERCENT_DESC"] = "Отображение реального текущего процента пулла на основе вовлечённых мобов с использованием данных MDT."
L["PULL_LABEL_DESC"] = "Метка, отображаемая перед текущим значением процента извлечения.\n\nОчистите поле, чтобы сбросить значение по умолчанию."
L["USE_MULTI_LINE_LAYOUT"] = "Использовать многострочное расположение"
L["USE_MULTI_LINE_LAYOUT_DESC"] = "Показывать каждое выбранное значение в новой строке."
L["SHOW_PROJECTED"] = "Показывать прогнозируемые значения"
L["SHOW_PROJECTED_DESC"] = "Добавить прогнозируемые значения: Текущие отображения (Текущий + Пулл). Требуемые отображения (Требуется - Пулл)."
L["SINGLE_LINE_SEPARATOR"] = "Однострочный разделитель"
L["SINGLE_LINE_SEPARATOR_DESC"] = "Разделитель, используемый между элементами, если не используется многострочное расположение."
L["FONT_ALIGN"] = "Выравнивание шрифта"
L["FONT_ALIGN_DESC"] = "Горизонтальное выравнивание отображаемого текста."
L["PREFIX_COLOR"] = "Цвет префиксов"
L["PREFIX_COLOR_DESC"] = "Цвет, применяемый к меткам/префиксам ('Требуется', 'текущий', 'пулл')."
L["MAX_WIDTH"] = "Максимальная ширина (однострочная)"
L["MAX_WIDTH_DESC"] = "Максимальная ширина в пикселях для однострочного расположения; 0 = автоматически (без переноса)."
L["REQUIRED_DEFAULT"] = "Требуется:"
L["CURRENT_DEFAULT"] = "Текущий:"
L["SECTION_REQUIRED_DEFAULT"] = "Всего требуется для этой части подземелья:"
L["PULL_DEFAULT"] = "Пулл:"

-- Section required prefix
L["SHOW_SECTION_REQUIRED_PREFIX"] = "Показать требуемую часть подземелья"
L["SHOW_SECTION_REQUIRED_PREFIX_DESC"] = "Отображает текущий процент общих сил противника, необходимых для текущей части подземелья, без учета уже достигнутого прогресса."
L["SECTION_REQUIRED_LABEL_DESC"] = "Метка отображается перед частью подземелья требуемого значения.\n\nОчистите поле, чтобы сбросить значения по умолчанию."
L["SECTION_REQUIRED_DEFAULT"] = "Всего требуется для части подземелья:"

L["FORMAT_MODE"] = "Формат текста"
L["FORMAT_MODE_DESC"] = "Выберите способ отображения прогресса."
L["COUNT"] = "Счётчик"

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
L["EXPORT_DIALOG_TEXT"] = "Скопировать строку ниже, чтобы поделиться своими процентами:"
L["IMPORT_DIALOG_TEXT"] = "Вставить экспортированную строку ниже:"
L["IMPORT_SUCCESS"] = "Импортирован пользовательский маршрут для %s."
L["IMPORT_ALL_SUCCESS"] = "Импортированный пользовательский маршрут для всех подземелий."
L["IMPORT_ERROR"] = "Неверная строка импорта"
L["IMPORT_DIFFERENT_DUNGEON"] = "Импортированы настройки для %s. Запуск параметров для этого подземелья."

-- MDT Integration
L["MDT_INTEGRATION_FEATURES"] = "Возможности интеграции Mythic Dungeon Tools"
L["MOB_PERCENTAGES_INFO"] = "• |cff00ff00Проценты мобов|r: Показывает процент вражеских сил на индикаторах здоровья в подземельях M+."
L["MOB_INDICATOR_INFO"] = "• |cff00ff00Индикаторы мобов|r: Ставит метки на индикаторы здоровья, чтобы показать, какие враги включены в Ваш текущий маршрут MDT."

-- Mob Percentages
L["MOB_PERCENTAGES"] = "Проценты мобов"
L["ENABLE_MOB_PERCENTAGES"] = "Отображать проценты мобов"
L["ENABLE_MOB_PERCENTAGES_DESC"] = "Показывать процент каждого моба в подземельях M+"
L["MOB_PERCENTAGE_FONT_SIZE"] = "Размер шрифта"
L["MOB_PERCENTAGE_FONT_SIZE_DESC"] = "Установить размер шрифта для текста процента мобов"
L["MOB_PERCENTAGE_POSITION"] = "Положение"
L["MOB_PERCENTAGE_POSITION_DESC"] = "Установить положение процентного текста относительно индикаторов здоровья."
L["RIGHT"] = "Право"
L["LEFT"] = "Лево"
L["TOP"] = "Верх"
L["BOTTOM"] = "Низ"
L["MDT_WARNING"] = "Для этой функции требуется установленный аддон Mythic Dungeon Tools (MDT)."
L["MDT_FOUND"] = "Найден Mythic Dungeon Tools. Проценты мобов будут использовать данные MDT."
L["MDT_LOADED"] = "Mythic Dungeon Tools успешно загружен."
L["MDT_NOT_FOUND"] = "Mythic Dungeon Tools не найден. Проценты мобов не будут отображаться. Для работы этой функции требуется MDT."
L["MDT_INTEGRATION"] = "Интеграция MDT"
L["MDT_SECTION_WARNING"] = "Для этого раздела требуется установленный аддон Mythic Dungeon Tools (MDT)."
L["DISPLAY_OPTIONS"] = "Параметры отображения"
L["APPEARANCE_OPTIONS"] = "Параметры внешнего вида"
L["SHOW_PERCENTAGE"] = "Процент"
L["SHOW_PERCENTAGE_DESC"] = "Показать процентное значение для каждого моба"
L["SHOW_COUNT"] = "Количество"
L["SHOW_COUNT_DESC"] = "Показывать значение количества для каждого моба"
L["SHOW_TOTAL"] = "Итоговый результат"
L["SHOW_TOTAL_DESC"] = "Показать общее количество, необходимое для 100%"
L["TEXT_COLOR"] = "Цвет шрифта"
L["TEXT_COLOR_DESC"] = "Установить цвет текста на индикаторах здоровья"
L["CUSTOM_FORMAT"] = "Формат текста"
L["CUSTOM_FORMAT_DESC"] = "Введите пользовательский формат. Используйте %s для процентов, %c для количества и %t для итогового результата. Примеры: (%s), %s | %c/%t, %c и т.д..."
L["RESET_TO_DEFAULT"] = "Сброс"
L["RESET_FORMAT_DESC"] = "Сбросить формат текста до значения по умолчанию (скобки)"

-- Mob Indicators
L["MOB_INDICATOR"] = "Индикаторы мобов"
L["ENABLE_MOB_INDICATORS"] = "Отображать индикаторы мобов"
L["ENABLE_MOB_INDICATORS_DESC"] = "Показывать индикатор для каждого моба, включенного в маршрут MDT"
L["MOB_INDICATOR_TEXTURE_HEADER"] = "Значок индикатора"
L["MOB_INDICATOR_TEXTURE"] = "Значок индикатора (ID или путь)"
L["MOB_INDICATOR_TEXTURE_SIZE"] = "Размер"
L["MOB_INDICATOR_TEXTURE_SIZE_DESC"] = "Установить размер текстуры для значка индикатора"
L["MOB_INDICATOR_COLORING_HEADER"] = "Раскрашивание"
L["MOB_INDICATOR_BEHAVIOR"] = "Режим"
L["MOB_INDICATOR_AUTO_ADVANCE"] = "Автоматический следующий пулл"
L["MOB_INDICATOR_AUTO_ADVANCE_DESC"] = "Автоматическое переключение на следующий пулл, если не видно противников текущего пулла."
L["MOB_INDICATOR_TINT"] = "Оттенок индикатора"
L["MOB_INDICATOR_TINT_DESC"] = "Оттенок значка индикатора"
L["MOB_INDICATOR_TINT_COLOR"] = "Цвет"
L["MOB_INDICATOR_POSITION_HEADER"] = "Позиционирование"
