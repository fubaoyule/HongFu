//
//  RegisterViewController.swift
//  FuTu
//
//  Created by Administrator1 on 2/1/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

protocol registerTapDelegate {
    func registerTapAct(sender:UITapGestureRecognizer)
}

class RegisterViewController: UIViewController,UITextFieldDelegate, BtnActDelegate ,registerTapDelegate{

    
    var currentTextField: UITextField!
    var registerView:RegisterView!
    let model = RegisterModel()
    var isMale:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        getVerifyImage()
        registerView = RegisterView(frame: self.view.frame, rootVC: self)
        self.view.addSubview(registerView)
        registerView.delegate = self
        
    }
    
    
    func getVerifyImage() -> Void {
        
        self.model.getVefiryImageUrl { (imageUrl) in
            
            tlPrint(message: "imageUrl:\(imageUrl)")
            let img = self.registerView.viewWithTag(RegisterTag.verifyImgTag.rawValue) as! UIImageView
            let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
            let url = URL(string: domain + imageUrl)
            tlPrint(message: "verify image URL:\(String(describing: url))")
            img.sd_setImage(with: url!)
        }
    }
    
    func verifyAllInfo(index:Int,success:@escaping((String)->())) -> Void {
        //let baseInfoKey = ["Username","Phone","Email","Captcha"]
        let textField = self.registerView.viewWithTag(RegisterTag.usernameText.rawValue + index) as! UITextField
        self.verifyInputInfo(textField: textField, success: {
            if index == 0 {
                success("HF\(textField.text!)")
            } else {
                success(textField.text!)
            }
        }, failed: {
            tlPrint(message: "*******   返回失败信息！   *******")
            return
        })
    }
    
    
    func verifyInputInfo(textField:UITextField, success:@escaping(()->()),failed:@escaping(()->())) -> Void {
        tlPrint(message: "verifyInputInfo")
        var userInfo = textField.text
        tlPrint(message: "userInfo:\(String(describing: userInfo))")
        if userInfo == nil || userInfo == "" {
            tlPrint(message: "用户没有输入该信息")
            let alert = UIAlertView(title: "提 示", message:"请输入完整的信息！", delegate: nil, cancelButtonTitle: "确 认")
            alert.show()
            failed()
            return
        }
        let infoVerify = InfoVerify()
        userInfo = userInfo?.replacingOccurrences(of: " ", with: "")
        var url:String = ""
        var param = ["":""]
        var verifyType = ValidatedType.Phone
        switch textField.tag {
        case RegisterTag.usernameText.rawValue:
            tlPrint(message: "用户名输入框失去焦点")
            verifyType = .UserName
            url = "Account/CheckUsername"
            param = ["username":"HF\(userInfo!)"]
            userInfo = "HF\(userInfo!)"
        case RegisterTag.passwordText.rawValue:
            tlPrint(message: "密码输入框失去焦点")
            verifyType = .Password
        case RegisterTag.realNameText.rawValue:
            tlPrint(message: "真实姓名输入框失去焦点")
            verifyType = .RealName
            let realName = textField.text
            userInfo = realName
//            if realName == nil || !isChiness(string: textField.text!) {
//                tlPrint(message: "请输入正确的姓名")
//                let alertLabel = self.registerView.viewWithTag(RegisterTag.infoAlertLabelTag.rawValue + textField.tag - RegisterTag.usernameText.rawValue) as! UILabel
//                alertLabel.text = model.alertLabelText2[textField.tag - RegisterTag.usernameText.rawValue]
//                alertLabel.isHidden = false
//                SystemTool.systemVibration(loopTimes: 1, intervalTime: 0)
//                failed()
//                return
//            }
//            success()
//            return
            
            //新加内容start
        case RegisterTag.wechatText.rawValue:
            tlPrint(message: "微信号输入框失去焦点")
            verifyType = .WechatNumber
//            url = "Account/CheckWechat"
            param = ["wechat":userInfo!]
        case RegisterTag.birthdayText.rawValue:
            tlPrint(message: "微信号输入框失去焦点")
            verifyType = .BirthDate
            param = ["BirthDate":userInfo!]
            //新加内容end
        case RegisterTag.phoneNumberText.rawValue:
            tlPrint(message: "手机号输入框失去焦点")
            verifyType = .Phone
            url = "Account/CheckMobile"
            param = ["mobile":userInfo!]
        case RegisterTag.mailText.rawValue:
            tlPrint(message: "电子邮箱输入框失去焦点")
            verifyType = .Email
            url = "Account/CheckEmail"
            param = ["email":userInfo!]
        case RegisterTag.verifyText.rawValue:
            tlPrint(message: "验证码输入框失去焦点")
            verifyType = .VerifyCode
            param = ["captchaText":userInfo!]
            url = model.checkVerifyUrl
        default:
            tlPrint(message: "no such case")
        }
        //判断格式是否正确
        if !infoVerify.ValidateText(validatedType: verifyType, validateString: userInfo!) {
            tlPrint(message: "输入格式不对 verifyType:\(verifyType)")
            
            let alertLabel = self.registerView.viewWithTag(RegisterTag.infoAlertLabelTag.rawValue + textField.tag - RegisterTag.usernameText.rawValue) as! UILabel
            alertLabel.text = model.alertLabelText2[textField.tag - RegisterTag.usernameText.rawValue]
            alertLabel.isHidden = false
            SystemTool.systemVibration(loopTimes: 1, intervalTime: 0)
            failed()
            return
        }
        //真实姓名、密码、性别、生日、微信不用判断是否被占用（手机号、邮箱也不需要了，注册的时候再判断）
        if textField.tag == RegisterTag.realNameText.rawValue || textField.tag == RegisterTag.passwordText.rawValue || textField.tag == RegisterTag.genderText.rawValue || textField.tag == RegisterTag.birthdayText.rawValue || textField.tag == RegisterTag.wechatText.rawValue || textField.tag == RegisterTag.phoneNumberText.rawValue || textField.tag == RegisterTag.mailText.rawValue {
            success()
            return
        }
        
        //网络请求
        futuNetworkRequest(type: .get, serializer: .http, url: url, params: param, success: { (response) in
            //tlPrint(message: "response:\(response)")
            let string = String(data: response as! Data, encoding: String.Encoding.utf8)
            tlPrint(message: "string:\(String(describing: string))")
            if string == "false" {
                tlPrint(message: "已经被注册过了")
                let alertLabel = self.registerView.viewWithTag(RegisterTag.infoAlertLabelTag.rawValue + textField.tag - RegisterTag.usernameText.rawValue) as! UILabel
                alertLabel.text = self.model.alertLabelText[textField.tag - RegisterTag.usernameText.rawValue]
                alertLabel.isHidden = false
                SystemTool.systemVibration(loopTimes: 1, intervalTime: 0)
                failed()
                return
            }
            success()
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
            failed()
        })
    }
    
    
    //判断是否中文
    
    enum language {
        case ND
        case Chinese
        case Other
    }
