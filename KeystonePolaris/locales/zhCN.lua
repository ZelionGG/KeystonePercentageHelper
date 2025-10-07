local AddonName, Engine = ...;

local LibStub = LibStub;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddonName, "zhCN", false, false);
if not L then return end

-- 译者：枫聖御雷

-- Dungeons Group
L["DUNGEONS"] = "当前赛季"
L["CURRENT_SEASON"] = "当前赛季"
L["NEXT_SEASON"] = "下个赛季"
L["EXPANSION_DF"] = "巨龙时代"
L["EXPANSION_CATA"] = "大地的裂变"
L["EXPANSION_WW"] = "地心之战"
L["EXPANSION_SL"] = "暗影国度"
L["EXPANSION_BFA"] = "争霸艾泽拉斯"
L["EXPANSION_LEGION"] = "军团再临"

-- The War Within
-- Ara-Kara, City of Echoes
L["AKCE_BOSS1"] = "阿瓦诺克斯"
L["AKCE_BOSS2"] = "阿努布泽克特"
L["AKCE_BOSS3"] = "收割者吉卡塔尔"

-- City of Threads
L["CoT_BOSS1"] = "演说者基克斯威兹克"
L["CoT_BOSS2"] = "女王之牙"
L["CoT_BOSS3"] = "凝结聚合体"
L["CoT_BOSS4"] = "大捻接师艾佐"

-- Cinderbrew Meadery
L["CBM_BOSS1"] = "酿造大师阿德里尔"
L["CBM_BOSS2"] = "艾帕"
L["CBM_BOSS3"] = "本克·鸣蜂"
L["CBM_BOSS4"] = "戈尔迪·底爵"

-- Darkflame Cleft
L["DFC_BOSS1"] = "老蜡须"
L["DFC_BOSS2"] = "布雷炙孔"
L["DFC_BOSS3"] = "蜡烛之王"
L["DFC_BOSS4"] = "黑暗之主"

-- Eco-Dome Al'Dani
L["EDAD_BOSS1"] = "Azhiccar"
L["EDAD_BOSS2"] = "Taah'bat and A'wazj"
L["EDAD_BOSS3"] = "Soul-Scribe"

-- Operation: Floodgate
L["OFG_BOSS1"] = "老大娘"
L["OFG_BOSS2"] = "破拆双人组"
L["OFG_BOSS3"] = "沼面"
L["OFG_BOSS4"] = "吉泽尔·超震"

-- Priory of the Sacred Flames
L["PotSF_BOSS1"] = "戴尔克莱上尉"
L["PotSF_BOSS2"] = "布朗派克男爵"
L["PotSF_BOSS3"] = "隐修院长穆普雷"

-- The Dawnbreaker
L["TDB_BOSS1"] = "夏多克朗"
L["TDB_BOSS2"] = "阿努布伊卡基"
L["TDB_BOSS3"] = "拉夏南"

-- The Rookery
L["TR_BOSS1"] = "凯里欧斯"
L["TR_BOSS2"] = "雷卫戈伦"
L["TR_BOSS3"] = "虚空石畸体"

-- The Stonevault
L["TSV_BOSS1"] = "E.D.N.A."
L["TSV_BOSS2"] = "斯卡莫拉克"
L["TSV_BOSS3"] = "机械大师"
L["TSV_BOSS4"] = "虚空代言人艾里克"

-- Shadowlands
-- Mists of Tirna Scithe
L["MoTS_BOSS1"] = "英格拉·马洛克"
L["MoTS_BOSS2"] = "唤雾者"
L["MoTS_BOSS3"] = "特雷德奥瓦"

--Theater of Pain
L["ToP_BOSS1"] = "狭路相逢"
L["ToP_BOSS2"] = "斩血"
L["ToP_BOSS3"] = "无堕者哈夫"
L["ToP_BOSS4"] = "库尔萨洛克"
L["ToP_BOSS5"] = "无尽女皇莫德蕾莎"

