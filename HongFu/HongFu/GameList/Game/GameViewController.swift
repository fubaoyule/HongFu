//
//  GameViewController.swift
//  FuTu
//
//  Created by Administrator1 on 23/10/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit
import WebKit


class GameViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {


    var param: AnyObject!
    var isFromLandscap = false  //上一页的屏幕方向（默认竖屏）
    var wkWebView: WKWebView!
    var indicator : TTIndicators!
    let screenSize = UIScreen.main.bounds.size
    var gameType:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.gray
        tlPrint(message: "game view controller")
        // 检测设备方向
        self.gameType = userDefaults.value(forKey: userDefaultsKeys.gameType.rawValue) as! String
//        if self.gameType == "AG" {
//            NotificationCenter.default.addObserver(self, selector: #selector(self.receivedRotation), name: .UIDeviceOrientationDidChange, object: nil)
//        }
        
        //旋转当前页面到指定的方向
        if let orientation = self.param.value(forKey: "orientation") {
            if (orientation as! String) == "right" {
                self.rotateToLanscap()
            } else if (orientation as! String) == "portrait" {
                self.rotateToPortrait()
            } else if (orientation as! String) == "all" {
                self.rotateToAll()
            }
        }
        configWebView(sender: param)
        //判断是否需要返回按钮
        if param.value(forKey: "notNeedReturnBtn") == nil {
            initReturnBtn()
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        //修改状态栏颜色
        return UIStatusBarStyle.lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
    
        if let orientation = self.param.value(forKey: "orientation") {
            if (orientation as! String) == "portrait" {
                self.rotateToPortrait()
                return
            } else if (orientation as! String) == "all" {
                self.rotateToAll()
                return
            } else {
                self.rotateToLanscap()
            }
        }
    }
    
