//
//  GameLobbyViewController.swift
//  FuTu
//
//  Created by Administrator1 on 22/11/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit





protocol lobbyDelegate {
    func alertBtnAct(sender:UIButton)
}

class GameLobbyViewController: UIViewController,UITextFieldDelegate, UIScrollViewDelegate, lobbyDelegate ,UIAlertViewDelegate{

    var gameIndex:Int!
    var gameName,gameId:String!
    var scroll: UIScrollView!
    let model = LobbyModel()
    let baseVC = BaseViewController()
    var transInOutView:LobbyTransInOutView!
    var bannerImageURL:String!
    var refreshIndicator:RefreshIndicator!
    var width,height: CGFloat!
    var playBtn: UIButton!
    var dataSource: Array<String>!
    let initFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var indecator:TTIndicators!
    var hotGameArray:Array<Int>!
    
    //优惠券张数
    //var preferentNumber = 2
    override func viewDidLoad() {
        tlPrint(message: "gameLobby")
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        height = self.view.frame.height
        width = self.view.frame.width
        self.view.backgroundColor = UIColor.clear
        dataSource = self.model.PTDataSource
        tlPrint(message: "\n\n\n热门游戏列表：\(self.hotGameArray)\n\\n\n")
        
        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
            if hasLogin as! Bool {
                self.getAccount(success: {
                    tlPrint(message: "游戏详情页获取数据成功")
                }, failure: {
                    tlPrint(message: "游戏详情页获取数据失败")
                })
            }
        }
        notifyRegister()
        
