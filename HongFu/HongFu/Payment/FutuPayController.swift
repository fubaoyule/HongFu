//
//  FutuPayController.swift
//  FuTu
//
//  Created by Administrator1 on 10/11/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class FutuPayController: NSObject {

    
    
    
    //========================
    //Mark:- 根据返回的PayName判断支付方式
    //========================
    class func payTypeConfirm(payName: String) -> String {
        
        tlPrint(message: "payTypeConfirm payName: \(payName)")
        var returnValue = ""
        
        if (payName.range(of: "zf") != nil) || (payName.range(of: "ZF") != nil) {
            //智付
            returnValue = "ZF"
        } else if (payName.range(of: "O2P") != nil || payName.range(of: "O2p") != nil) {
            //OpenToPay
            returnValue = "O2P"
        }
        return returnValue
    }
    
    
    
    //========================
    //Mark:- 智付支付入口
    //========================
    
    class func dinpay(sender: AnyObject,rootViewControler: UIViewController) -> Void {
        
        tlPrint(message: "dinpay:\(sender)")
        
        let futuItems = ["MerchantKey", "MerchantCode", "Amount", "BillDate", "Billno", "ServerUrl", "ReturnParam", "product_name"]
        let dinpayItems = ["RSAKey", "merchant", "order_amount", "order_time", "order_no", "notify_url", "extra_return_param", "product_name",]
        var dinpayDic = Dictionary<String,Any>()
        
        for i in 0 ... 7 {
            if let value = sender.value(forKey: futuItems[i]) {
                dinpayDic[dinpayItems[i]] = value
            } else if i < 7 {
                tlPrint(message: "没有成功获取\(futuItems[i])")
                return
            }
            if i == 7 {
                dinpayDic[dinpayItems[i]] = "充值"
            }
        }
        tlPrint(message: "dinpay dic1 = \(dinpayDic)")
        
        let dinpayVC = DinpayViewController()
        dinpayVC.information = dinpayDic
        rootViewControler.navigationController?.pushViewController(dinpayVC, animated: true)
    }
}
