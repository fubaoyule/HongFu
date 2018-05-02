//
//  SelfView.swift
//  FuTu
//
//  Created by Administrator1 on 17/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit


protocol selfDelegate {
    func buttonAction(btnTag:Int)
}

class SelfView: UIView {

    var delegate: selfDelegate!
    var scroll: UIScrollView!
    var width,height: CGFloat!
    let model = SelfModel()
    let baseVC = BaseViewController()
    var backImg:UIImageView!
    var headBackView,titleView:UIView!
    var scrollDelegate:UIScrollViewDelegate!
    var refreshIndicator:RefreshIndicator!
    
    init(frame:CGRect, param:AnyObject,rootVC:UIViewController) {
        super.init(frame: frame)
        self.width = frame.width
        self.height = frame.height
        self.scrollDelegate = rootVC as! UIScrollViewDelegate
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        initScrollView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func initScrollView() -> Void {
        
        scroll = UIScrollView(frame: frame)
        self.addSubview(scroll)
        scroll.contentSize = CGSize(width: frame.width, height: height + 1)
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = self.scrollDelegate
        self.addSubview(scroll)
        
        initTitleView()
        initGameView()
    }
    
    func initTitleView() -> Void {
        
        //视图
        self.titleView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: adapt_H(height:model.titleViewHeight)))
        self.scroll.addSubview(titleView)
        //background Image
        self.backImg = UIImageView(frame: titleView.frame)
//        self.insertSubview(backImg, at: 0)
        self.scroll.insertSubview(backImg, at: 0)
        backImg.image = UIImage(named: "self_title_bg.png")
        backImg.tag = 40
        
        
        
        
//        //head image
//        let headBackImgWidth = adapt_W(width: isPhone ? 85 : 60)
//        let headBackFrame = CGRect(x: (width - headBackImgWidth) / 2, y: adapt_H(height: isPhone ? 77 : 47), width: headBackImgWidth, height: headBackImgWidth)
//        headBackView = UIView(frame: headBackFrame)
//        titleView.insertSubview(headBackView, aboveSubview: backImg)
//        headBackView.backgroundColor = UIColor.white
//        headBackView.alpha = 0.5
//        headBackView.layer.cornerRadius = headBackImgWidth / 2
//        headBackView.layer.shadowColor = UIColor.colorWithCustom(r: 121, g: 51, b: 0).cgColor
//        headBackView.layer.shadowOffset = CGSize(width: 0, height: adapt_H(height: 6))
//        headBackView.layer.shadowOpacity = 1
//        
//        let headImage = UIImageView()
//        headImage.center = headBackView.center
//        titleView.insertSubview(headImage, aboveSubview: headBackView)
//        headImage.mas_makeConstraints { (make) in
//            _ = make?.centerX.equalTo()(self.headBackView.mas_centerX)
//            _ = make?.centerY.equalTo()(self.headBackView.mas_centerY)
//            _ = make?.height.equalTo()(self.headBackView.mas_height)?.setOffset(adapt_W(width: isPhone ? -5 : -3))
//            _ = make?.width.equalTo()(self.headBackView.mas_width)?.setOffset(adapt_W(width: isPhone ? -5 : -3))
//        }
//        
//        headImage.layer.cornerRadius = headBackImgWidth / 2 - adapt_W(width: isPhone ? 2.5 : 1.5)
//        headImage.clipsToBounds = true
//        headImage.image = UIImage(named:"self_head.png")
//        
//        //class
//        let vipLevel = userDefaults.value(forKey: userDefaultsKeys.userInfoVipLevel.rawValue) as! Int
//        let classView = UIImageView()
//        titleView.insertSubview(classView, aboveSubview: headImage)
////        classView.image = UIImage(named: "self_class_bg.png")
//        classView.image = UIImage(named: "self_class\(vipLevel).png")
//        classView.mas_makeConstraints { (make) in
////            _ = make?.bottom.equalTo()(self.headBackView.mas_bottom)?.setOffset(adapt_H(height: isPhone ? 6 : 4))
//            _ = make?.bottom.equalTo()(self.headBackView.mas_bottom)?.setOffset(adapt_H(height: isPhone ? 15 : 10))
//            _ = make?.width.equalTo()(adapt_W(width: isPhone ? 63 : 45))
////            _ = make?.height.equalTo()(adapt_H(height: isPhone ? 23 : 15))
//            _ = make?.height.equalTo()(adapt_H(height: isPhone ? 40 : 25))
//            _ = make?.centerX.equalTo()(self.headBackView.mas_centerX)
//        }
        
