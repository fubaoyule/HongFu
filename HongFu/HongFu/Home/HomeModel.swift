//
//  HomeModel.swift
//  FuTu
//
//  Created by Administrator1 on 21/11/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit


//tab bar height
let tabBarHeight:CGFloat = isPhone ? 49.5 : 54
//let tabBarHeightPad:CGFloat = 54
let navBarHeight:CGFloat = isPhone ? 44 : 36

//状态条背景图渐变色值
let statusBarColorTop = UIColor.gray
let statusBarColorBottom = UIColor.white
let statusBarAlpha:CGFloat = 0.6
let userDefaults = UserDefaults.standard
enum HomeTag:Int {
    case noticeScroll = 10,bannerScroll
    case totleAccountLabel = 20,accountBgImg
    
    case gameVeiwTag = 30, gameBtnTag
    case loginRegisterViewTag = 50, loginBtnTag, registerBtnTag,walletBtnTag, signInBtnTag,serviceBtnTag
    case giftBoxBtnTag = 60, treasureBoxBtnTag, redPacketBtnTag, lotteryBtnTag,treasureBoxConfirmBtnTag
    case emailRedbagShadowViewTag = 80, emailRedbagViewTag,emailRedbagConfirmBtnTag
}


class HomeModel: NSObject {
    
    //获取中心钱包余额地址
    let allAccountUrl = "Account"
    //充值地址
    let depositUrl = "FundTransfer/Deposit"

    
    //广告滚动视图的起始点
    //let scrollPoint = CGPoint(x: 0, y: (0.25 + 0.32) * deviceScreen.height + 30)
    let scrollPoint = CGPoint(x: 0, y: 0)

    //通知栏的字体颜色
    let noticeTextColer = UIColor.colorWithCustom(r: 255, g: 222, b: 193)
    //通知栏的字体大小
    let noticeTextFont: CGFloat = 12
    //通知栏的背景颜色
    let noticeBackColor = UIColor.colorWithCustom(r: 63, g: 38, b: 32)
    //通知滚动时间
    let noticeTimeInterval: CGFloat = 2
    //小黄条颜色
    let yellowLabelColor = UIColor.colorWithCustom(r: 255, g: 162, b: 0)
    
    //头部视图高度占屏比
    let titleViewHeight:CGFloat = 0.232
    //头部视图背景颜色
    let titleViewBackColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
    //头部按钮高度占屏比
    let titleBtnHeight:CGFloat = 0.217
    //头部按钮宽度占屏比
    let titleBtnWidth1:CGFloat = 0.3066
    let titleBtnWidth2:CGFloat = 0.3333
    //头部按钮圆角半径
    let titleBtnCorner:CGFloat = 4
    //头部按钮的背景色
    let titleBtnBackColor1 = UIColor.colorWithCustom(r: 255, g: 255, b: 255)
    let titleBtnBackColor2 = UIColor.colorWithCustom(r: 255, g: 255, b: 255)
    
    //头部按钮的阴影颜色
    let titleBtnShadeColor = UIColor.gray
    //头部按钮的图片
    let titleImageName: Array = ["home_title_recharge.png","home_title_dollar.png","home_title_withdraw.png"]
    //头部按钮图片的宽度占屏比
    let titleImageWidth: CGFloat = 0.184
    //头部按钮的名称
    //let titleTextName: Array = ["分享","中心钱包","砸金蛋"]
    //头部按钮的名称字体大小
    let titleTextFont:CGFloat = 12
    //头部按钮的名称字体大小
    let titleTextColor = UIColor.white
    
    
    //首页总金额字体的颜色
    let amountTextColor = UIColor.white
    //首页总金额字体的大小
    let amountTextFont: CGFloat = 16
    

    //'热门游戏'的高度比
    let gameTitleHeight:CGFloat = 0.052
    //'热门游戏'字体颜色
    let gameTitleColor = UIColor.colorWithCustom(r: 129, g: 129, b: 129)
    //'热门游戏'字体大小
    let gameTitleFont:CGFloat = 13
    
    //游戏名称字体大小
    let gameNameFont:CGFloat = 12
    //游戏名称字体颜色
    let gameNameColor = UIColor.colorWithCustom(r: 35, g: 35, b: 35)
    
    //分割线宽度
    let gameLineWidht:CGFloat = 0.5
    
    //每个游戏按钮之间的垂直距离
    let gameBtnDist_protrait:CGFloat = 2
    //每个游戏按钮之间的水平距离
    let gameBtnDist_landscap:CGFloat = 2
    
    //游戏视图的高度屏占比
    //let gameHeight: CGFloat = 0.39
    //游戏视图的背景色
    let gameBackColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
    
    //游戏视图的宽度屏占比
    let gameBtnImgWidth:CGFloat = 0.16
    //增加游戏需要修改
    //游戏按钮的图片
    let gameImg = ["home_game_newPT.png","home_game_MG.png", "home_game_SG.png", "home_game_PNG.png","home_game_HB.png", "home_game_TTG.png","home_game_bs.png",""]

