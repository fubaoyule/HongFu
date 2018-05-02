//
//  PersonView.swift
//  FuTu
//
//  Created by Administrator1 on 19/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class PersonView: UIView {

    
    var delegate: personDelegate!
    var textFeildDelegate: UITextFieldDelegate!
    var scroll: UIScrollView!
    var personBtn,bankBtn: UIButton!
    var width,height: CGFloat!
    let model = PersonModel()
 
    let baseVC = BaseViewController()
    
    init(frame:CGRect, param:AnyObject,rootVC:UIViewController) {
        super.init(frame: frame)
        self.width = frame.width
        self.height = frame.height
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        textFeildDelegate = rootVC as! UITextFieldDelegate
        
        initNavigationBar()
        initScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initNavigationBar() -> Void {
        //view
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20 + navBarHeight))
        self.addSubview(navigationView)
        let gradientLayer = CAGradientLayer.GradientLayer(topColor: UIColor.colorWithCustom(r: 65, g: 50, b: 48), buttomColor: UIColor.colorWithCustom(r: 43, g: 38, b: 34))
        gradientLayer.frame = navigationView.frame
        navigationView.layer.insertSublayer(gradientLayer, at: 0)
        //label
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: width, height: navBarHeight))
        setLabelProperty(label: titleLabel, text: "个人资料", aligenment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .clear, font: 17)
        navigationView.addSubview(titleLabel)
        
        
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        navigationView.addSubview(backBtn)
        backBtn.tag = personBtnTag.BackButton.rawValue
        //back button image
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
        
        //闪退点
        if let infoHasBind = userDefaults.value(forKey: userDefaultsKeys.userInfoIsBasicBound.rawValue) {
            if !(infoHasBind as! Bool) {
                // edit button
//                let editFrame = CGRect(x: width - adapt_W(width: isPhone ? 80 : 40), y: adapt_H(height: 10) + 20, width: adapt_W(width: isPhone ? 80 : 60), height: adapt_H(height: isPhone ? 20 : 12))
                
                let editFrame = CGRect(x: width - adapt_W(width: isPhone ? 80 : 40), y: navigationView.frame.height - adapt_H(height: 28), width: adapt_W(width: isPhone ? 80 : 60), height: adapt_H(height: isPhone ? 20 : 12))
                let editBtn = baseVC.buttonCreat(frame: editFrame, title: "编辑资料", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 14 : 9), events: .touchUpInside)
                editBtn.setTitleColor(.colorWithCustom(r: 255, g: 192, b: 0), for: .normal)
                navigationView.addSubview(editBtn)
                editBtn.tag = personBtnTag.InfoEditButton.rawValue
            }
        }
        
        //subTitle
        //person button
        let personFrame = CGRect(x: 0, y: navigationView.frame.height, width: width / 2, height: adapt_H(height: model.subTitleHeight))
        personBtn = baseVC.buttonCreat(frame: personFrame , title: "个人信息", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: model.subTitleBackColor, fonsize: fontAdapt(font: isPhone ? 16 : 10), events: .touchUpInside)
        self.addSubview(personBtn)
        //personBtn.tag = personBtnTag.PersonInfoButton.rawValue
        personBtn.setTitleColor(model.subTitleBtnColor1, for: .highlighted)
        personBtn.setTitleColor(model.subTitleBtnColor2, for: .normal)
        //person button blue line
        let lineHeight:CGFloat = isPhone ? 4 : 2
        let lineWidth:CGFloat = isPhone ? 70 : 45
        let personLine = UIView(frame: CGRect(x: width / 4 - adapt_W(width: lineWidth / 2), y: adapt_H(height: model.subTitleHeight - lineHeight), width: adapt_W(width: lineWidth), height: adapt_H(height: lineHeight)))
        personBtn.addSubview(personLine)
        personLine.layer.cornerRadius = adapt_W(width: lineHeight / 2)
        personLine.backgroundColor = model.subTitleBtnColor2
        
        //bank card button
        let bankFrame = CGRect(x: width / 2, y: navigationView.frame.height, width: width / 2, height: adapt_H(height: model.subTitleHeight))
        bankBtn = baseVC.buttonCreat(frame: bankFrame , title: "银行卡", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: model.subTitleBackColor, fonsize: fontAdapt(font: isPhone ? 16 : 10), events: .touchUpInside)
        self.addSubview(bankBtn)
        bankBtn.tag = personBtnTag.BankCardButton.rawValue
        bankBtn.setTitleColor(model.subTitleBtnColor1, for: .highlighted)
        bankBtn.setTitleColor(model.subTitleBtnColor1, for: .normal)
        
        //person button blue line
        let bankLine = UIView(frame: CGRect(x: width / 4 - adapt_W(width: lineWidth / 2), y: adapt_H(height: model.subTitleHeight - lineHeight), width: adapt_W(width: lineWidth), height: adapt_H(height: 4)))
        bankBtn.addSubview(bankLine)
        bankLine.layer.cornerRadius = adapt_W(width: lineHeight / 2)
        bankLine.backgroundColor = model.subTitleBackColor
        
    }
    
    
    func initScrollView() -> Void {
        scroll = UIScrollView(frame: CGRect(x: 0, y: 20 + navBarHeight + adapt_H(height: model.subTitleHeight), width: width, height: CGFloat(model.infoLabel.count) * adapt_H(height: model.infoColumHeight)))
        self.addSubview(scroll)
        
        scroll.contentSize = CGSize(width: frame.width, height: scroll.frame.height + 1)
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.backgroundColor = UIColor.white
        self.addSubview(scroll)
    
        for i in 0 ..< model.infoLabel.count - 2 {
            let colum = UIView(frame: CGRect(x: 0, y: CGFloat(i) * adapt_H(height: model.infoColumHeight), width: width, height: adapt_H(height: model.infoColumHeight)))
            scroll.addSubview(colum)
            //image
            let imgHeight:CGFloat = adapt_H(height: isPhone ? 32 : 24)
            let img = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 15 : 27), y: (adapt_H(height: model.infoColumHeight) - imgHeight) / 2, width: imgHeight, height: imgHeight))
            colum.addSubview(img)
            img.image = UIImage(named: "person_Info_\(i).png")
            
            //text 
            let textWord = model.infoLabel[i] as NSString
            let balanceTextWordSize = textWord.size(withAttributes: [NSAttributedStringKey.font :  UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 14 : 10))])
            
            let textLabel = UILabel(frame: CGRect(x: adapt_W(width: 56), y: 0, width:  balanceTextWordSize.width + adapt_W(width: 5), height: adapt_H(height: model.infoColumHeight)))
            colum.addSubview(textLabel)
            setLabelProperty(label: textLabel, text: model.infoLabel[i], aligenment: .center, textColor: .colorWithCustom(r: 129, g: 129, b: 129), backColor: .clear, font: fontAdapt(font: isPhone ? 14 : 10))

            if i < model.infoLabel.count - 2 {
                //info value
                let valueFrame = CGRect(x: balanceTextWordSize.width + adapt_W(width: 56 + 15), y: adapt_H(height: 2), width: adapt_W(width: 250), height: adapt_H(height: model.infoColumHeight))
                
                let valueTextField = baseVC.textFieldCreat(frame: valueFrame, placeholderText:"", aligment: .left, fonsize: fontAdapt(font: isPhone ? 16 : 10), borderWidth: 0, borderColor: .clear, tag: 0)
                colum.addSubview(valueTextField)
                valueTextField.isUserInteractionEnabled = false
                valueTextField.delegate = textFeildDelegate
                
                let infoKey = ["RealName","BirthDate","RegisterTime","Mobile","Email","QQ","Wechat","","",""]
                var info = userDefaults.value(forKey: "userInfo\(infoKey[i])")
                if info == nil {
                    tlPrint("未能获取到用户信息: i = \(i) -> \(infoKey[i])")
                    info = "    "
                }
                //真实姓名处理(只显示第一个字符)
                if i == 0 {
                    if let realName_t = info {
                        let realName = realName_t as! String
                        var showName = realName.substring(to: realName.index(realName.startIndex, offsetBy: 1))
                        for _ in 0 ..< realName.characters.count - 1 {
                            showName.append("*")
                        }
                        //showName.append(realName.substring(from: realName.index(realName.endIndex, offsetBy: -1)))
                        info = showName
                    }
                }
                //报错
                //注册时间处理
                if i == 2 {
                    tlPrint("用户生日 info:\(info)")

                    let infos = (info as! String).components(separatedBy: " ")
                    info = infos[0]
                }
                if info != nil {
                    valueTextField.text = "\(info!)"
                } else {
                    valueTextField.text = ""
                }
                
                valueTextField.textColor = UIColor.colorWithCustom(r: 35, g: 35, b: 35)
                valueTextField.isUserInteractionEnabled = false
                
                //手机号和邮箱需要判断是否绑定
                if let isPhoneBind_t = userDefaults.value(forKey: userDefaultsKeys.userInfoIsPhoneBound.rawValue) {
                    let isPhoneBind =  isPhoneBind_t as! Bool
                    if let isEmailBind_t = userDefaults.value(forKey: userDefaultsKeys.userInfoIsEmailBound.rawValue) {
                        
                        let isEmailBind = isEmailBind_t as! Bool
                        if (i == 3 && !isPhoneBind) || (i == 4 && !isEmailBind) || i == 7 {
                            
                            //next view button
                            let nextBtn = baseVC.buttonCreat(frame: valueFrame, title: "", alignment: .right, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
                            colum.addSubview(nextBtn)
                            nextBtn.tag = personBtnTag.InfoNextViewBtnTag.rawValue + i
                            
                            //img
                            let imgWidth = adapt_W(width: isPhone ? 25 : 15)
                            let img = UIImageView(frame: CGRect(x: valueFrame.width - adapt_W(width: isPhone ? 40 : 15), y:(valueFrame.height - imgWidth) / 2, width: imgWidth, height: imgWidth))
                            nextBtn.addSubview(img)
                            img.image = UIImage(named: "person_Info_nextIcon.png")
                            
                            
                            let bindFrame = CGRect(x: valueFrame.width - adapt_W(width: isPhone ? 80 : 40), y: 0, width: adapt_W(width: 70), height: valueFrame.height)
                            let bindLabel = baseVC.labelCreat(frame: bindFrame, text: i == 7 ? "" : "去绑定", aligment: .left, textColor: .colorWithCustom(r: 35, g: 35, b: 35), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 14 : 9))
                            nextBtn.addSubview(bindLabel)
                        }
                    }
                }
                
            } else {
                
            
            }
            //line 
            let line = UIView(frame:CGRect(x: textLabel.frame.origin.x, y: colum.frame.height, width: colum.frame.width - textLabel.frame.origin.x, height: adapt_H(height: 1)))
            line.backgroundColor = UIColor.colorWithCustom(r: 241, g: 241, b: 241)
            colum.addSubview(line)
            
        }
        
        //version label 
        let appVersion = SystemInfo.getCurrentVersion()
