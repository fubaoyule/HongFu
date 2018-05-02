//
//  HomeViewController.swift
//  FuTu
//
//  Created by Administrator1 on 21/11/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//
//  tag: 10+

import UIKit

protocol BtnActDelegate {
    func btnAct(btnTag:Int)
    
}
protocol checkLoginStatusDelegate {
    func checkLoginStagus(hasLogin:@escaping(()->()))
}

class HomeViewController: UIViewController,UIAlertViewDelegate, SDCycleScrollViewDelegate, BtnActDelegate,checkLoginStatusDelegate {
    func checkLoginStagus(hasLogin:@escaping(()->())) {
        self.checkLoginStatus {
            hasLogin()
        }
    }
    
    func btnAct(btnTag: Int) {
        tlPrint(message: "btnAct:\(btnTag)")
        switch btnTag {
        case HomeTag.emailRedbagConfirmBtnTag.rawValue:
            tlPrint("邮箱红包确定按钮")
            
        default:
            tlPrint(message: "no such case!")
        }
    }
    
    
    let baseVC = BaseViewController()
    let model = HomeModel()
    var amountLabel,noticeLabel: UILabel!
    var notiseScroll, cycleScroll : SDCycleScrollView!
    var scroll: UIScrollView!
    var indicator:TTIndicators!
//    var redPacketView: HomeBannerRedView!
    var redInfoDic:Dictionary<String,Any>!
    var startTime,endTime:String!
    var homeLeftTimeTimer,redPacketTimeoutTimer, getTokenTimer: Timer!
    var isStart:Bool = false
    var totalCount:Int!
    let bannerHeight:CGFloat = adapt_H(height: isPhone ? 170 : 100)
    let noticeHeight:CGFloat = adapt_H(height: isPhone ? 34 : 20)
    let titleHeight:CGFloat = adapt_H(height: isPhone ? 65 : 40)
    let loginRegisterHeight:CGFloat = adapt_H(height: isPhone ? 55 : 40)
    var scrollContentHeight:CGFloat!
    var titleBtnImg1,titleBtnImg1_start,titleBtnImg2,titleBtnImg3,titleBtnImg3_hammer: UIImageView!
    var titleBtn1, titleBtn2, titleBtn3, imgView1, imgView3, shareBtn:UIButton!
    let userDefaults = UserDefaults.standard
    var width,height,homeHeight:CGFloat!
    var appUpdateUrl = ""
    let share = ShareViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        width = self.view.frame.width
        height = self.view.frame.height
        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
            if hasLogin as! Bool {
                self.getTokenTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getAccount), userInfo: nil, repeats: true)
            }
        }
        
        //注册消息通知
        notifyRegister()
        //初始化滚动视图
        initScrollView()
        //初始化通知条
        getNoticeInfo()
        //初始化功能按钮视图
        initTitleView()
        //初始化登录注册视图
        self.initLoginRegisterView()
        //初始化游戏按钮视图
        initGameBtnView()
        //初始化广告滚动视图
        self.model.getHomeBannerInfo { (bannerArray) in
            self.initBannerView(imagesURLStrings: bannerArray)
        }
        //初始化客服按钮
        self.initServiceBtn()
        //添加下拉刷新
        refreshPull()
        //添加状态栏渐变背景
        initStatuBarBackColor()
        //上线之前必须开启
        self.requestLatestInfo()
        //初始化首页红包按钮
//        model.caculateRedBagStatus {
//            self.initRedPaketBtn()
//        }
        
