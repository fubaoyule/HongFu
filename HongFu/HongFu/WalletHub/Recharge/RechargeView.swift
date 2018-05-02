
//
//  RechargeView.swift
//  FuTu
//
//  Created by Administrator1 on 27/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class RechargeView: UIView,UIPickerViewDelegate, UIPickerViewDataSource {

    
    var scroll: UIScrollView!
    var inputTextField,preferentialTextField:UITextField!
    var tableView:UIView!
    var delegate:BtnActDelegate!
    var textFieldDelegate: UITextFieldDelegate!
    var scrollDelegate: UIScrollViewDelegate!
    var width,height: CGFloat!
    let model = RechargeModel()
    var activityInfo:[Dictionary<String,Any>]!
    var activityCode:String = "no"
    var isFromTab = false
    var nextBtn:UIButton!
    var currentBtnTag = 0

    let baseVC = BaseViewController()
    init(frame:CGRect, isFromTab: Bool,rootVC:UIViewController) {
        super.init(frame: frame)
        
        self.width = frame.width
        self.height = frame.height
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        self.delegate = rootVC as! BtnActDelegate
        self.scrollDelegate = rootVC as! UIScrollViewDelegate
        self.textFieldDelegate = rootVC as! UITextFieldDelegate
        self.isFromTab = isFromTab
        initNavigationBar()
        initPayType()
        initInputTable()
        initNextBtn()
        initWarmingLabel()
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
        setLabelProperty(label: titleLabel, text: "充值中心", aligenment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .clear, font: 17)
        navigationView.addSubview(titleLabel)
        if self.isFromTab {
            return
        }
        
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        navigationView.addSubview(backBtn)
        backBtn.tag = rechargeTag.RechargeBackTag.rawValue
        //back button image
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
 
    }
    
    let payTypeBtnText = ["微信转微信","微信转银行","QQ扫码", "微信扫码", "支付宝扫码", "在线充值", "网银转账", "快捷支付"]
    
    func initPayType() -> Void {
        tlPrint(message: "initPayType")
        let typeFrame = CGRect(x: 0, y: 20 + navBarHeight, width: width, height: adapt_H(height: model.payTypeViewHeight))
        let payTypeView = baseVC.viewCreat(frame: typeFrame, backgroundColor: .white)
        payTypeView.backgroundColor = UIColor.colorWithCustom(r: 244, g: 244, b: 244)
        self.addSubview(payTypeView)
        
        //alert label
        let alertFrame = CGRect(x: adapt_W(width: isPhone ? 26 : 23), y: adapt_H(height: isPhone ? 15 : 13), width: adapt_W(width: 120), height: adapt_H(height: isPhone ? 15 : 10))
        let alertLabel = baseVC.labelCreat(frame: alertFrame, text: "选择支付方式：", aligment: .left, textColor: .colorWithCustom(r: 129, g: 129, b: 129), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 14 : 10))
        payTypeView.addSubview(alertLabel)
        
        for i in 0 ..< payTypeBtnText.count {
            let btnX = CGFloat(i % 4) * width / 4
            let btnY =  adapt_H(height: isPhone ? (45 + CGFloat(i / 4) * 90) : (40 + CGFloat(i / 4) * 70))
            let btnW = width / 4
            let btnH = adapt_H(height: 60)
            let buttonFrame = CGRect(x:btnX, y: btnY, width:btnW, height: btnH)
            let typeBtn = baseVC.buttonCreat(frame: buttonFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
            payTypeView.addSubview(typeBtn)
            typeBtn.tag = rechargeTag.WechatPayBtnTag.rawValue + i
            
            //image
            let img = UIImageView(frame: CGRect(x: (btnW - adapt_W(width: model.payImgWidth)) / 2, y: 0, width: adapt_W(width: model.payImgWidth), height: adapt_W(width: model.payImgWidth)))
            img.image = UIImage(named: "wallet_recharge_\(i)_0.png")
            typeBtn.addSubview(img)
            img.tag = rechargeTag.PayTypeImg.rawValue + i
            //text
            let textFrame = CGRect(x: 0, y: adapt_W(width: model.payImgWidth + 7), width: width / 4, height: adapt_H(height: 15))
            let btnText = baseVC.labelCreat(frame: textFrame, text: payTypeBtnText[i], aligment: .center, textColor: .colorWithCustom(r: 161, g: 161, b: 161), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 13 : 9))
            typeBtn.addSubview(btnText)
            btnText.tag = rechargeTag.PayTypeText.rawValue + i
            //默认在线充值
            if i == 0 {
                img.image = UIImage(named: "wallet_recharge_\(i)_1.png")
                btnText.textColor = UIColor.colorWithCustom(r: 35, g: 35, b: 35)
            }
        }
    }
    
    
    func changePayTypeBtn(index:Int) -> Void {
        for i in 0 ..< payTypeBtnText.count {
            let img = self.viewWithTag(i + rechargeTag.PayTypeImg.rawValue) as! UIImageView
            let text = self.viewWithTag(i + rechargeTag.PayTypeText.rawValue) as! UILabel
            img.image = UIImage(named: "wallet_recharge_\(i)_0.png")
            text.textColor = UIColor.colorWithCustom(r: 161, g: 161, b: 161)
            if i == index {
                tlPrint(message: "index = \(index)")
                img.image = UIImage(named: "wallet_recharge_\(i)_1.png")
                text.textColor = UIColor.colorWithCustom(r: 35, g: 35, b: 35)
            }
        }
    }
    
    
    func initInputTable() -> Void {
        tlPrint(message: "initInputTable")
        let tableFrame = CGRect(x: adapt_W(width: 7), y: adapt_H(height: isPhone ? 310 : 220), width: width - adapt_W(width: 14), height: adapt_H(height: isPhone ? 200 : 110))
        self.tableView = baseVC.viewCreat(frame: tableFrame, backgroundColor: .white)
        self.addSubview(tableView)
        tableView.layer.cornerRadius = adapt_W(width: 4)
        tableView.clipsToBounds = true
        tableView.layer.borderColor = self.backgroundColor?.cgColor
        tableView.layer.borderWidth = adapt_H(height: 0.5)
        
        let alertWords = "     注：单笔充值限额（20元－50000元）"
        //alert label
        let alertFrame = CGRect(x: 0, y: 0, width: tableFrame.width, height: adapt_H(height: isPhone ? 45 : 25))
        let alertLabel = baseVC.labelCreat(frame: alertFrame, text: "", aligment: .left, textColor: .colorWithCustom(r: 245, g: 63, b: 0), backgroundcolor: .colorWithCustom(r: 255, g: 216, b: 0), fonsize: fontAdapt(font: isPhone ? 14 : 9))
        alertLabel.tag = rechargeTag.AlertLabelTag.rawValue
        tableView.addSubview(alertLabel)
        
        //label 变颜色
        let hintString = NSMutableAttributedString(string: alertWords)
        let range1 = NSRange(location: alertWords.characters.count - 10, length: 2)
        hintString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.colorWithCustom(r: 245, g: 63, b: 0), range: range1)
        let range2 = NSRange(location: alertWords.characters.count - 6, length: 4)
        hintString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.colorWithCustom(r: 245, g: 63, b: 0), range: range2)
        alertLabel.attributedText = hintString
        
        //input text field
        let textFrame = CGRect(x: 0, y: alertFrame.height , width: tableFrame.width, height: adapt_H(height: isPhone ? 85 : 45))
        inputTextField = baseVC.textFieldCreat(frame: textFrame, placeholderText: "单笔最低限额：20元", aligment: .left, fonsize: fontAdapt(font: isPhone ? 20 : 11), borderWidth: adapt_H(height: 0.5), borderColor: .colorWithCustom(r: 169, g: 169, b: 169), tag: rechargeTag.InputTextFieldTag.rawValue)
        tableView.addSubview(inputTextField)
        inputTextField.backgroundColor = UIColor.white
        let leftLabel = baseVC.labelCreat(frame: CGRect(x: adapt_W(width: 20), y: 0, width: adapt_W(width: isPhone ? 110 : 80), height: textFrame.height), text: "充值金额：¥    ", aligment: .center, textColor: .colorWithCustom(r: 35, g: 35, b: 35), backgroundcolor: .white, fonsize: fontAdapt(font: isPhone ? 17 : 10))
        inputTextField.leftView = leftLabel
        inputTextField.leftViewMode = .always
        inputTextField.keyboardType = .numberPad
        inputTextField.delegate = textFieldDelegate
        setLabelWithDiff(label: leftLabel, text: "充值金额：¥    ", font: fontAdapt(font: isPhone ? 17 : 10), color: .colorWithCustom(r: 35, g: 35, b: 35), range: NSRange(location: 5, length: 1))
        
        //优惠选择
        let preferentialFrame = CGRect(x: adapt_W(width: 20), y: adapt_H(height: isPhone ? 140 : 75), width: tableFrame.width - adapt_W(width: 40), height: adapt_H(height: isPhone ? 50 : 30))
        self.preferentialTextField = baseVC.textFieldCreat(frame: preferentialFrame, placeholderText: "请选择优惠", aligment: .left, fonsize: fontAdapt(font: isPhone ? 15 : 10), borderWidth: adapt_H(height: 0.5), borderColor: .colorWithCustom(r: 169, g: 169, b: 169), tag: rechargeTag.preferentialTextField.rawValue)
        tableView.addSubview(preferentialTextField)
        preferentialTextField.backgroundColor = UIColor.white
        preferentialTextField.layer.cornerRadius = adapt_W(width: 5)
        preferentialTextField.clipsToBounds = true
        let preferentialLeftLabel = baseVC.labelCreat(frame: CGRect(x: 0, y: 0, width: adapt_W(width: isPhone ? 30 : 18), height: preferentialFrame.height), text: "", aligment: .center, textColor: .clear, backgroundcolor: .white, fonsize: 0)
        preferentialTextField.leftView = preferentialLeftLabel
        preferentialTextField.leftViewMode = .always
        preferentialLeftLabel.layer.cornerRadius = adapt_W(width: 5)
        
        preferentialTextField.isUserInteractionEnabled = false
        //下拉按钮
        let selectFrame = CGRect(x: adapt_W(width: isPhone ? 290 : 300), y: adapt_H(height: isPhone ? 150 : 80), width: adapt_W(width: isPhone ? 43 : 30), height: adapt_H(height: isPhone ? 30 : 20))
        let selectBtn = baseVC.buttonCreat(frame: selectFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"person_alert_pulldown.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        tableView.addSubview(selectBtn)
        selectBtn.tag = rechargeTag.PreferentialBtnTag.rawValue
    }
    
