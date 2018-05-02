//
//  ForgetView.swift
//  FuTu
//
//  Created by Administrator1 on 2/1/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

class ForgetView: UIView {
    var width,height: CGFloat!
    var textFieldDelegate:UITextFieldDelegate!
    var delegate: BtnActDelegate!
    //基础空间
    let baseVC = BaseViewController()
    let model = ForgetModel()
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
        initBgColor()
        initNavigationBar()
        initStepLabel()
        initInputTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    //================================
    //Mark:- 导航头
    //================================
    func initNavigationBar() -> Void {
        //view
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20 + navBarHeight))
        self.addSubview(navigationView)
        navigationView.backgroundColor = UIColor.clear
        //label
        let titleLabel = UILabel(frame: CGRect(x: 0, y: adapt_H(height: 20), width: width, height: navBarHeight))
        setLabelProperty(label: titleLabel, text: "找回密码", aligenment: .center, textColor: .white, backColor: .clear, font: fontAdapt(font: isPhone ? 20 : 13))
        
        navigationView.addSubview(titleLabel)
        
        
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: adapt_W(width: 10), y: 20, width: adapt_W(width: isPhone ? 40 : 30), height: navBarHeight), title: "取消", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 16 : 10), events: .touchUpInside)
        navigationView.addSubview(backBtn)
        backBtn.setTitleColor(UIColor.white, for: .normal)
        backBtn.tag = ForgetTag.cancelBtnTag.rawValue
        
        
    }
    
    func initStepLabel() -> Void {
        let stepLabel = UILabel(frame: CGRect(x: 0, y: adapt_H(height: isPhone ? 80 : 50), width: width, height: adapt_H(height: isPhone ? 20 : 15)))
        setLabelProperty(label: stepLabel, text: "第一步填写账户信息", aligenment: .center, textColor: .colorWithCustom(r: 253, g: 129, b: 114), backColor: .clear, font: fontAdapt(font: isPhone ? 14 : 9))
        self.addSubview(stepLabel)
    }
    
    //================================
    //Mark:- 用户名输入框
    //================================
    private func initInputTextField() -> Void {
        let labelTextArray = ["用户名","真实姓名"]
        let placeholderText = ["您的用户名","您的真实姓名"]
        for i in 0 ..< 2 {
            let backView = UIView()
            self.addSubview(backView)
            backView.mas_makeConstraints { (make) in
                _ = make?.top.equalTo()(adapt_H(height: (isPhone ? 150 : 100) + adapt_H(height: (isPhone ? 48 : 30) * CGFloat(i))))
                _ = make?.left.equalTo()(self.mas_left)?.setOffset(adapt_W(width: isPhone ? 50 : 120))
                _ = make?.right.equalTo()(self.mas_right)?.setOffset(adapt_W(width: isPhone ? -50 : -120))
                _ = make?.height.equalTo()(adapt_H(height: isPhone ? 40 : 30))
            }
            backView.layer.cornerRadius = adapt_W(width: isPhone ? 5 : 3)
            backView.alpha = 0.15
            backView.backgroundColor = UIColor.black
            
            let textImg = UIImageView()
            self.addSubview(textImg)
            textImg.mas_makeConstraints { (make) in
                _ = make?.top.equalTo()(adapt_H(height: (isPhone ? 150 : 100) + adapt_H(height: (isPhone ? 48 : 30) * CGFloat(i))))
                _ = make?.left.equalTo()(self.mas_left)?.setOffset(adapt_W(width: isPhone ? 50 : 120))
                _ = make?.right.equalTo()(self.mas_right)?.setOffset(adapt_W(width: isPhone ? -50 : -120))
                _ = make?.height.equalTo()(adapt_H(height: isPhone ? 40 : 30))
            }
            textImg.image = UIImage(named: "null.png")
            
            
            //用户名，真实姓名文字
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
                _ = make?.width.equalTo()(adapt_W(width: isPhone ? 80 : 50))
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
            textField.keyboardType = .default
            textField.delegate = self.textFieldDelegate
            textField.tag = LoginTag.userText.rawValue + i
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText[i], attributes: [NSAttributedStringKey.foregroundColor:UIColor.colorWithCustom(r: 253, g: 129, b: 114), NSAttributedStringKey.font:UIFont.systemFont(ofSize:15)])
            textField.tag = ForgetTag.usernameText.rawValue + i
            textField.mas_makeConstraints { (make) in
                _ = make?.top.equalTo()(textImg.mas_top)?.setOffset(adapt_W(width: isPhone ? 2 : 1))
                _ = make?.left.equalTo()(textImg.mas_left)?.setOffset(adapt_W(width: 100))
                _ = make?.right.equalTo()(textImg.mas_right)
                _ = make?.height.equalTo()(textImg.mas_height)
            }
            
            
            //添加右侧视图:红色错误提示文字
            let alertLabel = UILabel()
            alertLabel.frame = CGRect(x: textField.frame.width - adapt_W(width: isPhone ? 80 : 60), y: 0, width: adapt_W(width: isPhone ? 90 : 65), height: adapt_H(height: isPhone ? 20 : 15))
            setLabelProperty(label: alertLabel, text: self.model.alertLabelText[i], aligenment: .right, textColor: .red, backColor: .clear, font: fontAdapt(font: isPhone ? 12 : 8))
            alertLabel.tag = ForgetTag.forgetAlergLabel.rawValue + i
            textField.rightView = alertLabel
            textField.rightViewMode = .always
            alertLabel.isHidden = true
        }
        
        //next button
        
        let nextLeftDis = adapt_W(width: isPhone ? 50 : 120)
        let nextFrame = CGRect(x: nextLeftDis, y: adapt_H(height: isPhone ? 280 : 200), width: width - 2 * nextLeftDis, height: adapt_H(height: isPhone ? 39 : 28))
        let nextBtn = baseVC.buttonCreat(frame: nextFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"login_button_back1.png"), hightImage: UIImage(named:"login_button_back2.png"), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.addSubview(nextBtn)
        //下部渐变背景
        let gradientLayer = CAGradientLayer.GradientLayer(topColor: UIColor.colorWithCustom(r: 255, g: 186, b: 0), buttomColor: UIColor.colorWithCustom(r: 239, g: 129, b: 0))
        gradientLayer.frame = CGRect(x: 0, y: 0, width: nextFrame.width, height: nextFrame.height)
        nextBtn.layer.insertSublayer(gradientLayer, at: 0)
        nextBtn.layer.cornerRadius = adapt_W(width: isPhone ? 4 : 3)
        nextBtn.clipsToBounds = true

        
        nextBtn.tag = ForgetTag.nextBtnTag.rawValue
        let loginLabelFrame = CGRect(x: 0, y: 0, width: nextFrame.width, height: nextFrame.height)
        let loginLabel = baseVC.labelCreat(frame: loginLabelFrame, text:  "下一步", aligment: .center, textColor: .white, backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 17 : 11))
        nextBtn.addSubview(loginLabel)

        
        
    }
    
    @objc func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct sender.tag:\(sender.tag)")
        delegate.btnAct(btnTag: sender.tag)
    }

}