-- The Necrotic Wake
L["NW_BOSS1"] = "凋骨"
L["NW_BOSS2"] = "收割者阿玛厄斯"
L["NW_BOSS3"] = "外科医生缝肉"
L["NW_BOSS4"] = "收割者阿玛厄斯"

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
L["OMGW_BOSS1"] = "坦克大战"
L["OMGW_BOSS2"] = "狂犬K.U.-J.0."
L["OMGW_BOSS3"] = "机械师的花园"
L["OMGW_BOSS4"] = "麦卡贡国王"

-- Siege of Boralus
L["SoB_BOSS1"] = "“屠夫”血钩"
L["SoB_BOSS2"] = "恐怖船长洛克伍德"
L["SoB_BOSS3"] = "哈达尔·黑渊"
L["SoB_BOSS4"] = "维克戈斯"

-- The MOTHERLODE!!
L["TML_BOSS1"] = "投币式群体打击者"
L["TML_BOSS2"] = "艾泽洛克"
L["TML_BOSS3"] = "瑞克莎·流火"
L["TML_BOSS4"] = "商业大亨拉兹敦克"

-- Legion

-- Cataclysm
-- Grim Batol
L["GB_BOSS1"] = "乌比斯将军"
L["GB_BOSS2"] = "铸炉之主索朗格斯"
L["GB_BOSS3"] = "达加·燃影者"
L["GB_BOSS4"] = "地狱公爵埃鲁达克"

-- UI Strings
L["MODULES"] = "Modules" -- To Translate
L["FINISHED"] = "地下城进度完成"
L["SECTION_DONE"] = "区域完成"
L["DONE"] = "区域进度完成"
L["DUNGEON_DONE"] = "地下城完成"
L["OPTIONS"] = "选项"
L["GENERAL_SETTINGS"] = "通用设置"
L["Changelog"] = "更新日志"
L["Version"] = "版本"
L["Important"] = "重要"
L["New"] = "新内容"
L["Bugfixes"] = "错误修复"
L["Improvment"] = "改进"
L["%month%-%day%-%year%"] = "%年%-%月%-%日%"
L["DEFAULT_PERCENTAGES"] = "默认进度百分比"
L["DEFAULT_PERCENTAGES_DESC"] = "This view shows the addon's built-in defaults and does not reflect your custom routes configuration." -- To Translate
L["ROUTES_DISCLAIMER"] = "By default, Keystone Polaris uses Raider.IO Weekly Routes (Beginner). Custom routes let you define your own different routes. To enable these routes, make sure to enable \"Custom routes\" in the addon's General Settings." -- To Translate
L["ADVANCED_SETTINGS"] = "自定义路线"
L["TANK_GROUP_HEADER"] = "首领进度百分比"
L["ROLES_ENABLED"] = "启用角色"
L["ROLES_ENABLED_DESC"] = "选择哪些角色会看到进度百分比并向团队通报"
L["LEADER"] = "队长"
L["TANK"] = "坦克"
L["HEALER"] = "治疗者"
L["DPS"] = "伤害输出者"
L["ENABLE_ADVANCED_OPTIONS"] = "启用自定义路线"
L["ADVANCED_OPTIONS_DESC"] = "这将允许你为每个首领之前设置自定义进度百分比目标，并选择是否在缺少进度时通知团队"
L["INFORM_GROUP"] = "通知团队"
L["INFORM_GROUP_DESC"] = "当缺少进度时向聊天频道发送消息"
L["MESSAGE_CHANNEL"] = "聊天频道"
L["MESSAGE_CHANNEL_DESC"] = "选择用于通知的聊天频道"
L["PARTY"] = "队伍"
L["SAY"] = "说"
L["YELL"] = "大喊"
L["PERCENTAGE"] = "百分比"
L["PERCENTAGE_DESC"] = "调整文本大小"
L["FONT"] = "字体"
L["FONT_SIZE"] = "字体大小"
L["FONT_SIZE_DESC"] = "调整文本大小"
L["POSITIONING"] = "位置调整"
L["COLORS"] = "颜色"
L["IN_PROGRESS"] = "进行中"
L["MISSING"] = "缺少"
L["FINISHED_COLOR"] = "Done" -- To Translate
L["VALIDATE"] = "确定"
L["CANCEL"] = "取消"
L["POSITION"] = "位置"
L["TOP"] = "上"
L["CENTER"] = "中"
L["BOTTOM"] = "下"
L["X_OFFSET"] = "水平位置"
L["Y_OFFSET"] = "垂直位置"
L["SHOW_ANCHOR"] = "显示定位锚点"
L["ANCHOR_TEXT"] = "< KPL 移动锚点 >"
L["RESET_DUNGEON"] = "重置为默认"
L["RESET_DUNGEON_DESC"] = "将此地下城中所有首领的进度百分比重置为其默认"
L["RESET_DUNGEON_CONFIRM"] = "你确定要将此地下城中所有首领的进度百分比重置为默认吗？"
L["RESET_ALL_DUNGEONS"] = "重置所有地下城"
L["RESET_ALL_DUNGEONS_DESC"] = "将所有地下城重置为其默认值"
L["RESET_ALL_DUNGEONS_CONFIRM"] = "你确定要将所有地下城重置为默认吗？"
L["NEW_SEASON_RESET_PROMPT"] = "新的大秘境赛季已开始。是否要将所有地下城值重置为默认？"
L["YES"] = "是"
L["NO"] = "否"
L["WE_STILL_NEED"] = "我们还需要"
L["NEW_ROUTES_RESET_PROMPT"] = "此版本中默认的地下城路线已更新。是否要将你当前的地下城路线重置为新的路线？"
L["RESET_ALL"] = "重置所有地下城"
L["RESET_CHANGED_ONLY"] = "仅重置有变化的"
L["CHANGED_ROUTES_DUNGEONS_LIST"] = "以下地下城有更新的路线："

