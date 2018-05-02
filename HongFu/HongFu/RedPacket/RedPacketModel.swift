//
//  RedPacketModel.swift
//  FuTu
//
//  Created by Administrator1 on 28/2/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit


enum redPacketTag:Int {
    case backBtnTag = 10,getBtnTag, confirmBtnTag,caseTapTag,alergGetBtnTag,shadowViewTapTag,bannerBombTapTag,startLabelImgTag
    case redNumLabelTag = 20, redNumTextTag ,homeRedNumLabelTag//本轮红包个数和已发放个数的标签
    case redBombBackImgTag = 25
    case leftTimeTag = 30
    case leftTimePointTag = 40
    case zeroTimeImgTag = 50
}
enum redPacketAlertType {
    case success,later,finish
}

class RedPacketModel: NSObject {
    
    
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
//            redPacketDic =  ["msg": "红包活动将在10/15/2017 12:00:00 AM开始，请关注鸿福其他给力活动！", "endTime": "2017-10-15T00:00:00", "startTime": "2017-10-11T00:00:00", "sentRedbagCount": 0, "haveRedbag": false, "totalCount": 15000]
            
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
    
    func timeIntervalCalculate(start:String,end:String) -> (Bool,Dictionary<String,Int>) {
        //        tlPrint(message: "timeIntervalCalculate   start:\(start)  end:\(end)")
        var haveStart = false
        let dm: DateFormatter = DateFormatter()
        dm.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let D_SECENDS = 1
        let D_MINUTE = D_SECENDS * 60
        let D_HOUR = D_MINUTE * 60
        
        let startDate: Date = dm.date(from: start)!
        let interval:TimeInterval = startDate.timeIntervalSinceNow
        
        var hours = (Int(interval)) / D_HOUR
        var minutes = (Int(interval)) / D_MINUTE % 60
        var secends = (Int(interval)) / D_SECENDS % 60
        //test
        //        hours = 0
        //        minutes = 0
        //        secends = -1
        if hours < 0 || minutes < 0 || secends < 0 {
            haveStart = true
            let endDate: Date = dm.date(from: end)!
            let interval:TimeInterval = endDate.timeIntervalSinceNow
            hours = (Int(interval)) / D_HOUR
            minutes = (Int(interval)) / D_MINUTE % 60
            secends = (Int(interval)) / D_SECENDS % 60
            if hours < 0 || minutes < 0 || secends < 0 {
                hours = 0
                minutes = 0
                secends = 0
            }
        }
        let resultDic = ["hour":hours,"minute":minutes,"secend":secends]
        return (haveStart,resultDic)
    }
    
    func timeOutCalculate(end:String) -> (Bool) {
        tlPrint(message: "timeOutCalculate   end:\(end)")
        var haveStop = false
        let dm: DateFormatter = DateFormatter()
        dm.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let D_SECENDS = 1
        let D_MINUTE = D_SECENDS * 60
        let D_HOUR = D_MINUTE * 60
        
        let endDate: Date = dm.date(from: end)!
        let interval:TimeInterval = endDate.timeIntervalSinceNow
        
        let hours = (Int(interval)) / D_HOUR
        let minutes = (Int(interval)) / D_MINUTE % 60
        let secends = (Int(interval)) / D_SECENDS % 60
        if hours < 0 || minutes < 0 || secends < 0 {
            haveStop = true
        }
        tlPrint(message: "hours:\(hours)  minutes:\(minutes)  secends:\(secends)")
        return haveStop
    }
    
    
    func changeDateDicToArray(dateDic:Dictionary<String,Int>) -> Array<Int> {
        //        tlPrint(message: "changeDateDicToArray")
        let hour = dateDic["hour"]
        let minute = dateDic["minute"]
        let secend = dateDic["secend"]
        let dateArray = [hour!,minute!,secend!]
        return (dateArray)
    }
    
    func separateDate(date:Array<Int>) -> Array<Int> {
        var returnArray = [0]
        let hourDate1 = date[0] / 100
        returnArray.append(hourDate1)
        for subDate in date {
            var leftDate = subDate
            if subDate >= 100 {
                leftDate = subDate - hourDate1 * 100
            }
            let date1 = leftDate / 10
            let date2 = leftDate % 10
            returnArray.append(date1)
            returnArray.append(date2)
        }
        returnArray.remove(at: 0)
        return returnArray
    }
    
    func leftRedbagNumber(totleNum:Int,startTime:String,endTime:String) -> Int {
        tlPrint(message: "hasSendRedbagNumber totleNum:\(totleNum)  startTime:\(startTime)  endTime:\(endTime)")
        
        let totleShowNum = CGFloat(totleNum) * (1 - leastRedPaket)
        var leftValue = 0
        let percentArray:[CGFloat] = [0.1, 0.2, 0.4, 0.1, 0.2]
        
        let dm: DateFormatter = DateFormatter()
        dm.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startDate: Date = dm.date(from: startTime)!
        let endDate: Date = dm.date(from: endTime)!
        let totleInterval:TimeInterval = endDate.timeIntervalSince(startDate)
        let totleTime = Int(totleInterval)
        let currentInterval:TimeInterval = startDate.timeIntervalSinceNow
        let currentTime = Int(-currentInterval)
        tlPrint(message: "totleTime:\(totleTime)")
        tlPrint(message: "currentTime:\(currentTime)")
        
        if currentTime <= 0 || currentTime >= totleTime {
            tlPrint(message: "抢红包时间已过")
            return (leftValue + Int(CGFloat(totleNum) * leastRedPaket + 0.5) )
        }
        //总分段数
        let totlePart:Int = totleTime / 5
        let timeoutPart:Int = currentTime / 5
        let partNumber:Int = Int(CGFloat(totleShowNum) / CGFloat(totlePart) + 0.5) //每一段的平均红包个数(四舍五入)
        let partStartAt:Int = Int(CGFloat(totleShowNum) * CGFloat(1 - CGFloat(timeoutPart) / CGFloat(totlePart)) + 0.5)
        let secents = ((NSDate.getTime(type: .secends)) as NSString).integerValue
        let subSecents = secents % 10 / 2
        tlPrint(message: "secents:\(secents) subSecents:\(subSecents)")
        
        let countValue = Int(CGFloat(partNumber) * percentArray[subSecents] + 0.5)
        tlPrint(message: "****   countValue:\(countValue)")
        
        leftValue = partStartAt - Int(CGFloat(partNumber) * percentArray[subSecents] + 0.5)
        tlPrint(message: "totlePart:\(totlePart)  timeoutPart:\(timeoutPart)  partNumber:\(partNumber)  partStartAt:\(partStartAt)  sendValue:\(leftValue)")
        if leftValue <= 0 {
            leftValue = 0
        }
        return (leftValue + Int(CGFloat(totleNum) * leastRedPaket + 0.5) )
    }
}

















