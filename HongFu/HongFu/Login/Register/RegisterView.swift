//
//  RegisterView.swift
//  FuTu
//
//  Created by Administrator1 on 2/1/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

class RegisterView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {

    var width,height: CGFloat!
    var textFieldDelegate:UITextFieldDelegate!
    var delegate: BtnActDelegate!
    var tapDelegate: registerTapDelegate!
    var birthdayTextField:UITextField!
    //基础空间
    let baseVC = BaseViewController()
    let model = RegisterModel()
    let initFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    init(frame:CGRect,rootVC:UIViewController) {
        super.init(frame: frame)
        
        self.width = deviceScreen.width
        self.height = deviceScreen.height
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        self.textFieldDelegate = rootVC as! UITextFieldDelegate
        self.tapDelegate = rootVC as! registerTapDelegate
        self.delegate = rootVC as! BtnActDelegate
        
        //self.initScrollView()
//        initBackImg()
        initBgColor()
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
        setLabelProperty(label: titleLabel, text: "注册新用户", aligenment: .center, textColor: .white, backColor: .clear, font: fontAdapt(font: isPhone ? 20 : 13))
        
        navigationView.addSubview(titleLabel)
        
        
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: adapt_W(width: 10), y: 20, width: adapt_W(width: isPhone ? 40 : 30), height: navBarHeight), title: "取消", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 16 : 10), events: .touchUpInside)
        navigationView.addSubview(backBtn)
        backBtn.setTitleColor(UIColor.white, for: .normal)
        backBtn.tag = RegisterTag.cancelBtnTag.rawValue
       
        
    }
    
    //================================
    //Mark:- 用户名输入框
    //================================
    private func initInputTextField() -> Void {
        //let labelImg = ["forget_text_userName.png","register_text_password.png","find_text_realName.png","register_text_birthday.png","register_text_gender.png","register_text_wechat.png","register_text_phone.png","register_text_mail.png",""]
        let labelTextArray = ["用户名","密  码","真实姓名","出生年月","性  别","微信号","手机号码","电子邮箱",""]
        let placeholderText = ["您的用户名","请输入密码","请输入您的名字","请输入出生日期","","请输入您的微信号","建议使用常用手机","建议使用常用邮箱","请输入验证码"]
        //let alertLabelText = ["名称已被占用","手机号已注册","该邮箱已注册","验证码输入有误"]
        let keyBoardType = [UIKeyboardType.default, UIKeyboardType.default, UIKeyboardType.default, UIKeyboardType.numberPad, UIKeyboardType.default,UIKeyboardType.default, UIKeyboardType.numberPad, UIKeyboardType.emailAddress, UIKeyboardType.default]
        let textHeight = adapt_H(height: isPhone ? 25 : 15)
        for i in 0 ..< labelTextArray.count {
            
            
            
            let backView = UIView()
            self.addSubview(backView)
            backView.mas_makeConstraints { (make) in
                _ = make?.top.equalTo()(adapt_H(height: (isPhone ? 80 : 50) + (isPhone ? 45 : 28) * CGFloat(i)))
                _ = make?.left.equalTo()(self.mas_left)?.setOffset(adapt_W(width: isPhone ? 40 : 120))
                _ = make?.right.equalTo()(self.mas_right)?.setOffset(adapt_W(width: isPhone ? -40 : -120))
                _ = make?.height.equalTo()(adapt_H(height: isPhone ? 35 : 20))
            }
            backView.layer.cornerRadius = adapt_W(width: isPhone ? 5 : 3)
            backView.alpha = 0.15
            backView.backgroundColor = UIColor.black
            
            let textImg = UIImageView()
            self.addSubview(textImg)
            textImg.mas_makeConstraints { (make) in
                _ = make?.top.equalTo()(backView.mas_top)
                _ = make?.left.equalTo()(backView.mas_left)
                _ = make?.right.equalTo()
                _ = make?.height.equalTo()(backView.mas_height)
            }
            textImg.image = UIImage(named: "null.png")
            
            
            //添加账号密码文字
            let leftLabel = UILabel()
            textImg.addSubview(leftLabel)
            setLabelProperty(label: leftLabel, text: labelTextArray[i], aligenment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .clear, font: fontAdapt(font: isPhone ? 15 : 11))
            //竖线
            let line = UIView()
            line.backgroundColor = UIColor.colorWithCustom(r: 255, g: 192, b: 0)
            textImg.addSubview(line)
            
            leftLabel.mas_makeConstraints({ (make) in
                _ = make?.top.equalTo()
                _ = make?.bottom.equalTo()
                _ = make?.left.equalTo()
                _ = make?.width.equalTo()(adapt_W(width: isPhone ? 80 : 50))
            })
            
            line.mas_makeConstraints({ (make) in
                _ = make?.top.equalTo()(adapt_H(height: isPhone ? 10 : 6))
                _ = make?.bottom.equalTo()(adapt_H(height: isPhone ? -10 : -7))
                _ = make?.width.equalTo()(adapt_W(width: 1))
                _ = make?.left.equalTo()(textImg.mas_left)?.setOffset(adapt_W(width: isPhone ? 80 : 50))
            })
            
            //输入框
            let textField = baseVC.textFieldCreat(frame: initFrame, placeholderText: placeholderText[i], aligment: .left, fonsize: fontAdapt(font: isPhone ? 16 : 12), borderWidth: 0, borderColor: .clear, tag: 10)
            textField.textColor = UIColor.white
            self.addSubview(textField)
            textField.keyboardType = keyBoardType[i]
            textField.delegate = self.textFieldDelegate
            textField.tag = LoginTag.userText.rawValue + i
            //修改默认文字placehoder颜色和大小
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText[i], attributes: [NSAttributedStringKey.foregroundColor:UIColor.colorWithCustom(r: 253, g: 129, b: 114), NSAttributedStringKey.font:UIFont.systemFont(ofSize:15)])
            textField.mas_makeConstraints { (make) in
                _ = make?.top.equalTo()(textImg.mas_top)?.setOffset(adapt_W(width: isPhone ? 2 : 1))
                _ = make?.left.equalTo()(textImg.mas_left)?.setOffset(adapt_W(width: 100))
                _ = make?.right.equalTo()(textImg.mas_right)
                _ = make?.height.equalTo()(textImg.mas_height)
            }
        

            if i == 3 {
                //生日输入按钮
                let birthDateBtn = baseVC.buttonCreat(frame: textField.frame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
                self.insertSubview(birthDateBtn, aboveSubview: textField)
                birthDateBtn.tag = RegisterTag.BirthDageBtnTag.rawValue
                birthDateBtn.mas_makeConstraints { (make) in
                    _ = make?.top.equalTo()(textField.mas_top)
                    _ = make?.left.equalTo()(textField.mas_left)
                    _ = make?.right.equalTo()(textField.mas_right)
                    _ = make?.height.equalTo()(textField.mas_height)
                }
            }
            //性别按钮
            if i == 4 {
                for genderBtnIndex in 0 ..< 2 {
                    textField.isUserInteractionEnabled = false
                    //布局性别按钮
                    tlPrint(message: textField.frame)
                    let genderFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
                    let genderBtn = baseVC.buttonCreat(frame: genderFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
                    genderBtn.tag = RegisterTag.maleBtnTag.rawValue + genderBtnIndex
                    self.addSubview(genderBtn)
                    genderBtn.mas_makeConstraints({ (make) in
                        _ = make?.top.equalTo()(textField.mas_top)
                        _ = make?.bottom.equalTo()(textField.mas_bottom)
                        _ = make?.left.equalTo()(adapt_W(width: CGFloat(isPhone ? (140 + genderBtnIndex * 60) : (140 + genderBtnIndex * 40))))
                        _ = make?.width.equalTo()(adapt_W(width: isPhone ? 50 : 30))
                    })
                    
                    
                    //单选图片
                    let imgHeight = adapt_H(height: isPhone ? 20 : 15)
                    let imgFrame = CGRect(x: adapt_W(width: isPhone ? 5 : 3), y: (textHeight - imgHeight) / 2, width: imgHeight, height: imgHeight)
                    let imgView = baseVC.imageViewCreat(frame: imgFrame, image: UIImage(named: "forget_find_way2.png")!, highlightedImage: UIImage(named: "forget_find_way2.png")!)

                    imgView.tag = RegisterTag.maleImgTag.rawValue + genderBtnIndex
                    genderBtn.addSubview(imgView)
                    imgView.mas_makeConstraints({ (make) in
                        _ = make?.top.equalTo()(adapt_H(height: isPhone ? 10 : 6))
                        _ = make?.left.equalTo()(adapt_H(height: isPhone ? 10 : 6))
                        _ = make?.width.equalTo()(imgHeight)
                        _ = make?.height.equalTo()(imgHeight)
                    })
                    
                    //男女文字
                    let genderLabel = baseVC.labelCreat(frame: genderFrame, text: genderBtnIndex == 0 ? "男" : "女", aligment: .center, textColor: .colorWithCustom(r: 253, g: 129, b: 114), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 14 : 10))
                    genderLabel.tag = RegisterTag.maleLabelTag.rawValue + genderBtnIndex
                    genderBtn.addSubview(genderLabel)
                    genderLabel.mas_makeConstraints({ (make) in
                        _ = make?.top.equalTo()
                        _ = make?.left.equalTo()(imgView.mas_right)?.setOffset(adapt_W(width: isPhone ? -5 : -2))
                        _ = make?.height.equalTo()(genderBtn.mas_height)
                        _ = make?.width.equalTo()(genderBtn.mas_height)
                    })
                    if genderBtnIndex == 0 {
                        imgView.image = UIImage(named: "forget_find_way1.png")
                        genderLabel.textColor = UIColor.colorWithCustom(r: 255, g: 192, b: 0)
                    }
                    
                }
            }
        
            //验证码重新布局
            if i == labelTextArray.count - 1 {
                let leftImg = UIImageView(image: UIImage(named: ""))
                textImg.addSubview(leftImg)
                leftImg.tag = RegisterTag.verifyImgTag.rawValue
                leftImg.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.registerTapAct(sender:)))
                leftImg.addGestureRecognizer(tap)
                textImg.isUserInteractionEnabled = true
                leftImg.mas_remakeConstraints({ (make) in
                    _ = make?.top.equalTo()
                    _ = make?.bottom.equalTo()
                    _ = make?.left.equalTo()(adapt_W(width: isPhone ? 10 : 6))
                    _ = make?.right.equalTo()(line.mas_right)?.setOffset(adapt_W(width: -3))
                })
            }
            //添加右侧视图:红色错误提示文字
            let alertLabel = UILabel()
            alertLabel.frame = CGRect(x: textField.frame.width - adapt_W(width: isPhone ? 80 : 60), y: 0, width: adapt_W(width: isPhone ? 90 : 65), height: adapt_H(height: isPhone ? 20 : 15))
            setLabelProperty(label: alertLabel, text: self.model.alertLabelText[i], aligenment: .right, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .clear, font: fontAdapt(font: isPhone ? 12 : 8))
            alertLabel.tag = RegisterTag.infoAlertLabelTag.rawValue + i
            textField.rightView = alertLabel
            textField.rightViewMode = .always
            alertLabel.isHidden = true   
        }
        
        
        
        
        //register button
        let regLeftDis = adapt_W(width: isPhone ? 50 : 120)
        let registerFrame = CGRect(x: regLeftDis, y: adapt_H(height: (isPhone ? 80 : 50) + (isPhone ? 48 : 30) * CGFloat(9)), width: width - 2 * regLeftDis, height: adapt_H(height: isPhone ? 40 : 30))
        let registerBtn = baseVC.buttonCreat(frame: registerFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"login_button_back1.png"), hightImage: UIImage(named:"login_button_back2.png"), backgroundColor: .clear, fonsize: fontAdapt(font: 17), events: .touchUpInside)
        self.addSubview(registerBtn)
        registerBtn.clipsToBounds = true
        //下部渐变背景
        let gradientLayer = CAGradientLayer.GradientLayer(topColor: UIColor.colorWithCustom(r: 255, g: 186, b: 0), buttomColor: UIColor.colorWithCustom(r: 239, g: 129, b: 0))
        gradientLayer.frame = CGRect(x: 0, y: 0, width: registerFrame.width, height: registerFrame.height)
        registerBtn.layer.insertSublayer(gradientLayer, at: 0)
        registerBtn.layer.cornerRadius = adapt_W(width: isPhone ? 4 : 3)
        registerBtn.tag = RegisterTag.registerBtnTag.rawValue
        let loginLabelFrame = CGRect(x: 0, y: 0, width: registerFrame.width, height: registerFrame.height)
        let loginLabel = baseVC.labelCreat(frame: loginLabelFrame, text:  "注   册", aligment: .center, textColor: .white, backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 19 : 12))
        registerBtn.addSubview(loginLabel)
        
        
        //login button
            
        let btnFrame = CGRect(x: adapt_W(width: 60), y: adapt_H(height: (isPhone ? 80 : 50) + (isPhone ? 48 : 30) * CGFloat(10)), width: width - 2 * adapt_W(width: 60), height: adapt_H(height: isPhone ? 30 : 20))
        let button = baseVC.buttonCreat(frame: btnFrame, title: "已有鸿福娱乐帐号，请登录", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 14 : 10), events: .touchUpInside)
        self.addSubview(button)
        button.tag = RegisterTag.loginBtnTag.rawValue
        button.setTitleColor(UIColor.colorWithCustom(r: 253, g: 129, b: 114), for: .normal)
        //增加下划线
