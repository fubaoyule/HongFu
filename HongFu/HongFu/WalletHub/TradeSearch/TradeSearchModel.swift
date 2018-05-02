//
//  TradeSearchModel.swift
//  FuTu
//
//  Created by Administrator1 on 28/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

enum tradeSearchTag:Int {
    case TradeSearchBackBtnTag = 10,DateSelectorTag
    case DateSearchBtnTag = 15,DateSelectConfirmBtnTag
    case TradeSearchSubTabBtnTag = 20
    case TradeSearchTabLineTag = 25
    case BetDateSelectorTag = 30
    case TradeSearchTabBtnTag = 40
    
    
}
enum tradeSearchType:Int {
    case Recharge = 0,Withdraw,Transfer,Bonus
    case tradeRecord = 50, betRecord
}


class TradeSearchModel: NSObject {

    //导航按钮的名称
    let tabName = ["交易记录","投注记录"]
    //交易记录子导航栏名称
    let subTabName = ["存款","取款","转账","红利"]
    //导航按钮字体颜色
    let tabBtnColorHigh = UIColor.colorWithCustom(r: 35, g: 35, b: 35)
    let tabBtnColorNormal = UIColor.colorWithCustom(r: 225, g: 225, b: 225)
    let tabBtnBgColorHigh = UIColor.colorWithCustom(r: 255, g: 216, b: 0)
    let tabBtnBgColorNormal = UIColor.colorWithCustom(r: 152, g: 147, b: 135)
    let subTabBtnColorHigh = UIColor.colorWithCustom(r: 140, g: 0, b: 43)
    let subTabBtnColorNormal = UIColor.colorWithCustom(r: 129, g: 129, b: 129)
    
    
    
    //data source
    var dataSource : [[Any]]! = [["加载中","...","交易成功","请耐心等待",""]]
    var betDataSource : [[Any]]! = [["","","","",""]]
    
    
    func changeData(type:tradeSearchType) -> [[Any]] {
        switch type {
        case tradeSearchType.Recharge:
            dataSource = getRechargeData()
        case tradeSearchType.Withdraw:
            dataSource = getWithdrawData()
        case tradeSearchType.Transfer:
            dataSource = getTransferData()
        case tradeSearchType.Bonus:
            dataSource = getBonusData()
        default:
            TLPrint("no such case!")
        }
        return dataSource
    }
    
    func getRechargeData() -> [[Any]] {
        let dataSource = [["充值",3000,"","23423526135341234","2016-08-21"],
                          ["充值",3000,true,"23423526135341234","2016-08-21"],
                          ["充值",20000,true,"23423526135341234","2016-08-21"],
                          ["充值",3000,true,"23423526135341234","2016-08-21"],
                          ["充值",8000,true,"23423526135341234","2016-08-21"],
                          ["充值",800,false,"23423526135341234","2016-08-21"],
                          ["充值",500,true,"23423526135341234","2016-08-21"],
                          ["充值",3000,true,"23423526135341234","2016-08-21"],
                          ["充值",3000,false,"23423526135341234","2016-08-21"],
                          ["充值",500,true,"23423526135341234","2016-08-21"],
                          ["充值",3000,true,"23423526135341234","2016-08-21"],
                          ["充值",3000,true,"23423526135341234","2016-08-21"],
                          ["充值",3000,true,"23423526135341234","2016-06-21"]]
        return dataSource
    }
    
    
    func getWithdrawData() -> [[Any]] {
        let dataSource = [["提现",3000,false,"23423526135341234","2016-08-21"],
                          ["提现",3000,false,"23423526135341234","2016-08-21"],
                          ["提现",234,false,"23423526135341234","2016-08-21"],
                          ["提现",3000,true,"23423526135341234","2016-08-21"],
                          ["提现",456,true,"23423526135341234","2016-08-21"],
                          ["提现",800,false,"23423526135341234","2016-08-21"],
                          ["提现",500,true,"23423526135341234","2016-08-21"],
                          ["提现",3000,false,"23423526135341234","2016-08-21"],
                          ["提现",3000,false,"23423526135341234","2016-08-21"],
                          ["提现",500,true,"23423526135341234","2016-08-21"],
                          ["提现",3000,false,"23423526135341234","2016-08-21"],
                          ["提现",3000,false,"23423526135341234","2016-08-21"],
                          ["提现",3000,true,"23423526135341234","2016-08-21"]]
        return dataSource
    }
    
