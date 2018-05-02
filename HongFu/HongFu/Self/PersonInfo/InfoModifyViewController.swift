//
//  InfoModifyViewController.swift
//  FuTu
//
//  Created by Administrator1 on 27/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

enum modifyViewTag:Int {
    
    case backBtnTag = 20,saveBtnTag, textFeildTag
}

class InfoModifyViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource, BtnActDelegate {
    
    
    var textIndex: Int!
    var modifyView:InfoModifyView!
    var width,height:CGFloat!
    var currentTextField:UITextField!
    let baseVC = BaseViewController()
    let model = PersonModel()
    var modifyType:ModifyType!
    var mobileNumber:String!
    let infoVerify = InfoVerify()
    override func viewDidLoad() {
        super.viewDidLoad()
        width = self.view.frame.width
        height = self.view.frame.height
        self.view.backgroundColor = UIColor.colorWithCustom(r: 209, g: 209, b: 209)
        self.modifyView = InfoModifyView(frame: self.view.frame, modifyType: self.modifyType, textIndex: textIndex, rootVC: self)
        self.view.addSubview(modifyView)
    }
    
    init(modifyType:ModifyType,textIndex:Int) {
        super.init(nibName: nil, bundle: nil)
        self.modifyType = modifyType
        self.textIndex = textIndex
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.modifyView.picker != nil {
            self.modifyView.hiddenPikerView()
        }
        if currentTextField != nil {
            currentTextField.resignFirstResponder()
        }
    }
    
    
    //****************************************
    //      TextField delegate
    //****************************************
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tlPrint(message: "textFieldShouldBeginEditing tag:\(textField.tag)")
        if textField.tag == personBtnTag.InfoTextFeildTag.rawValue {
            if currentTextField != nil {
                currentTextField.resignFirstResponder()
            }
            currentTextField = textField
            self.modifyView.initUIPickerView(textField: textField)
            return false
        } else if textField.tag == personBtnTag.InfoVerifyTextFieldTag.rawValue{
            self.verifyInputInfoResult(canUse: nil)
            currentTextField = textField
            return true
        } else if textField.tag == personBtnTag.InfoVerifyCodeFieldTag.rawValue{
            let finishBtn = self.modifyView.viewWithTag(personBtnTag.finishVerifyButton.rawValue) as! UIButton
            finishBtn.isUserInteractionEnabled = true
            finishBtn.backgroundColor = UIColor.colorWithCustom(r: 27, g: 123, b: 233)
            
            currentTextField = textField
            return true
        } else {
            self.modifyView.hiddenPikerView()
            currentTextField = textField
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == personBtnTag.InfoVerifyTextFieldTag.rawValue {
            self.verifyInputInfoResult(canUse: nil)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tlPrint(message: "textFieldDidEndEditing")
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tlPrint(message: "textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    
    
    //****************************************
    //      TablView delegate
    //****************************************
    let infoArray = ["出生日期","QQ号码","微信号码"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tlPrint(message: "numberOfRowsInSection")
        return self.infoArray.count
    }
    //返回行高
    var currentCellHeight:CGFloat!
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tlPrint(message: "heightForRowAt indexPath:\(indexPath)")
        let cellHeight:CGFloat = adapt_H(height: isPhone ? 60 : 40)
        return cellHeight
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tlPrint(message: "cellForRowAt \(indexPath)")
        var cell:InfoModifyTableViewCell!
        if cell == nil {
            cell = InfoModifyTableViewCell(cellIndex: indexPath[1], rootVC: self)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.gray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tlPrint(message: "didSelectRowAt:\(indexPath[1])")
    }
    
    
    func btnAct(btnTag:Int) -> Void {
        tlPrint(message: "btnAct btnTag = \(btnTag)")
        switch btnTag {
        case modifyViewTag.backBtnTag.rawValue:
            _ = self.navigationController?.popViewController(animated: true)
        case tradeSearchTag.DateSelectConfirmBtnTag.rawValue:
            self.modifyView.hiddenPikerView()
        case modifyViewTag.saveBtnTag.rawValue:
            tlPrint(message: "保存信息")
            self.modifyView.hiddenPikerView()
            if self.currentTextField != nil {
                self.currentTextField.resignFirstResponder()
            }
            inputInfoDeal()
        case personBtnTag.GetVerifyCodeButton.rawValue:
            tlPrint(message: "获取验证码")
            getCodeBtnAct()
        case personBtnTag.finishVerifyButton.rawValue:
            tlPrint(message: "完成验证")
            finishVerifyBtnAct()
        case personBtnTag.passwordModifyConfirmBtnTag.rawValue:
            tlPrint(message: "确认修改密码")
            let oldPassword = userDefaults.value(forKey: userDefaultsKeys.passWord.rawValue) as! String
            let textField = self.modifyView.viewWithTag(personBtnTag.passwordModifyTextFieldTag.rawValue + 1) as! UITextField
            let newPassword = textField.text!
            let passwordDic = ["OldPassword":oldPassword,"NewPassword":newPassword,"ConfirmPassword":newPassword]
            model.changePassword(passwordDic: passwordDic, success: { 
                let alert = UIAlertView(title: "提示", message: "修改密码成功", delegate: nil, cancelButtonTitle: "确 定")
                alert.show()
                userDefaults.setValue(passwordDic["NewPassword"], forKey: userDefaultsKeys.passWord.rawValue)
                self.navigationController?.popViewController(animated: true)
            }, failed: { 
                let alert = UIAlertView(title: "提示", message: "修改密码失败，请稍后重试或联系客服", delegate: nil, cancelButtonTitle: "确 定")
                alert.show()
                self.navigationController?.popViewController(animated: true)
            })
        default:
            tlPrint(message: "no such case")
        }
    }
    
    
    var getVerifyCodeTimer:Timer!
    func getCodeBtnAct() -> Void {
        tlPrint(message: "getCodeBtnAct")
        let getBtn = self.modifyView.viewWithTag(personBtnTag.GetVerifyCodeButton.rawValue) as! UIButton
        getBtn.isEnabled = false
        let textField = self.modifyView.viewWithTag(personBtnTag.InfoVerifyTextFieldTag.rawValue) as! UITextField
        let value = textField.text
        let type:ValidatedType!
        var checkUrl:String! = "Account/CheckHFEmailBind"
        var verifyType:Int = 0
        var param:Dictionary<String,String>! = ["":""]
        if model.infoLabel[self.textIndex] == "手机号码" {
            type = ValidatedType.Phone
        } else {
            type = ValidatedType.Email
        }
        if !infoVerify.ValidateText(validatedType: type, validateString: value!) {
            let alert = UIAlertView(title: "绑定失败", message: "请输入正确的\(model.infoLabel[self.textIndex])", delegate: nil, cancelButtonTitle: "确 定")
            DispatchQueue.main.async {
                alert.show()
            }
            getBtn.isEnabled = true
            return
        }
        if model.infoLabel[self.textIndex] == "手机号码" {
            checkUrl = "Account/CheckHFMobileBind"
            param = ["mobile":value!]
            verifyType = 0
        } else {
            checkUrl = "Account/CheckHFEmailBind"
            param = ["Email":value!]
            verifyType = 1
        }
        
        var initialNumber:String!
        if model.infoLabel[textIndex] == "手机号码" {
            
            let phoneNumber = userDefaults.value(forKey: userDefaultsKeys.userInfoMobile.rawValue)
            if let textInfo_t = phoneNumber {
                initialNumber = textInfo_t as! String
            }
        } else {
            let emailNumber = userDefaults.value(forKey: userDefaultsKeys.userInfoEmail.rawValue)
            if let textInfo_t = emailNumber {
                initialNumber = textInfo_t as! String
            }
        }
        
        if value == initialNumber {
            tlPrint(message: "绑定号码为注册号码")
            let getCodeUrl:String! = "Common/GetVerificationCode"
            //获取验证码
            futuGetRequestDataToString(serializer: .http, url: getCodeUrl, params: ["":""], success: { (response) in
                tlPrint(message: "response:\(response)")
                let sendCodeUrl = "Common/SendPassCode"
                let param = ["mobile":value!,"mode":verifyType,"verificationCode":response] as [String : Any]
                //发送验证码
                futuNetworkRequest(type: .get, serializer: .http, url: sendCodeUrl, params: param, success: { (response) in
                    tlPrint(message: "response:\(response)")
                    let string = String(data: response as! Data, encoding: String.Encoding.utf8)!
                    tlPrint(message: "string:\(string)")
                    if string == "Failed" || string == "\"Failed\""{
                        let alert = UIAlertView(title: "获取验证码失败", message: "系统繁忙，请稍后再试", delegate: nil, cancelButtonTitle: "确  定")
                        DispatchQueue.main.async {
                            alert.show()
                        }
                        getBtn.isEnabled = true
                        return
                    }
                    
                    self.mobileNumber = value!
                    self.getVerifyCodeTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.getVerifyCodeTimerAct), userInfo: nil, repeats: true)
                    tlPrint(message: "已经发送验证码，可以输入验证码了")
                    let alert = UIAlertView(title: "获取成功", message: "验证码已经发送成功，请输入验证码", delegate: nil, cancelButtonTitle: "确 定")
                    DispatchQueue.main.async {
                        alert.show()
                    }
                }, failure: { (error) in
                    tlPrint(message: "error:\(error)")
                    self.verifyInputInfoResult(canUse: false)
                    getBtn.isEnabled = true
                })
            }, failure: { (error) in
                tlPrint(message: "error:\(error)")
                self.verifyInputInfoResult(canUse: false)
                getBtn.isEnabled = true
            })
        } else {
            
            //判断信息是否可以绑定
            futuNetworkRequest(type: .get, serializer: .http, url: checkUrl, params: param, success: { (response) in
                tlPrint(message: "response:\(response)")
                
                let string = String(data: response as! Data, encoding: String.Encoding.utf8)!
                tlPrint(message: "string:\(string)")
                if string == "false" || string == "\"false\""{
                    tlPrint(message: "该号码已经被绑定")
                    self.verifyInputInfoResult(canUse: false)
                    return
                }
                self.verifyInputInfoResult(canUse: true)
                tlPrint(message: "号码可以绑定")
                let getCodeUrl:String! = "Common/GetVerificationCode"
                //获取验证码
                futuGetRequestDataToString(serializer: .http, url: getCodeUrl, params: ["":""], success: { (response) in
                    tlPrint(message: "response:\(response)")
                    let sendCodeUrl = "Common/SendPassCode"
                    let param = ["mobile":value!,"mode":verifyType,"verificationCode":response] as [String : Any]
                    //发送验证码
                    futuNetworkRequest(type: .get, serializer: .http, url: sendCodeUrl, params: param, success: { (response) in
                        tlPrint(message: "response:\(response)")
                        let string = String(data: response as! Data, encoding: String.Encoding.utf8)!
                        tlPrint(message: "string:\(string)")
                        if string == "Failed" || string == "\"Failed\"" {
                            let alert = UIAlertView(title: "获取验证码失败", message: "系统繁忙，请稍后再试", delegate: nil, cancelButtonTitle: "确  定")
                            DispatchQueue.main.async {
                                alert.show()
                            }
                            getBtn.isEnabled = true
                            tlPrint(message: "返回错误")
                            return
                        }
                        
                        self.mobileNumber = value!
                        self.getVerifyCodeTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.getVerifyCodeTimerAct), userInfo: nil, repeats: true)
                        tlPrint(message: "已经发送验证码，可以输入验证码了")
                        let alert = UIAlertView(title: "获取成功", message: "验证码已经发送成功，请输入验证码", delegate: nil, cancelButtonTitle: "确 定")
                        DispatchQueue.main.async {
                            alert.show()
                        }
                    }, failure: { (error) in
                        tlPrint(message: "error:\(error)")
                    })
                }, failure: { (error) in
                    tlPrint(message: "邮箱验证发送失败\nerror:\(error)")
                    self.verifyInputInfoResult(canUse: false)
                    getBtn.isEnabled = true
                })
            }, failure: { (error) in
                tlPrint(message: "获取邮箱验证码失败\nerror:\(error)")
                self.verifyInputInfoResult(canUse: false)
                getBtn.isEnabled = true
            })
            
        }
    }
    
    var leftTime = 120
    @objc func getVerifyCodeTimerAct() -> Void {
        
        //tlPrint(message: "getVerifyCodeTimerAct")
        let getCodeBtn = self.modifyView.viewWithTag(personBtnTag.GetVerifyCodeButton.rawValue) as! UIButton
        if leftTime <= 0 {
            getCodeBtn.isUserInteractionEnabled = true
            getCodeBtn.setTitle("获取验证码", for: .normal)
            getCodeBtn.setTitleColor(UIColor.colorWithCustom(r: 186, g: 9, b: 31), for: .normal)
            self.getVerifyCodeTimer.invalidate()
            leftTime = 120
        } else {
            getCodeBtn.isUserInteractionEnabled = false
            getCodeBtn.setTitle("\(leftTime)秒", for: .normal)
            getCodeBtn.setTitleColor(UIColor.colorWithCustom(r: 169, g: 169, b: 169), for: .normal)
            leftTime -= 1
        }
    }
    
    func verifyInputInfoResult(canUse:Bool?) -> Void {
        let alert = self.modifyView.viewWithTag(personBtnTag.AlertLableTag.rawValue) as! UILabel
        let img = self.modifyView.viewWithTag(personBtnTag.RightImageTag.rawValue) as! UIImageView
        if canUse == nil {
            alert.isHidden = true
            img.isHidden = true
        } else if canUse! {
            img.isHidden = false
            alert.isHidden = true
        } else {
            alert.isHidden = false
            img.isHidden = true
        }
    }
    
    
    func finishVerifyBtnAct() -> Void {
        
//        self.emailRedbag()
//        return
        
        tlPrint(message: "finishVerifyBtnAct")
        let infoField = self.modifyView.viewWithTag(personBtnTag.InfoVerifyTextFieldTag.rawValue) as! UITextField
        let codeField = self.modifyView.viewWithTag(personBtnTag.InfoVerifyCodeFieldTag.rawValue) as! UITextField
        let verifyCode = codeField.text
        if self.mobileNumber == nil {
            let alert = UIAlertView(title: "验证失败", message: "你的号码没有验证成功，请重新尝试", delegate: nil, cancelButtonTitle: "确  定")
            DispatchQueue.main.async {
                alert.show()
            }
            return
        }
        if verifyCode == nil || verifyCode! == "" || (verifyCode!).characters.count != 6 {
            let alert = UIAlertView(title: "验证失败", message: "请输入正确的验证码", delegate: nil, cancelButtonTitle: "确  定")
            DispatchQueue.main.async {
                alert.show()
            }
            return
        }
        var verifyType: Int = 0
        
        if model.infoLabel[self.textIndex] == "手机号码" {
            verifyType = 0
            
        } else {
            verifyType = 1
        }
        //检验信息是否可用
        var checkUrl:String
        var infoParam: [String:String]!
        if self.model.infoLabel[self.textIndex] == "手机号码" {
            checkUrl = "Account/CheckHFMobileBind"
            infoParam = ["mobile":infoField.text!]
        } else {
            checkUrl = "Account/CheckHFEmailBind"
            infoParam = ["Email":infoField.text!]
        }
        
        futuNetworkRequest(type: .get, serializer: .http, url: checkUrl, params: infoParam, success: { (response) in
            let string = String(data: response as! Data, encoding: String.Encoding.utf8)!
            tlPrint(message: "string:\(string)")
            if string == "false" || string == "\"false\"" {
                tlPrint(message: "已经被注册过了")
                let alert = UIAlertView(title: "", message: "该账号已经被注册过，请使用新的号码再试！", delegate: nil, cancelButtonTitle: "确  定")
                DispatchQueue.main.async {
                    alert.show()
                }
                return
            }
            
            //检验验证码是否正确
            
            var bindParamKey = "mobile"
            var bindUrl = "Account/BindMobile"
            if self.model.infoLabel[self.textIndex] == "手机号码" {
                bindParamKey = "mobile"
                bindUrl = "Account/BindMobile"
            } else if self.model.infoLabel[self.textIndex] == "电子邮箱"{
                bindParamKey = "email"
                bindUrl = "Account/BindEmail"
            }
            tlPrint("bindParamKey = \(bindParamKey)  \(self.model.infoLabel[self.textIndex])")
            let url = "Common/VerifyAppPassCode"
            let param = ["mobile":self.mobileNumber,"passCode":verifyCode!,"mode":verifyType] as [String : Any]
            tlPrint("url:\(url)   \nparams:\(param)")
            futuNetworkRequest(type: .get, serializer: .http, url: url, params: param, success: { (response) in
                tlPrint(message: "response:\(response)")
                let string = String(data: response as! Data, encoding: String.Encoding.utf8)!
                tlPrint(message: "string:\(string)")
                if string == "false" || string == "\"false\"" {
                    let alert = UIAlertView(title: "验证失败", message: "您输入的验证码不正确，请确认后重试", delegate: nil, cancelButtonTitle: "确  定")
                    DispatchQueue.main.async {
                        alert.show()
                    }
                    self.verifyInputInfoResult(canUse: false)
                    return
                }
                tlPrint(message: "验证成功")
                self.verifyInputInfoResult(canUse: true)
                
                //开始绑定信息
                futuNetworkRequest(type: .post, serializer: .http, url: bindUrl, params: [bindParamKey:self.mobileNumber], success: { (response) in
                    tlPrint("params:\(param)")
                    
                    tlPrint(message: "response:\(response)")
                    let string = String(data: response as! Data, encoding: String.Encoding.utf8)!
                    tlPrint(message: "string:\(string)")
                    //test
//                    self.emailRedbag()
                    
                    if string == "Failed" || string == "\"Failed\"" {
                        let alert = UIAlertView(title: "验证失败", message: "系统繁忙，请稍后再试", delegate: nil, cancelButtonTitle: "确  定")
                        DispatchQueue.main.async {
                            alert.show()
                        }
                        return
                    }
                    
                    
                    if bindParamKey == "email" {
                        tlPrint("邮箱绑定成功，开始匹配红包")
                        self.emailRedbag()
                    } else {
                        self.model.getAccount {
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                }, failure: { (error) in
                    tlPrint(message: "error:\(error)")
                })
            }, failure: { (error) in
                tlPrint(message: "error:\(error)")
            })
        }) { (error) in
            tlPrint(message: "error")
        }
        
        
        
        
        
        
        //        let url = "Common/VerifyPassCode"
        //        let param = ["mobile":self.mobileNumber,"passCode":verifyCode!,"mode":verifyType] as [String : Any]
        //
        //        futuNetworkRequest(type: .get, serializer: .http, url: url, params: param, success: { (response) in
        //            tlPrint(message: "response:\(response)")
        //            let string = String(data: response as! Data, encoding: String.Encoding.utf8)!
        //            tlPrint(message: "string:\(string)")
        //            if string == "false" {
        //                let alert = UIAlertView(title: "验证失败", message: "您输入的验证码不正确，请确认后重试", delegate: nil, cancelButtonTitle: "确  定")
        //                DispatchQueue.main.async {
        //                    alert.show()
        //                }
        //                return
        //            }
        //            tlPrint(message: "验证成功")
        //            var bindParamKey = "mobile"
        //            var bindUrl = "Account/Binddobile"
        //            if self.model.infoLabel[self.textIndex] == "手机号码" {
        //                bindParamKey = "mobile"
        //                bindUrl = "Account/BindMobile"
        //            } else {
        //                bindParamKey = "email"
        //                bindUrl = "Account/BindEmail"
        //            }
        //            futuNetworkRequest(type: .post, serializer: .http, url: bindUrl, params: [bindParamKey:self.mobileNumber], success: { (response) in
        //                tlPrint(message: "response:\(response)")
        //                let string = String(data: response as! Data, encoding: String.Encoding.utf8)!
        //                tlPrint(message: "string:\(string)")
        //                if string == "Failed" {
        //                    let alert = UIAlertView(title: "验证失败", message: "系统繁忙，请稍后再试", delegate: nil, cancelButtonTitle: "确  定")
        //                    DispatchQueue.main.async {
        //                        alert.show()
        //                    }
        //                    return
        //                }
        //                self.model.getAccount {
        //                    _ = self.navigationController?.popViewController(animated: true)
        //                }
        //
        //            }, failure: { (error) in
        //                tlPrint(message: "error:\(error)")
        //            })
        //        }, failure: { (error) in
        //            tlPrint(message: "error:\(error)")
        //        })
        
        
    }
    
    
    
    
    
    
    
    func inputInfoDeal() -> Void {
        tlPrint(message: "inputInfoDeal")
        var infoValue:[Any]! = [true]
        for i in 0 ..< infoArray.count {
            let textField = self.modifyView.viewWithTag(personBtnTag.InfoTextFeildTag.rawValue + i) as! UITextField
            let info = textField.text
            if info == nil || info == "" {
                let alert = UIAlertView(title: "保存失败", message: "请输入您的\(infoArray[i])", delegate: nil, cancelButtonTitle: "确  定")
                DispatchQueue.main.async {
                    alert.show()
                }
                return
            } else {
                var validate = true
                switch i {
                case ValidatedType.Email.rawValue:
                    validate = infoVerify.EmailIsValidated(vStr: info! as String)
                case ValidatedType.QQNumber.rawValue:
                    validate = infoVerify.QQNumberIsValidated(vStr: info! as String)
                default:
                    tlPrint(message: "无需验证")
                }
                if !validate {
                    let alert = UIAlertView(title: "保存失败", message: "请输入正确的\(infoArray[i])", delegate: nil, cancelButtonTitle: "确  定")
                    DispatchQueue.main.async {
                        alert.show()
                    }
                    return
                } else {
                    tlPrint(message: "信息验证成功")
                    infoValue.append(info ?? "info")
                }
            }
        }
        tlPrint(message: "infoValue:\(infoValue)")
        requestUserInfoModify(info: infoValue)
    }
    
    func requestUserInfoModify(info:[Any]) -> Void {
        
        let requestInfo = ["Sex":info[0],"BirthDate":info[1],"Email":info[2],"QQ":info[3],"Wechat":info[4]]
        let url = model.infoModifyAddr
        futuNetworkRequest(type: .post, serializer: .http, url: url, params: requestInfo, success: { (response) in
            tlPrint(message: "response:\(response)")
            self.model.getAccount {
                _ = self.navigationController?.popViewController(animated: true)
            }
            
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
        })
        
        
    }
    
    
    
    
    
    //    enum ValidatedType:Int{
    ////        case BirthDate = 0,PhoneNumber,Email,QQNumber,WechatNumber
    //        case BirthDate = 0,Email,QQNumber,WechatNumber,Phone
    //    }
    //    func EmailIsValidated(vStr: String) -> Bool {
    //        return ValidateText(validatedType: .Email, validateString: vStr)
    //    }
    //
    //    func QQNumberIsValidated(vStr: String) -> Bool {
    //        return ValidateText(validatedType: .QQNumber, validateString: vStr)
    //    }
    //
    //    func ValidateText(validatedType type: ValidatedType, validateString: String) -> Bool {
    //        do {
    //            let pattern: String
    //            if type == .Email {
    //                pattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
    ////            } else if type == .PhoneNumber {
    ////                pattern = "^1[0-9]{10}$"
    //            } else if type == .QQNumber {
    //                pattern = "^[0-9]{5,11}$"
    //            } else if type == .Phone {
    //                pattern = "^1[0-9]{10}$"
    //            } else {
    //                pattern = "^[0-9]{0,20}$"
    //            }
    //
    //            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
    //            let matches = regex.matches(in: validateString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, validateString.characters.count))
    //            return matches.count > 0
    //        }
    //        catch {
    //            return false
    //        }
    //    }
    
    
    
    
    func emailRedbag() -> Void {
        //邮箱邀请红包
        
        //匹配邮箱，判断是否可以领取红包
        self.getEmailRedbag(success: { (responseDic) in
            tlPrint("responseDic = \(responseDic)")
            
//            let responseDic = ["amount": 0, "status": 0, "msg": "对不起，您不是邀请贵宾！"] as [String : Any]
            if responseDic["status"] as! Int == 0 {
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(responseDic, forKey: userDefaultsKeys.emailRedbagMsg.rawValue)
                var emailRedbagInfo:[String:Any]
                if let emailRedbagInfo_t = userDefaults.value(forKey: userDefaultsKeys.emailRedbagMsg.rawValue){
                    emailRedbagInfo = emailRedbagInfo_t as! [String:Any]
//                    emailRedbagInfo = ["amount": 0, "status": 0, "msg": "对不起，您不是邀请贵宾！"]
                    if emailRedbagInfo["status"] as! Int != 0 {
                        return
                    }
                    let amount = emailRedbagInfo["amount"] as! Int
                    let msg = emailRedbagInfo["msg"] as! String
                    self.initEmailRedbag(infoArray: ["\(amount)元",msg])
                }
                
            } else {
                self.model.getAccount {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }, failure: {
            tlPrint("error")
            self.model.getAccount {
                _ = self.navigationController?.popViewController(animated: true)
            }
        })
        
        
    }
    
    
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
    
    //初始化邮箱匹配红包
    func initEmailRedbag(infoArray:[String]) -> Void {
        tlPrint("initEmailRedbag")
        let emailRedbagShadowView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.view.insertSubview(emailRedbagShadowView, aboveSubview: self.modifyView)
        emailRedbagShadowView.backgroundColor = UIColor.black
        emailRedbagShadowView.alpha = 0.8
        emailRedbagShadowView.tag = HomeTag.emailRedbagShadowViewTag.rawValue
        
        
        let emailRedbagView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.view.insertSubview(emailRedbagView, aboveSubview: emailRedbagShadowView)
        emailRedbagView.tag = HomeTag.emailRedbagViewTag.rawValue
        //金币
        let goldenImg = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: adapt_H(height: 433)))
        emailRedbagView.addSubview(goldenImg)
        goldenImg.image = UIImage(named: "EmailRedbag_golden.png")
        goldenImg.center = emailRedbagView.center
        //红包
        let redbagWidth = adapt_W(width: 239)
        let redbagImg = UIImageView(frame: CGRect(x: (width - redbagWidth) / 2, y: 0, width: redbagWidth, height: adapt_H(height: 317)))
        emailRedbagView.insertSubview(redbagImg, aboveSubview: goldenImg)
        redbagImg.image = UIImage(named: "EmailRedbag_redbag.png")
        redbagImg.isUserInteractionEnabled = true
        redbagImg.center = emailRedbagView.center
        //确认按钮
        let confirmBtnWidth = adapt_W(width: 144.5)
        let confirmBtnFrame = CGRect(x: (redbagWidth - confirmBtnWidth) / 2, y: adapt_H(height: 240), width: confirmBtnWidth, height: adapt_H(height: 38))
        let confirmBtn = baseVC.buttonCreat(frame: confirmBtnFrame, title: "", alignment: .center, target: self, myaction: #selector(self.emailRedbagBtnAct(sender:)), normalImage: UIImage(named:"EmailRedbag_confirm.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        redbagImg.addSubview(confirmBtn)
        confirmBtn.tag = personBtnTag.emailRedbagConfirmBtnTag.rawValue
        //红包金额标签
        //红包提示文本标签
        
        let labelFrameArray = [ CGRect(x: 0, y: adapt_H(height: 90), width: redbagWidth, height: adapt_H(height: 50)),CGRect(x: adapt_W(width: 50), y: adapt_H(height: 150), width: redbagWidth - adapt_W(width: 100), height: adapt_H(height: 50))]
        //        let labelTextArray = ["8.8元","恭喜你获得邮箱匹配奖金! 恭喜你获得邮箱匹配奖金"]
        let labelTextColorArray = [UIColor.colorWithCustom(r: 219, g: 0, b: 0),UIColor.colorWithCustom(r: 159, g: 17, b: 17)]
        for i in 0 ..< 2 {
            let label = baseVC.labelCreat(frame: labelFrameArray[i], text: infoArray[i], aligment: .center, textColor: labelTextColorArray[i], backgroundcolor: .clear, fonsize: fontAdapt(font: 12))
            redbagImg.addSubview(label)
            label.numberOfLines = 0
            
            
            switch i {
            case 0:
                tlPrint("")
                
                label.font = UIFont(name: "Arial-BoldMT", size: fontAdapt(font: 38))
                let hintString = NSMutableAttributedString(string: infoArray[i])
                let range = NSRange(location: infoArray[i].characters.count - 1, length: 1)
                hintString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.colorWithCustom(r: 245, g: 63, b: 0), range: range)
                
                hintString.addAttributes([NSAttributedStringKey.font:UIFont(name: "Arial-BoldMT", size: fontAdapt(font: 17))], range: range)
                
                label.attributedText = hintString
                break
                
            case 1:
                let attributedString:NSMutableAttributedString = NSMutableAttributedString(string:infoArray[i])
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = adapt_H(height: isPhone ? 6 : 4) //修改行间距
                attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0,  (infoArray[i]).characters.count))
                label.attributedText = attributedString
                label.textAlignment = .center
            default:
                tlPrint("no such case!")
            }
            
        }
        
        
        
        //金币动画效果
        UIView.animate(withDuration: 0.0001, animations: {
            goldenImg.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            goldenImg.isHidden = true
        }, completion: { (finished) in
            UIView.animate(withDuration: TimeInterval(0.5), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                goldenImg.isHidden = false
                goldenImg.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { (finisehd) in
                UIView.animate(withDuration: TimeInterval(0.3), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                    goldenImg.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }, completion: { (finisehd) in
                    UIView.animate(withDuration: TimeInterval(0.2), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                        goldenImg.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }, completion: { (finisehd) in
                        tlPrint(message: "动画完成")
                        
                    })
                    
                })
            })
        })
        
        //红包动画效果
        UIView.animate(withDuration: 0.0001, animations: {
            redbagImg.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            redbagImg.isHidden = true
        }, completion: { (finished) in
            UIView.animate(withDuration: TimeInterval(0.5), delay: TimeInterval(0.2), options: .allowUserInteraction, animations: {
                redbagImg.isHidden = false
                redbagImg.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: { (finisehd) in
                UIView.animate(withDuration: TimeInterval(0.2), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                    redbagImg.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: { (finisehd) in
                    
                })
            })
        })
    }
    
    
    
    func removeEmailRedbagView() -> Void {
        tlPrint("removeEmailRedbagView  移除邮箱匹配红包视图")
        
        let emailShadowView = self.view.viewWithTag(HomeTag.emailRedbagShadowViewTag.rawValue)!
        let emailRedbagView = self.view.viewWithTag(HomeTag.emailRedbagViewTag.rawValue)!
        
        UIView.animate(withDuration: 0.5, animations: {
            //            emailShadowView.frame = CGRect(x: self.width / 2, y: self.height, width: 0, height: 0)
            emailShadowView.alpha = 0
            emailRedbagView.frame = CGRect(x: 0, y: self.height, width: self.width, height: self.height)
        }) { (finished) in
            emailShadowView.removeFromSuperview()
            for view in emailRedbagView.subviews {
                view.removeFromSuperview()
            }
            emailRedbagView.removeFromSuperview()
            self.model.getAccount {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    @objc func emailRedbagBtnAct(sender:UIButton) {
        
        if sender.tag == personBtnTag.emailRedbagConfirmBtnTag.rawValue {
            self.removeEmailRedbagView()
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}
