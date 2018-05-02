//
//  RgstPassViewController.swift
//  FuTu
//
//  Created by Administrator1 on 2/1/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

class RgstPassViewController: UIViewController,UITextFieldDelegate,BtnActDelegate {

    
    var baseInfo:[String]!
    var currentTextField: UITextField!
    var passView:RgstPassView!
    let model = RgstPassModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passView = RgstPassView(frame: self.view.frame, rootVC: self)
        self.view.addSubview(passView)
        passView.delegate = self
        
    }
    
    func btnAct(btnTag: Int) {
        tlPrint(message: "btnAct btnTag:\(btnTag)")
        switch btnTag {
        case RgstPassTag.cancelBtnTag.rawValue:
            _ = self.navigationController?.popViewController(animated: true)
        case RgstPassTag.finishBtntag.rawValue:
            tlPrint(message: "完成按钮")
            finishBtnAct()
        default:
            tlPrint(message: "no such case")
        }
    }
    
    func finishBtnAct() -> Void {
        tlPrint(message: "finishBtnAct")
        var securityInfo = [""]
        self.verifyAllInfo(index: 0, success: { (info0) in
            securityInfo.append(info0)
            self.verifyAllInfo(index: 1, success: { (info1) in
                securityInfo.append(info1)
                self.verifyAllInfo(index: 2, success: { (info2) in
                    securityInfo.append(info2)
                    tlPrint(message: "securityInfo:\(securityInfo)")
                    securityInfo.remove(at: 0)
                    let param = ["Username":self.baseInfo[0],"Password":securityInfo[1],"ConfirmPassword":securityInfo[2],"RealName":securityInfo[0],"Phone":self.baseInfo[1],"Email":self.baseInfo[2],"Captcha":self.baseInfo[3],"RegApp":1] as [String:Any]
                    
                    futuNetworkRequest(type: .post, serializer: .json, url: "Account/Reg", params: param, success: { (response) in
                        tlPrint(message: "response:\(response)")
                        if (response as AnyObject).value(forKey: "Value") as! Bool {
                           
                            tlPrint(message: "注册成功")
                            
                            userDefaults.setValue(self.baseInfo[0], forKey: userDefaultsKeys.userName.rawValue)
                            userDefaults.setValue(securityInfo[1], forKey: userDefaultsKeys.passWord.rawValue)
                            userDefaults.setValue(true, forKey: userDefaultsKeys.userHasLogin.rawValue)
                            userDefaults.setValue(true, forKey: userDefaultsKeys.isFirstLogin.rawValue)
                            let loginVC = LoginViewController()
                            self.navigationController?.pushViewController(loginVC, animated: true)

                        } else {
                            userDefaults.setValue(false, forKey: userDefaultsKeys.isFirstLogin.rawValue)
                            let message = (response as AnyObject).value(forKey: "Message") as! String
                            let alert = UIAlertView(title: "注册失败", message: message, delegate: nil, cancelButtonTitle: "确 定")
                            DispatchQueue.main.async {
                                alert.show()
                            }
                        }
                        
                    }, failure: { (error) in
                        tlPrint(message: "error:\(error)")
                    })
                })
            })
        })
    }
    
    func verifyAllInfo(index:Int,success:@escaping((String)->())) -> Void {
        let textField = self.passView.viewWithTag(RgstPassTag.realNameText.rawValue + index) as! UITextField
        self.verifyInputInfo(textField: textField, success: {
            success(textField.text!)
        }, failed: {
            tlPrint(message: "*******   返回失败信息！   *******")
            return
        })
    }
    
    func verifyInputInfo(textField:UITextField, success:@escaping(()->()),failed:@escaping(()->())) -> Void {
        tlPrint(message: "verifyInputInfo")
        var userInfo = textField.text
        if userInfo == nil || userInfo == "" {
            tlPrint(message: "用户没有输入该信息")
            failed()
            return
        }
        let infoVerify = InfoVerify()
        userInfo = userInfo?.replacingOccurrences(of: " ", with: "")
        var verifyType = ValidatedType.RealName
        switch textField.tag {
        case RgstPassTag.realNameText.rawValue:
            tlPrint(message: "真实姓名输入框失去焦点")
            verifyType = .RealName
            success()
            return
        case RgstPassTag.passwordText.rawValue:
            tlPrint(message: "密码输入框失去焦点")
            verifyType = .Password
        case RgstPassTag.confirmText.rawValue:
            tlPrint(message: "确认密码输入框失去焦点")
            verifyType = .Password
        default:
            tlPrint(message: "no such case")
        }
        //判断格式是否正确
        if !infoVerify.ValidateText(validatedType: verifyType, validateString: userInfo!) {
            tlPrint(message: "输入格式不正确")
            showAlertInfo(isHiden: false, info: "当前输入格式有误")
            SystemTool.systemVibration(loopTimes: 1, intervalTime: 0)
            failed()
            return
        }
        //判断两次密码是否一致
        if textField.tag == RgstPassTag.passwordText.rawValue || textField.tag == RgstPassTag.confirmText.rawValue {
            let confirmText = self.passView.viewWithTag(RgstPassTag.confirmText.rawValue) as! UITextField
            let passText = self.passView.viewWithTag(RgstPassTag.passwordText.rawValue) as! UITextField
            
            if confirmText.text == nil || confirmText.text! == "" || passText.text == nil || passText.text! == "" {
                tlPrint(message: "密码框没有全部输入")
                return
            }
            if confirmText.text != passText.text {
                tlPrint(message: "两次输入不一致")
                showAlertInfo(isHiden: false, info: "两次输入不一致")
            }
            success()
            return
        }
    }
    
    
    func showAlertInfo(isHiden:Bool,info:String?) -> Void {
        
        let alertLabel = self.passView.viewWithTag(RgstPassTag.infoAlertLabelTag.rawValue) as! UILabel
        alertLabel.isHidden = isHiden
        
        if info == nil {
            return
        }
        alertLabel.text = info!
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tlPrint(message: "textFieldShouldBeginEditing")
        //鼠标进入UITextField
        currentTextField = textField
        showAlertInfo(isHiden: true, info: nil)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tlPrint(message: "textFieldDidBeginEditing")
        currentTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tlPrint(message: "textFieldDidEndEditing")
        //self.loginBtn.isUserInteractionEnabled = true
        self.verifyInputInfo(textField: textField, success: {
        }, failed: {
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tlPrint(message: "textFieldShouldReturn")
        //在输入框里,在虚拟键盘上点击return
        if currentTextField != nil {
            currentTextField.resignFirstResponder()
        }
        return true
    }
    
    //触摸完毕关闭键盘
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tlPrint(message: "touchesEnded")
        if currentTextField != nil {
            currentTextField.resignFirstResponder()
            
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
