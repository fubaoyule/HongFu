//
//  InfoVerify.swift
//  FuTu
//
//  Created by Administrator1 on 19/1/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

enum ValidatedType:Int{
    //        case BirthDate = 0,PhoneNumber,Email,QQNumber,WechatNumber
    case BirthDate = 0,Email,QQNumber,WechatNumber,Phone,VerifyCode,UserName,Password,RealName
}

class InfoVerify: NSObject {

    
    
    
    
    
    
    func EmailIsValidated(vStr: String) -> Bool {
        return ValidateText(validatedType: .Email, validateString: vStr)
    }
    func PhoneIsValidated(vStr: String) -> Bool {
        return ValidateText(validatedType: .Phone, validateString: vStr)
    }
    
    func QQNumberIsValidated(vStr: String) -> Bool {
        return ValidateText(validatedType: .QQNumber, validateString: vStr)
    }
    func PasswordIsValidated(vStr: String) -> Bool {
        return ValidateText(validatedType: .QQNumber, validateString: vStr)
    }
    
    func ValidateText(validatedType type: ValidatedType, validateString: String) -> Bool {
        do {
            let pattern: String
            if type == .Email {
                pattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            } else if type == .QQNumber {
                pattern = "^[0-9]{5,12}$"
            } else if type == .WechatNumber {
                pattern = "^[a-zA-Z]{1}[-_a-zA-Z0-9]{5,19}+$"
            } else if type == .Phone {
                pattern = "^1[0-9]{10}$"
            } else if type == .VerifyCode {
                pattern = "^[a-z0-9]{5}$"
            } else if type == .UserName {
                pattern = "^[a-zA-Z0-9_]{6,12}$"
            } else if type == .Password {
                pattern = "^([a-zA-Z0-9_\\.-@]+){6,12}$"
            } else if type == .BirthDate {
                pattern = "^[0-9/]{6,12}$"
            } else if type == .RealName {
                pattern = "^[\\u4E00-\\u9FA5]{2,5}+$"
            } else {
                pattern = "^[0-9]{0,20}$"
            }
            
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: validateString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, validateString.characters.count))
            return matches.count > 0
        }
        catch {
            return false
        }
    }
}
