//
//  GameListModel.swift
//  FuTu
//
//  Created by Administrator1 on 7/11/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class GameListDataSource: NSObject {
    
    var gameName: String!
    var imgName: String!
    var url: String!
    
    init(gameName:String, imgName:String, url:String) {
        
        self.gameName = gameName
        self.imgName = imgName
        self.url = url
    }
}
enum GameListTag:Int {
    case backBtnTag = 10,changeViewListBtnTag,changeViewImgBtnTag
    case gameTypeBtnTag = 20
    case gameTypeBtnBackImg = 30
    case gameTypeBtnTextImg = 40
    
}

class GameListModel: NSObject {
    
    //游戏列表页背景图
    let backgroundImage = "list_bg.png"
    
    //导航栏宽度
    let navWidht: CGFloat = deviceScreen.width
    //导航栏高度
    let navHeight: CGFloat = isPhone ? 60 : 40
    //导航栏背景图
    let navBackgroundImg = "list_nav_background.png"
    
    //返回按钮的宽度
    let backBtnWidth:CGFloat = 60
    //导航栏返回按钮图
//    let navBackBtnImg = "list_nav_back0.png"
//    let navBackBtnImg1 = "list_nav_back1.png"
    
    //导航按钮名称（3D）
//    var navItems_BS = ["所有游戏", "3D老虎机", "经典老虎机", "桌面游戏", "电子扑克", "其他游戏"]
    
    //增加游戏需要修改
    var navItems_BS = ["所有游戏"]

    //导航按钮名称（AV）
    let navItems_AV = ["所有游戏", "性感1", "性感2", "性感3", "性感4", "性感5"]
    //导航按钮名称（PT）
    let navItems_PT = ["所有游戏", "3D老虎机", "经典老虎机", "桌面游戏", "电子扑克", "其他游戏"]
    //导航按钮名称（TTG）
    let navItems_TTG = ["所有游戏"]
    //导航按钮名称（SG）
    let navItems_SG = ["所有游戏"]
    //导航按钮名称（HB）
    let navItems_HB = ["所有游戏"]
    //导航按钮名称（MG）
    let navItems_MG = ["所有游戏"]
    //导航按钮名称（PNG）
    let navItems_PNG = ["所有游戏"]
    //导航按钮名称（newPT）
    let navItems_newPT = ["所有游戏"]
//    //导航按钮名称（AG）
//    let navItems_AG = ["所有游戏"]
//    let navItems_AGFish = ["所有游戏"]
    
    //导航栏按钮图片(AV)
//    let navBtnImg_AV_normal = ["list_gameType_all_0.png", "list_gameType_sex1_0.png", "list_gameType_sex2_0.png", "list_gameType_sex3_0.png", "list_gameType_sex4_0.png", "list_gameType_sex5_0.png"]
//    
//    let navBtnImg_AV_select = ["list_gameType_all_1.png", "list_gameType_sex1_1.png", "list_gameType_sex2_1.png","list_gameType_sex3_1.png", "list_gameType_sex4_1.png", "list_gameType_sex5_1.png"]
    //导航栏按钮图片(其他)
    let navBtnImg_BS_normal = ["list_gameType_all_0.png", "list_gameType_3D_0.png", "list_gameType_classic_0.png",  "list_gameType_deskTop_0.png", "list_gameType_electric_0.png", "list_gameType_other_0.png"]
    
    let navBtnImg_BS_select = ["list_gameType_all_1.png", "list_gameType_3D_1.png", "list_gameType_classic_1.png", "list_gameType_deskTop_1.png", "list_gameType_electric_1.png", "list_gameType_other_1.png"]
    let navBtnImgSelectBack = "list_gameType_back_1.png"
    
    
    //导航按钮字体颜色
    let navBtnTextColor = UIColor.white
    //导航按钮字体大小
    let navBtnTextFont:CGFloat = 13
    //切换图片距离右侧的距离
    let changeImg_right: CGFloat = 5
    
    //收藏按钮图片
    let starImg = "list_button_start"
    let starImg2 = "list_button_start2"
    //切换图片显示图片
    let change_img = "list_button_img0.png"
    let change_img2 = "list_button_img1.png"
    //切换列表显示图片
    let change_list = "list_button_list0.png"
    let change_list2 = "list_button_list1.png"
//    //所有游戏按钮的图片
//    let diamond_allGame = "list_button_diamond"
//    let diamond_allGame2 = "list_button_diamond2"
    
    
    
    
    
    //单个游戏之间的距离
    let gameBtnDistLascap1:CGFloat = isPhone ? 7 : 5
    let gameBtnDistPortrait1:CGFloat = isPhone ? 12 : 20
    let gameBtnDistLascap2:CGFloat = isPhone ? 16 : 20
    let gameBtnDistPortrait2:CGFloat = isPhone ? 6 : 10
    
    //单个游戏的圆角半径
    let gameBtnCorner:CGFloat = isPhone ? 5 : 3
    
    //单个游戏的图片圆角半径
    let gameBtnImgCorner:CGFloat = isPhone ? 5 : 3
    
    //滚动视图左上角位置
    let scrollPoint = CGPoint(x: 0, y: adapt_H(height: isPhone ? 60 : 40))
    
    //每页游戏个数(图片展示页)
    let gameNumPerPage1 = 8
    
    //每页游戏个数(列表展示页)
    let gameNumPerPage2 = 18
    
    //游戏按钮文字的大小
    let gameTextSize1: CGFloat = fontAdapt(font: isPhone ? 14 : 8)
    let gameTextSize2: CGFloat = fontAdapt(font: isPhone ? 18 : 10)
    
    
    
