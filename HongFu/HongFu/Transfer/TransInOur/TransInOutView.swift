//
//  TransInOutView.swift
//  FuTu
//
//  Created by Administrator1 on 31/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

//class TransInOutView: UIView ,UIPickerViewDelegate, UIPickerViewDataSource{
class TransInOutView: UIView{
    
    
    
    var delegate: TransferDelegates!
    var textFeildDelegate: UITextFieldDelegate!
    var width,height: CGFloat!
    let model = TransferModel()
    let baseVC = BaseViewController()
    var pickerConfirmBtn: UIButton!
    var backView,alertView: UIView!
//    var picker: UIPickerView!
    var transferInTextField,preferentialTextField: UITextField!
    var gameIndex:Int!
    
    var transferType = "转入"
    var labelText = "存款"
//    var preferenceNumber:Int!
//    var preferenceInfo:[[Any]]!
    
    init(frame:CGRect, param:AnyObject,rootVC:UIViewController) {
        super.init(frame: frame)
        self.width = frame.width
        self.height = frame.height
        self.delegate = rootVC as! TransferDelegates
        
        if (param as! Int) >= TransferTag.transIn.rawValue &&  (param as! Int) < TransferTag.transOut.rawValue {
            self.gameIndex = ((param as! Int) - TransferTag.transIn.rawValue)
            self.transferType = "转入"
            self.labelText = "存款"
        } else if (param as! Int) >= TransferTag.transOut.rawValue{
            self.gameIndex = ((param as! Int) - TransferTag.transOut.rawValue)
            self.transferType = "转出"
            self.labelText = "转出"
        }
        self.textFeildDelegate = rootVC as! UITextFieldDelegate
//        self.preferenceInfo = model.preferenceInfo
        
        //获取充值优惠信息
//        self.getPreferenceInfo()
        backView = bankBackHideView()
        alertView = addAlertView()
        self.addSubview(backView)
        self.addSubview(alertView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
//    func getPreferenceInfo() -> Void {
//        if userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue) != nil {
//            futuNetworkRequest(type: .get,serializer: .json, url: model.preferenceUrl, params: ["gamecode":globleGameCode[self.gameIndex]], success: { (response) in
//                tlPrint(message: "response:\(response)")
//                for i in 0 ..< (response as AnyObject).count {
//                    let info = ((response as AnyObject as! NSArray)[i] as AnyObject).value(forKey: "ActName")
//                    let id = ((response as AnyObject as! NSArray)[i] as AnyObject).value(forKey: "returnDetailId")
//                    self.model.preferenceInfo.append([id!,info!])
//                }
//                self.model.preferenceInfo.remove(at: 0)
//                tlPrint(message: "model.preferenceInfo:\(self.model.preferenceInfo)")
//                self.preferenceInfo = self.model.preferenceInfo
//            }, failure: { (error) in
//                tlPrint(message: "error:\(error)")
//            }) 
//        }
//    }
    
    
    func bankBackHideView() -> UIView {
        backView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        backView.backgroundColor = UIColor.black
        backView.alpha = 0.5
        return backView
    }
    
    func addAlertView() -> UIView {
        
        tlPrint(message: "addBankAlertView")
        alertView = UIView(frame: CGRect(x: adapt_W(width: 20), y: adapt_H(height: 80), width: width - adapt_W(width: 40), height: adapt_H(height: 205)))
        alertView.backgroundColor = UIColor.colorWithCustom(r: 244, g: 244, b: 244)
        alertView.layer.cornerRadius = adapt_W(width: 10)
        alertView.clipsToBounds = true
        //title text
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: alertView.frame.width, height: adapt_H(height: 60)))
        alertView.addSubview(titleLabel)
        alertView.center = self.center
        tlPrint(message: "gameIndex = \(self.gameIndex)")
        setLabelProperty(label: titleLabel, text: "\(self.transferType)\(selfGameName[self.gameIndex])", aligenment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .white, font: fontAdapt(font: 17))
        //close button
        let closeFrame = CGRect(x: alertView.frame.width - adapt_W(width: 40), y: (adapt_H(height: 60) - adapt_W(width: 30)) / 2, width: adapt_W(width: 30), height: adapt_W(width: 30))
        
        let closeBtn = baseVC.buttonCreat(frame: closeFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"self_title_remind.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.alertView.addSubview(closeBtn)
        closeBtn.setImage(UIImage(named:"person_piker_close.png"), for: .normal)
        closeBtn.tag = TransferTag.alertCloseBtnTag.rawValue

        let transInOutFrame = CGRect(x: adapt_W(width: -0.5), y: titleLabel.frame.height, width: titleLabel.frame.width + adapt_W(width: 1), height: adapt_H(height: 95))
        transferInTextField = baseVC.textFieldCreat(frame: transInOutFrame, placeholderText: "请输入金额", aligment: .left, fonsize: fontAdapt(font: 20), borderWidth: adapt_W(width: 0.5), borderColor: .colorWithCustom(r: 193, g: 193, b: 193), tag: TransferTag.transInOutTextField.rawValue)
        self.alertView.insertSubview(transferInTextField, aboveSubview: titleLabel)
        transferInTextField.textColor = UIColor.colorWithCustom(r: 35, g: 35, b: 35)
        transferInTextField.delegate = self.textFeildDelegate
        
        let leftLabel = baseVC.labelCreat(frame: CGRect(x: 0, y: 0, width: adapt_W(width: 115),height:transInOutFrame.height), text: "\(labelText)金额：¥", aligment: .center, textColor: .colorWithCustom(r: 35, g: 35, b: 35), backgroundcolor: .clear, fonsize: fontAdapt(font: 16))
        leftLabel.center.y = transferInTextField.center.y
        transferInTextField.leftView = leftLabel
        transferInTextField.leftViewMode = .always
        transferInTextField.keyboardType = .decimalPad
        
        
        
        //confirm button
        let confirmFrame = CGRect(x: 0, y: alertView.frame.height - adapt_H(height: 50), width: alertView.frame.width, height: adapt_H(height: 50))
        pickerConfirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "确认\(self.transferType)", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 186, g: 10, b: 27), fonsize: fontAdapt(font: 20), events: .touchUpInside)
        alertView.addSubview(pickerConfirmBtn)
        pickerConfirmBtn.setTitleColor(UIColor.white, for: .normal)
        pickerConfirmBtn.tag = TransferTag.alertConfirmBtnTag.rawValue
        return alertView
        
    }
    
