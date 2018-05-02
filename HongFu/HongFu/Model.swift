//
//  Model.swift
//  HongFu
//
//  Created by Administrator1 on 24/11/17.
//  Copyright © 2017年 Taylor Tan. All rights reserved.
//

import UIKit


public func TLPrint<T>(_ message:T,file:String = #file,lint:Int = #line) {
//    print("\((file as NSString).lastPathComponent)[ \(lint) ]:  \(message)\n")
}

public func tlPrint<T>(_ message:T,file:String = #file,lint:Int = #line) {
//    print("\((file as NSString).lastPathComponent)[ \(lint) ]:  \(message)\n")
}


func fontAdapt(font:CGFloat) -> CGFloat {
    return font * (deviceScreen.width / (isPhone ? 375 : 384))
}
func adapt_H(height:CGFloat) -> CGFloat {
    return height * (deviceScreen.height / (isPhone ? 667 : 512))
}
func adapt_W(width:CGFloat) -> CGFloat {
    return width * (deviceScreen.width / (isPhone ? 375 : 384))
}


//设置Label的各个属性（文字，颜色，大小）
func setLabelProperty(label:UILabel,text:String,aligenment:NSTextAlignment,textColor:UIColor,backColor:UIColor,font:CGFloat) -> Void {
    label.text = text
    label.textAlignment = aligenment
    label.textColor = textColor
    label.backgroundColor = backColor
    label.font = UIFont.systemFont(ofSize: font)
}

//消息通知枚举
enum notificationName: String {
    //支付前跟中间API请求收到数据后的通知
    case PaymentRequestReturn = "PaymentRequestReturn"
    case ReloadMainPage = "ReloadMainPage"
    //登录界面需要跳转到注册或者忘记密码页面
    case LoginCallWebPage = "loginCallWebPage"
    //修改首页金额
    case HomeAccountValueModify = "HomeAccountValueModify"
    //邮箱邀请红包同志
    case EmailRedbagNotify = "EmailRedbagNotify"
    //刷新首页数据
    case HomeAccountValueRefresh = "HomeAccountValueRefresh"
    //修改平台游戏余额
    case PlatformGameAccountModify = "PlatformGameAccountModify"
    //转账页修改游戏平台余额
    case TransferGameAccountModify = "TransferGameAccountModify"
    //个人页修改游戏平台余额
    case SelfGameAccountModify = "SelfGameAccountModify"
    //刷新交易查询的信息
    case TradeSearchInfoTableRefresh = "TradeSearchInfoTableRefresh"
    
    //刷新银行卡界面消息通知
    case BankInfoRefresh = "BankInfoRefresh"
    //刷新砸金蛋界面消息通知
    case eggInfoRefresh = "eggInfoRefresh"
    
    //显示砸金蛋获奖信息通知
    case eggAwardInfo = "eggAwardInfo"
    
}

enum userDefaultsKeys: String {
    
    
    //前端回传的用户Token，存储了当前用户的信息
    case userToken = "userToken"
    //砸金蛋的Token
    case eggToken = "eggToken"
    
    //智付支付的密钥
    case dinpaySecurityKey = "dinpaySecurityKey"
    //主域名
    case domainName = "domainName"
    //当前用户名
    case userName = "userName"
    //是第一次登录，需要注册密码
    case isFirstLogin = "isFirstLogin"
    //第一次登录是否可以领取红包
//    case canGetEmailRedbag = "canGetEmailRedbag"
    case emailRedbagMsg = "emailRedbagMsg"
    
    //当前密码
    case passWord = "passWord"
    //中心钱包总余额
    case userInfoAccountName = "userInfoAccountName"
    case userInfoBalance = "userInfoBalance"
    case userInfoBirthDate = "userInfoBirthDate"
    case userInfoDayWithdrawCount = "userInfoDayWithdrawCount"
    case userInfoDayWithdrawMax = "userInfoDayWithdrawMax"
    case userInfoEmail = "userInfoEmail"
    case userInfoId = "userInfoId"
    case userInfoIsBankBound = "userInfoIsBankBound"
    case userInfoIsBasicBound = "userInfoIsBasicBound"
    case userInfoIsEmailBound = "userInfoIsEmailBound"
    case userInfoIsPhoneBound = "userInfoIsPhoneBound"
    case userInfoLastLogin = "userInfoLastLogin"
    case userInfoMobile = "userInfoMobile"
    case userInfoQQ = "userInfoQQ"
    case userInfoWechat = "userInfoWechat"
    case userInfoUserLevel = "userInfoUserLevel"
    case userInfoVipLevel = "userInfoVipLevel"
    case userInfoRealName = "userInfoRealName"
    case userInfoSex = "userInfoSex"
    case userInfoRegisterTime = "userInfoRegisterTime"

    
    case messageInfo = "messageInfo"
    case activityInfo = "activityInfo"
    case gameDetailInfo = "gameDetailInfo"
    //用户登陆状态,如果为true，用户不需要做任何验证就进入主页面
    case userHasLogin = "isLoginSuccess"
    //手势锁是否开启的状态
    case gestureLockStatus = "gestureLockStatus"
    //指纹识别是否开启的状态
    case touchIDStatus = "touchIDStatus"
    //当前的游戏类型
    case gameType = "currentGameType"
    //dinPay失败的时间
    case dinPayFailedTime = "dinPayFailedTime"
    case dinPayFailedLockTime = "dinPayFailedLockTime"
}

