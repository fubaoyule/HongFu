//
//  SystemTool.swift
//  FuTu
//
//  Created by Administrator1 on 10/10/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit
import AudioToolbox
import SafariServices


class SystemTool: NSObject {

    
    //系统声音
    class func systemSound(soundNumber: Int) -> Void {
        
//        let loopTimes = sender.value(forKey: "loopTimes") as! Int
//        let soundNumber = sender.value(forKey: "soundNumber")as! Int
//        let intervalTime = sender.value(forKey: "intervalTime")as! Int
        //        //建立的SystemSoundID对象
        //        var soundID:SystemSoundID = 1000
        //        //获取声音地址
        //        let path = Bundle.main.path(forResource: "alertsound", ofType: "wav")
        //        //地址转换
        //        let baseURL = NSURL(fileURLWithPath: path!)
        //        //赋值
        //        AudioServicesCreateSystemSoundID(baseURL, &soundID)
        //        //播放声音
        //        AudioServicesPlaySystemSound(soundID)
        //播放系统声音
        //for _ in 1 ... loopTimes {
            AudioServicesPlaySystemSound(SystemSoundID(soundNumber))
            //sleep(UInt32(intervalTime))//间隔时常
        //}
    }
    
    //系统提醒
    class func systemAlert() -> Void {
        //        //建立的SystemSoundID对象
        //        var soundID:SystemSoundID = 0
        //        //获取声音地址
        //        let path = Bundle.main.path(forResource: "msg", ofType: "wav")
        //        //地址转换
        //        let baseURL = NSURL(fileURLWithPath: path!)
        //        //赋值
        //        AudioServicesCreateSystemSoundID(baseURL, &soundID)
        //        //提醒（同上面唯一的一个区别）
        //        AudioServicesPlayAlertSound(soundID)
    }
    
    //系统震动
    class func systemVibration(loopTimes: Int, intervalTime: UInt32) -> Void {
        
        let soundID = SystemSoundID(kSystemSoundID_Vibrate)
        //for i in 1 ... loopTimes {
            //tlPrint(message: "systemVibration:\(i)")
            AudioServicesPlaySystemSound(soundID)
            //sleep(intervalTime)//间隔时常
        //}
    }
    
    class func openSafiri(withUrl: String, viewController: UIViewController) -> Void {
        
        if #available(iOS 9.0, *) {
            let safari = SFSafariViewController(url: URL(string: withUrl)!)
            viewController.present(safari, animated: true, completion: nil)
            
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    class func systemSetting(urlString: String){
    
        let url = URL(string: urlString)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.openURL(url!)
            
        
        }
    }
    
    //使用MobileCoreServices.framework里的私有API:
    //  - (BOOL)openSensitiveURL:(id)arg1 withOptions:(id)arg2;
    //  头文件参考：LSApplicationWorkspace.h
//    class func systemSettingsForIOS10(urlString: String){
//    
//        let url = URL(string: "Prefs:root=Privacy&path=LOCATION")
//        let LSApplicationWorkspace = NSClassFromString("LSApplicationWorkspace")
//        
//        LSApplicationWorkspace?.performSelector(inBackground: <#T##Selector#>, with: <#T##Any?#>)
//    }
    
    
    class func openSettints() {
        let url = URL(string: UIApplicationOpenSettingsURLString)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.openURL(url!)
        }
    }
    
}
