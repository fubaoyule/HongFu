//
//  WithdrawViewController.swift
//  FuTu
//
//  Created by Administrator1 on 28/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class WithdrawViewController: UIViewController,BtnActDelegate,UITextFieldDelegate,UIAlertViewDelegate {

    
    var withdrawView:WithdrawView!
    var leftTimes:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var amount = ""
        if let amount_t = userDefaults.value(forKey: userDefaultsKeys.userInfoBalance.rawValue) {
            amount = amount_t as! String
        }
        withdrawView = WithdrawView(frame: self.view.frame, param: [self.leftTimes ,amount,"默认银行卡"], rootVC: self)
        
        self.view.addSubview(withdrawView)
        
        checkUserBankInfo {
            tlPrint(message: "可以提现")
        }
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    init(times:Int) {
        super.init(nibName: nil, bundle: nil)
        self.leftTimes = times
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func btnAct(btnTag: Int) {
        tlPrint(message: "withdrawBtnAct btnTag = \(btnTag)")
        if btnTag == withdrawTag.WithdrawBackBtnTag.rawValue {
            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        
        self.checkLoginStatus {
            switch btnTag {
                
            case withdrawTag.WithdrawNextBtnTag.rawValue:
                tlPrint(message: "下一步按钮")
                self.nextBtnAct()
            case withdrawTag.WithdrawBankBtnTag.rawValue:
                tlPrint(message: "选择银行按钮")
                let personVC = PersonViewController(infoType: .BankInfo)
                self.navigationController?.pushViewController(personVC, animated: true)
            default:
                tlPrint(message: "no such case")
            }
        }
    }
    
    func nextBtnAct() -> Void {
        tlPrint(message: "nextBtnAct")
        let textField = self.withdrawView.viewWithTag(withdrawTag.WithdrawInputTextTag.rawValue) as! UITextField
        let amount = textField.text
        if amount == nil || amount == "" {
            let alert = UIAlertView(title: "提醒", message: "您还没有输入金额", delegate: nil, cancelButtonTitle: "确定")
            DispatchQueue.main.async {
                alert.show()
            }
            return
        }
        //已经输入金额了
        self.withdrawView.nextBtn.isUserInteractionEnabled = false
        checkUserBankInfo {
            let url = "Transact/DoWithdrawal"
            let userId = userDefaults.value(forKey: userDefaultsKeys.userInfoId.rawValue)
            let param = ["UserId":userId,"Amount":amount!]
            
            futuNetworkRequest(type: .post, serializer: .json, url: url, params: param , success: { (response) in
                tlPrint(message: "response:\(response)")
                let message = (response as AnyObject).value(forKey: "Message") as! String
                tlPrint(message: "message:\(message)")
                let alert = UIAlertView(title: "提醒", message: message, delegate: nil, cancelButtonTitle: "确定")
                DispatchQueue.main.async {
                    alert.show()
                }
                self.withdrawView.nextBtn.isUserInteractionEnabled = true
                return
            }, failure: { (error) in
                tlPrint(message: "error:\(error)")
                self.withdrawView.nextBtn.isUserInteractionEnabled = true
            })
        }
        
    }
    
    func checkUserBankInfo(success:@escaping(()->())) -> Void {
        tlPrint(message: "checkUserBankInfo")
        let url = "UserBankInfo/CheckUserBankInfo"
        futuNetworkRequest(type: .get, serializer: .http, url: url, params: ["":""], success: { (response) in
            let string = String(data: response as! Data, encoding: String.Encoding.utf8)! as String
            tlPrint(message: "string:\(string)")
            if string == "true" {
                tlPrint(message: "已经绑定过银行卡了")
                
                success()
            } else {
                self.checkLoginStatus {
                    tlPrint(message: "您还没有绑定银行卡")
                    let alert = UIAlertView(title: "提醒", message: "您还没有绑定银行看，是否现在去绑定？", delegate: self, cancelButtonTitle: "返回", otherButtonTitles: "去绑定")
                    alert.tag = 10
                    DispatchQueue.main.async {
                        alert.show()
                    }
                }
            }
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
        }) 
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
        case 10:
            //没有绑定银行卡弹窗
            tlPrint(message: "buttonIndex:\(buttonIndex)")
            switch buttonIndex {
            case 0:
                tlPrint(message: "返回")
//                let notify = NSNotification.Name(rawValue: notificationName.HomeAccountValueRefresh.rawValue)
//                NotificationCenter.default.post(name: notify, object: nil)
//                _ = self.navigationController?.popViewController(animated: true)
            case 1:
                tlPrint(message: "确认")
                let personVC = PersonViewController(infoType: .BankInfo)
                self.navigationController?.pushViewController(personVC, animated: true)
            default:
                tlPrint(message: "no such case")
            }
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
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentTextField != nil {
            currentTextField.resignFirstResponder()
        }
    }
    
    //texeField delegate
    var currentTextField:UITextField!
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
