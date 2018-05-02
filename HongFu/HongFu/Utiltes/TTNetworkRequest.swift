//
//  TTNetworkRequest.swift
//  FuTu
//
//  Created by Administrator1 on 1/10/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit


/*!
 *  @author Taylor Tan
 *
 *  网络请求枚举类型
 *  @param  ttNetworkRequestGet         GET方式的网络请求
 *  @param  ttNetworkRequestPost        POST方式的网络请求
 *  @param  ttNetworkRequestDownload    文件下载
 *  @param  ttNetworkRequestUpload      文件上传
 */

public enum ttNetworkRequestType {
    case ttNetworkRequestGet
    case ttNetworkRequestPost
    case ttNetworkRequestDownload
    case ttNetworkRequestUpload
}

/*!
 *  @author Taylor Tan
 *
 *  网络请求返回值存储结构体
 *  @param  isSucess            请求是否成功
 *  @param  response            返回的内容，如果成功返回的是我们需要的内容，如果失败返回的是错误Error
 */
public struct ttNetworkRequestFeedback {
    let isSucess: Bool
    let response: Any
}



class TTNetworkRequest: NSObject {

    //==========================
    // MARK:- URLSession get请求
    //==========================
    func getWithPath(path: String,paras: Dictionary<String,Any>?,success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) {
        
        var i = 0
        var address = path
        if let paras = paras {
            for (key,value) in paras {
                
                if i == 0 {
                    address += "?\(key)=\(value)"
                }else {
                    address += "&\(key)=\(value)"
                }
                i += 1
            }
        }
        
        let url = URL(string: address.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, respond, error) in
            if let data = data {
                if let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    
                    success(result)
                }
            }else {
                failure(error!)
            }
        }
        dataTask.resume()
    }
    
    //==========================
    // MARK:- URLSession post请求
    //==========================
    func postWithPath(path: String,paras: Dictionary<String,Any>?,success: @escaping ((_ result: Any?) -> ()),failure: @escaping ((_ error: Error) -> ())) {
        
        var i = 0
        var address: String = ""
        
        if let paras = paras {
            
            for (key,value) in paras {
                if i == 0 {
                    address += "\(key)=\(value)"
                } else {
                    address += "&\(key)=\(value)"
                }
                i += 1
            }
        }
        let url = URL(string: path)
        var request = URLRequest.init(url: url!)
        request.httpMethod = "POST"
        print(address)
        request.httpBody = address.data(using: .utf8)
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, respond, error) in
            tlPrint(message: "data: \(String(describing: data))")
            tlPrint(message: "respond: \(String(describing: respond))")
            tlPrint(message: "error: \(String(describing: error))")
            if let data = data {
                if let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    success(result)
                } else { //返回数据不正确
                    //success(["error":"","error_description":"用户名或密码不正确"])
                    success(nil)
                }
            } else {
                failure(error!)
            }
        }
        dataTask.resume()
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*!
     *  @author Taylor Tan
     *
     *  网络请求
     *
     *  @param requestType              网络请求的类型（GET,POST,Download,Upload）
     *  @param url                      请求的网络地址
     */
    func ttNetworkRequest(requestType: ttNetworkRequestType,baseUrl: String?, url: String?, params: Dictionary<String,Any>?, refreshCash: Bool) -> ttNetworkRequestFeedback{
        
        var feedBack = ttNetworkRequestFeedback(isSucess: false, response: "")
        switch requestType {
        case .ttNetworkRequestGet:
            tlPrint(message: "get")
            if let path = url {
                feedBack = ttNetworkGetRequest(baseUrl: nil, url: path)
            }
            
        case .ttNetworkRequestPost:
            if let path = url  {
                if let paramter = params {
                    feedBack = ttNetworkPostRequest(baseUrl: baseUrl, url: path, params: paramter)
                }
            }
            
        case .ttNetworkRequestDownload:
            tlPrint(message: "")
        case .ttNetworkRequestUpload:
            tlPrint(message: "")

        }
        return feedBack
    }
    
    
    /*!
     *  @author Taylor Tan
     *
     ＊  网络配置
     *
     *  @param baseUrl              基准地址
     *
     */
    public func ttNetworkConfigure(baseUrl:String?) {
    
        if let base = baseUrl {//base 不为nil则更新
            
            tlPrint(message: "base url is: \(base)")
            TTNetworking.updateBaseUrl(base)
        }
        
        TTNetworking.enableInterfaceDebug(true)
        TTNetworking.configRequestType(.plainText,
                                       responseType: .JSON,
                                       shouldAutoEncodeUrl: true,
                                       callbackOnCancelRequest: false)
        
        //TTNetworking.cacheGetRequest(true, shoulCachePost: true)
        
        TTNetworking.cacheGetRequest(false, shoulCachePost: false)
    }
    
    /*!
     *  @author Taylor Tan
     *
     *  Get请求
     *
     *  @param baseUrl              基准地址
     *
     *
     *
     */
    private func ttNetworkGetRequest(baseUrl:String?, url:String) -> ttNetworkRequestFeedback {
    
        
        ttNetworkConfigure(baseUrl: baseUrl)
        
        var isSucessFeedBack = false
        var responseFeedBack: Any = ""
        //同步线程，获得请求反馈以后再返回
        _ = DispatchQueue.global().sync {
            TTNetworking.getWithUrl(url, refreshCache: false, params: nil, progress: { (bytesRead, totleBytesRead) in
                
                tlPrint(message: "progress: \(bytesRead/totleBytesRead)%  in \(totleBytesRead)")
                
                }, success: { (response) in
                    
                    tlPrint(message: "get response success: \(response!)")
                    isSucessFeedBack = true
                    responseFeedBack = response ?? "response"
                    
            }) { (error) in
                
                tlPrint(message: "get response error : \(String(describing: error))")
                isSucessFeedBack = false
                responseFeedBack = error ?? "error"
            }
            
            
            DispatchQueue.main.async(execute: {
                tlPrint(message: "isSuccess: \(isSucessFeedBack)")
                tlPrint(message: "infomation: \(responseFeedBack)")
                
                tlPrint(message: "prepare to return.")

                
            })
        }
        
        tlPrint(message: "prepare to return.")
        return ttNetworkRequestFeedback(isSucess: isSucessFeedBack, response: responseFeedBack)
    }
    
    
    /*!
     *  @author Taylor Tan
     *
     *  Post请求
     *
     *  @param baseUrl              基准地址
     *
     */
    private func ttNetworkPostRequest(baseUrl:String?, url:String, params:Dictionary<String,Any>) -> ttNetworkRequestFeedback {

        ttNetworkConfigure(baseUrl: baseUrl)
        
        var isSucessFeedBack = false
        var responseFeedBack: Any = ""
        
        _ = DispatchQueue.global().sync {
            TTNetworking.post(withUrl: url, refreshCache: false, params: params, progress: { (bytesRead, totleBytesRead) in
                
                tlPrint(message: "post progress: \(bytesRead/totleBytesRead)%  in \(totleBytesRead)")
                
                }, success: { (response) in
                    
                    tlPrint(message: "post success response: \(String(describing: response))")
                    isSucessFeedBack = true
                    responseFeedBack = response ?? "response"
                    
                }, fail: { (error) in
                    
                    tlPrint(message: "post error: \(String(describing: error))")
                    isSucessFeedBack = false
                    responseFeedBack = error ?? "error"
            })
            
//            DispatchQueue.main.sync(execute: {
//                
//                tlPrint(message: "post main process")
//                
//            })
        }
        
        
        tlPrint(message: "prepare to return.")
        return ttNetworkRequestFeedback(isSucess: isSucessFeedBack, response: responseFeedBack)
    }
    
    
    
    
    /*!
     *  @author Taylor Tan
     *
     *  网络下载请求
     *
     *  @param baseUrl              基准地址
     *
     */
    private func ttNetworkDownloadRequest() {
    
        let path = NSHomeDirectory() as NSString
        path.strings(byAppendingPaths: ["Documents/b.zip"])
        
        tlPrint(message: "document path:\(path)")
        
        let url = "http://wiki.lbsyun.baidu.com/cms/iossdk/sdk/BaiduMap_IOSSDK_v2.10.2_All.zip"
        TTNetworking.download(withUrl: url, saveToPath: path as String!, progress: { (byteRead, totleByteRead) in
            
            tlPrint(message: "download: \(byteRead/totleByteRead)% in totle: \(totleByteRead)")
            
            }, success: { (response) in
                
                tlPrint(message: "download response: \(String(describing: response))")
                
            }) { (error) in
                
                tlPrint(message: "download error: \(String(describing: error))")
        }
    }
    
    
    
    
}
