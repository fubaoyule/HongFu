//
//  RegisterModel.swift
//  FuTu
//
//  Created by Administrator1 on 2/1/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

enum RegisterTag:Int {
    case cancelBtnTag = 10, registerBtnTag,loginBtnTag, verifyImgTag,BirthDageBtnTag
    case usernameText = 20, passwordText, realNameText,birthdayText,genderText, wechatText,phoneNumberText, mailText, verifyText
    case maleBtnTag,femaleBtnTag = 30,maleImgTag, femaleImgTag,maleLabelTag,femalelabelTag,birthdayPikerConfirmBtnTag
    case infoAlertLabelTag = 40
}

//
//enum RgstPassTag:Int {
//    case cancelBtnTag = 10, finishBtntag
//    case realNameText = 20, passwordText,confirmText
//    case eyeOpenImgTag = 25,eyeCloseImgTag
//    case infoAlertLabelTag = 30
//}

class RegisterModel: NSObject {

    
    
    //校验 用户名是否存在
    let checkUsernameUrl = "Account/CheckUsername"
    //请求 图片验证码
    let getVerifyImageUrl = "Common/GenerateCaptcha"
    //验证图片验证码
    let checkVerifyUrl = "Common/ValidateCaptcha"
    
    let loginErrorCodeDic = ["1004":"Email已存在，请重新输入","1005":"手机号已存在，请重新输入","1003":"用户名已存在，请重新输入"]
    //
    let alertLabelText = ["名称已被占用","密码格式错误","姓名输入错误","年龄不符合要求","","微信号已被注册","手机号已注册","该邮箱已注册","验证码输入有误"]
    let alertLabelText2 = ["名称格式有误","密码格式错误","姓名输入错误","请输入出生日期","","微信号格式有误","手机号格式有误","邮箱格式有误","验证码格式有误"]
    
    func getVefiryImageUrl(success:@escaping((String)->())) -> Void {
        tlPrint(message: "getVefiryImageUrl")
        
        futuNetworkRequest(type: .get, serializer: .http, url: self.getVerifyImageUrl, params: ["":""], success: { (response) in
            var string = String(data: response as! Data, encoding: String.Encoding.utf8)! as String
            string = string.replacingOccurrences(of: "\"", with: "")
            success(string)
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
            let message = "获取验证码失败，请稍后再试！"
            let alert = UIAlertView(title: "提 醒", message: message, delegate: nil, cancelButtonTitle: "确 定")
            DispatchQueue.main.async {
                alert.show()
            }
        })
    }
}