    class func userInfoDeal(userInfo:AnyObject,success: @escaping (() -> ())) -> Void {
        
        tlPrint(message: "userInfoDeal - userInfo:\(userInfo)")
        let userInfoKey:[String] = ["AccountName","Balance","BirthDate","DayWithdrawCount","DayWithdrawMax","Email","Id","IsBankBound","IsBasicBound","IsEmailBound","IsPhoneBound","LastLogin","Mobile","QQ","Wechat","RealName","RegisterTime","Sex","UserLevel","VipLevel"]
        
        for i in 0 ..< userInfoKey.count {
            
            var value = userInfo.value(forKey: userInfoKey[i])
            //此接口的数据，存储在userdefaults的键名为“userInfo”加上收到的键名
            if value == nil || value is NSNull {
                userDefaults.setValue("", forKey: "userInfo\(userInfoKey[i])")
                continue
            }
            let savedValue = userDefaults.value(forKey: "userInfo\(userInfoKey[i])")
            if savedValue == nil || "\(String(describing: value))" != "\(String(describing: savedValue))" {
                if i == 1 {
                    value = retain2Decima(originString: "\(value!)")
                }
                userDefaults.setValue(value, forKey: "userInfo\(userInfoKey[i])")
            }
        }
        let notify = NSNotification.Name(rawValue: notificationName.HomeAccountValueModify.rawValue)
        NotificationCenter.default.post(name: notify, object: nil)
        success()

    }
    
    var bannerDataSource: [String]!
    func getHomeBannerInfo(success:@escaping(([String])->())) -> Void {
        
        futuNetworkRequest(type: .get, serializer: .http, url: "Content/home.txt", params: ["":""], success: { (response) in
            tlPrint(message: "respose:\(response)")
            let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
            let url = domain + "Content/home.txt"
            clearCacheWithURL(url: URL(string: url)!)
            self.homeBannerInfoDeal(info: response as AnyObject, success: { (homeBannerInfo) in
                tlPrint(message: "处理完毕 homeBannerInfo = \(String(describing: homeBannerInfo))")
                success(homeBannerInfo!)
            })
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
        })
    }
    
    var hotGameListDic:Array<Dictionary<String,Array<Int>>>!
    func homeBannerInfoDeal(info:AnyObject,success:@escaping(([String]?)->())) -> Void {
        tlPrint(message: "activityInfoDeal  info:\(info)")
        var homeBannerData:[String] = ["imgUrl"]
        var string = String(data: info as! Data, encoding: String.Encoding.utf8)
        tlPrint(message: "string0:\(String(describing: string))")
        if string == nil {
            userDefaults.setValue(nil, forKey: userDefaultsKeys.messageInfo.rawValue)
            self.bannerDataSource = nil
            success(nil)
            return
        }
        string = string!.replacingOccurrences(of: "\r\n", with: "")
        string = string!.replacingOccurrences(of: "\"{", with: "{")
        string = string!.replacingOccurrences(of: "}\"", with: "}")
        string = string!.replacingOccurrences(of: " ", with: "")
        tlPrint(message: "string:\(String(describing: string))")
        let activityDic = (string)?.objectFromJSONString() as! Dictionary<String, Any>
        tlPrint(message: "activitiDic:\(activityDic)")
        
        var imgURLArray = activityDic["homeList"] as! Array<Any>
        
//        if webApi != "http://api.toobet.com" {
//            imgURLArray = activityDic[isPhone ? "homeList" : "ipadList"] as! Array<Any>
//
//        }
        
        
        let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
        for i in 0 ..< imgURLArray.count {
            tlPrint(message: "activityArray[\(i)] = \(imgURLArray[i])")
            let imgURLValue = imgURLArray[i] as! Dictionary<String,Any>
            let imgUrl = domain+(imgURLValue["imgUrl"] as! String)
            tlPrint(message: "imgUrl:\(imgUrl)")
            homeBannerData.append(imgUrl )
        }
        homeBannerData.remove(at: 0)
        tlPrint(message: "homeBannerData:\(homeBannerData)")
        success(homeBannerData)
    }
    
    var gameBannerInfo:[[String:Any]]!
    func getGameBannerInfo(success:@escaping(([[String:Any]]!)->())) -> Void {
        
        futuNetworkRequest(type: .get, serializer: .http, url: "Content/gamePictures.txt", params: ["":""], success: { (response) in
            tlPrint(message: "respose:\(String(describing: response))")
            
            self.gameBannerInfoDeal(info: response as AnyObject, success: { (gameBannerInfo) in
                tlPrint(message: "处理完毕 gameBannerInfo = \(gameBannerInfo)")
                success(gameBannerInfo)
            })
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
        })
    }
    