//    func initUIPickerView() -> UIPickerView {
//        if picker != nil {
//            picker.isHidden = false
//            if pickerConfirmBtn != nil {
//                pickerConfirmBtn.isHidden = false
//            }
//            return picker
//        }
//        picker = UIPickerView(frame: CGRect(x: 0, y: adapt_H(height: 60), width: alertView.frame.width, height: adapt_H(height: 155)))
//        alertView.addSubview(picker)
//        picker.backgroundColor = UIColor.white
//        picker.dataSource = self
//        picker.delegate = self
//        picker.selectRow(0, inComponent: 0, animated: true)
//        let confirmFrame = CGRect(x: 0, y: alertView.frame.height - adapt_H(height: 50), width: alertView.frame.width, height: adapt_H(height: 50))
//        pickerConfirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "选 择", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 27, g: 123, b: 233), fonsize: fontAdapt(font: 20), events: .touchUpInside)
//        pickerConfirmBtn.setTitleColor(UIColor.white, for: .normal)
//        pickerConfirmBtn.tag = TransferTag.pickerConfirmBtnTag.rawValue
//        alertView.insertSubview(pickerConfirmBtn, aboveSubview: picker)
//        return picker
//        
//    }
//    
//    
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
            for view in alertView.subviews {
                view.removeFromSuperview()
            }
            alertView.removeFromSuperview()
            alertView = nil
            backView.removeFromSuperview()
            backView = nil
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
