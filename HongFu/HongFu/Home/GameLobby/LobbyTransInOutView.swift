//
//  LobbyTransInOutView.swift
//  FuTu
//
//  Created by Administrator1 on 10/1/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

//class LobbyTransInOutView:  UIView ,UIPickerViewDelegate, UIPickerViewDataSource{
class LobbyTransInOutView:  UIView {
    
    
    
    
    var delegate: lobbyDelegate!
    var textFeildDelegate: UITextFieldDelegate!
    var width,height: CGFloat!
    let model = TransferModel()
    let baseVC = BaseViewController()
    var pickerConfirmBtn: UIButton!
    var backView,alertView: UIView!
    var transferInTextField,preferentialTextField: UITextField!
    var gameIndex:Int!
    var gameName:String!
    var transferType = "转入"
    var labelText = "存款"
    
    init(frame:CGRect, param:[Any],rootVC:UIViewController) {
        super.init(frame: frame)
        
        self.width = frame.width
        self.height = frame.height
        self.gameIndex = param[0] as! Int
        self.gameName = gameLobbyGameName[gameIndex]
        self.transferType = param[1] as! String
        self.labelText = (self.transferType == "转入" ? "存款" : "转出")
        
        self.textFeildDelegate = rootVC as! UITextFieldDelegate
        self.delegate = rootVC as! lobbyDelegate
        backView = bankBackHideView()
        alertView = addAlertView()
        self.addSubview(backView)
        self.addSubview(alertView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bankBackHideView() -> UIView {
        backView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        backView.backgroundColor = UIColor.black
        backView.alpha = 0.5
        return backView
    }
    
    func addAlertView() -> UIView {
        
        tlPrint(message: "addBankAlertView")
        alertView = UIView(frame: CGRect(x: adapt_W(width: isPhone ? 20 : 80), y: adapt_H(height: isPhone ? 80 : 130), width: width - adapt_W(width: isPhone ? 40 : 160), height: adapt_H(height: isPhone ? 205 : 105)))
        alertView.backgroundColor = UIColor.colorWithCustom(r: 244, g: 244, b: 244)
        alertView.layer.cornerRadius = adapt_W(width: isPhone ? 10 : 5)
        alertView.clipsToBounds = true
        //title text
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: alertView.frame.width, height: adapt_H(height: isPhone ? 60 : 30)))
        alertView.addSubview(titleLabel)
        alertView.center = self.center
        tlPrint(message: "gameIndex = \(self.gameIndex)")
        setLabelProperty(label: titleLabel, text: "\(self.transferType)\(self.gameName!)", aligenment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .white, font: fontAdapt(font: isPhone ? 17 : 12))
        //close button
        let closeFrame = CGRect(x: alertView.frame.width - adapt_W(width: isPhone ? 40 : 30), y: (adapt_H(height: isPhone ? 60 : 30) - adapt_W(width: isPhone ? 30 : 15)) / 2, width: adapt_W(width: isPhone ? 30 : 15), height: adapt_W(width: isPhone ? 30 : 15))
        
        let closeBtn = baseVC.buttonCreat(frame: closeFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"self_title_remind.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.alertView.addSubview(closeBtn)
        closeBtn.setImage(UIImage(named:"person_piker_close.png"), for: .normal)
        closeBtn.tag = TransferTag.alertCloseBtnTag.rawValue
        
        let transInOutFrame = CGRect(x: adapt_W(width: -0.5), y: titleLabel.frame.height, width: titleLabel.frame.width + adapt_W(width: 1), height: adapt_H(height: isPhone ? 95 : 40))
        transferInTextField = baseVC.textFieldCreat(frame: transInOutFrame, placeholderText: "请输入金额", aligment: .left, fonsize: fontAdapt(font: isPhone ? 20 : 11), borderWidth: adapt_W(width: 0.5), borderColor: .colorWithCustom(r: 193, g: 193, b: 193), tag: TransferTag.transInOutTextField.rawValue)
        self.alertView.insertSubview(transferInTextField, aboveSubview: titleLabel)
        transferInTextField.textColor = UIColor.colorWithCustom(r: 35, g: 35, b: 35)
        transferInTextField.delegate = self.textFeildDelegate
        
        let leftLabel = baseVC.labelCreat(frame: CGRect(x: 0, y: 0, width: adapt_W(width: isPhone ? 115 : 90),height:transInOutFrame.height), text: "\(labelText)金额：¥", aligment: .center, textColor: .colorWithCustom(r: 35, g: 35, b: 35), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 16 : 10))
        leftLabel.center.y = transferInTextField.center.y
        transferInTextField.leftView = leftLabel
        transferInTextField.leftViewMode = .always
        transferInTextField.keyboardType = .decimalPad
        
        
        
        //confirm button
        let confirmFrame = CGRect(x: 0, y: alertView.frame.height - adapt_H(height: isPhone ? 50 : 35), width: alertView.frame.width, height: adapt_H(height: isPhone ? 50 : 40))
        pickerConfirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "确认\(self.transferType)", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 186, g: 10, b: 27), fonsize: fontAdapt(font: isPhone ? 20 : 12), events: .touchUpInside)
        alertView.addSubview(pickerConfirmBtn)
        pickerConfirmBtn.setTitleColor(UIColor.white, for: .normal)
        pickerConfirmBtn.tag = TransferTag.alertConfirmBtnTag.rawValue
        pickerConfirmBtn.setTitleColor(UIColor.colorWithCustom(r: 255, g: 192, b: 0), for: .normal)
        
        
        return alertView
        
    }