        //初始化返回按钮
//        initBackBtn()
        initNavigationBar()
        //初始化滚动视图
        initScrollView()
        //初始化下拉刷新
        //refreshPull()
        initStatuBarBackColor()
        tlPrint(message: "gameIndex: \(gameIndex)")
        tlPrint(message: "game lobby game name: \(gameName)")
        
    }
    
    init(hotGameArray:Array<Int>) {
        super.init(nibName: nil, bundle: nil)
        self.hotGameArray = hotGameArray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //===========================================
    //Mark:- set the style of status bar
    //===========================================
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tlPrint(message: "viewWillAppear")
        self.refreshAct()
    }
    
    
    func initNavigationBar() -> Void {
        //view
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20 + navBarHeight))
        self.view.addSubview(navigationView)
        let gradientLayer = CAGradientLayer.GradientLayer(topColor: UIColor.colorWithCustom(r: 65, g: 50, b: 48), buttomColor: UIColor.colorWithCustom(r: 43, g: 38, b: 34))
        gradientLayer.frame = navigationView.frame
        navigationView.layer.insertSublayer(gradientLayer, at: 0)
        
        //label
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: width, height: navBarHeight))
        setLabelProperty(label: titleLabel, text: gameLobbyGameName[self.gameIndex], aligenment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .clear, font: 17)
        navigationView.addSubview(titleLabel)
        
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        navigationView.addSubview(backBtn)
        backBtn.tag = LobbyTag.backBtnAct.rawValue
        //back button image
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
        
    }

    
    
    func getAccount(success:@escaping(()->()),failure:@escaping(()->())) -> Void {
        //获取各个平台的余额
        
        futuNetworkRequest(type: .get,serializer: .http, url: model.gameBalanceUrl, params: ["gamecode":gameLobbyGameCode[self.gameIndex]], success: { (response) in
            tlPrint(message: "response:\(response)")
            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
            tlPrint(message: "string:\(String(describing: string))")
            string = retain2Decima(originString: string!)
            self.model.gameAccountDeal(account: string!, index: self.gameIndex, success: {
                tlPrint(message: "游戏详情页处理数据成功")
                success()
            })
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
            failure()
        })
        
    }
    
    //注册消息通知
    func notifyRegister() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(self.modifyAccountLabel(sender:)), name: NSNotification.Name(rawValue: notificationName.PlatformGameAccountModify.rawValue), object: nil)
        
    }
    //消息通知改变中心钱包金额
    @objc func modifyAccountLabel(sender:Notification) -> Void {
        let accountLabel = self.view.viewWithTag(LobbyTag.gameAccountLabel.rawValue) as! UILabel
        
        var account = sender.object
        if "\(String(describing: account))" == "\"Failed\"" {
            tlPrint(message: "拿到的数据为Failed")
            account = "0.0"
        }
        accountLabel.text = "¥ \(account!)"
    }
    
    //初始化状态条背景
    func initStatuBarBackColor() -> Void {
        
        let statusBarImg = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        self.view.addSubview(statusBarImg)
        statusBarImg.image = UIImage(named: "home_statusBar_img.png")
    }
    
    //初始化返回按钮
    func initBackBtn() -> Void {
        tlPrint(message: "initBackBtn")
        let backFrame = CGRect(x: adapt_W(width: isPhone ? 12 : 18), y: adapt_H(height: isPhone ? 25 : 15), width: adapt_W(width: isPhone ? 35 : 25), height: adapt_W(width: isPhone ? 35 : 25))
        let backBtn = baseVC.buttonCreat(frame: backFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named: dataSource[0]), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
        self.view.insertSubview(backBtn, at: 1)
        backBtn.tag = LobbyTag.backBtnAct.rawValue
        
    }

    var bannerImgView:UIImageView!
    //初始化滚动视图
    func initScrollView() -> Void {
        tlPrint(message: "initScrollView")
        let scrollFrame = CGRect(x: 0, y: 20 + navBarHeight, width: width, height: height - (20 + navBarHeight))
        scroll = UIScrollView(frame: scrollFrame)
        self.view.insertSubview(scroll, at: 0)
        self.automaticallyAdjustsScrollViewInsets = false
        
        let scrollHeight:CGFloat = height + adapt_H(height: 1)
        scroll.contentSize = CGSize(width: width, height: scrollHeight)
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = self
        
        //初始化游戏图片视图
        initImageView()
        //初始化帐户信息视图
        initAccountView()
        
//        if self.gameIndex == 1 || self.gameIndex == 2 {
//            //AG真人和AG捕鱼不显示热门游戏
//            return
//        }
//        initGameDetail()
    }
    
     //初始化游戏图片视图
    func initImageView() -> Void {
        tlPrint(message: "initImageView")
        let imgFrame = CGRect(x: 0, y: 0, width: width, height: adapt_H(height: isPhone ? 210 : 190))
        bannerImgView = UIImageView(frame: imgFrame)
        self.scroll.insertSubview(bannerImgView, at: 0)
        bannerImgView.image = UIImage(named: "lobby_bannerImg_\(globleGameCode[self.gameIndex]).png")
        
        
//        bannerImgView.sd_setImage(with: URL(string: self.bannerImageURL), placeholderImage: UIImage(named: "auto-image.png"))
        
        
        
    }
    
    func initPlayBtn() -> Void {
        tlPrint(message: "initPlayBtn")
        let playBtn = baseVC.buttonCreat(frame: initFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named: dataSource[2]), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
        self.scroll.addSubview(playBtn)
        self.scroll.bringSubview(toFront: playBtn)
        playBtn.frame = CGRect(x: (width - adapt_H(height: (isPhone ? 278 : 180))) / 2 , y: adapt_H(height: isPhone ? 420 : 300), width: adapt_W(width: isPhone ? 278 : 180), height: adapt_W(width: isPhone ? 61 : 40))
        playBtn.tag = LobbyTag.gamePlayBtnTag.rawValue
    }
    //===========================================
    //Mark:- 进入游戏列表页面
    //===========================================
    
    //增加游戏需要修改
    let gameType = ["MG","SG","PNG","HB","TTG","BS"]
    //增加游戏需要修改
    let gameTokenAddr = ["Game/GetMgToken","Game/GetSgToken","Game/GetPngToken","Game/GetHabaToken","Game/GetTtgToken","Game/GetBetSoftToken"]
    
    func playBtnAct() -> Void {
        tlPrint(message: "playBtnAct")
        //gameType用去区分游戏游戏列表显示的数据
        if self.indecator == nil {
            self.indecator = TTIndicators(view: self.view, frame: portraitIndicatorFrame)
        }
        self.indecator.play(frame: portraitIndicatorFrame)
        
//        let currentType = gameType[self.gameIndex]
        let playBtn = self.scroll.viewWithTag(LobbyTag.gamePlayBtnTag.rawValue) as! UIButton
        playBtn.isUserInteractionEnabled = false
        let param = ["":""]
//        switch currentType {
//        case "AG":
//            param = ["gameType":"0","fromUrl":"www.toobet.com","oddType":"A"]
//            self.getGameToken(type: .post, isGameList: false, param: param,url: gameTokenAddr[self.gameIndex])
//        case "AGFish":
//            param = ["gameType":"6","fromUrl":"www.toobet.com","oddType":"A"]
//            self.getGameToken(type: .post, isGameList: false, param: param,url: gameTokenAddr[self.gameIndex])
//        default:
//            self.getGameToken(type: .get, isGameList: true, param: param,url: gameTokenAddr[self.gameIndex])
//        }
        self.getGameToken(type: .get, isGameList: true, param: param,url: gameTokenAddr[self.gameIndex])
        
        playBtn.isUserInteractionEnabled = true

    }
    
    func getHotGameToken(param:Dictionary<String,Any>,url:String,success: @escaping ((_ token: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) -> Void {
        futuNetworkRequest(type: .get, serializer: .http, url: url, params: param, success: { (response) in
            tlPrint(message: "response:\(response)")
            //去空格
            let gameToken_t = response as! Data
            var gameToken = String(data: gameToken_t , encoding: String.Encoding.utf8)
            gameToken = gameToken!.replacingOccurrences(of: "\"", with: "")
            
            //返回游戏token
            gameToken = gameToken!.replacingOccurrences(of: "\\", with: "")
            tlPrint(message: "gameToken:\(String(describing: gameToken))")
//            let sender = ["gameToken":gameToken,"gameType":self.gameType[self.gameIndex]]
//            self.rotateScreen(sender: ["oritation":"right"] as AnyObject)
            userDefaults.setValue(self.gameType[self.gameIndex], forKey: userDefaultsKeys.gameType.rawValue)
            success(gameToken ?? "default_token")
            
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
            
        })
    }
    
    func getGameToken(type:NetworkRequestType,isGameList:Bool,param:Dictionary<String,Any>,url:String) -> Void {
        tlPrint(message: "getGameToken")
        //gameURL用于获取游戏Token
            futuNetworkRequest(type: .get, serializer: .http, url: url, params: param, success: { (response) in
                tlPrint(message: "response:\(response)")
                //去空格
                let gameToken_t = response as! Data
                var gameToken = String(data: gameToken_t , encoding: String.Encoding.utf8)
                gameToken = gameToken!.replacingOccurrences(of: "\"", with: "")
                tlPrint(message: "current game index = \(self.gameIndex)")
                if isGameList {
                    //返回游戏token
                    gameToken = gameToken!.replacingOccurrences(of: "\\", with: "")
                    tlPrint(message: "gameToken:\(String(describing: gameToken))")
                    let sender = ["gameToken":gameToken,"gameType":self.gameType[self.gameIndex]]
                    self.rotateScreen(sender: ["oritation":"right"] as AnyObject)
                    userDefaults.setValue(self.gameType[self.gameIndex], forKey: userDefaultsKeys.gameType.rawValue)
                    let gameListVC = GameListViewController()
                    gameListVC.param = sender as AnyObject!
                    if self.indecator != nil {
                        self.indecator.stop()
                    }
                    self.navigationController?.pushViewController(gameListVC, animated: true)
                }
//                else if self.gameType[self.gameIndex] == "AG" || self.gameType[self.gameIndex] == "AGFish" {
//                    
//                    //该游戏返回的游戏地址
//                    gameToken = gameToken!.replacingOccurrences(of: "\\", with: "")
//                    tlPrint(message: "gameToken:\(String(describing: gameToken))")
//                    var url:String = gameToken!
//                    url = url.replacingOccurrences(of: "\\u", with: "&")
//                    url = url.replacingOccurrences(of: "\"", with: "")
//                    tlPrint(message: "new url: \(url)")
//                    
//                    let sender = ["gameType":self.gameType[self.gameIndex],"orientation":self.gameType[self.gameIndex] == "AG" ? "all" : "right","url":"\(url)"]
//                    self.rotateScreen(sender: ["oritation":sender["orientation"]] as AnyObject)
//                    userDefaults.setValue(self.gameType[self.gameIndex], forKey: userDefaultsKeys.gameType.rawValue)
//                    let gameVC = GameViewController()
//                    gameVC.param = sender as AnyObject!
//                    self.navigationController?.pushViewController(gameVC, animated: true)
//                    if self.indecator != nil {
//                        self.indecator.stop()
//                    }
//
//                }
                else {
                    if (gameToken != nil) && gameToken == "false" {
                        self.getGameToken(type: .get, isGameList: false, param: ["":""],url: self.gameTokenAddr[self.gameIndex])
                    } else {
                        var url:String = gameToken!
                        url = url.replacingOccurrences(of: "\\u0026", with: "&")
                        url = url.replacingOccurrences(of: "\"", with: "")
                        url = url.replacingOccurrences(of: "\\", with: "")
                        tlPrint(message: "new url: \(url)")
                            
                        let sender = ["gameType":"BBIN","orientation":"portrait","url":"\(url)"]
                        let gameVC = GameViewController()
                        gameVC.param = sender as AnyObject!
                        if self.indecator != nil {
                            self.indecator.stop()
                        }
                            self.navigationController?.pushViewController(gameVC, animated: true)
                        }
                    }
            }, failure: { (error) in
                tlPrint(message: "error:\(error)")
            
            })
    }
    
    
    func check(string:String) -> String {
        let  result = NSMutableString()
        // 使用正则表达式一定要加try语句
        do {
            // - 1、创建规则
            let pattern = "[a-zA-Z_0-9]"
            // - 2、创建正则表达式对象
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            // - 3、开始匹配
            let res = regex.matches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.characters.count))
            // 输出结果
            for checkingRes in res {
                let nn = (string as NSString).substring(with: checkingRes.range) as NSString
                result.append(nn as String)
            }
        } catch {
            print(error)
        }
        return result as String
        
    }

    

    //========================
    //Mark:- 旋转屏幕
    //========================
    func  rotateScreen(sender: AnyObject) -> Void {
        
        tlPrint(message: "rotateScrenn sender: \(sender)")
        if let oritation = sender.value(forKey: "oritation") {
            switch oritation as! String {
            case "portrait":
                
                RotateScreen.portrait()
            case "right":
                
                RotateScreen.right()
            case "left":
                
                RotateScreen.left()
                
            case "all":
                
                RotateScreen.all()
            default:
                break
            }
        }
    }


    
    //初始化帐户信息视图
    func initAccountView() -> Void {
        tlPrint(message: "initAccountView")
        let accountBg = UIImageView(frame: CGRect(x: 0, y: bannerImgView.frame.height, width: width, height: adapt_H(height: 600)))
        self.scroll.addSubview(accountBg)
        let gradientLayer = CAGradientLayer.GradientLayer(topColor: UIColor.colorWithCustom(r: 146, g: 14, b: 54), buttomColor: UIColor.colorWithCustom(r: 51, g: 10, b: 22))
        gradientLayer.frame = CGRect(x: 0, y: 0, width: accountBg.frame.width, height: accountBg.frame.height)
        accountBg.layer.insertSublayer(gradientLayer, at: 0)
        accountBg.isUserInteractionEnabled = true
        //初始化播放按钮
        initPlayBtn()
        
        //infoView
        let infoView = UIView()
        infoView.backgroundColor = UIColor.white
        accountBg.addSubview(infoView)
        infoView.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(adapt_H(height: 14))
            _ = make?.left.equalTo()(adapt_W(width: isPhone ? 13 : 25))
            _ = make?.right.equalTo()(accountBg.mas_right)?.setOffset(adapt_W(width: isPhone ? -13 : -25))
            _ = make?.height.equalTo()(adapt_H(height: isPhone ? 160 : 100))
        }
        infoView.layer.borderColor = UIColor.colorWithCustom(r: 225, g: 225, b: 225).cgColor
        infoView.layer.borderWidth = 0.5
        infoView.layer.cornerRadius = adapt_H(height: isPhone ? 7 : 5)
        infoView.clipsToBounds = true
        infoView.isUserInteractionEnabled = true
        //黄条
        let yellowLine = UIView()
        infoView.addSubview(yellowLine)
        yellowLine.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(adapt_W(width: 18))
            _ = make?.height.equalTo()(adapt_H(height: 20))
            _ = make?.top.equalTo()(adapt_H(height: 20))
            _ = make?.width.equalTo()(adapt_W(width: 5))
        }
        yellowLine.backgroundColor = UIColor.colorWithCustom(r: 255, g: 198, b: 0)
        
        //game label
        let gameNameLabel = UILabel()
        infoView.addSubview(gameNameLabel)
        //Balance label
        let balanceLabel = UILabel()
        infoView.addSubview(balanceLabel)
        
        gameNameLabel.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(adapt_H(height: isPhone ? 10 : 8))
            _ = make?.left.equalTo()(yellowLine.mas_right)?.setOffset(adapt_W(width: 5))
            _ = make?.right.equalTo()
            _ = make?.height.equalTo()(adapt_H(height: 40))
        }
        gameNameLabel.text = gameLobbyGameName[self.gameIndex]
        
        gameNameLabel.textAlignment = .left
        gameNameLabel.textColor = UIColor.colorWithCustom(r: 58, g: 58, b: 58)
        gameNameLabel.font = UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 18 : 14))
        gameNameLabel.font = UIFont(name: "Arial-BoldMT", size: fontAdapt(font: isPhone ? 18 : 14))
        
        //Balance label
        balanceLabel.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(gameNameLabel.mas_left)
            _ = make?.top.equalTo()(gameNameLabel.mas_bottom)?.setOffset(adapt_H(height: 0.5))
            _ = make?.width.equalTo()(adapt_W(width: 80))
            _ = make?.height.equalTo()(adapt_H(height: 80))
        }
        balanceLabel.text = "游戏余额:"
        balanceLabel.font = UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 16 : 12))
        balanceLabel.textColor = UIColor.colorWithCustom(r: 106, g: 106, b: 106)
        //Balance amount label
        let balanceAmount = UILabel()
        infoView.addSubview(balanceAmount)
        balanceAmount.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(balanceLabel.mas_right)
            _ = make?.right.equalTo()
            _ = make?.height.equalTo()(balanceLabel.mas_height)
            _ = make?.top.equalTo()(balanceLabel.mas_top)
        }
        var balanceValue:String = ""
        if let balanceValue_u = userDefaults.value(forKey: gameLobbyGameUserDefaults[self.gameIndex]) {
            balanceValue = balanceValue_u as! String
        }
        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
            if hasLogin as! Bool {
                
            } else {
                balanceValue = "0.00"
            }
        } else {
            balanceValue = "0.00"
        }
        
        balanceAmount.text = "¥ \(balanceValue)"
        tlPrint(message: "balanceAmount.text = \(String(describing: balanceAmount.text))")
        balanceAmount.textColor = UIColor.colorWithCustom(r: 119, g: 0, b: 19)
        balanceAmount.font = UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 24 : 17))
        balanceAmount.tag = LobbyTag.gameAccountLabel.rawValue

        let line = UIView()
        infoView.addSubview(line)
        line.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()
            _ = make?.right.equalTo()
            _ = make?.bottom.equalTo()(balanceLabel.mas_top)
            _ = make?.top.equalTo()(gameNameLabel.mas_bottom)
        }
        line.backgroundColor = UIColor.colorWithCustom(r: 192, g: 192, b: 192)
        
        if gameType[gameIndex] == "newPT" {
            tlPrint(message: "新PT游戏")
            return
        }
        
        
        //recharge(充值) button
        let buttonHeight = adapt_H(height: isPhone ? 40 : 30)
        
        let rechargeBtn = baseVC.buttonCreat(frame: initFrame, title: "转  入", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: model.rechargeBtnColor, fonsize: fontAdapt(font: isPhone ? 15 : 10), events: .touchUpInside)
        rechargeBtn.setTitleColor(model.rechargeTextColor, for: .normal)
        infoView.addSubview(rechargeBtn)
        rechargeBtn.tag = LobbyTag.rechargeBtnTag.rawValue
        //Withdraw(提现) button
        let withdrawBtn = baseVC.buttonCreat(frame: initFrame, title: "转  出", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: model.rechargeBtnColor, fonsize: fontAdapt(font: isPhone ? 15 : 10), events: .touchUpInside)
        withdrawBtn.setTitleColor(model.rechargeTextColor, for: .normal)
        infoView.addSubview(withdrawBtn)
        withdrawBtn.tag = LobbyTag.withdrawBtnTag.rawValue
        rechargeBtn.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()
            _ = make?.right.equalTo()(withdrawBtn.mas_left)?.setOffset(adapt_W(width:-1))
            _ = make?.bottom.equalTo()
            _ = make?.height.equalTo()(buttonHeight)
        }
        tlPrint(message: "buttonHeight = \(buttonHeight)")
        
        withdrawBtn.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(rechargeBtn.mas_top)
            _ = make?.bottom.equalTo()(rechargeBtn)
            _ = make?.right.equalTo()
            _ = make?.left.equalTo()(rechargeBtn.mas_right)?.setOffset(adapt_W(width: 1))
            _ = make?.width.equalTo()(rechargeBtn.mas_width)
        }
    }
    
    
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offSetY:CGFloat = scrollView.contentOffset.y
        if offSetY < 0 {
            let originH = adapt_H(height: isPhone ? 210 : 190)
            let originW:CGFloat = width
            let newHeight = -offSetY + originH
            let newWidth = -offSetY * originW / originH + originW
            bannerImgView.frame = CGRect(x: offSetY * originW / originH / 2, y: offSetY, width: newWidth, height: newHeight)
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
        self.isRefreshing = true
        let refreshIndecatorFrame = CGRect(x: (width - adapt_W(width: 20))/2 , y: adapt_H(height: isPhone ? 20 : 10), width: adapt_W(width: 20), height: adapt_W(width: 20))
        if self.refreshIndicator == nil {
            self.refreshIndicator = RefreshIndicator(view: self.view, frame: refreshIndecatorFrame)
            //self.walletHubView.refreshIndicator.refreshPlay(frame: refreshIndecatorFrame)
        } else {
            self.refreshIndicator.refreshPlay(frame: refreshIndecatorFrame)
        }
        self.getAccount(success: { 
            tlPrint(message: "中心钱包页刷新数据成功")
            self.refreshIndicator.refreshStop()
            self.isRefreshing = false
//            let notify = NSNotification.Name(rawValue: notificationName.HomeAccountValueRefresh.rawValue)
//            NotificationCenter.default.post(name: notify, object: nil)
        }, failure: {
            tlPrint(message: "游戏详情页刷新数据失败")
            self.refreshIndicator.refreshStop()
            self.isRefreshing = false
        })
    }
    

    
    
    @objc func btnAct(sender:UIButton) -> Void {
        
        if sender.tag == LobbyTag.backBtnAct.rawValue {
            tlPrint(message: "返回")
            let notify = NSNotification.Name(rawValue: notificationName.HomeAccountValueRefresh.rawValue)
            NotificationCenter.default.post(name: notify, object: nil)
            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        
        self.checkLoginStatus {
            switch sender.tag {
            case LobbyTag.gamePlayBtnTag.rawValue:
                tlPrint(message: "开始游戏")
                self.playBtnAct()
            case LobbyTag.rechargeBtnTag.rawValue:
                tlPrint(message: "充值按钮")
                self.gameBtnAct(sender: sender)
            case LobbyTag.withdrawBtnTag.rawValue:
                tlPrint(message: "提现按钮")
                self.gameBtnAct(sender: sender)
            default:
                sender.isEnabled = false
                if self.indecator == nil {
                    self.indecator = TTIndicators(view: self.view, frame: portraitIndicatorFrame)
                }
                self.indecator.play(frame: portraitIndicatorFrame)
                self.getHotGameToken(param: ["":""], url: self.gameTokenAddr[self.gameIndex], success: { (token) in
                    tlPrint(message: "token:\(token)")
                    self.startHotGame(sender: sender, token: token as! String)
                }, failure: { (error) in
                    tlPrint(message: error)
                })
                
            }
        }
        
        
    }
    
    func startHotGame(sender:UIButton,token:String) -> Void {
        if sender.tag >= LobbyTag.hotGameBtnTag.rawValue {
            tlPrint(message: "热门推荐游戏按钮\(sender.tag - LobbyTag.hotGameBtnTag.rawValue)")
            let gameNumber = sender.tag - LobbyTag.hotGameBtnTag.rawValue
            let gameListModel = GameListModel()
            //增加游戏需要修改
            //游戏资源字典
            let dataSourceDic = ["BS":gameListModel.BSDataSource,"PT":gameListModel.PTDataSource,"MG":gameListModel.MGDataSource,"TTG":gameListModel.TTGDataSource,"SG":gameListModel.SGDataSource,"HB":gameListModel.HBDataSource,"PNG":gameListModel.PNGDataSource]
            //游戏地址字典
            
            let gameAddrDic = ["BS":gameListModel.BSGameAddr,"PT":gameListModel.PTGameAddr,"MG":gameListModel.MGGameAddr,"TTG":gameListModel.TTGGameAddr,"SG":gameListModel.SGGameAddr,"HB":gameListModel.HBGameAddr,"PNG":gameListModel.PNGGameAddr]
            
            
            self.gameId = (dataSourceDic[gameType[gameIndex]]![sender.tag - LobbyTag.hotGameBtnTag.rawValue] as! NSArray)[2] as! String
            tlPrint(message: gameId)
            var url = gameAddrDic[gameType[gameIndex]]!
            let userName = userDefaults.value(forKey: userDefaultsKeys.userName.rawValue)as! String
            let passWord = userDefaults.value(forKey: userDefaultsKeys.passWord.rawValue)as! String
            switch self.gameType[self.gameIndex] {
            case "BS":
                url = url+"&token=\(token)&gameId=\(gameId!)"
            case "AV":
                url = url+"&token=\(token)&gameconfig=\(gameId!)"
            case "PT":
                url = url+"&token=\(token)&gameconfig=\(gameId!)"
            case "TTG":
                url = url+"&playerHandle=\(token)&gameId=\(gameId!)&gameName=\((gameListModel.TTGDataSource[gameNumber] as! Array<String>)[3])&gameType=0"
            case "SG":
                url = url+"&acctId=ft\(userName)&token=\(token)&game=\(gameId!)"
            case "HB":
                url = url+"&token=\(token)&keyname=\(gameId!)"
            case "MG":
                let xmanEndPoints = "https://xplay22.gameassists.co.uk/xman/x.x"
                url = url+"\(gameId!)/zh-cn/?lobbyURL=&bankingURL=&username=ft\(userName)&password=\(passWord)&currencyFormat=%23%2C%23%23%23.%23%23&logintype=fullUPE&xmanEndPoints=\(xmanEndPoints)"
            case "PNG":
                url = url+"&gameid=\(gameId!)&ticket=\(token)"
//            case "AG":
//                url = url+"&gameid=\(gameId!)&ticket=\(token)"
//            case "AGFish":
//                tlPrint(message: "currentIndex = \(String(describing: gameIndex))")
//                url = url+"&gameid=\(gameId!)&ticket=\(token)"
                
            default:
                tlPrint(message: "no such game type")
            }
            
            
            RotateScreen.right()
            let gameVC = GameViewController()
            gameVC.param = ["orientation":"right","url":url] as AnyObject
            gameVC.isFromLandscap = true
            tlPrint(message: "开始跳转到游戏界面")
            
            sender.isEnabled = true
            self.indecator.stop()
            self.navigationController?.pushViewController(gameVC, animated: true)
            
            
        } else {
            tlPrint(message: "no such case")
        }
    }
    
    func gameBtnAct(sender: UIButton) {
        tlPrint(message: "gameBtnAct")
        
        let transferType:String = sender.tag == LobbyTag.rechargeBtnTag.rawValue ? "转入" : "转出"
        self.transInOutView = LobbyTransInOutView(frame: self.view.frame, param: [self.gameIndex,transferType], rootVC: self)

        self.view.insertSubview(transInOutView, aboveSubview: scroll)
        
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
        switch sender.tag {
        case TransferTag.alertCloseBtnTag.rawValue:
            self.view.bringSubview(toFront: self.scroll)
        case TransferTag.alertConfirmBtnTag.rawValue:
            
            transferValueDeal()
        default:
            tlPrint(message: "no such case")
        }
    }
    
    func transferValueDeal() -> Void {
        tlPrint(message: "transferValueDeal")

        
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
        
        if self.indecator == nil {
            self.indecator = TTIndicators(view: self.view, frame: portraitIndicatorFrame)
        }
        self.indecator.play(frame: portraitIndicatorFrame)
        
        
        amount = value!
        
        let url = transInOutView.transferType == "转入" ? model.deposit : model.withdrawl
        futuNetworkRequest(type: .post, serializer: .http, url: url, params: ["amount":amount,"gameCode":gameLobbyGameCode[self.transInOutView.gameIndex]], success: { (response) in
            tlPrint(message: "response:\(response)")
            let string = String(data: response as! Data, encoding: String.Encoding.utf8)
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
                tlPrint(message: "游戏详情页转入成功，刷新数据成功")
                
                self.indecator.stop()
            }, failure: {
                tlPrint(message: "游戏详情页转入成功，刷新数据失败")
                self.indecator.stop()
            })
            
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
        })
        
        //去掉弹窗
        //self.view.bringSubview(toFront: self.)
        self.transInOutView.backView.removeFromSuperview()
        self.transInOutView.backView = nil
        for view in self.transInOutView.subviews {
            view.removeFromSuperview()
        }
        self.transInOutView.removeFromSuperview()
        self.transInOutView = nil
    }
    
    
    
    
    
    //textField delegate
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if transInOutView == nil {
            return
        }
        if transInOutView.transferInTextField != nil {
            transInOutView.transferInTextField.resignFirstResponder()
        
            UIView.animate(withDuration: 0.3, animations: {
                self.transInOutView.alertView.center = self.transInOutView.center
            })
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.3, animations: {
            self.transInOutView.alertView.frame = CGRect(x: adapt_W(width: isPhone ? 20 : 80), y: adapt_H(height: isPhone ? 80 : 130), width: self.width - adapt_W(width: isPhone ? 40 : 160), height: adapt_H(height: isPhone ? 205 : 105))
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
