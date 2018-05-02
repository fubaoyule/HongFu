//
//  RedBagModel.swift
//  HongFu
//
//  Created by Administrator1 on 07/02/18.
//  Copyright © 2018年 Taylor Tan. All rights reserved.
//

import UIKit

enum redBagTag:Int {
    case confirmBtnTag = 10
}
enum redBagAlertType:Int {
    case success = 0
    case unstart = 1
    case finish = 2
    case failed = 3
    case end = 4
}

class RedBagModel: NSObject {

    
    let getRedPacketInfoAddr = "Active/GetValidRedbag"
    let getRedPacketAccountAddr = "Active/GetGrabRedBag"
    var redPacketStartTime:String!
    var sendRedPacketCount:Int!
    
    let leastRedPaket:CGFloat = 0.053
    
    func getRedPacketInfo(success:@escaping((Dictionary<String, Any>)->()),failure:@escaping(()->())) -> Void {
        tlPrint(message: "getRedPacketInfo")
        
        futuNetworkRequest(type: .get, serializer: .http, url: getRedPacketInfoAddr, params: ["":""], success: { (response) in
            tlPrint(message: "response:\(response)")
            if "\(response)" == "Failed" || "\(response)" == "\"Failed\"" || "\(response)" == ""{
                tlPrint(message: "获取红包数据失败")
                failure()
                return
            }
            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
            string = string!.replacingOccurrences(of: "\"{", with: "{")
            string = string!.replacingOccurrences(of: "}\"", with: "}")
            string = string!.replacingOccurrences(of: "\\", with: "")
            tlPrint(message: "string2:\(String(describing: string))")
            if "\(string)" == "Failed" || "\(string)" == "\"Failed\"" || "\(string)" == ""{
                tlPrint(message: "获取红包数据失败")
                failure()
                return
            }
            var redPacketDic = (string!).objectFromJSONString() as! Dictionary<String, Any>
            tlPrint(message: "redPacketDic:\(redPacketDic)")
            //test data
            //            redPacketDic =  ["msg": "红包活动将在10/15/2017 12:00:00 AM开始，请关注富宝其他给力活动！", "endTime": "2017-10-15T00:00:00", "startTime": "2017-10-11T00:00:00", "sentRedbagCount": 0, "haveRedbag": false, "totalCount": 15000]
            
            if let startDate_t = redPacketDic["startTime"] {
                let startDate_s = (startDate_t as! String).replacingOccurrences(of: "T", with: " ")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                let startDate = dateFormatter.date(from: startDate_s)
                if (startDate?.timeIntervalSinceReferenceDate)! <= Date().timeIntervalSinceReferenceDate {
                    //红包开始了
                    let startTime = redPacketDic["startTime"]
                    let sentRedbagCount = redPacketDic["sentRedbagCount"]
                    let message = redPacketDic["msg"]
                    let redPacketInfoArray = [startTime,sentRedbagCount,message]
                    tlPrint(message: "redPacketInfoArray:\(redPacketInfoArray)")
                    success(redPacketDic)
                } else {
                    tlPrint(message: "红包活动还没有开始")
                }
            } else {
                tlPrint(message: "获取红包状态失败")
                return
            }
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
            failure()
        })
    }
    
    
    func getRedPacketAccount(success:@escaping((Dictionary<String, Any>)->()),failure:@escaping(()->())) -> Void {
        tlPrint(message: "getRedPacketAccount")
        
        futuNetworkRequest(type: .get, serializer: .http, url: getRedPacketAccountAddr, params: ["":""], success: { (response) in
            tlPrint(message: "response:\(response)")
            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
            string = string!.replacingOccurrences(of: "\"{", with: "{")
            string = string!.replacingOccurrences(of: "}\"", with: "}")
            string = string!.replacingOccurrences(of: "\\", with: "")
            tlPrint(message: "string2:\(String(describing: string))")
            if string == "\"Failed\"" || string == "Failed" {
                let redPacketDic = ["Amount":0, "msg": "获取失败！"] as [String : Any]
                success(redPacketDic)
                return
            }
            let redPacketDic = (string!).objectFromJSONString() as! Dictionary<String, Any>
            tlPrint(message: "redPacketDic:\(redPacketDic)")
            //test data
            //            redPacketDic = ["Amount": 888, "msg": "获取成功！"]
            success(redPacketDic)
            
            
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
            failure()
        })
    }
    
    
    
    
    
    
    func changeDateDicToArray(dateDic:Dictionary<String,Int>) -> Array<Int> {
        //        tlPrint(message: "changeDateDicToArray")
        let hour = dateDic["hour"]
        let minute = dateDic["minute"]
        let secend = dateDic["secend"]
        let dateArray = [hour!,minute!,secend!]
        return (dateArray)
    }
    
    
    
    
}
