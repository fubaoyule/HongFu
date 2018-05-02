//
//  WithdrawView.swift
//  FuTu
//
//  Created by Administrator1 on 28/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class WithdrawView: UIView {

    var scroll: UIScrollView!
    var inputTextField:UITextField!
    var bankLabel: UILabel!
    var delegate:BtnActDelegate!
    var textFieldDelegate: UITextFieldDelegate!
    var scrollDelegate: UIScrollViewDelegate!
    var width,height: CGFloat!
    let model = RechargeModel()
    
    var nextBtn:UIButton!
    
    var param: [Any]!
    
    let baseVC = BaseViewController()
    init(frame:CGRect, param:[Any],rootVC:UIViewController) {
        super.init(frame: frame)
        
        self.width = frame.width
        self.height = frame.height
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        self.param = param
        
        self.delegate = rootVC as! BtnActDelegate
        self.textFieldDelegate = rootVC as! UITextFieldDelegate
        
        initNavigationBar()
        initInputTable()
        initNextBtn()
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
        setLabelProperty(label: titleLabel, text: "取款", aligenment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .clear, font: 17)
        navigationView.addSubview(titleLabel)
        
        
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        navigationView.addSubview(backBtn)
        backBtn.tag = withdrawTag.WithdrawBackBtnTag.rawValue
        //back button image
//        let backBtnImg = UIImageView(frame: CGRect(x: 10, y: 12, width: 12, height: 20))
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
        
    }
    
    
    func initInputTable() -> Void {
        tlPrint(message: "initInputTable")
        let tableFrame = CGRect(x: adapt_W(width: 7), y: adapt_H(height: 90), width: width - adapt_W(width: 14), height: adapt_H(height: 225))
        let tableView = baseVC.viewCreat(frame: tableFrame, backgroundColor: .white)
        self.addSubview(tableView)
        tableView.layer.cornerRadius = adapt_W(width: 5)
        tableView.clipsToBounds = true
        tableView.layer.borderColor = UIColor.colorWithCustom(r: 169, g: 169, b: 169).cgColor
        tableView.layer.borderWidth = adapt_H(height: 0.7)
        
//        let alertWords = "   注：单笔提现限额100至50000元，今日可提\(self.param[0])次"
        let alertWords = "   注：单笔提现限额100至50000元"
        //alert label
        let alertFrame = CGRect(x: 0, y: 0, width: tableFrame.width, height: adapt_H(height: 45))
        let alertLabel = baseVC.labelCreat(frame: alertFrame, text: alertWords, aligment: .left, textColor: .colorWithCustom(r: 129, g: 129, b: 129), backgroundcolor: .clear, fonsize: fontAdapt(font: 14))
        tableView.addSubview(alertLabel)
        //label 字体变颜色
        let hintString = NSMutableAttributedString(string: alertWords)
        let range1 = NSRange(location: alertWords.characters.count - 6, length: 5)
        hintString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.colorWithCustom(r: 245, g: 63, b: 0), range: range1)
        let range2 = NSRange(location: alertWords.characters.count - 10, length: 3)
        hintString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.colorWithCustom(r: 245, g: 63, b: 0), range: range2)