-- Changelog
L["COPY_INSTRUCTIONS"] = "Select All, then Ctrl+C to copy. Optional: DeepL https://www.deepl.com/translator"
L["SELECT_ALL"] = "Select All"
L["TRANSLATE"] = "Translate"
L["TRANSLATE_DESC"] = "Copy this changelog in a popup to paste into your translator."

-- Test Mode
L["TEST_MODE"] = "Test Mode"
L["TEST_MODE_OVERLAY"] = "Keystone Polaris: Test Mode"
L["TEST_MODE_OVERLAY_HINT"] = "Preview is simulated. Right-click this hint to exit test mode and reopen settings."
L["TEST_MODE_DESC"] = "Show a live preview of your display configuration without being in a dungeon. This will:\n• Close the settings panel to reveal the preview\n• Show a dim overlay and a hint above the display\n• Simulate combat/out-of-combat every 3s to reveal projected values and pull%\nTip: Right-click the hint to exit Test Mode and reopen settings."
L["TEST_MODE_DISABLED"] = "Test Mode disabled automatically%s"
L["TEST_MODE_REASON_ENTERED_COMBAT"] = "entered combat"
L["TEST_MODE_REASON_STARTED_DUNGEON"] = "started dungeon"
L["TEST_MODE_REASON_CHANGED_ZONE"] = "changed zone"