    //===========================================
    //Mark:- WKUIDelegate代理方法-［生命周期］
    //===========================================
    //** 警告框 **
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        tlPrint(message: "runJavaScriptAlertPanelWithMessage message:\(message)")
        let alert = UIAlertController(title: "鸿福娱乐", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            // We must call back js
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //** 确认框 **
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        tlPrint(message: "runJavaScriptConfirmPanelWithMessage message:\(message)")
        let alert = UIAlertController(title: "鸿福娱乐", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            // 点击完成后，可以做相应处理，最后再回调js端
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) -> Void in
            // 点击取消后，可以做相应处理，最后再回调js端
            completionHandler(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //** 输入框 **
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        tlPrint(message: "runJavaScriptTextInputPanelWithPrompt")
        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) -> Void in
            textField.textColor = UIColor.red
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
            // 处理好之前，将值传到js端
            completionHandler(alert.textFields![0].text!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //===========================================
    //Mark:- WKNavigationDelegate代理方法-［生命周期］
    //===========================================
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        tlPrint(message: "webView didStartProvisionalNavigation")
        let indicatorFrame: CGRect!
        tlPrint(message: "game start Url: \(String(describing: webView.url))")
        tlPrint(message: "还没有gameType 传递过来")
        if currentScreenOritation == UIInterfaceOrientationMask.portrait {
            indicatorFrame = portraitIndicatorFrame
        } else {
            indicatorFrame = landscapeIndicatorFrame
            tlPrint(message: "当前为横屏")
        }
        if indicator == nil {
            indicator = TTIndicators(view: wkWebView, frame: indicatorFrame)
        }
        indicator.play(frame: indicatorFrame)
        
        //判断是否在请求列表页
        if let currentURL = wkWebView.url {
            
            if (String(describing: currentURL).range(of: "_List") != nil) {
                tlPrint(message: "需要跳转回列表页")
                if isFromLandscap {
                    RotateScreen.right()
                }
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController){
        tlPrint(message: "webView commitPreviewingViewController")
    }
    
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        tlPrint(message: "webView didFinish")

        if indicator != nil {
            let userDefaults = UserDefaults.standard
            if let gameType = userDefaults.value(forKey: userDefaultsKeys.gameType.rawValue){
                if gameType as! String == "BS" {
                    sleep(5)
                }
            }
            indicator.stop()
        }
        
        let gameUrl = webView.url
        tlPrint(message: "game end Url: \(String(describing: gameUrl))")
        tlPrint(message: "game end time: \(getTime())")
    }
    

    /*GD failed url:
    http://gd.toobet.com/main.php?OperatorCode=futuu0026lang=zh-cnu0026playerid=Taylor4u0026LoginTokenID=KXNYfrJKX4wu0026Currency=CNYu0026Key=af8af420f94a1cbd6b6e3ee1bf8ee1523b65f77901edf1d8d268c443b7003e83u0026mobile=1
     
    http://gd.toobet.com/main.php?OperatorCode=futu&lang=zh-cn&playerid=tiger01&LoginTokenID=9vqT7lhu6jg&Currency=CNY&Key=c1f6404cedabfb246877fa8977e234975fcc744ddb25755bc65626dbe30e644f&mobile=1

     GD html success url:
 
     */
    
    
    
    //==============================
    //Mark:- 初始化网络视图，加载默认网页
    //==============================
    private func configWebView(sender: AnyObject) {
        
        tlPrint(message: "configWebView")
        //Mark:- HTML5调用Native部分
        let scriptHandle = WKUserContentController()    //新建一个处理类
        //addScriptHanle(handle: scriptHandle)
        let config = WKWebViewConfiguration()   //新建一个WKWebView的配置
        config.userContentController = scriptHandle
        //Mark:- 网页加载部分
        let bouds = self.view.frame
        var wkFrame = CGRect(x: 0, y: 0, width: bouds.width, height: bouds.height)
        let userDefaults = UserDefaults.standard
        
        if let gameType = userDefaults.value(forKey: userDefaultsKeys.gameType.rawValue) {
            tlPrint(message: "gameType:\(gameType)")
            let gameType = gameType as! String
            if currentScreenOritation == .portrait || gameType == "service"  {
                wkFrame = CGRect(x: 0, y: 0, width: bouds.width, height: bouds.height - 0)
            } else if gameType == "BS" {
                self.initHomeBtn()
            }else if gameType == "MG" {
                
                if let type = param.value(forKey: "gameType") {
                    if type as! String == "MGRecord" {
                    wkFrame = CGRect(x: 0, y: 0, width: bouds.width, height: bouds.height)
                
                    }
                } else {
                
                let titleViewHeight = adapt_H(height: isPhone ? 36 : 24)
                wkFrame = CGRect(x: 0, y: titleViewHeight, width: bouds.width, height: bouds.height - titleViewHeight)
                
                let titleViewFrame = CGRect(x: 0, y: 0, width: bouds.width, height: titleViewHeight)
                let titleView = UIView(frame: titleViewFrame)
                titleView.backgroundColor = UIColor.white
                self.view.addSubview(titleView)
                
                let logoImg = UIImageView(frame: CGRect(x: 10, y: 3, width: adapt_W(width: isPhone ? 68 : 50), height: adapt_H(height: isPhone ? 30 : 20)))
                logoImg.image = UIImage(named: "Game_MG_hongfulogo.png")
                titleView.addSubview(logoImg)
                
                let baseVC = BaseViewController()
                let recordFrame = CGRect(x: bouds.width - adapt_W(width: isPhone ? 70 : 50), y: adapt_H(height: isPhone ? 8 : 6), width: adapt_W(width: isPhone ? 60 : 40), height: adapt_H(height: isPhone ? 20 : 12))
                let recordBtn = baseVC.buttonCreat(frame: recordFrame, title: "投注记录", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named: "Game_MG_recordBtn_bg.png"), hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 14 : 10), events: .touchUpInside)
                recordBtn.tag = gameViewBtnTag.Game_MGRecordBtnTag.rawValue
                titleView.addSubview(recordBtn)
                let btnNameLabel = baseVC.labelCreat(frame: CGRect(x: 0, y: 0, width: recordFrame.width, height: recordFrame.height), text: "投注记录", aligment: .center, textColor: .white, backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 10 : 7))
                recordBtn.addSubview(btnNameLabel)
                }
            } else if gameType == "MGRecord" {
                wkFrame = CGRect(x: 0, y: adapt_H(height: isPhone ? -130 : -120), width: bouds.width, height: bouds.height)
            }
//            else if gameType == "AG" || gameType == "AGFish"{
//                
//            }
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        wkWebView = WKWebView(frame: wkFrame, configuration: config)
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        wkWebView.backgroundColor = UIColor.black
//        wkWebView.scrollView.showsVerticalScrollIndicator = false
//        wkWebView.scrollView.alwaysBounceVertical = true
        wkWebView.scrollView.bounces = false//关闭回弹效果
//        wkWebView.scrollView.isScrollEnabled = false
        self.view.insertSubview(wkWebView, at: 0)
        rotateScreen(sender: sender)
        
        
        
        //根据参数的地址显示游戏界面
        if let urlString = sender.value(forKey: "url") {
            tlPrint(message: "urlString:\(urlString)")
            if (urlString as! String) == "Failed" || (urlString as! String) == "" {
                tlPrint(message: "没有获取到游戏链接")
                let alert = UIAlertView(title: "", message: "获取游戏地址失败", delegate: nil, cancelButtonTitle: "确 认")
                DispatchQueue.main.async {
                    alert.show()
                }
                _ = self.navigationController?.popViewController(animated: true)
                return
            }
            var urlString_success = (urlString as! String).replacingOccurrences(of: "u0026", with: "&")
            urlString_success = urlString_success.replacingOccurrences(of: " ", with: "")
            let url = URL(string: urlString_success)
            tlPrint(message: "url:\(String(describing: url))")
            tlPrint(message: "gameType:\(gameType)")
            var cachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
            if let gameType = userDefaults.value(forKey: userDefaultsKeys.gameType.rawValue) {
                if gameType as! String == "service" {
                    cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
                }
            }
            
            let request = URLRequest(url: url!, cachePolicy: cachePolicy, timeoutInterval: 10)
            wkWebView.load(request)
        } else {
            tlPrint(message: "没有拿到游戏地址")
        }
        tlPrint(message: "configWebView end")
    }
    
    
    
    
    //==============================
    //Mark:- 初始化返回按钮
    //==============================
    
