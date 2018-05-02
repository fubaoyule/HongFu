//
//  RechargeScanViewController.swift
//  FuTu
//
//  Created by Administrator1 on 11/4/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

class RechargeScanViewController: UIViewController,UITextFieldDelegate,BtnActDelegate {
    
    var payType: PayType = PayType.OnlinePay
    var activityCode:String = "no"
    var amount:String!
    var scanview:RechargeScanView!
    let model = RechargeModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.scanview = RechargeScanView(frame: self.view.frame, payType: self.payType, rootVC: self)
        self.view.addSubview(self.scanview)
        
        getInfo()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    init(payType:PayType,amount:String,actCode:String) {
        super.init(nibName: nil, bundle: nil)
        
        self.payType = payType
        self.amount = amount
        self.activityCode = actCode
    }
    
    
    
    let payStartTime = Date()
    func getInfo() -> Void {
        tlPrint(message: "getInfo")
//        if self.payType == PayType.WeChatPay || self.payType == PayType.AliPay {
//            
//            if activityCode == "" {
//                activityCode = "no_activitycode"
//            }
//            //转账支付
//            model.scanPayRequest(payType: self.payType, amount: self.amount, activityCode: self.activityCode, success: { (payInfo) in
//                tlPrint(message: "payInfo:\(payInfo)")
//                if "\(payInfo)".range(of: "Failed") != nil  {
//                    //test
//                    let loginAlert = UIAlertView(title: "提示", message: "您的账户在别的地方登录，请重新登录！", delegate: self, cancelButtonTitle: "确 定")
//                    loginAlert.show()
//                    
//                    LogoutController.logOut()
//                    let loginVC = LoginViewController()
//                    self.navigationController?.pushViewController(loginVC, animated: true)
//                    return
//                }
//                if let confirmBtn = self.scanview.viewWithTag(rechargeTag.UnionPayConfirmBtnTag.rawValue) {
//                    (confirmBtn as! UIButton).isUserInteractionEnabled = true
//                    confirmBtn.isHidden = false
//                    self.scanview.updatePayInfo(info: payInfo)
//                }
//            }) {
//                let alert = UIAlertView(title: "提 醒", message: "该支付方式维护中\n请稍后再试,或使用其他方式进行充值", delegate: self, cancelButtonTitle: "确 定")
//                DispatchQueue.main.async {
//                    alert.show()
//                }
//                tlPrint(message: "failed")
//            }
//        } else if self.payType == PayType.TimePay {
//            //点卡支付
//        } else {
            //网银支付
        let randomAmount:CGFloat = CGFloat(Double(self.amount)!) + (CGFloat(getRandomValueInt(number: 2)) / 100)
        let totoleAmount = self.payType != PayType.WechaToBank ? self.amount : (self.amount.contains(".") ? amount : "\(randomAmount)")
        
        model.unionPayRequest(amount: totoleAmount!, activityCode: self.activityCode, success: { (payInfo) in
                tlPrint(message: "payInfo:\(payInfo)")
                
                if "\(payInfo)".range(of: "请重新登录!") != nil  {
                    //test
                    let loginAlert = UIAlertView(title: "提示", message: "您的账户在别的地方登录，请重新登录!", delegate: self, cancelButtonTitle: "确 定")
                    loginAlert.show()
                    
                    LogoutController.logOut()
                    let loginVC = LoginViewController()
                    self.navigationController?.pushViewController(loginVC, animated: true)
                    return
                }
                
                if let confirmBtn = self.scanview.viewWithTag(rechargeTag.UnionPayConfirmBtnTag.rawValue) {
                    (confirmBtn as! UIButton).isUserInteractionEnabled = true
                    confirmBtn.isHidden = false
                    self.scanview.updatePayInfo(info: payInfo)
                }
                
            }) {
                let alert = UIAlertView(title: "提 醒", message: "该支付方式维护中\n请稍后再试,或使用其他方式进行充值", delegate: self, cancelButtonTitle: "确 定")
                DispatchQueue.main.async {
                    alert.show()
                }
                tlPrint(message: "failed")
            }
//        }
    }
    
