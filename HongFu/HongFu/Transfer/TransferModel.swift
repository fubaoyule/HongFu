//
//  TransferModel.swift
//  FuTu
//
//  Created by Administrator1 on 6/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit


enum TransferTag:Int {
    case serviceBtnTag = 10, detailBtnTag,changeBtnTag,balanceLabel,alertCloseBtnTag,alertConfirmBtnTag, transInOutTextField,preferentialTextField,preferentialSelectBtnTag,pickerConfirmBtnTag,backBtnTag
    
    case gameViewTag = 25
    case transIn = 40
    case transOut = 60
    case platformBalanceLabel = 80
    
}

class TransferModel: NSObject {
    //获取中心钱包余额地址
    let allAccountUrl = "Account"
    //获取个平台游戏余额
    let gameBalanceUrl = "FundTransfer/GetGameBalance"
    //获取充值优惠的地址
    let preferenceUrl = "FundTransfer/GetOnsale"
    //转入游戏平台地址
    let deposit = "FundTransfer/Deposit"
    //转出游戏平台地址
    let withdrawl = "FundTransfer/Withdrawal"
    
    //头部背景图高度
    let topBackHeight:CGFloat = 200
    //渐变背景色
    let backgroundTopColor = UIColor.colorWithCustom(r: 11, g: 161, b: 226)
    let backgroundBottomColor = UIColor.colorWithCustom(r: 8, g: 67, b: 118)

    //游戏标签距离左右边界距离
    let gameViewLeft:CGFloat = 10
    //
    let gameViewInterval:CGFloat = 6
    //游戏标签距离顶部初始距离
    let gameViewTop:CGFloat = 155
    
    //游戏余额字体大小
    let balanceTextFont:CGFloat = 13
    let balanceNumberFont:CGFloat = 20
    
    //充值和提现按钮颜色和字体大小
    let rechargeBtnFont:CGFloat = 14
    let rechargeBtnColor = UIColor.colorWithCustom(r: 61, g: 118, b: 245)
    
    let withdrawBtnColor = UIColor.colorWithCustom(r: 50, g: 185, b: 183)
    
    
     let imgName = isPhone ? ["transfer_view_MG.png","transfer_view_SG.png","transfer_view_PNG.png","transfer_view_HB.png","transfer_view_TTG.png","transfer_view_BS.png"] : ["transfer_view_newPT_Pad.png","transfer_view_MG_Pad.png","transfer_view_SG_Pad.png","transfer_view_PNG_Pad.png","transfer_view_HB_Pad.png","transfer_view_TTG_Pad.png","transfer_view_BS_Pad.png"]
    
    var preferenceInfo:[[Any]] = [["",""]]
    
    func gameAccountDeal(account:String,index:Int) -> Void {
        tlPrint(message: "account:\(account)  index:\(index)")
        if "\(account)" == "\"Failed\"" {
            tlPrint(message: "account failed:\(account)")
            return
        }
        
        var newAcount = retain2Decima(originString: "\(account)")
        tlPrint(message: "newAcount:\(newAcount)")
        let gameUserDefaults = selfGameUserDefaults[index]
        let gameAccount = userDefaults.value(forKey: gameUserDefaults)
        if gameAccount != nil || "\(String(describing: gameAccount))" != "\(account)" {
            newAcount = retain2Decima(originString: account)
            userDefaults.setValue(newAcount, forKey: gameUserDefaults)
        }
        let notify = NSNotification.Name(rawValue: notificationName.TransferGameAccountModify.rawValue)
        NotificationCenter.default.post(name: notify, object: [newAcount,index])
        
    }
}