//    func initChoiceBtn() -> Void {
//        
//        let buttonWidth = (width - adapt_W(width: 7) * 4) / 3
//        
//        for i in 0 ..< 6 {
//            let buttonX = adapt_W(width: 7) + CGFloat(i % 3) * (adapt_W(width: 7) + buttonWidth)
//            let buttonY = CGFloat(Int(i / 3)) * adapt_H(height: model.choiceBtnHieght + 8) + adapt_H(height: 360)
//            let choiceBtn = baseVC.buttonCreat(frame: CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: adapt_H(height: model.choiceBtnHieght)), title: "\(model.choiceValue[i])元", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .white, fonsize: fontAdapt(font: 17), events: .touchUpInside)
//            self.addSubview(choiceBtn)
//            choiceBtn.layer.cornerRadius = adapt_W(width: 4)
//            choiceBtn.layer.borderWidth = adapt_H(height: 1)
//            choiceBtn.layer.borderColor = UIColor.colorWithCustom(r: 10, g: 114, b: 232).cgColor
////            choiceBtn.layer.borderColor = self.backgroundColor?.cgColor
//            choiceBtn.setTitleColor(UIColor.colorWithCustom(r: 10, g: 114, b: 232), for: .normal)
//            choiceBtn.tag = rechargeTag.AmountBtnTag.rawValue + i
//            if i == 0 {
//                choiceBtn.backgroundColor = UIColor.colorWithCustom(r: 10, g: 114, b: 232)
//                choiceBtn.setTitleColor(UIColor.white, for: .normal)
//            }
//        }
//    }
//    
//    func changeChoiceBtn(index:Int) -> Void {
//        
//        inputTextField.text = model.choiceValue[index]
//        for i in 0 ..< 6 {
//            let button = self.viewWithTag(i + rechargeTag.AmountBtnTag.rawValue) as! UIButton
//            button.setTitleColor(UIColor.colorWithCustom(r: 10, g: 114, b: 232), for: .normal)
//            button.backgroundColor = UIColor.white
//            if i == index {
//                button.backgroundColor = UIColor.colorWithCustom(r: 10, g: 114, b: 232)
//                button.setTitleColor(UIColor.white, for: .normal)
//            }
//        }
//    }
    
    
    //充值金额上面的提示信息
    func initAlertLabel(lowLimit:Double,hightLimit:Double,btnTag:Int) -> Void {
        tlPrint(message: "initAlertLabel: \(lowLimit) - \(hightLimit)")
        
        let alertWords = "     注：单笔充值限额（\(lowLimit)元－\(hightLimit)元）"

        let inputTextField = self.viewWithTag(rechargeTag.InputTextFieldTag.rawValue) as! UITextField
        inputTextField.placeholder = "请输入金额"
        if btnTag == rechargeTag.AliScanPayBtnTag.rawValue || btnTag == rechargeTag.WechatScanPayBtnTag.rawValue || btnTag == rechargeTag.WechaToBankPayBtnTag.rawValue {
            inputTextField.placeholder = "请输入小数金额"
        }
        
        let alertLabel = self.viewWithTag(rechargeTag.AlertLabelTag.rawValue) as! UILabel
        alertLabel.text = alertWords
    }
    
    //微信提示微信号
    func initWechatAlertLabel(textString:String) -> Void {
        //点击了微信支付，需要更换文本内容
        let inputTextField = self.viewWithTag(rechargeTag.InputTextFieldTag.rawValue) as! UITextField
        inputTextField.placeholder = "单笔最低限额：20元"
        let alertLabel = self.viewWithTag(rechargeTag.AlertLabelTag.rawValue) as! UILabel
        alertLabel.text = textString
    }
    
    
    
    
    
    var picker:UIPickerView!
    var pickerConfirmBtn:UIButton!
    func initUIPickerView() -> UIPickerView {
        if picker != nil {
            picker.isHidden = false
            if pickerConfirmBtn != nil {
                pickerConfirmBtn.isHidden = false
            }
            return picker
        }
        picker = UIPickerView(frame: CGRect(x: adapt_W(width: 20), y: tableView.frame.origin.y + adapt_H(height: isPhone ? 130 : 70), width: self.frame.width - adapt_W(width: 40), height: adapt_H(height: isPhone ? 170 : 100)))
        self.addSubview(picker)
        picker.backgroundColor = UIColor.white
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(0, inComponent: 0, animated: true)
        
        
        
        let confirmFrame = CGRect(x: picker.frame.origin.x, y: self.picker.frame.height + picker.frame.origin.y - adapt_H(height: isPhone ? 30 : 20), width: picker.frame.width, height: adapt_H(height: isPhone ? 30 : 20))
        pickerConfirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "选 择", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 186, g: 10, b: 27), fonsize: fontAdapt(font: isPhone ? 20 : 13), events: .touchUpInside)
        pickerConfirmBtn.setTitleColor(UIColor.white, for: .normal)
        pickerConfirmBtn.tag = rechargeTag.PickerConfirmBtnTag.rawValue
        self.insertSubview(pickerConfirmBtn, aboveSubview: picker)
        return picker
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        tlPrint(message: "self.preferenceInfo:\(self.activityInfo!)")
        if activityInfo == nil || "\(activityInfo)" == "null" {
            activityInfo = [["Main_Title":"下回再参与","Activity_Code":""]]
//            return 0
        }
        return self.activityInfo!.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        tlPrint(message: "self.preferenceInfo:\(self.activityInfo!)  row:\(row)  component:\(component)")
        return self.activityInfo[row]["Main_Title"] as? String
    }
    

    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tlPrint(message: "didSelectRow")
        let selectedText = "  (已选择优惠)"
        let activityText = self.activityInfo[row]["Main_Title"] as! String + selectedText
        //label 变颜色
        let hintString = NSMutableAttributedString(string: activityText)
        let range = NSRange(location: activityText.characters.count - selectedText.characters.count, length: selectedText.characters.count)
        hintString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.colorWithCustom(r: 10, g: 114, b: 232), range: range)
        hintString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 12 : 8)) , range: range)
        self.preferentialTextField.attributedText = hintString
        self.activityCode = self.activityInfo[row]["Activity_Code"] as! String
        tlPrint(message: "activitiInfo:\(activityInfo)")
        tlPrint(message: "activity code:\(activityCode)")
    }
    
    func initNextBtn() -> Void {
        tlPrint(message: "initNextBtn")
        let nextFrame = CGRect(x: adapt_W(width: isPhone ? 42 : 50), y: adapt_H(height: isPhone ? 520 : 360), width: width - adapt_H(height: isPhone ? 84 : 100), height: adapt_H(height: isPhone ? 44 : 30))
        nextBtn = baseVC.buttonCreat(frame: nextFrame, title: "下一步", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 186, g: 10, b: 27), fonsize:fontAdapt(font: isPhone ? 17 : 11), events: .touchUpInside)
        self.insertSubview(nextBtn, belowSubview: tableView)
        nextBtn.tag = rechargeTag.NextBtnTag.rawValue
        nextBtn.layer.cornerRadius = adapt_H(height: 4)
        
    }

    
    func initWarmingLabel() {
        tlPrint(message: "initWarmingLabel")
        
        
        //alert label
        let warmingFrame = CGRect(x: adapt_W(width: isPhone ? 42 : 50), y: adapt_H(height: isPhone ? 547 : 400), width: width - adapt_H(height: isPhone ? 84 : 100), height: adapt_H(height: isPhone ? 80 : 50))
        let warmingLabel = baseVC.labelCreat(frame: warmingFrame, text: "", aligment: .left, textColor: .colorWithCustom(r: 245, g: 63, b: 0), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 14 : 9))
        warmingLabel.tag = rechargeTag.WarmingLabelTag.rawValue
        self.addSubview(warmingLabel)
        warmingLabel.numberOfLines = 0
        
    }
    
    @objc func btnAct(sender:UIButton) -> Void {
        if sender.tag != rechargeTag.NextBtnTag.rawValue && sender.tag == self.currentBtnTag {
            tlPrint(message: "点击了同一个支付方式按钮")
            self.nextBtn.isEnabled = true
            return
        }
        self.currentBtnTag = sender.tag
        
        switch sender.tag {
        case rechargeTag.PreferentialBtnTag.rawValue:
            let amountTextField = self.viewWithTag(rechargeTag.InputTextFieldTag.rawValue) as! UITextField
            amountTextField.resignFirstResponder()
            _ = initUIPickerView()
        case rechargeTag.PickerConfirmBtnTag.rawValue:
            picker.isHidden = true
            pickerConfirmBtn.isHidden = true
            return
        
        default:
            delegate.btnAct(btnTag: sender.tag)
        }
    }
    
    func setLabelWithDiff(label:UILabel, text:String, font:CGFloat, color:UIColor, range:NSRange) -> Void {
        label.text = text
        let attStr = NSMutableAttributedString(string: text)
        attStr.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        attStr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: font), range: range)
        label.attributedText = attStr
    }
}
