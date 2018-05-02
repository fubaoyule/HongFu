//
//  TransferViewController.swift
//  FuTu
//
//  Created by Administrator1 on 6/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit


var isChanged:Bool = false

protocol TransferDelegates {
    
    func serviceBtnAct(sender:UIButton)
    func detailBtnAct(sender:UIButton)
    func changeBtnAct(sender:UIButton)
    func gameBtnAct(sender:UIButton)
    func alertBtnAct(sender:UIButton)
    func backBtnAct(sender:UIButton)
}
class TransferViewController: UIViewController, UIScrollViewDelegate,UITextFieldDelegate, TransferDelegates,UIAlertViewDelegate {

    var width,height: CGFloat!
    let model = TransferModel()
    var transferView: TransferView!
    var transInOutView:TransInOutView!
    //view 控件
    var topBackImg: UIImageView!//顶部背景图片视图
    var balanceTextLabel,balanceLabel: UILabel!
    var serviceBtn,detailBtn: UIButton!
    var isFromTabView:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.width = self.view.frame.width
        self.height = self.view.frame.height
        self.navigationController?.isNavigationBarHidden = true
        
        notifyRegister()

        getAccount(success: { 
            tlPrint(message: "转账页获取数据成功")
        }, failure: {
            tlPrint(message: "转账页获取数据失败")
        })
        
        self.view.backgroundColor = UIColor.clear
        transferView = TransferView(frame: self.view.frame, param: self.isFromTabView as AnyObject)
        transferView.delegate = self
        transferView.scroll.delegate = self
        self.view.addSubview(transferView.self)
        
