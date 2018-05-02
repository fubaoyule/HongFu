//
//  InfoModifyTableViewCell.swift
//  FuTu
//
//  Created by Administrator1 on 15/1/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

class InfoModifyTableViewCell: UITableViewCell {

    
    var info:[String]!
    var cellIndex:Int!
    var width,height:CGFloat!
    var textFeildDelegate:UITextFieldDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    init(cellIndex:Int,rootVC:UIViewController) {
        super.init(style: .default, reuseIdentifier: "ABC")
        self.width = deviceScreen.width
        self.height = deviceScreen.height
        self.cellIndex = cellIndex
        self.textFeildDelegate = rootVC as! UITextFieldDelegate
        initCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCell() -> Void {
        let baseVC = BaseViewController()
//        let infoArray = ["出生日期","手机号码","电子邮箱","QQ号码","微信号码"]
        let infoArray = ["出生日期","QQ号码","微信号码"]
        let inputFrame = CGRect(x: 0, y: 0, width: width, height: adapt_H(height: isPhone ? 60 : 40))
        let inputTextFeild = baseVC.textFieldCreat(frame: inputFrame, placeholderText: "请输入您的\(infoArray[self.cellIndex])", aligment: .left, fonsize: fontAdapt(font: isPhone ? 15 : 11), borderWidth: 0, borderColor: .clear, tag: personBtnTag.InfoTextFeildTag.rawValue + cellIndex)
        self.addSubview(inputTextFeild)
        inputTextFeild.delegate = self.textFeildDelegate
        
        let labelFrame = CGRect(x: 0, y: 0, width: adapt_W(width: isPhone ? 80 : 60), height: adapt_H(height: isPhone ? 60 : 40))
        let infoLabel = baseVC.labelCreat(frame: labelFrame, text: infoArray[self.cellIndex], aligment: .center, textColor: .colorWithCustom(r: 129, g: 129, b: 129), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 15 : 11))
        inputTextFeild.leftViewMode = .always
        inputTextFeild.leftView = infoLabel
        tlPrint(message: "cellIndex:\(cellIndex)")
        switch self.cellIndex {
        case 0:
//            inputTextFeild.keyboardType = .numberPad
            let birthDate = userDefaults.value(forKey: userDefaultsKeys.userInfoBirthDate.rawValue) as? String
            inputTextFeild.text = birthDate
//        case 1:
//            inputTextFeild.keyboardType = .alphabet
//            let email = userDefaults.value(forKey: userDefaultsKeys.userInfoEmail.rawValue) as? String
//            inputTextFeild.text = email
        case 1:
            inputTextFeild.keyboardType = .numberPad
            let qqNumber = userDefaults.value(forKey: userDefaultsKeys.userInfoQQ.rawValue) as? String
            inputTextFeild.text = qqNumber
        case 2:
            inputTextFeild.keyboardType = .asciiCapable
            let weChatNumber = userDefaults.value(forKey: userDefaultsKeys.userInfoWechat.rawValue) as? String
            inputTextFeild.text = weChatNumber
        default:
            tlPrint(message: "no such case")
        }
    }
}
