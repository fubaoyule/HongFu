//
//  LoginView.swift
//  FuTu
//
//  Created by Administrator1 on 31/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class LoginView: UIView {

    //var scroll: UIScrollView!
    //头像图像视图
    var headImgView: UIImageView!
    var width,height: CGFloat!
    var scrollDelgate:UIScrollViewDelegate!
    var textFieldDelegate:UITextFieldDelegate!
    var delegate: BtnActDelegate!
    //基础控件
    let baseVC = BaseViewController()
    let model = LoginModel()
    let initFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    init(frame:CGRect,rootVC:UIViewController) {
        super.init(frame: frame)
        
        self.width = deviceScreen.width
        self.height = deviceScreen.height
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        self.textFieldDelegate = rootVC as! UITextFieldDelegate
        self.delegate = rootVC as! BtnActDelegate
        
        //self.initScrollView()
//        initBackImg()
        self.initBgColor()
        initBackBtn()
        initHeadImgView()
        initInputTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private func initScrollView() -> Void {
//        
//        let scrollFrame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
//        scroll = UIScrollView(frame: scrollFrame)
//        self.addSubview(scroll)
//        scroll.delegate = scrollDelgate
//        //scroll.backgroundColor = UIColor.green
//        scroll.contentSize = CGSize(width: self.width, height: self.height + 1)
//        scroll.showsVerticalScrollIndicator = false
//        scroll.showsHorizontalScrollIndicator = false
//        
//        
//        initBackImg()
//        initHeadImgView()
//        initInputTextField()
//    }
//    
    
    //================================
    //Mark:- 背景图
    //================================
    private func initBackImg() -> Void {
        
        let backImg = UIImageView(frame: self.frame)
        backImg.image = UIImage(named: "login_bg.png")
        
        self.addSubview(backImg)
    }
    private func initBgColor() -> Void {
        
        
        //下部渐变背景
        let gradientLayer = CAGradientLayer.GradientLayer(topColor: UIColor.colorWithCustom(r: 210, g: 52, b: 26), buttomColor: UIColor.colorWithCustom(r: 86, g: 0, b: 28))
        gradientLayer.frame = self.frame
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func initBackBtn() -> Void {
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.addSubview(backBtn)
        backBtn.tag = LoginTag.HomeBtnTag.rawValue
        //back button image
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
    }
    
    //================================
    //Mark:- 头像视图
    //================================
    private func initHeadImgView() -> Void {
        
        headImgView = UIImageView()
        headImgView.image = UIImage(named: "login_logo.png")
        
        self.addSubview(headImgView)
        let imgWidth = adapt_W(width: isPhone ? 170 : 120)
        let imgHeight = adapt_H(height: isPhone ? 81 : 50)
        headImgView.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(adapt_H(height: isPhone ? 60 : 40))
            _ = make?.left.equalTo()((self.width - imgWidth) / 2)
            _ = make?.width.equalTo()(imgWidth)
            _ = make?.height.equalTo()(imgHeight)
        }
        headImgView.center.x = self.center.x
        headImgView.layer.cornerRadius = adapt_W(width: isPhone ? 10 : 6)
        headImgView.clipsToBounds = true
    }
    
    
    //================================
    //Mark:- 用户名输入框
    //================================
    private func initInputTextField() -> Void {
//        let labelImg = ["login_text_userName.png","login_text_password.png","login_button_forget.png","login_button_register.png"]
        let labelTextArray = ["账号","密码"]
        let placeholderText = ["您的账户","输入您的密码"]
        for i in 0 ..< 2 {
            
            
            let backView = UIView()
            self.addSubview(backView)
            backView.mas_makeConstraints { (make) in
                _ = make?.top.equalTo()(adapt_H(height: (isPhone ? 200 : 150) + adapt_H(height: (isPhone ? 48 : 30) * CGFloat(i))))
                _ = make?.left.equalTo()(self.mas_left)?.setOffset(adapt_W(width: isPhone ? 60 : 120))
                _ = make?.right.equalTo()(self.mas_right)?.setOffset(adapt_W(width: isPhone ? -60 : -120))
                _ = make?.height.equalTo()(adapt_H(height: isPhone ? 40 : 30))
            }
            backView.layer.cornerRadius = adapt_W(width: isPhone ? 5 : 3)
            backView.alpha = 0.15
            backView.backgroundColor = UIColor.black
            
            let textImg = UIImageView()
            self.addSubview(textImg)
            textImg.mas_makeConstraints { (make) in
                _ = make?.top.equalTo()(adapt_H(height: (isPhone ? 200 : 150) + adapt_H(height: (isPhone ? 48 : 30) * CGFloat(i))))
                _ = make?.left.equalTo()(self.mas_left)?.setOffset(adapt_W(width: isPhone ? 60 : 120))
                _ = make?.right.equalTo()(self.mas_right)?.setOffset(adapt_W(width: isPhone ? -60 : -120))
                _ = make?.height.equalTo()(adapt_H(height: isPhone ? 40 : 30))
            }
            textImg.image = UIImage(named: "null.png")
            
            
            //添加账号密码文字
            let leftLabel = UILabel()
            textImg.addSubview(leftLabel)
            setLabelProperty(label: leftLabel, text: labelTextArray[i], aligenment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .clear, font: fontAdapt(font: isPhone ? 15 : 11))
            //竖线
            let line = UIView()
            line.backgroundColor = UIColor.colorWithCustom(r: 255, g: 192, b: 0)
            leftLabel.addSubview(line)
            
            leftLabel.mas_makeConstraints({ (make) in
                _ = make?.top.equalTo()
                _ = make?.bottom.equalTo()
                _ = make?.left.equalTo()(adapt_W(width: isPhone ? 5 : 3))
                _ = make?.width.equalTo()(adapt_W(width: isPhone ? 60 : 40))
//                _ = make?.right.equalTo()(line.mas_right)
            })
            
            line.mas_makeConstraints({ (make) in
                _ = make?.top.equalTo()(adapt_H(height: isPhone ? 10 : 6))
                _ = make?.bottom.equalTo()(adapt_H(height: isPhone ? -10 : -7))
                _ = make?.width.equalTo()(adapt_W(width: 0.5))
                _ = make?.left.equalTo()(leftLabel.mas_right)
            })
            
            //输入框
            let textField = baseVC.textFieldCreat(frame: initFrame, placeholderText: placeholderText[i], aligment: .left, fonsize: fontAdapt(font: isPhone ? 17 : 12), borderWidth: 0, borderColor: .clear, tag: 10)
            textField.textColor = UIColor.white
            self.addSubview(textField)
            textField.delegate = self.textFieldDelegate
            textField.tag = LoginTag.userText.rawValue + i
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText[i], attributes: [NSAttributedStringKey.foregroundColor:UIColor.colorWithCustom(r: 253, g: 129, b: 114), NSAttributedStringKey.font:UIFont.systemFont(ofSize:15)])
            if i == 0 {
                let nameImg = UIImageView()
                nameImg.image = UIImage(named: "login_hf.png")
                textImg.addSubview(nameImg)
                nameImg.mas_makeConstraints({ (make) in
                    _ = make?.top.equalTo()(adapt_H(height: isPhone ? 12 : 8))
                    _ = make?.left.equalTo()(line.mas_right)?.setOffset(adapt_W(width: isPhone ? 10 : 6))
                    _ = make?.width.equalTo()(adapt_W(width: isPhone ? 30 : 20))
                    _ = make?.height.equalTo()(adapt_H(height: isPhone ? 17 : 12))
                })
                
                
                textField.mas_makeConstraints { (make) in
                    _ = make?.top.equalTo()(textImg.mas_top)?.setOffset(adapt_W(width: isPhone ? 2 : 1))
                    _ = make?.left.equalTo()(textImg.mas_left)?.setOffset(adapt_W(width: 110))
                    _ = make?.right.equalTo()(textImg.mas_right)
                    _ = make?.height.equalTo()(textImg.mas_height)
                }
            } else if i == 1 {
                textField.mas_makeConstraints { (make) in
                    _ = make?.top.equalTo()(textImg.mas_top)?.setOffset(adapt_W(width: isPhone ? 2 : 1))
                    _ = make?.left.equalTo()(textImg.mas_left)?.setOffset(adapt_W(width: 80))
                    _ = make?.right.equalTo()(textImg.mas_right)
                    _ = make?.height.equalTo()(textImg.mas_height)
                }
                textField.isSecureTextEntry = true
            }
            
        }
        
        //login button
        let loginLeftDis = adapt_W(width: isPhone ? 60 : 120)
        let loginFrame = CGRect(x: loginLeftDis, y: adapt_H(height: isPhone ? 315 : 200), width: width - 2 * loginLeftDis, height: adapt_H(height: isPhone ? 39 : 28))
        let loginBtn = baseVC.buttonCreat(frame: loginFrame, title: "登  录", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.addSubview(loginBtn)
        //下部渐变背景
        let gradientLayer = CAGradientLayer.GradientLayer(topColor: UIColor.colorWithCustom(r: 255, g: 186, b: 0), buttomColor: UIColor.colorWithCustom(r: 239, g: 129, b: 0))
        gradientLayer.frame = CGRect(x: 0, y: 0, width: loginFrame.width, height: loginFrame.height)
        loginBtn.layer.insertSublayer(gradientLayer, at: 0)
        loginBtn.layer.cornerRadius = adapt_W(width: isPhone ? 4 : 3)
        loginBtn.tag = LoginTag.loginBtnTag.rawValue
        loginBtn.titleLabel?.textColor = UIColor.white
        loginBtn.clipsToBounds = true
        
        let loginLabelFrame = CGRect(x: 0, y: 0, width: loginFrame.width, height: loginFrame.height)
        let loginLabel = baseVC.labelCreat(frame: loginLabelFrame, text:  "登  录", aligment: .center, textColor: .white, backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 17 : 12))
        loginBtn.addSubview(loginLabel)
        
        
        //back to home button
//        let homeFrame = CGRect(x: (width - adapt_W(width: isPhone ? 275 : 200)) / 2, y: adapt_H(height: isPhone ? 400 : 280), width: adapt_W(width: isPhone ? 275 : 200), height: adapt_H(height: isPhone ? 45 : 28))
//        let homeBtn = baseVC.buttonCreat(frame: homeFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"login_homeBtn.png"), hightImage: UIImage(named:"login_homeBtn.png"), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
//        self.addSubview(homeBtn)
//        homeBtn.tag = LoginTag.HomeBtnTag.rawValue
//        let homeLabelFrame = CGRect(x: 0, y: 0, width: loginFrame.width, height: loginFrame.height)
//        let homeLabel = baseVC.labelCreat(frame: homeLabelFrame, text:  "鸿福首页", aligment: .center, textColor: .colorWithCustom(r: 26, g: 123, b: 233), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 15 : 10))
//        homeBtn.addSubview(homeLabel)
        
        
        //forget & register button
        let textArray = ["忘记密码","立即注册"]
        for i in 0 ..< 2 {
            
            let btnFrame = CGRect(x: adapt_W(width: (isPhone ? 103 : 110) * (CGFloat(i) + 1)), y: adapt_H(height: isPhone ? 365 : 280), width: adapt_W(width: isPhone ? 65 : 45), height: adapt_H(height: isPhone ? 22 : 15))
            let button = baseVC.buttonCreat(frame: btnFrame, title: textArray[i], alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 13 : 10), events: .touchUpInside)
            self.addSubview(button)
            button.tag = LoginTag.forgetBtnTag.rawValue + i
            button.setTitleColor(UIColor.colorWithCustom(r: 253, g: 129, b: 114), for: .normal)
        }
    }
    
    
    @objc func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct sender.tag:\(sender.tag)")
        delegate.btnAct(btnTag: sender.tag)
    }

}