//        self.initTestBtn()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tlPrint(message: "viewWillAppear")
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tlPrint(message: "viewWillDisappear")
        if self.redPacketTimeoutTimer != nil {
            self.redPacketTimeoutTimer.invalidate()
        }
    }
    
    
    func initTestBtn() -> Void {
        
        let testBtnFrame = CGRect(x: 100, y: 100, width: 200, height: 50)
        let testBtn = baseVC.buttonCreat(frame: testBtnFrame, title: "彩票测试入口", alignment: .center, target: self, myaction: #selector(self.testBtnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: UIColor.orange, fonsize: 28, events: .touchUpInside)
        self.scroll.addSubview(testBtn)
        
    }
    @objc func testBtnAct(sender:UIButton) -> Void {
        let eggVC = EggViewController()
        self.navigationController?.pushViewController(eggVC, animated: true)
    }
    
    
    //===========================================
    //Mark:- set the style of status bar
    //===========================================
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    @objc func getAccount() -> Void {
        //获取中心钱包余额
        if userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue) != nil {
            if self.getTokenTimer != nil {
                self.getTokenTimer.invalidate()
            }
            
            futuNetworkRequest(type: .get,serializer: .json, url: model.allAccountUrl, params: ["":""], success: { (response) in
                tlPrint(message: "response:\(String(describing: response))")
                let value = (response as AnyObject).value(forKey: "Value") as AnyObject
                HomeModel.userInfoDeal(userInfo: value as AnyObject, success: {
                    tlPrint(message: "首页获取信息成功")
                })
            }, failure: { (error) in
                tlPrint(message: "error:\(error)")
            })
        }
    }
    
    //消息通知注册
    func notifyRegister() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(self.modifyAccountLabel), name: NSNotification.Name(rawValue: notificationName.HomeAccountValueModify.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshAct), name: NSNotification.Name(rawValue: notificationName.HomeAccountValueRefresh.rawValue), object: nil)
        
        
    }
    //消息通知注销
    func notifyRemove() -> Void {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notificationName.HomeAccountValueModify.rawValue), object: nil)
        
    }
    
    //消息通知改变中心钱包金额,以及隐藏登录按钮
    @objc func modifyAccountLabel() -> Void {
        
        tlPrint(message: "＊＊＊＊＊＊＊＊＊＊＊ 修改中心钱包余额 ＊＊＊＊＊＊＊＊＊＊＊")
        let accountLabel = self.view.viewWithTag(HomeTag.totleAccountLabel.rawValue) as! UILabel
        let accountValue = userDefaults.value(forKey: userDefaultsKeys.userInfoBalance.rawValue)
        tlPrint(message: "中心钱包余额\(String(describing: accountValue))")
        accountLabel.text = "¥\(accountValue!)"
        
        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
            if hasLogin as! Bool {
                self.scroll.contentSize = CGSize(width: width, height: scrollContentHeight - self.loginRegisterHeight)
            } else {
                self.scroll.contentSize = CGSize(width: width, height: scrollContentHeight + self.loginRegisterHeight)
            }
        }
        //热门游戏按钮视图
        let loginView = self.view.viewWithTag(HomeTag.loginRegisterViewTag.rawValue)!
        UIView.animate(withDuration: 0.2) {
            loginView.frame = CGRect(x: 0, y: adapt_H(height: -50), width: self.width, height: adapt_H(height: 40))
            let scrollHeight = self.height - tabBarHeight
            let scrollFrame = CGRect(x: 0, y: adapt_H(height: 0), width: self.width, height: scrollHeight)
            self.scroll.frame = scrollFrame
        }
    }
    
    //初始化状态条背景
    func initStatuBarBackColor() -> Void {
        
        let statusBarImg = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        self.view.addSubview(statusBarImg)
        statusBarImg.image = UIImage(named: "home_statusBar_img.png")
        
    }
    
    func initScrollView() -> Void {
        tlPrint(message: "initScrollView")
        let scrollHeight = height - tabBarHeight
        homeHeight = height - tabBarHeight
        let scrollFrame = CGRect(x: 0, y:loginRegisterHeight, width: width, height: scrollHeight)
        scroll = UIScrollView(frame: scrollFrame)
        let gemeBtnHeight = adapt_H(height: isPhone ? 105 : 65) * CGFloat(Int((homeGameName.count + 1) / 2))
        self.scrollContentHeight = bannerHeight + noticeHeight + gemeBtnHeight + titleHeight + loginRegisterHeight + adapt_H(height: 20)
        scroll.contentSize = CGSize(width: width, height: scrollContentHeight)
        scroll.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        self.view.addSubview(scroll)
    }
    
    //===========================================
    //Mark:- initialize scroll view for advertisement
    //===========================================
    func initBannerView(imagesURLStrings:[String]) -> Void {
        tlPrint(message: "initScrollView")
        
        let scrollFrame = CGRect(x: 0, y: 0, width: width, height: adapt_H(height: (isPhone ? 170 : 100)))
        
        cycleScroll = SDCycleScrollView(frame: scrollFrame , delegate: self, placeholderImage: UIImage(named:"auto-image.png"))
        cycleScroll?.autoScrollTimeInterval = 4
        cycleScroll?.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        cycleScroll?.currentPageDotColor = UIColor.white // define the color of page controller.
        self.scroll.insertSubview(cycleScroll, at: 0)
        DispatchQueue.main.async {
            self.cycleScroll?.imageURLStringsGroup = imagesURLStrings
//            //礼盒  **********************************************
//            self.model.getGiftBoxStatus(success: {
//                self.initGiftBoxBtn()
//            }, failed: { tlPrint(message: "礼盒未开启") })
            //宝箱  **********************************************
            self.initTreasureBoxBtn()
//
//            
//            //红包  **********************************************
//            let redPacketModel = RedPacketModel()
//            redPacketModel.getRedPacketInfo(success: { (redInfoDic) in
//                tlPrint(message: "首页获取红包数据成功：\(redInfoDic)")
//                //没有红包则不实现倒计时
//                var endTime = redInfoDic["endTime"] as! String
//                endTime = endTime.replacingOccurrences(of: "T", with: " ")
//                let redPacketModel = RedPacketModel()
//                let isStop = redPacketModel.timeOutCalculate(end: endTime)
//                if isStop {
//                    return
//                }
//                self.initRedPaketBtn()
//                //换成浮动的方式
//                self.isStart = redInfoDic["haveRedbag"] as! Bool
//            }, failure: {
//                tlPrint(message: "获取红包数据失败")
//            })
//            //3D福利彩票  **********************************************
//            self.initLotteryBtn()
        }
        cycleScroll.tag = HomeTag.bannerScroll.rawValue
        cycleScroll.isUserInteractionEnabled = true
    }
    
    
    func initShareBtn() -> Void {
        
        self.shareBtn = baseVC.buttonCreat(frame: CGRect(x:0,y:0,width:0,height:0), title: "", alignment: .center, target: self, myaction: #selector(ShareBtnAct), normalImage: UIImage(named:"home_share.png"), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
        self.scroll.addSubview(shareBtn)
        self.scroll.bringSubview(toFront: shareBtn)
        shareBtn.frame = CGRect(x: width - adapt_W(width: isPhone ? 55 : 40), y: adapt_H(height: isPhone ? 25 : 15), width: adapt_W(width: isPhone ? 40 : 25), height: adapt_W(width: isPhone ? 40 : 25))
    }
    
    
    func initServiceBtn() -> Void {
        
        let serviceBtn = baseVC.buttonCreat(frame: CGRect(x:0,y:0,width:0,height:0), title: "", alignment: .center, target: self, myaction: #selector(btnAct(sender:)), normalImage: UIImage(named:"Home_service.png"), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
        serviceBtn.tag = HomeTag.serviceBtnTag.rawValue
        self.scroll.addSubview(serviceBtn)
        self.scroll.bringSubview(toFront: serviceBtn)
        serviceBtn.frame = CGRect(x: width - adapt_W(width: isPhone ? 55 : 40), y: adapt_H(height: isPhone ? 25 : 15), width: adapt_W(width: isPhone ? 40 : 25), height: adapt_W(width: isPhone ? 40 : 25))
    }
    
    
    
    
    
    
    //分享按钮事件处理
    @objc func ShareBtnAct() -> Void {
        tlPrint(message: "ShareBtnAct")
        
        //获取代理编码
        let getAgentCodeUrl = "Commission/GetAgentCode"
        let getShortUrl = "Share/GetShortUrl"
        let getActiveUrl = "Active/GetRndActive"
        
        if self.indicator == nil {
            self.indicator = TTIndicators(view: self.view, frame: portraitIndicatorFrame)
        }
        self.indicator.play(frame: portraitIndicatorFrame)
        futuNetworkRequest(type: .get, serializer: .http, url: getAgentCodeUrl, params: ["":""], success: { (response) in
            var agentCode = String(data: response as! Data, encoding: String.Encoding.utf8)
            agentCode = agentCode!.replacingOccurrences(of: "\"", with: "")
            agentCode = agentCode!.replacingOccurrences(of: "\\", with: "")
            agentCode = agentCode!.replacingOccurrences(of: " ", with: "")
            tlPrint(message: "agentCode:\(String(describing: agentCode))")
            let domain = self.userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
            let param = ["longUrl":"\(domain)?\(agentCode!)"]
            //获取短域名
            futuNetworkRequest(type: .get, serializer: .http, url: getShortUrl, params: param, success: { (response) in
                var shortUrl = String(data: response as! Data, encoding: String.Encoding.utf8)
                shortUrl = shortUrl!.replacingOccurrences(of: "[", with: "")
                shortUrl = shortUrl!.replacingOccurrences(of: "]", with: "")
                let shortUrlDic = (shortUrl)?.objectFromJSONString() as! Dictionary<String, Any>
                tlPrint(message: "shortUrlDic:\(shortUrlDic)")
                shortUrl = shortUrlDic["url_short"] as! String
                tlPrint(message: "shortUrl:\(shortUrl)")
                
                //获取内容
                futuNetworkRequest(type: .get, serializer: .http, url: getActiveUrl, params: ["":""], success: { (response) in
                    tlPrint(message: "active url response:\(response)")
                    var active = String(data: response as! Data, encoding: String.Encoding.utf8)
                    tlPrint(message: "active1:\(active!)")
                    active = active!.replacingOccurrences(of: "\"{", with: "{")
                    active = active!.replacingOccurrences(of: "}\"", with: "}")
                    active = active!.replacingOccurrences(of: "\\", with: "")
                    tlPrint(message: active!)
                    let activeArray1 = active!.components(separatedBy: "\"SubTitle\":")
                    if activeArray1.count < 2 {
                        self.indicator.stop()
                        self.shareFailedAlert()
                        return
                    }
                    
                    let activeArray2 = activeArray1[1].components(separatedBy: ",\"ImageLink\"")
                    if activeArray2.count < 2 {
                        self.indicator.stop()
                        self.shareFailedAlert()
                        return
                    }
                    let imageInfo = "\"ImageLink\"" + activeArray2[1]
                    active = activeArray1[0] + imageInfo
                    tlPrint(message: active!)
                    let activeDict = (active)?.objectFromJSONString() as! Dictionary<String, Any>
                    tlPrint(message: activeDict)
                    let shareTitle = activeDict["MainTitle"]
                    //                    var shareImgUrl = domain + (activeDict["ImageLink"] as! String)
                    var shareImgUrl = "www.toobet.com/" + (activeDict["ImageLink"] as! String)
                    shareImgUrl = shareImgUrl.replacingOccurrences(of: "//", with: "/")
                    //获取到数据，开始弹出分享框
                    let info = ["content": shareTitle!, "src": shortUrl!, "title": "鸿福娱乐", "urlImg": shareImgUrl]
                    
                    tlPrint(message: "--->> info : \(info)\n\n***************")
                    
                    self.indicator.stop()
                    self.share.showActionSheet(info)//此方法为弹出分享窗
                    
                    
                }, failure: { (error) in
                    tlPrint(message: "active error:\(error)")
                    self.indicator.stop()
                    self.shareFailedAlert()
                })
                
            }, failure: { (error) in
                tlPrint(message: "short url error:\(error)")
                self.indicator.stop()
                self.shareFailedAlert()
            })
            
        }, failure: { (error) in
            tlPrint(message: "agent code error:\(error)")
            self.indicator.stop()
            self.shareFailedAlert()
        })
    }
    
    func shareFailedAlert() -> Void {
        let alert = UIAlertView(title: "", message: "分享失败", delegate: nil, cancelButtonTitle: "确定")
        DispatchQueue.main.async {
            alert.show()
        }
    }
    
    
    
    
    
    
    
    //初始化登陆注册按钮视图
    func initLoginRegisterView() -> Void {
        tlPrint(message: "initLoginBtn")
        let loginRegView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: loginRegisterHeight))
        self.view.addSubview(loginRegView)
        loginRegView.tag = HomeTag.loginRegisterViewTag.rawValue
        loginRegView.backgroundColor = UIColor.colorWithCustom(r: 63, g: 38, b: 32)
        let loginWidth = adapt_W(width: isPhone ? 110 : 70)
        let loginXArray = [adapt_W(width: 50),width - loginWidth - adapt_W(width: 50)]
        let lgoinImgArray = ["home_loginBtn.png","home_registerBtn.png"]
        for i in 0 ..< 2 {
            
            let loginFrame = CGRect(x: loginXArray[i], y: adapt_H(height: isPhone ? 20 : 14), width: loginWidth, height: adapt_W(width: isPhone ? 30 : 20))
            let loginBtn = baseVC.buttonCreat(frame: loginFrame, title: "", alignment: .center, target: self, myaction: #selector(btnAct(sender:)), normalImage: UIImage(named:lgoinImgArray[i]), hightImage: UIImage(named:lgoinImgArray[i]), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
            loginBtn.setTitleColor(UIColor.red, for: .normal)
            loginBtn.tag = HomeTag.loginBtnTag.rawValue + i
            loginRegView.addSubview(loginBtn)
        }
    }
    
    func initGiftBoxBtn() -> Void {
        
        let giftBoxBtn = baseVC.buttonCreat(frame: CGRect(x: width - adapt_W(width: isPhone ? 80 : 60), y: adapt_H(height: isPhone ? 55 : 30), width: adapt_W(width: isPhone ? 63 : 40), height: adapt_W(width: isPhone ? 63 : 40)), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"GiftBox_homeBtnImg.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.scroll.addSubview(giftBoxBtn)
        self.scroll.bringSubview(toFront: giftBoxBtn)
        giftBoxBtn.tag = HomeTag.giftBoxBtnTag.rawValue
        self.floatAnimation(view: giftBoxBtn, duration: 3.0, fromValue: 15.0, toValue: -12.0)
        self.shakeAnimation(view: giftBoxBtn, duration: 1.0, fromValue: NSNumber(value: -0.3), toValue: NSNumber(value: 0.3))
        
    }
    //初始化开宝箱入口
    func initTreasureBoxBtn() -> Void {
        
        let TreasureBoxBtn = baseVC.buttonCreat(frame: CGRect(x: width - adapt_W(width: isPhone ? 80 : 60), y: adapt_H(height: isPhone ? 55 : 30), width: adapt_W(width: isPhone ? 63 : 40), height: adapt_W(width: isPhone ? 70 : 45)), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"TreasureBox_home_logo.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.scroll.addSubview(TreasureBoxBtn)
        self.scroll.bringSubview(toFront: TreasureBoxBtn)
        TreasureBoxBtn.tag = HomeTag.treasureBoxBtnTag.rawValue
        self.floatAnimation(view: TreasureBoxBtn, duration: 4.0, fromValue: 0, toValue: 40.0)
        self.shakeAnimation(view: TreasureBoxBtn, duration: 1.0, fromValue:NSNumber(value: 0.3), toValue: NSNumber(value: -0.3))
        TreasureBoxBtn.isHidden = false
    }
    
    //首页红包入口
    func initRedPaketBtn() -> Void {
        
        let redPaketBtn = baseVC.buttonCreat(frame: CGRect(x: width - adapt_W(width: isPhone ? 80 : 60), y: adapt_H(height: isPhone ? 55 : 30), width: adapt_W(width: isPhone ? 63 : 40), height: adapt_W(width: isPhone ? 70 : 45)), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"Home_Redbag_home.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.scroll.addSubview(redPaketBtn)
        self.scroll.bringSubview(toFront: redPaketBtn)
        redPaketBtn.tag = HomeTag.redPacketBtnTag.rawValue
        self.floatAnimation(view: redPaketBtn, duration: 3.0, fromValue: 30, toValue: 00)
        self.shakeAnimation(view: redPaketBtn, duration: 1.0, fromValue: NSNumber(value: -0.3), toValue: NSNumber(value: 0.3))
        redPaketBtn.tag = HomeTag.redPacketBtnTag.rawValue
        
    }
    
    //初始化3D福利彩票入口
    func initLotteryBtn() -> Void {
        
        let lotteryBtn = baseVC.buttonCreat(frame: CGRect(x: width - adapt_W(width: isPhone ? 110 : 70), y: adapt_H(height: isPhone ? 35 : 20), width: adapt_W(width: isPhone ? 100 : 60), height: adapt_W(width: isPhone ? 110 : 70)), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"lottery_home.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.scroll.addSubview(lotteryBtn)
        self.scroll.bringSubview(toFront: lotteryBtn)
        lotteryBtn.tag = HomeTag.lotteryBtnTag.rawValue
        self.floatAnimation(view: lotteryBtn, duration: 4.0, fromValue: -15.0, toValue: 15.0)
        self.shakeAnimation(view: lotteryBtn, duration: 1.0, fromValue:NSNumber(value: 0.2), toValue: NSNumber(value: -0.2))
    }
    
    
    //宝箱上下浮动动画
    func floatAnimation(view:UIView,duration:CGFloat,fromValue:Float,toValue:Float) -> Void {
        
        let float = CABasicAnimation(keyPath: "transform.translation.y")
        float.duration = CFTimeInterval(duration)
        float.autoreverses = true//是否重复
        float.repeatCount = HUGE
        float.isRemovedOnCompletion = false
        float.fillMode = kCAFillModeForwards
        float.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        float.fromValue = NSNumber(value: fromValue)
        float.toValue = NSNumber(value: toValue)
        view.layer.animation(forKey: "caseFloat")
        view.layer.add(float, forKey: nil)
    }
    
    //宝箱晃动动画
    func shakeAnimation(view:UIView,duration: CGFloat, fromValue:NSNumber, toValue:NSNumber) -> Void {
        let shake = CABasicAnimation(keyPath: "transform.rotation.z")
        shake.fromValue = fromValue
        shake.toValue = toValue
        shake.duration = CFTimeInterval(duration)
        shake.autoreverses = true//是否重复
        shake.repeatCount = HUGE
        shake.isRemovedOnCompletion = false
        shake.fillMode = kCAFillModeForwards
        shake.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.layer.animation(forKey: "caseShake")
        view.layer.add(shake, forKey: nil)
        
    }
    
    //===========================================
    //Mark:- initialize the notice info view
    //===========================================
    private func initNoticeView(notice: Array<String>) -> Void {
        
        //init notice picture background view
        let noticeFrame = CGRect(x: 0, y: adapt_H(height: (isPhone ? 170 : 100)), width: width, height: adapt_H(height: isPhone ? 34 : 20))
        let noticeView = baseVC.viewCreat(frame: noticeFrame, backgroundColor: model.noticeBackColor)
        self.scroll.addSubview(noticeView)
        
        //init notice image
        let yellowLabel = UILabel()
        noticeView.addSubview(yellowLabel)
        yellowLabel.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(adapt_W(width: 12))
            _ = make?.centerY.equalTo()(noticeView.mas_centerY)
            _ = make?.width.equalTo()(adapt_W(width: 3))
            _ = make?.height.equalTo()(adapt_H(height: 12))
        }
        yellowLabel.backgroundColor = model.yellowLabelColor
        
        //initialize advertise scroll view
        let noticeScrollFrame = CGRect(x: adapt_W(width: 16), y: 0, width: width - adapt_W(width: 28), height:noticeFrame.height)
        notiseScroll = SDCycleScrollView(frame: noticeScrollFrame, delegate: self, placeholderImage: nil)
        noticeView.addSubview(notiseScroll!)
        notiseScroll?.scrollDirection = UICollectionViewScrollDirection.vertical
        notiseScroll?.onlyDisplayText = true
        notiseScroll?.titleLabelBackgroundColor = UIColor.clear
        notiseScroll.titleLabelTextColor = model.noticeTextColer
        notiseScroll.titleLabelTextFont = UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 12 : 10))
        notiseScroll?.autoScrollTimeInterval = self.model.noticeTimeInterval
        self.notiseScroll.titlesGroup = notice
        notiseScroll.tag = HomeTag.noticeScroll.rawValue
    }
    
    
    
    
    
    
    func initTitleView() -> Void {
        TLPrint("ininAccountView")
        let accountBgImg = UIImageView(frame:  CGRect(x: 0, y: bannerHeight + noticeHeight, width: width, height: adapt_H(height: titleHeight)))
        accountBgImg.image = UIImage(named: "home_title_bg.png")
        accountBgImg.isUserInteractionEnabled = true
        self.scroll.addSubview(accountBgImg)
        accountBgImg.tag = HomeTag.accountBgImg.rawValue
        
        //触摸事件tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapAct(sender:)))
        accountBgImg.addGestureRecognizer(tapGesture)
        var amountText = ""
        if let amount = userDefaults.value(forKey: userDefaultsKeys.userInfoBalance.rawValue) {
            if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
                if hasLogin as! Bool {
                    amountText = "¥\(amount)"
                }
            }
        }
        let initFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        amountLabel = baseVC.labelCreat(frame: initFrame, text: amountText, aligment: .left, textColor: model.amountTextColor, backgroundcolor: .clear, fonsize:fontAdapt(font: 16))
        accountBgImg.addSubview(amountLabel)
        amountLabel.tag = HomeTag.totleAccountLabel.rawValue
        amountLabel.mas_makeConstraints { (make) in
            _ = make?.bottom.equalTo()(adapt_H(height: -titleHeight * 0.2))
            _ = make?.left.equalTo()(adapt_W(width: 60))
            _ = make?.width.equalTo()(300)
            _ = make?.height.equalTo()(accountBgImg.frame.height * 0.25)
        }
        amountLabel.font = UIFont(name: "Arial-BoldMT", size: fontAdapt(font: 20))
        
        
        //中心钱包按钮
        let wallentFrame = CGRect(x: adapt_W(width: 150), y: adapt_H(height: 15), width: adapt_W(width: 89), height: adapt_H(height: 35))
        let wallentBtn = baseVC.buttonCreat(frame: wallentFrame, title: "", alignment: .center, target: self, myaction: #selector(self.titleBtnAct(sender:)), normalImage: UIImage(named:"home_title_walletBtn.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        
        accountBgImg.addSubview(wallentBtn)
        wallentBtn.tag = HomeTag.walletBtnTag.rawValue
        
        
        //签到按钮
        let signInFrame = CGRect(x: adapt_W(width: 250), y: adapt_H(height: 15), width: adapt_W(width: 89), height: adapt_H(height: 35))
        let signInBtn = baseVC.buttonCreat(frame: signInFrame, title: "", alignment: .center, target: self, myaction: #selector(self.titleBtnAct(sender:)), normalImage: UIImage(named:"home_title_btn.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)

        accountBgImg.addSubview(signInBtn)
        signInBtn.tag = HomeTag.signInBtnTag.rawValue
        
    }
    
    //===========================================
    //Mark:- initialize the game button view
    //===========================================
    private func initGameBtnView() -> Void {
        //initialize view of game button
        
        let gameViewY:CGFloat = bannerHeight + noticeHeight + titleHeight
        let gameViewHeight = adapt_H(height: isPhone ? 105 : 65) * CGFloat(Int((homeGameName.count + 1) / 2))
        let viewFrame = CGRect(x: 0, y: gameViewY, width: width, height: gameViewHeight)
        let gameView = baseVC.viewCreat(frame: viewFrame, backgroundColor: model.gameBackColor)
        gameView.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        self.scroll.addSubview(gameView)
        self.scroll.bringSubview(toFront: gameView)
        gameView.tag = HomeTag.gameVeiwTag.rawValue
        //initialize game button
        for i in 0 ..< homeGameName.count {
            
            let disY = adapt_H(height: 8)
            let disX = adapt_H(height: 8)
            let btnWidth = (width - 3 * disX) / 2
            let btnX = disX + (disX + btnWidth) * CGFloat(i % 2)
            let btnHeight = adapt_H(height: isPhone ? 100 : 60)
            let btnY = disY + (disY + btnHeight) * CGFloat(i / 2)
            
            let gameBtnFrame = CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight)
            let gameBtn = baseVC.buttonCreat(frame: gameBtnFrame, title: "", alignment: .center, target: self, myaction: #selector(gameBtnAction(sender:)), normalImage: UIImage(named:model.gameImg[i]), hightImage: UIImage(named:model.gameImg[i]), backgroundColor: .white, fonsize: model.gameTitleFont, events: .touchUpInside)
            gameBtn.tag = HomeTag.gameBtnTag.rawValue + i
            
            gameView.addSubview(gameBtn)
            gameBtn.layer.cornerRadius = adapt_W(width: 5)
           
            gameBtn.clipsToBounds = true
            //圆角和阴影不能同时出现，添加底部阴影层
            let shadowBtnFrame = CGRect(x: gameBtnFrame.origin.x + adapt_W(width: 5), y: gameBtnFrame.origin.y + adapt_H(height: 1), width: gameBtnFrame.width - adapt_W(width: 10), height: gameBtnFrame.height - adapt_H(height: 2))
            let shadowBtn = baseVC.buttonCreat(frame: shadowBtnFrame, title: "", alignment: .center, target: self, myaction: #selector(gameBtnAction(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .black, fonsize: model.gameTitleFont, events: .touchUpInside)
            gameView.insertSubview(shadowBtn, belowSubview: gameBtn)
            shadowBtn.layer.shadowColor = UIColor.black.cgColor
            shadowBtn.layer.shadowOffset = CGSize(width: 5, height: adapt_H(height: 5))
            shadowBtn.layer.shadowOpacity = 0.5
            
        }
    }
    
    
    //初始化邮箱匹配红包
    func initEmailRedbag(infoArray:[String]) -> Void {
        tlPrint("initEmailRedbag")
        let emailRedbagShadowView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.view.insertSubview(emailRedbagShadowView, aboveSubview: self.scroll)
        emailRedbagShadowView.backgroundColor = UIColor.black
        emailRedbagShadowView.alpha = 0.8
        emailRedbagShadowView.tag = HomeTag.emailRedbagShadowViewTag.rawValue
        
        
        let emailRedbagView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.view.insertSubview(emailRedbagView, aboveSubview: emailRedbagShadowView)
        emailRedbagView.tag = HomeTag.emailRedbagViewTag.rawValue
        //金币
        let goldenImg = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: adapt_H(height: 433)))
        emailRedbagView.addSubview(goldenImg)
        goldenImg.image = UIImage(named: "EmailRedbag_golden.png")
        goldenImg.center = emailRedbagView.center
        //红包
        let redbagWidth = adapt_W(width: 239)
        let redbagImg = UIImageView(frame: CGRect(x: (width - redbagWidth) / 2, y: 0, width: redbagWidth, height: adapt_H(height: 317)))
        emailRedbagView.insertSubview(redbagImg, aboveSubview: goldenImg)
        redbagImg.image = UIImage(named: "EmailRedbag_redbag.png")
        redbagImg.isUserInteractionEnabled = true
        redbagImg.center = emailRedbagView.center
        //确认按钮
        let confirmBtnWidth = adapt_W(width: 144.5)
        let confirmBtnFrame = CGRect(x: (redbagWidth - confirmBtnWidth) / 2, y: adapt_H(height: 240), width: confirmBtnWidth, height: adapt_H(height: 38))
        let confirmBtn = baseVC.buttonCreat(frame: confirmBtnFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"EmailRedbag_confirm.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        redbagImg.addSubview(confirmBtn)
        confirmBtn.tag = HomeTag.emailRedbagConfirmBtnTag.rawValue
        //红包金额标签
        //红包提示文本标签
       
        let labelFrameArray = [ CGRect(x: 0, y: adapt_H(height: 90), width: redbagWidth, height: adapt_H(height: 50)),CGRect(x: adapt_W(width: 50), y: adapt_H(height: 150), width: redbagWidth - adapt_W(width: 100), height: adapt_H(height: 50))]
//        let labelTextArray = ["8.8元","恭喜你获得邮箱匹配奖金! 恭喜你获得邮箱匹配奖金"]
        let labelTextColorArray = [UIColor.colorWithCustom(r: 219, g: 0, b: 0),UIColor.colorWithCustom(r: 159, g: 17, b: 17)]
        for i in 0 ..< 2 {
            let label = baseVC.labelCreat(frame: labelFrameArray[i], text: infoArray[i], aligment: .center, textColor: labelTextColorArray[i], backgroundcolor: .clear, fonsize: fontAdapt(font: 12))
            redbagImg.addSubview(label)
            label.numberOfLines = 0
            
            
            switch i {
            case 0:
                tlPrint("")
                
                label.font = UIFont(name: "Arial-BoldMT", size: fontAdapt(font: 38))
                let hintString = NSMutableAttributedString(string: infoArray[i])
                let range = NSRange(location: infoArray[i].characters.count - 1, length: 1)
                hintString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.colorWithCustom(r: 245, g: 63, b: 0), range: range)
                
                hintString.addAttributes([NSAttributedStringKey.font:UIFont(name: "Arial-BoldMT", size: fontAdapt(font: 17))!], range: range)
                
                label.attributedText = hintString
                break
                
            case 1:
                let attributedString:NSMutableAttributedString = NSMutableAttributedString(string:infoArray[i])
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = adapt_H(height: isPhone ? 6 : 4) //修改行间距
                attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0,  (infoArray[i]).characters.count))
                label.attributedText = attributedString
                label.textAlignment = .center
            default:
                tlPrint("no such case!")
            }
            
        }
        
        
        
        //金币动画效果
        UIView.animate(withDuration: 0.0001, animations: {
            goldenImg.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            goldenImg.isHidden = true
        }, completion: { (finished) in
            UIView.animate(withDuration: TimeInterval(0.5), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                goldenImg.isHidden = false
                goldenImg.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { (finisehd) in
                UIView.animate(withDuration: TimeInterval(0.3), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                    goldenImg.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }, completion: { (finisehd) in
                    UIView.animate(withDuration: TimeInterval(0.2), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                        goldenImg.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }, completion: { (finisehd) in
                        tlPrint(message: "动画完成")
                        
                    })
                
                })
            })
        })
        
        //红包动画效果
        UIView.animate(withDuration: 0.0001, animations: {
            redbagImg.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            redbagImg.isHidden = true
        }, completion: { (finished) in
            UIView.animate(withDuration: TimeInterval(0.5), delay: TimeInterval(0.2), options: .allowUserInteraction, animations: {
                redbagImg.isHidden = false
                redbagImg.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: { (finisehd) in
                UIView.animate(withDuration: TimeInterval(0.2), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                    redbagImg.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: { (finisehd) in
                    
                })
            })
        })
        
        
        
    }
    
    
    
    func removeEmailRedbagView() -> Void {
        tlPrint("removeEmailRedbagView  移除邮箱匹配红包视图")
        
        let emailShadowView = self.view.viewWithTag(HomeTag.emailRedbagShadowViewTag.rawValue)!
        let emailRedbagView = self.view.viewWithTag(HomeTag.emailRedbagViewTag.rawValue)!
        
        UIView.animate(withDuration: 0.5, animations: {
//            emailShadowView.frame = CGRect(x: self.width / 2, y: self.height, width: 0, height: 0)
            emailShadowView.alpha = 0
            emailRedbagView.frame = CGRect(x: 0, y: self.height, width: self.width, height: self.height)
        }) { (finished) in
            emailShadowView.removeFromSuperview()
            for view in emailRedbagView.subviews {
                view.removeFromSuperview()
            }
            emailRedbagView.removeFromSuperview()
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
    

    func getNoticeInfo() -> Void {
        
        getNoticeInfo(success: { (response) in
            tlPrint(message: "response: \(response)")
            let noticeString = response as! String
            tlPrint(message: "noticeArray: \(noticeString)")
            var sourceArray2:Array<String> = [""]
            var sourceArray = noticeString.components(separatedBy: "\",\"CreateTime\"")
            for i in 0 ..< sourceArray.count {
                let sourceSubArray = sourceArray[i].components(separatedBy: "\"Content\":\"")
                if sourceSubArray.count >= 2 {
                    sourceArray2.append(sourceSubArray[1])
                }
            }
            sourceArray2.removeFirst()
            DispatchQueue.main.async(execute: {
                self.initNoticeView(notice: self.noticeInfoDeal(strArray: sourceArray2))
            })
            
            
        }) { (error) in
            tlPrint(message: "error: \(error)")
            DispatchQueue.main.async(execute: {
                self.initNoticeView(notice: ["鸿福娱乐"])
            })
        }
    }
    
    func noticeInfoDeal(strArray: Array<String>) -> Array<String> {
        var newArray: Array = [""]
        var maxWord = 23
        
        tlPrint(message: "************** deviceScreen.width :\(deviceScreen.width)")
        switch deviceScreen.width {
        case 320.0:
            maxWord = 22
        case 375.0:
            maxWord = 26
        case 414.0:
            maxWord = 30
        default:
            if deviceScreen.width > 414.0 {
                maxWord = 34
            }
            tlPrint(message: "no such case")
        }
        if strArray.count < 1 {
            tlPrint(message: "收到的广播为空")
            return newArray
        }
        for i in 0 ..< strArray.count  {
            
            var temp = strArray[i] as String
            for _ in 0 ... (temp.characters.count - 1) / maxWord {
                var wordNum = maxWord
                if temp.characters.count < wordNum {
                    wordNum = temp.characters.count
                }
                let index = temp.index(temp.startIndex, offsetBy: wordNum)
                newArray.append(temp.substring(to: index))
                temp = temp.substring(from: index)
                
            }
        }
        newArray.removeFirst()
        return newArray
    }
    
    //===========================================
    //Mark:- get the notice info from api
    //Will response a Array<String> type
    //===========================================
    func getNoticeInfo(success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) {
        
        var domain:String!
        if let domain_t = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) {
            domain = domain_t as! String
            let url = domain + "active/gethfnotices"
            tlPrint(message: "url:\(url)")
            let network = TTNetworkRequest()
            network.getWithPath(path: url, paras: nil, success: { (response) in
                
                tlPrint(message: "response: \(response)")
                success(response)
                
            }, failure: { (error) in
                
                tlPrint(message: "error: \(error)")
                failure(error)
            })
        }
    }
    
    //=======================================================
    //Mark:- actions after press the title button down and up
    //=======================================================
    @objc func titleBtnAct(sender:UIButton) -> Void {
        tlPrint(message: "titleBtnAct")
        self.checkLoginStatus {
            self.view.isUserInteractionEnabled = false
//            sender.backgroundColor = self.model.titleBtnBackColor1
            switch sender.tag {
            case HomeTag.signInBtnTag.rawValue:
                TLPrint("签到赢奖金按钮")
                self.view.isUserInteractionEnabled = true
                let signinVC = PreferentViewController(pageType: PageType.singin)
                self.navigationController?.pushViewController(signinVC, animated: true)
                break
            case HomeTag.walletBtnTag.rawValue:
                tlPrint(message: "中心钱包")
                let walletHubVC = WalletHubViewController()
                self.navigationController?.pushViewController(walletHubVC, animated: true)
                self.view.isUserInteractionEnabled = true
                break
            case 10:
                tlPrint(message: "存款")
                self.withdrawBtnAnimate(img: self.titleBtnImg1, success: {
                    let rechargeVC = RechargeViewController(isFromTab: false)
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.pushViewController(rechargeVC, animated: true)
                })
            case 11:
                tlPrint(message: "中心钱包")
                self.walletBtnAct(img: self.titleBtnImg2)
            case 12:
                tlPrint(message: "取款")
                self.withdrawBtnAnimate(img: self.titleBtnImg3, success: {
                    self.withdrawBtnAct()
                })
            default:
                tlPrint(message: "no such case")
            }
        }
    }
    
    func withdrawBtnAct() -> Void {
        tlPrint(message: "withdrawBtnAct")
        
        let withdrawVC = WithdrawViewController(times: self.stringToInt(str: "5"))
        self.view.isUserInteractionEnabled = true
        self.navigationController?.pushViewController(withdrawVC, animated: true)
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
    
    func withdrawBtnAnimate(img:UIImageView,success: @escaping (() -> ())) -> Void {
        
        let diamondRate:CGFloat = 0.8
        //钻石和星星动画
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
            img.layer.setAffineTransform(CGAffineTransform.init(scaleX: diamondRate, y: diamondRate))
            
        }) { (finished) in
            UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
                img.layer.setAffineTransform(CGAffineTransform.identity)
            }, completion: { (finished) in })
        }
        //页面延时跳转
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.4)) {
            success()
        }
    }
    
    //中心钱包动画
    func walletBtnAct(img: UIImageView) -> Void {
        
        UIView.beginAnimations("walletAnimation", context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
        UIView.setAnimationTransition(.flipFromLeft, for: img, cache: false)
        UIView.commitAnimations()
        //页面延时跳转
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.4)) {
            let walletHubVC = WalletHubViewController()
            self.navigationController?.pushViewController(walletHubVC, animated: true)
            self.view.isUserInteractionEnabled = true
        }
    }
    
    
    

    
    //===========================================
    //Mark:- game button actions
    //===========================================
    @objc func gameBtnAction(sender: UIButton) -> Void {
        tlPrint(message: "gameBtnAction")
        let index = sender.tag - HomeTag.gameBtnTag.rawValue
        if index == 0 {
            checkLoginStatus(hasLogin: {
                //新PT游戏
                let gameToken = self.userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue) as! String
                let sender = ["gameToken":gameToken,"gameType": homeGameName[index]]
                //            self.rotateScreen(sender: ["oritation":"right"] as AnyObject)
                RotateScreen.right()
                self.userDefaults.setValue(homeGameCode[index], forKey: userDefaultsKeys.gameType.rawValue)
                let gameListVC = GameListViewController()
                gameListVC.param = sender as AnyObject!
                self.navigationController?.pushViewController(gameListVC, animated: true)
            })
            return
        }
        
        
        self.model.getGameBannerInfo { (gameBannerInfo) in
            let gameLobbyIndex = index - 1 //游戏大厅的下标需要排除PT游戏
            self.userDefaults.setValue(gameBannerInfo, forKey: userDefaultsKeys.gameDetailInfo.rawValue)
            let domain = self.userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
            let hotGameList = gameBannerInfo[1][self.model.gameKey[gameLobbyIndex]] as! Array<Int>
            tlPrint(message: hotGameList)
            let gameLobby = GameLobbyViewController(hotGameArray: hotGameList)
            gameLobby.bannerImageURL = "\(domain)\((gameBannerInfo[0][self.model.gameKey[index-1]] as! String))"
            gameLobby.gameName = homeGameName[index-1]
            gameLobby.gameIndex = gameLobbyIndex
            tlPrint(message: homeGameName[index])
            self.navigationController?.pushViewController(gameLobby, animated: true)
        }
    }
    
    
    
    func requestLatestInfo() -> Void {
        futuNetworkRequest(type: .get, serializer: .http, url: "Mobile/GetMobileConfig", params: nil, success: { (response) in
            tlPrint(message:"response: \(response)")
            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
            string = string!.replacingOccurrences(of: "\"{", with: "{")
            string = string!.replacingOccurrences(of: "}\"", with: "}")
            string = string!.replacingOccurrences(of: "\\", with: "")
            tlPrint(message: "string: \(String(describing: string))")
            if string == nil || string == "" || string == "\"Failed\"" {
                TLPrint("没有收到手机配置信息")
                return
            }
            let returnValue = (string)?.objectFromJSONString() as! Dictionary<String, Any>
//            let oldDomainName = self.userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue)
            let oldAppVersion = SystemInfo.getCurrentVersion()
            let newAppVersion = returnValue["version"] as! String
            let separateVersion = newAppVersion.components(separatedBy: ".")
            
            //不再管域名
            if oldAppVersion < newAppVersion as! String{
                tlPrint(message: "*********** 请更新版本 oldAppVersion:\(oldAppVersion) < newAppVersion:\(String(describing: newAppVersion))")
                //当前版本号超过三位，需要强制更新
                //1.2.1   不强制更新
                //1.2.1.0 强制更新
                if separateVersion.count > 3 {
                    self.isEssentialUpadate = true
                }
                
                
                if let updateUrl = returnValue["downloadAddr"] {
                    //获取app的更新地址
                    tlPrint(message: "get the download address: \(updateUrl)")
                    self.appUpdateUrl = (updateUrl as! String)
                    tlPrint(message: "self.appUpdateUrl : \(self.appUpdateUrl)")
                    var alert: UIAlertView!
                    if !self.isEssentialUpadate {
                        alert = UIAlertView(title: "更新提示", message: "你当前的版本是V\(oldAppVersion)，发现新版本V\(newAppVersion ),是否下载新版本？\n(若提示无法下载，请卸载以后在官网扫码下载)", delegate: self, cancelButtonTitle: "下次再说", otherButtonTitles: "立即下载")
                    } else {
                        alert = UIAlertView(title: "重要更新", message: "你当前的版本是V\(oldAppVersion)，发现新版本V\(newAppVersion ),该更新极为重要，请更新后再进入？\n(若提示无法下载，请卸载以后在官网扫码下载)", delegate: self, cancelButtonTitle: "立即下载")
                    }
                    alert.tag = 10
                    alert.show()
                    tlPrint(message: "当前bundleID为：\(SystemInfo.getBundleID())")
                }
            }
            tlPrint(message: "response:\(String(describing: response))")
        }) { (error) in
            tlPrint(message: "Error: \(String(describing: error))")
        }
    }
    @objc func tapAct(sender:UITapGestureRecognizer) -> Void {
        tlPrint(message: "tapAct: \(sender.view!.tag)")
        self.checkLoginStagus {
            if sender.view?.tag ==  HomeTag.accountBgImg.rawValue {
                let wallentVC = WalletHubViewController()
                self.navigationController?.pushViewController(wallentVC, animated: true)
            }
        }
        
    }
    //********************  宝箱活动部分  ********************
    var resultMaskView: UIView!
    var alertImg:UIImageView!
    private func initTreasureMaskView() -> UIView {
        let mask = UIView(frame: self.view.frame)
        mask.backgroundColor = UIColor.black
        mask.alpha = 0.8
        return mask
    }
    
    func initTreasureAlertView(info:Dictionary<String,Any>) -> Void {
        tlPrint(message: "initResultAlertView")
//        let infos = ["amount": 22, "status": 0, "msg": "您的存款未达到开宝箱要求，立即存款获取开宝箱次数！"] as [String : Any]
        let amount = info["amount"] as! Int
        let status = info["status"] as! Int
        let msg = (info["msg"] as! String).replacingOccurrences(of: "，", with: "\n")
        //添加蒙版
        self.resultMaskView = self.initTreasureMaskView()
        self.view.addSubview(resultMaskView)
        //添加弹窗底图
        let alertW = adapt_W(width: isPhone ? 350 : 250)
        let alertH = adapt_H(height: isPhone ? 320 : 220)
        let alertImgFrame = CGRect(x: (width - alertW) / 2, y: height, width: alertW, height: alertH)
        self.alertImg = baseVC.imageViewCreat(frame: alertImgFrame, image: UIImage(named:"TreasureBox_alert_bg.png")!, highlightedImage: UIImage(named:"TreasureBox_alert_bg.png")!)
        self.view.insertSubview(alertImg, aboveSubview: self.resultMaskView)
        
        //内容显示label
        let infoFrame = CGRect(x: adapt_W(width: 75), y: adapt_H(height: isPhone ? 80 : 50), width: alertImgFrame.width - adapt_W(width: 150), height: adapt_H(height: 80))
        let infoLabel = baseVC.labelCreat(frame: infoFrame, text: msg as! String, aligment: .center, textColor: .colorWithCustom(r: 255, g: 228, b: 0), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 17 : 12))
        alertImg.addSubview(infoLabel)
        infoLabel.numberOfLines = 0
        infoLabel.font = UIFont(name: "HelveticaNeue-Bold", size: fontAdapt(font: isPhone ? 14 : 12))
        if status == 2 {
            infoLabel.frame = CGRect(x: adapt_W(width: 75), y: adapt_H(height: isPhone ? 65 : 50), width: alertImgFrame.width - adapt_W(width: 150), height: adapt_H(height: 30))
            infoLabel.text = "恭喜您获得奖金"
            let amountFrame = CGRect(x: adapt_W(width: 75), y: adapt_H(height: isPhone ? 110 : 70), width: alertImgFrame.width - adapt_W(width: 150), height: adapt_H(height: 80))
            let amountLabel = baseVC.labelCreat(frame: infoFrame, text: "\(amount) 元", aligment: .center, textColor: .white, backgroundcolor: .clear, fonsize: 0)
            alertImg.addSubview(amountLabel)
            amountLabel.font = UIFont(name: "HelveticaNeue-Bold", size: fontAdapt(font: isPhone ? 32 : 25))
            
        }
        
        
        //确定按钮
        let confirmW = adapt_W(width: isPhone ? 142 : 120)
        let confirmH = adapt_H(height: isPhone ? 39 : 25)
        let confirmFrame = CGRect(x: (width - confirmW) / 2, y: height - adapt_H(height: isPhone ? 200 : 130), width: confirmW, height: confirmH)
        let confirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"TreasureBox_alert_confirm.png"), hightImage: UIImage(named:"TreasureBox_alert_confirm.png"), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        confirmBtn.tag = HomeTag.treasureBoxConfirmBtnTag.rawValue
        self.view.addSubview(confirmBtn)
        confirmBtn.isHidden = true
        
        //弹窗上弹动画
        UIView.animate(withDuration: 0.5, animations: {
            self.alertImg.frame = CGRect(x: (self.width - alertW) / 2, y: adapt_H(height: isPhone ? 160 : 110), width: alertW, height: alertH)
        }) { (finished) in
            //显示确认按钮
            confirmBtn.isHidden = false
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func dismissResultAlertView() -> Void {
        tlPrint(message: "dismissResultAlertView")
        
        if self.resultMaskView != nil {
            self.resultMaskView.removeFromSuperview()
            self.resultMaskView = nil
        }
        if self.alertImg != nil {
            for view in alertImg.subviews {
                view.removeFromSuperview()
            }
            self.alertImg.removeFromSuperview()
            self.alertImg = nil
        }
        if let confirmBtn = self.view.viewWithTag(HomeTag.treasureBoxConfirmBtnTag.rawValue) {
            (confirmBtn as! UIButton).removeFromSuperview()
        }
    }
    
    
    //********************   宝箱结束  ********************
    
    
    
    func redBagBtnAct() -> Void {
        tlPrint("redBagBtnAct")
        self.checkLoginStagus {
            let redBagModel = RedBagModel()
            redBagModel.getRedPacketAccount(success: { (response) in
                tlPrint("response:\(response)")
                let amount = response["Amount"]
                let message = response["msg"] as! String
                let index = message.index(message.startIndex, offsetBy: 1)
                let type_s = message.substring(to: index)
                tlPrint("type_s = \(type_s)")
                var type:Int = 1
                if let type_t:Int = Int(type_s) {
                    type = type_t
                }
                let redbagView = RedBagView(type: type, amount: "\(amount!)", frame: self.view.frame)
                self.view.addSubview(redbagView)
            }) {
                tlPrint("fialed")
                let alert = UIAlertView(title: "提 示", message: "获取红包失败", delegate: nil, cancelButtonTitle: "知道了")
                alert.show()
            }
        }
    }
    
    @objc func btnAct(sender:UIButton) -> Void {
        switch sender.tag {
        case HomeTag.loginBtnTag.rawValue:
            tlPrint(message: "点击了登录按钮")
            let loginVC = LoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
        case HomeTag.registerBtnTag.rawValue:
            tlPrint(message: "点击了注册按钮")
            let registerVC = RegisterViewController()
            self.navigationController?.pushViewController(registerVC, animated: true)
        case HomeTag.emailRedbagConfirmBtnTag.rawValue:
            tlPrint(message: "点击了邮箱红包确认按钮")
            self.removeEmailRedbagView()
        case HomeTag.serviceBtnTag.rawValue:
            tlPrint("点击了客服按钮")
            let serviceVC = ServiceViewController()
            self.navigationController?.pushViewController(serviceVC, animated: true)
        case HomeTag.redPacketBtnTag.rawValue:
            self.redBagBtnAct()
        case HomeTag.treasureBoxBtnTag.rawValue:
            tlPrint("点击了宝箱按钮")
            sender.isUserInteractionEnabled = false
            self.checkLoginStatus {
                self.model.getTreasureBoxInfo(success: { (responseDic) in
                    tlPrint("responseDic:\(responseDic)")
                    
                    self.initTreasureAlertView(info: responseDic)
                }, failure: {
                    tlPrint("出错")
                })
            }
        case HomeTag.treasureBoxConfirmBtnTag.rawValue:
            tlPrint("点击了宝箱确定按钮")
            self.dismissResultAlertView()
            let treasureBoxBtn = self.view.viewWithTag(HomeTag.treasureBoxBtnTag.rawValue) as! UIButton
            treasureBoxBtn.isUserInteractionEnabled = true
        default:
            tlPrint(message: "no such case!")
        }
    }
    
    //===========================================
    //Mark:- 弹窗处理函数
    //===========================================
    var isEssentialUpadate = false
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        tlPrint(message: "alertView - clickedButtonAt")
        switch alertView.tag {
        case 10:
            //app更新弹窗
            if buttonIndex == 1 || isEssentialUpadate {
                //确认更新app
                appUpdateUrl = appUpdateUrl.replacingOccurrences(of: "u0026", with: "&")
                let url = URL(string: appUpdateUrl)
                tlPrint(message: "new app url: \(String(describing: url))")
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: { (response) in
                        tlPrint(message: "response:\(response)")
                    })
                } else {
                
                    UIApplication.shared.openURL(url!)
                }
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
    
    private func refreshPull() ->Void {
        tlPrint(message: "refreshViewOfBlock")
        let header = MJRefreshNormalHeader()
        //修改字体
        header.stateLabel.font = UIFont.systemFont(ofSize: 15)
        header.lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: 13)
        //隐藏刷新提示文字
        header.stateLabel.isHidden = true
        //隐藏上次刷新时间
        header.lastUpdatedTimeLabel.isHidden = true
        header.setRefreshingTarget(self, refreshingAction: #selector(self.refreshAct))
        self.scroll.mj_header = header
    }
    
    @objc func refreshAct() -> Void {
        tlPrint(message: "refreshAct")
        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
            if !(hasLogin as! Bool) {//未登录
                self.scroll.mj_header.endRefreshing()
                return
            }
        } else {//持久存储没有登录信息
            self.scroll.mj_header.endRefreshing()
            return
        }
        self.getAccount()
        self.scroll.mj_header.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


func refreshHeader(scrollView:UIScrollView,action:Selector) -> Void {
    tlPrint(message: "refreshViewOfBlock")
    let header = MJRefreshNormalHeader()
    //修改字体
    header.stateLabel.font = UIFont.systemFont(ofSize: 15)
    header.lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: 13)
    
    //隐藏刷新提示文字
    header.stateLabel.isHidden = true
    //隐藏上次刷新时间
    header.lastUpdatedTimeLabel.isHidden = true
    header.setRefreshingTarget(nil, refreshingAction: action)
    scrollView.mj_header = header
}



