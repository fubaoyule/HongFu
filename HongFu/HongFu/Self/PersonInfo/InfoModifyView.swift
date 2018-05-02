//
//  InfoModifyView.swift
//  FuTu
//
//  Created by Administrator1 on 15/1/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit



class InfoModifyView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var delegate:BtnActDelegate!
    var textFieldDelegate: UITextFieldDelegate!
    var width,height: CGFloat!
    let model = PersonModel()
    var infoTable:UITableView!
    var tableDelegate: UITableViewDelegate!
    var tableDataSource: UITableViewDataSource!
    var textIndex:Int! = 3
    var currentTabBtn:UIButton!
    var currentTabLine:UIView!
    var modifyType:ModifyType!
    let baseVC = BaseViewController()
    init(frame:CGRect,modifyType:ModifyType, textIndex:Int?,rootVC:UIViewController) {
        super.init(frame: frame)
        
        self.width = frame.width
        self.height = frame.height
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        if textIndex != nil {
            self.textIndex = textIndex
        }
        self.modifyType = modifyType
        self.delegate = rootVC as! BtnActDelegate
        self.textFieldDelegate = rootVC as! UITextFieldDelegate
        self.tableDelegate = rootVC as! UITableViewDelegate
        self.tableDataSource = rootVC as! UITableViewDataSource
        initNavigation()
        
        switch modifyType {
        case .edit:
            tlPrint(message: "编辑资料")
            initInfoTable()
        case .bind:
            tlPrint(message: "绑定资料")
            initInputView()
        case .password:
            tlPrint(message: "更改密码")
            initPWModifyView()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initNavigation() -> Void {
        
        tlPrint(message: "initNavigation")
        let navFrame = CGRect(x: 0, y: 0, width: width, height: 64)
        let navView = baseVC.viewCreat(frame: navFrame, backgroundColor: .colorWithCustom(r: 27, g: 123, b: 233))
        
        let gradientLayer = CAGradientLayer.GradientLayer(topColor: UIColor.colorWithCustom(r: 65, g: 50, b: 48), buttomColor: UIColor.colorWithCustom(r: 43, g: 38, b: 34))
        gradientLayer.frame = navView.frame
        navView.layer.insertSublayer(gradientLayer, at: 0)
        self.addSubview(navView)
        //title label
        let titleFrame = CGRect(x: 0, y: 20, width: width, height: 40)
        let titleLabel = baseVC.labelCreat(frame: titleFrame, text: "资料更改", aligment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 17 : 12))
        
        navView.addSubview(titleLabel)
        
        //back button
        let backFrame = CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight)
        let backBtn = baseVC.buttonCreat(frame: backFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        navView.addSubview(backBtn)
        backBtn.tag = modifyViewTag.backBtnTag.rawValue
        //back button image
//        let backBtnImg = UIImageView(frame: CGRect(x: 10, y: 12, width: 12, height: 20))
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
        
        if self.modifyType == ModifyType.bind {
            tlPrint(message: "绑定界面无须保存")
            titleLabel.text = "资料绑定"
            return
        } else if self.modifyType == ModifyType.password {
            tlPrint(message: "密码更改无须保存")
            titleLabel.text = "密码更改"
            return
        }
        
        //save button
        let saveFrame = CGRect(x: width - adapt_W(width: isPhone ? 80 : 40), y: navFrame.height - adapt_H(height: 28), width: adapt_W(width: isPhone ? 80 : 60), height: adapt_H(height: isPhone ? 20 : 12))
        let saveBtn = baseVC.buttonCreat(frame: saveFrame, title: "保存", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 14 : 10), events: .touchUpInside)
        navView.addSubview(saveBtn)
        saveBtn.tag = modifyViewTag.saveBtnTag.rawValue
        saveBtn.setTitleColor(UIColor.colorWithCustom(r: 255, g: 192, b: 0), for: .normal)
        saveBtn.center.y = titleLabel.center.y
    }
    
    
    
    func initInfoTable() -> Void {
        let tableY = 64 + adapt_H(height: 6)
        infoTable = UITableView(frame: CGRect(x: 0, y: tableY, width: width, height: height - tableY))
        self.addSubview(infoTable)
        //infoTable.separatorStyle = .singleLine
        infoTable.separatorColor = UIColor.clear
        infoTable.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        infoTable.delegate = self.tableDelegate
        infoTable.dataSource = self.tableDataSource
    }
    
    
    
    func initInputView() -> Void {
        tlPrint(message: "initInputView")
        //view
        let backFrame = CGRect(x: adapt_W(width: 20), y: 64 + adapt_H(height: 60), width: width - adapt_W(width: 40), height: adapt_H(height: 100))
        let backView = baseVC.viewCreat(frame: backFrame, backgroundColor: .white)
        self.addSubview(backView)
        backView.layer.cornerRadius = adapt_W(width: 10)
        //phone number input text
        let phoneFrame = CGRect(x: 0, y: 0, width: backFrame.width, height: adapt_H(height: 50))
        var textInfo:String! = ""
        if model.infoLabel[textIndex] == "手机号码" {
            
            let phoneNumber = userDefaults.value(forKey: userDefaultsKeys.userInfoMobile.rawValue)
            if let textInfo_t = phoneNumber {
                textInfo = textInfo_t as! String
            }
        } else {
            let emailNumber = userDefaults.value(forKey: userDefaultsKeys.userInfoEmail.rawValue)
            if let textInfo_t = emailNumber {
                textInfo = textInfo_t as! String
            }
        }
        let phoneFeild = baseVC.textFieldCreat(frame: phoneFrame, placeholderText: "请输入\(model.infoLabel[textIndex])", aligment: .left, fonsize: fontAdapt(font: 14), borderWidth: adapt_W(width: 0.5), borderColor: .colorWithCustom(r: 226, g: 227, b: 231), tag: modifyViewTag.textFeildTag.rawValue)
        backView.addSubview(phoneFeild)
        phoneFeild.text = textInfo
        let labelFrame = CGRect(x: adapt_W(width: 20), y: 0, width: adapt_W(width: 80), height: backFrame.height)
        let label = baseVC.labelCreat(frame: labelFrame, text: model.infoLabel[textIndex], aligment: .center, textColor: .colorWithCustom(r: 129, g: 129, b: 129), backgroundcolor: .clear, fonsize: fontAdapt(font: 14))
        
        phoneFeild.leftViewMode = .always
        phoneFeild.leftView = label
        phoneFeild.tag = personBtnTag.InfoVerifyTextFieldTag.rawValue
        
        let rightView = UIView(frame: CGRect(x: phoneFrame.width - adapt_W(width: 100), y: 0, width: adapt_W(width: 100), height: phoneFrame.height))
        phoneFeild.rightViewMode = .always
        phoneFeild.rightView = rightView
        phoneFeild.delegate = self.textFieldDelegate
        phoneFeild.keyboardType = .emailAddress
        
        let imageFrame = CGRect(x: adapt_W(width: 60), y: adapt_W(width: 20), width: adapt_W(width: 22), height: adapt_W(width: 22))
        let image = UIImageView(frame: imageFrame)
        image.center.y = rightView.center.y
        rightView.addSubview(image)
        image.image = UIImage(named: "person_varify_success.png")
        image.isHidden = true
        image.tag = personBtnTag.RightImageTag.rawValue
        //手机号或则邮箱不能用的时候，不弹出图片，弹出红色提示文字
        let alertLable = UILabel(frame: CGRect(x: 0, y: 0, width: rightView.frame.width, height: rightView.frame.height))
        rightView.addSubview(alertLable)
        setLabelProperty(label: alertLable, text: "该号码不可用", aligenment: .center, textColor: .red, backColor: .clear, font: fontAdapt(font: 10))
        alertLable.isHidden = true
        alertLable.tag = personBtnTag.AlertLableTag.rawValue
        
        //验证码输入框
        let varifyFrame = CGRect(x: 0, y: phoneFrame.height, width: backFrame.width, height: adapt_H(height: 50))
        let varifyFeild = baseVC.textFieldCreat(frame: varifyFrame, placeholderText: "请输入验证码", aligment: .left, fonsize: fontAdapt(font: 14), borderWidth: adapt_W(width: 0.5), borderColor: .colorWithCustom(r: 226, g: 227, b: 231), tag: modifyViewTag.textFeildTag.rawValue)
        backView.addSubview(varifyFeild)
        let varifyLabelFrame = CGRect(x: adapt_W(width: 20), y: 0, width: adapt_W(width: 80), height: backFrame.height)
        let varifyLabel = baseVC.labelCreat(frame: varifyLabelFrame, text: "验证码", aligment: .center, textColor: .colorWithCustom(r: 129, g: 129, b: 129), backgroundcolor: .clear, fonsize: fontAdapt(font: 14))
        
        varifyFeild.leftViewMode = .always
        varifyFeild.leftView = varifyLabel
        varifyFeild.delegate = self.textFieldDelegate
        varifyFeild.tag = personBtnTag.InfoVerifyCodeFieldTag.rawValue
        //        varifyFeild.isUserInteractionEnabled = false
        
        
        let codeBtnFrame = CGRect(x: varifyFrame.width - adapt_W(width: 100), y: 0, width: adapt_W(width: 100), height: varifyFrame.height)
        let codeBtn = baseVC.buttonCreat(frame: codeBtnFrame, title: "获取验证码", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: 14), events: .touchUpInside)
        codeBtn.tag = personBtnTag.GetVerifyCodeButton.rawValue
        codeBtn.setTitleColor(UIColor.colorWithCustom(r: 186, g: 9, b: 31), for: .normal)
        codeBtn.layer.borderColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231).cgColor
        codeBtn.layer.borderWidth = adapt_W(width: 0.5)
        varifyFeild.rightView = codeBtn
        varifyFeild.rightViewMode = .always
        varifyFeild.keyboardType = .phonePad
        
        //finish verify button
        let finishBtnFrame = CGRect(x: adapt_W(width: 20), y: adapt_W(width: 250), width: width - adapt_W(width: 40), height: varifyFrame.height)
        let finishBtn = baseVC.buttonCreat(frame: finishBtnFrame, title: "完成验证", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 169, g: 169, b: 169), fonsize: fontAdapt(font: 16), events: .touchUpInside)
        finishBtn.tag = personBtnTag.finishVerifyButton.rawValue
        self.addSubview(finishBtn)
        finishBtn.layer.cornerRadius = adapt_W(width: 10)
        finishBtn.isUserInteractionEnabled = false
        //.colorWithCustom(r: 27, g: 123, b: 233)
    }
    
    
    
    func initPWModifyView() -> Void {
        tlPrint(message: "initPWModifyView")
        let textFeildLabel = ["输入旧密码","输入新密码","再次输入"]
        let textFeildY:[[CGFloat]] = [[80,40],[135,75],[185,105]]
        let textFeildWidth = width - adapt_W(width: isPhone ? 0 : 100)
        for i in 0 ..< 3 {
        
            //password input text
            let textFeildFrame = CGRect(x: (width - textFeildWidth) / 2, y: adapt_H(height: isPhone ? textFeildY[i][0] : textFeildY[i][1]) , width: textFeildWidth, height: adapt_H(height: isPhone ? 50 : 30))
            
            let passwordFeild = baseVC.textFieldCreat(frame: textFeildFrame, placeholderText: model.passwordInfoLabel[i], aligment: .left, fonsize: fontAdapt(font: isPhone ? 14 : 10), borderWidth: adapt_W(width: 0.5), borderColor: .colorWithCustom(r: 226, g: 227, b: 231), tag: modifyViewTag.textFeildTag.rawValue)
            self.addSubview(passwordFeild)
            passwordFeild.backgroundColor = UIColor.white
            passwordFeild.isSecureTextEntry = true
            passwordFeild.keyboardType = UIKeyboardType.default
            passwordFeild.delegate = self.textFieldDelegate

            let labelFrame = CGRect(x: 0, y: 0, width: adapt_W(width: isPhone ? 100 : 80), height: textFeildFrame.height)
            let label = baseVC.labelCreat(frame: labelFrame, text: textFeildLabel[i], aligment: .center, textColor: .colorWithCustom(r: 129, g: 129, b: 129), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 14 : 10))
            passwordFeild.leftViewMode = .always
            passwordFeild.leftView = label
            passwordFeild.tag = personBtnTag.passwordModifyTextFieldTag.rawValue + i
            
            
            let rightView = UIView(frame: CGRect(x: textFeildFrame.width - textFeildFrame.height, y: 0, width: textFeildFrame.height, height: textFeildFrame.height))
            rightView.backgroundColor = UIColor.clear
            passwordFeild.rightViewMode = .always
            passwordFeild.rightView = rightView
            
            
            
            
            let imageFrame = CGRect(x: adapt_W(width: 0), y: adapt_W(width: 0), width: adapt_W(width: isPhone ? 25 : 20), height: adapt_W(width: isPhone ? 25 : 20))
            let image = UIImageView(frame: imageFrame)
            image.isUserInteractionEnabled = true
            
            image.center.y = rightView.center.y
            rightView.addSubview(image)
            image.image = UIImage(named: "register_pass_eye1.png")
            image.isHidden = false
            image.tag = personBtnTag.passwordModifyRightImageTag.rawValue + i
            let tapGeutrue = UITapGestureRecognizer(target: self, action: #selector(self.tapGuestureAct(tap:)) )
            image.addGestureRecognizer(tapGeutrue)
            
//            //手机号或则邮箱不能用的时候，不弹出图片，弹出红色提示文字
//            let alertLable = UILabel(frame: CGRect(x: 0, y: 0, width: rightView.frame.width, height: rightView.frame.height))
//            rightView.addSubview(alertLable)
//            setLabelProperty(label: alertLable, text: "该号码不可用", aligenment: .center, textColor: .red, backColor: .clear, font: fontAdapt(font: 10))
//            alertLable.isHidden = true
//            alertLable.tag = personBtnTag.AlertLableTag.rawValue
            
            
            //确认按钮
            
            let confirmBtnFrame = CGRect(x: adapt_W(width: isPhone ? 20 : 80), y: adapt_W(width: isPhone ? 300 : 200), width: width - adapt_W(width: isPhone ? 40 : 160), height: adapt_W(width: isPhone ? 50 : 30))
            let confirmBtn = baseVC.buttonCreat(frame: confirmBtnFrame, title: "确  认", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: UIColor.colorWithCustom(r: 186, g: 9, b: 31), fonsize: fontAdapt(font: isPhone ? 17 : 12), events: .touchUpInside)
            self.addSubview(confirmBtn)
            confirmBtn.tag = personBtnTag.passwordModifyConfirmBtnTag.rawValue
            confirmBtn.layer.cornerRadius = adapt_W(width: isPhone ? 5 : 3)
            
        }
        
    }
    var eyeImgOpenStatus = [false,false,false]
    @objc func tapGuestureAct(tap:UITapGestureRecognizer) -> Void {
        tlPrint(message: "tapGuestureAct tap.view.tag:\(String(describing: tap.view?.tag))")
        let index = tap.view!.tag - personBtnTag.passwordModifyRightImageTag.rawValue
        let eyeImg = self.viewWithTag(tap.view!.tag) as! UIImageView
        eyeImg.image = UIImage(named: eyeImgOpenStatus[index] ? "register_pass_eye1.png" : "register_pass_eye2.png")
        eyeImgOpenStatus[index] = !eyeImgOpenStatus[index]
        
        let textField = self.viewWithTag(personBtnTag.passwordModifyTextFieldTag.rawValue + index) as! UITextField
        textField.isSecureTextEntry = !eyeImgOpenStatus[index]
        
    }
    
    
    var pickerView:UIView!
    var picker:UIPickerView!
    var currentTextField:UITextField!
    func initUIPickerView(textField:UITextField) {
        tlPrint(message: "initUIPickerView")
        //先修改textField的日期为今日日期
        //let currentDate:String = NSDate.getDate(type: .all)
        textField.text = "1985/01/01"
        currentTextField = textField
        tlPrint(message: "initUIPickerView")
        if pickerView != nil {
            pickerView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.pickerView.frame = CGRect(x: 0, y: adapt_H(height: 400), width: self.width, height: self.height - adapt_H(height: 400))
            })
            return
        }
        
        pickerView = UIView(frame: CGRect(x: 0, y: height, width: width, height: height - adapt_H(height: 400)))
        self.addSubview(pickerView)
        
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.width, height: height - adapt_H(height: 450)))
        picker.backgroundColor = UIColor(white: 1, alpha: 1)
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(45, inComponent: 0, animated: true)
        picker.selectRow(0, inComponent: 1, animated: true)
        picker.selectRow(0, inComponent: 2, animated: true)
        pickerView.addSubview(picker)
        
        //confirm button
        let confirmFrame = CGRect(x: 0, y: picker.frame.height, width: width, height: adapt_H(height: 50))
        
        let confirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "确   定", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: UIColor.colorWithCustom(r: 186, g: 9, b: 31), fonsize: fontAdapt(font: 17), events: .touchUpInside)
        confirmBtn.tag = tradeSearchTag.DateSelectConfirmBtnTag.rawValue
        pickerView.addSubview(confirmBtn)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.pickerView.frame = CGRect(x: 0, y: adapt_H(height: 400), width: self.width, height: self.height - adapt_H(height: 400))
        })
    }
    
    
    func hiddenPikerView() -> Void {
        if self.pickerView != nil {
            UIView.animate(withDuration: 0.5, animations: {
                self.pickerView.frame = CGRect(x: 0, y: self.height, width: self.width, height: self.height - adapt_H(height: 400))
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
    
    @objc func btnAct(sender:UIButton) -> Void {
        var password = ["","",""]
        tlPrint(message: "btnAct sender.tag = \(sender.tag)")
        if sender.tag == personBtnTag.passwordModifyConfirmBtnTag.rawValue {
            for i in 0 ..< 3 {
                let textField = self.viewWithTag(personBtnTag.passwordModifyTextFieldTag.rawValue + i) as! UITextField
                //没有完全输入
                if textField.text == nil || textField.text == "" {
                    let alert = UIAlertView(title: "输入错误", message: "请\(model.passwordInfoLabel[i])", delegate: nil, cancelButtonTitle: "好 的")
                    alert.show()
                    return
                }
                //旧密码不正确
                let oldPassword = userDefaults.value(forKey: userDefaultsKeys.passWord.rawValue) as! String
                if i == 0 && textField.text != oldPassword {
                    let alert = UIAlertView(title: "输入错误", message: "请输入正确的旧密码", delegate: nil, cancelButtonTitle: "重新输入")
                    alert.show()
                    return
                }
                //存储新密码

                password[i] = textField.text!
                
            }
            
            //新密码不一致
            if password[1] != password[2] {
                let alert = UIAlertView(title: "输入错误", message: "两次密码输入不一致", delegate: nil, cancelButtonTitle: "重新输入")
                alert.show()
                return
            }
            //修旧密码相同
//            if password[0] == password[1] {
//                let alert = UIAlertView(title: "提 示", message: "新密码不能与旧密码相同！", delegate: nil, cancelButtonTitle: "重新输入")
//                alert.show()
//                return
//            }
            //验证新密码是否合规
            let infoVerify = InfoVerify()
            if !infoVerify.PasswordIsValidated(vStr: password[1]) {
                let alert = UIAlertView(title: "输入错误", message: "新密码格式不正确", delegate: nil, cancelButtonTitle: "重新输入")
                alert.show()
                return
            }
        }
        delegate.btnAct(btnTag: sender.tag)
    }
}
