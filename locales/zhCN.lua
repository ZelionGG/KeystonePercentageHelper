local AddonName, Engine = ...;

local LibStub = LibStub;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddonName, "zhCN", false, false);
if not L then return end

-- TRANSLATION REQUIRED

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
L["AKCE"] = "艾拉-卡拉，回响之城"
L["AKCE_BOSS1"] = "阿瓦诺克斯"
L["AKCE_BOSS2"] = "阿努布泽克特"
L["AKCE_BOSS3"] = "收割者吉卡塔尔"

-- City of Threads
L["CoT"] = "千丝之城"
L["CoT_BOSS1"] = "演说者基克斯威兹克"
L["CoT_BOSS2"] = "女王之牙"
L["CoT_BOSS3"] = "凝结聚合体"
L["CoT_BOSS4"] = "大捻接师艾佐"

-- Cinderbrew Meadery
L["CBM"] = "燧酿酒庄"
L["CBM_BOSS1"] = "酿造大师阿德里尔"
L["CBM_BOSS2"] = "艾帕"
L["CBM_BOSS3"] = "本克·鸣蜂"
L["CBM_BOSS4"] = "戈尔迪·底爵"

-- Darkflame Cleft
L["DFC"] = "暗焰裂口"
L["DFC_BOSS1"] = "老蜡须"
L["DFC_BOSS2"] = "布雷炙孔"
L["DFC_BOSS3"] = "蜡烛之王"
L["DFC_BOSS4"] = "黑暗之主"

-- Operation: Floodgate
L["OFG"] = "水闸行动"
L["OFG_BOSS1"] = "老大娘"
L["OFG_BOSS2"] = "破拆双人组"
L["OFG_BOSS3"] = "沼面"
L["OFG_BOSS4"] = "吉泽尔·超震"

-- Priory of the Sacred Flames
L["PotSF"] = "圣焰隐修院"
L["PotSF_BOSS1"] = "戴尔克莱上尉"
L["PotSF_BOSS2"] = "布朗派克男爵"
L["PotSF_BOSS3"] = "隐修院长穆普雷"

-- The Dawnbreaker
L["TDB"] = "破晨号"
L["TDB_BOSS1"] = "夏多克朗"
L["TDB_BOSS2"] = "阿努布伊卡基"
L["TDB_BOSS3"] = "拉夏南"

-- The Rookery
L["TR"] = "驭雷栖巢"
L["TR_BOSS1"] = "凯里欧斯"
L["TR_BOSS2"] = "雷卫戈伦"
L["TR_BOSS3"] = "虚空石畸体"

-- The Stonevault
L["TSV"] = "矶石宝库"
L["TSV_BOSS1"] = "E.D.N.A."
L["TSV_BOSS2"] = "斯卡莫拉克"
L["TSV_BOSS3"] = "机械大师"
L["TSV_BOSS4"] = "虚空代言人艾里克"

-- Shadowlands
-- Mists of Tirna Scithe
L["MoTS"] = "塞兹仙林的迷雾"
L["MoTS_BOSS1"] = "英格拉·马洛克"
L["MoTS_BOSS2"] = "唤雾者"
L["MoTS_BOSS3"] = "特雷德奥瓦"

--Theater of Pain
L["ToP"] = "伤逝剧场"
L["ToP_BOSS1"] = "狭路相逢"
L["ToP_BOSS2"] = "斩血"
L["ToP_BOSS3"] = "无堕者哈夫"
L["ToP_BOSS4"] = "库尔萨洛克"
L["ToP_BOSS5"] = "无尽女皇莫德蕾莎"

-- The Necrotic Wake
L["NW"] = "通灵战潮"
L["NW_BOSS1"] = "凋骨"
L["NW_BOSS2"] = "收割者阿玛厄斯"
L["NW_BOSS3"] = "外科医生缝肉"
L["NW_BOSS4"] = "收割者阿玛厄斯"


