//
//  SystemInfo.swift
//  FuTu
//
//  Created by Administrator1 on 10/10/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit
import AdSupport
class SystemInfo: NSObject {

    //获取设备唯一标志码
    class func getDeviceUUID() -> String {
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        return uuid!
    }
    
    class func getAdID() -> String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    class func getBundleID() -> String {
        return Bundle.main.bundleIdentifier!
    }


    
    
    //获取当前版本号
    class func getCurrentVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        tlPrint(message: "current version: \(String(describing: version))")
        return version as! String
    }
}