    private func initReturnBtn() {
        
        tlPrint(message: "gameVC size: \(screenSize)")
        var returnFrame: CGRect!
        let returnBtn = UIButton()
        self.view.insertSubview(returnBtn, at: 1)
        if currentScreenOritation == UIInterfaceOrientationMask.all {
            //当前不控制屏幕方向
            //当前页面为竖屏
            returnFrame = CGRect(x: 0, y: 0, width: adapt_W(width: 40), height: adapt_H(height: 60))
            returnBtn.setImage(UIImage(named: "returnIcon"), for: .normal)
            returnBtn.backgroundColor = UIColor.clear
        }  else if currentScreenOritation == UIInterfaceOrientationMask.portrait {
            //当前页面为竖屏
            returnFrame = CGRect(x: 0, y: 0, width: adapt_W(width: 40), height: adapt_H(height: 60))
            returnBtn.setImage(UIImage(named: "returnIcon"), for: .normal)
            returnBtn.backgroundColor = UIColor.clear
        } else {
            //当前页面为横屏
            returnFrame = CGRect(x: adapt_W(width: -5), y: screenSize.height / 2 - adapt_H(height: 50), width: adapt_W(width: 40), height: adapt_H(height: 100))
            
            let gameType = userDefaults.value(forKey: userDefaultsKeys.gameType.rawValue) as! String
            returnBtn.setImage(UIImage(named: "img_backBtn"), for: .normal)
            let backWidht = adapt_W(width: 50)
            if gameType == "newPT" {
                returnFrame = CGRect(x: self.view.frame.width - backWidht - adapt_W(width: 10), y: adapt_H(height: 10), width: backWidht, height: backWidht)
                
                returnBtn.setImage(UIImage(named:"Game_backImg_newPT.png"), for: .normal)
            } else if gameType == "SG" {
                returnFrame = CGRect(x: adapt_W(width: 5), y: adapt_H(height: 10), width: backWidht, height: backWidht)
                
                returnBtn.setImage(UIImage(named:"Game_backImg_newPT.png"), for: .normal)
            } else if gameType == "MG" {
                returnFrame = CGRect(x: adapt_W(width: 5), y: adapt_H(height: 40), width: backWidht, height: backWidht)
                
                returnBtn.setImage(UIImage(named:"Game_backImg_newPT.png"), for: .normal)
            }
        }
        returnBtn.frame = returnFrame
        tlPrint(message: "returnBtn.frame = \(returnBtn.frame)")
        returnBtn.addTarget(self, action: #selector(gameReturnAct), for: .touchUpInside)
    }
    
    
    func initHomeBtn() -> Void {
        let baseVC = BaseViewController()
        let homeWidth = adapt_W(width: 50)
        let homeFrame = CGRect(x: self.view.frame.width - homeWidth, y: adapt_H(height: 40), width: homeWidth, height: homeWidth)
        let homeBtn = baseVC.buttonCreat(frame: homeFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.view.insertSubview(homeBtn, at: 1)
        homeBtn.tag = gameViewBtnTag.Game_BS_homeBtnTag.rawValue
    }

    @objc func gameReturnAct() {
        tlPrint(message: "gameReturnAct")
        //返回的时候页面有可能正在loading,页面被禁止交互
        if gameType != "MGRecord" {
            self.rotateToPortrait()
        }
        if indicator != nil {
            indicator.stop()
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //========================
    //Mark:- 旋转屏幕
    //========================
    func  rotateScreen(sender: AnyObject) -> Void {
        
        tlPrint(message: "rotateScrenn sender: \(sender)")
        
        if let oritation = sender.value(forKey: "orientation") {
            switch oritation as! String {
            case "portrait":
                RotateScreen.portrait()
            case "right":
                RotateScreen.right()
            case "left":
                RotateScreen.left()
            default:
                break
            }
        } else {
            tlPrint(message: "没有收到旋转屏幕的命令")
        }
    }
    
    @objc func btnAct(sender:UIButton) -> Void {
        tlPrint(message: sender.tag)
        switch sender.tag {
        case gameViewBtnTag.Game_MGRecordBtnTag.rawValue:
            tlPrint(message: "MG 游戏投注记录按钮")
            let model = GameModel()
            model.getMGRecordURL(success: { (url) in
                tlPrint(message: "url:\(url)")
                let recordVC = GameViewController()
                recordVC.param = ["gameType":"MGRecord", "orientation":"right", "url":url] as AnyObject
                self.navigationController?.pushViewController(recordVC, animated: true)
            }, failure: { 
                tlPrint(message: "没有拿到MG的投注记录链接")
            })
        case gameViewBtnTag.Game_BS_homeBtnTag.rawValue:
            tlPrint(message: "BS home按钮")
            self.navigationController?.popViewController(animated: true)
        default:
            tlPrint(message: "no such case!")
        }
    }
    
    
    //旋转到横屏
    func rotateToLanscap() -> Void {
        
        currentScreenOritation = UIInterfaceOrientationMask.landscapeRight
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = UIInterfaceOrientationMask.landscapeRight
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    //旋转到竖屏
    func rotateToPortrait() -> Void {
        tlPrint(message: "旋转到竖屏")
        currentScreenOritation = UIInterfaceOrientationMask.portrait
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = UIInterfaceOrientationMask.portrait
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    //
    func rotateToAll() -> Void {
        tlPrint(message: "旋转到竖屏")
        currentScreenOritation = UIInterfaceOrientationMask.all
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = UIInterfaceOrientationMask.all
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    func receivedRotation() -> Void {
        // 屏幕方向
        let wkFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 0)
        switch UIDevice.current.orientation {
        case UIDeviceOrientation.unknown:
            print("方向未知")
        case .portrait: // Device oriented vertically, home button on the bottom
            print("屏幕直立")
        case .portraitUpsideDown: // Device oriented vertically, home button on the top
            print("屏幕倒立")
        case .landscapeLeft: // Device oriented horizontally, home button on the right
            print("屏幕左在上方")
        case .landscapeRight: // Device oriented horizontally, home button on the left
            print("屏幕右在上方")
        case .faceUp: // Device oriented flat, face up
            print("屏幕朝上")
        case .faceDown: // Device oriented flat, face down
            print("屏幕朝下")
        }
        self.wkWebView.frame = wkFrame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
