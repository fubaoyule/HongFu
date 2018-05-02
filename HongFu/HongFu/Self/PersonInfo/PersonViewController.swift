//
//  PersonViewController.swift
//  FuTu
//
//  Created by Administrator1 on 19/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController,personDelegate,UIScrollViewDelegate,UITextFieldDelegate,UIAlertViewDelegate {

    
    var width, height: CGFloat!
    let baseVC = BaseViewController()
    var bankView: BankView!
    var personView: PersonView!
    var infoView: PersonView!
    var backHidenView,bankAlertView: UIView!
    let model = PersonModel()
    var bankData:[[Any]]!
    var infoType:InfoType!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.width = self.view.frame.width
        self.height = self.view.frame.height
        self.bankData = model.bankDataSource
        self.notifyRegister()

        //获取银行卡信息
        self.model.getBankInfo { (dataSource) in
            self.bankData = dataSource
            //self.bankData = self.model.bankDataSource
            
            self.bankView = BankView(frame: self.view.frame, param: "" as AnyObject, dataSource: self.bankData)
            self.bankView.delegate = self
            self.bankView.scroll.delegate = self
            self.bankView.textFeildDelegate = self
            
            self.infoView = PersonView(frame: self.view.frame, param: "" as AnyObject, rootVC: self)
            self.infoView.delegate = self
            self.infoView.scroll.delegate = self
            self.infoView.textFeildDelegate = self
            
            self.view.addSubview(self.bankView.self)
            self.view.addSubview(self.infoView.self)
            
            if self.infoType == InfoType.BankInfo {
                self.view.bringSubview(toFront: self.bankView)
            } else {
                self.view.bringSubview(toFront: self.infoView)
            }
        }
    }
    

    
    
    init(infoType:InfoType) {
        super.init(nibName: nil, bundle: nil)
        self.infoType = infoType
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tlPrint(message: "viewWillAppear")

        initInfoView()
        initBankView(notify: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    
    //注册消息通知
    func notifyRegister() -> Void {
        tlPrint(message: "notifyRegister")
        NotificationCenter.default.addObserver(self, selector: #selector(self.initBankView(notify:)), name: NSNotification.Name(rawValue:notificationName.BankInfoRefresh.rawValue), object: nil)
        
    }
    @objc func initBankView(notify:Notification?) -> Void {
        tlPrint(message: "initBankView")
        if notify != nil {
            tlPrint(message: "notify:\(String(describing: notify!.object))")
            self.bankData = notify?.object as! [[Any]]
            tlPrint(message: "**** bankData:\(self.bankData)")
        }
        
        
        if self.infoType == InfoType.PersonInfo {
            return
        }
        if self.bankView != nil {
            for view in self.bankView.subviews {
                view.removeFromSuperview()
            }
            bankView.removeFromSuperview()
            bankView = nil
        }
        tlPrint(message: "initBankView.dataSource = \(self.bankData)")
        self.bankView = BankView(frame: self.view.frame, param: "" as AnyObject, dataSource: self.bankData)
        self.bankView.delegate = self
        self.bankView.scroll.delegate = self
        self.bankView.textFeildDelegate = self
        self.view.addSubview(bankView.self)
        if self.infoType == InfoType.BankInfo {
            self.view.bringSubview(toFront: bankView)
        } else {
            self.view.bringSubview(toFront: infoView)
        }
    }
    
    
    func initInfoView() -> Void {
        tlPrint(message: "initInfoView")
        if self.infoType == InfoType.BankInfo {
            return
        }
        if self.infoView != nil {
            for view in infoView.subviews {
                view.removeFromSuperview()
            }
            infoView.removeFromSuperview()
            infoView = nil
        }
        infoView = PersonView(frame: self.view.frame, param: "" as AnyObject, rootVC: self)
        infoView.delegate = self
        infoView.scroll.delegate = self
        infoView.textFeildDelegate = self
        self.view.addSubview(infoView.self)
        if self.infoType == InfoType.BankInfo {
            self.view.bringSubview(toFront: bankView)
        } else {
            self.view.bringSubview(toFront: infoView)
        }
    }
    
    
    func persongBtnAct(btnTag: Int) {
        tlPrint(message: "persongBtnAct")
        switch btnTag {
        case personBtnTag.BackButton.rawValue:
            _ = self.navigationController?.popViewController(animated: true)
        case personBtnTag.InfoEditButton.rawValue:
            let modifyVC = InfoModifyViewController(modifyType: .edit, textIndex: btnTag - personBtnTag.InfoNextViewBtnTag.rawValue)
            self.navigationController?.pushViewController(modifyVC, animated: true)
        case personBtnTag.PersonInfoButton.rawValue:
            tlPrint(message: "个人资料")
        case personBtnTag.BankCardButton.rawValue:
            tlPrint(message: "银行卡")
            self.infoType = InfoType.BankInfo
            if self.bankView != nil {
                self.view.bringSubview(toFront: self.bankView)
            }
        case personBtnTag.LogOutButton.rawValue:
            tlPrint(message: "退出登录")
            let alert = UIAlertView(title: "", message: "您确定要退出吗？", delegate: self, cancelButtonTitle: "取 消", otherButtonTitles: "确 定")
            alert.show()
            alert.tag = 10
            
        default:
            if btnTag >= personBtnTag.InfoNextViewBtnTag.rawValue {
                tlPrint(message: "准备进入资料绑定页面")
                var moditype = ModifyType.bind
                if btnTag == personBtnTag.InfoNextViewBtnTag.rawValue + 7 {
                    moditype = .password
                }
                let modifyVC = InfoModifyViewController(modifyType: moditype, textIndex: btnTag - personBtnTag.InfoNextViewBtnTag.rawValue)
                modifyVC.textIndex = btnTag - personBtnTag.InfoNextViewBtnTag.rawValue
                self.navigationController?.pushViewController(modifyVC, animated: true)
                
            } else {
                tlPrint(message: "no such case")
            }
        }
    }
    
    
    func bankBtnAct(btnTag: Int) {
        tlPrint(message: "bankBtnAct btnTag = \(btnTag)")
        switch btnTag {
        case personBtnTag.BackButton.rawValue:
            _ = self.navigationController?.popViewController(animated: true)
        case personBtnTag.PersonInfoButton.rawValue:
            tlPrint(message: "个人信息")
            if self.infoView == nil {
                self.initInfoView()
                self.infoType = InfoType.PersonInfo
                return
            }
            self.view.bringSubview(toFront: infoView)
        case personBtnTag.BankCardButton.rawValue:
            tlPrint(message: "银行卡")
        case personBtnTag.addButton.rawValue:
            tlPrint(message: "添加银行卡")
            self.showBankAlert()
        
        default:
            if btnTag >= 100 && btnTag < 150 {
                tlPrint(message: "银行卡 卡片按钮事件")
                bankView.bankCardBtnAct(sender: btnTag)
            } else {
                tlPrint(message: "no such case")
            }
        }
    }
    //显示银行卡弹窗
    func showBankAlert() -> Void {
        tlPrint(message: "showBankAlert")
        if backHidenView == nil {
            backHidenView = bankView.bankBackHideView()
            self.view.addSubview(backHidenView)
            self.view.bringSubview(toFront: backHidenView)
        } else {
            backHidenView.isHidden = false
        }
        
        
        if bankAlertView == nil {
            bankAlertView = bankView.addBankAlertView()
            bankAlertView.center = self.view.center
            self.view.insertSubview(bankAlertView, aboveSubview: backHidenView)
            tlPrint(message: "backHidenView: \(backHidenView)")
        } else {
            bankAlertView.isHidden = false
        }
        
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        switch alertView.tag {
        case 10:
            //没有登录弹窗
            tlPrint(message: "buttonIndex:\(buttonIndex)")
            if buttonIndex == 1 {
                LogoutController.logOut()
                LogoutController.clearnUserInfo()
                let tabBarVC = CustomTabBarController()
                self.navigationController?.pushViewController(tabBarVC, animated: true)
            }
        default:
            tlPrint(message: "no such case")
        }
    }
    
    

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tlPrint(message: "textFieldDidEndEditing")
    }
    
    
    var currentTextFeild: UITextField!
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tlPrint(message: "touchesEnded")
        if currentTextFeild == nil {
        
            return
        }
        
        currentTextFeild.resignFirstResponder()
        
        if currentTextFeild.tag >= personBtnTag.BankAlertTextFieldTag.rawValue && currentTextFeild.tag < personBtnTag.InfoTextFeildTag.rawValue {
            //添加银行卡弹出的输入框
            UIView.animate(withDuration: 0.2, animations: {
                self.bankAlertView.center = self.view.center
            
            })
        }
        tlPrint(message: "touchesEnded end")
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tlPrint(message: "textFieldShouldBeginEditing")
        
        
        
        
        currentTextFeild = textField
        if currentTextFeild.tag >= personBtnTag.BankAlertTextFieldTag.rawValue + 1 && currentTextFeild.tag < personBtnTag.BankAlertTextFieldTag.rawValue + 4 {
            UIView.animate(withDuration: 0.2, animations: {
                self.bankAlertView.frame = CGRect(x: adapt_W(width: isPhone ? 20 : 50), y: adapt_H(height: 20), width: self.width - adapt_W(width: isPhone ? 40 : 100), height: adapt_H(height: isPhone ? 330 : 240))
            })
            for i in 1 ..< 4 {
                let alertLabel = self.bankView.alertView.viewWithTag(personBtnTag.infoAlertLabelTag.rawValue + i) as! UILabel
                alertLabel.isHidden = true
            }
        }
        
        tlPrint(message: "textFieldShouldBeginEditing end")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tlPrint(message: "textFieldShouldReturn")
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.2, animations: {
            self.bankAlertView.center = self.view.center

        })
        tlPrint(message: "textFieldShouldReturn end")
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
