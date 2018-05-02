//
//  TransferView.swift
//  FuTu
//
//  Created by Administrator1 on 8/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit



class TransferView: UIView {

    
    var delegate: TransferDelegates?
    
    var backgroundView: UIView!
    var topBackImg: UIImageView!
    var scroll: UIScrollView!
    var serviceBtn,detailBtn,changeBtn: UIButton!
    var textLabel,balanceLabel: UILabel!
    var width,height: CGFloat!
    let model = TransferModel()
    var isFromTabView:Bool!
    let initFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    let baseVC = BaseViewController()
    var refreshIndicator:RefreshIndicator!
    
    
    init(frame:CGRect, param:AnyObject) {
        super.init(frame: frame)
        self.width = frame.width
        self.height = frame.height
        self.isFromTabView = param as! Bool
        
        //滑动3D视图
        initScrollView()
        //背景视图
        initBackImgView()
        //切换按钮
        initChangeBtn()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    func initBackImgView() -> Void {
        
        backgroundView = UIView(frame: frame)
        self.insertSubview(backgroundView, at: 0)
        //头部背景
        let imgFrame = CGRect(x: 0, y: 0, width: width, height: adapt_H(height: isPhone ? 200 : 140))
        topBackImg = UIImageView(frame: imgFrame)
        topBackImg.image = UIImage(named: "transfer_title_bg.png")
        backgroundView.insertSubview(topBackImg, at: 0)
        backgroundView.backgroundColor = UIColor.colorWithCustom(r: 187, g: 187, b: 187)
        //下部渐变背景
//        let gradientLayer = CAGradientLayer.GradientLayer(topColor: model.backgroundTopColor, buttomColor: model.backgroundBottomColor)
//        gradientLayer.frame = CGRect(x: 0, y: imgFrame.height, width: width, height: height - imgFrame.height)
//        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        //判断入口决定是否添加返回按钮
        if !self.isFromTabView {
            let backFrame = CGRect(x: adapt_W(width: isPhone ? 12 : 18), y: adapt_H(height: isPhone ? 25 : 15), width: adapt_W(width: isPhone ? 35 : 25), height: adapt_W(width: isPhone ? 35 : 25))
            let backBtn = baseVC.buttonCreat(frame: backFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"service_back.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
            
            self.insertSubview(backBtn, at: 3)
            backBtn.tag = TransferTag.backBtnTag.rawValue
        }
    }
    
    func initScrollView() -> Void {
        
        let gameViewHeight:CGFloat = adapt_H(height: (isPhone ? 112 : 80))
        scroll = UIScrollView(frame: frame)
        self.addSubview(scroll)
        let scrollContentHeight:CGFloat = adapt_H(height:(isPhone ? (self.model.gameViewTop + tabBarHeight + 100) : (120 + tabBarHeight + 50))) + 6 * gameViewHeight * 0.6
        tlPrint(message: "*** scrollContentHeight:  \(scrollContentHeight)")
        scroll.contentSize = CGSize(width: frame.width, height: scrollContentHeight)
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        
        initBalanceLabel()  //余额标签
        //initServiceBtn()    //客服按钮
        initDetailBtn()     //交易明细按钮
        //初始化游戏标签视图
        for i in 0 ..< model.imgName.count {
            
            let gameView = UIView(frame: CGRect(x: adapt_W(width: model.gameViewLeft), y: adapt_H(height: isPhone ? self.model.gameViewTop : 105) + gameViewHeight * CGFloat(i) * 0.6, width: width - adapt_W(width: model.gameViewLeft * 2), height: gameViewHeight))
            //背景视图
            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: gameView.frame.width, height: gameView.frame.height))
            imgView.image = UIImage(named: model.imgName[i])
            gameView.insertSubview(imgView, at: 0)
            
            var transform = CATransform3DIdentity
            transform.m34 = -1.0 / 400.0   //透视投影
            transform = CATransform3DRotate(transform, CGFloat(Double.pi * 0.08), -1, 0, 0)//旋转
            gameView.layer.transform = transform

            gameView.tag = TransferTag.gameViewTag.rawValue + i
            scroll.addSubview(gameView)
            
            //余额
            var balanceValue = "¥0.00"
//            let game = (i == 0 ? "platformGame_SB" : globleGameUserDefaults[i - 1])
            let game = selfGameUserDefaults[i]
            if let balanceValue_t = userDefaults.value(forKey: game){
                balanceValue = "¥\(balanceValue_t as! String)"
            }
            
            let balanceValueSize = balanceValue.size(withAttributes: [NSAttributedStringKey.font :  UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 20 : 16))])
            let bNumWidth = balanceValueSize.width + adapt_W(width: 5)

