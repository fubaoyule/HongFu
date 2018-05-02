//
//  MessageModel.swift
//  FuTu
//
//  Created by Administrator1 on 29/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

enum MessageTag:Int {
    case MessageBtnTag = 10
    case ActivityTabBtnTag = 15,MessageTabBtnTag
    case MessageTabLineTag = 18
    
    case ActiVityImgTag = 20
    
}

enum MessageType {
    case SystemMessage,Activity
}

class MessageModel: NSObject {

    
    
    //系统消息地址
    let sysMsgAddr = "Active/GetNotices"
    //
    //未读消息条数地址
    let unReadMsgCountAddr = "Message/GetNoReadMsgCount "
    //获取未读消息地址
    let getInternalMsgAddr = "Message/GetPagedMessagesByUserId"
    
    
    //导航按钮的名称
    let tabName = ["优惠活动","站内信"]
    //导航按钮字体颜色
    let tabBtnColorHigh = UIColor.colorWithCustom(r: 186, g: 9, b: 31)
    let tabBtnColorNormal = UIColor.colorWithCustom(r: 129, g: 129, b: 129)
    let tabBtnBackColor = UIColor.colorWithCustom(r: 244, g: 244, b: 244)
    
    var messageDataSource:[[String:Any]]?
    var activityDataSource:[[String:Any]]?
    var dataSource:[[String:Any]]?
    
    
    func changeDataSource(messageType:MessageType) -> [[String:Any]]! {
        
        if messageType == .SystemMessage {
            if self.messageDataSource != nil {
                self.dataSource = self.messageDataSource
            } else {
                self.dataSource = userDefaults.value(forKey: userDefaultsKeys.messageInfo.rawValue) as? [[String:Any]]
            }
            
        } else {
            if self.messageDataSource != nil {
                self.dataSource = self.activityDataSource
            } else {
                self.dataSource = userDefaults.value(forKey: userDefaultsKeys.activityInfo.rawValue) as? [[String:Any]]
            }
        }
        tlPrint(message: "DataSource:\(String(describing: dataSource))")
        return self.dataSource
    }
    
   //获取系统消息数据
    func getSysMsg(success:@escaping(([[String:Any]])->())) -> Void {
        tlPrint(message: "getSysMsg")
        futuNetworkRequest(type: .get, serializer: .http, url: self.sysMsgAddr, params: ["":""], success: { (response) in
            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
            string = string?.replacingOccurrences(of: "\"", with: "")
            string = string?.replacingOccurrences(of: "\\", with: "")
            string = string?.replacingOccurrences(of: "]", with: "")
            string = string?.replacingOccurrences(of: "[", with: "")
            tlPrint(message: "string:\(String(describing: string))")
            self.sysMsgDeal(msg: string as AnyObject, success: { (sysMsg) in
                success(sysMsg)
            })
            
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
        })
    }
    
    //处理系统消息数据
    func sysMsgDeal(msg:AnyObject,success:@escaping(([[String:Any]])->())) -> Void {
        tlPrint(message: "sysMsgDeal msg:\(msg)")
        var sysDataSource:[[String:Any]] = [["Id":0,"UserId":"","AlreadyRead":true,"Content":"","Created":""]]
        let sysInfoArray = msg.components(separatedBy: ",")
        tlPrint(message: "sysInfo: \(sysInfoArray)")
        var currentDate = NSDate.getDate(type: .all)
        currentDate = currentDate.replacingOccurrences(of: "/", with: "-")
        
        
        for i in 0 ..< sysInfoArray.count {
            let info = ["Id":0,"UserId":000000,"AlreadyRead":true,"Content":sysInfoArray[i],"Created":currentDate] as [String : Any]
            sysDataSource.append(info)
        }
        sysDataSource.remove(at: 0)
        success(sysDataSource)
    }
    
    //获取站内信未读数据
    func getInternalMsgCount(success:@escaping((String)->())) -> Void {
        tlPrint(message: "getSysMsg")
        futuNetworkRequest(type: .get, serializer: .http, url: self.unReadMsgCountAddr, params: ["":""], success: { (response) in
            tlPrint(message: "response:\(response)")
            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
            string = string?.replacingOccurrences(of: "\"", with: "")
            string = string?.replacingOccurrences(of: "\\", with: "")
            tlPrint(message: "string:\(String(describing: string))")
            string = (string == "") ? "0" : string
            success(string!)
            
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
        })
    }
    
