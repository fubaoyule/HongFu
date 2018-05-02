//
//  OnlinePayViewController.swift
//  FuTu
//
//  Created by Administrator1 on 29/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit
import WebKit

class OnlinePayViewController: UIViewController,WKUIDelegate, WKNavigationDelegate {

    
    let baseVC = BaseViewController()
    var width,height: CGFloat!
    let navBarHeight = 44
    var wkWebView: WKWebView!
    var indicator:TTIndicators!
    var payType:PayType!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.width = self.view.frame.width
        self.height = self.view.frame.height
        tlPrint(message: "viewDidLoad")
        initNavigationBar()
    }
    
    
    init(param:AnyObject,payType:PayType) {
        super.init(nibName: nil, bundle: nil)
        self.payType = payType
        initWebView(param: param)
    
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initWebView(param:AnyObject) -> Void {
        tlPrint(message: "initWebView:\n")
        tlPrint(message: param)
        if wkWebView == nil {
            configWebView()
        }
        
        let message: String = (param as AnyObject).value(forKey: "Message") as! String
        
        tlPrint(message: "message: \(message)")
        
        
        
//        wkWebView.loadHTMLString(message, baseURL: URL.init(fileURLWithPath: Bundle.main.bundlePath))
        
        
        
        
        
        
        // WKWebView加载请求
//        webView.load(request as URLRequest)
        wkWebView.loadHTMLString(message, baseURL: URL.init(fileURLWithPath: Bundle.main.bundlePath))
        
    }
    
    //Generates script to create given cookies
    public func getJSCookiesString(cookies: [HTTPCookie]) -> String {
        var result = ""
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        
        for cookie in cookies {
            result += "document.cookie='\(cookie.name)=\(cookie.value); domain=\(cookie.domain); path=\(cookie.path); "
            if let date = cookie.expiresDate {
                result += "expires=\(dateFormatter.string(from: date)); "
            }
            if (cookie.isSecure) {
                result += "secure; "
            }
            result += "'; "
        }
        return result
    }
    
    
    
    //网页中有target="_blank" 在新窗口打开链接,需要实现配置
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        tlPrint(message: "create WebView With configuration")
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        } else if !(navigationAction.targetFrame?.isMainFrame)! {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
     //如果是跳转一个新页面
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        tlPrint(message: "decidePolicyFor navigationAction webView.url:\(String(describing: webView.url))")

        if self.payType == PayType.WechatScanPay {
            
            UIApplication.shared.openURL(webView.url!)
            decisionHandler(.allow)
            return
        }
        
        if (navigationAction.targetFrame == nil) {
            webView.load(navigationAction.request)
        }
        decisionHandler(.allow)
    }
    
    
    
    //===========================================
    //Mark:- WKUIDelegate代理方法-［生命周期］
    //===========================================
    //** 警告框 **
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        tlPrint(message: "runJavaScriptAlertPanelWithMessage message:\(message)")
        let alert = UIAlertController(title: "提 示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            // We must call back js
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //** 确认框 **
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        tlPrint(message: "runJavaScriptConfirmPanelWithMessage message:\(message)")
        let alert = UIAlertController(title: "提 示", message: message, preferredStyle: .alert)
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
    
    
    
    private func configWebView() {
        
        tlPrint(message: "configWebView")
        //Mark:- HTML5调用Native部分
//        let scriptHandle = WKUserContentController()    //新建一个处理类
//        let config = WKWebViewConfiguration()   //新建一个WKWebView的配置
//        config.userContentController = scriptHandle
        
        //获取cookies并放入请求头部
        let userContentController = WKUserContentController()
        if let cookies = HTTPCookieStorage.shared.cookies{
            print(cookies)
            let script = getJSCookiesString(cookies: cookies)
            let cookieScript = WKUserScript(source: script, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
            userContentController.addUserScript(cookieScript)
        }
        let webviewConfig = WKWebViewConfiguration()
        webviewConfig.userContentController = userContentController
        
        
        //Mark:- 网页加载部分
        let bouds = self.view.frame
        let wkFrame = CGRect(x: 0, y: 64, width: bouds.width, height: bouds.height - 64)
        self.automaticallyAdjustsScrollViewInsets = false
        // 创建WKWebView
        wkWebView = WKWebView(frame: wkFrame ,configuration: webviewConfig)
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        self.view.addSubview(wkWebView)
    }

    
    func initNavigationBar() -> Void {
        //view
        //let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: 20 + navBarHeight))
        
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: Int(width), height: 20 + navBarHeight))
        self.view.addSubview(navigationView)
        let gradientLayer = CAGradientLayer.GradientLayer(topColor: UIColor.colorWithCustom(r: 65, g: 50, b: 48), buttomColor: UIColor.colorWithCustom(r: 43, g: 38, b: 34))
        gradientLayer.frame = navigationView.frame
        navigationView.layer.insertSublayer(gradientLayer, at: 0)
        
        
        let userDefaults = UserDefaults.standard
        var bankName:String
        if let bankName_t = userDefaults.value(forKey: "onlinePayName") {
            bankName = bankName_t as! String
            
        } else {
            bankName = "鸿福支付"
        }
        //label
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: Int(width), height: navBarHeight))
        setLabelProperty(label: titleLabel, text: bankName, aligenment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .clear, font: 17)
        navigationView.addSubview(titleLabel)
        
        
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        navigationView.addSubview(backBtn)
        //back button image
//        let backBtnImg = UIImageView(frame: CGRect(x: 10, y: 12, width: 12, height: 20))
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
        
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        tlPrint(message: "didStartProvisionalNavigation：\(String(describing: webView.url))")
        if self.indicator == nil {
            self.indicator = TTIndicators(view: self.view, frame: portraitIndicatorFrame)
            
        } else {
            self.indicator.play(frame: portraitIndicatorFrame)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        tlPrint(message: "didFinish：\(String(describing: webView.url))")
        if self.indicator != nil {
            indicator.stop()
        }
        
    }
    
    
    @objc func btnAct(sender:UIButton) -> Void {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func setLabelProperty(label:UILabel,text:String,aligenment:NSTextAlignment,textColor:UIColor,backColor:UIColor,font:CGFloat) -> Void {
        label.text = text
        label.textAlignment = aligenment
        label.textColor = textColor
        label.backgroundColor = backColor
        label.font = UIFont.systemFont(ofSize: font)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
