//
//  CustomTabBarController.swift
//  FuTu
//
//  Created by Administrator1 on 2/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController,UIAlertViewDelegate {
    
    
    
    var subView,tabBarView : UIView!
    var img1 = UIImageView(), img2 = UIImageView(), img3 = UIImageView(), img4 = UIImageView(),img5 = UIImageView()
    var label1 = UILabel(), label2 = UILabel(), label3 = UILabel(), label4 = UILabel(),label5 = UILabel()
    let itemImages = ["home_toolbar_home1","home_toolbar_preferent1","home_toolbar_transfer1","home_toolbar_recharge1","home_toolbar_my1"]
    let itemImagesSelect = ["home_toolbar_home2","home_toolbar_preferent2","home_toolbar_transfer2","home_toolbar_recharge2","home_toolbar_my2"]
    var imgs:[UIImageView]!,labels:[UILabel]!
    
    var loginVC: LoginViewController!
    var homeVC:HomeViewController!
//    var serviceVC: ServiceViewController!
    var selfVC: SelfViewController!
    var transferVC: TransferViewController!
    var preferentVC: PreferentViewController!
    var rechargeVC: RechargeViewController!
    var currentControllerIndex = 0
    
    var tabBarVC = [UIViewController]()
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tlPrint(message: "self.frame = \(self.view.frame)")
        subView = UIView()
        self.view.insertSubview(subView, at: 1)
        subView.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()
            _ = make?.left.equalTo()
            _ = make?.right.equalTo()
            _ = make?.bottom.equalTo()(self.view.mas_bottom)?.setOffset(tabBarHeight)
        }
        
        self.initTabSubViewController(index: nil)
        
        
    }
    //Hiragino Sans GB
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        

    }
    
//    func initTabSubViewController(index:Int?) -> Void {
//        tlPrint(message: "initTabSubViewController")
//        if index == nil {
//            self.homeVC = HomeViewController()
//            self.transferVC = TransferViewController(isFromTab: true)
//            self.serviceVC = ServiceViewController()
//            self.selfVC = SelfViewController()
//        } else {
//            tlPrint(message: "controlelr index = \(index)")
//            
//            switch index! {
//            case 0:
//                self.homeVC.refreshAct()
//            case 1:
//                if self.transferVC.transferView != nil {
//                    self.transferVC.refreshAct()
//                }
//            case 3:
//                if self.selfVC.selfView != nil {
//                    self.selfVC.refreshAct()
//                }
//            default:
//                tlPrint(message: "no such case!")
//            }
//        }
//        tabBarVC = [homeVC,transferVC,serviceVC,selfVC]
//        self.setViewControllers(tabBarVC, animated: true)
//        //custom tabbar.
//        initCustomTabbar()
//    }
    func initTabSubViewController(index:Int?) -> Void {
        tlPrint(message: "initTabSubViewController")
        if index == nil {
            self.homeVC = HomeViewController()
            
            self.transferVC = TransferViewController(isFromTab: true)
            self.rechargeVC = RechargeViewController(isFromTab: true)
            self.selfVC = SelfViewController()
            self.preferentVC = PreferentViewController(pageType: .preferent)
            
            
            self.tabBarVC = [homeVC,preferentVC,transferVC,rechargeVC,selfVC]
            self.setViewControllers(tabBarVC, animated: true)
            self.initCustomTabbar()
        } else {
            tlPrint(message: "controlelr index = \(String(describing: index))")
            //客服页面不用刷新
            switch index! {
            case 0:
                self.homeVC.refreshAct()
            case 1:
                self.preferentVC.refreshAct()
            case 2:
                if self.transferVC.transferView != nil {
                    self.transferVC.refreshAct()
                }
            case 4:
                if self.selfVC.selfView != nil {
                    self.selfVC.refreshAct()
                }
            default:
                tlPrint(message: "no such case!")
            }
        }
        //        tabBarVC = [homeVC,transferVC,serviceVC,selfVC]
//        tabBarVC = [homeVC,preferentVC,transferVC,serviceVC,selfVC]
//        self.setViewControllers(tabBarVC, animated: true)
//        //custom tabbar.
//        initCustomTabbar()
    }
    
    
    
    func initCustomTabbar() -> Void {
        tlPrint(message: "initCustomTabbar")
        // 资源数据
        self.view.backgroundColor = UIColor.white
        
        let itmeNames = ["鸿福首页","优惠","转账","充值","个人"]
        imgs = [img1,img2,img3,img4,img5]
        labels = [label1,label2,label3,label4,label5]
        
        //TabBar View
        tabBarView = UIView()
        self.view.addSubview(tabBarView)
        tabBarView.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(self.view.mas_left)
            _ = make?.right.equalTo()(self.view.mas_right)
            _ = make?.bottom.equalTo()(self.view.mas_bottom)
            _ = make?.height.equalTo()(tabBarHeight)
        }