    //获取站内信数据
    func getInternalMsg(success:@escaping(([[String:Any]])->())) -> Void {
        
        futuNetworkRequest(type: .post, serializer: .http, url: self.getInternalMsgAddr, params: ["PageIndex":0,"PageSize":8], success: { (response) in
            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
            string = string?.replacingOccurrences(of: "}]}\"", with: "}]}")
            string = string?.replacingOccurrences(of: "\"{\\\"", with: "{\\\"")
            string = string?.replacingOccurrences(of: "\\", with: "")
            
            self.internalMsgDeal(msg: string as AnyObject, success: { (internalMsg) in
                success(internalMsg)
            })
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
        })
    }
    
   
    //处理站内信数据
    func internalMsgDeal(msg:AnyObject?,success:@escaping(([[String:Any]])->())) -> Void {
        tlPrint(message: "internalMsgDeal  msg:\(String(describing: msg))")
        
        
        if msg == nil || msg as! String == "" {
            tlPrint(message: "没有消息")
//            let alert = UIAlertView(title: "", message: "没有新的消息！", delegate: nil, cancelButtonTitle: "知道了")
//            DispatchQueue.main.async {
//                alert.show()
//            }
            //success([["Content": "没有新的消息", "Created": "", "UserId": 0, "AlreadyRead": true, "Id": 0]])
            success([["":""]])
            return
        }
        var internalDataSource:[[String:Any]] = [["Id":0,"UserId":"","AlreadyRead":true,"Content":"","Created":""]]
//        let infoKeys = ["Id","UserId","AlreadyRead","Content","Created"]
        tlPrint(message: "msg = \(String(describing: msg))")
        var allInfoDic = (msg as! String).objectFromJSONString() as? Dictionary<String, Any>
        tlPrint(message: "allInfoDic:\(String(describing: allInfoDic))")
        if allInfoDic != nil {
            
        } else {
            tlPrint(message: "没有消息获取到")
            success([["":""]])
            return
        }
        if (allInfoDic!["TotalPages"] as! Int) <= 0 {
            tlPrint(message: "没有消息")
            success([["":""]])
            return
        }
        
        let messages = allInfoDic!["Messages"]
        let messageArray = messages as! Array<Any>
        if let totlePage = allInfoDic!["TotalPages"] {
            if (totlePage as! Int) == 0 {
                tlPrint(message: "没有消息获取到")
                return
            }
        }
        //{"TotalPages":0,"Messages":[]}
        //{"TotalPages":1,"Messages":[{"Id":4403}]}
        
//        if messages == nil || messages ==  {
//            tlPrint(message: "消息为空")
//            return
//        }
        
        for i in 0 ..< messageArray.count {
            tlPrint(message: "messageArray[\(i)] = \(messageArray[i])")
            let message = messageArray[i] as! Dictionary<String,Any>
            let id = message["Id"]
            let userId = message["UserId"]
            let alreadyRead = message["AlreadyRead"]
            let content = message["Content"]
            var created = message["Created"] as! String
            created = created.replacingOccurrences(of: "T", with: " ")
            created = created.substring(to: created.index(created.startIndex, offsetBy: 16))
            let value = ["Id":id!,"UserId":userId!,"AlreadyRead":alreadyRead!,"Content":content!,"Created":created]
            tlPrint(message: "value:\(value)")
            
            internalDataSource.append(value)
        }
        internalDataSource.remove(at: 0)
        tlPrint(message: "internalDataSource:\(internalDataSource)")
        success(internalDataSource)

    }
    
    
    func getActivityInfo(success:@escaping(([[String:Any]]!)->())) -> Void {
        
        futuNetworkRequest(type: .get, serializer: .http, url: "Content/tsconfig.txt", params: ["":""], success: { (response) in
            tlPrint(message: "respose:\(response)")
            
            self.activityInfoDeal(info: response as AnyObject, success: { (activityInfo) in
                tlPrint(message: "处理完毕 activityInfo = \(activityInfo)")
                success(activityInfo)
            })
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
        })
    }
    
    func activityInfoDeal(info:AnyObject,success:@escaping(([[String:Any]]!)->())) -> Void {
        tlPrint(message: "activityInfoDeal  info:\(info)")
        var activityData:[[String:Any]] = [["imgUrl":"","link":"","type":""]]
        var string = String(data: info as! Data, encoding: String.Encoding.utf8)
        tlPrint(message: "string0:\(String(describing: string))")
        if string == nil {
            userDefaults.setValue(nil, forKey: userDefaultsKeys.messageInfo.rawValue)
            self.activityDataSource = nil
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
        
        let activityArray = activityDic["OfferList"] as! Array<Any>
        
        for i in 0 ..< activityArray.count {
            tlPrint(message: "activityArray[\(i)] = \(activityArray[i])")
            let activityValue = activityArray[i] as! Dictionary<String,Any>
            let imgUrl = activityValue["imgUrl"]
            let link = activityValue["link"]
            let type = activityValue["type"]
            let value = ["imgUrl":imgUrl!,"link":link!,"type":type!,]
            tlPrint(message: "value:\(value)")
            activityData.append(value)
        }
        activityData.remove(at: 0)
        tlPrint(message: "activityData:\(activityData)")
        self.activityDataSource = activityData
        success(activityData)
    }
    
    //*********************************************************
    //         鸿福体育网络请求函数
    //*********************************************************
    func activityNetworkRequest(type:NetworkRequestType,serializer:NetworkRequestType,url:String, params:Dictionary<String, Any>,success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) -> Void {
        
        var token:String = ""
        if let token_t = userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue){
            token = token_t as! String
        }
        let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
        
        let url = domain + url
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
                    let string = String(data: responseObject as! Data, encoding: String.Encoding.utf8)
                    tlPrint(message: "string7777:\(String(describing: string))")
                    success(responseObject ?? "")
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

    
    
    func dataToArray(data:Data) -> Array<Any> {
        tlPrint(message: "dataToArray")
        let array = NSKeyedUnarchiver.unarchiveObject(with: data) as! Array<Any>
        return array
    }
}