        topBackImg = transferView.topBackImg
        balanceLabel = transferView.balanceLabel
        balanceTextLabel = transferView.textLabel
        //serviceBtn = transferView.serviceBtn
        detailBtn = transferView.detailBtn
//        refreshPull()
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
    
    
    //注册消息通知
    func notifyRegister() -> Void {
        tlPrint(message: "notifyRegister")
        NotificationCenter.default.addObserver(self, selector: #selector(self.modifyAccountLabel(sender:)), name: NSNotification.Name(rawValue: notificationName.TransferGameAccountModify.rawValue), object: nil)
        
    }
    //消息通知改变中心钱包金额
    var isInTransfer = true
    @objc func modifyAccountLabel(sender:Notification) -> Void {
        tlPrint(message: "sender:\(sender)")
        tlPrint(message: "modifyAccountLabel")
        let account = (sender.object as! Array<Any>)[0]
        if (account as! String).contains("请重新登录") && isInTransfer {
            isInTransfer = false
            let loginAlert = UIAlertView(title: "提示", message: "您的账户在别的地方登录，请重新登录!", delegate: self, cancelButtonTitle: "确 定")
            loginAlert.show()
            
            LogoutController.logOut()
            let loginVC = LoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
            return
        }
        let balanceLabel = self.transferView.scroll.viewWithTag(TransferTag.platformBalanceLabel.rawValue + ((sender.object as! Array<Any>)[1] as! Int)) as! UILabel
        
        
        balanceLabel.text = "¥\(account)"
        let balanceValue = "¥\(account)" as NSString
        let balanceValueSize = balanceValue.size(withAttributes: [NSAttributedStringKey.font :  UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 20 : 16))])
        let bNumWidth = balanceValueSize.width + adapt_W(width: 5)
        balanceLabel.mas_remakeConstraints({ (make) in
            _ = make?.top.equalTo()(adapt_H(height: isPhone ? 20 : 18))
//            _ = make?.right.equalTo()(adapt_W(width: isPhone ? -20 : -17))
            _ = make?.right.equalTo()
            _ = make?.width.equalTo()(bNumWidth)
            _ = make?.height.equalTo()(balanceValueSize.height)
        })
    }

    
    
    func getAccount(success:@escaping(()->()),failure:@escaping(()->())) -> Void {
        //获取中心钱包余额
        if userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue) != nil {
            //getTokenTimer.invalidate()
            futuNetworkRequest(type: .get,serializer: .json, url: model.allAccountUrl, params: ["":""], success: { (response) in
                tlPrint(message: "response:\(response)")
                if "\(response)".range(of: "Failed") != nil {
                    failure()
                }
                let value = (response as AnyObject).value(forKey: "Value") as AnyObject
                let totleAccount = (value as AnyObject).value(forKey: "Balance")
                let balanceLabel = self.transferView.scroll.viewWithTag(TransferTag.balanceLabel.rawValue) as! UILabel
                let balanceAcount = retain2Decima(originString: "\(totleAccount!)")
                balanceLabel.text = "\(balanceAcount)"
            }, failure: { (error) in
                tlPrint(message: "error:\(error)")
                failure()
            })
            
            //获取各个平台的余额
            var j:Int = 0
            for i in 0 ..< model.imgName.count {
                let gameCode = selfGameCode[i]
                
                futuNetworkRequest(type: .get,serializer: .http, url: model.gameBalanceUrl, params: ["gamecode":gameCode], success: { (response) in
                    let string = String(data: response as! Data, encoding: String.Encoding.utf8)
                    
                    tlPrint(message: "amount \(i) :\(String(describing: string))")
                    self.model.gameAccountDeal(account: string!, index: i)
                    j += 1
                    if j >= selfGameName.count {
                        tlPrint("j = \(j)")
                        success()
                    }
                }, failure: { (error) in
                    tlPrint(message: "error:\(error)")
                    failure()
                })
            }
        }
    }
    

    


    //scroll view delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tlPrint(message: "scrollViewDidScroll ＊＊＊＊＊＊＊＊ 0")
        let offSetY:CGFloat = scrollView.contentOffset.y
        if offSetY < 0 {
            tlPrint(message: "scrollViewDidScroll ＊＊＊＊＊＊＊＊ 1")
            let originH = adapt_H(height: isPhone ? 200 : 140)
            let originW:CGFloat = width
            let newHeight = -offSetY + originH
            let newWidth = -offSetY * originW / originH + originW
            transferView.topBackImg.frame = CGRect(x: offSetY * originW / originH / 2, y: 0, width: newWidth, height: newHeight)
            if transferView.changeViewStatus == 1 {
                for i in 0 ..< 8 {
                    let gameView = transferView.scroll.viewWithTag(TransferTag.gameViewTag.rawValue + i)
                    
                    var transform = CATransform3DIdentity
                    transform.m34 = -1.0 / 400.0   //透视投影
                    let angle = CGFloat(Double.pi * 0.08 ) - offSetY / 150
                    transform = CATransform3DRotate(transform, angle, -1, 0, 0)//旋转
                    gameView?.layer.transform = transform
                }
            }
            tlPrint(message: "scrollViewDidScroll ＊＊＊＊＊＊＊＊ 2")
            //固定住头部的label和按钮
            transferView.textLabel.frame = CGRect(x: adapt_W(width: 29.5), y: adapt_H(height: (isPhone ? 40 : 22) + offSetY * (isPhone ? 0.666 : 0.444)), width: adapt_W(width: 150), height: adapt_H(height: isPhone ? 15 : 12))
            transferView.balanceLabel.frame = CGRect(x: adapt_W(width: 29.5), y: adapt_H(height: (isPhone ? 85 : 55) + offSetY * 0.333), width: width - adapt_W(width: 29.5), height: adapt_H(height: isPhone ? 33 : 30))
            detailBtn.center.y = balanceLabel.center.y
            tlPrint(message: "scrollViewDidScroll ＊＊＊＊＊＊＊＊ 3")
        }
    }
    
    
    var dragOffset:CGFloat = 0
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        tlPrint(message: "scrollViewDidEndDragging")
        dragOffset = scrollView.mj_offsetY
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        tlPrint(message: "scrollViewDidEndDecelerating")
        if dragOffset < -refreshHeight {
            refreshAct()
        }
    }
    var isRefreshing = false
    func refreshAct() -> Void {
        tlPrint(message: "refreshAct")
        
        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
            if !(hasLogin as! Bool) {//未登录
                return
            }
        } else {//持久存储没有登录信息
            return
        }
        if self.isRefreshing {
            return
        }
        
        let refreshIndecatorFrame = CGRect(x: (width - adapt_W(width: 20))/2 , y: adapt_H(height: isPhone ? 20 : 10), width: adapt_W(width: 20), height: adapt_W(width: 20))
        if self.transferView.refreshIndicator == nil {
            self.isRefreshing = true
            self.transferView.refreshIndicator = RefreshIndicator(view: self.transferView, frame: refreshIndecatorFrame)
        } else {
            self.isRefreshing = false
            self.transferView.refreshIndicator.refreshPlay(frame: refreshIndecatorFrame)
        }
        
        self.getAccount(success: {
            tlPrint(message: "转账页刷新数据成功")
            self.isRefreshing = true
            if self.transferView.refreshIndicator != nil {
                self.transferView.refreshIndicator.refreshStop()
            }
            for view in self.transferView.subviews {
                view.removeFromSuperview()
            }
            self.transferView.removeFromSuperview()
            self.transferView = nil
            self.transferView = TransferView(frame: self.view.frame, param: self.isFromTabView as AnyObject)
            self.transferView.delegate = self
            self.transferView.scroll.delegate = self
            self.view.addSubview(self.transferView)
            self.isRefreshing = false
        }, failure: {
            tlPrint(message: "转账页刷新数据失败")
            self.isRefreshing = false
            if self.transferView.refreshIndicator != nil {
                self.transferView.refreshIndicator.refreshStop()
            }
            
        })
    }
    
