////
////  ActivityDetailModel.swift
////  FuTu
////
////  Created by Administrator1 on 30/12/16.
////  Copyright © 2016 Taylor Tan. All rights reserved.
////
//
//import UIKit
//
//enum ActivityDetailTag:Int {
//    case backBtnTag = 10,joinBtnTag
//}
//class ActivityDetailModel: NSObject {
//
//    let userDefaults = UserDefaults.standard
//    let activityAPIAddr = webApi + "/api/Active/GetActiveById"
//    
//    func getActivityInfo(id:Int,success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) -> Void {
//        tlPrint(message: "getActivityInfo id:\(id)")
//        let token = userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue)
//        let url = activityAPIAddr
//        //网络请求
////        var returnValue: NSMutableDictionary = NSMutableDictionary()
//        //字符串的转码
//        let urlString = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
//        //创建管理者对象
//        let manager = AFHTTPSessionManager()
//        //设置允许请求的类别
//        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/plain", "text/json", "application/json","charset=utf-8","text/javascript","text/html", "application/javascript", "text/js") as? Set<String>
//        manager.securityPolicy.allowInvalidCertificates = true
//        //数据类型选择
//        manager.requestSerializer = AFJSONRequestSerializer()
//        manager.responseSerializer = AFJSONResponseSerializer()
//        //manager.requestSerializer = AFHTTPRequestSerializer()
//        //manager.responseSerializer = AFHTTPResponseSerializer()
//        //验证信息
//        if let token = token {
//            manager.requestSerializer.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
//        //let headers = manager.requestSerializer.httpRequestHeaders
//        DispatchQueue.global().sync {
//            tlPrint(message: "进入了队列")
//            manager.get(urlString, parameters: ["classId":id], progress: { (downloadProgress) in
//                
//            }, success: { (task, responseObject) in
//                tlPrint(message: "成功 \n responseObject:\(String(describing: responseObject))")
//                success(responseObject)
//            }, failure: { (task, error) in
//                tlPrint(message: "请求失败\n ERROR:\n\(error)")
//                failure(error)
//            })
//            
//        }
//    }
//}