//        let range3 = NSRange(location: alertWords.characters.count - 17, length: 3)
//        hintString.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithCustom(r: 245, g: 63, b: 0), range: range3)
        alertLabel.attributedText = hintString
        
        
        //bank label
        let bankText = "   到账银行卡： \(param[2])"
        let bankFrame = CGRect(x: 0, y: alertFrame.height, width: tableFrame.width, height: alertFrame.height)
        bankLabel = baseVC.labelCreat(frame: bankFrame, text: bankText, aligment: .left, textColor: .colorWithCustom(r: 35, g: 35, b: 35), backgroundcolor: .clear, fonsize: fontAdapt(font: 14))
        tableView.addSubview(bankLabel)
        let bankString = NSMutableAttributedString(string: bankText)
        let bankRange = NSRange(location: 10, length: bankText.characters.count - 10)
        bankString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.colorWithCustom(r: 0, g: 101, b: 215), range: bankRange)
        bankLabel.attributedText = bankString
        bankLabel.layer.borderColor = UIColor.colorWithCustom(r: 169, g: 169, b: 169).cgColor
        bankLabel.layer.borderWidth = adapt_H(height: 0.5)
        
        //bank choose button
        let chooseFrame = CGRect(x: adapt_W(width: 100), y: alertFrame.height, width: tableFrame.width - adapt_W(width: 100), height: alertFrame.height)
        let bankChooseBtn = baseVC.buttonCreat(frame: chooseFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        tableView.addSubview(bankChooseBtn)
        bankChooseBtn.tag = withdrawTag.WithdrawBankBtnTag.rawValue
        //button image
        let imgFrame = CGRect(x: chooseFrame.width - adapt_W(width: 38), y: adapt_H(height: 10), width: adapt_W(width: 25), height: adapt_W(width: 25))
        let bankBtnImg = baseVC.imageViewCreat(frame: imgFrame, image: UIImage(named:"person_Info_nextIcon.png")!, highlightedImage: UIImage(named:"person_Info_nextIcon.png")!)
        bankChooseBtn.addSubview(bankBtnImg)
        
        
        //input text field
        let textFrame = CGRect(x: 0, y: alertFrame.height * 2  , width: tableFrame.width, height: adapt_H(height: 84))
        inputTextField = baseVC.textFieldCreat(frame: textFrame, placeholderText: "请输入金额", aligment: .left, fonsize: fontAdapt(font: 20), borderWidth: adapt_H(height: 0.5), borderColor: .colorWithCustom(r: 169, g: 169, b: 169), tag: rechargeTag.InputTextFieldTag.rawValue)
        tableView.addSubview(inputTextField)
        inputTextField.tag = withdrawTag.WithdrawInputTextTag.rawValue
        
        let leftLabel = baseVC.labelCreat(frame: CGRect(x: adapt_W(width: 20), y: 0, width: adapt_W(width: 120), height: textFrame.height), text: "提现金额：¥", aligment: .center, textColor: .colorWithCustom(r: 35, g: 35, b: 35), backgroundcolor: .clear, fonsize: fontAdapt(font: 17))
        inputTextField.leftView = leftLabel
        inputTextField.leftViewMode = .always
        inputTextField.keyboardType = .numberPad
        inputTextField.delegate = textFieldDelegate
        inputTextField.layer.borderColor = UIColor.colorWithCustom(r: 169, g: 169, b: 169).cgColor
        inputTextField.layer.borderWidth = adapt_H(height: 0.5)
        
        
        //amount label
        let amountWords = "   中心钱包余额：¥\(self.param[1])"
        //alert label
        let amountFrame = CGRect(x: 0, y: alertFrame.height * 2 + textFrame.height, width: tableFrame.width, height: adapt_H(height: 52))
        let amountLabel = baseVC.labelCreat(frame: amountFrame, text: amountWords, aligment: .left, textColor: .colorWithCustom(r: 35, g: 35, b: 35), backgroundcolor: .colorWithCustom(r: 244, g: 244, b: 244), fonsize: fontAdapt(font: 14))
        tableView.addSubview(amountLabel)
        //label 字体变颜色
        let amountString = NSMutableAttributedString(string: amountWords)
        let range = NSRange(location: 10, length: amountWords.characters.count - 10)
        amountString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.colorWithCustom(r: 245, g: 63, b: 0), range: range)
        amountString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: fontAdapt(font: 17)), range: range)
        amountLabel.attributedText = amountString
        amountLabel.layer.borderColor = UIColor.colorWithCustom(r: 169, g: 169, b: 169).cgColor
        amountLabel.layer.borderWidth = adapt_H(height: 0.5)
        
        //withdraw all amount button
        let allFrame = CGRect(x: amountFrame.width - adapt_W(width: 90), y: amountFrame.origin.y, width: adapt_W(width: 90), height: amountFrame.height)
        let withdrawAllBtn = baseVC.buttonCreat(frame: allFrame, title: "全部提现", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: 14), events: .touchUpInside)
        tableView.addSubview(withdrawAllBtn)
        withdrawAllBtn.setTitleColor(UIColor.colorWithCustom(r: 0, g: 101, b: 215), for: .normal)
        withdrawAllBtn.tag = withdrawTag.WithdrawAllBtnTag.rawValue
        
    }
    
    func initNextBtn() -> Void {
        tlPrint(message: "initNextBtn")
        let nextFrame = CGRect(x: adapt_W(width: 19), y: adapt_H(height: 350), width: width - adapt_H(height: 38), height: adapt_H(height: 50))
        self.nextBtn = baseVC.buttonCreat(frame: nextFrame, title: "下一步", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 186, g: 10, b: 27), fonsize:fontAdapt(font: 17), events: .touchUpInside)
        self.addSubview(nextBtn)
        nextBtn.tag = withdrawTag.WithdrawNextBtnTag.rawValue
        nextBtn.layer.cornerRadius = adapt_H(height: 8)
        nextBtn.setTitleColor(UIColor.colorWithCustom(r: 255, g: 192, b: 0), for: .normal)
        
    }
    
    
    
    @objc func btnAct(sender:UIButton) -> Void {
        if sender.tag == withdrawTag.WithdrawAllBtnTag.rawValue {
            inputTextField.text = "\(self.param[1])"
            return
        }
        if sender.tag == withdrawTag.WithdrawNextBtnTag.rawValue {
            let currentAmount = CGFloat(Double(self.param[1] as! String)!)
            if inputTextField.text == nil || inputTextField.text == "" {
                tlPrint(message: "请输入金额")
                let alert = UIAlertView(title: "输入有误", message: "单笔可提现金额为100至50000元，请核对后再试", delegate: nil, cancelButtonTitle: "确 定")
                DispatchQueue.main.async {
                    alert.show()
                }
                return
            } else if (self.param[0] as! Int) <= 0 {
                tlPrint(message: "今日提现次数已经达到上限")
                let alert = UIAlertView(title: "提现失败", message: "今日提现次数已经达到上限", delegate: nil, cancelButtonTitle: "确 定")
                DispatchQueue.main.async {
                    alert.show()
                }
                return
            } else if String.stringToCGFloat(string: inputTextField.text!) < 100 || String.stringToCGFloat(string: inputTextField.text!) > 50000 {
                tlPrint(message: "今日提现次数已经达到上限")
                let alert = UIAlertView(title: "提现失败", message: "单笔可提现金额为100至50000元，\n请核对后再试", delegate: nil, cancelButtonTitle: "确 定")
                DispatchQueue.main.async {
                    alert.show()
                }
                return
            } else if CGFloat(Int(inputTextField.text!)!) > currentAmount {
                let alert = UIAlertView(title: "提现失败", message: "余额不足，请充值！", delegate: nil, cancelButtonTitle: "确 定")
                DispatchQueue.main.async {
                    alert.show()
                }
                return
            }
        }
        delegate.btnAct(btnTag: sender.tag)
    }
    
