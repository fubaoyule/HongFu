//
//  LoginModel.swift
//  FuTu
//
//  Created by Administrator1 on 26/10/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

//登录框状态枚举
enum LoginShowType {
    case NONE
    case USER
    case PASS
}
enum LoginTag:Int {
    case loginBtnTag = 10,forgetBtnTag,registerBtnTag,HomeBtnTag
    case userText = 20, passText
}

class LoginModel: NSObject {

    //分割线的颜色
    let lineViewColor = UIColor(white: 0.5, alpha: 0.5)
    
    //当前屏幕的尺寸
    let size = UIScreen.main.bounds.size
    
    //屏幕颜色
    let screenColor = UIColor.white
    
    //头像距离顶部的距离
    let headImgTop = UIScreen.main.bounds.size.height * 0.2
    
    //头像视图的宽度
    let headImgWidth = UIScreen.main.bounds.size.width * 0.2
    
    
    
    func getEmailRedbag(success:@escaping((Dictionary<String,Any>))->(),failure:@escaping(()->())) -> Void {
        let url = "Active/GetEmailRedbag"
        futuNetworkRequest(type: .post, serializer: .http, url: url, params: nil, success: { (response) in
            tlPrint("respones:\(response)")
            
            let string = String(data: response as! Data, encoding: String.Encoding.utf8)
            tlPrint(message: "string:\(String(describing: string))")
            if string == "Failed" || string == "\"Failed\"" || string == "\"null\"" {
                tlPrint(message: "error string: \(String(describing: string))")
                failure()
                return
            }
            let resultDic = (string)?.objectFromJSONString() as! Dictionary<String, Any>
            success(resultDic)
            
            
        }) { (error) in
            tlPrint("Error:\(error)")
            failure()
        }
    }
    
    
    
//    
//    let userDefaults = UserDefaults.standard
//    func loginRequest(paras: Dictionary<String, String>, username: String, password:String,loginBtn:UIButton) -> Void {
//        
//        let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
//        let url = domain + loginApi
//        let networking = TTNetworkRequest()
//        networking.postWithPath(path: url, paras: paras, success: { (response) in
//            //接收返回数据
//            tlPrint(message: "response:\(response)")
//            
//            let value = response as AnyObject
//            DispatchQueue.main.async {
//                //允许点击登录按钮
//                loginBtn.isUserInteractionEnabled = true
//            }
//            self.longinReturnDeal(response: value, username: username, password: password, isLoginPage: true)
//        }) { (error) in
//            tlPrint(message: "error:\(error)")
//            DispatchQueue.main.async {
//                //允许点击登录按钮
//                loginBtn.isUserInteractionEnabled = true
//            }
//        }
//    }
//    
//    //================================
//    //Mark:- 登录数据返回处理函数
//    //================================
//    func longinReturnDeal(response: AnyObject, username:String, password: String, isLoginPage: Bool) -> Void {
//        
//        tlPrint(message: "longin Return deal sender: \(response)")
//        DispatchQueue.main.async {
//            //停止loading图标
//            if self.indicator != nil {
//                self.indicator.stop()
//                self.view.isUserInteractionEnabled = true
//            }
//        }
//        if let token_t = response.value(forKey: "access_token") {
//            //登录成功
//            tlPrint(message: "登录成功")
//            //将用户名、密码和Token写入数据库
//            userDefaults.setValue(token_t as! String, forKey: userDefaultsKeys.userToken.rawValue)
//            userDefaults.setValue(username, forKey: userDefaultsKeys.userName.rawValue)
//            userDefaults.setValue(password, forKey: userDefaultsKeys.passWord.rawValue)
//            userDefaults.setValue(true, forKey: userDefaultsKeys.userHasLogin.rawValue)
//            userDefaults.synchronize()
//            
//            DispatchQueue.main.async(execute: {
//                let token = token_t as! String
//                let notification = NotificationCenter.default
//                let userToken:Dictionary<String,String> = ["request":"login","token": token]
//                notification.post(name: NSNotification.Name(rawValue: notificationName.LoginCallWebPage.rawValue), object: userToken)
//                if isLoginPage {
//                    _ = self.navigationController?.popViewController(animated: true)
//                }
//            })
//            //self.dismiss(animated: true, completion: nil)
//        } else if response.value(forKey: "error") != nil {
//            
//            DispatchQueue.main.async(execute: {
//                let errorMessage = response.value(forKey: "error_description") as! String
//                let alert = UIAlertView(title: "登录失败", message: errorMessage, delegate: self, cancelButtonTitle: "确定")
//                alert.show()
//            })
//        } else {
//            tlPrint(message: "failed")
//            DispatchQueue.main.async(execute: {
//                let alert = UIAlertView(title: "登录失败", message: "用户名或密码不正确", delegate: self, cancelButtonTitle: "确定")
//                alert.show()
//            })
//        }
//    }
    
}