//当前是否为发布模式
let isRelease = true

//手机和iPad判断标志
var isPhone = true
//用户注册时向后台判断和获取token的地址
let loginApi = "Token"

//指示器的宽度
let indecatorWidth:CGFloat = 120

//指示器的高度
let indecatorHeight:CGFloat = 120

//屏幕的大小
let deviceScreen = UIScreen.main.bounds.size

//竖屏指示器的位置
let portraitIndicatorFrame = CGRect(x: (deviceScreen.width - indecatorWidth) / 2, y: (deviceScreen.height - indecatorHeight) / 3, width: indecatorWidth, height: indecatorHeight)

//横屏指示器的位置
let landscapeIndicatorFrame = CGRect(x: (deviceScreen.height - indecatorHeight) / 2, y: (deviceScreen.width - indecatorWidth) / 2, width: indecatorWidth, height: indecatorHeight)

//当前屏幕方向
var currentScreenOritation = UIInterfaceOrientationMask.portrait

let refreshHeight:CGFloat = 80
enum NetworkRequestType {
    case get,post
    case json,http
}

//let globleGameCode = ["SB","BTS","SG","HABA","BBIN","PT","MG","TTG","PNG"]
//let globleGameName = ["鸿福体育","BS老虎机","SG老虎机","HB老虎机","BBIN老虎机","PT老虎机","MG老虎机","TTG老虎机","PNG老虎机"]
//let globleGameUserDefaults = ["platformGame_SB","platformGame_3D","platformGame_SG","platformGame_HB","platformGame_BBIN","platformGame_PT","platformGame_MG","platformGame_TTG","platformGame_PNG"]
//获取账户余额是的区分代码
//增加游戏需要修改
let globleGameCode = ["MG","SG","PNG","HABA","TTG","BTS"]
let selfGameCode = ["MG","SG","PNG","HABA","TTG","BTS"]
let gameLobbyGameCode = ["MG","SG","PNG","HABA","TTG","BTS"]
let homeGameCode = ["newPT","MG","SG","PNG","HABA","TTG","BTS"]
//游戏名称
//增加游戏需要修改
let globleGameName = ["MG老虎机","SG老虎机","PNG老虎机","HB老虎机","TTG老虎机","BS老虎机"]
let selfGameName = ["MG老虎机","SG老虎机","PNG老虎机","HB老虎机","TTG老虎机","BS老虎机"]
let gameLobbyGameName = ["MG老虎机","SG老虎机","PNG老虎机","HB老虎机","TTG老虎机","BS老虎机"]
let homeGameName = ["PT旗舰版","MG老虎机","SG老虎机","PNG老虎机","HB老虎机","TTG老虎机","BS老虎机"]
//增加游戏需要修改
let globleGameUserDefaults = ["platformGame_newPT","platformGame_MG","platformGame_SG","platformGame_PNG","platformGame_HB","platformGame_TTG","platformGame_BS"]
let selfGameUserDefaults = ["platformGame_MG","platformGame_SG","platformGame_PNG","platformGame_HB","platformGame_TTG","platformGame_BS"]
let gameLobbyGameUserDefaults = ["platformGame_MG","platformGame_SG","platformGame_PNG","platformGame_HB","platformGame_TTG","platformGame_BS"]
//*********************************************************
//         鸿福体育网络请求函数
//*********************************************************
func futuNetworkRequest(type:NetworkRequestType,serializer:NetworkRequestType,url:String, params:Dictionary<String, Any>?,success: @escaping ((_ result: Any?) -> ()),failure: @escaping ((_ error: Error?) -> ())) -> Void {
    var token:String = ""
    if let token_t = userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue){
        token = token_t as! String
    }
    let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
    
    let url = domain + url
    //    let url = (isUseApi ? "http://mapi.toobet.net/api/" : domain) + url
    
    let para = (params == nil ? ["":""] : params)
    tlPrint(message: "networkRequest params:\(String(describing: para))\nget networkRequest  url:\(url)")
    let urlString = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    let manager = AFHTTPSessionManager()
    manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/plain", "text/json", "application/json","charset=utf-8","text/javascript","text/html", "application/javascript", "text/js") as? Set<String>
    manager.securityPolicy.allowInvalidCertificates = true
    if serializer == .json {
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
    } else {
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
    }