        let headImgHeight = adapt_W(width: isPhone ? 80 : 60)
        let headImgFrame = CGRect(x: (width - headImgHeight) / 2, y: adapt_H(height: isPhone ? 77 : 47), width: headImgHeight, height: headImgHeight)
        let headImgView = UIImageView(frame: headImgFrame)
        titleView.addSubview(headImgView)
        headImgView.image = UIImage(named: "self_headImg.png")
        
        
        //class
        var vipLevel:Int! = 0
        if let vipLevel_t = userDefaults.value(forKey: userDefaultsKeys.userInfoVipLevel.rawValue) {
            vipLevel = vipLevel_t as! Int
        }
        let classImgWidth = adapt_W(width: isPhone ? 80 : 60)
        let classImgFrame = CGRect(x: (width - classImgWidth) / 2, y: adapt_H(height: isPhone ? 135 : 88), width: classImgWidth, height: classImgWidth / 2.5)
        let classView = UIImageView(frame: classImgFrame)
        titleView.insertSubview(classView, aboveSubview: headImgView)
        classView.image = UIImage(named: "self_class\(vipLevel).png")
//        if vipLevel == 0 {
//            classView.image = UIImage(named: "login_logo.png")
//            let logoWidth = adapt_W(width: isPhone ? 80 : 60)
//            classView.frame = CGRect(x: (width - logoWidth) / 2, y: adapt_H(height: isPhone ? 77 : 47), width: logoWidth, height: logoWidth)
//            classView.layer.cornerRadius = adapt_W(width: isPhone ? 20 : 15)
//            classView.clipsToBounds = true
//        }
        
//        classView.mas_makeConstraints { (make) in
//            _ = make?.bottom.equalTo()(self.headBackView.mas_bottom)?.setOffset(adapt_H(height: isPhone ? 15 : 10))
//            _ = make?.width.equalTo()(adapt_W(width: isPhone ? 63 : 45))
//            _ = make?.height.equalTo()(adapt_H(height: isPhone ? 40 : 25))
//            _ = make?.centerX.equalTo()(self.headBackView.mas_centerX)
//        }
        
//        let LVImg = UIImageView()
//        classView.addSubview(LVImg)
//        LVImg.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(classView.mas_top)?.setOffset(adapt_H(height: isPhone ? 4.5 : 3))
//            _ = make?.left.equalTo()(classView.mas_left)?.setOffset(adapt_W(width: isPhone ? 15 : 10))
//            _ = make?.height.equalTo()(adapt_H(height: isPhone ? 12 : 8))
//            _ = make?.width.equalTo()(adapt_W(width: isPhone ? 24 : 16))
//        }
//        let vipLevel = userDefaults.value(forKey: userDefaultsKeys.userInfoVipLevel.rawValue) as! Int
//        LVImg.image = UIImage(named: "self_class_LV.png")
//        let classNum = UIImageView()
//        classView.addSubview(classNum)
//        classNum.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(LVImg.mas_top)
//            _ = make?.left.equalTo()(LVImg.mas_right)
//            _ = make?.height.equalTo()(LVImg.mas_height)
//            _ = make?.width.equalTo()(adapt_W(width: 8))
//        }
//        classNum.image = UIImage(named: "self_class_\(vipLevel).png")
//        
//        if vipLevel > 9 {
//        
//            LVImg.mas_makeConstraints { (make) in
//                _ = make?.top.equalTo()(classView.mas_top)?.setOffset(adapt_H(height: isPhone ? 4.5 : 3))
//                _ = make?.left.equalTo()(classView.mas_left)?.setOffset(adapt_W(width: isPhone ? 11 : 7))
//                _ = make?.height.equalTo()(adapt_H(height: isPhone ? 12 : 8))
//                _ = make?.width.equalTo()(adapt_W(width: isPhone ? 24 : 16))
//            }
//            classNum.image = UIImage(named: "self_class_1.png")
//
//            let classNum2 = UIImageView()
//            classView.addSubview(classNum2)
//            classNum2.mas_makeConstraints { (make) in
//                _ = make?.top.equalTo()(classNum.mas_top)
//                _ = make?.left.equalTo()(classNum.mas_right)
//                _ = make?.height.equalTo()(classNum.mas_height)
//                _ = make?.width.equalTo()(classNum.mas_width)
//            }
//            classNum2.image = UIImage(named: "self_class_\(model.dataSource[2]as! Int % 10).png")
//        }
   
