//
//  SelfViewController.swift
//  FuTu
//
//  Created by Administrator1 on 17/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class SelfViewController: UIViewController, UIScrollViewDelegate,selfDelegate,UIAlertViewDelegate {

    var width,height: CGFloat!
    let model = SelfModel()
    
    var selfView: SelfView!
    var backImg: UIImageView!
    var headBackView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.width = self.view.frame.width
        self.height = self.view.frame.height
        self.getUnReadMsgAccount()
        self.selfView = SelfView(frame: self.view.frame, param: "" as AnyObject, rootVC: self)
        self.selfView.delegate = self
        self.selfView.scroll.delegate = self
        backImg = selfView.backImg
        headBackView = selfView.headBackView
        self.view.addSubview(selfView.self)
        notifyRegister()
        //共用转账页的通知，不再需要重新获取数据。
        //self.getAccount()
//        self.refreshPull()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tlPrint(message: "viewWillAppear")
        self.refreshAct()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //注册消息通知
    func notifyRegister() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(self.selfModifyAccountLabel(sender:)), name: NSNotification.Name(rawValue: notificationName.SelfGameAccountModify.rawValue), object: nil)
        
    }

    
    
    func getUnReadMsgAccount() -> Void {
        let messageModel = MessageModel()
        messageModel.getInternalMsgCount { (account) in
            tlPrint(message: "有\(account)条未读消息")
            let label = self.selfView.viewWithTag(selfBtnTag.AlertLabel.rawValue) as! UILabel
            let img = self.selfView.viewWithTag(selfBtnTag.AlertImg.rawValue) as! UIImageView
            let unreadAccount = ("\(account)" == "Failed" ? "0" : account)
            label.text = unreadAccount
            if unreadAccount > "0" {
                label.isHidden = false
                img.isHidden = false
            } else {
                label.isHidden = true
                img.isHidden = true
            }
        }
    }
    
    
    //消息通知改变中心钱包金额
    @objc func selfModifyAccountLabel(sender:Notification) -> Void {
        let account = (sender.object as! Array<Any>)[0]
        tlPrint(message: "sender.tag:\((sender.object as! Array<Any>)[1] as! Int))")
        let balanceLabel = self.selfView.scroll.viewWithTag(selfBtnTag.AccountLabel.rawValue + ((sender.object as! Array<Any>)[1] as! Int)) as! UILabel
        balanceLabel.text = "¥\(account)"

    }
    
    private func getAccount(success:@escaping(()->()),failure:@escaping(()->())) -> Void {
        //获取中心钱包余额
        if userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue) != nil {
            //getTokenTimer.invalidate()
            futuNetworkRequest(type: .get,serializer: .json, url: model.allAccountUrl, params: ["":""], success: { (response) in
                tlPrint(message: "response:\(response)")
                let value = (response as AnyObject).value(forKey: "Value") as AnyObject
                let totleAccount = (value as AnyObject).value(forKey: "Balance")
                let balanceLabel = self.selfView.titleView.viewWithTag(selfBtnTag.TotleAccountLabel.rawValue) as! UILabel
                let newBalance = retain2Decima(originString: "\(totleAccount!)")
                balanceLabel.text = "¥\(newBalance)"
                success()
                
            }, failure: { (error) in
                tlPrint(message: "error:\(error)")
                failure()
            })
            
            //获取各个平台的余额
            for i in 0 ..< selfGameName.count {
                futuNetworkRequest(type: .get,serializer: .http, url: model.gameBalanceUrl, params: ["gamecode":selfGameCode[i]], success: { (response) in
                    tlPrint(message: "response:\(response)")
                    let string = String(data: response as! Data, encoding: String.Encoding.utf8)
                    self.model.gameAccountDeal(account: string!, index: i)
                }, failure: { (error) in
                    tlPrint(message: "error:\(error)")
                    failure()
                })
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tlPrint(message: "scrollViewDidScroll")
        let offSetY:CGFloat = scrollView.contentOffset.y
//        if offSetY < 0 {
//            let originH = adapt_H(height: model.titleViewHeight)
//            let originW:CGFloat = width
//            let newHeight = -offSetY + originH
//            let newWidth = -offSetY * originW / originH + originW
////            self.backImg.frame = CGRect(x: offSetY * originW / originH / 2, y: offSetY, width: newWidth, height: newHeight)
//            
//            self.backImg.frame = CGRect(x: offSetY * originW / originH / 2, y: 0, width: newWidth, height: newHeight)
//            
//            self.headBackView.frame = CGRect(x: (width - adapt_W(width: 85)) / 2, y: adapt_H(height: 77) + offSetY * 0.33, width: adapt_W(width: 85), height: adapt_W(width: 85))
//            
//            
//        } else if offSetY >= 0{
//            
//        }
        if offSetY < 0 {
            let originH = adapt_H(height:model.titleViewHeight)
            let originW:CGFloat = width
            let newHeight = -offSetY + originH
            let newWidth = -offSetY * originW / originH + originW
            self.backImg.frame = CGRect(x: offSetY * originW / originH / 2, y: offSetY, width: newWidth, height: newHeight)
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
            tlPrint(message: "正在刷新中，请稍后再试！")
            return
        }
        self.isRefreshing = true
        
        let refreshIndecatorFrame = CGRect(x: (width - adapt_W(width: 20))/2 , y: adapt_H(height: isPhone ? 20 : 10), width: adapt_W(width: 20), height: adapt_W(width: 20))
        if self.selfView.refreshIndicator == nil {
            self.selfView.refreshIndicator = RefreshIndicator(view: self.selfView, frame: refreshIndecatorFrame)
            //self.walletHubView.refreshIndicator.refreshPlay(frame: refreshIndecatorFrame)
        } else {
            self.selfView.refreshIndicator.refreshPlay(frame: refreshIndecatorFrame)
        }
        
        self.getAccount(success: { 
            tlPrint(message: "个人页刷新数据成功")
            self.selfView.refreshIndicator.refreshStop()
            for view in self.selfView.subviews {
                view.removeFromSuperview()
            }
            self.selfView.removeFromSuperview()
            self.selfView = nil
            self.selfView = SelfView(frame: self.view.frame, param: "" as AnyObject, rootVC: self)
            self.selfView.delegate = self
            self.selfView.scroll.delegate = self
            self.backImg = self.selfView.backImg
            self.headBackView = self.selfView.headBackView
            self.view.addSubview(self.selfView)
            self.isRefreshing = false
        }, failure: {
            tlPrint(message: "个人页刷新数据失败")
            self.isRefreshing = false
        })
    }
    
    func buttonAction(btnTag: Int) {
        tlPrint(message: "buttonAction btnTag:\(btnTag)")
        self.checkLoginStatus {
            switch btnTag {
            case selfBtnTag.SettingBtn.rawValue://设置按钮
                tlPrint(message: "设置按钮")
                let person = PersonViewController(infoType: .PersonInfo)
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(person, animated: true)
                }
            case selfBtnTag.MessageBtn.rawValue:
                TLPrint("站内信暂时不使用！！")
                self.view.isUserInteractionEnabled = false
                let message = MessageViewController(messageType: .SystemMessage)
                message.getAllMessageInfo {
                    self.navigationController?.pushViewController(message, animated: true)
                    self.view.isUserInteractionEnabled = true
                }
                
            case selfBtnTag.BankBtn.rawValue:
                let bindBank = PersonViewController(infoType: .BankInfo)
                self.navigationController?.pushViewController(bindBank, animated: true)
            case selfBtnTag.TotleAccountLabel.rawValue:
                tlPrint(message: "进入中心钱包")
                let walletHub = WalletHubViewController()
                self.navigationController?.pushViewController(walletHub, animated: true)
            default:
                if btnTag >= selfBtnTag.SelfGameBtnTag.rawValue && btnTag < selfBtnTag.AccountLabel.rawValue {
                    tlPrint(message: "游戏按钮")
                    let gameIndex = btnTag - selfBtnTag.SelfGameBtnTag.rawValue
//                    if gameIndex >= 2 {
//                        gameIndex+=1
//                    }
                    let homeModel = HomeModel()
                    
//                    homeModel.getGameBannerInfo { (gameBannerInfo) in
//                        userDefaults.setValue(gameBannerInfo, forKey: userDefaultsKeys.gameDetailInfo.rawValue)
//                        let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
//                        let hotGameList = gameBannerInfo[1][homeModel.gameKey[gameIndex]] as! Array<Int>
//                        let gameLobby = GameLobbyViewController(hotGameArray: hotGameList)
//                        gameLobby.bannerImageURL = "\(domain)\((gameBannerInfo[0][homeModel.gameKey[gameIndex]] as! String))"
//                        gameLobby.gameName = gameLobbyGameName[gameIndex]
//                        gameLobby.gameIndex = gameIndex
//
//                        self.navigationController?.pushViewController(gameLobby, animated: true)
//
//                    }
                } else {
                    tlPrint(message: "no such case!")
                }
            }
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
//    
//    
//    private func refreshPull() ->Void {
//        tlPrint(message: "refreshViewOfBlock")
//        let header = MJRefreshNormalHeader()
//        //修改字体
//        header.stateLabel.font = UIFont.systemFont(ofSize: 15)
//        header.lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: 13)
//        header.stateLabel.textColor = UIColor.white
//        //隐藏刷新提示文字
//        header.stateLabel.isHidden = true
//        //隐藏上次刷新时间
//        header.lastUpdatedTimeLabel.isHidden = true
//        header.setRefreshingTarget(self, refreshingAction: #selector(self.selfRefreshAct))
//        
//        self.selfView.scroll.mj_header = header
//    }
//    
//    func selfRefreshAct() -> Void {
//        tlPrint(message: "refreshAct")
//        self.getAccount()
//        self.getUnReadMsgAccount()
//        self.selfView.scroll.mj_header.endRefreshing()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