//        tabBarView.backgroundColor = UIColor.colorWithCustom(r: 241, g: 241, b: 241)
        let tabImg = UIImageView()
        self.tabBarView.addSubview(tabImg)
        tabImg.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()
            _ = make?.left.equalTo()
            _ = make?.bottom.equalTo()
            _ = make?.right.equalTo()
        }
        tabImg.image = UIImage(named: "tab_bg.png")
        tabImg.isUserInteractionEnabled = true
        
        //TabBar button
        let btnWidth = self.view.frame.width / CGFloat(isPhone ? 5 : 9)
        for i in 0 ..< 5 {
            let tabBarBtn = UIButton()
            tabImg.addSubview(tabBarBtn)
            tabBarBtn.mas_makeConstraints({ (make) in
                _ = make?.top.equalTo()(self.tabBarView.mas_top)
                _ = make?.bottom.equalTo()(self.tabBarView.mas_bottom)
                _ = make?.width.equalTo()(btnWidth)
                _ = make?.left.equalTo()(self.tabBarView.mas_left)?.setOffset((isPhone ? CGFloat(i) : CGFloat(i) + 2) * btnWidth)
            })
            tabBarBtn.addTarget(self, action: #selector(tabBtnAct(sender:)), for: .touchDown)
            tabBarBtn.tag = i
            
            //image
            tabBarBtn.addSubview(imgs[i])
            _ = imgs[i].mas_makeConstraints({ (make) in
                _ = make?.top.equalTo()(tabBarBtn.mas_top)?.setOffset(5)
                _ = make?.width.equalTo()(25)
                _ = make?.height.equalTo()(25)
                _ = make?.centerX.equalTo()(tabBarBtn.mas_centerX)
            })
            imgs[i].image = UIImage(named: itemImages[i])
            
            //label
            tabBarBtn.addSubview(labels[i])
            _ = labels[i].mas_makeConstraints({ (make) in
                _ = make?.top.equalTo()(self.imgs[i].mas_bottom)?.setOffset(5)
                _ = make?.left.equalTo()(tabBarBtn.mas_left)
                _ = make?.right.equalTo()(tabBarBtn.mas_right)
                _ = make?.bottom.equalTo()(tabBarBtn.mas_bottom)?.setOffset(-3)
            })
            labels[i].textAlignment = .center
            labels[i].text = itmeNames[i]
            labels[i].textColor = UIColor.colorWithCustom(r: 129, g: 129, b: 129)
            labels[i].font = UIFont.systemFont(ofSize: 10)
        }
        
        //提前加载优惠页面
//        self.subView.addSubview(tabBarVC[1].view)
//        img1.image = UIImage(named: itemImagesSelect[1])
        
        self.subView.addSubview(tabBarVC[0].view)
        img1.image = UIImage(named: itemImagesSelect[0])
        label1.textColor = UIColor.colorWithCustom(r: 255, g: 192, b: 0)
        
    }
    
    
    @objc func tabBtnAct(sender:UIButton) -> Void {
        tlPrint(message: "tabBtnAct tag == \(sender.tag)")
        
        if sender.tag == 1 || sender.tag == 2 || sender.tag == 3 || sender.tag == 4 {
            self.checkLoginStatus(hasLogin: { 
                if sender.tag == self.currentControllerIndex {
                    return
                }
                self.currentControllerIndex = sender.tag
                self.reloadAllPage(pageIndex:sender.tag)
                for i in 0 ... 4 {
                    if i == sender.tag {
                        self.imgs[i].image = UIImage(named: self.itemImagesSelect[i])
                        self.labels[i].textColor = UIColor.colorWithCustom(r: 255, g: 192, b: 0)
                        
                    } else {
                        self.imgs[i].image = UIImage(named: self.itemImages[i])
                        self.labels[i].textColor = UIColor.colorWithCustom(r: 129, g: 129, b: 129)
                    }
                }
                self.subView.addSubview(self.tabBarVC[sender.tag].view)
                return
            }, hasNotLogin: { 
                return
            })
        } else {
            if sender.tag == self.currentControllerIndex {
                return
            }
            self.currentControllerIndex = sender.tag
            self.reloadAllPage(pageIndex:sender.tag)
            for i in 0 ... 4 {
                if i == sender.tag {
                    imgs[i].image = UIImage(named: itemImagesSelect[i])
                    labels[i].textColor = UIColor.colorWithCustom(r: 255, g: 192, b: 0)
                    
                } else {
                    imgs[i].image = UIImage(named: itemImages[i])
                    labels[i].textColor = UIColor.colorWithCustom(r: 129, g: 129, b: 129)
                }
            }
            self.subView.addSubview(tabBarVC[sender.tag].view)
        }
        
        
     
    }
    
    //判断用户是否已经登录
    func checkLoginStatus(hasLogin:@escaping(()->()), hasNotLogin:@escaping(()->())) -> Void {
        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
            if !(hasLogin as! Bool) {
                let alert = UIAlertView(title: "您还没有登录", message: "", delegate: self, cancelButtonTitle: "再逛逛", otherButtonTitles: "登录/注册")
                alert.tag = 11
                alert.show()
                hasNotLogin()
                return
            }
        } else {
            let alert = UIAlertView(title: "您还没有登录", message: "", delegate: self, cancelButtonTitle: "再逛逛", otherButtonTitles: "登录/注册")
            alert.tag = 11
            alert.show()
            hasNotLogin()
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
    

    
    
    func reloadAllPage(pageIndex:Int) -> Void {
        tlPrint(message: "reloadAllPage")
        self.initTabSubViewController(index: pageIndex)
    }
    
    
//    //===========================================
//    //Mark:- 已经登陆过，自动登录处理
//    //===========================================
//    func autoLoginDeal() -> Void {
//        if loginVC == nil {
//            loginVC = LoginViewController()
//        }
//        tlPrint(message: "autoLoginDeal")
//        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
//            if hasLogin as! Bool {      //用户已经登录
//                
//                let network = TTNetworkRequest()
//                let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
//                let url = domain + loginApi
//                let username = userDefaults.value(forKey: userDefaultsKeys.userName.rawValue) as! String
//                let password = userDefaults.value(forKey: userDefaultsKeys.passWord.rawValue) as! String
//                let info =  ["grant_type":"password","username":username, "password":password]
//                
//                
//                network.postWithPath(path: url, paras: info, success: { (response) in
//                    
//                    if let value = response {
//                        self.loginVC.longinReturnDeal(response: value as AnyObject, username: username, password: password, isLoginPage: true)
//                    } else {
//                        self.loginVC.longinReturnDeal(response: ["error":"","error_description":"用户名或密码不正确"] as AnyObject, username: username, password: password, isLoginPage: true)
//                    }
//                    
//                }, failure: { (error) in
//                    tlPrint(message: "error:\(error)")
//                    DispatchQueue.main.async(execute: {
//                        let errorCode = error.localizedDescription
//                        tlPrint(message: "error code: \(errorCode)")
//                        //let alert = UIAlertView(title: "登录失败", message: errorCode, delegate: self, cancelButtonTitle: "确定")
//                        let alert = UIAlertView(title: "登录失败", message: "当前出现网络错误，请检查网络连接状态后再试！", delegate: self, cancelButtonTitle: "确定")
//                        alert.show()
//                        self.navigationController?.pushViewController(self.loginVC, animated: false)
//                    })
//                })
//            } else {
//                tlPrint(message: "userHasLogin = false")
//                self.navigationController?.pushViewController(self.loginVC, animated: false)//跳转到登陆界面
//            }
//        } else {
//            tlPrint(message: "userHasLogin 没有")
//            userDefaults.setValue(false, forKey: userDefaultsKeys.userHasLogin.rawValue)
//            self.navigationController?.pushViewController(self.loginVC, animated: false)//跳转到登陆界面
//        }
//    }
}
