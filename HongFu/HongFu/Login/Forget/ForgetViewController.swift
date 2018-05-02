//
//  ForgetViewController.swift
//  FuTu
//
//  Created by Administrator1 on 2/1/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit


class ForgetViewController: UIViewController,UITextFieldDelegate ,BtnActDelegate{

    var currentTextField: UITextField!
    var forgetView:ForgetView!
    let model = ForgetModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forgetView = ForgetView(frame: self.view.frame, rootVC: self)
        self.view.addSubview(forgetView)
        forgetView.delegate = self
        
    }
    
    func btnAct(btnTag: Int) {
        tlPrint(message: "btnAct btnTag:\(btnTag)")
        switch btnTag {
        case ForgetTag.cancelBtnTag.rawValue:
            _ = self.navigationController?.popViewController(animated: true)
        case ForgetTag.nextBtnTag.rawValue:
            tlPrint(message: "下一步按钮")
            nextBtnAct()
            
        default:
            tlPrint(message: "no such case")
        }
    }
    
    func nextBtnAct() -> Void {
        tlPrint(message: "nextBtnAct")
        
        let userNameText = self.forgetView.viewWithTag(ForgetTag.usernameText.rawValue) as! UITextField
        let realNameText = self.forgetView.viewWithTag(ForgetTag.realNameText.rawValue) as! UITextField
        if userNameText.text == nil || realNameText.text == nil {
            tlPrint(message: "请输入完整的信息")
            let alert = UIAlertView(title: "提醒", message: "", delegate: "请输入完整的信息", cancelButtonTitle: "确 定")
            DispatchQueue.main.async {
                alert.show()
            }
            return
        }
        verifyUserName(userInfo: userNameText.text!, success: {
            let param = ["AccountName":userNameText.text!,"RealName":realNameText.text!]
            
            let findVC = FindViewController()
            findVC.userInfo = param
            self.navigationController?.pushViewController(findVC, animated: true)
        }, failed: { 
            
        })
    }
    
    func verifyUserName(userInfo:String,success:@escaping(()->()),failed:@escaping(()->())) -> Void {
        //网络请求
        let url = "Account/CheckUsername"
        let param = ["username":userInfo]
        futuNetworkRequest(type: .get, serializer: .http, url: url, params: param, success: { (response) in
            //tlPrint(message: "response:\(response)")
            let string = String(data: response as! Data, encoding: String.Encoding.utf8)
            tlPrint(message: "string:\(String(describing: string))")
            let alertLabel = self.forgetView.viewWithTag(ForgetTag.forgetAlergLabel.rawValue) as! UILabel
            alertLabel.text = self.model.alertLabelText[0]
            if string != "false" {
                tlPrint(message: "该用户名不存在")
                alertLabel.isHidden = false
                SystemTool.systemVibration(loopTimes: 1, intervalTime: 0)
                return
            }
            alertLabel.isHidden = true
            success()
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
            failed()
        })
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
        if textField.tag == ForgetTag.realNameText.rawValue {
            return
        }
        if textField.text == nil {
            return
        }
        self.verifyUserName(userInfo: textField.text!, success: {
            tlPrint(message: " textField verifyUserName")
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
