//
//  WalletHubView.swift
//  FuTu
//
//  Created by Administrator1 on 27/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class WalletHubView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var scroll: UIScrollView!
    var titleLabel: UILabel!
    var amountLabel: UILabel!
    var tradeSearchBtn: UIButton!
    var logoImg: UIImageView!
    var delegate:BtnActDelegate!
    var titleView:UIView!
    var scrollDelegate: UIScrollViewDelegate!
    var width,height: CGFloat!
    let model = WalletHubModel()
    
    var refreshIndicator:RefreshIndicator!
    
    let baseVC = BaseViewController()
    
    
    init(frame:CGRect, param:AnyObject,rootVC:UIViewController) {
        super.init(frame: frame)
        
        self.width = frame.width
        self.height = frame.height
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        delegate = rootVC as! BtnActDelegate
        self.scrollDelegate = rootVC as! UIScrollViewDelegate
        
        initScrollView()
        initNavigationBar()
    }
    
    
    
    
    func initScrollView() -> Void {
        
        scroll = baseVC.scrollViewCreat(frame: self.frame, delegate: scrollDelegate, contentSize: CGSize(width:width,height:height+1), showsIndicatorV: false, showsIndecatorH: false, backColor: .colorWithCustom(r: 244, g: 244, b: 244))
        self.insertSubview(scroll, at: 0)
        scroll.delegate = scrollDelegate
        
        //titleView
        let titleFrame = CGRect(x: 0, y: 0, width: width, height: adapt_H(height: model.titleHeight))
        titleView = UIView(frame: titleFrame)

        let gradientLayer = CAGradientLayer.gradientLayerTopLeft(topLeft: .colorWithCustom(r: 241, g: 124, b: 65), bottomRight: .colorWithCustom(r: 159, g: 11, b: 67))
        gradientLayer.frame = titleView.frame
        titleView.layer.insertSublayer(gradientLayer, at: 0)
        
//        titleView = baseVC.imageViewCreat(frame: titleFrame, image: UIImage(named:"wallet_title_bg.png")!, highlightedImage: UIImage(named:"wallet_title_bg.png")!)
        scroll.addSubview(titleView)
        
//        //title label
//        let titleLabelFrame = CGRect(x: 0, y: 20 + adapt_H(height: 16), width: width, height: 20)
//        titleLabel = baseVC.labelCreat(frame: titleLabelFrame, text: "中心钱包", aligment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 17 : 12))
//        scroll.addSubview(titleLabel)
        
        //search button
//        let searchFrame = CGRect(x: width - adapt_W(width: isPhone ? 80 : 50), y: 20 + adapt_H(height: 10), width: adapt_W(width: isPhone ? 80 : 50), height: adapt_H(height: isPhone ? 40 : 25))
//        tradeSearchBtn = baseVC.buttonCreat(frame: searchFrame, title: "交易查询", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 13 : 9), events: .touchUpInside)
//        scroll.addSubview(tradeSearchBtn)
//        tradeSearchBtn.tag = walletHubTag.TradeSearchBtnTag.rawValue
//        tradeSearchBtn.setTitleColor(UIColor.colorWithCustom(r: 255, g: 192, b: 0), for: .normal)
        
        //logo
        let logoFrame = CGRect(x: (width - adapt_W(width: model.logoWidth)) / 2, y: adapt_H(height: isPhone ? 85 : 55), width: adapt_W(width: model.logoWidth), height: adapt_W(width: model.logoWidth))
        logoImg = UIImageView(frame: logoFrame)
        logoImg.image = UIImage(named: "wallet_center_Logo.png")
        scroll.addSubview(logoImg)
        
        //amount label
        var amountText = "¥0.00"
        if let amount = userDefaults.value(forKey: userDefaultsKeys.userInfoBalance.rawValue) {
            amountText = "¥\(amount)"
        }
        let amountFrame = CGRect(x: 0, y: adapt_H(height: isPhone ? 200 : 140), width: width, height: adapt_H(height: isPhone ? 55 : 35))
        amountLabel = baseVC.labelCreat(frame: amountFrame, text: amountText, aligment: .center, textColor: .white, backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 32 : 20))
        scroll.addSubview(amountLabel)
        
        //Bailouts button
        //
        let weekendView = UIView(frame: CGRect(x: 0, y: self.titleView.frame.height - adapt_H(height: isPhone ? 70 : 40), width: width, height: adapt_H(height: isPhone ? 70 : 40)))
        scroll.addSubview(weekendView)
        weekendView.backgroundColor = UIColor.black
        weekendView.layer.opacity = 0.1

        let weekendButtonWidth:CGFloat = isPhone ? 115 : 90
        let weekendButtonHeight:CGFloat = isPhone ? 35 : 25
        let weekendButtonXArray = [width / 2 - adapt_W(width: (isPhone ? 12 : 18) + weekendButtonWidth), width / 2 + adapt_W(width: isPhone ? 12 : 18)]
        let weekendBtnName = ["周六奖金","周日奖金"]
        for i in 0 ..< 2 {
            let btnFrame = CGRect(x: weekendButtonXArray[i], y:titleFrame.height - (weekendView.frame.height + weekendButtonHeight) / 2, width:adapt_W(width: weekendButtonWidth), height:adapt_H(height:  weekendButtonHeight))
            let button = baseVC.buttonCreat(frame: btnFrame, title: weekendBtnName[i], alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 17 : 12), events: .touchUpInside)
            button.setTitleColor(.colorWithCustom(r: 255, g: 192, b: 0), for: .normal)
            scroll.insertSubview(button, aboveSubview: weekendView)
            button.tag = walletHubTag.WeekendBtnTag.rawValue + i
