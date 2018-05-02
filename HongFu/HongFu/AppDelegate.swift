//
//  AppDelegate.swift
//  HongFu
//
//  Created by Administrator1 on 24/11/17.
//  Copyright © 2017年 Taylor Tan. All rights reserved.
//

import UIKit
import SafariServices
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIAlertViewDelegate {
    
    var window: UIWindow?
    var launchView: UIView?
    var blockRotation = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        //判断是否手机打开的app
        isPhone = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiom.phone)
        
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) == nil {
            
            userDefaults.setValue(isRelease ? "https://m.whf999.com/" : "http://mhf.toobet.co/", forKey: userDefaultsKeys.domainName.rawValue)//正式域名
//            userDefaults.setValue(isRelease ? "http://m.whf138.com/" : "http://mhf.toobet.co/", forKey: userDefaultsKeys.domainName.rawValue)//正式域名
//            userDefaults.setValue(isRelease ? "http://m.whf6666.com/" : "http://mhf.toobet.co/", forKey: userDefaultsKeys.domainName.rawValue)//正式域名
            
//            webApi = (isRelease ? "http://mapi.toobet.net" : "http://api.toobet.com")
            
            
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        let tabVC = CustomTabBarController()
        let rootVC = UINavigationController(rootViewController:tabVC);
        self.window?.rootViewController = rootVC
        return true
    }
    
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return blockRotation
    }
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        tlPrint(message: "applicationWillResignActive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        tlPrint(message: "applicationDidEnterBackground")
        
        
    }
    
    
    //dinpay回调函数
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return DPPlugin.handlePaymentResult(url)
    }
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return DPPlugin.handlePaymentResult(url)
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return DPPlugin.handlePaymentResult(url)
    }
    //dinpay回调函数结束
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        tlPrint(message: "applicationWillEnterForeground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        tlPrint(message: "applicationDidBecomeActive")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        tlPrint(message: "applicationWillTerminate")
    }
    
    //=====================
    //消息推送相关
    //=====================
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //获取DevictToken
        //
        //        tlPrint(message: "fun: didRegisterForRemoteNotificationsWithDeviceToken")
        //        var token: String = ""
        //        for i in 0..<deviceToken.count {
        //            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        //        }
        //        tlPrint(message: "token:\(token)")
        
        
        
        
        //        var token:String = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        //        token = token.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSString.CompareOptions.LiteralSearch, range: nil)
        //        let token = deviceToken as String
        //        token = deviceToken.description.trimmingCharacters(in: CharacterSet)
        //        token = deviceToken.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        //
        //        tlPrint(message: "token:\(token)")
        
    }
    
    //    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    //        //收到推送消息
    //        tlPrint(message: "didReceiveRemoteNotification")
    //    }
    //
    //    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    //        //获取DeviceToken失败
    //        tlPrint(message: "didFailToRegisterForRemoteNotificationsWithError")
    //    }
    //
    //    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    //        //收取消息通知失败
    //        tlPrint(message: "didReceiveRemoteNotification")
    //    }
    
    
    
    
    
    
}