-- Main Display
L["MAIN_DISPLAY"] = "Main Display"
L["SHOW_REQUIRED_PREFIX"] = "Show required text prefix"
L["SHOW_REQUIRED_PREFIX_DESC"] = "When the base value is numeric (e.g., 12.34%), prefix it with a label (e.g., 'Required:'). No prefix is added for DONE/SECTION/DUNGEON states."
L["LABEL"] = "Prefix"
L["REQUIRED_LABEL_DESC"] = "Label displayed before the numeric required percentage (e.g., 'Required: 12.34%').\n\nClear the field to reset to the default value."
L["SHOW_CURRENT_PERCENT"] = "Show current %"
L["SHOW_CURRENT_PERCENT_DESC"] = "Display the current overall enemy forces percent (from the scenario tracker)."
L["CURRENT_LABEL_DESC"] = "Label displayed before the current percentage value.\n\nClear the field to reset to the default value."
L["SHOW_CURRENT_PULL_PERCENT"] = "Show current pull % (MDT)"
L["SHOW_CURRENT_PULL_PERCENT_DESC"] = "Display the real current pull percent based on engaged mobs using MDT data."
L["PULL_LABEL_DESC"] = "Label displayed before the current pull percentage value.\n\nClear the field to reset to the default value."
L["USE_MULTI_LINE_LAYOUT"] = "Use multi-line layout"
L["USE_MULTI_LINE_LAYOUT_DESC"] = "Show each selected value on a new line."
L["SHOW_PROJECTED"] = "Show projected values"
L["SHOW_PROJECTED_DESC"] = "Append projected values: Current shows (Current + Pull). Required shows (Required - Pull)."
L["SINGLE_LINE_SEPARATOR"] = "Single-line separator"
L["SINGLE_LINE_SEPARATOR_DESC"] = "Separator used between items when not using multi-line layout."
L["FONT_ALIGN"] = "Font align"
L["FONT_ALIGN_DESC"] = "Horizontal alignment for the display text."
L["PREFIX_COLOR"] = "Prefixes color"
L["PREFIX_COLOR_DESC"] = "Color applied to labels/prefixes (Required, Current, Pull)."
L["MAX_WIDTH"] = "Max width (single-line)"
L["MAX_WIDTH_DESC"] = "Maximum width in pixels for single-line layout. 0 = automatic (no wrapping)."
L["REQUIRED_DEFAULT"] = "Required:"
L["CURRENT_DEFAULT"] = "Current:"
L["SECTION_REQUIRED_DEFAULT"] = "Total required for section:"
L["PULL_DEFAULT"] = "Pull:"

-- Section required prefix
L["SHOW_SECTION_REQUIRED_PREFIX"] = "Show section required"
L["SHOW_SECTION_REQUIRED_PREFIX_DESC"] = "Display the current overall enemy forces percent required for the current section without taking into account the progress already done."
L["SECTION_REQUIRED_LABEL_DESC"] = "Label displayed before the section required value.\n\nClear the field to reset to the default value."
L["SECTION_REQUIRED_DEFAULT"] = "Total required for section:"

L["FORMAT_MODE"] = "Text format"
L["FORMAT_MODE_DESC"] = "Select how to display the progress."
L["COUNT"] = "Count"

-- Export/Import
L["EXPORT_DUNGEON"] = "导出地下城"
L["EXPORT_DUNGEON_DESC"] = "导出此地下城的自定义百分比"
L["IMPORT_DUNGEON"] = "导入地下城"
L["IMPORT_DUNGEON_DESC"] = "导入此地下城的自定义百分比"
L["EXPORT_ALL_DUNGEONS"] = "导出所有地下城"
L["EXPORT_ALL_DUNGEONS_DESC"] = "导出所有地下城的设置。"
L["EXPORT_ALL_DIALOG_TEXT"] = "复制下面的字符串以分享你所有地下城的自定义百分比："
L["IMPORT_ALL_DUNGEONS"] = "导入所有地下城"
L["IMPORT_ALL_DUNGEONS_DESC"] = "导入所有地下城的设置。"
L["IMPORT_ALL_DIALOG_TEXT"] = "将下面的字符串粘贴以导入所有地下城的自定义百分比："
L["EXPORT_SECTION"] = "导出分组"
L["EXPORT_SECTION_DESC"] = "导出 %s 的所有地下城设置。"
L["EXPORT_SECTION_DIALOG_TEXT"] = "复制下面的字符串以分享你 %s 的自定义百分比："
L["IMPORT_SECTION"] = "导入分组"
L["IMPORT_SECTION_DESC"] = "导入 %s 的所有地下城设置。"
L["IMPORT_SECTION_DIALOG_TEXT"] = "将下面的字符串粘贴以导入 %s 的自定义百分比："
L["EXPORT_DIALOG_TEXT"] = "复制下面的字符串以分享你的自定义百分比："
L["IMPORT_DIALOG_TEXT"] = "将导出的字符串粘贴在下面："
L["IMPORT_SUCCESS"] = "成功导入 %s 的自定义路线。"
L["IMPORT_ALL_SUCCESS"] = "成功导入所有地下城的自定义路线。"
L["IMPORT_ERROR"] = "导入字符串无效"
L["IMPORT_DIFFERENT_DUNGEON"] = "导入了 %s 的设置。正在为该地下城打开选项。"

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
