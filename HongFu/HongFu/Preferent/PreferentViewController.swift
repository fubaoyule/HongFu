//
//  PreferentViewController.swift
//  FuBao
//
//  Created by Administrator1 on 16/8/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit
import WebKit

enum PageType {
    case singin
    case preferent
}


class PreferentViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIAlertViewDelegate, URLSessionDelegate {

    
    var wkWebView: WKWebView!
    var indicator : TTIndicators!
    let screenSize = UIScreen.main.bounds.size
    var pageType:PageType!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.gray
        tlPrint(message: "game view controller")
        self.configWebView()
//        //判断是否需要返回按钮
        if self.pageType == PageType.singin {
            initReturnBtn()
        }
    }
    
    init(pageType:PageType) {
        super.init(nibName: nil, bundle: nil)
        self.pageType = pageType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        //修改状态栏颜色
        return UIStatusBarStyle.lightContent
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
        tlPrint(message: "game start Url: \(String(describing: webView.url))")

        if indicator == nil {
            indicator = TTIndicators(view: wkWebView, frame: portraitIndicatorFrame)
        }
        indicator.play(frame: portraitIndicatorFrame)
    }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController){
        tlPrint(message: "webView commitPreviewingViewController")
    }
    
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        tlPrint(message: "webView didFinish")
        
        if indicator != nil {
            indicator.stop()
        }
        let gameUrl = webView.url
        tlPrint(message: "game end Url: \(String(describing: gameUrl))")
        tlPrint(message: "game end time: \(getTime())")
//        self.sendToken()
    }
    
    
    
    
    //==============================
    //Mark:- 初始化网络视图，加载默认网页
    //==============================
    private func configWebView() {
        
        tlPrint(message: "configWebView")
        //Mark:- HTML5调用Native部分
        let scriptHandle = WKUserContentController()    //新建一个处理类
        addScriptHanle(handle: scriptHandle)
        let config = WKWebViewConfiguration()   //新建一个WKWebView的配置
        config.userContentController = scriptHandle
        //Mark:- 网页加载部分
        let bouds = self.view.frame
        let wkFrame = CGRect(x: 0, y: 0, width: bouds.width, height: bouds.height)
        let userDefaults = UserDefaults.standard
        
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        wkWebView = WKWebView(frame: wkFrame, configuration: config)
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        wkWebView.backgroundColor = UIColor.white
//        wkWebView.scrollView.showsVerticalScrollIndicator = false
//        wkWebView.scrollView.alwaysBounceVertical = true
        wkWebView.scrollView.bounces = false//关闭回弹效果
//        wkWebView.scrollView.isScrollEnabled = false
        self.view.insertSubview(wkWebView, at: 3)
        let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
        var token:String = ""
        if let token_t = userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue){
            token = token_t as! String
        }
        let pathDic = [PageType.singin:"Signin",PageType.preferent:"Promotion"]
        let urlString = domain + "\(pathDic[self.pageType] as! String)?isApp=true&token=\(token)"
        tlPrint("urlString = \(urlString)")
        let url = URL(string: urlString)
        
        clearCacheWithURL(url: url!)
        let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        wkWebView.load(request)
        tlPrint(message: "configWebView end")
        
//        self.initNavigationBar()
    }
    
    
//    func initNavigationBar() -> Void {
//        //view
//        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: deviceScreen.width, height: 20 + navBarHeight))
//        self.view.addSubview(navigationView)
//        let gradientLayer = CAGradientLayer.GradientLayer(topColor: UIColor.colorWithCustom(r: 65, g: 50, b: 48), buttomColor: UIColor.colorWithCustom(r: 43, g: 38, b: 34))
//        gradientLayer.frame = navigationView.frame
//        navigationView.layer.insertSublayer(gradientLayer, at: 0)
//        
//        //label
//        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: deviceScreen.width, height: navBarHeight))
//        setLabelProperty(label: titleLabel, text: "优惠活动", aligenment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .clear, font: 17)
//        navigationView.addSubview(titleLabel)
//    }
    
    //==============================
    //Mark:- 初始化返回按钮
    //==============================
    
    private func initReturnBtn() {
        
        tlPrint(message: "gameVC size: \(screenSize)")

        
       
        //back button
        let baseVC = BaseViewController()
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight), title: "", alignment: .center, target: self, myaction: #selector(gameReturnAct), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.view.addSubview(backBtn)
        backBtn.tag = personBtnTag.BackButton.rawValue
        //back button image
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
        
    }
    
//    var timer: Timer!
    func sendToken() {
        
        if let token = userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue){
            tlPrint(message: "token:\(token as! String)")
            self.wkWebView.evaluateJavaScript("getToken(\(token as! String))", completionHandler: { (response, error) in
                tlPrint(message: "**************  response:\(String(describing: response))\t error:\(String(describing: error))")
//                if (response != nil) {
//                    self.timer.invalidate()
//                }
            })
        }
//        let token = sender.value(forKey: "userInfo") as! String
        
//        self.wkWebView.evaluateJavaScript("getToken('\(token)')", completionHandler: { (response, error) in
//            tlPrint(message: "**************  response:\(String(describing: response))\t error:\(String(describing: error))")
//            if (response != nil) {
//                self.timer.invalidate()
//            }
//        })
        
    }
    
    //========================
    //Mark:- HTML5事件监听注册方法
    //========================
    private func addScriptHanle(handle:WKUserContentController) -> Void {
        let funcName = ["getToken1"]
        for name in funcName {
            handle.add(self, name: name)
        }
    }
    //=====================================
    //Mark:- WKScriptMessageHandler代理方法
    //=====================================
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let fun = message.name
        tlPrint(message: "fun = \(fun)")
        let arg: AnyObject = message.body as AnyObject
        switch fun {
        case "getToken":           //分享
            TLPrint("接受来至网络的请求")
            self.sendToken()
        default:
            tlPrint(message: "no such case!")
        }
    }
    
    
    
    @objc func gameReturnAct() {
        tlPrint(message: "gameReturnAct")
        if indicator != nil {
            indicator.stop()
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func refreshAct() -> Void {
        tlPrint(message: "refreshAct()")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