//    var picker:UIPickerView!
//    
//    func initUIPickerView() -> UIPickerView {
//        tlPrint(message: "initUIPickerView")
//        if picker != nil {
//            picker.isHidden = false
//            return picker
//        }
//        picker = UIPickerView(frame: CGRect(x: 0, y: adapt_H(height: 400), width: width, height: height - adapt_H(height: 400)))
//        picker.backgroundColor = UIColor(white: 1, alpha: 0.3)
//        picker.dataSource = self
//        picker.delegate = self
//        picker.selectRow(6, inComponent: 0, animated: true)
//        self.addSubview(picker)
//        return picker
//        
//    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if picker != nil {
//            picker.isHidden = true
//        }
//    }
//    
//    let bankModel = PersonModel()
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return bankModel.bankName.count
//    }
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return bankModel.bankName[row]
//    }

    
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        tlPrint(message: "didSelectRow:\(row)")
//        let bankText = "   到账银行卡： \(bankModel.bankName[row])"
//        let bankString = NSMutableAttributedString(string: bankText)
//        let bankRange = NSRange(location: 10, length: bankText.characters.count - 10)
//        bankString.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithCustom(r: 0, g: 101, b: 215), range: bankRange)
//        bankLabel.attributedText = bankString
//    }
    
}