//        let versionFrame = CGRect(x: 0, y: adapt_H(height: isPhone ? 440 : 330), width: width, height: adapt_H(height: 30))
        let versionFrame = CGRect(x: 0, y: scroll.frame.height - adapt_H(height: isPhone ? 80 : 50), width: width, height: adapt_H(height: isPhone ? 30 : 20))
        let versionLabel = baseVC.labelCreat(frame: versionFrame, text: "当前版本：\(appVersion)", aligment: .center, textColor: .gray, backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 14 : 9))
        scroll.addSubview(versionLabel)
        
        
        
        //logout button
        let logOutHeight = adapt_H(height: isPhone ? 55 : 30)
        let logOutFrame = CGRect(x: 0, y: height - logOutHeight, width: width, height: logOutHeight)
        let logOutBtn = baseVC.buttonCreat(frame: logOutFrame, title: "退出登录", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .white, fonsize: fontAdapt(font: isPhone ? 17 : 10), events: .touchUpInside)
        logOutBtn.setTitleColor(UIColor.colorWithCustom(r: 245, g: 63, b: 0), for: .normal)
        logOutBtn.tag = personBtnTag.LogOutButton.rawValue
        self.addSubview(logOutBtn)
        
    }
    
    
    
    @objc func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct sender.tag = \(sender.tag)")
        
        delegate.persongBtnAct(btnTag: sender.tag)
    }
}
