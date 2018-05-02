//
//  ActivityDetailViewController.swift
//  FuTu
//
//  Created by Administrator1 on 30/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit
import WebKit

class ActivityDetailViewController: UIViewController,WKUIDelegate, WKNavigationDelegate,BtnActDelegate {

    var width,height: CGFloat!
    let model = ActivityDetailModel()
    var param:AnyObject!
    var indicator: TTIndicators!
    var wkWebView:WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.width = self.view.frame.width
        self.height = self.view.frame.height
        let detailView = ActivityDetailView(frame: self.view.frame, param:self.param, rootVC: self)
        self.wkWebView = detailView.wkWebView
        self.view.addSubview(detailView)
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    init(selecedInfo:AnyObject) {
        super.init(nibName: nil, bundle: nil)
        self.param = selecedInfo
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    func btnAct(btnTag: Int) {
        tlPrint(message: "btnAct btnTag:\(btnTag)")
        switch btnTag {
        case ActivityDetailTag.backBtnTag.rawValue:
            _ = self.navigationController?.popViewController(animated: true)
        case ActivityDetailTag.joinBtnTag.rawValue:
            let transfer = TransferViewController(isFromTab: false)
            self.navigationController?.pushViewController(transfer, animated: true)
        default:
            tlPrint(message: "no such case")
        }
    }
    
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let indicatorFrame = portraitIndicatorFrame
        if indicator == nil {
            
            indicator = TTIndicators(view: wkWebView, frame: indicatorFrame)
        }
        indicator.play(frame: indicatorFrame)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if indicator != nil {
            indicator.stop()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