    //增加游戏需要修改
    let gameKey = ["mg","sg","png","hb","ttg","bs"]
    func gameBannerInfoDeal(info:AnyObject,success:@escaping(([[String:Any]]!)->())) -> Void {
        tlPrint(message: "activityInfoDeal  info:\(info)")
        var gameBannerData:[[String:Any]] = [["imgUrl":"","type":""]]
        var string = String(data: info as! Data, encoding: String.Encoding.utf8)
        tlPrint(message: "string0:\(String(describing: string))")
        if string == nil {
            userDefaults.setValue(nil, forKey: userDefaultsKeys.messageInfo.rawValue)
            self.gameBannerInfo = nil
            success(nil)
            return
        }
        string = string!.replacingOccurrences(of: "\r\n", with: "")
        string = string!.replacingOccurrences(of: "\"{", with: "{")
        string = string!.replacingOccurrences(of: "}\"", with: "}")
        string = string!.replacingOccurrences(of: " ", with: "")
        tlPrint(message: "string:\(String(describing: string))")
        let gameBannerDic = (string)?.objectFromJSONString() as! Dictionary<String, Any>
        tlPrint(message: "activitiDic:\(gameBannerDic)")
        
        let gameBannerArray = gameBannerDic["gameList"] as! Array<Dictionary<String, Any>>
        for i in 0 ..< gameBannerArray.count {
            let imgUrl = gameBannerArray[i]
            gameBannerData.append(imgUrl)
        }
        tlPrint(message: "gameBannerData:\(gameBannerData)")
        
        let hotGameArray = gameBannerDic["hotGameList"] as! Array<Dictionary<String, Any>>
        tlPrint(message: "hotGameArray:\(hotGameArray)")
        for i in 0 ..< hotGameArray.count {
            let hotGameList = hotGameArray[i]
            gameBannerData.append(hotGameList)
        }
        
        gameBannerData.remove(at: 0)
        tlPrint(message: "hotGameArray.count = \(hotGameArray.count) --> activityData:\(gameBannerData)")
        self.gameBannerInfo = gameBannerData
        
        success(gameBannerData)
    }
    //获取宝箱是否开启
    func getTreasureBoxStatus(success:@escaping(()->()),failed:@escaping(()->())) -> Void {
        tlPrint(message: "getTreasureBoxStatus")
        let url = "Active/GrabGoldenBox"
        futuNetworkRequest(type: .get, serializer: .http, url: url, params: nil, success: { (response) in
            tlPrint(message: "response\(response)")
            //test
            success()
            
            
            let string = String(data: response as! Data, encoding: String.Encoding.utf8)
            if "\(string!)" != "true" {
                tlPrint(message: "\(String(describing: string))")
                failed()
                return
            }
            success()
        }) { (error) in
            tlPrint(message: "error\(error)")
            failed()
        }
    }
    
    //获取礼盒是否开启
    func getGiftBoxStatus(success:@escaping(()->()),failed:@escaping(()->())) -> Void {
        tlPrint(message: "getGiftBoxStatus")
        let url = "Active/GetHaveGift"
        futuNetworkRequest(type: .get, serializer: .http, url: url, params: nil, success: { (response) in
            tlPrint(message: "response\(response)")
            let string = String(data: response as! Data, encoding: String.Encoding.utf8)
            if "\(string!)" != "true" {
                tlPrint(message: "\(String(describing: string))")
                failed()
                return
            }
            success()
        }) { (error) in
            tlPrint(message: "error\(error)")
            failed()
        }
    }
    
    
    
    
    func caculateRedBagStatus(success:@escaping(()->())) -> Void {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HHmmss")
        let dateStr2 = dateFormatter.string(from: Date())
        
        dateFormatter.setLocalizedDateFormatFromTemplate("dd")
        let dateStr1 = dateFormatter.string(from: Date())
        let dateStr = "\(dateStr1)\(dateStr2)"
        let endTime = "1123:59:59"
        if dateStr < endTime {
            tlPrint("时间范围内")
            success()
        }
    }
    
    
    
    //打开宝箱接口请求函数
    func getTreasureBoxInfo(success:@escaping((Dictionary<String,Any>))->(),failure:@escaping(()->())) -> Void {
        
        let url = "Active/GrabGoldenBox"
        futuNetworkRequest(type: .get, serializer: .http, url: url, params: nil, success: { (response) in
            tlPrint(message: response)
            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
            string = string!.replacingOccurrences(of: "\"{", with: "{")
            string = string!.replacingOccurrences(of: "}\"", with: "}")
            string = string!.replacingOccurrences(of: "\\", with: "")
            tlPrint(message: "string:\(String(describing: string))")
            if string == "Failed" || string == "\"Failed\"" || string == "\"null\"" {
                tlPrint(message: "error string: \(String(describing: string))")
                failure()
                return
            }
            let resultDic = (string)?.objectFromJSONString() as! Dictionary<String, Any>
            success(resultDic)
            
        }) { (error) in
            tlPrint(message: error)
        }
    }
}