//    private func refreshPull() ->Void {
//        tlPrint(message: "refreshViewOfBlock")
//        let header = MJRefreshNormalHeader()
//        //修改字体
//        header.stateLabel.font = UIFont.systemFont(ofSize: 15)
//        //header.lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: 13)
//        header.stateLabel.textColor = UIColor.white
//        
//        //隐藏刷新提示文字
//        header.stateLabel.isHidden = true
//        //隐藏上次刷新时间
//        header.lastUpdatedTimeLabel.isHidden = true
//        header.setRefreshingTarget(self, refreshingAction: #selector(self.refreshAct))
//        
//        self.transferView.scroll.mj_header = header
//    }
//    
//    func refreshAct() -> Void {
//        tlPrint(message: "refreshAct")
//        getAccount()
//        self.transferView.scroll.mj_header.endRefreshing()
//    }
    
    
    
    
    //textField delegate
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        transInOutView.transferInTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            self.transInOutView.alertView.center = self.transInOutView.center
        })
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.3, animations: {
            self.transInOutView.alertView.frame = CGRect(x: adapt_W(width: 20), y: adapt_H(height: 80), width: self.width - adapt_W(width: 40), height: adapt_H(height: 205))
        })
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        transInOutView.transferInTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.4, animations: {
            self.transInOutView.alertView.center = self.transInOutView.center
        })
        return true
    }
    
    
    
    //Transferdelegate代理方法

    func serviceBtnAct(sender: UIButton) {
        tlPrint(message: "serviceBtnAct")
        self.checkLoginStatus {
            let serviceVC = ServiceViewController()
            self.navigationController?.pushViewController(serviceVC, animated: true)
        }
        
        
    }
    func detailBtnAct(sender: UIButton) {
        tlPrint(message: "detailBtnAct")
        self.checkLoginStatus {
            let tradeSearch = TradeSearchViewController(searchType: .Transfer)
            self.navigationController?.pushViewController(tradeSearch, animated: true)
        }
        
    }
    func changeBtnAct(sender: UIButton) {
        tlPrint(message: "changeBtnAct")
        if isChanged {
            isChanged = false
            self.transferView.initUnchangedScrollView()
        } else {
            isChanged = true
            self.transferView.initChangedScrollView()
        }
        
    }

    
    func gameBtnAct(sender: UIButton) {
        tlPrint(message: "gameBtnAct sender.tag = \(sender.tag)")
        self.checkLoginStatus {
            if sender.tag >= TransferTag.transIn.rawValue && sender.tag < TransferTag.transOut.rawValue {
                tlPrint(message: "转入")
                self.transInOutView = TransInOutView(frame: self.view.frame, param: sender.tag as AnyObject,rootVC:self)
            } else if sender.tag >= TransferTag.transOut.rawValue {
                tlPrint(message: "转出")
                self.transInOutView = TransInOutView(frame: self.view.frame, param: sender.tag as AnyObject,rootVC:self)
            }
            self.view.insertSubview(self.transInOutView, aboveSubview: self.transferView)
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
    
    
    func alertBtnAct(sender: UIButton) {
        tlPrint(message: "alertBtnAct")
        self.checkLoginStatus {
            switch sender.tag {
            case TransferTag.alertCloseBtnTag.rawValue:
                self.view.bringSubview(toFront: self.transferView)
                for view in self.transInOutView.subviews {
                    view.removeFromSuperview()
                }
                self.transInOutView.removeFromSuperview()
                self.transInOutView = nil
            case TransferTag.alertConfirmBtnTag.rawValue:
                self.transferValueDeal()
            default:
                tlPrint(message: "no such case")
            }
        }
    }
    
    
    func transferValueDeal() -> Void {
        let value = transInOutView.transferInTextField.text
        var amount:String = "0"
        if value == nil || value! == "" || value! <= "0" {
            tlPrint(message: "没有输入金额")
            let alert = UIAlertView(title: "转账失败", message: "您输入的金额有误，请重新输入！", delegate: nil, cancelButtonTitle: "确  定")
            DispatchQueue.main.async {
                alert.show()
            }
            return
        }
        amount = value!
        let url = transInOutView.transferType == "转入" ? model.deposit : model.withdrawl
        futuNetworkRequest(type: .post, serializer: .http, url: url, params: ["amount":amount,"gameCode":selfGameCode[self.transInOutView.gameIndex]], success: { (response) in
            tlPrint(message: "response:\(response)")
            let string = String(data: response as! Data, encoding: String.Encoding.utf8)
            tlPrint(message: "string0:\(String(describing: string))")
            
            if string!.contains("请重新登录!") {
                //test
                let loginAlert = UIAlertView(title: "提示", message: "您的账户在别的地方登录，请重新登录!", delegate: self, cancelButtonTitle: "确 定")
                loginAlert.show()
                
                LogoutController.logOut()
                let loginVC = LoginViewController()
                self.navigationController?.pushViewController(loginVC, animated: true)
                return
            }
            
            let stringDic = (string)?.objectFromJSONString() as! Dictionary<String, Any>
            let message = (stringDic as AnyObject).value(forKey: "Message") as! String
            let alert = UIAlertView(title: "转账", message: message, delegate: nil, cancelButtonTitle: "确 认")
            DispatchQueue.main.async {
                alert.show()
            }
            self.getAccount(success: { 
                tlPrint(message: "转账后刷新数据成功")
            }, failure: {
            tlPrint(message: "转账后刷新数据失败")
            })
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
        })
        
        //去掉弹窗
        self.view.bringSubview(toFront: self.transferView)
        self.transInOutView.backView.removeFromSuperview()
        self.transInOutView.backView = nil
        for view in self.transInOutView.subviews {
            view.removeFromSuperview()
        }
        self.transInOutView.removeFromSuperview()
        self.transInOutView = nil
    }
    
    func backBtnAct(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}





