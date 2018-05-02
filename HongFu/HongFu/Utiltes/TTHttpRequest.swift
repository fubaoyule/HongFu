//
//  TTHttpRequest.swift
//  FuTu
//
//  Created by Administrator1 on 7/10/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class TTHttpRequest: NSObject {
    
    //只做请求之前的事情，通用
    class func httpPostConfig() {
    
    }

    class func httpPostRequest(urlString: String,token: String?, params: NSMutableDictionary, returnNotificationName:notificationName?) -> Void {
        
        
//        tlPrint(message: "http request value: \nurlString:\(urlString)\ntoken:\(String(describing: token))\nparams:\(params)")
        
        var returnValue: NSMutableDictionary = NSMutableDictionary()
        
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
        //let headers = manager.requestSerializer.httpRequestHeaders
        let notificationCenter = NotificationCenter.default
        DispatchQueue.global().sync {
            tlPrint(message: "进入了队列")
            manager.post(urlString, parameters: params, progress: { (downloadProgress) in
                
                }, success: { (task, responseObject) in
                    tlPrint(message: "成功")
                    tlPrint(message: "responseObject:\(String(describing: responseObject))")
                    //数据解析
                    returnValue = responseObject as! NSMutableDictionary
                    
                    if let returnNotification = returnNotificationName {
                        //参数里面给了通知名称，执行完毕消息通知
                        //收到数据通知ViewController,且将数据传递过去
                        
                        notificationCenter.post(name: NSNotification.Name(returnNotification.rawValue), object: returnValue)
                    }
                    
                }, failure: { (task, error) in
                    tlPrint(message: "请求失败\nERROR:\n\(error)")
            })
        }
        //return returnValue
    }
    
    //消息通知
    //NSNotificationCenter.defaultCenter().postNotificationName("modifyPasswordStep2", object: passwordDic)

    class func httpSessionPostTest() -> Void {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        let url = URL(string: "http://eyeforweb.info.bh-in-15.webhostbox.net/myconnect/api.php") //pass your url
        
        
        let request = NSMutableURLRequest(url: url!,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 60.0)
        
        request.addValue("", forHTTPHeaderField: "")
        request.addValue("*/*", forHTTPHeaderField: "Accept")
        
        request.httpMethod = "POST"
        let data = "login=pradeep.kumar@eyeforweb.com&password=admin123"
        
        let postData = data.data(using: String.Encoding.utf8)
        
        
        
        request.httpBody = postData
        
        tlPrint(message: "session test ----- 1")
        
        _ = session.dataTask(with: request as URLRequest) { (data, response, error) in
            tlPrint(message: "session test ----- 2")
            if error == nil {
                tlPrint(message: "session test ----- 3")
                let httpResponse: HTTPURLResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    tlPrint(message: "session test ----- 4")
                    var dict: NSDictionary? = nil
                    do {
                        tlPrint(message: "session test ----- 5")
                        dict = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.init(rawValue:0)) as? NSDictionary
                    } catch {
                        tlPrint(message: "session test ----- 6")
                    }
                    
                    let isSuccess = dict?.object(forKey: "success") as! NSInteger
                    if isSuccess == 1 {
                        tlPrint(message: "session test ----- 7")
                        tlPrint(message: "login success")
                    } else {
                        tlPrint(message: "session test ----- 8")
                        tlPrint(message: "login fial")
                    }
                    tlPrint(message: "session test ----- 9")
                }
            } else {
                tlPrint(message: "session test ----- 10")
                tlPrint(message: "erorr:\(String(describing: error))")
            }
        }
    }
    
    class func httpConnectionPostTest() -> Void {
        
        let path = "http://api.toobet.com/api/MobileOnlineDeposit/OnlineProcess"
        let params: NSMutableDictionary = NSMutableDictionary()
        params["Amount"] = 50
        params["paytype"] = "1"
        // 1. URL
        let url = NSURL(string: path)
        // 2. 请求(可以改的请求)
        let request = NSMutableURLRequest(url: url! as URL)
        // ? POST
        // 默认就是GET请求
        request.httpMethod = "POST"
        
        let headers = "Hy2b3qWlLVBk4_CTK9EMhnd_Xl_Czhmlh5rPCXQbgMjw6FMVJMqYp0PWd0RWFs-W8FTekyGCwPvq8tZTzAEpBQ3K1-bTZIs0ARihN5yyyi1jc9LWu61RBhuv2PZB7wxArFShd4YRZu6AkHpvHx1sG2V7zkHrUfVnal6yL5xmmMOWkCF7apthYUmK3G6rxUe6Re7wK6eUBKISXclnfO8xVENm93fV2K98x7l6Sbc9JH8Azyidg0db6tzJspD4gox9bjIyi4o9Op77tNQmYBW1WsFCTf-NvQ-mnC03MTB6621Dc0VNya7hRd26huk-xBFzv_AdhZam3u4kgWR9ersoyZEVE9-huroDjv6qWlvXnHm6p26rOSimzkdpR22Er-AYBAFKOLKk57jjzZ4JcWtfLR24d_51GikbzZmyeVdPU-E"
        request.addValue(headers, forHTTPHeaderField: "Authorization")
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        // ? 数据体
        var jsonData: Data? = nil
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: params, options:JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
        }
        
        tlPrint(message: "jsonData = \(jsonData!)")
        // 将字符串转换成数据
        request.httpBody = jsonData
        
        
        // 3. 连接,异步
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue()) { (response, data, error) in
            if error == nil {
                var dict: NSDictionary? = nil
                do {
                    dict = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.init(rawValue:0)) as? NSDictionary
                } catch {
                }
                
                //取data的值
                let data:NSDictionary = dict!["data"] as!  NSDictionary
                //取token的值
                let token = data["token"]as! String
                tlPrint(message: token)
                
            } else {
                tlPrint(message: "error:\n\(String(describing: error))")
            }
        }
    }
    
    class func httpPostTest() -> Void {
        
        let postUrl = "http://api.toobet.com/api/MobileOnlineDeposit/OnlineProcess"
        let postParam: Dictionary<String,Any> = ["Amount":50, "paytyme":"1"]
        
        var isVerifySuccess = false //后台验证成功
        DispatchQueue.global().sync {
            
            _ = TTNetworking.post(withUrl: postUrl, refreshCache: true, params: postParam, success: { (response) in
                //请求成功
                let isSucess = response?.value(forKey: "isSucess") as! Bool
                
                if isSucess {
                    //返回值为成功
                    let orderModel = response?.value(forKey: "OrderModel")
                    let returnMessage = response?.value(forKey: "isSucess")
                    if  let message = returnMessage {
                        tlPrint(message: "pay success, message:\(message)")
                        
                        if let order = orderModel {
                            tlPrint(message: "pay success, orderInfor:\(order)")
                            isVerifySuccess = true
                        } else {
                            isVerifySuccess = false
                        }
                    } else {
                        isVerifySuccess = false
                    }
                    
                    
                } else {
                    //返回值为失败
                    isVerifySuccess = false
                    let returnMessage = response?.value(forKey: "isSucess")
                    if  let message = returnMessage {
                        tlPrint(message: "pay fail, message:\(message)")
                    } else {
                        
                    }
                }
                
                }, fail: { (error) in
                    //请求失败
                    tlPrint(message: "--->  request error")
                    tlPrint(message: "request fail, Error:\(String(describing: error))")
                    isVerifySuccess = false
            })
            
            
            
            DispatchQueue.main.async(execute: {
                if isVerifySuccess {
                    tlPrint(message: "")
//                    let info = ["product_name":"存款", "order_amount":"0.01", "notify_url":"http://192.168.1.178:3080/return/return.jsp" ]
                    
                    //self.dinpay(sender: info as AnyObject)
                } else {
                    tlPrint(message: "isVerifySuccess is false")
                }
            })//DispatchQueue.main.async
        }
    }
    
    
    class func httpGetTest () -> Void {
        let url = "http://swiftdeveloperblog.com/my-http-get-example-script/"
        
        var isSucessFeedBack = false
        var responseFeedBack: Any = ""
        
        DispatchQueue.global().sync {
            _ = TTNetworking.getWithUrl(url, refreshCache: true, params: nil, progress: { (bytesRead, totleBytesRead) in
                
                tlPrint(message: "progress: \(bytesRead/totleBytesRead)%  in \(totleBytesRead)")
                }, success: { (response) in
                    
                    tlPrint(message: "get response success: \(response!)")
                    isSucessFeedBack = true
                    responseFeedBack = response ?? "response"
                    
                    let value = response?.value(forKey: "Message")
                    tlPrint(message: "---------> value = \(String(describing: value))")
                    
            }) { (error) in
                
                tlPrint(message: "get response error : \(String(describing: error))")
                isSucessFeedBack = false
                responseFeedBack = error ?? "error"
            }
            DispatchQueue.main.async(execute: {
                tlPrint(message: "isSuccess: \(isSucessFeedBack)")
                tlPrint(message: "infomation: \(responseFeedBack)")
            })
        }
    }
    
}
