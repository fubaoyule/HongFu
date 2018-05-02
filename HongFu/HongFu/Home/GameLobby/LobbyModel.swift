//
//  LobbyModel.swift
//  FuTu
//
//  Created by Administrator1 on 23/11/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit


enum LobbyTag:Int {
    case backBtnAct = 10,gamePlayBtnTag,rechargeBtnTag,withdrawBtnTag,gameAccountLabel
    case hotGameBtnTag = 40
}

class LobbyModel: NSObject {

    //获取个平台游戏余额
    let gameBalanceUrl = "FundTransfer/GetGameBalance"
    //转入游戏平台地址
    let deposit = "FundTransfer/Deposit"
    //转出游戏平台地址
    let withdrawl = "FundTransfer/Withdrawal"
    //游戏对应的键名
    //增加游戏需要修改
    let gameKey = ["mg","sg","png","hb","ttg","bs"]
    let PTDataSource:Array<String> = ["lobby_PT_back","lobby_PT_image","lobby_PT_play","lobby_PT_ico","PT老虎机"]
    //头部图片视图高度占屏比
    let imgHeight:CGFloat = 0.326
    //play按钮的宽度倍率
    let playBtnWidth:CGFloat = 0.226
    //帐户栏的高度倍率
    let accounHeight:CGFloat = 0.243
    //帐户栏图片宽度倍率
    let accountImgWidth:CGFloat = 0.221
    //帐户信息栏的宽度倍率
    let accountInfoWidth:CGFloat = 0.651
    //帐户信息栏的高度倍率
    let accountInfoHeight:CGFloat = 0.106
    //按钮高度倍率
    let btnHeight:CGFloat = 0.0555
    //按钮上下距离高度倍率
    let btnBottom:CGFloat = 0.03
    //充值按钮颜色
    let rechargeBtnColor = UIColor.colorWithCustom(r: 255, g: 198, b: 0)
    let rechargeTextColor = UIColor.colorWithCustom(r: 55, g: 55, b: 55)
    //充值按钮字体大小
    let rechargeFont:CGFloat = 15
    //提现按钮颜色
    let withdrawBtnColor = UIColor.colorWithCustom(r: 31, g: 198, b: 153)
    let withdrawTextColor = UIColor.colorWithCustom(r: 255, g: 255, b: 255)
    //提现按钮字体大小
    let withdrawFont:CGFloat = 15
    //帐户信息栏和优惠活动栏中间的分割线宽度
    let grayLineHeight:CGFloat = isPhone ? 10 : 4
    let gameIconArray = ["lobby_ico_MG.png","lobby_ico_SG.png","lobby_ico_PNG.png","lobby_ico_HB.png","lobby_ico_TTG.png","lobby_ico_BS.png"]
    
    func getPlatformAccount(token:String,gameIndex:Int,success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) -> Void {
        
        tlPrint(message: "getPlatformAccount token:\(token)  gameIndex:\(gameIndex)")
        let token = userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue)
        let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
        let url = domain + gameBalanceUrl
        tlPrint(message: "get totle account url:\(url)")
        //字符串的转码
        let urlString = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        //创建管理者对象
        let manager = AFHTTPSessionManager()
        //设置允许请求的类别
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/plain", "text/json", "application/json","charset=utf-8","text/javascript","text/html", "application/javascript", "text/js") as? Set<String>
        manager.securityPolicy.allowInvalidCertificates = true
        //数据类型选择
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        //验证信息
        if let token = token {
            manager.requestSerializer.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        DispatchQueue.global().sync {
            tlPrint(message: "进入了队列")
            manager.get(urlString, parameters: ["gamecode":gameLobbyGameCode[gameIndex]], progress: { (downloadProgress) in
                
            }, success: { (task, responseObject) in
                tlPrint(message: "成功 \n responseObject:\(String(describing: responseObject))")
                let string = String(data: responseObject! as! Data, encoding: String.Encoding.utf8)

                success(string ?? "success")
            }, failure: { (task, error) in
                tlPrint(message: "请求失败\n ERROR:\n\(error)")
                failure(error)
            })
        }
    }
    
    func gameAccountDeal(account:String,index:Int,success:@escaping(()->())) -> Void {
        tlPrint(message: "account:\(account)  index:\(index)")

        if "\(account)" == "\"Failed\"" {
            tlPrint(message: "account failed:\(account)")
            return
        }
        
        let gameAccount = userDefaults.value(forKey: gameLobbyGameUserDefaults[index])
        if gameAccount != nil || "\(String(describing: gameAccount))" != "\(account)" {
            userDefaults.setValue(account, forKey: gameLobbyGameUserDefaults[index])
        }
        
        let notify = NSNotification.Name(rawValue: notificationName.PlatformGameAccountModify.rawValue)
        NotificationCenter.default.post(name: notify, object: account)
        success()
    }
    
    
    
    //*********************************************************
    //         鸿福体育-游戏大厅 网络请求函数
    //*********************************************************
    func lobbyNetworkRequest(type:NetworkRequestType,serializer:NetworkRequestType,url:String, params:Dictionary<String, Any>,success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) -> Void {
        tlPrint(message: "lobbyNetworkRequest")
        var token:String = ""
        if let token_t = userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue){
            token = token_t as! String
        }
        let url = url
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
//        manager.requestSerializer = (serializer == .json ? AFJSONRequestSerializer() : AFHTTPRequestSerializer())
//        manager.responseSerializer = (serializer == .json ? AFJSONResponseSerializer() : AFHTTPResponseSerializer())
        manager.requestSerializer.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        tlPrint(message: "param:\(params)")
        DispatchQueue.global().sync {
            tlPrint(message: "进入了队列")
            if type == .get {
                manager.get(urlString, parameters: params, progress: { (downloadProgress) in
                }, success: { (task, responseObject) in
                    tlPrint(message: "成功 \n responseObject:\(String(describing: responseObject))")
                    success(responseObject ?? "responseObject")
                }, failure: { (task, error) in
                    tlPrint(message: "请求失败\n ERROR:\n\(error)")
                    failure(error)
                })
            } else if type == .post {
                manager.post(urlString, parameters: params, progress: { (downloadProgress) in
                }, success: { (task, responseObject) in
                    tlPrint(message: "成功 \n responseObject:\(String(describing: responseObject))")
                    success(responseObject)
                }, failure: { (task, error) in
                    tlPrint(message: "请求失败\n ERROR:\n\(error)")
                    failure(error)
                })
            }
        }
    }
}