//    manager.requestSerializer = (serializer == .json ? AFJSONRequestSerializer() : AFHTTPRequestSerializer())
//    manager.responseSerializer = (serializer == .json ? AFJSONResponseSerializer() : AFHTTPResponseSerializer())
    
    manager.requestSerializer.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    manager.securityPolicy.allowInvalidCertificates = true
    manager.securityPolicy.validatesDomainName = false
    
    tlPrint(message: "param:\(String(describing: para))")
    DispatchQueue.global().sync {
        tlPrint(message: "进入了队列")
        if type == .get {
            manager.get(urlString, parameters: para, progress: { (downloadProgress) in
            }, success: { (task, responseObject) in
                tlPrint(message: "\(url) 请求成功 \n responseObject:\(String(describing: responseObject))")
                success(responseObject ?? "success")
            }, failure: { (task, error) in
                tlPrint(message: "\(url) 请求失败\n ERROR:\n\(error)")
                failure(error)
            })
        } else if type == .post {
            manager.post(urlString, parameters: para, progress: { (downloadProgress) in
            }, success: { (task, responseObject) in
                tlPrint(message: "\(url) 请求成功 \n responseObject:\(String(describing: responseObject))")
                success(responseObject)
            }, failure: { (task, error) in
                tlPrint(message: "\(url) 请求失败\n error:\n\(error)")
                failure(error)
            })
        }
    }
}





//*********************************************************
//         鸿福体育网络请求函数,Get请求，收到Data转换为String
//*********************************************************
func futuGetRequestDataToString(serializer:NetworkRequestType,url:String, params:Dictionary<String, Any>,success: @escaping ((_ result: String) -> ()),failure: @escaping ((_ error: Error) -> ())) -> Void {
    
    var token:String = ""
    if let token_t = userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue){
        token = token_t as! String
    }
    let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
    
    let url = domain + url
    
    //    let url = (isUseApi ? "http://mapi.toobet.net/api/" : domain) + url
    
    
    tlPrint(message: "networkRequest params:\(params)\nget networkRequest  url:\(url)")
    let urlString = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    let manager = AFHTTPSessionManager()
    manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/plain", "text/json", "application/json","charset=utf-8","text/javascript","text/html", "application/javascript", "text/js") as? Set<String>
    manager.securityPolicy.allowInvalidCertificates = true
    if serializer == .json {
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
    } else {
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
    }
//    manager.requestSerializer = (serializer == .json ? AFJSONRequestSerializer() : AFHTTPRequestSerializer())
//    manager.responseSerializer = (serializer == .json ? AFJSONResponseSerializer() : AFHTTPResponseSerializer())
    manager.requestSerializer.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    tlPrint(message: "param:\(params)")
    manager.securityPolicy.allowInvalidCertificates = true
    manager.securityPolicy.validatesDomainName = false
    
    DispatchQueue.global().sync {
        tlPrint(message: "进入了队列")
        manager.get(urlString, parameters: params, progress: { (downloadProgress) in
        }, success: { (task, responseObject) in
            tlPrint(message: "成功 \n responseObject:\(String(describing: responseObject))")
            //success(responseObject)
            let string = String(data: responseObject as! Data, encoding: String.Encoding.utf8)!
            success(string)
            tlPrint(message: "string*****:\(string)")
            
        }, failure: { (task, error) in
            tlPrint(message: "请求失败\n ERROR:\n\(error)")
            failure(error)
        })
    }
}

func refreshPull(target:Any?,selector:Selector) ->MJRefreshHeader {
    tlPrint(message: "refreshViewOfBlock")
    let header = MJRefreshNormalHeader()
    //修改字体
    header.stateLabel.font = UIFont.systemFont(ofSize: 15)
    header.lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: 13)
    
    //隐藏刷新提示文字
    header.stateLabel.isHidden = true
    //隐藏上次刷新时间
    header.lastUpdatedTimeLabel.isHidden = true
    header.setRefreshingTarget(target, refreshingAction: selector)
    return header
    //self.scroll.mj_header = header
}


func retain2Decima(originString:String) -> String {
    //保留两位小数
    var newValue = originString
    let newValueArray = newValue.components(separatedBy: ".")
    if newValueArray.count > 1 && newValueArray[1].characters.count > 2 {
        newValue = newValueArray[1].substring(to: newValueArray[1].index(newValueArray[1].startIndex, offsetBy: 2))
        newValue = newValueArray[0] + "." + newValue
    } else if newValueArray.count > 1 && newValueArray[1].characters.count <= 1 {
        newValue = newValueArray[1].substring(to: newValueArray[1].index(newValueArray[1].startIndex, offsetBy: 1))
        newValue = newValueArray[0] + "." + newValue + "0"
    }
    return newValue
}


//清楚URL缓存
func clearCacheWithURL(url:URL) -> Void {
    URLCache.shared.removeAllCachedResponses()
    URLCache.shared.diskCapacity = 0
    URLCache.shared.memoryCapacity = 0
}


//=============================================
//Mark:- 添加一些全局的计算变量,使获取全局队列更方便一些
//=============================================
//
var GlobalMainQueue: DispatchQueue {
    return DispatchQueue.main
}
var GlobalUserInteractiveQueue: DispatchQueue {
    return DispatchQueue.global(qos: .userInteractive)
}

var GlobalUserInitiatedQueue: DispatchQueue {
    return DispatchQueue.global(qos: .userInitiated)
}

var GlobalUtilityQueue: DispatchQueue {
    return DispatchQueue.global(qos: .utility)
}

var GlobalBackgroundQueue: DispatchQueue {
    return DispatchQueue.global(qos: .background)
}






