//
//  LogoutController.swift
//  FuTu
//
//  Created by Administrator1 on 10/11/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class LogoutController: NSObject {

    
    //===========================================
    //Mark:- 用户主动退出登陆，清空持久存储信息
    //===========================================
    class func logOut() -> Void {
        tlPrint(message: "logOut function")
        let removeItems:Array = [userDefaultsKeys.userHasLogin.rawValue,userDefaultsKeys.userInfoBalance.rawValue, "gestureLockStatus", "touchIDStatus"]
        let userDefaults = UserDefaults.standard
        for i in removeItems {
            userDefaults.removeObject(forKey: i)
        }
    }
    
    //===========================================
    //Mark:- 清除用户基本信息
    //===========================================
    class func clearnUserInfo() -> Void {
        tlPrint(message: "clearnUserInfo")
        let clearnItems = [userDefaultsKeys.userInfoAccountName.rawValue,
                           userDefaultsKeys.userInfoBalance.rawValue,
                           userDefaultsKeys.userInfoBirthDate.rawValue,
                           userDefaultsKeys.userInfoDayWithdrawCount.rawValue,
                           userDefaultsKeys.userInfoDayWithdrawMax.rawValue,
                           userDefaultsKeys.userInfoEmail.rawValue,
                           userDefaultsKeys.userInfoId.rawValue,
                           userDefaultsKeys.userInfoIsBankBound.rawValue,
                           userDefaultsKeys.userInfoIsBasicBound.rawValue,
                           userDefaultsKeys.userInfoIsEmailBound.rawValue,
                           userDefaultsKeys.userInfoIsPhoneBound.rawValue,
                           userDefaultsKeys.userInfoLastLogin.rawValue,
                           userDefaultsKeys.userInfoMobile.rawValue,
                           userDefaultsKeys.userInfoQQ.rawValue,
                           userDefaultsKeys.userInfoWechat.rawValue,
                           userDefaultsKeys.userInfoUserLevel.rawValue,
                           userDefaultsKeys.userInfoRealName.rawValue,
                           userDefaultsKeys.userInfoSex.rawValue,
                           userDefaultsKeys.userInfoRegisterTime.rawValue]
        
        
        for item in clearnItems {
            userDefaults.removeObject(forKey: item)
        }
    }
}

class ClearnUserInfoController: NSObject {
    

    //===========================================
    //Mark:- 清除用户基本信息
    //===========================================
    class func clearnUserInfo() -> Void {
        tlPrint(message: "clearnUserInfo")
        let clearnItems = [userDefaultsKeys.userInfoAccountName.rawValue,
                          userDefaultsKeys.userInfoBalance.rawValue,
                          userDefaultsKeys.userInfoBirthDate.rawValue,
                          userDefaultsKeys.userInfoDayWithdrawCount.rawValue,
                          userDefaultsKeys.userInfoDayWithdrawMax.rawValue,
                          userDefaultsKeys.userInfoEmail.rawValue,
                          userDefaultsKeys.userInfoId.rawValue,
                          userDefaultsKeys.userInfoIsBankBound.rawValue,
                          userDefaultsKeys.userInfoIsBasicBound.rawValue,
                          userDefaultsKeys.userInfoIsEmailBound.rawValue,
                          userDefaultsKeys.userInfoIsPhoneBound.rawValue,
                          userDefaultsKeys.userInfoLastLogin.rawValue,
                          userDefaultsKeys.userInfoMobile.rawValue,
                          userDefaultsKeys.userInfoQQ.rawValue,
                          userDefaultsKeys.userInfoWechat.rawValue,
                          userDefaultsKeys.userInfoUserLevel.rawValue,
                          userDefaultsKeys.userInfoRealName.rawValue,
                          userDefaultsKeys.userInfoSex.rawValue,
                          userDefaultsKeys.userInfoRegisterTime.rawValue]
        
        
        for item in clearnItems {
            userDefaults.removeObject(forKey: item)
        }
    }
    

}

