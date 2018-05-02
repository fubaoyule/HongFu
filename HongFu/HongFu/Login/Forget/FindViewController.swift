//
//  FindViewController.swift
//  FuTu
//
//  Created by Administrator1 on 2/1/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

class FindViewController: UIViewController,UIAlertViewDelegate,BtnActDelegate {

    var findView:FindView!
    var userInfo: [String:String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findView = FindView(frame: self.view.frame, rootVC: self)
        self.view.addSubview(findView)
        findView.delegate = self
        
    }
    
    func btnAct(btnTag: Int) {
        tlPrint(message: "btnAct btnTag:\(btnTag)")
        switch btnTag {
        case ForgetTag.cancelBtnTag.rawValue:
            _ = self.navigationController?.popViewController(animated: true)
        case ForgetTag.nextBtnTag.rawValue:
            tlPrint(message: "下一步按钮")
            
            futuNetworkRequest(type: .post, serializer: .http, url: "ccount/ResetPassword", params: userInfo, success: { (response) in
                tlPrint(message: "response:\(String(describing: response))")
                
                let wayText = ["手机","邮箱"]
                let alert = UIAlertView(title: "找回密码", message: "已经发送密码到您的\(wayText[self.findView.findWay])，请注意查收!", delegate: self, cancelButtonTitle: "去登录")
                alert.show()
                
            }, failure: { (error) in
                tlPrint(message: "error:\(String(describing: error))")
            })
        default:
            tlPrint(message: "no such case")
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        tlPrint(message: "clickedButtonAt buttonIndex:\(buttonIndex)")
        if buttonIndex == 0 {
            let loginVC = LoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
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
