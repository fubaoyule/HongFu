//
//  WalletHubModel.swift
//  FuTu
//
//  Created by Administrator1 on 27/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit


enum walletHubTag:Int {
    case HubBackBtnTag = 10, TradeSearchBtnTag
    case RechargeBtnTag = 12
    case BailoutsBtnTag = 20
    case WeekendBtnTag = 30
    
}

class WalletHubModel: NSObject {

    //头部视图的高度
    let titleHeight:CGFloat = isPhone ? 350 : 230
    
    let logoWidth:CGFloat = isPhone ? 120 : 80
    
    let buttonInfo = [["存  款",UIColor.colorWithCustom(r: 28, g: 185, b: 67)],
                      ["转  账",UIColor.colorWithCustom(r: 241, g: 124, b: 65)],
                      ["取  款",UIColor.colorWithCustom(r: 159, g: 11, b: 67)]]
    
    
    
    

    //获取救援金接口请求函数
    func getBailoutsInfo(yestoday:Bool, success:@escaping((Dictionary<String,Any>))->(),failure:@escaping(()->())) -> Void {
        
        let url = "FundTransfer/GetRescureGold?yestodayFlag=\(yestoday)"
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
    
    
    //获取周日／周六奖金的接口请求函数
    func getWeekendAwardInfo(success:@escaping((Dictionary<String,Any>))->(),failure:@escaping(()->())) -> Void {
        
        let url = "/Active/GetWeeklyScRtn"
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