//        let str = "已有鸿福娱乐帐号，请登录"
//        let attributedString = NSMutableAttributedString(string:"")
//        let attrs = [NSFontAttributeName : UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 14.0 : 10.0)),
//                         NSForegroundColorAttributeName : UIColor.colorWithCustom(r: 253, g: 129, b: 114),
//                         NSUnderlineStyleAttributeName : 1] as [String : Any]
//        let Setstr = NSMutableAttributedString.init(string: str, attributes: attrs)
//        attributedString.append(Setstr)
//        button.setAttributedTitle(attributedString, for: .normal)
    }
    
    
    
    
    var pickerView:UIView!
    var picker:UIPickerView!
    var currentTextField:UITextField!
    func initUIPickerView(textField:UITextField) {
        tlPrint(message: "initUIPickerView")
        textField.text = "1985/01/01"
        currentTextField = textField
        self.endEditing(true)
        let pickerWidth = width
        let pickerHeight = adapt_H(height: isPhone ? 150 :100)
        let pickerBtnHeight = adapt_H(height: isPhone ? 50 : 30)
        if pickerView != nil {
            pickerView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
            self.pickerView.frame = CGRect(x: (self.width - pickerWidth!) / 2, y: self.height - pickerHeight - pickerBtnHeight, width: pickerWidth!, height: pickerHeight)
            })
            return
        }
        pickerView = UIView(frame: CGRect(x: (width - pickerWidth!) / 2, y: height, width: self.width - adapt_W(width: isPhone ? 60 : 100), height: pickerHeight))

        self.addSubview(pickerView)
        
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: pickerWidth!, height: pickerHeight))
        picker.backgroundColor = UIColor(white: 1, alpha: 1)
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(45, inComponent: 0, animated: true)
        picker.selectRow(7, inComponent: 1, animated: true)
        picker.selectRow(14, inComponent: 2, animated: true)
        pickerView.addSubview(picker)
        
        //confirm button
        let confirmFrame = CGRect(x: 0, y: picker.frame.height, width: pickerWidth!, height: pickerBtnHeight)
        
        let confirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "确   定", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 255, g: 186, b: 0), fonsize: fontAdapt(font: 17), events: .touchUpInside)
        confirmBtn.tag = RegisterTag.birthdayPikerConfirmBtnTag.rawValue
        pickerView.addSubview(confirmBtn)

        
        UIView.animate(withDuration: 0.5, animations: {
            self.pickerView.frame = CGRect(x: self.pickerView.frame.origin.x, y: self.height - pickerHeight - pickerBtnHeight, width: self.pickerView.frame.width, height: pickerHeight)
        })
    }
    
    
    func hiddenPikerView() -> Void {
        self.frame = CGRect(x: 0, y:0, width: width, height: height)
        if self.pickerView != nil {
            UIView.animate(withDuration: 0.5, animations: {
                self.pickerView.frame = CGRect(x: self.pickerView.frame.origin.x
                    , y: self.height, width: self.pickerView.frame.width, height: self.height - adapt_H(height: 400))
            }, completion: { (finished) in
                self.pickerView.isHidden = true
                self.picker.selectRow(45, inComponent: 0, animated: true)
                self.picker.selectRow(0, inComponent: 1, animated: true)
                self.picker.selectRow(0, inComponent: 2, animated: true)
            })
        }
    }
    
    //pickerView 代理
    let dateArray:[[String]] = [["1940","1941","1942","1943","1944","1945","1946","1947","1948","1949","1950","1951","1952","1953","1954","1955","1956","1957","1958","1959","1960","1961","1962","1963","1964","1965","1966","1967","1968","1969","1970","1971","1972","1973","1974","1975","1976","1977","1978","1979","1980","1981","1982","1983","1984","1985","1986","1987","1988","1989","1990","1991","1992","1993","1994","1995","1996","1997","1998","1999"],
                                ["01","02","03","04","05","06","07","08","09","10","11","12"],
                                ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]]
    let pickerUnit = ["年","月","日"]
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        tlPrint(message: "pickerView")
        return dateArray[component].count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        tlPrint(message: "numberOfComponents")
        return dateArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        tlPrint(message: "titleForRow")
        return "\(dateArray[component][row])\(pickerUnit[component])"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tlPrint(message: "didSelectRow")
        tlPrint(message: "\(dateArray[component][row])")
        
        let oldDate = currentTextField.text
        var singleDate:[String] = oldDate!.components(separatedBy: "/")
        
        singleDate[component] = String(dateArray[component][row])
        let newDate = singleDate[0] + "/" + singleDate[1] + "/" + singleDate[2]
        currentTextField.text = newDate
    }
    
    
    
    
    @objc func registerTapAct(sender:UITapGestureRecognizer) -> Void {
        tlPrint(message: "registerTapAct")
        self.tapDelegate.registerTapAct(sender: sender)
    }
    
    @objc func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct sender.tag:\(sender.tag)")

            delegate.btnAct(btnTag: sender.tag)
        
        
    }

}