//    
//    func initUIPickerView() -> UIPickerView {
//        if picker != nil {
//            picker.isHidden = false
//            if pickerConfirmBtn != nil {
//                pickerConfirmBtn.isHidden = false
//            }
//            return picker
//        }
//        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: alertView.frame.width, height: adapt_H(height: isPhone ? 215 : 110)))
//        alertView.addSubview(picker)
//        picker.backgroundColor = UIColor.white
//        picker.dataSource = self
//        picker.delegate = self
//        picker.selectRow(0, inComponent: 0, animated: true)
//        let confirmFrame = CGRect(x: 0, y: alertView.frame.height - adapt_H(height: isPhone ? 50 : 35), width: alertView.frame.width, height: adapt_H(height: isPhone ? 50 : 35))
//        pickerConfirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "选 择", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 27, g: 123, b: 233), fonsize: fontAdapt(font: isPhone ? 20 : 12), events: .touchUpInside)
//        pickerConfirmBtn.setTitleColor(UIColor.white, for: .normal)
//        pickerConfirmBtn.tag = TransferTag.pickerConfirmBtnTag.rawValue
//        alertView.insertSubview(pickerConfirmBtn, aboveSubview: picker)
//        return picker
//        
//    }
    
 
    
    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        tlPrint(message: "self.preferenceInfo:\(self.preferenceInfo!)")
//        return self.preferenceInfo!.count
//    }
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        tlPrint(message: "self.preferenceInfo:\(self.preferenceInfo!)")
//        return self.preferenceInfo[row][1] as? String
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        tlPrint(message: "didSelectRow")
//        self.preferentialTextField.text = self.preferenceInfo[row][1] as? String
//        self.preferenceNumber = self.preferenceInfo[row][0] as! Int
//        tlPrint(message: "preference number:\(preferenceNumber!)")
//    }
    
    
    //关闭弹窗以后的处理函数
    func bankAlertClose() -> Void {
        tlPrint(message: "bankAlertClose")
        if backView != nil {
            backView.isHidden = true
        }
        if alertView != nil {
            alertView.isHidden = true
        }
        
        tlPrint(message: "选择的tag: \(TransferTag.transInOutTextField.rawValue)")
        let textFeild = self.alertView.viewWithTag(TransferTag.transInOutTextField.rawValue) as! UITextField
        textFeild.resignFirstResponder()
        
        alertView.center = self.center
        
    }
    

    
    @objc func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct sender.tag = \(sender.tag)")
        
        
        switch sender.tag {
//        case TransferTag.preferentialSelectBtnTag.rawValue:
//            _ = initUIPickerView()
//            return
//        case TransferTag.pickerConfirmBtnTag.rawValue:
//            picker.isHidden = true
//            pickerConfirmBtn.isHidden = true
//            return
        case TransferTag.alertCloseBtnTag.rawValue:
            alertView.removeFromSuperview()
            backView.removeFromSuperview()
            self.removeFromSuperview()
//        case TransferTag.alertConfirmBtnTag.rawValue:
//            
//            /**        判断数据以及上传数据到服务器        **/
//            alertView.removeFromSuperview()
//            backView.removeFromSuperview()
//            self.removeFromSuperview()
        default:
            delegate.alertBtnAct(sender: sender)
        }
    }
}