//    func languageDetectByFirstCharacter (str:String?) -> language {
//        if str != nil && str != "" {
//            let SimplifiedChinese = 0x4E00 ... 0x9FFF
//            
//            
//            for chr in str!.substring(to: str!.index(str!.startIndex, offsetBy: 1)).unicodeScalars {
//                switch Int(chr.value) {
//                case let x where x >= SimplifiedChinese.startIndex && x <= SimplifiedChinese.endIndex :
//                    return language.Chinese
//                default :
//                    return language.Other
//                }
//            }
//            return language.Other
//        }
//        return language.ND
//    }
//    func isChiness(string:String) -> Bool {
//        tlPrint(message: "isChiness")
//        let match = "(^[\\u4e00-\\u9fa5]+$)"
//        let predicate = NSPredicate(format: "SELF matches %@", match)
//        let isChines = predicate.evaluate(with: string)
//        tlPrint(message: "isChines = \(isChines)")
//        return isChines
//    }
    
    
    func btnAct(btnTag: Int) {
        tlPrint(message: "btnAct btnTag:\(btnTag)")
        switch btnTag {
        case RegisterTag.cancelBtnTag.rawValue:
            _ = self.navigationController?.popViewController(animated: true)
        case RegisterTag.maleBtnTag.rawValue:
            tlPrint(message: "男性")
            let maleImg = self.registerView.viewWithTag(RegisterTag.maleImgTag.rawValue) as! UIImageView
            let femaleImg = self.registerView.viewWithTag(RegisterTag.femaleImgTag.rawValue) as! UIImageView
            let maleLabel = self.registerView.viewWithTag(RegisterTag.maleLabelTag.rawValue) as! UILabel
            let femaleLabel = self.registerView.viewWithTag(RegisterTag.femalelabelTag.rawValue) as! UILabel
            maleImg.image = UIImage(named: "forget_find_way1.png")
            femaleImg.image = UIImage(named: "forget_find_way2.png")
            maleLabel.textColor = UIColor.colorWithCustom(r: 255, g: 192, b: 0)
            femaleLabel.textColor = UIColor.colorWithCustom(r: 253, g: 129, b: 114)
            self.isMale = true
        case RegisterTag.femaleBtnTag.rawValue:
            tlPrint(message: "女性")
            let maleImg = self.registerView.viewWithTag(RegisterTag.maleImgTag.rawValue) as! UIImageView
            let femaleImg = self.registerView.viewWithTag(RegisterTag.femaleImgTag.rawValue) as! UIImageView
            let maleLabel = self.registerView.viewWithTag(RegisterTag.maleLabelTag.rawValue) as! UILabel
            let femaleLabel = self.registerView.viewWithTag(RegisterTag.femalelabelTag.rawValue) as! UILabel
            femaleImg.image = UIImage(named: "forget_find_way1.png")
            maleImg.image = UIImage(named: "forget_find_way2.png")
            femaleLabel.textColor = UIColor.colorWithCustom(r: 255, g: 192, b: 0)
            maleLabel.textColor = UIColor.colorWithCustom(r: 253, g: 129, b: 114)
        
            self.isMale = false
        case RegisterTag.BirthDageBtnTag.rawValue:
            let textField = self.registerView.viewWithTag(RegisterTag.birthdayText.rawValue) as! UITextField
            self.registerView.initUIPickerView(textField: textField)
            if haveMoveUp {
                tlPrint(message: "需要下移动画面")
                haveMoveUp = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.registerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                })
            }
        case RegisterTag.birthdayPikerConfirmBtnTag.rawValue:
            self.registerView.hiddenPikerView()
        case RegisterTag.registerBtnTag.rawValue:
            tlPrint(message: "注册按钮")
            self.registerBtnAct()
        case RegisterTag.loginBtnTag.rawValue:
            tlPrint(message: "返回登录")
            _ = self.navigationController?.popViewController(animated: true)
        default:
            tlPrint(message: "no such case")
        }
    }
    
    func registerTapAct(sender: UITapGestureRecognizer) {
        tlPrint(message: "registerTapAct")
        getVerifyImage()
    }
    
    func registerBtnAct() -> Void {
        var infos = [""]
        tlPrint(message: "registerBtnAct")
        self.verifyAllInfo(index: 0, success: { (info0) in
            infos.append(info0)
            self.verifyAllInfo(index: 1, success: { (info1) in
                infos.append(info1)
                self.verifyAllInfo(index: 2, success: { (info2) in
                    infos.append(info2)
                    self.verifyAllInfo(index: 3, success: { (info3) in
                        infos.append(info3)
                        infos.append(self.isMale ? "1" : "0")
                        self.verifyAllInfo(index: 5, success: { (info5) in
                            infos.append(info5)
                            self.verifyAllInfo(index: 6, success: { (info6) in
                                infos.append(info6)
                                self.verifyAllInfo(index: 7, success: { (info7) in
                                    infos.append(info7)
                                    self.verifyAllInfo(index: 8, success: { (info8) in
                                        infos.append(info8)
                                        infos.remove(at: 0)
                                        tlPrint(message: "infos:\(infos)")
                                        self.finishBtnAct(infos: infos)
                                    })
                                })
                            })
                        })
                    })
                })
            })
        })
    }
    
    
