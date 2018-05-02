////
////  HomeView.swift
////  FuTu
////
////  Created by Administrator1 on 3/12/16.
////  Copyright © 2016 Taylor Tan. All rights reserved.
////
//
//import UIKit
//
//class HomeView: UIView,SDCycleScrollViewDelegate {
//
//    let baseVC = BaseViewController()
//    let model = HomeModel()
//    var amountLabel: UILabel!
//    var noticeLabel: UILabel!
//    var notiseScroll : SDCycleScrollView!
//    var cycleScroll : SDCycleScrollView!
//    var homeDelegate : HomeViewDelegate!
//    
//    var titleBtnImg1,titleBtnImg1_start,titleBtnImg2,titleBtnImg3,titleBtnImg3_hammer: UIImageView!
//    var titleBtn1,titleBtn2,titleBtn3,imgView1,imgView3:UIButton!
//    let userDefaults = UserDefaults.standard
//    var width:CGFloat!
//    var height:CGFloat!
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        tlPrint(message: "&&&&&&&&&&&& init &&&&&&&&&&&&")
//        width = self.frame.width
//        height = self.frame.height
//        //getNoticeInfo()
//        
//        initTitleView()
//        initGameBtnView()
//        initServiceBtn()
//        initScrollView()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    //===========================================
//    //Mark:- initialize scroll view for advertisement
//    //===========================================
//    func initScrollView() -> Void {
//        tlPrint(message: "initScrollView")
//        
//        let scrollFrame = CGRect(x: 0, y: 0, width: width, height: height * model.scrollHeight)
//        
//        let imagesURLStrings = [
//            "http://m2.toobet.co/Content/Images/home-banner1.png",
//            "http://m2.toobet.co/Content/Images/home-banner2.png",
//            "http://m2.toobet.co/Content/Images/home-banner3.png",
//            "http://m2.toobet.co/Content/Images/home-banner4.png"]
//        
//        cycleScroll = SDCycleScrollView(frame: scrollFrame , delegate: self, placeholderImage: UIImage(named:"auto-image.png"))
//        //cycleScroll?.backgroundColor = UIColor.yellow
//        cycleScroll?.autoScrollTimeInterval = 4
//        cycleScroll?.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
//        cycleScroll?.currentPageDotColor = UIColor.white // define the color of page controller.
//        self.insertSubview(cycleScroll, at: 0)
//        
//        DispatchQueue.main.async {
//            self.cycleScroll?.imageURLStringsGroup = imagesURLStrings;
//        }
//    }
//    
//    func initServiceBtn() -> Void {
//        
//        let serviceBtn = baseVC.buttonCreat(frame: CGRect(x:0,y:0,width:0,height:0), title: "", alignment: .center, target: self, myaction: #selector(serviceBtnAct), normalImage: UIImage(named:"home_service.png"), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
//        self.insertSubview(serviceBtn, at: 1)
//        serviceBtn.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(25)
//            _ = make?.right.equalTo()(-15)
//            _ = make?.width.equalTo()(25)
//            _ = make?.height.equalTo()(25)
//        }
//    }
//    
//    func serviceBtnAct() -> Void {
//        tlPrint(message: "serviceBtnAct")
//    }
//    
//    
//    //===========================================
//    //Mark:- initialize the notice info view
//    //===========================================
//    func initNoticeView(notice: Array<String>) -> Void {
//        
//        
//        
//        //init notice picture background view
//        let noticeFrame = CGRect(x: 0, y: height * model.scrollHeight, width: width, height: model.noticeHeight * height)
//        let noticeView = baseVC.viewCreat(frame: noticeFrame, backgroundColor: model.noticeBackColor)
//        self.addSubview(noticeView)
//        
//        //init notice image
//        let yellowLabel = UILabel()
//        noticeView.addSubview(yellowLabel)
//        yellowLabel.mas_makeConstraints { (make) in
//            _ = make?.left.equalTo()(15)
//            _ = make?.centerY.equalTo()(noticeView.mas_centerY)
//            _ = make?.width.equalTo()(3)
//            _ = make?.height.equalTo()(12)
//        }
//        yellowLabel.backgroundColor = model.yellowLabelColor
//        //initialize advertise scroll view
//        let noticeScrollFrame = CGRect(x: model.noticeHeight * width, y: 0, width: width - model.noticeHeight * height, height: model.noticeHeight * height)
//        notiseScroll = SDCycleScrollView(frame: noticeScrollFrame, delegate: self, placeholderImage: nil)
//        noticeView.addSubview(notiseScroll!)
//        notiseScroll?.scrollDirection = UICollectionViewScrollDirection.vertical
//        notiseScroll?.onlyDisplayText = true
//        notiseScroll?.titleLabelBackgroundColor = UIColor.clear
//        notiseScroll.titleLabelTextColor = model.noticeTextColer
//        notiseScroll.titleLabelTextFont = UIFont.systemFont(ofSize: model.noticeTextFont)
//        notiseScroll?.autoScrollTimeInterval = self.model.noticeTimeInterval
//        
//        self.notiseScroll.titlesGroup = notice
//        //self.notiseScroll.titlesGroup = ["我来自中华人民共和国我来自中华人民共和国我来自中华人民共和国我来自中华人民共和国我来自中华人民共和国我来自中华人民共和国我来自中华人民共和国我来自中华人民共和国","鸿福娱乐2"]
//    }
//    
//    
//    
//    //===========================================
//    //Mark:- initialize the title view
//    //===========================================
//    func initTitleView() -> Void {
//        tlPrint(message: "initTitleView")
//        let initFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
//        //initialize title view
//        let titleY = (model.scrollHeight + model.noticeHeight) * height
//        let titleFrame = CGRect(x: 0, y: titleY, width: width, height: height * model.titleViewHeight)
//        let titleView = baseVC.viewCreat(frame: titleFrame, backgroundColor: model.titleViewBackColor)
//        self.addSubview(titleView)
//        
//        //initialize share button
//        let btnDistX = (1 - model.titleBtnWidth1 * 2 - model.titleBtnWidth2) * width / 4
//        let btnDistY = (model.titleViewHeight - model.titleBtnHeight) * height / 2
//        titleBtn1 = baseVC.buttonCreat(frame: initFrame, title: "", alignment: .center, target: self, myaction: #selector(titleBtnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .white, fonsize: 12, events: .touchUpInside)
//        titleView.addSubview(titleBtn1)
//        titleBtn1.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(btnDistX)
//            _ = make?.left.equalTo()(btnDistY)
//            _ = make?.width.equalTo()(self.model.titleBtnWidth1 * self.width)
//            _ = make?.height.equalTo()(self.model.titleBtnHeight * self.height)
//        }
//        titleBtn1.layer.cornerRadius = model.titleBtnCorner
//        titleBtn1.tag = 10
//        
//        //init share image
//        imgView1 = UIButton()
//        imgView1.tag = 10
//        imgView1.addTarget(self, action: #selector(titleBtnAct(sender:)), for: .touchUpInside)
//        titleBtn1.addSubview(imgView1)
//        imgView1.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(13)
//            _ = make?.centerX.equalTo()(self.titleBtn1.mas_centerX)
//            _ = make?.width.equalTo()(self.width * self.model.titleImageWidth)
//            _ = make?.height.equalTo()(self.width * self.model.titleImageWidth)
//        }
//        //diamond
//        titleBtnImg1 = UIImageView()
//        imgView1.addSubview(titleBtnImg1)
//        titleBtnImg1.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(self.width * self.model.titleImageWidth * 0.3)
//            _ = make?.centerX.equalTo()(self.titleBtn1.mas_centerX)
//            _ = make?.width.equalTo()(self.width * self.model.titleImageWidth * 0.7)
//            _ = make?.height.equalTo()(self.width * self.model.titleImageWidth * 0.7)
//        }
//        titleBtnImg1.image = UIImage(named: "home_title_diamond.png")
//        //star
//        titleBtnImg1_start = UIImageView()
//        imgView1.addSubview(titleBtnImg1_start)
//        titleBtnImg1_start.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(self.width * self.model.titleImageWidth * 0.1)
//            _ = make?.left.equalTo()(self.width * self.model.titleImageWidth * 0.05)
//            _ = make?.width.equalTo()(self.width * self.model.titleImageWidth * 0.35)
//            _ = make?.height.equalTo()(self.width * self.model.titleImageWidth * 0.35)
//        }
//        titleBtnImg1_start.image = UIImage(named: "home_title_start.png")
//        //init share button name
//        let titleBtnLabel1 = UIImageView()
//        titleBtn1.addSubview(titleBtnLabel1)
//        titleBtnLabel1.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(self.imgView1.mas_bottom)?.setOffset(10)
//            _ = make?.centerX.equalTo()(self.imgView1.mas_centerX)
//            _ = make?.width.equalTo()(self.width * self.model.titleImageWidth * 0.8)
//            _ = make?.height.equalTo()(self.width * self.model.titleImageWidth * 0.2)
//        }
//        titleBtnLabel1.image = UIImage(named: "home_title_diamondText.png")
//        
//        
//        
//        
//        
//        //initialize account button
//        titleBtn2 = baseVC.buttonCreat(frame: initFrame, title: "", alignment: .center, target: self, myaction: #selector(titleBtnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .white, fonsize: 12, events: .touchUpInside)
//        titleView.addSubview(titleBtn2)
//        titleBtn2.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(btnDistX)
//            _ = make?.left.equalTo()(self.titleBtn1.mas_right)?.setOffset(btnDistY)
//            _ = make?.width.equalTo()(self.model.titleBtnWidth2 * self.width)
//            _ = make?.height.equalTo()(self.model.titleBtnHeight * self.height)
//        }
//        titleBtn2.layer.cornerRadius = model.titleBtnCorner
//        titleBtn2.tag = 11
//        
//        titleBtnImg2 = UIImageView()
//        titleBtn2.addSubview(titleBtnImg2)
//        titleBtnImg2.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(13)
//            _ = make?.centerX.equalTo()(self.titleBtn2.mas_centerX)
//            _ = make?.width.equalTo()(self.width * self.model.titleImageWidth)
//            _ = make?.height.equalTo()(self.width * self.model.titleImageWidth)
//        }
//        titleBtnImg2.image = UIImage(named: "home_title_dollar.png")
//        //init account button name
//        let titleBtnLabel2 = UIImageView()
//        titleBtn2.addSubview(titleBtnLabel2)
//        titleBtnLabel2.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(self.titleBtnImg2.mas_bottom)?.setOffset(10)
//            _ = make?.centerX.equalTo()(self.titleBtnImg2.mas_centerX)
//            _ = make?.width.equalTo()(self.width * self.model.titleImageWidth * 0.8)
//            _ = make?.height.equalTo()(self.width * self.model.titleImageWidth * 0.2)
//        }
//        titleBtnLabel2.image = UIImage(named: "home_title_dollarText.png")
//        
//        //init the label of amount.
//        amountLabel = baseVC.labelCreat(frame: initFrame, text: "¥6786.69", aligment: .center, textColor: model.amountTextColor, backgroundcolor: .clear, fonsize: model.amountTextFont)
//        titleBtn2.addSubview(amountLabel)
//        amountLabel.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(titleBtnLabel2.mas_bottom)?.setOffset(8)
//            _ = make?.centerX.equalTo()(titleBtnLabel2.mas_centerX)
//            _ = make?.width.equalTo()(self.titleBtn1.mas_width)
//            _ = make?.height.equalTo()(self.width * self.model.titleImageWidth * 0.3)
//        }
//        
//        //initialize egg button
//        titleBtn3 = baseVC.buttonCreat(frame: initFrame, title: "", alignment: .center, target: self, myaction: #selector(titleBtnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .white, fonsize: 12, events: .touchUpInside)
//        titleView.addSubview(titleBtn3)
//        titleBtn3.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(btnDistX)
//            _ = make?.left.equalTo()(self.titleBtn2.mas_right)?.setOffset(btnDistY)
//            _ = make?.width.equalTo()(self.model.titleBtnWidth1 * self.width)
//            _ = make?.height.equalTo()(self.model.titleBtnHeight * self.height)
//        }
//        titleBtn3.layer.cornerRadius = model.titleBtnCorner
//        titleBtn3.tag = 12
//        
//        //button image view
//        imgView3 = UIButton()
//        imgView3.tag = 12
//        imgView3.addTarget(self, action: #selector(titleBtnAct(sender:)), for: .touchUpInside)
//        titleBtn3.addSubview(imgView3)
//        imgView3.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(13)
//            _ = make?.centerX.equalTo()(self.titleBtn3.mas_centerX)
//            _ = make?.width.equalTo()(self.width * self.model.titleImageWidth)
//            _ = make?.height.equalTo()(self.width * self.model.titleImageWidth)
//        }
//        //egg
//        titleBtnImg3 = UIImageView()
//        imgView3.addSubview(titleBtnImg3)
//        titleBtnImg3.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(self.width * self.model.titleImageWidth * 0.3)
//            _ = make?.centerX.equalTo()(self.titleBtn3.mas_centerX)
//            _ = make?.width.equalTo()(self.width * self.model.titleImageWidth * 0.7)
//            _ = make?.height.equalTo()(self.width * self.model.titleImageWidth * 0.7)
//        }
//        titleBtnImg3.image = UIImage(named: "home_title_egg.png")
//        
//        
//        //hammer
//        titleBtnImg3_hammer = UIImageView()
//        //titleBtnImg3_hammer.backgroundColor = UIColor.gray
//        imgView3.addSubview(titleBtnImg3_hammer)
//        titleBtnImg3_hammer.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(self.width * self.model.titleImageWidth * 0.1)
//            _ = make?.right.equalTo()
//            _ = make?.width.equalTo()(self.width * self.model.titleImageWidth * 0.4)
//            _ = make?.height.equalTo()(self.width * self.model.titleImageWidth * 0.4)
//        }
//        titleBtnImg3_hammer.image = UIImage(named: "home_title_hammer.png")
//        
//        
//        //init egg button name
//        let titleBtnLabel3 = UIImageView()
//        titleBtn3.addSubview(titleBtnLabel3)
//        titleBtnLabel3.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(self.imgView3.mas_bottom)?.setOffset(10)
//            _ = make?.centerX.equalTo()(self.titleBtnImg3.mas_centerX)
//            _ = make?.width.equalTo()(self.width * self.model.titleImageWidth * 0.8)
//            _ = make?.height.equalTo()(self.width * self.model.titleImageWidth * 0.2)
//        }
//        titleBtnLabel3.image = UIImage(named: "home_title_eggText.png")
//        
//    }
//    
//    
//    //===========================================
//    //Mark:- initialize the game button view
//    //===========================================
//    func initGameBtnView() -> Void {
//        //initialize view of game button
//        tlPrint(message: "initGameBtnView")
//        let gameViewY = (model.scrollHeight + model.noticeHeight + model.titleViewHeight) * height
//        let gameViewHeight = (1 - model.scrollHeight - model.noticeHeight - model.titleViewHeight) * height - 49
//        let viewFrame = CGRect(x: 0, y: gameViewY, width: width, height: gameViewHeight)
//        let gameView = baseVC.viewCreat(frame: viewFrame, backgroundColor: model.gameBackColor)
//        self.addSubview(gameView)
//        
//        
//        //init yellow image
//        let yellowLabel = UILabel()
//        gameView.addSubview(yellowLabel)
//        yellowLabel.mas_makeConstraints { (make) in
//            _ = make?.left.equalTo()(15)
//            _ = make?.top.equalTo()((self.model.gameTitleHeight * self.height - CGFloat(12)) / 2)
//            _ = make?.width.equalTo()(3)
//            _ = make?.height.equalTo()(12)
//        }
//        yellowLabel.backgroundColor = model.yellowLabelColor
//        
//        
//        let hotFrame = CGRect(x: 0, y: 0, width: width, height: model.gameTitleHeight * height)
//        let hotGameLabel = baseVC.labelCreat(frame: hotFrame, text: "       热门游戏", aligment: .left, textColor: model.gameTitleColor, backgroundcolor: .white, fonsize: model.gameTitleFont)
//        gameView.insertSubview(hotGameLabel, at: 0)
//        
//        //initialize game button
//        for i in 0 ... 7 {
//            let btnWidth = (width - 3 * model.gameLineWidht) / 4
//            let btnX = btnWidth * CGFloat(i % 4) + CGFloat(i % 4) * model.gameLineWidht
//            let btnHeight = (gameViewHeight - model.gameTitleHeight * height - 3 * model.gameLineWidht) / 2
//            let btnY = btnHeight * CGFloat(i / 4) + model.gameTitleHeight * height + CGFloat(i / 4 + 1) * model.gameLineWidht
//            
//            let gameBtnFrame = CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight)
//            let gameBtn = baseVC.buttonCreat(frame: gameBtnFrame, title: "", alignment: .center, target: self, myaction: #selector(gameBtnAction(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .white, fonsize: model.gameTitleFont, events: .touchUpInside)
//            //image
//            let gameBtnImg = UIImageView(image: UIImage(named: model.gameImg[i]), highlightedImage: nil)
//            gameBtn.addSubview(gameBtnImg)
//            gameBtnImg.mas_makeConstraints({ (make) in
//                //make?.top.equalTo()(gameBtn.mas_top)?.setOffset(15)
//                make?.top.equalTo()(gameBtn.mas_top)?.setOffset(btnHeight * 0.134)
//                _ = make?.centerX.equalTo()(gameBtn.mas_centerX)
//                _ = make?.width.equalTo()(self.width * self.model.gameBtnImgWidth)
//                _ = make?.height.equalTo()(self.width * self.model.gameBtnImgWidth)
//            })
//            //label
//            let gameNameLabel = UILabel()
//            gameBtn.addSubview(gameNameLabel)
//            gameNameLabel.mas_makeConstraints({ (make) in
//                _ = make?.left.equalTo()
//                _ = make?.right.equalTo()
//                _ = make?.top.equalTo()(gameBtnImg.mas_bottom)
//                _ = make?.bottom.equalTo()
//            })
//            gameNameLabel.text = model.gameName[i]
//            gameNameLabel.textAlignment = .center
//            //判断字体大小
//            let font = width == 375 ? model.gameNameFont : (width < 375 ? model.gameNameFont - 1 : model.gameNameFont + 1)
//            gameNameLabel.font = UIFont(name: "Hiragino Sans", size: font )
//            
//            gameNameLabel.textColor = model.gameNameColor
//            
//            gameBtn.tag = 20 + i
//            gameView.addSubview(gameBtn)
//        }
//    }
//    
//    
//    //=======================================================
//    //Mark:- actions after press the title button down and up
//    //=======================================================
//    func titleBtnAct(sender:UIButton) -> Void {
//        tlPrint(message: "titleBtnAct")
//        self.isUserInteractionEnabled = false
//        sender.backgroundColor = model.titleBtnBackColor1
//        switch sender.tag {
//        case 10:
//            tlPrint(message: "分享")
//            shareBtnAct(img1: titleBtnImg1, img2: titleBtnImg1_start)
//        case 11:
//            tlPrint(message: "中心钱包")
//            walletBtnAct(img: titleBtnImg2)
//        case 12:
//            tlPrint(message: "砸金蛋")
//            eggBtnAct(img: titleBtnImg3)
//        default:
//            tlPrint(message: "no such case")
//        }
//    }
//    
//    
//    //分享按钮动画
//    func shareBtnAct(img1: UIImageView,img2:UIImageView) -> Void {
//        
//        let starRate:CGFloat = 1.5
//        let diamondRate:CGFloat = 0.8
//        //钻石和星星动画
//        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
//            img1.layer.setAffineTransform(CGAffineTransform.init(scaleX: diamondRate, y: diamondRate))
//            img2.layer.setAffineTransform(CGAffineTransform.init(scaleX: starRate, y: starRate))
//        }) { (finished) in
//            UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
//                img1.layer.setAffineTransform(CGAffineTransform.identity)
//            }, completion: { (finished) in
//                img2.layer.setAffineTransform(CGAffineTransform.identity)
//            })
//        }
//        //页面延时跳转
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.4)) {
//            let gameLobbyVC = GameLobbyViewController()
//            //self.navigationController?.pushViewController(gameLobbyVC, animated: true)
//            self.homeDelegate.pushToViewConntroller(destination: gameLobbyVC)
//            self.isUserInteractionEnabled = true
//        }
//    }
//    //中心钱包动画
//    func walletBtnAct(img: UIImageView) -> Void {
//        
//        UIView.beginAnimations("walletAnimation", context: nil)
//        UIView.setAnimationDuration(0.5)
//        UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
//        UIView.setAnimationTransition(.flipFromLeft, for: img, cache: false)
//        UIView.commitAnimations()
//        //页面延时跳转
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.4)) {
//            let gameLobbyVC = GameLobbyViewController()
//            //self.navigationController?.pushViewController(gameLobbyVC, animated: true)
//            self.homeDelegate.pushToViewConntroller(destination: gameLobbyVC)
//            self.isUserInteractionEnabled = true
//        }
//    }
//    //砸金蛋动画
//    func eggBtnAct(img: UIImageView) -> Void {
//        
//        //设置锤子动画效果，动画时间长度 0.4 秒。
//        UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
//            //在动画中，锤子有一个角度的旋转。
//            self.titleBtnImg3_hammer.layer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(M_PI) * 0.3))
//        }) { (finished) in
//            
//            UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: {
//                //完成动画时，锤子复原
//                self.titleBtnImg3_hammer.layer.setAffineTransform(.identity)
//            }, completion: { (finished) in
//                //设置金蛋抖动效果
//                self.shakeAnimation(view: self.titleBtnImg3)
//            })
//        }
//        //页面延时跳转
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.4)) {
//            let gameLobbyVC = GameLobbyViewController()
//            //self.navigationController?.pushViewController(gameLobbyVC, animated: true)
//            self.homeDelegate.pushToViewConntroller(destination: gameLobbyVC)
//            self.isUserInteractionEnabled = true
//        }
//    }
//    //抖动动画
//    func shakeAnimation(view:UIView) -> Void {
//        
//        let shake = CABasicAnimation(keyPath: "transform.rotation.z")
//        shake.fromValue = NSNumber(value: -0.5)
//        shake.toValue = NSNumber(value: 0.5)
//        shake.duration = 0.05
//        shake.autoreverses = true//是否重复
//        shake.repeatCount = 8
//        view.layer.animation(forKey: "eggShake")
//        view.layer.add(shake, forKey: nil)
//        
//    }
//    
//    
//    //===========================================
//    //Mark:- game button actions
//    //===========================================
//    func gameBtnAction(sender: UIButton) -> Void {
//        tlPrint(message: "gameBtnAction")
//        let gameNameArray = ["鸿福体育","3D老虎机","AV老虎机","BBIN老虎机","GD娱乐城","太阳城","BBIN娱乐城","PT老虎机"]
//        let gameLobby = GameLobbyViewController()
//        gameLobby.gameName = gameNameArray[sender.tag - 20]
//        tlPrint(message: gameNameArray[sender.tag - 20])
//        //self.navigationController?.pushViewController(gameLobby, animated: true)
//        self.homeDelegate.pushToViewConntroller(destination: gameLobby)
//    }
//
//    
//
//
//}