    //新PT游戏链接地址
    let newPTGameAddrTest = "https://gs2.stg.m27613.com/v1/mrch/game?language=zh-cn&merchantCode=swgenesisfubao&playmode=fun&merch_login_url=http://www.toobet88.co/NewPT"
//    let newPTGameAddr = "https://gs2.m27613.com/v1/mrch/game?language=zh-cn&merchantCode=swgnsfubao&playmode=real&merch_login_url=http://www.toobet88.co/NewPT"
    let newPTGameAddr = "https://gs2.m27613.com/v1/mrch/game?language=zh-cn&merchantCode=swgnsfubao&playmode=real&merch_login_url="
    let navItem_newPT0 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56]

    //新PT老虎机游戏列表数据
    let newPTDataSource: NSMutableArray = [["龙龙龙","List_newPT_sw_lll.jpg","sw_lll"],
                                           ["金钱蛙","List_newPT_sw_jqw.jpg","sw_jqw"],
                                           ["招财童子","List_newPT_sw_shctz.jpg","sw_shctz"],
                                           ["权杖女王","List_newPT_sw_qow.jpg","sw_qow"],
                                           ["印加帝国头奖","List_newPT_sw_ijp.jpg","sw_ijp"],
                                           ["疯狂麻将","List_newPT_sw_fkmj.jpg","sw_fkmj"],
                                           ["宝石女王","List_newPT_sw_gq.jpg","sw_gq"],
                                           ["四象","List_newPT_sw_sixng.jpg","sw_sixng"],
                                           ["超级八","List_newPT_sw_ch8.jpg","sw_ch8"],
                                           ["幸运狮子","List_newPT_sw_fl.jpg","sw_fl"],
                                           ["好事成双","List_newPT_sw_hcs.jpg","sw_hcs"],
                                           ["五虎将","List_newPT_sw_whmj.jpg","sw_whmj"],
                                           ["亚洲幻想","List_newPT_sw_af.jpg","sw_af"],
                                           
                                           
                                           
                                           ["加油金块","List_newPT_sw_gs.jpg","sw_gs"],
                                           ["加油金罐","List_newPT_sw_ps.jpg","sw_ps"],
                                           ["法老","List_newPT_sw_qotp.jpg","sw_qotp"],
                                           ["送福","List_newPT_sw_rr.jpg","sw_rr"],
                                           ["四美","List_newPT_sw_fb.jpg","sw_fb"],
                                           ["阿兹特克送福","List_newPT_sw_ar.jpg","sw_ar"],
                                           ["百搭雄狮","List_newPT_sw_bl.jpg","sw_bl"],
                                           ["豪华大蓝","List_newPT_sw_dld.jpg","sw_dld"],
                                           ["福气水果","List_newPT_sw_fuqsg.jpg","sw_fuqsg"],
                                           ["酷炫财神","List_newPT_sw_kxcs.jpg","sw_kxcs"],
                                           ["海盗女皇","List_newPT_sw_pe.jpg","sw_pe"],
                                           ["招财熊猫","List_newPT_sw_zcxm.jpg","sw_zcxm"],
                                           
                                           ["走运老夫子","List_newPT_sw_lucky_omq.jpg","sw_lucky_omq"],
                                           ["宝石王","List_newPT_sw_gk.jpg","sw_gk"],
                                           ["黑杰克","List_newPT_sw_bjc.jpg","sw_bjc"],
                                           
                                           ["三姐妹","List_newPT_sw_ts.jpg","sw_ts"],
                                           ["现金霸王龙","List_newPT_sw_tr.jpg","sw_tr"],
                                           ["糖果炸弹","List_newPT_sw_rc.jpg","sw_rc"],
                                           ["八方女神","List_newPT_sw_go8d.jpg","sw_go8d"],
                                           ["众神之王","List_newPT_sw_kog.jpg","sw_kog"],
                                           ["熊猫vs山羊","List_newPT_sw_pvg.jpg","sw_pvg"],
                                           ["囍","List_newPT_sw_sx.jpg","sw_sx"],
                                           ["财神爷","List_newPT_sw_csy.jpg","sw_csy"],
                                           ["吉祥龙","List_newPT_sw_jxl.jpg","sw_jxl"],
                                           ["维京女王","List_newPT_sw_qv.jpg","sw_qv"],
                                           ["熊猫财富","List_newPT_sw_pg.jpg","sw_pg"],
                                           ["熊猫奖励","List_newPT_sw_pp.jpg","sw_pp"],
                                           ["逆戟鲸,冰山和企鹅","List_newPT_sw_totiatp.jpg","sw_totiatp"],
                                           ["财富城堡","List_newPT_sw_fc.jpg","sw_fc"],
                                           ["美人鱼宝藏","List_newPT_sw_mj.jpg","sw_mj"],
                                           ["双龙传","List_newPT_sw_t2d.jpg","sw_t2d"],
                                           ["名利双收","List_newPT_sw_gg.jpg","sw_gg"],
                                           ["超强三人组","List_newPT_sw_mt.jpg","sw_mt"],
                                           ["88 师父","List_newPT_sw_88sf.jpg","sw_88sf"],
                                           ["九子一王","List_newPT_sw_9s1k.jpg","sw_9s1k"],
                                           ["狂野麒麟","List_newPT_sw_wq.jpg","sw_wq"],
                                           ["傳奇巨龍","List_newPT_sw_ld.jpg","sw_ld"],
                                           ["游园会","List_newPT_sw_cts.jpg","sw_cts"],
                                           ["黃金花園","List_newPT_sw_ggdn.jpg","sw_ggdn"],
                                           ["天上凤凰","List_newPT_sw_hp.jpg","sw_hp"],
                                           
                                           
                                           ["神龙宝石","List_newPT_sw_slbs.jpg","sw_slbs"],
                                           ["捕鱼多福","List_newPT_sw_fufish-jp.jpg","sw_fufish-jp"],
                                           ["老夫子","List_newPT_sw_omqjp.jpg","sw_omqjp"],
                                           ["捕鱼多福","List_newPT_sw_fufish_intw.jpg","sw_fufish_intw"],
                                           ["三福","List_newPT_sw_sf.jpg","sw_sf"],
                                           ["猴子先生","List_newPT_sw_mrmnky.jpg","sw_mrmnky"],
                                           ["快乐海豚","List_newPT_sw_dd.jpg","sw_dd"],
                                           ["丛林翻倍赢","List_newPT_sw_dj.jpg","sw_dj"],
                                           
                                           ["水果财富","List_newPT_sw_sgcf.jpg","sw_sgcf"],
                                           ["亚马逊美人","List_newPT_sw_al.jpg","sw_al"],
                                           ["福宝宝","List_newPT_sw_fbb.jpg","sw_fbb"],
                                           ["狂热重转","List_newPT_sw_rm.jpg","sw_rm"],
                                           ["冰火女王","List_newPT_sw_qoiaf.jpg","sw_qoiaf"],
                                           ["冰雪女王","List_newPT_sw_sq.jpg","sw_sq"],
                                           ["虎虎生财","List_newPT_sw_tc.jpg","sw_tc"],
                                           ["双倍奖金","List_newPT_sw_db.jpg","sw_db"],
                                           
                                           ["钻石交响曲","List_newPT_sw_sod.jpg","sw_sod"],
                                           ["猩猩月亮","List_newPT_sw_gm.jpg","sw_gm"],
                                           ["美人鱼","List_newPT_sw_mer.jpg","sw_mer"],
                                           ["大黑赐福","List_newPT_sw_dhcf.jpg","sw_dhcf"],
                                           ["熊猫厨神","List_newPT_sw_pc.jpg","sw_pc"],
                                           ["浴火凤凰","List_newPT_sw_fp.jpg","sw_fp"],
                                           ["闪电之神","List_newPT_sw_gol.jpg","sw_gol"],
                                           ["拉美西斯财富","List_newPT_sw_rf.jpg","sw_rf"],
                                           
                                           ["新年财富","List_newPT_sw_nyf.jpg","sw_nyf"],
                                           ["吉祥招财猫","List_newPT_sw_mf.jpg","sw_mf"],
                                           ["迎财神","List_newPT_sw_ycs.jpg","sw_ycs"],
                                           ["崛起的武士","List_newPT_sw_rs.jpg","sw_rs"],
                                           ["龙鲤传奇","List_newPT_sw_lodk.jpg","sw_lodk"],
                                           ["生财有道","List_newPT_sw_scyd.jpg","sw_scyd"],
                                           ["金龟发发发","List_newPT_sw_888t.jpg","sw_888t"],
                                           ["两心知","List_newPT_sw_h2h.jpg","sw_h2h"]]
    
    
    
    
    
    //MG游戏链接地址
    let MGGameAddrTest = "https://mobile22.gameassists.co.uk/mobilewebservices_40/casino/game/launch/GoldenTree/"
    let MGGameAddr = "https://mobile22.gameassists.co.uk/mobilewebservices_40/casino/game/launch/GoldenTree/"
    let navItem_MG0 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113]
    //    let navItem_MG0: Array<Int> = [0,1,2,3,4,5,6,7,8,9,10]
    //MG老虎机游戏列表数据
    let MGDataSource: NSMutableArray = [//0
        ["宝石之轮","List_MG_ReelGems.jpg","reelGems"],
        ["反转马戏团","List_MG_TheTwistedCircus.jpg","theTwistedCircus"],
        ["百万动物园","List_MG_MegaMoolah.jpg","megaMoolah"],
        ["幸运锦鲤","List_MG_LuckyKoi.jpg","luckyKoi"],
        ["足球之巅","List_MG_FootballStar.jpg","footballStar"],
        ["冰上曲棍球","List_MG_BreakAway.jpg","breakAway"],
        ["阿瓦隆","List_MG_Avalon.jpg","avalon"],
        ["阿拉斯加垂钓","List_MG_AlaskanFishing.jpg","alaskanFishing"],
        ["森林之王","List_MG_BigKahuna.jpg","bigKahuna"],
        ["青龙出海","List_MG_EmperorOfTheSea.jpg","emperorOfTheSea"],
        //10
        ["水果vs糖果","List_MG_FruitVSCandy.jpg","fruitVSCandy"],//*****
        ["舞龙","List_MG_DragonDance.jpg","dragonDance"],
        ["海底派对","List_MG_FishParty.jpg","fishParty"],
        ["阿丽亚娜","List_MG_Ariana.jpg","ariana"],
        ["黄金时代","List_MG_GoldenEra.jpg","goldenEra"],
        ["大航海时代","List_MG_AgeofDiscovery.jpg","ageOfDiscovery"],
        ["现金之王","List_MG_KingsofCash.jpg","kingsOfCash"],//*****
        ["百万美人鱼","List_MG_MermaidsMillions.jpg","mermaidsMillions"],
        ["雷神","List_MG_Thunderstruck.jpg","thunderstruck"],
        ["雷神2","List_MG_Thunderstruck2.jpg","thunderstruckII"],
        //20
        ["幸运龙宝贝","List_MG_Dragonz.jpg","dragonz"],
        ["泰山传奇","List_MG_Tarzan.jpg","tarzan"],
        ["古墓奇兵","List_MG_TombRaider.jpg","tombRaider"],
        ["玛雅公主","List_MG_MayanPrincess.jpg","mayanPrincess"],
        ["快乐假日","List_MG_HappyHolidays.jpg","happyHolidays"],
        ["终极杀手","List_MG_Hitman.jpg","hitman"],
        ["轩辕帝传","List_MG_TheYellowEmperor.jpg","huangdiTheYellowEmperor"],
        ["比基尼派对","List_MG_BikiniParty.jpg","bikiniParty"],
        ["花粉之国","List_MG_PollenParty.jpg","pollenParty"],
        ["淑女派对","List_MG_LadiesNite.jpg","ladiesNite"],
        //30
        ["尼罗河宝藏","List_MG_TreasureNile.jpg","treasureNile"],
        ["侠盗猎车手","List_MG_5ReelDrive.jpg","5ReelDrive"],
        ["冒险丛林","List_MG_AdventurePalace.jpg","adventurePalace"],
        ["城市猎人","List_MG_AgentJaneBlonde.jpg","agentJaneBlonde"],
        ["马戏团","List_MG_BigTop.jpg","bigTop"],
        ["银行抢匪2","List_MG_BreakDaBankAgain.jpg","breakDaBankAgain"],
        ["狂欢节","List_MG_Carnaval.jpg","carnaval"],
        ["网球冠军","List_MG_CentreCourt.jpg","centreCourt"],
        ["加德满都","List_MG_Kathmandu.jpg","kathmandu"],
        ["派对岛屿","List_MG_PartyIsland.jpg","partyIsland"],
        //40
        ["雷霆风暴","List_MG_ReelThunder.jpg","reelThunder"],
        ["暗恋","List_MG_SecretAdmirer.jpg","secretAdmirer"],
        ["春假时光","List_MG_SpringBreak.jpg","springBreak"],
        ["暑假时光","List_MG_Summertime.jpg","summertime"],
        ["狐狸爵士","List_MG_TallyHo.jpg","tallyHo"],
        ["宝藏宫殿","List_MG_TreasurePalace.jpg","treasurePalace"],
        ["猫头鹰乐园","List_MG_WhataHoot.jpg","whatAHoot"],
        ["银狼","List_MG_SilverFang.jpg","silverFang"],
        ["伴娘我最大","List_MG_Bridesmaids.jpg","bridesmaids"],
        ["白金俱乐部","List_MG_PurePlatinum.jpg","purePlatinum"],
        //50
        ["虎眼","List_MG_Tiger'sEye.jpg","tigersEye"],
        ["圣诞大餐","List_MG_DeckTheHalls.jpg","deckTheHalls"],
        ["疯狂帽匠","List_MG_MadHatters.jpg","madHatters"],
        ["星光之吻","List_MG_StarlightKiss.jpg","starlightKiss"],
        ["探险之旅","List_MG_TheGrandJourney.jpg","theGrandJourney"],//*****
        ["美式酒吧","List_MG_Bars&Stripes.jpg","barsNStripes"],
        ["沙滩女孩","List_MG_BeachBabes.jpg","beachBabes"],//*****
        ["疾风老鹰","List_MG_Eagle'sWings.jpg","eaglesWings"],
        ["哈维斯的晚餐","List_MG_Harveys.jpg","harveys"],
        ["上流社会","List_MG_HighSociety.jpg","highSociety"],
        //60
        ["伊西斯","List_MG_Isis.jpg","isis"],
        ["幸运嘻哈","List_MG_Loaded.jpg","loaded"],
        ["好多怪兽","List_MG_SoManyMonsters.jpg","soManyMonsters"],
        ["好多糖果","List_MG_SoMuchCandy.jpg","soMuchCandy"],
        ["好多寿司","List_MG_SomuchSushi.jpg","soMuchSushi"],//*****
        ["纯银","List_MG_SterlingSilver.jpg","sterlingSilver"],
        ["增强马力","List_MG_SupeitUp.jpg","supeItUp"],//*****
        ["必胜","List_MG_SureWin.jpg","sureWin"],
        ["亚洲风情","List_MG_AsianBeauty.jpg","asianBeauty"],
        ["篮球巨星","List_MG_BasketballStar.jpg","basketballStar"],
        //70
        ["燃烧的慾望","List_MG_BurningDesire.jpg","burningDesire"],
        ["酷派狼人","List_MG_CoolWolf.jpg","coolWolf"],
        ["板球明星","List_MG_CricketStar.jpg","cricketStar"],
        ["舞龙","List_MG_DragonDance.jpg","dragonDance"],
        ["侏罗纪公园","List_MG_JurassicPark.jpg","jurassicPark"],
        ["神秘的梦","List_MG_MysticDreams.jpg","mysticDreams"],
        ["橄榄球明星","List_MG_RugbyStar.jpg","rugbyStar"],
        ["野生熊貓","List_MG_UntamedGiantPanda.jpg","untamedGiantPanda"],
        ["哈囉巴黎","List_MG_Voila.jpg","voila"],//*****
        ["摇滚怪兽","List_MG_BoogieMonsters.jpg","boogieMonsters"],
        //80
        ["现金威乐","List_MG_Cashville.jpg","cashville"],
        ["万圣节派对","List_MG_Halloweenies.jpg","halloweenies"],
        ["液态黄金","List_MG_LiquidGold.jpg","liquidGold"],
        ["幸运妖精","List_MG_LuckyLeprechaun.jpg","luckyLeprechaun"],
        ["冰雪圣诞村","List_MG_SantaPaws.jpg","santaPaws"],
        ["泰坦帝国","List_MG_StashOfTheTitans.jpg","stashOfTheTitans"],//*****
        ["丛林快讯","List_MG_BushTelegraph.jpg","bushTelegraph"],
        ["乔治与柏志","List_MG_RhymingReelsGeorgiePorgie.jpg","rhymingReelsGeorgiePorgie"],
        ["瑞维拉财宝","List_MG_RivieraRiches.jpg","rivieraRiches"],
        ["昆虫派对","List_MG_Cashapillar.jpg","cashapillar"],
        //90
        ["狮子的骄傲","List_MG_Lion'sPride.jpg","lionsPride"],
        ["暑假","List_MG_SummerHoliday.jpg","summerHoliday"],//*****
        ["银行抢匪","List_MG_BreakDaBank.jpg","breakDaBank"],
        ["慵懒土豆","List_MG_CouchPotato.jpg","couchPotato"],
        ["K歌乐韵","List_MG_KaraokeParty.jpg","karaokeParty"],
        ["丛林吉姆黄金国​","List_MG_JungleJim-ElDorado.jpg","jungleJimElDorado"],
        ["富裕人生","List_MG_LifeOfRiches.jpg","lifeOfRiches"],
        ["秘密爱慕者","List_MG_SecretRomance.jpg","secretRomance"],
        ["运财酷儿","List_MG_CoolBuck5Reel.jpg","coolBuck5Reel"],
        ["梦果子乐园","List_MG_CandyDreams.jpg","candyDreams"],
        //100
        ["金库甜心","List_MG_FortuneGirl.jpg","fortuneGirl"],
        ["美丽骷髅","List_MG_BeautifulBones.jpg","beautifulBones"],
        ["侏罗纪世界","List_MG_JurassicWorld.jpg","jurassicWorld"],
        ["金牌大西洋城21点","List_MG_AtlanticCityBlackjackGold.jpg","atlanticCityBlackjackGold"],//*****
        ["黄金经典21点","List_MG_ClassicBlackjackGold.jpg","classicBlackjackGold"],
        ["金牌欧洲21点","List_MG_EuropeanBlackjacGold.jpg","europeanBlackjacGold"],
        ["金牌拉斯维加斯市中心","List_MG_VegasDowntownBlackjackGold.jpg","vegasDowntownBlackjackGold"],
        ["黄金拉斯维加斯大道","List_MG_VegasStripBlackjackGold.jpg","vegasStripBlackjackGold"],
        ["A及8牌","List_MG_AcesAndEights.jpg","acesAndEights"],//*****
        ["A及花牌","List_MG_AcesAndFaces.jpg","acesAndFaces"],//*****
        //110
        ["超级百搭二王","List_MG_BonusDeucesWild.jpg","bonusDeucesWild"],//*****
        ["百搭二王","List_MG_DeucesWild.jpg","deucesWild"],//*****
        ["翻倍红利扑克","List_MG_DoubleDoubleBonus.jpg","doubleDoubleBonus"],//*****
        ["对J高手5PK","List_MG_JacksOrBetter.jpg","jacksOrBetter"]]//*****
        //114
    
    // ["黄金经典21点","List_MG_ClassicBlackjackGold.jpg",""],
    
    /*
     无法游戏：
     ["美式酒吧","List_MG_Bars&Stripes.jpg","bars&Stripes"],
     ["侏儸纪公园","List_MG_JurassicPark.jpg","jurassicpark"],
     ["金牌欧洲21点","List_MG_EuropeanBlackjacGold.jpg","europeanBlackjacGold"],
     */
    
    //SG游戏链接地址
    let SGGameAddrTest = "http://api.egame.staging.sgplay.net/futu/auth/?language=zh_CN&mobile=true"
    let SGGameAddr = "http://lobby.bigmoose88.com/futu/auth/?language=zh_CN&mobile=true"
    let navItem_SG0 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81]
   
    //SG老虎机游戏列表数据
    let SGDataSource: NSMutableArray = [//0
        ["天通雷神","List_SG_ZEUS.jpg","S-ZE01"],
        ["海龙王","List_SG_SeaEmperor.jpg","S-NT01"],
        ["虎大天王","List_SG_TigerWarrior.jpg","S-TW01"],
        ["新霸天下","List_SG_FistofGold.jpg","S-FG01"],
        ["森林之王","List_SG_Tarzan.jpg","S-TZ01"],
        ["上海 00发","List_SG_ShangHai008.jpg","S-SH01"],
        ["潘精灵","List_SG_PanFairy.jpg","S-PP01"],
        ["齐天大胜","List_SG_GoldenMonkey.jpg","S-FM02"],
        ["初恋","List_SG_FirstLove.jpg","S-FL02 "],
        ["大明帝国","List_SG_MingDynasty.jpg","S-DM01"],
        ["汪旺财","List_SG_WowProsperity.jpg","S-WP02"],
        ["旺旺公主","List_SG_PrincessWang.jpg","S-PW02"],
        ["斧头帮","List_SG_GangsterAxe.jpg","S-GA01"],
        ["发发发2","List_SG_FaFaFa2.jpg","S-LY02"],
        
        ["猴爷到","List_SG_HoyeahMonkey.jpg","S-HY01"],
        ["金鸡","List_SG_GoldenChicken.jpg","S-GC03"],
        ["金龙赐福 SA","List_SG_DragonGoldSA.jpg","S-DG04"],
        ["发大财 SA","List_SG_BigProsperitySA.jpg","S-FC03"],
        ["五福门 SA","List_SG_5FortuneSA.jpg","S-WM03"],
        ["新霸天下","List_SG_FistofGold.jpg","S-FG01"],
        ["虎大天王","List_SG_TigerWarrior.jpg","S-TW01"],
        ["海龙王","List_SG_SeaEmperor.jpg","S-NT01"],
        ["天通雷神","List_SG_ZEUS.jpg","S-ZE01"],
        ["吉星 SA","List_SG_GreatStarsSA.jpg","S-GS04"],
        //10
        ["旺财 SA","List_SG_WongChoySA.jpg","S-WC03"],
        ["狮心王SA","List_SG_LionHeartSA.jpg","S-LH03"],
        ["斩五门SA","List_SG_EmperorGateSA.jpg","S-EG03"],
        ["斯巴达SA","List_SG_SpartanSA.jpg","S-SP03"],
        ["将军令SA","List_SG_ShougenSA.jpg","S-SG04"],
        ["狮子王SA","List_SG_LionEmperorSA.jpg","S-LE03"],
        ["雪冰世界SA","List_SG_IcelandSA.jpg","S-IL03"],
        ["印度神话SA","List_SG_IndianMythSA.jpg","S-IM03 "],
        ["风生水起","List_SG_LuckyFengShui.jpg","S-LF01"],
        ["海盗霸王","List_SG_PirateKing.jpg","S-PK01"],
        //20
        ["极速王者","List_SG_HighwayFortune.jpg","S-HF01"],
        ["冠军高尔夫","List_SG_GolfChampion.jpg","S-GP02"],
        ["潘金莲 特别版","List_SG_GoldenLotusSE.jpg","S-GL02"],
        ["新法老宝藏","List_SG_KingPharaoh.jpg","S-PH02"],
        ["一路发发","List_SG_168Fortunes.jpg","S-FO01"],
        ["宝袋精灵","List_SG_PocketMonGo.jpg","S-PO01"],
        ["财神宝宝","List_SG_BabyCaiShen.jpg","S-BC01"],
        ["美人鱼","List_SG_Mermaid.jpg","S-MR01"],
        ["旺宝","List_SG_WongPo.jpg","S-WP01"],
        ["新狮子王","List_SG_AdventureLionEmperor.jpg","S-LE02"],
        //30
        ["新雪冰世界","List_SG_IcelandSA.jpg","S-IL02"],
        ["新印度神话","List_SG_AdventureIndianMyth.jpg","S-IM02 "],
        ["疯狂足球","List_SG_SoccerMania.jpg","S-SM01"],
        ["运财锂鱼","List_SG_LuckyKoi.jpg","S-LK01"],
        ["厨神","List_SG_GodKitchen.jpg","S-GO01 "],
        ["青龙白虎","List_SG_DoubleFortune.jpg","S-DF01"],
        ["阿里巴巴","List_SG_Alibaba.jpg","S-AL01"],
        ["五龙吐珠","List_SG_5FortuneDragon.jpg","S-FD01"],
        ["财神888","List_SG_CaiShen888.jpg","S-CS01"],
        ["太空神猴","List_SG_SpaceMonkey.jpg","S-SM02"],
        //40
        ["发发发","List_SG_Fafafa.jpg","S-LY01"],
        ["森林狂欢季","List_SG_DrunkenJungle.jpg","S-CM01"],
        ["幸运坦克","List_SG_LuckyTank.jpg","S-HL01"],
        ["新金龙赐福","List_SG_NewDragonGold.jpg","S-DG03"],
        ["新发大财","List_SG_NewBigProsperity.jpg","S-FC02"],
        ["新五福门","List_SG_New5Fortune.jpg","S-WM02"],
        ["新吉星","List_SG_NewGreatStars.jpg","S-GS03"],
        ["新旺财","List_SG_NewWongChoy.jpg","S-WC02"],
        ["新狮心王","List_SG_NewLionHeart.jpg","S-LH02"],
        ["新斩五门","List_SG_NewEmperorGate.jpg","S-EG02"],
        //50
        ["新斯巴达","List_SG_NewSpartan.jpg","S-SP02"],
        ["新将军令","List_SG_NewShougen.jpg","S-SG03"],
        ["花木兰","List_SG_HuaMulan.jpg","S-PT01"],
        ["如鱼得水","List_SG_AquaCash.jpg","S-GG01"],
        ["新中华之最","List_SG_NewGreatChina.jpg","S-GC02"],
        ["新日本福气","List_SG_NewJapanFortune.jpg","S-JF02"],
        ["新冒险火岛","List_SG_NewLavaIsland.jpg","S-LI02"],
        ["新泰国神游","List_SG_NewAmazingThailand.jpg","S-AT02"],
        ["熊之蜜","List_SG_HoneyHunter.jpg","S-HH01"],
        ["天降财神","List_SG_LuckyCaiShen.jpg","S-LC01"],
        //60
        ["野生动物园","List_SG_SafariKing.jpg","S-SK01"],
        ["圣诞大礼","List_SG_SantaGifts.jpg","S-SG02"],
        ["金狮拜年","List_SG_FestiveLion.jpg","S-BB01"],
        ["财源广进","List_SG_CaiYuanGuangJin.jpg","S-CY01"],
        ["超吉猫","List_SG_LuckyMeow.jpg","S-LM01"],
        ["至尊厨师","List_SG_MasterChef.jpg","S-CC01"],
        ["爸爸飞那儿","List_SG_Daddy'sVacationf.jpg","S-DV01"],
        ["铁路王","List_SG_RailwayKing.jpg","S-RK01"],
        ["大福小福","List_SG_DaFuXiaoFu.jpg","S-DX01"],
        ["马上赢","List_SG_LuckyStrike.jpg","S-LS01"],
        //70
        ["新中国好歌声","List_SG_NewTheSong.jpg","S-TS02"],
        ["新神錘魔咒","List_SG_NewMagicHammer.jpg","S-MH02"],
        ["新父女战殭屍","List_SG_NewFather&Zombie.jpg","S-FZ02"],
        ["新大脚先生","List_SG_NewBigFoot.jpg","S-BF02"],
        ["新下水道小魔兽","List_SG_NewMonsterTunnel.jpg","S-MP02"],
        ["新魔幻宝石","List_SG_NewRisingGems.jpg","S-RG02"],
        ["新石器时代","List_SG_NewSpinStone.jpg","S-SA02"],
        ["新金靴世界杯","List_SG_NewWorldCupGoldenBoot.jpg","S-FB02"],
        ["乐天堂","List_SG_TheParadise.jpg","S-TP01"],
        ["杰克海盗","List_SG_JackThePirates.jpg","S-JT01"],
        //80
        ["黄金黥鱼","List_SG_GoldenWhale.jpg","S-GW01"],
        ["霹雳神猴","List_SG_MonkeyThunderBolt.jpg","A-MT02"]]
        //82
    
    /*
     ["新雪冰世界","List_SG_AdventureIceland","S-IL02"],
     ["霹雳神猴","List_SG_MonkeyThunderBolt","A-MT02"]
     */
    
    
    
    
    
    //PNG游戏链接地址
    let PNGGameAddrTest = "https://bsistage.playngonetwork.com/casino/PlayMobile?div=pngCasinoGame&lang=zh_CN&pid=295&practice=100%25&width=100%25&height=1"
    let PNGGameAddr = "https://bsicw.playngonetwork.com/casino/PlayMobile?pid=295&lang=zh_CN&practice=0"
    let navItem_PNG0 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90]
    //PNG老虎机游戏列表数据
    let PNGDataSource: NSMutableArray = [//0
        ["五彩宝石","List_PNG_GEMiX.jpg","100286"],
        ["火焰小丑","List_PNG_FireJoker.jpg","100307"],
        ["维京人世界","List_PNG_VikingRunecraft.jpg","100319"],
        ["夏日庆典","List_PNG_Matsuri.jpg","100320"],
        ["七宗罪","List_PNG_7Sins.jpg","100321"],
        ["黄金之帆","List_PNG_SailsofGold.jpg","100311"],
        ["金色商队","List_PNG_GoldenCaravan.jpg","100312"],
        ["节庆假日","List_PNG_HolidaySeason.jpg","100327"],
        ["太阳神的财富","List_PNG_RichesofRA.jpg","100237"],
        ["龙船","List_PNG_DragonShip.jpg","100238"],
//        ["雨果巨魔","List_PNG_Hugo.jpg","100322"],
        //10
        ["珍珠湖","List_PNG_PearlLagoon.jpg","100241"],
        ["印度珍珠","List_PNG_PearlsofIndia.jpg","100282"],
        ["神秘小丑","List_PNG_MysteryJoker.jpg","100283"],
        ["中国新年","List_PNG_ChineseNewYear.jpg","100277"],
        ["黄金传奇","List_PNG_GoldenLegend.jpg","100290"],
        ["酷炫一族","List_PNG_Pimped.jpg","100291"],
        ["旋转派对","List_PNG_SpinParty.jpg","100292"],
        ["复活节彩蛋","List_PNG_EasterEggs.jpg","100293"],
        ["万能西瓜","List_PNG_WildMelon.jpg","100004"],
        ["幸运钻石","List_PNG_LuckyDiamonds.jpg","100005"],
        //20
        ["海盗旗帜","List_PNG_JollyRoger.jpg","100040"],
        ["水果财富","List_PNG_FruitBonanza.jpg","100043"],
        ["黑桃A","List_PNG_AceofSpades.jpg","100099"],
        ["财富铃铛","List_PNG_BellofFortune.jpg","100105"],
        ["极速现金","List_PNG_SpeedCash.jpg","100106"],
        ["礼品店","List_PNG_GiftShop.jpg","100107"],
        ["黄金球门","List_PNG_GoldenGoal.jpg","100108"],
        ["占卜师","List_PNG_FortuneTeller.jpg","100196"],
        ["非洲掠影","List_PNG_PhotoSafari.jpg","100197"],
        ["太空竞赛","List_PNG_SpaceRace.jpg","100198"],
        //30
        ["5x魔术","List_PNG_5xMagic.jpg","100199"],
        ["爱尔兰黄金","List_PNG_IrishGold.jpg","100200"],
        ["魔法草原","List_PNG_EnchantedMeadow.jpg","100225"],
        ["珠宝盒","List_PNG_JewelBox.jpg","100242"],
        ["阿兹特克人像","List_PNG_AztecIdols.jpg","100243"],
        ["神话","List_PNG_Myth.jpg","100245"],
        ["黄金奖杯2","List_PNG_GoldTrophy2.jpg","100246"],
        ["狂野血液","List_PNG_WildBlood.jpg","100250"],
        ["矮精灵埃及之旅","List_PNG_LeprechaungoesEgypt.jpg","100251"],
        ["忍者水果","List_PNG_NinjaFruits.jpg","100253"],
        //40
        ["巨魔猎人","List_PNG_TrollHunters.jpg","100254"],
        ["财富崛起","List_PNG_RagetoRiches.jpg","100257"],
        ["魔法水晶","List_PNG_EnchantedCrystals.jpg","100259"],
        ["能量小精灵","List_PNG_Energoonz.jpg","100262"],
        ["财富淑女","List_PNG_LadyofFortune.jpg","100278"],
        ["疯狂奶牛","List_PNG_CrazyCows.jpg","100284"],
        ["黄金入场券","List_PNG_GoldenTicket.jpg","100285"],
        ["高塔任务","List_PNG_TowerQuest.jpg","100287"],
        ["欢乐圣诞节","List_PNG_MerryXmas.jpg","100288"],
        ["北部荒野","List_PNG_WildNorth.jpg","100294"],
        //50
        ["超级翻转","List_PNG_SuperFlip.jpg","100295"],
        ["克拉肯的眼睛","List_PNG_EyeoftheKraken.jpg","100297"],
        ["皇室化妆舞会","List_PNG_RoyalMasquerade.jpg","100298"],
        ["天际战神","List_PNG_CloudQuest.jpg","100300"],
        ["宝石巫师","List_PNG_WizardofGems.jpg","100302"],
        ["冷酷亡灵","List_PNG_GrimMuerto.jpg","100303"],
        ["桑巴嘉年华","List_PNG_SambaCarnival.jpg","100304"],
        ["欢乐万圣节","List_PNG_HappyHalloween.jpg","100305"],
        ["圣诞小丑","List_PNG_Xmasoker.jpg","100309"],
        ["亡灵书","List_PNG_BookofDead.jpg","100310"],
        //60
        ["淘气小公主","List_PNG_PrissyPrincess.jpg","100325"],
        ["翡翠魔术师","List_PNG_JadeMagician.jpg","100326"],
        ["水果 多多 81","List_PNG_MULTIFRUIT81.jpg","100330"],
        ["阿斯德克战士公主","List_PNG_AztecWarriorPrincess.jpg","100332"],
        ["甜蜜 27","List_PNG_Sweet27.jpg","100355"],
        ["迷你百家乐","List_PNG_MiniBaccarat.jpg","100011"],
        ["欧洲轮盘","List_PNG_EuropeanRoulette.jpg","100031"],
        ["比大小","List_PNG_BeatMe.jpg","100034"],
        ["赌场桩牌扑克 ","List_PNG_CasinoStudPoker.jpg","100035"],
        ["多手21点","List_PNG_BlackJackMH.jpg","100052"],
        //70
        ["欧洲21点","List_PNG_EuropeanBlackJackMH.jpg","100053"],
        ["双开式21点","List_PNG_DoubleExposureBlackJackMH.jpg","100054"],
        ["单副牌21点","List_PNG_Single eckBlackJackMH.jpg","100055"],
        ["赌场Hold’em","List_PNG_CasinoHold'em.jpg","100057"],
        ["牌九扑克","List_PNG_PaiGowPoker.jpg","100058"],
        ["刮刮乐","List_PNG_ScratchAhoy.jpg","100093"],
        ["一杆进洞","List_PNG_Holeinone.jpg","100094"],
        ["三輪大小","List_PNG_TripleChanceHiLo.jpg","100235"],
        ["杰克高手","List_PNG_JacksorBetterMH.jpg","100269"],
        ["德塞斯野生","List_PNG_DeucesWildMH.jpg","100270"],
        //80
        ["小丑扑克","List_PNG_JokerPokerMH.jpg","100271"],
        ["国王高手","List_PNG_KingsorBetterMH.jpg","100272"],
        ["牌十高手","List_PNG_TensorBetterMH.jpg","100273"],
        ["双倍奖金","List_PNG_DoubleBonusMH.jpg","100274"],
        ["德塞斯小丑","List_PNG_Deuces&JokerMH.jpg","100275"],
        ["累积奖金扑克","List_PNG_JackpotPoker.jpg","100276"],
        ["飞翔小猪","List_PNG_FlyingPigs.jpg","100316"],
        ["虫虫派对","List_PNG_BugsParty.jpg","100317"],
        ["财运之轮","List_PNG_MoneyWheel.jpg","100318"],
        ["超级旋转","List_PNG_SuperWheel.jpg","100324"],
        //90
        ["基諾快乐彩","List_PNG_Keno.jpg","100239"]]
        //91
    //["雨果巨魔","List_PNG_Hugo.jpg","100322"],
    
    //HB游戏链接地址
    let HBGameAddrTest = "https://app-test.insvr.com/play?brandid=9b8bc342-c053-e711-80dd-000d3a802d1d&mode=real&locale=CNY&language=Zh-cn&"
    let HBGameAddr = "https://app-a.insvr.com/play?brandid=355cac7f-cb5f-e711-80c4-000d3a805b30&mode=real&locale=zh-CN"
    let navItem_HB0 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62]
    //HB老虎机游戏列表数据
    let HBDataSource: NSMutableArray = [//0
        ["12生肖","List_HB_SG12Zodiacs.jpg","SG12Zodiacs"],
        ["三剑客","List_HB_SGAllForOne.jpg","SGAllForOne"],
        ["神秘元素","List_HB_SGArcaneElements.jpg","SGArcaneElements"],
        ["北极奇迹","List_HB_SGArcticWonders.jpg","SGArcticWonders"],
        ["亚兹特兰金","List_HB_SGAzlandsGold.jpg","SGAzlandsGold"],
        ["农场现金","List_HB_SGBarnstormerBucks.jpg","SGBarnstormerBucks"],
        ["比基尼岛","List_HB_SGBikiniIsland.jpg","SGBikiniIsland"],
        ["炸弹追击","List_HB_SGBombsAway.jpg","SGBombsAway"],
        ["昆虫宝","List_HB_SGBuggyBonus.jpg","SGBuggyBonus"],
        ["现金嘉年华","List_HB_SGCarnivalCash.jpg","SGCarnivalCash"],
        //10
        ["金钱礁","List_HB_SGCashReef.jpg","SGCashReef"],
        ["恐龙现金","List_HB_SGCashosaurus.jpg","SGCashosaurus"],
        ["狼贼夺宝 ","List_HB_SGCoyoteCrash.jpg","SGCoyoteCrash"],
        ["舞厅技巧","List_HB_SGDiscoFunk.jpg","SGDiscoFunk"],
        ["好感医生","List_HB_SGDrFeelgood.jpg","SGDrFeelgood"],
        ["龙之城堡","List_HB_SGTheDragonCastle.jpg","SGTheDragonCastle"],
        ["龙之城堡","List_HB_SGDragonsRealm.jpg","SGDragonsRealm"],
        ["龙之宝座","List_HB_SGDragonsThrone.jpg","SGDragonsThrone"],
        ["发财神","List_HB_SGFaCaiShen.jpg","SGFaCaiShen"],
        ["凤凰","List_HB_SGFenghuang.jpg","SGFenghuang"],
        //20
        ["公鸡王","List_HB_SGFireRooster.jpg","SGFireRooster"],
        ["高飞","List_HB_SGFlyingHigh.jpg","SGFlyingHigh"],
        ["边境之福","List_HB_SGFrontierFortunes.jpg","SGFrontierFortunes"],
        ["银河大战","List_HB_SGGalacticCash.jpg","SGGalacticCash"],
        ["黑手党","List_HB_SGGangsters.jpg","SGGangsters"],
        ["淘金疯狂 ","List_HB_SGGoldRush.jpg","SGGoldRush"],
        ["金麒麟 ","List_HB_SGGoldenUnicorn.jpg","SGGoldenUnicorn"],
        ["逃跑的葡萄","List_HB_SGGrapeEscape.jpg","SGGrapeEscape"],
        ["鬼屋","List_HB_SGHauntedHouse.jpg","SGHauntedHouse"],
        ["印第安追梦","List_HB_SGIndianCashCatcher.jpg","SGIndianCashCatcher"],
        //30
        ["惊喜秀","List_HB_SGJugglenaut.jpg","SGJugglenaut"],
        ["丛林怒吼","List_HB_SGJungleRumble.jpg","SGJungleRumble"],
        ["凯恩地狱","List_HB_SGKanesInferno.jpg","SGKanesInferno"],
        ["图坦卡蒙之墓","List_HB_SGKingTutsTomb.jpg","SGKingTutsTomb"],
        ["小青钱","List_HB_SGLittleGreenMoney.jpg","SGLittleGreenMoney"],
        ["怪物现金","List_HB_SGMonsterMashCash.jpg","SGMonsterMashCash"],
        ["珠光宝气","List_HB_SGMrBling.jpg","SGMrBling"],
        ["金钱木乃伊 ","List_HB_SGMummyMoney.jpg","SGMummyMoney"],
        ["神秘宝藏 ","List_HB_SGMysticFortune.jpg","SGMysticFortune"],
        ["海洋之音","List_HB_SGOceansCall.jpg","SGOceansCall"],
        //40
        ["宠爱我","List_HB_SGPamperMe.jpg","SGPamperMe"],
        ["台球高手","List_HB_SGPoolShark.jpg","SGPoolShark"],
        ["亲吻王子","List_HB_SGPuckerUpPrince.jpg","SGPuckerUpPrince"],
        ["女王之女王 II","List_HB_SGQueenOfQueensTwo.jpg","SGQueenOfQueens243"],//*****
        ["女王之女王","List_HB_SGQueenOfQueens.jpg","SGQueenOfQueens1024"],//*****
        ["牛仔骑马","List_HB_SGRideEmCowboy.jpg","SGRideEmCowboy"],//*****
        ["罗马帝国","List_HB_SGRomanEmpire.jpg","SGRomanEmpire"],
        ["触电的小鸟","List_HB_SGRuffledUp.jpg","SGRuffledUp"],
        ["求救信号","List_HB_SGSOS.jpg","SGSOS"],
        ["少林宝藏","List_HB_SGShaolinFortunes243.jpg","SGShaolinFortunes243"],
        //50
        ["天空之际","List_HB_SGSkysTheLimit.jpg","SGSkysTheLimit"],//****
        ["空间宝藏","List_HB_SGSpaceFortune.jpg","SGSpaceFortune"],
        ["斯巴达","List_HB_SGSparta.jpg","SGSparta"],
        ["好球","List_HB_SGSuperStrike.jpg","SGSuperStrike"],
        ["超级龙卷风","List_HB_SGSuperTwister.jpg","SGSuperTwister"],
        ["重要人物","List_HB_SGTheBigDeal.jpg","SGTheBigDeal"],
        ["披萨塔","List_HB_SGTowerOfPizza.jpg","SGTowerOfPizza"],
        ["宝藏潜水员","List_HB_SGTreasureDiver.jpg","SGTreasureDiver"],
        ["维京掠宝","List_HB_SGVikingsPlunder.jpg","SGVikingsPlunder"],
        ["科学怪人","List_HB_SGWeirdScience.jpg","SGWeirdScience"],
        //60
        ["巫婆大财","List_HB_SGWickedWitch.jpg","SGWickedWitch"],
        ["宙斯","List_HB_SGZeus.jpg","SGZeus"],
        ["宙斯2","List_HB_SGZeus2.jpg","SGZeus2"]]
        //63
    
    
   
    
    //TTG游戏链接地址
    let TTGGameAddrTest = "http://ams-games.stg.ttms.co/casino/default/game/casino5.html?account=CNY&lang=zh-cn&deviceType=mobile&lsdid=futu&"
    let TTGGameAddr = "http://ams2-games.ttms.co/casino/default/game/casino5.html?account=CNY&lang=zh-cn&deviceType=mobile&lsdid=futu"
    let navItem_TTG0 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
    //TTG老虎机游戏列表数据
    let TTGDataSource: NSMutableArray = [//0
        ["炽热火山","List_TTG_1061.jpg","1061","HotVolcanoH5"],
        ["招财进宝","List_TTG_1060.jpg","1060","FortunePaysH5"],
        ["超级宝贝","List_TTG_1072.jpg","1072","SuperKids"],
        ["葫芦娃","List_TTG_1078.jpg","1078","Huluwa"],
        ["林克的传说","List_TTG_1049.jpg","1049","LegendOfLinkH5"],
        ["黑猫警长","List_TTG_1075.jpg","1075","DetectiveBlackCat"],
        ["捕蝇大赛","List_TTG_1052.jpg","1052","FrogsNFliesH5"],
        ["八仙过海","List_TTG_1042.jpg","1042","EightImmortals"],
        ["恭喜发财","List_TTG_1073.jpg","1073","GongXiFaCai"],
        ["金海豚","List_TTG_1055.jpg","1055","DolphinGoldH5 "],
        //10
        ["海龙王","List_TTG_1056.jpg","1056","DragonKingH5"],
        ["银狮奖","List_TTG_1057.jpg","1057","SilverLionH5"],
        ["猴年大吉","List_TTG_1054.jpg","1054","YearOfTheMonkeyH5"],
        ["火辣金砖","List_TTG_1053.jpg","1053","ChilliGoldH5"],
        ["疯狂的猴子","List_TTG_1051.jpg","1051","MadMonkeyH5"]]
        //15
    
    
    //BS游戏Token获取地址
    let BSTokenGetAddr = "Game/GetBetSoftToken"
    //BS游戏链接地址
    let BSGameAddr = "https://winwis-gp3.betsoftgaming.com/cwstartgamev2.do?bankId=1833&mode=real&lang=zh-cn&homeUrl=https://m.whf990abccom&cashierUrl=https://m.whf990abc.com"
    //所有游戏按钮游戏列表
    let navItem_BS0 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62]
    
    //3D老虎机按钮游戏列表
    let navItem_BS1 = [0,1,2,3,4,5,6,7,9,10,11,12,14,15,16,17,18,19,20,21,22,25,26,27,28,31,32,33,34,35,36,37,38,39,40,41,42,43,45,46,47,48,49,51,52,53,54,55,56,57,58,59,60,61,62]
    //经典老虎机按钮游戏列表
    let navItem_BS2 = [8,13]
    //桌面游戏按钮游戏列表
    let navItem_BS3 = [23,29,44,50]
    //电子扑克按钮游戏列表
    let navItem_BS4 = [24]
    //其他游戏按钮游戏列表
    let navItem_BS5 = [30]
    //3D老虎机的游戏列表数据
    let BSDataSource: NSMutableArray = [//0
        ["虎威","List_BS_game_788.jpg","788"],
        ["弹弹糖 2","List_BS_game_784.jpg","784"],
        ["尼罗河传说","List_BS_game_775.jpg","775"],
        ["踩踏","List_BS_game_771.jpg","771"],
        ["寻宝小丑","List_BS_game_767.jpg","767"],
        ["吸血僵尸","List_BS_game_763.jpg","763"],
        ["吉运来闪钻","List_BS_game_759.jpg","759"],
        ["疯狂战士","List_BS_game_755.jpg","755"],
        ["魔术商店","List_BS_game_751.jpg","751"],
        
        ["吸血僵尸","List_BS_xixue.jpg","763"],
        ["吉运来闪钻","List_BS_Jiyong.jpg","759"],
        ["魔术商店","List_BS_MagicStore.png","751"],
        ["垂钓者","List_BS_Angler.jpg","747"],
        ["发发姐妹","List_BS_FaFaTwins.jpg","692"],
        ["老虎机老爹","List_BS_Slotfather2.jpg","704"],
        ["Great 88","List_BS_great88-GameButton.jpg","700"],
        ["卡哇伊喵喵儿","List_BS_kawaii-GameButton.jpg","727"],
        ["罪恶之夜","List_BS_sincity-DemoButton.jpg","719"],
        ["劲爆辣椒","List_BS_game_227.jpg","225"],
        ["到达者","List_BS_game_226.jpg","226"],
        
        //8
        ["幸运七宝","List_BS_lucky-7.jpg","2"],
        ["通天大盗","List_BS_heist.jpg","180"],
        ["贪婪的妖精","List_BS_greedy-goblins.jpg","341"],
        ["公元前两百万年","List_BS_2-million-bc.jpg","224"],
        ["维京时代","List_BS_viking-age.jpg","228"],
        ["第七天堂","List_BS_7th-heaven.jpg","229"],
        ["真实与幻象","List_BS_true-illusions.jpg","236"],
        ["妈妈咪呀","List_BS_mamma-mia.jpg","238"],
        
        //16
        ["疯狂科学家","List_BS_madder-scientist.jpg","247"],
        ["迷失","List_BS_lost.jpg","248"],
        ["黑金帝国","List_BS_black-gold.jpg","256"],
        ["星夜迷案","List_BS_after-night-falls.jpg","295"],
        ["科帕酒店","List_BS_at-the-copa.jpg","300"],
        ["床下魅影","List_BS_under-the-bed.jpg","308"],
        ["火树银花","List_BS_boomanji.jpg","323"],
        ["加勒比扑克","List_BS_caribbean-poker.jpg","12"],
        
        //24
        ["疯狂局末","List_BS_deuces-wild-video-poker.jpg","29"],
        ["着魔","List_BS_enchanted.jpg","350"],
        ["巴黎之夜","List_BS_a-night-in-paris-jp.jpg","351"],
        ["真正的警长","List_BS_the-true-sheriff.jpg","384"],
        ["糖果之星","List_BS_sugar-pop.jpg","402"],
        ["二十一点大亨","List_BS_single-deck-blackjack.jpg","63"],
        ["挖金矿","List_BS_more-gold-diggin.jpg","444"],
        ["古怪机器","List_BS_curious-machine-plus.jpg","461"],
        
        //32
        ["大富豪","List_BS_tycoons-plus.jpg","471"],
        ["吉普赛玫瑰","List_BS_gypsy-rose.jpg","478"],
        ["挚爱宠物","List_BS_puppy-love-plus.jpg","482"],
        ["化身博士","List_BS_dr-jekyll-mr-hyde.jpg","500"],
        ["金星来客","List_BS_it-came-from-venus-jp-plus.jpg","504"],
        ["水果道","List_BS_fruit-zen.jpg","512"],
        ["木偶奇遇记","List_BS_pinocchio.jpg","520"],
        ["巨钻珍宝","List_BS_curious-machine-plus.jpg","534"],
        
        //40
        ["黑洞边界","List_BS_event-horizon.jpg","548"],
        ["奢华生活","List_BS_mega-glam-life.jpg","554"],
        ["赌城周末","List_BS_weekend-in-vegas.jpg","590"],
        ["宿醉之旅","List_BS_the-tipsy-tourist.jpg","597"],
        ["欧式轮盘","List_BS_european-roulette.jpg","79"],
        ["四季","List_BS_four-seasons.jpg","637"],
        ["科学怪人","List_BS_frankenslots-monster.jpg","647"],
        ["苯苯鸟","List_BS_birds.jpg","654"],
        
        //48
        ["三个愿望","List_BS_three-wishes.jpg","177"],
        ["巨钻珍宝","List_BS_mega-gems.jpg","534"],
        ["美式二十一点","List_BS_american-us-blackjack.jpg","195"],
        ["猎人山姆","List_BS_safari-sam.jpg","280"],
        ["角斗士","List_BS_gladiator.jpg","178"],
        ["维加斯先生","List_BS_mr-vegas.jpg","210"],
        ["巴巴里海岸","List_BS_barbary-coast.jpg","194"],
        ["奇趣房子","List_BS_house-of-fun.jpg","221"],
        
        //56
        ["魅力三叶者","List_BS_charms-and-clovers.jpg","691"],
        ["老虎机教父","List_BS_the-slotfather-jp.jpg","344"],
        ["天使与魔鬼","List_BS_good-girlbad-girl.jpg","426"],
        ["圣诞颂歌","List_BS_a-christmas-carol.jpg","619"],
        ["法师塔","List_BS_alkemors-tower.jpg","553"],
        ["鲁克的复仇","List_BS_rooks-revenge.jpg","277"],
        ["海底沉宝","List_BS_under-the-sea.jpg","259"]];
        //63
    
   
    
    
    //**************************************************************************
    //***********              上线游戏结束          *****************************
    //**************************************************************************
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //AV游戏Token获取地址
    let AVTokenGetAddr = "Game/GetGspotToken"
    //AV游戏链接地址
    let AVGameAddr = "http://gspotslots.bbtech.asia/UIS/connect?config=tokyo_ch_cloud&room=1855&lang=zh-cn"
    //所有游戏按钮游戏列表
    let navItem_AV0 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32]
    //性感1按钮游戏列表
    let navItem_AV1 = [9,13,21,31,32]
    //性感2按钮游戏列表
    let navItem_AV2 = [3,4,12,14]
    //性感3按钮游戏列表
    let navItem_AV3 = [11,17,19,20,23]
    //性感4按钮游戏列表
    let navItem_AV4 = [0,1,7,8]
    //性感5按钮游戏列表
    let navItem_AV5 = [2,16,24,25,26,29,30]
    //AV老虎机游戏列表数据
    let AVDataSource: NSMutableArray = [
        ["AYU-1","List_AV_GSPOT26.png","miracle_pg_ayu"],
        ["AYU-2","List_AV_GSPOT25.png","miracle_jq_ayu"],
        ["白夜凛音","List_AV_GSPOT46.png","cascade_byakuya_lin_ne"],
        ["惩罚指导","List_AV_GSPOT8.png","chobatsu"],
        ["大奶妹们运动会","List_AV_GSPOT9.png","classmatefcker"],
        ["硬弟来了","List_AV_GSPOT34.png","youwillbemoreandmorehard"],
        ["乳后4８","List_AV_GSPOT2.png","oppainoohjya48"],
        ["AV女优东凛1","List_AV_GSPOT23.png","rinazuma1"],
                                        //8
        ["AV女优东凛2","List_AV_GSPOT24.png","rinazuma2"],
        ["拥抱校园生活","List_AV_GSPOT7.png","hugyou"],
        ["巨乳妹渡假村","List_AV_GSPOT13.png","resortboin"],
        ["发情火箭炮","List_AV_GSPOT14.png","yokujtohbazooka"],
        ["黑暗圣经","List_AV_GSPOT10.png","bibleblack"],
        ["圣女的奉献","List_AV_GSPOT5.png","kuroinu"],
        ["姐妹花","List_AV_GSPOT11.png","mysisters"],
        ["扰交发情学园","List_AV_GSPOT99.png","yarimanenkoh"],
        //16
        ["夜勤病栋","List_AV_GSPOT56.png","cascade_yakinbyouto"],
        ["阴阳师","List_AV_GSPOT22.png","inuoshi"],
        ["麻将","List_AV_GSPOT50.png","cascade_mahjong"],
        ["女仆大作战","List_AV_GSPOT17.png","maidlesson"],
        ["女忍者咲夜","List_AV_GSPOT18.png","kunoichi_sakuya"],
        ["女神三姐妹","List_AV_GSPOT4.png","megachuu"],
        ["魔法少女","List_AV_GSPOT29.png","mahousyoujyo"],
        ["请强♥我","List_AV_GSPOT19.png","pleasmekujyosakura"],
        //24
        ["若槻贝美","List_AV_GSPOT35.png","wakatsuki"],
        ["若槻贝美-v2","List_AV_GSPOT36.png","wakatsukivr2"],
        ["若槻贝美-v3","List_AV_GSPOT37.png","wakatsukivr3"],
        ["少女X少女","List_AV_GSPOT21.png","girlxgirlxgirl"],
        ["圣女学园","List_AV_GSPOT3.png","seishohjyo"],
        ["偷窥的洞","List_AV_GSPOT53.png","cascade_nozokiana"],
        ["我的姐姐很色","List_AV_GSPOT33.png","dekakute"],
        ["我的小女友们","List_AV_GSPOT6.png","kanojyo3"],
        //32
        ["大奶妻妈咪故事","List_AV_GSPOT1.png","mamaboin"]]
    

    
    

    //PT游戏链接地址
    let PTGameAddr = ""
    let navItem_PT0 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72]
    //PT老虎机游戏列表数据
    let PTDataSource: NSMutableArray = [
        ["百家乐","List_PT_baccarat.jpg","ba"],
        ["性感甜心","List_PT_ano.jpg","ano"],
        ["多手21点","List_PT_bjs.jpg","mobbj"],
        ["转牌21点","List_PT_mobbj.jpg","bjs"],
        ["船长的宝藏","List_PT_mobbj.jpg","ct"],
        ["赌城扑克","List_PT_ingle-deck-blackjack.jpg","cheaa"],
        ["猫后","List_PT_single-deck-blackjack.jpg","catqc"],
        ["疯狂777","List_PT_hree-wishes.jpg","c7"],
        //8
        ["沙漠珍宝","List_PT_mobdt.jpg","mobdt"],
        ["埃斯梅拉达","List_PT_mobdt.jpg","esm"],
        ["欧式轮盘","List_PT_rofl.jpg","rofl"],
        ["神奇四侠","List_PT_ff.jpg","fnf"],
        ["野生亚马逊","List_PT_wild.jpg","ashamw"],
        ["北极宝藏","List_PT_archer.jpg","art"],
        ["Frankie Dettori's Magic Seven JP","List_PT_archer.jpg","fdtgj"],
        ["圆月财富","List_PT_archer.jpg","ashfmf"],
        //16
        ["时髦的水果","List_PT_at-the-copa.jpg","fnfrj"],
        ["角斗士累积奖池","List_PT_glrj.jpg","glrj"],
        ["黄金旅行","List_PT_gos.jpg","gos"],
        ["丛林深处","List_PT_at-the-copa.jpg","ashhotj"],
        ["冰上奔跑","List_PT_at-the-copa.jpg","ir"],
        ["钢铁侠2","List_PT_","ir2"],
        ["多手对J高手","List_PT_at-the-copa.jpg","jb_mh50"],
        //24
        ["钞票先生","List_PT_at-the-copa.jpg","mrcb"],
        ["众神之战","List_PT_at-the-copa.jpg","gtsbtg"],
        ["海滨嘉年华","List_PT_beach.jpg","bl"],
        ["奖金熊","List_PT_bonus.jpg","bob"],
        ["Cat In Vegas","List_PT_enchanted.jpg","fsc"],
        ["Cat Queen","List_PT_a-night-in-paris-jp.jpg","fsc"],
        ["樱之恋","List_PT_cherry.jpg","chl"],
        ["很多箱子","List_PT_sugar-pop.jpg","ashcpl"],
        //32
        ["年年有鱼","List_PT_dr-jekyll-mr-hyde.jpg","nian"],
        ["法老的秘密","List_PT_dr-jekyll-mr-hyde.jpg","pst"],
        ["21点刮刮乐","List_PT_","shmst"],
        ["银色子弹","List_PT_sib.jpg","ngm"],
        ["辛巴达黄金之旅","List_PT_bjp.jpg","ashsbd"],
        ["蜘蛛侠","List_PT_spidc.jpg","spidc"],
        ["幸运直击","List_PT_spidc.jpg","sol"],
        ["甜蜜派对","List_PT_","cnpr"],
        //40
        ["完美21点","List_PT_bjp.jpg","bjp"],
        ["复仇者联盟","List_PT_","avng"],
        ["绿巨人刮刮乐","List_PT_","hlk2"],
        ["恋爱博士","List_PT_dr-jekyll-mr-hyde.jpg","dlm"],
        ["惊喜复活节","List_PT_easter.jpg","eas"],
        ["每个人的大奖","List_PT_everybody.jpg","evj"],
        ["巴西桑巴","List_PT_samba.jpg","gtssmbr"],
        ["刮刀痕","List_PT_samurai.jpg","sis"],
        //48
        ["唐吉诃德的财富","List_PT_a-christmas-carol.jpg","donq"],
        ["足球嘉年华","List_PT_a-christmas-carol.jpg","gtsfc"],
        ["幸运5","List_PT_birds.jpg","frtf"],
        ["幻影骑手","List_PT_frankie.jpg","fdt"],
        ["钢铁侠3","List_PT_safari-sam.jpg","irm3"],
        ["金刚","List_PT_kong.jpg","kkg"],
        ["疯狂乐透","List_PT_lotto.jpg","lm"],
        ["玛丽莲·梦露","List_PT_marilyn.jpg","gtsmrln"],
        //56
        ["武隆","List_PT_spamalot.jpg","wlg"],
        ["豪华度假站","List_PT_spamalot.jpg","vcstd"],
        ["21点","List_PT_spamalot.jpg","spm"],
        ["白狮王","List_PT_spamalot.jpg","whk"],
        ["X战警","List_PT_xmen.jpg","xmn50"],
        ["月下美洲豹","List_PT_panther.jpg","pmn"],
        ["企鹅假期","List_PT_penguin.jpg","pgv"],
        ["巨额奖池","List_PT_house-of-fun.jpg","jpgt"],
        //64
        ["招财进宝","List_PT_zcjb.jpg","zcjb"],
        ["火枪手和女王的钻石","List_PT_diamond.jpg","tmqd"],
        ["艺妓故事","List_PT_geisha.jpg","ges"],
        ["深蓝冒险","List_PT_great.jpg","bib"],
        ["高速之王","List_PT_highway.jpg","hk"],
        ["爱尔兰运气","List_PT_irish.jpg","irl"],
        ["粉红豹","List_PT_pink.jpg","pnp"],
        ["超级富翁","List_PT_plenty.jpg","gtspor"]]
    
    
    //BS游戏Token获取地址
