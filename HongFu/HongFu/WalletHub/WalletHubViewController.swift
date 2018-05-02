//
//  WalletHubViewController.swift
//  FuTu
//
//  Created by Administrator1 on 26/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit



class WalletHubViewController: UIViewController,UIScrollViewDelegate,BtnActDelegate,UIAlertViewDelegate {

    var walletHubView: WalletHubView!
    var width,height:CGFloat!
    let model = WalletHubModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.width = self.view.frame.width
        self.height = self.view.frame.height
        
        self.automaticallyAdjustsScrollViewInsets = false
        walletHubView = WalletHubView(frame: self.view.frame, param: "" as AnyObject, rootVC: self)
        self.view.addSubview(walletHubView)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    func getAccount(success: @escaping (() -> ()),failure: @escaping (() -> ())) -> Void {
        //获取中心钱包余额
        let homeModel = HomeModel()
        tlPrint(message: getAccount)
        if userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue) != nil {
            futuNetworkRequest(type: .get,serializer: .json, url: homeModel.allAccountUrl, params: nil, success: { (response) in
                tlPrint(message: "response:\(response)")
                let value = (response as AnyObject).value(forKey: "Value") as AnyObject
                HomeModel.userInfoDeal(userInfo: value as AnyObject, success: {
                    tlPrint(message: "中心钱包获取信息成功")
                    success()
                })
            }, failure: { (error) in
                tlPrint(message: "error:\(error)")
            })
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        
        if offSetY < 0 {
//            tlPrint("offsetY = \(offSetY)")
            //let otitleFrame = walletHubView.titleView.frame
//            walletHubView.titleView.frame = CGRect(x: 0, y: offSetY, width: width, height: adapt_H(height: model.titleHeight) - offSetY)
//            walletHubView.titleLabel.frame = CGRect(x: 0, y: 20 + adapt_H(height: 16) + offSetY * 0.7, width: width, height: 20)
//            walletHubView.tradeSearchBtn.frame = CGRect(x: width - adapt_W(width: 80), y: 20 + adapt_H(height: 10) + offSetY * 0.7, width: adapt_W(width: 80), height: adapt_H(height: 40))
//            walletHubView.logoImg.frame = CGRect(x: (width - adapt_W(width: model.logoWidth)) / 2, y: adapt_H(height: isPhone ? 85 : 55), width: adapt_W(width: model.logoWidth), height: adapt_W(width: model.logoWidth))
//            walletHubView.amountLabel.frame = CGRect(x: 0, y: adapt_H(height: isPhone ? 200 : 140), width: width, height: adapt_H(height: isPhone ? 55 : 35))
            
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
    
    
    func btnAct(btnTag: Int) {
        tlPrint(message: "walletBtnAct btnTag = \(btnTag)")
        switch btnTag {
        case walletHubTag.HubBackBtnTag.rawValue:
            _ = self.navigationController?.popViewController(animated: true)
        case walletHubTag.TradeSearchBtnTag.rawValue:
            tlPrint(message: "交易查询")
            self.tradeSearchBtnAct()
        case walletHubTag.RechargeBtnTag.rawValue:
            tlPrint(message: "充值按钮")
            let rechargeVC = RechargeViewController(isFromTab: false)
            self.navigationController?.pushViewController(rechargeVC, animated: true)
        case walletHubTag.RechargeBtnTag.rawValue + 2:
            tlPrint(message: "提现按钮")
            withdrawBtnAct()
        case walletHubTag.RechargeBtnTag.rawValue + 1:
            tlPrint(message: "转账按钮")
            let transferVC = TransferViewController(isFromTab: false)
            self.navigationController?.pushViewController(transferVC, animated: true)
        case walletHubTag.WeekendBtnTag.rawValue:
            tlPrint(message: "周六奖金")
            weekendBtnAct(isSaturday: true)
            let bailoutBtn = self.walletHubView.viewWithTag(btnTag) as! UIButton
            bailoutBtn.isEnabled = false
        case walletHubTag.WeekendBtnTag.rawValue + 1:
            tlPrint(message: "周日奖金")
            //禁用今日救援按钮
            let bailoutBtn = self.walletHubView.viewWithTag(btnTag) as! UIButton
            bailoutBtn.isEnabled = false
            weekendBtnAct(isSaturday: false)
        default:
            tlPrint(message: "no such case")
        }
    }
    
    func weekendBtnAct(isSaturday:Bool) -> Void {
        //救援金入口
        self.checkLoginStatus {
            self.model.getWeekendAwardInfo(success: { (response) in
                tlPrint(message: "response : \(response)")
                var message = ""
                let amount = response["amount"] as! CGFloat
                let status = response["status"] as! NSNumber
                if let msg = response["msg"] {
                    message = msg as! String
                }
                tlPrint(message: "amount:\(amount)   status: \(status)    msg:\(message)")
                let alert = UIAlertView(title: isSaturday ? "周六奖金" : "周日奖金", message: message, delegate: nil, cancelButtonTitle: "确 定")
                alert.show()
                //启用按钮
                let weekendBtn = self.walletHubView.viewWithTag(walletHubTag.WeekendBtnTag.rawValue + (isSaturday ? 0 : 1)) as! UIButton
                weekendBtn.isEnabled = true
                if amount > 0 {
                    self.refreshAct()
                }
            }, failure: { 
                tlPrint("error")
                //启用按钮
                let weekendBtn = self.walletHubView.viewWithTag(walletHubTag.WeekendBtnTag.rawValue + (isSaturday ? 0 : 1)) as! UIButton
                weekendBtn.isEnabled = true
            })
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
    
    func tradeSearchBtnAct() -> Void {
        self.checkLoginStatus {
            let tradeSearchVC = TradeSearchViewController(searchType: tradeSearchType.Recharge)
            self.navigationController?.pushViewController(tradeSearchVC, animated: true)
            return
        }
    }
    
    func withdrawBtnAct() -> Void {
        tlPrint(message: "withdrawBtnAct")
        let withdrawVC = WithdrawViewController(times: 5)
        self.navigationController?.pushViewController(withdrawVC, animated: true)
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
            tlPrint("刷新中。。。。。")
            return
        }
        self.isRefreshing = true
        let refreshIndecatorFrame = CGRect(x: (width - adapt_W(width: 20))/2 , y: adapt_H(height: isPhone ? 20 : 10), width: adapt_W(width: 20), height: adapt_W(width: 20))
        if self.walletHubView.refreshIndicator == nil {
            self.walletHubView.refreshIndicator = RefreshIndicator(view: self.walletHubView, frame: refreshIndecatorFrame)
            //self.walletHubView.refreshIndicator.refreshPlay(frame: refreshIndecatorFrame)
        } else {
            self.walletHubView.refreshIndicator.refreshPlay(frame: refreshIndecatorFrame)
        }

        
        self.getAccount(success: {
            self.walletHubView.refreshIndicator.refreshStop()
            let newAmount = userDefaults.value(forKey: userDefaultsKeys.userInfoBalance.rawValue)
            self.walletHubView.amountLabel.text = "¥\(newAmount!)"
            self.isRefreshing = false
        }) {
            tlPrint("获取账户信息失败")
            self.isRefreshing = false
            self.walletHubView.refreshIndicator.refreshStop()
            
        }
    }
    
    
    func stringToInt(str:String)->(Int){
        
        let string = str
        var int: Int?
        if let doubleValue = Int(string) {
            int = Int(doubleValue)
        }
        if int == nil {
            return 0
        }
        return int!
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