-- Battle for Azeroth
-- Operation: Mechagon - Workshop
L["OMGW"] = "麦卡贡行动 - 车间"
L["OMGW_BOSS1"] = "坦克大战"
L["OMGW_BOSS2"] = "狂犬K.U.-J.0."
L["OMGW_BOSS3"] = "机械师的花园"
L["OMGW_BOSS4"] = "麦卡贡国王"

-- Siege of Boralus
L["SoB"] = "围攻伯拉勒斯"
L["SoB_BOSS1"] = "“屠夫”血钩"
L["SoB_BOSS2"] = "恐怖船长洛克伍德"
L["SoB_BOSS3"] = "哈达尔·黑渊"
L["SoB_BOSS4"] = "维克戈斯"

-- The MOTHERLODE!!
L["TML"] = "暴富矿区！！"
L["TML_BOSS1"] = "投币式群体打击者"
L["TML_BOSS2"] = "艾泽洛克"
L["TML_BOSS3"] = "瑞克莎·流火"
L["TML_BOSS4"] = "商业大亨拉兹敦克"

-- Legion

-- Cataclysm
-- Grim Batol
L["GB"] = "格瑞姆巴托"
L["GB_BOSS1"] = "乌比斯将军"
L["GB_BOSS2"] = "铸炉之主索朗格斯"
L["GB_BOSS3"] = "达加·燃影者"
L["GB_BOSS4"] = "地狱公爵埃鲁达克"

-- UI Strings
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
L["FINISHED"] = "已完成"
L["MISSING"] = "缺少"
L["GENERAL"] = "通用"
L["ANCHOR_POSITION"] = "锚点位置"
L["VALIDATE"] = "确定"
L["CANCEL"] = "取消"
L["POSITION"] = "位置"
L["TOP"] = "顶部"
L["CENTER"] = "居中"
L["BOTTOM"] = "底部"
L["X_OFFSET"] = "X 偏移"
L["Y_OFFSET"] = "Y 偏移"
L["SHOW_ANCHOR"] = "显示定位锚点"
L["ANCHOR_TEXT"] = "< KPH 移动锚点 >"
L["RESET_DUNGEON"] = "重置为默认值"
L["RESET_DUNGEON_DESC"] = "将此地下城中所有首领的进度百分比重置为其默认值"
L["RESET_DUNGEON_CONFIRM"] = "你确定要将此地下城中所有首领的进度百分比重置为默认值吗？"
L["RESET_ALL_DUNGEONS"] = "重置所有地下城"
L["RESET_ALL_DUNGEONS_DESC"] = "将所有地下城重置为其默认值"
L["RESET_ALL_DUNGEONS_CONFIRM"] = "你确定要将所有地下城重置为默认值吗？"
L["NEW_SEASON_RESET_PROMPT"] = "新的大秘境赛季已开始。是否要将所有地下城值重置为其默认值？"
L["YES"] = "是"
L["NO"] = "否"
L["WE_STILL_NEED"] = "我们还需要"
L["NEW_ROUTES_RESET_PROMPT"] = "此版本中默认的地下城路线已更新。是否要将你当前的地下城路线重置为新的默认值？"
L["RESET_ALL"] = "重置所有地下城"
L["RESET_CHANGED_ONLY"] = "仅重置有变化的"
L["CHANGED_ROUTES_DUNGEONS_LIST"] = "以下地下城有更新的路线："

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
L["EXPORT_DIALOG_TITLE"] = "导出地下城百分比"
L["EXPORT_DIALOG_TEXT"] = "复制下面的字符串以分享你的自定义百分比："
L["IMPORT_DIALOG_TITLE"] = "导入地下城百分比"
L["IMPORT_DIALOG_TEXT"] = "将导出的字符串粘贴在下面："
L["IMPORT_SUCCESS"] = "成功导入 %s 的自定义路线。"
L["IMPORT_ALL_SUCCESS"] = "成功导入所有地下城的自定义路线。"
L["IMPORT_ALL_ERROR"] = "导入字符串无效。"
L["IMPORT_ERROR"] = "导入字符串无效"
L["IMPORT_DIFFERENT_DUNGEON"] = "导入了 %s 的设置。正在为该地下城打开选项。"
