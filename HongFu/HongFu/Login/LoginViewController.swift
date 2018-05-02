 //
//  LoginViewController.swift
//  FuTu
//
//  Created by Administrator1 on 27/10/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//  tag: 10+

import UIKit



class LoginViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate, UIScrollViewDelegate,BtnActDelegate {

    
    //用户名、密码输入框
    var currentTextField,userNameTextField,passWordTextField: UITextField!
    var loginBtn,forgetBtn,registerBtn: UIButton!
    var homeVC:CustomTabBarController!
    var appUpdateUrl = ""
    
    //基础控件
    var baseVC: BaseViewController!
    var size = UIScreen.main.bounds.size
    var model = LoginModel()
    var indicator: TTIndicators!
    let userDefaults = UserDefaults.standard
    let initFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    override func viewDidLoad() {
        super.viewDidLoad()

//        //上线之前必须开启
//        self.requestLatestInfo()
//        isPhone = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiom.phone)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
        let loginView = LoginView(frame: self.view.frame, rootVC: self)
        self.view.addSubview(loginView)
        
        self.userNameTextField = loginView.viewWithTag(LoginTag.userText.rawValue) as! UITextField
        self.passWordTextField = loginView.viewWithTag(LoginTag.passText.rawValue) as! UITextField
        self.loginBtn = loginView.viewWithTag(LoginTag.loginBtnTag.rawValue) as! UIButton
        self.forgetBtn = loginView.viewWithTag(LoginTag.forgetBtnTag.rawValue) as! UIButton
        self.registerBtn = loginView.viewWithTag(LoginTag.registerBtnTag.rawValue) as! UIButton
        
        LogoutController.clearnUserInfo()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
            
        //新进入页面可以点击
        loginBtn.isUserInteractionEnabled = true
        forgetBtn.isUserInteractionEnabled = true
        registerBtn.isUserInteractionEnabled = true
        
        
        addUserInfoToTextField()        //将上一次的信息填入输入框
        self.autoLoginDeal()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //停止loading图标
        if self.indicator != nil {
            self.indicator.stop()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    //================================
    //Mark:- 填充用户名
    //================================
    func addUserInfoToTextField() -> Void {
        if let username = userDefaults.value(forKey: userDefaultsKeys.userName.rawValue) {
            userNameTextField.text = (username as! String).substring(from: "HF".endIndex)
        }
        passWordTextField.text = ""
    }
    
    
    
    //================================
    //Mark:- 登陆按钮点击方法
    //================================
    func logBtnAct() -> Void {
        tlPrint(message: "logBtnAct")
        //点击登录按钮，键盘消失
        if currentTextField != nil {
            currentTextField.resignFirstResponder()
        }
        
        var username = userNameTextField.text
        let password = passWordTextField.text
        
        if username == nil || username == "" {
            tlPrint(message: "请输入用户名")
            let alert = UIAlertView(title: "提示", message: "请输入用户名", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        } else if password == nil || password == "" {
            tlPrint(message: "请输入密码")
            let alert = UIAlertView(title: "提示", message: "请输入密码", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        username = "HF\(username!)"
        
        let info: Dictionary<String, String> = ["isApp":"2", "grant_type":"password","username":username!, "password":password!]
        
        tlPrint(message: "----------------------   \n        login info :\(info)\n-------------------------")
        
        if userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) == nil {
            tlPrint(message: "没有拿到域名")
            return
        }
        //加载loading图标
        if indicator == nil {
            indicator = TTIndicators(view: self.view, frame: portraitIndicatorFrame)
            
        }
        indicator.play(frame: portraitIndicatorFrame)
        self.view.isUserInteractionEnabled = false
        
        //loginBtn.isUserInteractionEnabled = false
        
        let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
        let url = domain + loginApi
        tlPrint(message: "url:\(url)")
//        futuNetworkRequest(type: .post, serializer: .http, url: "Token", params: info, success: { (response) in
//            //接收返回数据
//            tlPrint(message: "response:\(String(describing: response))")
//            let string = String(data: response as! Data, encoding: String.Encoding.utf8)
//            if string!.contains("failed") {
//                self.longinReturnDeal(response: ["error":"","error_description":"用户名或密码不正确"] as AnyObject, username: username!, password: password!, isLoginPage: true)
//            }
//            let loginDic = (string)?.objectFromJSONString() as! Dictionary<String, Any>
//            DispatchQueue.main.async {
//                //允许点击登录按钮
//                self.loginBtn.isUserInteractionEnabled = true
//            }
//            self.longinReturnDeal(response: loginDic as AnyObject, username: username!, password: password!, isLoginPage: true)
//        }) { (error) in
//            //允许点击登录按钮
//            self.view.isUserInteractionEnabled = true
//            DispatchQueue.main.async {
//                tlPrint(message: "\(url) 请求失败\n ERROR1:\n\(error)")
//
//                tlPrint(message: "\(url) 请求失败\n ERROR1:\n\(error!._userInfo!)")
//                tlPrint(message: "\(url) 请求失败\n ERROR1:\n\(error!._userInfo!["password-error"])")
//                tlPrint(message: "\(url) 请求失败\n ERROR:\n\(error!._userInfo?.value(forKey: "password-error"))")
//                tlPrint(message: "\(url) 请求失败\n ERROR:\n\(error!._userInfo?.value(forKey: "no-user"))")
//
////                tlPrint(message: "\(url) 请求失败\n ERROR:\n\(error?.localizedDescription)")
////                tlPrint(message: "\(url) 请求失败\n ERROR:\n\(error!._userInfo?.value(forKey: "password-error"))")
////                let errorData = error!._userInfo?.value(forKey: "com.alamofire.serialization.response.error.data")
////                let errorString = String(data: errorData as! Data, encoding: String.Encoding.utf8)
////                TLPrint("errorString: \(errorString)")
//
//
//                //停止loading图标
//                if self.indicator != nil {
//                    self.indicator.stop()
//                    self.view.isUserInteractionEnabled = true
//                }
//                let alert = UIAlertView(title: "登录失败", message: "当前出现网络错误，请检查网络连接状态后再试！", delegate: self, cancelButtonTitle: "确定")
//                alert.show()
//                }
//        }
        
        
        let networking = TTNetworkRequest()
        networking.postWithPath(path: url, paras: info, success: { (response) in
            //接收返回数据
            tlPrint(message: "response:\(String(describing: response))")
            DispatchQueue.main.async {
                //允许点击登录按钮
                self.loginBtn.isUserInteractionEnabled = true
            }
            if let value = response {
                self.longinReturnDeal(response: value as AnyObject, username: username!, password: password!, isLoginPage: true)
            } else {
                self.longinReturnDeal(response: ["error":"","error_description":"用户名或密码不正确"] as AnyObject, username: username!, password: password!, isLoginPage: true)
            }

        }) { (error) in
            tlPrint(message: "error:\(error)")
            //允许点击登录按钮
            self.view.isUserInteractionEnabled = true
            DispatchQueue.main.async {

                //停止loading图标
                if self.indicator != nil {
                    self.indicator.stop()
                    self.view.isUserInteractionEnabled = true
                }

                let alert = UIAlertView(title: "登录失败", message: "当前出现网络错误，请检查网络连接状态后再试！", delegate: self, cancelButtonTitle: "确定")
                alert.show()
            }
        }
    }
    
    enum ErrorToThrow: Error {
        case badRequest
    }
    
    
    
    
    //================================
    //Mark:- 登录数据返回处理函数
    //================================
    func longinReturnDeal(response: AnyObject, username:String, password: String, isLoginPage: Bool) -> Void {
        
        tlPrint(message: "longin Return deal sender: \(response)")
        
        DispatchQueue.main.async { 
            //停止loading图标
            if self.indicator != nil {
                self.indicator.stop()
                self.view.isUserInteractionEnabled = true
            }
        }
        if "\(response)" == "failed" {
            tlPrint(message: "登录失败")
            let alert = UIAlertView(title: "", message: "登录失败", delegate: nil, cancelButtonTitle: "确 定")
            DispatchQueue.main.sync(execute: { 
                alert.show()
            })
            return
        }
        
        if let token_t = response.value(forKey: "access_token") {
            //登录成功
            tlPrint(message: "登录成功")
            //将用户名、密码和Token写入数据库
            userDefaults.setValue(token_t as! String, forKey: userDefaultsKeys.userToken.rawValue)
            userDefaults.setValue(username, forKey: userDefaultsKeys.userName.rawValue)
            userDefaults.setValue(password, forKey: userDefaultsKeys.passWord.rawValue)
            userDefaults.setValue(true, forKey: userDefaultsKeys.userHasLogin.rawValue)
            userDefaults.synchronize()
            let isFirstLogin = userDefaults.value(forKey: userDefaultsKeys.isFirstLogin.rawValue)
            if isFirstLogin != nil && (isFirstLogin as! Bool){
                tlPrint(message: "是第一次登陆")
                //在各个平台注册游戏
                futuNetworkRequest(type: .get, serializer: .http, url: "Game/GameRegister", params: ["":""], success: { (response) in
                    tlPrint(message: "response:\(response)")
                    //修改第一次登录标识位
                    self.userDefaults.setValue(false, forKey: userDefaultsKeys.isFirstLogin.rawValue)
                }, failure: { (error) in
                    tlPrint(message: "error:\(error)")
                })
//                if let canGetEmailRedbag = userDefaults.value(forKey: userDefaultsKeys.canGetEmailRedbag.rawValue) {
//                    return
//                }
                
                //匹配邮箱，判断是否可以领取红包
//                self.model.getEmailRedbag(success: { (responseDic) in
//                    tlPrint("responseDic = \(responseDic)")
////                    let responseDic = ["amount": 0, "status": 0, "msg": "对不起，您不是邀请贵宾！"] as [String : Any]
//                    if responseDic["status"] as! Int == 0 {
//                        self.userDefaults.setValue(responseDic, forKey: userDefaultsKeys.emailRedbagMsg.rawValue)
//                        let notify = NSNotification.Name(rawValue: notificationName.EmailRedbagNotify.rawValue)
//                        NotificationCenter.default.post(name: notify, object: nil)
//                        
//                    }
//                }, failure: {
//                    tlPrint("error")
//                })
            }
            DispatchQueue.main.async(execute: {
                let token = token_t as! String
                let notification = NotificationCenter.default
                let userToken:Dictionary<String,String> = ["request":"login","token": token]
                notification.post(name: NSNotification.Name(rawValue: notificationName.LoginCallWebPage.rawValue), object: userToken)
                if self.homeVC == nil {
                    self.homeVC = CustomTabBarController()
                }
                self.homeVC.homeVC.getAccount()
                self.navigationController?.pushViewController(self.homeVC, animated: true)
            })
            
//            DispatchQueue.global().async {
//                let url = "Game/CheckStatus?strToken=\(token_t as! String)"
//                tlPrint(message: "url:\(url)")
//                futuNetworkRequest(type: .get, serializer: .http, url: url, params: ["":""], success: { (response) in
//                    tlPrint(message: "response:\(response)")
//                }, failure: { (error) in
//                    tlPrint(message: "error:\(error)")
//                })
//            }
            
            
            
        } else if response.value(forKey: "error") != nil {
            
            DispatchQueue.main.async(execute: {
                let errorMessage = response.value(forKey: "error_description") as! String
                let alert = UIAlertView(title: "登录失败", message: errorMessage, delegate: self, cancelButtonTitle: "确定")
                alert.show()
            })
        } else {
            tlPrint(message: "failed")
            DispatchQueue.main.async(execute: {
                let alert = UIAlertView(title: "登录失败", message: "用户名或密码不正确", delegate: self, cancelButtonTitle: "确定")
                alert.show()
            })
        }
    }
    
    
    //===========================================
    //Mark:- 已经登陆过，自动登录处理
    //===========================================
    func autoLoginDeal() -> Void {
        if homeVC == nil {
            homeVC = CustomTabBarController()
        }
        
        tlPrint(message: " autoLoginDeal")
        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
            if hasLogin as! Bool {      //用户已经登录
                if self.indicator == nil {
                    self.indicator = TTIndicators(view: self.view, frame: portraitIndicatorFrame)
                }
                self.indicator.play(frame: portraitIndicatorFrame)
                
                let network = TTNetworkRequest()
                let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
                let url = domain + loginApi
                let username = userDefaults.value(forKey: userDefaultsKeys.userName.rawValue) as! String
                let password = userDefaults.value(forKey: userDefaultsKeys.passWord.rawValue) as! String
                let info =  ["isApp":"2", "grant_type":"password","username":username, "password":password]
                tlPrint(message: "----------------------   \n        login info :\(info)\n-------------------------")
                network.postWithPath(path: url, paras: info, success: { (response) in

                    if let value = response {
                        self.longinReturnDeal(response: value as AnyObject, username: username, password: password, isLoginPage: true)
                    } else {
                        self.longinReturnDeal(response: ["error":"","error_description":"用户名或密码不正确"] as AnyObject, username: username, password: password, isLoginPage: true)
                    }
                    
                    }, failure: { (error) in
                        tlPrint(message: "error:\(error)")
                        DispatchQueue.main.async(execute: {
                            let alert = UIAlertView(title: "登录失败", message: "当前出现网络错误，请检查网络连接状态后再试！", delegate: self, cancelButtonTitle: "确定")
                            alert.show()
                        })
                        if self.indicator != nil {
                            self.indicator.stop()
                            self.view.isUserInteractionEnabled = true
                        }
                })
            } else {
                tlPrint(message: "userHasLogin = false")
            }
        } else {
            tlPrint(message: "userHasLogin 没有")
            userDefaults.setValue(false, forKey: userDefaultsKeys.userHasLogin.rawValue)
        }
    }

    
    func btnAct(btnTag: Int) {
        switch btnTag {
        case LoginTag.HomeBtnTag.rawValue:
            self.navigationController?.popViewController(animated: true)
        case LoginTag.loginBtnTag.rawValue:
            tlPrint(message: "longin button action")
            self.logBtnAct()
        case LoginTag.forgetBtnTag.rawValue:
            tlPrint(message: "forget password button action")
            self.forgetBtnAct()
        case LoginTag.registerBtnTag.rawValue:
            tlPrint(message: "register button action")
            self.registerBtnAct()
        default:
            tlPrint(message: "no such case")
        }
    }
    //================================
    //Mark:- 忘记密码按钮点击方法
    //================================
    func forgetBtnAct() -> Void {
        tlPrint(message: "forget password button action")
        let forgetVC = ForgetViewController()
        self.navigationController?.pushViewController(forgetVC, animated: true)
    }
    
    //================================
    //Mark:- 注册按钮点击方法
    //================================
    func registerBtnAct() -> Void {
        tlPrint(message: "register password button action")
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tlPrint(message: "textFieldShouldBeginEditing")
         //鼠标进入UITextField
        currentTextField = textField
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tlPrint(message: "textFieldDidBeginEditing")
        currentTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tlPrint(message: "textFieldDidEndEditing")
        //self.loginBtn.isUserInteractionEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tlPrint(message: "textFieldShouldReturn")
        //在输入框里,在虚拟键盘上点击return
        if currentTextField != nil {
            currentTextField.resignFirstResponder()
        }
        return true
    }
    
    
    //===========================================
    //Mark:- get请求获得当前最新域名和版本信息等
    //===========================================
    
    
//    func requestLatestInfo() -> Void {
//        tlPrint(message: "requestLatestInfo  >>>>>>>>><<<<<<<<<<<<<<")
//        let userDefaults = UserDefaults.standard
//        var returnValue  = NSDictionary()
//        //动态域名url字符串的转码
//        let urlString = dynamicDomainUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
//        //创建管理者对象
//        let manager = AFHTTPSessionManager()
//        //设置允许请求的类别
//        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/plain", "text/json", "application/json","charset=utf-8","text/javascript","text/html", "application/javascript", "text/js") as? Set<String>
//        manager.securityPolicy.allowInvalidCertificates = true
//        
//        //数据类型选择
//        manager.requestSerializer = AFJSONRequestSerializer()
//        manager.responseSerializer = AFJSONResponseSerializer()
//        
//        _ = DispatchQueue.global().sync {
//            manager.get(urlString, parameters: nil, progress: { (progress) in
//                
//                
//            }, success: { (task, response) in
//                returnValue = response as! NSDictionary
//                
//                tlPrint(message: "response:\(String(describing: response))")
//                let oldDomainName = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue)
//                let oldAppVersion = SystemInfo.getCurrentVersion()
//                let newDomainName = returnValue.value(forKey: "doMain")
//                let newAppVersion = returnValue.value(forKey: "version")
//                if let domainName = newDomainName {
//                    if (domainName as! String) != (oldDomainName as! String)  {
//                        //将新的域名写进数据库，发送重新加载网页的消息通知
//                        let domain = domainName as! String
//                        tlPrint(message: "domain1: \(domain)")
//                        userDefaults.setValue((domain), forKey: userDefaultsKeys.domainName.rawValue)
//                        userDefaults.synchronize()
//                        //self.reloadMainPage(url: nil)
//                    }
//                    let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
//                    tlPrint(message: "domain2: \(domain)")
//                }
//                if oldAppVersion < newAppVersion as! String{
//                    tlPrint(message: "***********  oldAppVersion:\(oldAppVersion) < newAppVersion:\(String(describing: newAppVersion))")
//                    //有新的版本，提示用户更新
//                    tlPrint(message: "请更新版本")
//                    if let updateUrl = returnValue.value(forKey: "downloadAddr") {
//                        //获取app的更新地址
//                        tlPrint(message: "get the download address: \(updateUrl)")
//                        self.appUpdateUrl = (updateUrl as! String)
//                        tlPrint(message: "self.appUpdateUrl : \(self.appUpdateUrl)")
//                        
//                        let alert = UIAlertView(title: "升级提示", message: "你当前的版本是V\(oldAppVersion)，发现新版本V\(newAppVersion as! String),是否下载新版本？", delegate: self, cancelButtonTitle: "下次再说", otherButtonTitles: "立即下载")
//                        alert.tag = 10
//                        alert.show()
//                        tlPrint(message: "当前bundleID为：\(SystemInfo.getBundleID())")
//                    }
//                }
//                
//                tlPrint(message: "response:\(String(describing: response))")
//            }, failure: { (task, error) in
//                tlPrint(message: "请求失败\nERROR:\n\(error)")
//            })
//        }
//    }
    
    
    
    //===========================================
    //Mark:- 弹窗处理函数
    //===========================================
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        tlPrint(message: "alertView - clickedButtonAt")
        switch alertView.tag {
        case 10:
            if buttonIndex == 1 {
                //确认更新app
                let url = URL(string: appUpdateUrl)
                tlPrint(message: "new app url: \(String(describing: url))")
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: { (response) in
                        tlPrint(message: "response:\(response)")
                    })
                } else {
                    UIApplication.shared.openURL(url!)
                }
            }
        default:
            tlPrint(message: "no such case")
        }
    }
    
    
    //触摸完毕关闭键盘
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tlPrint(message: "touchesEnded")
        if currentTextField != nil {
            currentTextField.resignFirstResponder()
            
        }
    }
}