        //nick name label.
        let nickLabel = UILabel()
        titleView.insertSubview(nickLabel, aboveSubview: backImg)
        var nickName:String = ""
        if let nickName_t = userDefaults.value(forKey: userDefaultsKeys.userInfoAccountName.rawValue) {
            nickName = nickName_t as! String
        }

        setLabelProperty(label: nickLabel, text: nickName, aligenment: .center, textColor: .white, backColor: .clear, font: fontAdapt(font: isPhone ? 20 : 11))
        nickLabel.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(self.headBackView.mas_top)?.setOffset(isPhone ? -40 : -40)
//            _ = make?.centerX.equalTo()(self.headBackView.mas_centerX)
            _ = make?.top.equalTo()(headImgView.mas_top)?.setOffset(isPhone ? -40 : -40)
            _ = make?.centerX.equalTo()(headImgView.mas_centerX)
            _ = make?.width.equalTo()(self.width)
            _ = make?.height.equalTo()(adapt_H(height: isPhone ? 28 : 15))
        }
        
        //setting button
        let setBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 0, width: 0, height: 0), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"self_title_setting.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        titleView.insertSubview(setBtn, aboveSubview: backImg)
        setBtn.tag = selfBtnTag.SettingBtn.rawValue
        setBtn.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(adapt_W(width: isPhone ? 25 : 40))
            _ = make?.height.equalTo()(adapt_W(width: isPhone ? 40 : 30))
            _ = make?.width.equalTo()(adapt_W(width: isPhone ? 40 : 30))
//            _ = make?.centerY.equalTo()(self.headBackView.mas_centerY)
            _ = make?.centerY.equalTo()(headImgView.mas_centerY)
        }
        
        
        // message button
        let msgBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 0, width: 0, height: 0), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"self_title_message.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        titleView.insertSubview(msgBtn, aboveSubview: backImg)
        msgBtn.tag = selfBtnTag.MessageBtn.rawValue
        msgBtn.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(setBtn.mas_top)
            _ = make?.height.equalTo()(setBtn.mas_height)
            _ = make?.width.equalTo()(setBtn.mas_width)
            _ = make?.right.equalTo()(adapt_W(width: isPhone ? -25 : -40))
            _ = make?.centerY.equalTo()(setBtn.mas_centerY)
        }
        msgBtn.isHidden = true
        
        //message alert image view
        let alertFrame = CGRect(x: adapt_W(width: isPhone ? -12 : -8), y: adapt_W(width: isPhone ? 10 : 7), width: adapt_W(width: isPhone ? 20 : 15), height: adapt_W(width: isPhone ? 20 : 15))
        let alertImg = UIImageView(frame: alertFrame)
        msgBtn.addSubview(alertImg)
        alertImg.image = UIImage(named: "self_title_remind.png")
        alertImg.tag = selfBtnTag.AlertImg.rawValue
        alertImg.isHidden = true
        //message alert label
        let alertLabel = UILabel(frame: alertFrame)
        msgBtn.addSubview(alertLabel)
        setLabelProperty(label: alertLabel, text: "\(model.dataSource[3])", aligenment: .center, textColor: .white, backColor: .clear, font: fontAdapt(font: isPhone ? 13 : 9))
        alertLabel.tag = selfBtnTag.AlertLabel.rawValue
        alertLabel.isHidden = true
        
        //wallent view
        let wallentViewHeight = adapt_H(height: isPhone ? 70 : 44)
        let wallentView = UIView(frame: CGRect(x: 0, y: titleView.frame.height - wallentViewHeight, width: width, height: wallentViewHeight))
        titleView.insertSubview(wallentView, aboveSubview: backImg)
        wallentView.backgroundColor = UIColor.black
        wallentView.alpha = 0.1
        
        //wallent word label
        let wallentWord = UILabel(frame: CGRect(x: adapt_W(width: isPhone ? 19 : 44), y: adapt_H(height: model.titleViewHeight - (isPhone ? 40 : 30)), width: adapt_W(width: isPhone ? 80 : 60), height: adapt_H(height: 15)))
        self.titleView.insertSubview(wallentWord, aboveSubview: wallentView)
        setLabelProperty(label: wallentWord, text: "中心钱包", aligenment: .center, textColor: .white, backColor: .clear, font: fontAdapt(font: isPhone ? 16 : 10 ))
        //account