//            button.layer.cornerRadius = btnFrame.height / 2
//            button.layer.borderColor = UIColor.white.cgColor
//            button.layer.borderWidth = adapt_H(height: 1)
            button.center.y = weekendView.center.y
            //当前隐藏救援金功能
//            button.isHidden = true
            
        }
        //竖线
        let line = UIView()
        line.backgroundColor = UIColor.colorWithCustom(r: 255, g: 192, b: 0)
        scroll.addSubview(line)
        line.mas_makeConstraints({ (make) in
            _ = make?.top.equalTo()(weekendView.mas_top)?.setOffset(adapt_H(height: isPhone ? 20 : 6))
            _ = make?.bottom.equalTo()(weekendView.mas_bottom)?.setOffset(adapt_H(height: isPhone ? -20 : -7))
            _ = make?.width.equalTo()(adapt_W(width: 2))
            _ = make?.left.equalTo()(weekendView.mas_left)?.setOffset(width / 2 - adapt_W(width: 1))
        })
        
        
        //3 buttons
        let buttonWidth = adapt_W(width: isPhone ? 270 : 220)
        let buttonHeight = adapt_H(height: isPhone ? 45 : 30)
        let buttonDist = adapt_H(height: isPhone ? 60 : 45)
        let buttonY = adapt_H(height: isPhone ? 380 : 250)
        for i in 0 ..< 3 {
            let btnFrame = CGRect(x: (width - buttonWidth) / 2, y:buttonY + CGFloat(i) * buttonDist, width: buttonWidth, height: buttonHeight)
            let button = baseVC.buttonCreat(frame: btnFrame, title: model.buttonInfo[i][0] as! String, alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: model.buttonInfo[i][1] as! UIColor, fonsize: fontAdapt(font: isPhone ? 17 : 12), events: .touchUpInside)
            scroll.addSubview(button)
            button.tag = walletHubTag.RechargeBtnTag.rawValue + i
            button.layer.cornerRadius = btnFrame.height / 2
        }
    }
    
    func initNavigationBar() {
        
        
        //view
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20 + navBarHeight))
        self.addSubview(navigationView)
        let gradientLayer = CAGradientLayer.GradientLayer(topColor: UIColor.colorWithCustom(r: 65, g: 50, b: 48), buttomColor: UIColor.colorWithCustom(r: 43, g: 38, b: 34))
        gradientLayer.frame = navigationView.frame
        navigationView.layer.insertSublayer(gradientLayer, at: 0)
        
        //label
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: width, height: navBarHeight))
        setLabelProperty(label: titleLabel, text: "中心钱包", aligenment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .clear, font: 17)
        navigationView.addSubview(titleLabel)
        
        //back button
        let backFrame = CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight)
        let backBtn = baseVC.buttonCreat(frame: backFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        navigationView.addSubview(backBtn)
        backBtn.tag = walletHubTag.HubBackBtnTag.rawValue
        //back button image
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
        
        
        //search button
        let searchFrame = CGRect(x: width - adapt_W(width: isPhone ? 80 : 50), y: 20 + adapt_H(height: 22), width: adapt_W(width: isPhone ? 80 : 50), height: adapt_H(height: isPhone ? 15 : 10))
        tradeSearchBtn = baseVC.buttonCreat(frame: searchFrame, title: "交易查询", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 13 : 9), events: .touchUpInside)
        navigationView.addSubview(tradeSearchBtn)
        tradeSearchBtn.tag = walletHubTag.TradeSearchBtnTag.rawValue
        tradeSearchBtn.setTitleColor(UIColor.colorWithCustom(r: 255, g: 192, b: 0), for: .normal)
        tradeSearchBtn.mas_makeConstraints { (make) in
            _ = make?.bottom.equalTo()(titleLabel.mas_bottom)?.setOffset(adapt_W(width: -12))
            _ = make?.right.equalTo()(adapt_W(width: -10))
            _ = make?.width.equalTo()(adapt_W(width: isPhone ? 80 : 50))
            _ = make?.height.equalTo()(adapt_H(height: isPhone ? 15 : 10))
        }
        
    }
    
    
    @objc func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct sender.tag: \(sender.tag)")
        delegate.btnAct(btnTag: sender.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