//    let AGTokenGetAddr = "Game/GetAGloginLink"
//    //AG游戏链接地址
//    let AGGameAddr = ""
//    
//    let navItem_AG0 = [0,1,2,3,4]
//    //AG老虎机游戏列表数据
//    let AGDataSource: NSMutableArray = [
//        ["AG真人视频1","List_BS_curious-machine-plus.jpg","ba"],
//        ["AG真人视频2","List_BS_curious-machine-plus.jpg","ba"],
//        ["AG真人视频3","List_BS_curious-machine-plus.jpg","ba"],
//        ["AG真人视频4","List_BS_curious-machine-plus.jpg","ba"],
//        ["AG真人视频5","List_BS_curious-machine-plus.jpg","ba"]]
    

    
   
    

    

   
    /*
     AV
     '/Game/GetGspotToken',
     src = "http://gspotslots.bbtech.asia/UIS/connect?config=tokyo_ch_cloud&room=1855&lang=zh-cn&token=" + ob.token_AV + "&gameconfig=" + gameId;
     
     
     BS
     '/Game/GetBetSoftToken'
     src = "https://winwis-gp3.betsoftgaming.com/cwstartgamev2.do?bankId=1833&mode=real&lang=zh-cn&token=" + ob.token_BS + "&gameId=" + gameId;
     
     TTG
     http://ams-games.stg.ttms.co/casino/default/game/casino5.html?playerHandle==100099590467505315438181213011075772&account=CNY&gameName=DragonBallReels&gameType=0&gameId=1040&lang=zh-cn&deviceType=web&lsdid=futu

     
     */
}