            let balanceNumber = UILabel()
            imgView.addSubview(balanceNumber)
            balanceNumber.mas_makeConstraints({ (make) in
                _ = make?.top.equalTo()(adapt_H(height: isPhone ? 20 : 18))
                _ = make?.right.equalTo()
                _ = make?.width.equalTo()(bNumWidth)
                _ = make?.height.equalTo()( balanceValueSize.height)
            })
            
            balanceNumber.tag = TransferTag.platformBalanceLabel.rawValue + i
            setLabelProperty(label: balanceNumber, text: balanceValue as String, aligenment: .left, textColor: .white, backColor: .clear, font: fontAdapt(font: isPhone ? 20 : 16))
            
            //余额标签
            let balanceTextWord = "余额:" as NSString
            let balanceTextWordSize = balanceTextWord.size(withAttributes: [NSAttributedStringKey.font :  UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 13 : 10))])
            let balanceText = UILabel()
//            gameView.insertSubview(balanceText, aboveSubview: imgView)
            imgView.addSubview(balanceText)
            balanceText.mas_makeConstraints({ (make) in
                _ = make?.top.equalTo()(adapt_H(height: isPhone ? 20 : 18) + 0.4 * balanceTextWordSize.height)
                _ = make?.right.equalTo()(balanceNumber.mas_left)
                _ = make?.width.equalTo()(adapt_W(width: isPhone ? 50 : 40))
                _ = make?.height.equalTo()(balanceTextWordSize.height)
            })
            setLabelProperty(label: balanceText, text: balanceTextWord as String, aligenment: .right, textColor: .white, backColor: .clear, font: fontAdapt(font: model.balanceTextFont))

            
            //按钮
            //转入转出按钮
            let rechargeFrame = CGRect(x: adapt_W(width: 82), y: adapt_H(height: isPhone ? 74 : 50), width: adapt_W(width: 130), height: adapt_H(height: isPhone ? 32 : 20))
            let rechargeBtn = baseVC.buttonCreat(frame: rechargeFrame, title: "转  入", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 14 : 10), events: .touchUpInside)
            gameView.insertSubview(rechargeBtn, aboveSubview: imgView)
            rechargeBtn.setTitleColor(model.rechargeBtnColor, for: .normal)
            rechargeBtn.layer.borderColor = model.rechargeBtnColor.cgColor
            rechargeBtn.layer.borderWidth = adapt_W(width: 0.5)
            rechargeBtn.tag = TransferTag.transIn.rawValue + i
            
            let withdrawFrame = CGRect(x: adapt_W(width: 222), y: adapt_H(height: isPhone ? 74 : 50), width:adapt_W(width: 130), height: adapt_H(height: isPhone ? 32 : 20))
            let withdrawBtn = baseVC.buttonCreat(frame: withdrawFrame, title: "转  出", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 14 : 10), events: .touchUpInside)
            gameView.insertSubview(withdrawBtn, aboveSubview: imgView)
            withdrawBtn.setTitleColor(model.withdrawBtnColor, for: .normal)
            withdrawBtn.layer.borderColor = model.withdrawBtnColor.cgColor
            withdrawBtn.layer.borderWidth = adapt_W(width: 0.5)
            withdrawBtn.tag = TransferTag.transOut.rawValue + i
       
            rechargeBtn.layer.cornerRadius = adapt_H(height: isPhone ? 16 : 10)
            withdrawBtn.layer.cornerRadius =  adapt_H(height: isPhone ? 16 : 10)

            
        

            //添加点击事件
            let gesture = UITapGestureRecognizer(target: self, action: #selector(gameTouchAct(sender:)))
            gesture.numberOfTapsRequired = 1
            gameView.isUserInteractionEnabled = true
            gameView.addGestureRecognizer(gesture)
        }
    }
    var changeViewStatus:Int = 1
    //点击了切换按钮以后的视图
    func initChangedScrollView() -> Void {
        changeViewStatus = 2
        isChanged = true
        let gameViewHeight:CGFloat = adapt_H(height: (isPhone ? 112 : 80))
        let scrollContentHeight:CGFloat = adapt_H(height:(isPhone ? (self.model.gameViewTop + tabBarHeight) : (120 + tabBarHeight)) + 30) + 6 * gameViewHeight
        scroll.contentSize = CGSize(width: frame.width, height: scrollContentHeight)

        for i in 0 ... 7 {
            
            let gameView = scroll.viewWithTag(TransferTag.gameViewTag.rawValue + i)
            UIView.animate(withDuration: 0.5, animations: {
                gameView?.frame = CGRect(x: adapt_W(width: self.model.gameViewLeft), y: adapt_H(height: isPhone ? self.model.gameViewTop : 105) + CGFloat(i) * (gameViewHeight + self.model.gameViewInterval), width: self.width - adapt_W(width: self.model.gameViewLeft * 2), height: gameViewHeight)
                
                let transform = CATransform3DIdentity
                gameView?.layer.transform = transform
            })
        }
        changeBtn.setImage(UIImage(named:"transfer_menu01.png"), for: .normal)
        //scroll.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
    
    //未点击或者点击了两次切换按钮以后的视图
    func initUnchangedScrollView() -> Void {
        changeViewStatus = 1
        isChanged = false
        let gameViewHeight:CGFloat = adapt_H(height: (isPhone ? 112 : 80))
        let scrollContentHeight:CGFloat = adapt_H(height:(isPhone ? (self.model.gameViewTop + tabBarHeight + 100) : (120 + tabBarHeight + 50))) + 6 * gameViewHeight * 0.6
        scroll.contentSize = CGSize(width: frame.width, height: scrollContentHeight)
        for i in 0 ... 7 {
            
            let gameView = scroll.viewWithTag(TransferTag.gameViewTag.rawValue + i)
            UIView.animate(withDuration: 0.5, animations: {

                gameView?.frame = CGRect(x: adapt_W(width: self.model.gameViewLeft), y: adapt_H(height: isPhone ? self.model.gameViewTop : 105) + gameViewHeight * CGFloat(i) * 0.6, width: self.width - adapt_W(width: self.model.gameViewLeft * 2), height: gameViewHeight)
                
                
                var transform = CATransform3DIdentity
                transform.m34 = -1.0 / 400.0   //透视投影
                transform = CATransform3DRotate(transform, CGFloat(Double.pi * 0.08), -1, 0, 0)//旋转
                gameView?.layer.transform = transform
            })
        }
        changeBtn.setImage(UIImage(named:"transfer_menu02.png"), for: .normal)
        //scroll.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }

    
    
    //初始化中心钱包余额
    func initBalanceLabel() -> Void {
        //中心钱包余额文字部分
        let textFrame = CGRect(x: adapt_W(width: 29.5), y: adapt_H(height: isPhone ? 40 : 22), width: adapt_W(width: 150), height: adapt_H(height: isPhone ? 15 : 12))
        textLabel = UILabel(frame: textFrame)
        scroll.insertSubview(textLabel, at: 0)
        setLabelProperty(label: textLabel, text: "中心钱包余额（元）", aligenment: .left, textColor: .white, backColor: .clear, font: fontAdapt(font: isPhone ? 14 : 12))
        //余额金额标签
        let balanceFrame = CGRect(x: adapt_W(width: 29.5), y: adapt_H(height: isPhone ? 85 : 55), width: width - adapt_W(width: 29.5), height: adapt_H(height: isPhone ? 33 : 30))
        balanceLabel = UILabel(frame: balanceFrame)
        balanceLabel.tag = TransferTag.balanceLabel.rawValue
        scroll.insertSubview(balanceLabel, at: 0)
        var accountText = "0.00"
        if let accountText_t = userDefaults.value(forKey: userDefaultsKeys.userInfoBalance.rawValue) {
            accountText = "\(accountText_t)"
        }
        setLabelProperty(label: balanceLabel, text: accountText, aligenment: .left, textColor: .white, backColor: .clear, font: fontAdapt(font: isPhone ? 40 : 30))
    }
    //初始化客服按钮
    func initServiceBtn() -> Void {
        //service button
        let serviceFrame = CGRect(x:width - adapt_W(width: isPhone ? 50 : 20), y:adapt_H(height: isPhone ? 25 : 18), width:adapt_W(width: isPhone ? 35 : 20), height:adapt_H(height: isPhone ? 35 : 20))
        serviceBtn = baseVC.buttonCreat(frame: serviceFrame, title:"",alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"home_service.png"), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
        serviceBtn.tag = TransferTag.serviceBtnTag.rawValue
        scroll.addSubview(serviceBtn)
    }
    //初始化交易明细按钮
    func initDetailBtn() -> Void {
        //service button
        let detailFrame = CGRect(x:width - adapt_W(width: isPhone ? (75 + 20) : (70 + 18)), y: adapt_H(height: 98), width:adapt_W(width: isPhone ? 75 : 50), height:adapt_H(height: isPhone ? 25 : 15))
        detailBtn = baseVC.buttonCreat(frame: detailFrame, title:"交易明细",alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 12 : 8), events: .touchUpInside)
        detailBtn.tag = TransferTag.detailBtnTag.rawValue
        detailBtn.setTitleColor(UIColor.white, for: .normal)
        detailBtn.setTitleColor(UIColor.gray, for: .highlighted)
        detailBtn.layer.borderColor = UIColor.white.cgColor
        detailBtn.layer.borderWidth = adapt_W(width: 0.5)
        detailBtn.layer.cornerRadius = detailFrame.height / 2
        detailBtn.center.y = self.balanceLabel.center.y
        scroll.addSubview(detailBtn)
    }
    //初始化切换按钮
    func initChangeBtn() -> Void {
        let changeWidth:CGFloat = isPhone ? (73 / 2) : 25
        let changeFrame = CGRect(x: width - adapt_W(width: 15 + changeWidth), y: height - adapt_H(height: tabBarHeight + 20 + changeWidth), width: adapt_W(width: changeWidth), height: adapt_H(height: changeWidth))
        changeBtn = baseVC.buttonCreat(frame: changeFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"transfer_menu02.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)

        changeBtn.tag = TransferTag.changeBtnTag.rawValue
        self.addSubview(changeBtn)
    }
    //服务，明细，切换按钮事件
    @objc func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct,tag = \(sender.tag)")
        switch sender.tag {
        case TransferTag.serviceBtnTag.rawValue:
            self.delegate?.serviceBtnAct(sender: sender)
        case TransferTag.detailBtnTag.rawValue:
            self.delegate?.detailBtnAct(sender: sender)
        case TransferTag.changeBtnTag.rawValue:
            self.delegate?.changeBtnAct(sender: sender)
        case TransferTag.backBtnTag.rawValue:
            self.delegate?.backBtnAct(sender: sender)
        default:
            if sender.tag >= TransferTag.transIn.rawValue {
                self.delegate?.gameBtnAct(sender: sender)
            } else {
                tlPrint(message: "no such case")
            }
            
        }
    }
    //层叠状态下游戏条点击事件
    @objc func gameTouchAct(sender:UITapGestureRecognizer) -> Void {
        tlPrint(message: "gameTouchAct.tag = \(String(describing: sender.view?.tag))")
        let gameViewHeight:CGFloat = adapt_H(height: (isPhone ? 112 : 80))
        let gameViewInterval: CGFloat = adapt_H(height: isPhone ? 6 : 4)
        if changeViewStatus == 1 {
            initChangedScrollView()
            if sender.view!.tag >= TransferTag.gameViewTag.rawValue + 3 {
                //延时等待展开以后再上滑动
                let offset = CGFloat(sender.view!.tag - TransferTag.gameViewTag.rawValue - 2) * (gameViewHeight + gameViewInterval)
                UIView.animate(withDuration: 0.5, delay: 2, options: .allowUserInteraction, animations: {
                    self.scroll.setContentOffset(CGPoint(x:0,y:offset), animated: true)
                }, completion: { (finished) in
                    
                })
            }
        }
    }
}






























