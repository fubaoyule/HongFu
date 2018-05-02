////
////  ActivityDetailView.swift
////  FuTu
////
////  Created by Administrator1 on 30/12/16.
////  Copyright © 2016 Taylor Tan. All rights reserved.
////
//
//import UIKit
//import WebKit
//
//class ActivityDetailView: UIView {
//
//    var wkWebView: WKWebView!
////    var scroll: UIScrollView!
//    var width,height: CGFloat!
//    let model = ActivityDetailModel()
//    let baseVC = BaseViewController()
//    var delegate: BtnActDelegate!
//    var wkUIDelegate:WKUIDelegate!
//    var wkNavDelegate:WKNavigationDelegate!
//    var param:AnyObject!
//    
//    init(frame:CGRect, param:AnyObject,rootVC:UIViewController) {
//        super.init(frame: frame)
//        self.width = frame.width
//        self.height = frame.height
//        self.param = param
//        tlPrint(message: "param:\(param)")
//        self.delegate = rootVC as! BtnActDelegate
//        self.wkUIDelegate = rootVC as! WKUIDelegate
//        self.wkNavDelegate = rootVC as! WKNavigationDelegate
//        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
////        initScrollView()
//        initBackBtn()
//        initJoinBtn()
//        initWebView(id: 2)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
////    func initScrollView() -> Void {
////        
////        scroll = UIScrollView(frame: frame)
////        self.addSubview(scroll)
////        scroll.contentSize = CGSize(width: frame.width, height: height + 1)
////        scroll.showsVerticalScrollIndicator = false
////        scroll.showsHorizontalScrollIndicator = false
////        self.addSubview(scroll)
////        scroll.backgroundColor = UIColor.white
////        initStableView()
////        
////    }
//    
//    func initBackBtn() -> Void {
//        tlPrint(message: "service_banner.png")
//        //back button
//        let backFrame = CGRect(x: adapt_W(width: 12), y: adapt_H(height: 25), width: adapt_W(width: 35), height: adapt_W(width: 35))
//        let backBtn = baseVC.buttonCreat(frame: backFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"lobby_PT_back.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
//        
//        self.insertSubview(backBtn, at: 3)
//        backBtn.tag = ActivityDetailTag.backBtnTag.rawValue
//    }
//    
//    
////    func initStableView() -> Void {
////        tlPrint(message: "initStableView")
////        //banner
////        let banner = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: adapt_H(height: 170)))
////        scroll.addSubview(banner)
////        let url = URL(string: dataSource[0], relativeTo: URL(string: dataSource[1]))
////        banner.sd_setImage(with: url, placeholderImage: UIImage(named: "auto-image.png"))
////        let curveImg = UIImageView(frame: CGRect(x: 0, y: banner.frame.height - adapt_H(height: 50), width: width, height: adapt_H(height: 50)))
////        curveImg.image = UIImage(named: "prefer_detail_curve.png")
////        banner.addSubview(curveImg)
////        
////        let activeTimeImg = UIImageView(frame: CGRect(x: (width - adapt_W(width: 245)) / 2, y: banner.frame.height - adapt_H(height: 20), width: adapt_W(width: 245), height: adapt_H(height: 35)))
////        activeTimeImg.image = UIImage(named: "perfer_detail_time.png")
////        scroll.addSubview(activeTimeImg)
////        
////        let activeInfoImg = UIImageView(frame: CGRect(x: (width - adapt_W(width: 245)) / 2, y: activeTimeImg.frame.origin.y + adapt_H(height: 80), width: adapt_W(width: 245), height: adapt_H(height: 35)))
////        activeInfoImg.image = UIImage(named: "prefer_detail_info.png")
////        scroll.addSubview(activeInfoImg)
////        
////        
////        let joinView = UIView(frame: CGRect(x: 0, y: height - adapt_H(height: 70), width: width, height: adapt_H(height: 70)))
////        joinView.backgroundColor = UIColor.gray
////        joinView.alpha = 0.1
////        self.insertSubview(joinView, at: 2)
////        let joinFrame = CGRect(x: (width - adapt_W(width: 300)) / 2, y: height - adapt_H(height: 57), width: adapt_W(width: 300), height: adapt_H(height: 45))
////        let joinBtn = baseVC.buttonCreat(frame: joinFrame, title: "立即参加", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 245, g: 63, b: 0), fonsize: fontAdapt(font: 17), events: .touchUpInside)
////        self.insertSubview(joinBtn, at: 3)
////        joinBtn.layer.cornerRadius = adapt_H(height: 45 / 2)
////        joinBtn.tag = ActivityDetailTag.joinBtnTag.rawValue
////
////        
////    }
//    
//    func initWebView(id:Int) -> Void {
//        tlPrint(message: "initWebView:\nid = \(id)")
//        if wkWebView == nil {
//            configWebView()
//        }
//        
////        model.getActivityInfo(id: id, success: {(response) in
////            tlPrint(message: "response: \(response)")
////            let response_arry = response as! Array<Any>
////            tlPrint(message: "response_arry: \(response_arry)")
////            let message: String = (response_arry[2] as AnyObject).value(forKey: "Description") as! String
////            self.wkWebView.loadHTMLString(message, baseURL: URL.init(fileURLWithPath: Bundle.main.bundlePath))
////        }, failure: {(error) in
////            tlPrint(message: "获取活动详情的HTML代码失败了")
////        })
//        let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
//        let urlString = domain + (self.param.value(forKey: "link") as! String)
//        let url = URL(string: urlString)
//        let request = URLRequest(url: url!)
//        wkWebView.load(request)
//    }
//    
//    
//    func initJoinBtn() -> Void {
//        tlPrint(message: "initJoinBtn")
//        let joinView = UIView(frame: CGRect(x: 0, y: height - adapt_H(height: 70), width: width, height: adapt_H(height: 70)))
//        joinView.backgroundColor = UIColor.gray
//        joinView.alpha = 0.1
//        self.insertSubview(joinView, at: 2)
//        let joinFrame = CGRect(x: (width - adapt_W(width: 320)) / 2, y: height - adapt_H(height: 59), width: adapt_W(width: 320), height: adapt_H(height: 48))
//        let joinBtn = baseVC.buttonCreat(frame: joinFrame, title: "立即参加", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 245, g: 63, b: 0), fonsize: fontAdapt(font: 17), events: .touchUpInside)
//        self.insertSubview(joinBtn, at: 3)
//        joinBtn.layer.cornerRadius = adapt_H(height: 45 / 2)
//        joinBtn.tag = ActivityDetailTag.joinBtnTag.rawValue
//    }
//    
//    
//    
//    
//    
//    private func configWebView() {
//        
//        tlPrint(message: "configWebView")
//        //Mark:- HTML5调用Native部分
//        let scriptHandle = WKUserContentController()    //新建一个处理类
//        let config = WKWebViewConfiguration()   //新建一个WKWebView的配置
//        config.userContentController = scriptHandle
//        
//        //Mark:- 网页加载部分
//        //let wkFrame = CGRect(x: 0, y: adapt_H(height: 260), width: width, height: height - adapt_H(height: 260))
//        
//        wkWebView = WKWebView(frame: self.frame, configuration: config)
//        wkWebView.navigationDelegate = self.wkNavDelegate
//        wkWebView.uiDelegate = self.wkUIDelegate
//        self.insertSubview(wkWebView, at: 0)
//    }
//    
//    func btnAct(sender:UIButton) -> Void {
//        tlPrint(message: "btnAct  sender.tag = \(sender.tag)")
//        self.delegate.btnAct(btnTag: sender.tag)
//    }
//}