    func getTransferData() -> [[Any]] {
        let dataSource = [["转账",3000,false,"23423526135341234","2016-08-21"],
                          ["转账",3000,true,"23423526135341234","2016-08-21"],
                          ["转账",234,true,"23423526135341234","2016-08-21"],
                          ["转账",3000,true,"23423526135341234","2016-08-21"],
                          ["转账",456,true,"23423526135341234","2016-08-21"]]

        return dataSource
    }
    
    func getBonusData() -> [[Any]] {
        let dataSource = [["红利",3,true,"23423526135341234","2016-08-21"],
                          ["红利",3,true,"23423526135341234","2016-08-21"],
                          ["红利",2,true,"23423526135341234","2016-08-21"],
                          ["红利",30,true,"23423526135341234","2016-08-21"],
                          ["红利",45,true,"23423526135341234","2016-08-21"],
                          ["红利",80,false,"23423526135341234","2016-08-21"]]
        return dataSource
    }
    
    
    
    
    func getSearchedData(type:tradeSearchType,startDate:String,endDate:String) -> Void {
        
        var paras = ["searchType": type.rawValue + 1 , "startDate":startDate, "endDate":endDate] as [String : Any]
        tlPrint(message: "parse: \(paras)")
        var url = "Transact/SearchTransactionHistory"
        futuNetworkRequest(type: .post, serializer: .json, url: url , params: paras, success: { (response) in
            tlPrint(message: "response:\(response)")
            if response == nil || "\(response)" == "" {
                tlPrint("获取交易记录失败，或者没有交易记录")
                return
            }
            if self.dataSource != nil {
                self.dataSource.removeAll()
            }
            self.dataSource = [["加载中","...",true,"请耐心等待",""]]
            let itemsArray = response as! NSArray
            for items in itemsArray {
                let items = (items as! NSDictionary)
                for item in items {
                    if item.key as! String == "TransactionDate" {
                        continue
                    }
                    tlPrint(message: "item: \(item)")
                    let values = item.value as! NSArray
                    for value in values {
                        let amount = (value as AnyObject).value(forKey: "Amount")!
                        let orderNumber = (value as AnyObject).value(forKey: "OrderNumber")!
                        let transactionDate = (value as AnyObject).value(forKey: "TransactionDate")!
                        let tradeStauts = (value as AnyObject).value(forKey: "TransactionDescription")!
                        tlPrint(message: "**********************   tradeStatus:\(tradeStauts)")
                        let data = [self.subTabName[type.rawValue], "\(amount)", tradeStauts, "\(orderNumber)", "\(transactionDate)"]
                        self.dataSource.append(data)
                        tlPrint(message: "交易记录状态：")
                        
                    }
                }
            }
            self.dataSource.remove(at: 0)
            tlPrint(message: "new data source:\(self.dataSource)")
            let notify = NSNotification.Name(rawValue: notificationName.TradeSearchInfoTableRefresh.rawValue)
            NotificationCenter.default.post(name: notify, object: nil)
            //通知控制器刷新页面数据
        }, failure: { (error) in
            tlPrint(message: "Error:\(error)")
            let alert = UIAlertView(title: "查询失败", message: "\(error)", delegate: nil, cancelButtonTitle: "确  定")
            DispatchQueue.main.async {
                alert.show()
            }
        })
    }
    
    
    func getSearchedBetData(type:tradeSearchType,startDate:String,endDate:String, gameType:String) -> Void {
        
        let paras = ["PlatNo":gameType,"StartTime":startDate,"EndTime":endDate,"type":"1","PageIndex":"0","PageSize":"9999"]
        tlPrint(message: "parse: \(paras)")
        let url = "BetRecord/GetPagedBetRecordByGamePlatType"
        futuNetworkRequest(type: .post, serializer: .http, url: url , params: paras, success: { (response) in
            tlPrint(message: "response:\(String(describing: response))")
            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
            string = string!.replacingOccurrences(of: "\"{", with: "{")
            string = string!.replacingOccurrences(of: "}\"", with: "}")
            string = string!.replacingOccurrences(of: "\\", with: "")
            tlPrint(message: "string:\(String(describing: string))")
            if string == "Failed" || string == "\"Failed\"" || string == "\"null\"" || string == "" {
                tlPrint(message: "error string: \(String(describing: string))")
                return
            } else if string!.contains("在别的地方登陆") {
                let loginAlert = UIAlertView(title: "提示", message: "您的账户在别的地方登录，请重新登录!", delegate: self, cancelButtonTitle: "确 定")
                loginAlert.show()
                return
            }
            
            let resultDic = (string)?.objectFromJSONString() as! Dictionary<String, Any>
            tlPrint(message: "bet resultDic:\(resultDic)")
            
            if self.betDataSource != nil {
                self.betDataSource.removeAll()
            }
            self.betDataSource = [["","","","",""]]
            let TotalBetAmount = resultDic["TotalBetAmount"]
            let TotalWinLoss = resultDic["TotalWinLoss"]
            let BetCount = resultDic["BetCount"]
            let BetRecords = resultDic["BetRecords"] as! NSArray
            tlPrint("TotalBetAmount:\(TotalBetAmount), TotalWinLoss:\(TotalWinLoss), BetCount:\(BetCount)")
            for record in BetRecords {
                let recordDic = record as! NSDictionary
                let platNo = recordDic["platNo"]
                let betTime = recordDic["betTime"]
                let betAmount = recordDic["betAmount"]
                let winLoss = recordDic["winLoss"]
//                let info = ["\(platNo!)","\(betTime!)","\(BetCount!)","\(betAmount!)","\(winLoss!)"]
                let info = ["\(betTime!)","\(platNo!)","\(betAmount!)","\(winLoss!)"]
                if type == tradeSearchType.betRecord {
                    self.betDataSource.append(info)
                }
                
            }
            
            self.betDataSource.remove(at: 0)
            tlPrint(message: "new bet data source:\(self.betDataSource!)")
            let notify = NSNotification.Name(rawValue: notificationName.TradeSearchInfoTableRefresh.rawValue)
            NotificationCenter.default.post(name: notify, object: nil)
            //通知控制器刷新页面数据
        }, failure: { (error) in
            tlPrint(message: "Error:\(error)")
            let alert = UIAlertView(title: "查询失败", message: "\(error)", delegate: nil, cancelButtonTitle: "确  定")
            DispatchQueue.main.async {
                alert.show()
            }
        })
    }
    
//    func getSearchedData(type:tradeSearchType,startDate:String,endDate:String) -> Void {
//        
//        let paras = ["searchType": type.rawValue + 1 , "startDate":startDate, "endDate":endDate] as [String : Any]
//        tlPrint(message: "parse: \(paras)")
//        futuNetworkRequest(type: .post, serializer: .http, url: "Transact/SearchTransactionHistory", params: paras, success: { (response) in
//            tlPrint(message: "response:\(response)")
//           var string = String(data: response as! Data, encoding: String.Encoding.utf8)
//            
//            TLPrint("string:\(string)")
//            if self.dataSource != nil {
//                self.dataSource.removeAll()
//            }
//            self.dataSource = [["加载中","...",true,"请耐心等待",""]]
//            let itemsArray = response as! NSArray
//            for items in itemsArray {
//                //tlPrint(message: "items: \(items)")
//                let items = (items as! NSDictionary)
//                for item in items {
//                    if item.key as! String == "TransactionDate" {
//                        continue
//                    }
//                    //tlPrint(message: "item: \(item)")
//                    let values = item.value as! NSArray
//                    for value in values {
//                        let amount = (value as AnyObject).value(forKey: "Amount")!
//                        let orderNumber = (value as AnyObject).value(forKey: "OrderNumber")!
//                        let transactionDate = (value as AnyObject).value(forKey: "TransactionDate")!
//                        let tradeStauts = (value as AnyObject).value(forKey: "TransactionDescription")!
//                        tlPrint(message: "**********************   tradeStatus:\(tradeStauts)")
//                        
//                        //tradeStauts = String(data: tradeStauts as! Data, encoding: String.Encoding.utf8)! as String
//                        let data = [self.tabName[type.rawValue], "\(amount)", tradeStauts, "\(orderNumber)", "\(transactionDate)"]
//                        self.dataSource.append(data)
//                        tlPrint(message: "交易记录状态：")
//                        
//                    }
//                }
//            }
//            self.dataSource.remove(at: 0)
//            tlPrint(message: "new data source:\(self.dataSource)")
//            let notify = NSNotification.Name(rawValue: notificationName.TradeSearchInfoTableRefresh.rawValue)
//            NotificationCenter.default.post(name: notify, object: nil)
//            //通知控制器刷新页面数据
//        }, failure: { (error) in
//            tlPrint(message: "Error:\(error)")
//            let alert = UIAlertView(title: "查询失败", message: "\(error)", delegate: nil, cancelButtonTitle: "确  定")
//            DispatchQueue.main.async {
//                alert.show()
//            }
//        })
//    }
    
    
}
