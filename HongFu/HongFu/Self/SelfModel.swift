//
//  SelfModel.swift
//  FuTu
//
//  Created by Administrator1 on 17/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

enum selfBtnTag:Int {
    //buttons
    case SettingBtn = 60,MessageBtn,BankBtn,TotleAccountLabel,AlertLabel,AlertImg
    //games
    case SelfGameBtnTag = 70
    case AccountLabel = 100
}

class SelfModel: NSObject {
    
    
    //获取中心钱包余额地址
    let allAccountUrl = "Account"
    //获取个平台游戏余额
    let gameBalanceUrl = "FundTransfer/GetGameBalance"
    
    //头部视图高度
//    let titleViewHeight:CGFloat = isPhone ? 220 : 165
    let titleViewHeight:CGFloat = isPhone ? 270 : 180
    
    
    let dataSource = ["未来大神",
                      "http://xxxxxx.com/img",
                      8,
                      99,
                      "1787663.87",
                      "273.6","4000.29","640.97","20.00","1.23","1234","3252..87","234.12"] as [Any]
    
    func gameAccountDeal(account:String,index:Int) -> Void {
        tlPrint(message: "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊account:\(account)  index:\(index)＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊")
        var newAcount = account
        if "\(account)" == "\"Failed\"" {
            tlPrint(message: "account failed:\(account)")
            return
        }
        
        let gameAccount = userDefaults.value(forKey: selfGameUserDefaults[index])
        if gameAccount != nil || "\(String(describing: gameAccount))" != "\(account)" {
            
            newAcount = retain2Decima(originString: newAcount)
            userDefaults.setValue(newAcount, forKey: selfGameUserDefaults[index])
        }
        
        let notify = NSNotification.Name(rawValue: notificationName.SelfGameAccountModify.rawValue)
        NotificationCenter.default.post(name: notify, object: [newAcount,index])
        
    }

}