    func btnAct(btnTag: Int) {
        tlPrint(message: "btnAct btnTag : \(btnTag)")
        switch btnTag {
        case rechargeTag.RechargeScanBackTag.rawValue:
            _ = self.navigationController?.popViewController(animated: true)
        case rechargeTag.UnionPayConfirmBtnTag.rawValue:
            tlPrint(message: "银联支付确认按钮")
            let confirmBtn = self.scanview.viewWithTag(rechargeTag.UnionPayConfirmBtnTag.rawValue) as! UIButton
            confirmBtn.isUserInteractionEnabled = false
            model.unionPayConfirmRequest(actCode: activityCode, rnd: model.unionPayRnd, success: {
                tlPrint(message: "网银支付上传成功")
                let payName = "网银转账"
                let alert = UIAlertView(title: payName, message: "充值确认已经提交，请您耐心等待,3分钟内将给您确认上分,谢谢您！", delegate: nil, cancelButtonTitle: "确定")
                DispatchQueue.main.async {
                    alert.show()
                }
                confirmBtn.isHidden = true
                confirmBtn.isUserInteractionEnabled = false
            }, failure: {
                tlPrint(message: "网银支付上传失败")
            })
            
//        case rechargeTag.TimeCardPayConfirmBtnTag.rawValue:
//            tlPrint(message: "点卡支付充值确认按钮")
//            self.timeCardConfirmBtnAct()
        default:
//            if btnTag >= rechargeTag.TimeCardPayTypeBtnTag.rawValue {
//                tlPrint(message: "选择了点卡按钮")
//                self.scanview.timeCardSelected(tag: btnTag)
//                if currentTextField != nil {
//                    currentTextField.resignFirstResponder()
//                    self.scanview.timeCardViewMoveUp(isNeedUp: false)
//                }
//                
//            } else {
//                tlPrint(message: "no such case!")
//            }
            tlPrint(message: "no such case!")
        }
    }
    
    
//    func timeCardConfirmBtnAct() -> Void {
//        tlPrint(message: "timeCardConfirmBtnAct")
//        let inputTextArray = ["点卡账号","点卡密码"]
//        var infoValue = ["",""]
//        //region 卡种代码
//        //YDSZX 移动神州行
//        //LTYKT 联通一卡充
//        //DXGK 电信国卡
//        //JWYKT 骏网一卡通
//        //SDYKT 盛大一卡通
//        //QBCZK QQ币充值卡
//        //WMYKT 完美一卡通
//        //ZTYKT 征途一卡通
//        //WYYKT 网易一卡通
//        //SHYKT 搜狐一卡通
//        //JYYKT 久游一卡通
//        //THYKT 天宏一卡通
//        //TXYKT 天下一卡通
//        //GYYKT 光宇一卡通
//        //ZYYKT 纵游一卡通
//        //TXYKTZX 天下一卡通专项
//        //SFYKT 盛付通一卡通
//        //endregion
//        //点卡界面向下归位
//        self.scanview.frame = CGRect(x: 0, y: 0, width: self.scanview.frame.width, height: self.scanview.frame.height)
//        //收起键盘
//        self.currentTextField.resignFirstResponder()
//        if self.scanview.indicator == nil {
//            self.scanview.indicator = TTIndicators(view: self.scanview, frame: portraitIndicatorFrame)
//        }
//        self.scanview.indicator.play(frame: portraitIndicatorFrame)
//        var cardIndex:Int = 0
//        for i in 0 ..< 2 {
//            let inputTextFeild = self.scanview.viewWithTag(rechargeTag.TimeCardPayInputTextFeildTag.rawValue + i) as! UITextField
//            //            let inputTextFeild = self.scanview.viewWithTag(rechargeTag.TimeCardPayInputTextFeildTag.rawValue + i) as! UIButton
//            
//            
//            let inputValue = inputTextFeild.text
//            if inputValue == nil || inputValue == "" {
//                self.scanview.indicator.stop()
//                let alert = UIAlertView(title: "", message: "请输入正确的\(inputTextArray[i])", delegate: nil, cancelButtonTitle: "重 试")
//                DispatchQueue.main.async {
//                    alert.show()
//                }
//                return
//            }
//            infoValue[i] = inputValue!
//            cardIndex = self.scanview.selectedBtnTag - rechargeTag.TimeCardPayTypeBtnTag.rawValue
//        }
//        if activityCode == "" {
//            activityCode = "no_activitycode"
//        }
//        self.model.timePayRequest(payType: .TimePay, amount: self.amount, activityCode: self.activityCode, cardCode: self.model.timeCardTypeArray[cardIndex], cardInfo:infoValue, success: { (response) in
//            tlPrint(message: "response : \(response)")
//            
//            if "\(response)".range(of: "Failed") != nil  {
//                //test
//                let loginAlert = UIAlertView(title: "提示", message: "您的账户在别的地方登录，请重新登录！", delegate: self, cancelButtonTitle: "确 定")
//                loginAlert.show()
//                
//                LogoutController.logOut()
//                let loginVC = LoginViewController()
//                self.navigationController?.pushViewController(loginVC, animated: true)
//                return
//            }
//            
//            if let msg = response["Message"] {
//                let alert = UIAlertView(title: "充值提示", message: msg as? String, delegate: nil, cancelButtonTitle: "确 定")
//                DispatchQueue.main.async {
//                    self.scanview.indicator.stop()
//                    alert.show()
//                }
//            }
//        }) {
//            tlPrint(message: "error")
//            let alert = UIAlertView(title: "提 示", message: "点卡支付出现问题，请稍后再试或联系客服！", delegate: nil, cancelButtonTitle: "好的")
//            self.scanview.indicator.stop()
//            alert.show()
//        }
//        
//        
//        tlPrint(message: "info value : \(infoValue)")
//        
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func image(image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject)
    {
        if didFinishSavingWithError != nil
        {
            return
        }
    }
    
    
//    var currentTextField: UITextField!
//    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        tlPrint(message: "textFieldShouldBeginEditing")
//        currentTextField = textField
//        self.scanview.timeCardViewMoveUp(isNeedUp: true)
//        return true
//    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        tlPrint(message: "textFieldDidBeginEditing")
//        currentTextField = textField
//        self.scanview.timeCardViewMoveUp(isNeedUp: true)
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        tlPrint(message: "textFieldShouldReturn")
//        textField.resignFirstResponder()
//        self.scanview.timeCardViewMoveUp(isNeedUp: false)
//        return true
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        tlPrint(message: "textFieldDidEndEditing")
//        textField.resignFirstResponder()
//        self.scanview.timeCardViewMoveUp(isNeedUp: false)
//    }
    
    
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        tlPrint(message: "touchesEnded")
//        if currentTextField != nil {
//            currentTextField.resignFirstResponder()
//            self.scanview.timeCardViewMoveUp(isNeedUp: false)
//        }
//    }
    
    
    
    
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
