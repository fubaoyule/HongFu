//
//  FuTuPayNetworking.swift
//  FuTu
//
//  Created by Administrator1 on 13/10/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class FuTuPayNetworking: NSObject {
    
    class func httpPostRequest(urlString: String, token: String?, params: Dictionary<String,Any>, returnNotificationName:notificationName?,viewController:RechargeViewController) -> Void {
        
        var returnValue: NSMutableDictionary? = NSMutableDictionary()
        //字符串的转码
        let urlString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        //创建管理者对象
        let manager = AFHTTPSessionManager()
        
        //设置允许请求的类别
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/plain", "text/json", "application/json","charset=utf-8","text/javascript","text/html", "application/javascript", "text/js") as? Set<String>

        let securiutyPolicy = AFSecurityPolicy.default()
        securiutyPolicy.allowInvalidCertificates = true
        manager.securityPolicy = securiutyPolicy
        
        //数据类型选择
//        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.requestSerializer = AFHTTPRequestSerializer()
       // manager.responseSerializer = AFHTTPResponseSerializer()
        
        //验证信息
        if let currentToken = token {
            manager.requestSerializer.setValue("Bearer \(currentToken)", forHTTPHeaderField: "Authorization")
        } else {
            tlPrint(message: "未能获取到用户token")
        }
        
//        let notificationCenter = NotificationCenter.default
        DispatchQueue.global().sync {
            tlPrint(message: "进入了队列")
            tlPrint(message: params)
            manager.post(urlString, parameters: params, progress: { (downloadProgress) in
                
                }, success: { (task, responseObject) in
                    tlPrint(message: "成功")
                    tlPrint(message: "responseObject:\(String(describing: responseObject))")
                    //数据解析
                    returnValue = responseObject as? NSMutableDictionary
                    tlPrint(message: "returnNotificationName = \(String(describing: returnNotificationName))")
                    if returnNotificationName != nil {
                        //参数里面给了通知名称，执行完毕消息通知
                        if let returnData = returnValue {
                            //收到数据通知ViewController,且将数据传递过去
                            viewController.paymentDeal(sender: returnData as! Dictionary<String, Any>)
                        }
                    } else {
                    
                        tlPrint(message: "returnNotificationName2 = \(String(describing: returnNotificationName))")
                    }
                    
                }, failure: { (task, error) in
                    tlPrint(message: "请求失败\nERROR:\n\(error)")
                    
                    //如果返回未授权，则表示在别处登陆
                    if "\(error)".range(of: "unauthorized") != nil  {
                        //test
                        let loginAlert = UIAlertView(title: "提示", message: "您的账户在别的地方登录，请重新登录！", delegate: self, cancelButtonTitle: "确 定")
                        loginAlert.show()
                        
                        LogoutController.logOut()
                        let loginVC = LoginViewController()
                        viewController.navigationController?.pushViewController(loginVC, animated: true)
                        return
                    }
                    
                    DispatchQueue.main.async(execute: {

                        let alert = UIAlertView(title: "充值失败", message: "网络请求错误，请联系客服", delegate: self, cancelButtonTitle: "确认")
                        alert.show()
                    })
                
                    let errors = error as AnyObject
                    if (errors.value(forKey: "code") as! Int == NSURLErrorCancelled) {
                        tlPrint(message: "error cancelled")
                        return
                    }
            })
        }
        tlPrint(message: "disReturn")
        //return returnValue
    }
    
    class func httpGetRequest(urlString: String,token: String?) -> Void {
        
        
        tlPrint(message: "http request value: \nurlString:\(urlString)\ntoken:\(String(describing: token))")
        
        //字符串的转码
        let urlString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        //创建管理者对象
        let manager = AFHTTPSessionManager()
        
        //设置允许请求的类别
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/plain", "text/json", "application/json","charset=utf-8","text/javascript","text/html", "application/javascript", "text/js") as? Set<String>
        manager.securityPolicy.allowInvalidCertificates = true
        
        //数据类型选择
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        //验证信息
        if let token = token {
            manager.requestSerializer.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        DispatchQueue.global().sync {
            tlPrint(message: "进入了队列")
            
            manager.get(urlString, parameters: nil, progress: { (progress) in
                
                }, success: { (task, response) in
                    tlPrint(message: "response:\(String(describing: response))")
                }, failure: { (task, error) in
                    tlPrint(message: "error:\(error)")
                    
            })
        }
        tlPrint(message: "disReturn")
        //return returnValue
    }

    
    
    
    
      
}