//        let wallentValue = UILabel(frame: CGRect(x: adapt_W(width: 100), y: adapt_H(height: isPhone ? 227: 150 ), width: width - adapt_W(width: 200), height: adapt_H(height: 20)))
        let wallentValue = UILabel(frame: CGRect(x: adapt_W(width: 100), y: wallentWord.frame.origin.y, width: width - adapt_W(width: 200), height: adapt_H(height: 20)))
        
        var amountText = "¥0.00"
        if let amount = userDefaults.value(forKey: userDefaultsKeys.userInfoBalance.rawValue) {
            amountText = "¥\(amount)"
        }
        titleView.insertSubview(wallentValue, aboveSubview: wallentView)
        setLabelProperty(label: wallentValue, text: amountText, aligenment: .center, textColor: .white, backColor: .clear, font: fontAdapt(font: isPhone ? 25 : 17))
        wallentValue.layer.shadowColor = UIColor.black.cgColor
        wallentValue.layer.shadowOffset = CGSize(width: 2, height: 3)
        wallentValue.layer.shadowOpacity = 0.3
        wallentValue.tag = selfBtnTag.TotleAccountLabel.rawValue
        wallentValue.isUserInteractionEnabled = true
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGuesAct))
        wallentValue.addGestureRecognizer(tapGuesture)
        
        
        //bank button
        let bankFrame = CGRect(x: width - adapt_W(width: isPhone ? 100 : 110), y: wallentWord.frame.origin.y, width: adapt_W(width: isPhone ? 78 : 63), height: adapt_H(height: isPhone ? 25 : 20))
        let bankBtn = baseVC.buttonCreat(frame: bankFrame, title: "绑定银行卡", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 12 : 9), events: .touchUpInside)
        self.titleView.insertSubview(bankBtn, aboveSubview: wallentView)
        bankBtn.tag = selfBtnTag.BankBtn.rawValue
        bankBtn.setTitleColor(UIColor.white, for: .normal)
        bankBtn.setTitleColor(UIColor.gray, for: .highlighted)
        bankBtn.layer.borderColor = UIColor.white.cgColor
        bankBtn.layer.borderWidth = adapt_W(width: 0.5)
        bankBtn.layer.cornerRadius = adapt_H(height: isPhone ? 25 : 20) / 2
        