//    func registerBtnAction(index:Int, info:Array<String>) -> Void {
//        tlPrint(message: "registerBtnAct")
//        for _ in 0 ..< 9 {
//            
//        
//        
//        }
//        
//        
//    }
    
    
    func finishBtnAct(infos:Array<String>) -> Void {
        tlPrint(message: "finishBtnAct")
        let birthday = infos[3].replacingOccurrences(of: "/", with: "-")
        let param = ["Username":infos[0],"Password":infos[1],"RealName":infos[2],"BirthDate":birthday,"sex":infos[4],"wechat":infos[5],"Phone":infos[6],"Email":infos[7],"Captcha":infos[8],"RegApp":1] as [String:Any]
        tlPrint("param:\(param)")
        futuNetworkRequest(type: .post, serializer: .json, url: "Account/Reg", params: param, success: { (response) in
            tlPrint(message: "response:\(response)")
            if (response as AnyObject).value(forKey: "Value") as! Bool {
                
                tlPrint(message: "注册成功")
                userDefaults.setValue(infos[0], forKey: userDefaultsKeys.userName.rawValue)
                userDefaults.setValue(infos[1], forKey: userDefaultsKeys.passWord.rawValue)
                userDefaults.setValue(true, forKey: userDefaultsKeys.userHasLogin.rawValue)
                userDefaults.setValue(true, forKey: userDefaultsKeys.isFirstLogin.rawValue)
                let loginVC = LoginViewController()
                self.navigationController?.pushViewController(loginVC, animated: true)
                            
            } else {
                userDefaults.setValue(false, forKey: userDefaultsKeys.isFirstLogin.rawValue)
                let messageCode = (response as AnyObject).value(forKey: "MessageCode") as! String
                var message = (response as AnyObject).value(forKey: "Message") as! String
                if let errorMessage = self.model.loginErrorCodeDic[messageCode] {
                    message = errorMessage
                }
                
                let alert = UIAlertView(title: "注册失败", message: message, delegate: nil, cancelButtonTitle: "确 定")
                alert.show()
//                DispatchQueue.main.async {
//                    alert.show()
//                }
            }
                        
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
            userDefaults.setValue(false, forKey: userDefaultsKeys.isFirstLogin.rawValue)
            let message = "服务器异常，请联系客服处理！"
            let alert = UIAlertView(title: "注册失败", message: message, delegate: nil, cancelButtonTitle: "确 定")
            DispatchQueue.main.async {
                alert.show()
            }
            
        })
    }
    
    var haveMoveUp = false
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tlPrint(message: "textFieldShouldBeginEditing")
        //鼠标进入UITextField
        self.currentTextField = textField
        let alertLabel = self.registerView.viewWithTag(RegisterTag.infoAlertLabelTag.rawValue + textField.tag - RegisterTag.usernameText.rawValue) as! UILabel
        //隐藏错误提示标签
        alertLabel.isHidden = true
        //收起生日picker
        if self.registerView.pickerView != nil {
            self.registerView.hiddenPikerView()
        }
        if textField.tag >= RegisterTag.wechatText.rawValue {
            tlPrint(message: "需要上移动画面")
            haveMoveUp = true
            UIView.animate(withDuration: 0, animations: {
                self.registerView.frame = CGRect(x: 0, y: adapt_H(height: isPhone ? -200 : -50), width: self.view.frame.width, height: self.view.frame.height)
            })
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tlPrint(message: "textFieldDidBeginEditing")
        
//        if textField.tag == RegisterTag.birthdayText.rawValue {
//            textField.resignFirstResponder()
//            tlPrint(message: "输入出生日期")
//            self.view.endEditing(true)
//            self.registerView.initUIPickerView(textField: textField)
//            if currentTextField != nil {
//                currentTextField.resignFirstResponder()
//            }
//        }
        currentTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tlPrint(message: "textFieldDidEndEditing textField.tag = \(textField.tag)")
        //self.verifyInputInfo(textField: textField)
        textField.resignFirstResponder()
        if currentTextField != nil {
            currentTextField.resignFirstResponder()
        }
        
        self.verifyInputInfo(textField: textField, success: {
        }, failed: {
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tlPrint(message: "textFieldShouldReturn")
        textField.resignFirstResponder()
        view.endEditing(true)
        //在输入框里,在虚拟键盘上点击return
        if currentTextField != nil {
            currentTextField.resignFirstResponder()
        }
        if textField.tag >= RegisterTag.wechatText.rawValue && haveMoveUp {
            tlPrint(message: "需要下移动画面")
            haveMoveUp = false
            UIView.animate(withDuration: 0.2, animations: {
                self.registerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            })
        }
        if self.registerView.pickerView != nil {
            self.registerView.hiddenPikerView()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == RegisterTag.phoneNumberText.rawValue {
            if textField.text!.characters.count == 0 { return true}
            let exitstedLenth = textField.text!.characters.count
            let selectedLenth = range.length
            let replaceLenth = string.characters.count
            if (exitstedLenth - selectedLenth + replaceLenth) > 11 {
                return false
            }
        }
        
        return true
    }

    
    //触摸完毕关闭键盘
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tlPrint(message: "touchesEnded")
        if currentTextField != nil {
            currentTextField.resignFirstResponder()
            if currentTextField.tag >= RegisterTag.wechatText.rawValue && haveMoveUp{
                tlPrint(message: "需要下移动画面")
                haveMoveUp = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.registerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                })
            }
        }
        if self.registerView.pickerView != nil {
            self.registerView.hiddenPikerView()
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
