//
//  RgstPassView.swift
//  FuTu
//
//  Created by Administrator1 on 2/1/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

class RgstPassView: UIView {

    var width,height: CGFloat!
    var textFieldDelegate:UITextFieldDelegate!
    var delegate: BtnActDelegate!
    //基础空间
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
        initBackImg()
        initNavigationBar()
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
    
    //================================
    //Mark:- 导航头
    //================================
    func initNavigationBar() -> Void {
        //view
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20 + navBarHeight))
        self.addSubview(navigationView)
        navigationView.backgroundColor = UIColor.clear
        //label
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: width, height: navBarHeight))
        setLabelProperty(label: titleLabel, text: "注册新用户", aligenment: .center, textColor: .colorWithCustom(r: 81, g: 81, b: 81), backColor: .clear, font: fontAdapt(font: 20))
        
        navigationView.addSubview(titleLabel)
        
        
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: adapt_W(width: 10), y: 20, width: navBarHeight, height: navBarHeight), title: "取消", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: 15), events: .touchUpInside)
        navigationView.addSubview(backBtn)
        backBtn.setTitleColor(UIColor.colorWithCustom(r: 81, g: 81, b: 81), for: .normal)
        backBtn.tag = RegisterTag.cancelBtnTag.rawValue
        
        
    }
    
    //================================
    //Mark:- 用户名输入框
    //================================
    private func initInputTextField() -> Void {
        let labelImg = ["find_text_realName.png","register_text_password.png","register_text_confirm.png"]
        let placeholderText = ["请输入您的名字","6-12位字符","请确认密码"]
        
        for i in 0 ..< 3 {
            
            let textImg = UIImageView()
            self.addSubview(textImg)
            textImg.mas_makeConstraints { (make) in
                _ = make?.top.equalTo()(adapt_H(height: 140 + adapt_H(height: 65 * CGFloat(i))))
                _ = make?.left.equalTo()(self.mas_left)?.setOffset(adapt_W(width: 30))
                _ = make?.width.equalTo()(self.width - adapt_W(width: 60))
                _ = make?.height.equalTo()(adapt_H(height: 25))
            }
            textImg.image = UIImage(named: "login_text_line.png")
            
            let textField = baseVC.textFieldCreat(frame: initFrame, placeholderText: placeholderText[i], aligment: .left, fonsize: fontAdapt(font: 17), borderWidth: 0, borderColor: .clear, tag: 10)
            textField.textColor = UIColor.colorWithCustom(r: 37, g: 37, b: 37)
            self.addSubview(textField)
            textField.keyboardType = .default
            textField.delegate = self.textFieldDelegate
            textField.tag = RgstPassTag.realNameText.rawValue + i
            textField.mas_makeConstraints { (make) in
                _ = make?.top.equalTo()(textImg.mas_top)?.setOffset(adapt_H(height: -5))
                _ = make?.left.equalTo()(textImg.mas_left)
                _ = make?.right.equalTo()(textImg.mas_right)
                _ = make?.height.equalTo()(textImg.mas_height)
            }
            //添加左侧视图
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: adapt_W(width: 100), height: adapt_H(height: 20)))
            textField.leftView = leftView
            textField.leftViewMode = .always
            
            let leftImg = UIImageView(image: UIImage(named: labelImg[i]))
            leftView.addSubview(leftImg)
            let line = UIView()
            line.backgroundColor = UIColor.colorWithCustom(r: 161, g: 161, b: 161)
            leftView.addSubview(line)
            
            leftImg.mas_makeConstraints({ (make) in
                _ = make?.top.equalTo()
                _ = make?.bottom.equalTo()
                _ = make?.left.equalTo()(adapt_W(width: 10))
                _ = make?.right.equalTo()(line.mas_right)?.setOffset(adapt_W(width: -10))
            })
            //leftImg.center.y = textField.center.y
            
            line.mas_makeConstraints({ (make) in
                _ = make?.top.equalTo()
                _ = make?.bottom.equalTo()(adapt_H(height: -3))
                _ = make?.width.equalTo()(adapt_W(width: 0.5))
                _ = make?.right.equalTo()(adapt_W(width: -14))
            })
            if i >= 1{
                //添加右侧视图（密码是否可见）
//                let rightFrame = CGRect(x: textField.frame.width - adapt_W(width: 40), y: 0 , width: adapt_W(width: 40), height: textField.frame.height)
//                
//                let rightView = baseVC.buttonCreat(frame: rightFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
                textField.isSecureTextEntry = true
                let rightView = UIImageView(frame: CGRect(x: textField.frame.width - adapt_W(width: 30), y: (textField.frame.height - adapt_W(width: 30)) / 2, width: adapt_W(width: 30), height: adapt_W(width: 30)))
                rightView.image = UIImage(named: "register_pass_eye1.png")
                textField.rightView = rightView
                textField.rightViewMode = .always
                rightView.tag = RgstPassTag.eyeOpenImgTag.rawValue + i - 1
                rightView.isUserInteractionEnabled = true
                let tapGeutrue = UITapGestureRecognizer(target: self, action: #selector(self.tapGuestureAct(tap:)) )
                rightView.addGestureRecognizer(tapGeutrue)
            }
            
        }
        
        let alertLabel = UILabel(frame: CGRect(x: adapt_W(width: 20), y: adapt_H(height: 290), width: width - adapt_W(width: 40), height: adapt_H(height: 22)))
        self.addSubview(alertLabel)
        setLabelProperty(label: alertLabel, text: "", aligenment: .right, textColor: .red, backColor: .clear, font: fontAdapt(font: 14))
        alertLabel.tag = RgstPassTag.infoAlertLabelTag.rawValue
        alertLabel.isHidden = true
        
        
        //register button
        let registerFrame = CGRect(x: (width - adapt_W(width: 275)) / 2, y: adapt_H(height: 350), width: adapt_W(width: 275), height: adapt_H(height: 45))
        let registerBtn = baseVC.buttonCreat(frame: registerFrame, title: "完   成", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"login_button_back1.png"), hightImage: UIImage(named:"login_button_back2.png"), backgroundColor: .clear, fonsize: fontAdapt(font: 17), events: .touchUpInside)
        self.addSubview(registerBtn)
        registerBtn.tag = RgstPassTag.finishBtntag.rawValue
        let loginLabelFrame = CGRect(x: 0, y: 0, width: registerFrame.width, height: registerFrame.height)
        let loginLabel = baseVC.labelCreat(frame: loginLabelFrame, text:  "完   成", aligment: .center, textColor: .white, backgroundcolor: .clear, fonsize: fontAdapt(font: 19))
        registerBtn.addSubview(loginLabel)
        
        
               
    }
    
    @objc func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct sender.tag:\(sender.tag)")
        
        delegate.btnAct(btnTag: sender.tag)
    }

    var eyeImgOpenStatus = [false,false]
    @objc func tapGuestureAct(tap:UITapGestureRecognizer) -> Void {
//        tlPrint(message: "tapGuestureAct tap.view.tag:\(tap.view?.tag)")
        let index = tap.view!.tag - RgstPassTag.eyeOpenImgTag.rawValue
        let eyeImg = self.viewWithTag(tap.view!.tag) as! UIImageView
        eyeImg.image = UIImage(named: eyeImgOpenStatus[index] ? "register_pass_eye1.png" : "register_pass_eye2.png")
        eyeImgOpenStatus[index] = !eyeImgOpenStatus[index]
        
        let textField = self.viewWithTag(RgstPassTag.passwordText.rawValue + index) as! UITextField
        textField.isSecureTextEntry = !eyeImgOpenStatus[index]
        
    }
}
