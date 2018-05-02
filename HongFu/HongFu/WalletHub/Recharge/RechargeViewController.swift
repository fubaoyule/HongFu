//
//  RechargeViewController.swift
//  FuTu
//
//  Created by Administrator1 on 27/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit


class RechargeViewController: UIViewController,UIScrollViewDelegate, UITextFieldDelegate,BtnActDelegate,UIAlertViewDelegate {

    var rechargeView: RechargeView!
    let model = RechargeModel()
    var payType:PayType = PayType.WeChatPay
    var isFromTabView = true
    var activityCode:String!
    var codeTimer: DispatchSourceTimer!
    var indicator:TTIndicators!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rechargeView = RechargeView(frame: self.view.frame,isFromTab: self.isFromTabView, rootVC: self)
        self.view.addSubview(self.rechargeView)
        
        //test
        self.model.getDepositActivesList(success: { (response) in
            tlPrint(message: "response:\(response)")
            self.rechargeView.activityInfo = response
        }) {
            tlPrint(message: "error")
        }
        
        
//        self.viewWillAppear(true)
//        self.viewDidAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tlPrint("viewDidAppear")
        //进入页面默认微信转账，需要请求微信号
        if self.payType ==  PayType.WeChatPay {
            self.model.getWechatAccount(success: { (wechatNum) in
                tlPrint(message: "支付微信号：\(wechatNum)")
                if self.payType != PayType.WeChatPay {
                    return
                }
                self.rechargeView.initWechatAlertLabel(textString: "     添加微信：\(wechatNum)，转账并备注鸿福账号！")
            }, failure: {
                self.rechargeView.nextBtn.isEnabled = false
                if self.payType != PayType.WeChatPay {
                    return
                }
                self.rechargeView.initWechatAlertLabel(textString: "     微信转账维护中,请使用其他方式进行充值")
                let alert = UIAlertView(title: "提 醒", message: "微信转账维护中\n请使用其他方式进行充值", delegate: self, cancelButtonTitle: "确 定")
                DispatchQueue.main.async {
                    alert.show()
                }
                tlPrint(message: "获取失败")
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.codeTimer != nil {
            codeTimer.cancel()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tlPrint(message: "viewWillAppear")
        
        self.countDownDeal()
        
    }

    
    init(isFromTab:Bool) {
        super.init(nibName: nil, bundle: nil)
        self.isFromTabView = isFromTab
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
   
    
    func btnAct(btnTag: Int) {
        tlPrint(message: "rechargeBtnAction btnTag = \(btnTag)")
        if btnTag == rechargeTag.RechargeBackTag.rawValue {
            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        self.checkLoginStatus {
            if btnTag >= rechargeTag.WechatPayBtnTag.rawValue && btnTag <= rechargeTag.TimeCardPayBtnTag.rawValue {
                self.choosePayTypeAct(btnTag: btnTag)
                
                
            } else if btnTag == rechargeTag.NextBtnTag.rawValue {
                tlPrint(message: "下一步")
                if self.indicator == nil {
                    self.indicator = TTIndicators(view: self.view, frame: portraitIndicatorFrame)
                }
                self.indicator.play(frame: portraitIndicatorFrame)
                if self.currentTextField != nil {
                    self.currentTextField.resignFirstResponder()
                }
                let returnValue = self.model.nextBtnAct(rechargeView: self.rechargeView,payType: self.payType)
                if returnValue {
                    self.nextBtnAct()
                } else if self.indicator != nil {
                    self.indicator.stop()
                }
                
            } else {
                tlPrint(message: "no such case")
            }
        }
    }

    
    func choosePayTypeAct(btnTag:Int) -> Void {
        tlPrint(message: "选择支付方式")
        
        self.rechargeView.nextBtn.setTitle("下一步", for: .normal)
        if self.codeTimer != nil {
            self.codeTimer.cancel()
            self.rechargeView.nextBtn.isEnabled = true
        }
        var lockTime = 1
        if let lockTime_t = userDefaults.value(forKey: userDefaultsKeys.dinPayFailedLockTime.rawValue) {
            lockTime = lockTime_t as! Int
        }
        tlPrint(message: "self.lockTime = \(lockTime)")
        if btnTag == rechargeTag.AliScanPayBtnTag.rawValue && lockTime > 0 {
            if let failedTime = userDefaults.value(forKey: userDefaultsKeys.dinPayFailedTime.rawValue)  {
                let timeInterval = Date().timeIntervalSince(failedTime as! Date)
                if Int(Double(lockTime) - timeInterval) > 0 {
                    self.countDown(time: Int(Double(lockTime) - timeInterval))
                    self.rechargeView.nextBtn.isEnabled = false
                }
            }
        } else {
            self.rechargeView.nextBtn.isEnabled = true
            self.isLocked = false
        }
        let index = btnTag - rechargeTag.WechatPayBtnTag.rawValue
        self.rechargeView.changePayTypeBtn(index: index)
        self.modifyPayType(btnIndex: index)
        //修改键盘格式
        let inputTextFeild = self.rechargeView.viewWithTag(rechargeTag.InputTextFieldTag.rawValue) as! UITextField
        if btnTag == rechargeTag.AliScanPayBtnTag.rawValue || btnTag == rechargeTag.WechatScanPayBtnTag.rawValue || btnTag == rechargeTag.WechaToBankPayBtnTag.rawValue {
            inputTextFeild.keyboardType = .decimalPad
        } else {
            inputTextFeild.keyboardType = .numberPad
        }
        
        //修改温馨提示内容
        let warmingWords = [PayType.WeChatPay:"点击‘下一步’之前，请确认您已经添加微信且转账成功！",
                            PayType.WechaToBank:"请输入充值金额后点击下一步获取收款账号，通过微信转账成功以后再进行提单确认！",
                            PayType.QQPay:"*温馨提示：如果无法完成充值，建议使用“在线充值”",
                            PayType.WechatScanPay:"*温馨提示：若提交订单失败请等待90秒后重试！建议使用“在线充值”、“快捷支付”",
                            PayType.AliScanPay:"*温馨提示：若提交订单失败请等待90秒后重试！建议使用“在线充值”、“快捷支付”",
                            PayType.OnlinePay:"",
                            PayType.AliPay:"",
                            PayType.UnionPay:"",
                            PayType.FastPay:""]
        let warmingLable = self.rechargeView.viewWithTag(rechargeTag.WarmingLabelTag.rawValue) as! UILabel
        warmingLable.text = warmingWords[self.payType]
        
        if btnTag ==  rechargeTag.WechatPayBtnTag.rawValue {
            self.model.getWechatAccount(success: { (wechatNum) in
                tlPrint(message: "支付微信号：\(wechatNum)")
                self.rechargeView.initWechatAlertLabel(textString: "     添加微信：\(wechatNum)，转账并备注鸿福账号！")
            }, failure: {
                self.rechargeView.nextBtn.isEnabled = false
                self.rechargeView.initWechatAlertLabel(textString: "     微信转账维护中,请使用其他方式进行充值")
                let alert = UIAlertView(title: "提 醒", message: "微信转账维护中\n请使用其他方式进行充值", delegate: self, cancelButtonTitle: "确 定")
                DispatchQueue.main.async {
                    alert.show()
                }
                tlPrint(message: "获取失败")
            })
        } else {
            self.rechargeView.initAlertLabel(lowLimit: self.model.limitAmount[self.payType]![0], hightLimit: self.model.limitAmount[self.payType]![1],btnTag:btnTag)
        }
    }
    
    
    
    
    //判断用户是否已经登录
    func checkLoginStatus(hasLogin:@escaping(()->())) -> Void {
        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
            if !(hasLogin as! Bool) {
                let alert = UIAlertView(title: "您还没有登录", message: "", delegate: self, cancelButtonTitle: "再逛逛", otherButtonTitles: "登录/注册")
                alert.tag = 11
                alert.show()
                return
            }
        } else {
            let alert = UIAlertView(title: "您还没有登录", message: "", delegate: self, cancelButtonTitle: "再逛逛", otherButtonTitles: "登录/注册")
            alert.tag = 11
            alert.show()
            return
        }
        hasLogin()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        switch alertView.tag {
        case 11:
            //没有登录弹窗
            tlPrint(message: "buttonIndex:\(buttonIndex)")
            if buttonIndex == 1 {
                tlPrint(message: "选择了进入注册")
                let loginVC = LoginViewController()
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        default:
            tlPrint(message: "no such case")
        }
    }

    //========================
    //Mark:- 鸿福支付总入口
    //========================
    private func futuPayment(sender: Dictionary<String,Any>) -> Void {
        tlPrint(message: sender)
        //中转接口请求参数
        var urlString: String
        var tokenString: String
        //给中转接口的传递参数
        var amount: Float
        var paytype: String
        var bankCode: String
        var forApp: String
        if let forApp_t = sender["ForApp"] {
            forApp = forApp_t as! String
        } else {
            tlPrint(message: "not have ForApp recieved")
            return
        }
        if let url = sender["url"] {
            urlString = url as! String
        } else {
            tlPrint(message: "not have url recieved")
            return
        }
        if let receiveToken = sender["token"] {
            tokenString = receiveToken as! String
            tlPrint(message: "tokenString:\(tokenString)")
        } else {
            tlPrint(message: "not have token recieved")
            return
        }
        if let receiveAmount = sender["amount"] {
            amount = receiveAmount as! Float
        } else {
            tlPrint(message: "not have Amount Amount")
            return
        }
        if let receivepaytype = sender["paytype"] {
            paytype = receivepaytype as! String
            var bankName = ""
            if paytype == "1" {
                bankName = "在线支付"
            } else if paytype == "12" {
                bankName = "支付宝扫码"
            } else if paytype == "13" {
                bankName = "微信扫码"
            } else if paytype == "15" {
                bankName = "QQ扫码"
            } else if paytype == "16" {
                bankName = "快捷支付"
            }
            userDefaults.setValue(bankName, forKey: "onlinePayName")
            
        } else {
            tlPrint(message: "not have paytype recieved")
            return
        }
        if let receiveBankCode = sender["bankcode"] {
            bankCode = receiveBankCode as! String
            
        } else {
            tlPrint(message: "not have bankcode recieved")
            return
        }
        tlPrint(message: "支付请求中转API地址：\(urlString)")
        let Amount = String(amount)
        var domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
        
        //去掉hppt:// 或者 https://
        let index = domain.range(of: "https://") == nil ? 7 : 8
        domain = (domain as NSString).substring(from: index)
        let returnUrl = "\(domain)WalletRecharge"
        if activityCode == nil || activityCode == "" {
            activityCode = "no_activitycode"
        }

        let params: Dictionary<String,Any> = ["ForApp":forApp,"amount":Amount,"paytype":paytype,"bankcode":bankCode,"ActCode":activityCode,"ReturnDomain":returnUrl]
        let url = "MobileOnlineDeposit/OnlineProcess"
        
        futuNetworkRequest(type: .post, serializer: .http, url: url, params: params, success: { (response) in
            tlPrint(message: response)
            let string = String(data: response as! Data, encoding: String.Encoding.utf8)
            
            tlPrint(message: string)
            if "\(String(describing: string))".range(of: "请重新登录!") != nil  {
                //判断是否在别处登陆
                let loginAlert = UIAlertView(title: "提示", message: "您的账户在别的地方登录，请重新登录!", delegate: self, cancelButtonTitle: "确 定")
                loginAlert.show()
                if self.indicator != nil {
                    self.indicator.stop()
                }
                LogoutController.logOut()
                let loginVC = LoginViewController()
                self.navigationController?.pushViewController(loginVC, animated: true)
                return
            }
            
            if string?.range(of: "频繁提交订单") == nil && string?.range(of: "openapi.alipay.com") == nil {
                //不是DPay
                let payDic = (string!).objectFromJSONString() as! Dictionary<String, Any>
//                self.paymentDeal(sender: payDic as! NSMutableDictionary)
                self.paymentDeal(sender: payDic)
                self.isLocked = false
                if self.indicator != nil {
                    self.indicator.stop()
                }
                return
            }
            //DinPya 支付处理函数
            self.rechargeView.nextBtn.isEnabled = true
            self.dinPayDeal(payString: string!)
            
        }) { (error) in
            tlPrint(message: error)
            //如果返回未授权，则表示在别处登陆
            if "\(error)".range(of: "unauthorized") != nil  {
                //test
                let loginAlert = UIAlertView(title: "提示", message: "您的账户在别的地方登录，请重新登录！", delegate: self, cancelButtonTitle: "确 定")
                loginAlert.show()
                
                LogoutController.logOut()
                let loginVC = LoginViewController()
                self.navigationController?.pushViewController(loginVC, animated: true)
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
        }
    }
    
    
    
    var isLocked = false
    var lastTime:Date!    //上一次提交的时间

    func dinPayDeal(payString: String) -> Void {
        //DinPay支付。非智付
        
        self.isLocked = true
        self.lastTime = Date()
        userDefaults.setValue(lastTime, forKey: userDefaultsKeys.dinPayFailedTime.rawValue)
        if payString.range(of: "频繁提交订单") != nil {
            //频繁提交,锁90秒
            userDefaults.setValue(90, forKey: userDefaultsKeys.dinPayFailedLockTime.rawValue)
            isLocked = true
            self.countDownDeal()
            return
            
        } else if payString.range(of: "openapi.alipay.com") != nil {
            //正常提交，锁15秒
            userDefaults.setValue(15, forKey: userDefaultsKeys.dinPayFailedLockTime.rawValue)
            isLocked = true
            let payDic = (payString).objectFromJSONString() as! Dictionary<String, Any>
//            self.paymentDeal(sender: payDic as! NSMutableDictionary)
            self.paymentDeal(sender: payDic)
        }
    }

    //==============================================
    //Mark:- 支付处理函数（根据中专API返回的内容选择支付方式）
    //==============================================
    public func paymentDeal(sender: Dictionary<String,Any>) -> Void {
        
        tlPrint(message: "paymentDeal object: \(sender)")
        let response = sender
        self.rechargeView.nextBtn.isEnabled = true
        if "\(response)".range(of: "请重新登录") != nil  {
            //test
            let loginAlert = UIAlertView(title: "提示", message: "您的账户在别的地方登录，请重新登录！", delegate: self, cancelButtonTitle: "确 定")
            loginAlert.show()
            
            LogoutController.logOut()
            let loginVC = LoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
            return
        }
        let value = sender as AnyObject
        if let success = value.value(forKey: "Success") {
            if !(success as! Bool) {
                //返回值为0，弹窗提示，不进行支付
                if let message = value.value(forKey: "Message") {
                    let alert = UIAlertView(title: "支付提醒", message: (message as! String), delegate: self, cancelButtonTitle: "确 定")
                    alert.show()
                    return
                }
                return
            }
        
            //在线支付
            if self.payType == PayType.OnlinePay  {
                tlPrint(message: "payment sender: \(sender)")
                if FutuPayController.payTypeConfirm(payName: "\(value)") == "ZF" {
                    
                    tlPrint(message: "当前为在线支付，使用智付SDK支付")
                    //*********    智付支付SDK测试开始   *********
                    tlPrint(message: "value:\(value)")
                    if value.value(forKey: "orderModel") == nil {
                        return
                    }
                    let orderModel = value.value(forKey: "orderModel")
                    if (orderModel as AnyObject).value(forKey: "PayName") == nil {
                        return
                    }
                    let payName = (orderModel as AnyObject).value(forKey: "PayName")
                    tlPrint(message: "ordermodel: \(orderModel!)")
                    tlPrint(message: "payName: \(payName!)")
                    FutuPayController.dinpay(sender: orderModel as AnyObject, rootViewControler: self)
                    //*********    智付支付SDK测试结束    *********
                } else {
                    let alert = UIAlertView(title: "支付提醒", message: "该支付暂时没有配置信息\n请使用其他支付方式或联系客服", delegate: self, cancelButtonTitle: "好   的")
                    alert.show()
                }
                
            } else {
                //支付宝扫码、QQ扫码、微信扫码或者快捷支付
                tlPrint(message: "***  跳转到支付页面  ***")
                let onlinePayVC = OnlinePayViewController(param: value,payType:self.payType)
                self.navigationController?.pushViewController(onlinePayVC, animated: true)
            }
        }
    }
    

    
    
    func nextBtnAct() -> Void {
        tlPrint(message: "nextBtnAct")
        
        self.rechargeView.nextBtn.isEnabled = false
        let textField = self.rechargeView.viewWithTag(rechargeTag.InputTextFieldTag.rawValue) as! UITextField
        var Amount = textField.text!
        let amount = Float(Amount)
        let bankCode = getBankCode()
        self.activityCode = self.rechargeView.activityCode

        if self.payType == PayType.WeChatPay {
            tlPrint(message: "微信转账")

            self.model.scanPayRequest(payType: .WeChatPay, amount: Amount, activityCode: activityCode, success: { (respondDic) in
                tlPrint(message: "respondDic:\(respondDic)")
                let rnd = respondDic["Rnd"] as! String
                let alert = UIAlertView(title: "微信转账", message: "订单号：\(rnd)\n完成转账，联系在线客服办理入账！", delegate: nil, cancelButtonTitle: "好 的")
                alert.show()
                self.rechargeView.nextBtn.isEnabled = true
                if self.indicator != nil {
                    self.indicator.stop()
                }
            }, failure: { 
                tlPrint(message: "error")
                let alert = UIAlertView(title: "", message: "微信转账未完成，请使用其他方式充值，或联系客服！", delegate: nil, cancelButtonTitle: "好 的")
                alert.show()
                
                self.rechargeView.nextBtn.isEnabled = true
                if self.indicator != nil {
                    self.indicator.stop()
                }
            })
            
            return
        } else if self.payType == PayType.WechaToBank || self.payType == PayType.UnionPay {
            tlPrint(message: "新的转账支付方式(网银，支付宝，点卡) actCode:\(self.activityCode)")
            //扫码添加支付和点卡支付
            let scanVC = RechargeScanViewController(payType: self.payType,amount:Amount,actCode:self.activityCode)
            if self.indicator != nil {
                self.indicator.stop()
            }
            self.navigationController?.pushViewController(scanVC, animated: true)
            self.rechargeView.nextBtn.isEnabled = true
            return
        }
        //判断有没有频繁提交订单
        if isLocked {
            let failedTime = userDefaults.value(forKey: userDefaultsKeys.dinPayFailedTime.rawValue) as! Date
            let timeInterval = Date().timeIntervalSince(lastTime)
            
            tlPrint(message: "lockTime : \(failedTime)")
            var lockTime = 1
            if let lockTime_t = userDefaults.value(forKey: userDefaultsKeys.dinPayFailedLockTime.rawValue) {
                lockTime = lockTime_t as! Int
            }
            if timeInterval < Double(lockTime) {
                tlPrint(message: "请勿频繁提交")
                //倒计时
                self.countDown(time: Int(Double(lockTime) - timeInterval))
                return
            }
        }
        let payType = self.payType.rawValue
        let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
        let url = domain + "MobileOnlineDeposit/OnlineProcess"
        let token = userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue) as! String
        var params = ["ForApp" : self.payType == PayType.OnlinePay ? "1" : "", "amount":amount ?? 0,"bankcode":bankCode,"paytype":payType,"ActCode":self.activityCode,"url":url,"token":token] as [String : Any]
        if self.activityCode == nil || self.activityCode == "" {
            params = ["ForApp" : self.payType == PayType.OnlinePay ? "1" : "","amount":amount ?? 0,"bankcode":bankCode,"paytype":payType,"url":url,"token":token] as [String : Any]
        }
        
        tlPrint(message: "param:\(params)")
        self.futuPayment(sender: (params as Dictionary<String,Any>))
    }
    
    func countDownDeal() -> Void {
        if self.codeTimer != nil {
            self.codeTimer.cancel()
            self.rechargeView.nextBtn.isEnabled = true
        }
        var lockTime = 1
        if let lockTime_t = userDefaults.value(forKey: userDefaultsKeys.dinPayFailedLockTime.rawValue) {
            lockTime = lockTime_t as! Int
        }
        tlPrint(message: "self.lockTime = \(lockTime)")
        if self.payType == PayType.AliScanPay && lockTime > 0 {
            if let failedTime = userDefaults.value(forKey: userDefaultsKeys.dinPayFailedTime.rawValue)  {
                let timeInterval = Date().timeIntervalSince(failedTime as! Date)
                if Int(Double(lockTime) - timeInterval) > 0 {
                    self.countDown(time: Int(Double(lockTime) - timeInterval))
                    self.rechargeView.nextBtn.isEnabled = false
                }
            }
        } else {
            self.rechargeView.nextBtn.isEnabled = true
            self.isLocked = false
        }
    }
    
    func countDown(time:Int) -> Void {
        // 定义需要计时的时间
        var timeCount = time
        // 在global线程里创建一个时间源
        self.codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.scheduleRepeating(deadline: .now(), interval: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            // 每秒计时一次
            timeCount = timeCount - 1
            // 时间到了取消时间源
            if timeCount <= 0 {
                DispatchQueue.main.async {
                    self.rechargeView.nextBtn.isEnabled = true
                }
                self.codeTimer.cancel()
            }
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                tlPrint(message: "timeCount:\(timeCount)")
                self.rechargeView.nextBtn.setTitle( timeCount > 0 ? "下一步（\(timeCount))" : "下一步", for: .normal)

            }
        })
        // 启动时间源
        codeTimer.resume()
    }
    
    //修改支付类型
    func modifyPayType(btnIndex:Int) -> Void {
        self.payType = model.payTypeArray[btnIndex]
        
    }
    
    func getBankCode() -> String {
        var bankCode:String! = "online"
        switch self.payType {
        case PayType.OnlinePay:
            bankCode = "online"
        case PayType.WeChatPay:
            bankCode = "weixin"
        case PayType.AliPay:
            bankCode = "alipay"
        case PayType.QQPay:
            bankCode = "QQPay"
        default:
            bankCode = "online"
        }
        return bankCode
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY:CGFloat = scrollView.contentOffset.y
        if offSetY < -80 {
            tlPrint(message: "刷新")
        }
    }
    
    var currentTextField: UITextField!
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextField = textField
        if textField.tag ==  rechargeTag.InputTextFieldTag.rawValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.rechargeView.frame = CGRect(x: 0, y: adapt_H(height: isPhone ? -200 : -120), width: self.rechargeView.frame.width, height: self.rechargeView.frame.height)
            })
            
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.2, animations: {
            self.rechargeView.frame = CGRect(x: 0, y: 0, width: self.rechargeView.frame.width, height: self.rechargeView.frame.height)
        })
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.2, animations: {
            self.rechargeView.frame = CGRect(x: 0, y: 0, width: self.rechargeView.frame.width, height: self.rechargeView.frame.height)
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tlPrint(message: "touchesEnded")
        if currentTextField != nil {
            currentTextField.resignFirstResponder()
            UIView.animate(withDuration: 0.2, animations: {
                self.rechargeView.frame = CGRect(x: 0, y: 0, width: self.rechargeView.frame.width, height: self.rechargeView.frame.height)
            })
        }
    }
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