//        wallentWord.mas_makeConstraints { (make) in
//            _ = make?.centerY.equalTo()(wallentValue.mas_centerY)
//            _ = make?.left.equalTo()(adapt_W(width: 19))
//        }
//        bankBtn.mas_makeConstraints { (make) in
//            _ = make?.centerY.equalTo()(wallentValue.mas_centerY)
//            _ = make?.right.equalTo()(adapt_W(width: isPhone ? -13 : -20))
//            _ = make?.width.equalTo()(adapt_W(width: isPhone ? 78 : 63))
//            _ = make?.height.equalTo()(adapt_H(height: isPhone ? 25 : 20))
//        }
        wallentValue.center.y = wallentWord.center.y
        bankBtn.center.y = wallentWord.center.y
    }
    
    
    func initGameView() -> Void {
        //增加游戏需要修改
        let gameImgArray = ["self_game_MG.png","self_game_SG.png","self_game_PNG.png","self_game_HB.png","self_game_TTG.png","self_game_BS.png"]

        let titleViewHeight = adapt_H(height: model.titleViewHeight)
        let gameFrame = CGRect(x: 0, y: titleViewHeight + adapt_H(height: 6), width: width, height: height - titleViewHeight - adapt_H(height: 6) - tabBarHeight)
        let gameView = baseVC.viewCreat(frame: gameFrame, backgroundColor: .white)
        scroll.addSubview(gameView)
        let buttonNum = Int((gameImgArray.count + 1) / 2) * 2
        for i in 0 ..< buttonNum {
            let btnW:CGFloat = width / 2
            let btnH:CGFloat = gameFrame.height / CGFloat(Int((selfGameName.count + 1) / 2))
            let btnX:CGFloat = CGFloat(i % 2) * (width / 2)
            let btnY:CGFloat = CGFloat(Int(i / 2)) * btnH
            let btnFrame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
            let gameBtn = baseVC.buttonCreat(frame: btnFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .white, fonsize: 0, events: .touchUpInside)
            gameBtn.tag = selfBtnTag.SelfGameBtnTag.rawValue + i
            gameView.addSubview(gameBtn)
            gameBtn.layer.borderColor = self.backgroundColor?.cgColor
            gameBtn.layer.borderWidth = adapt_W(width: isPhone ? 0.35 : 0.25)
            if i >= selfGameName.count {
                gameBtn.isEnabled = false
                return
            }
            
            //img
            let imageHeight = adapt_H(height: isPhone ? 60 : 40)
            let gameImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 35), y: (btnFrame.height - imageHeight) / 2, width: imageHeight, height: imageHeight))
            gameImg.image = UIImage(named: gameImgArray[i])
            gameBtn.addSubview(gameImg)
            
            //name
            let gameName = UILabel(frame: CGRect(x: adapt_W(width: isPhone ? 80 : 85), y: btnFrame.height / 2 - adapt_H(height: isPhone ? 20 : 15), width: adapt_W(width: 100), height: adapt_H(height: 15)))
            gameBtn.addSubview(gameName)
            setLabelProperty(label: gameName, text: selfGameName[i], aligenment: .left, textColor: UIColor.colorWithCustom(r: 59, g: 59, b: 59), backColor: .clear, font: fontAdapt(font: isPhone ? 13 : 9))
            //account
            let account = UILabel(frame: CGRect(x: gameName.frame.origin.x, y: btnFrame.height / 2 + adapt_H(height: isPhone ? 10 :5), width: adapt_W(width: 120), height: adapt_H(height: 15)))
            gameBtn.addSubview(account)
            account.tag = selfBtnTag.AccountLabel.rawValue + i
            var balanceValue = "¥0.0"
            if let balanceValue_t = userDefaults.value(forKey: selfGameUserDefaults[i]){
                balanceValue = "¥\(balanceValue_t as! String)"
            }
            setLabelProperty(label: account, text: balanceValue, aligenment: .left, textColor: UIColor.colorWithCustom(r: 45, g: 45, b: 45), backColor: .clear, font: fontAdapt(font: isPhone ? 16 : 12))
        }
    }
    
    
    @objc func tapGuesAct(sender:UITapGestureRecognizer) -> Void {
        delegate.buttonAction(btnTag: sender.view!.tag)
    }
    
    
    @objc func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct  sender.tag = \(sender.tag)")
        delegate.buttonAction(btnTag: sender.tag)
    }
    

}
