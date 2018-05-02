//
//  TTIndicators.swift
//  FuTu
//
//  Created by Administrator1 on 25/10/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit
import WebKit


//============================
//Mark:- CLASS 网页跳转时的指示器
//============================

class TTIndicators: NSObject {

    var activityIndicator:UIActivityIndicatorView!
    var indicatorView: UIView!
    var webView: UIView!
    init(view:UIView, frame:CGRect) {
        super.init()
        
        webView = view
        
        //添加指示器背景视图
        indicatorView = UIView(frame: frame)
        //indicatorView.center = view.center
        indicatorView.layer.cornerRadius = 12
        indicatorView.backgroundColor = UIColor.black
        indicatorView.alpha = 0.6
        view.addSubview(indicatorView)
        
        //添加指示视图
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        //indicatorView.addSubview(activityIndicator)
        activityIndicator.center = indicatorView.center
        tlPrint(message: "indicatorView.frame = \(indicatorView.frame)")
        tlPrint(message: "activityIndicator.center = \(activityIndicator.center)")
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        view.addSubview(activityIndicator)
        
        //添加提示文本标签
//        let indicatorLabel = UILabel(frame: CGRect(x: 0, y: 80, width: 120, height: 20))
//        indicatorLabel.text = "全力加载中"
//        indicatorLabel.font = UIFont.systemFont(ofSize: 12)
//        indicatorLabel.textColor = UIColor.white
//        indicatorLabel.textAlignment = .center
//        
//        indicatorView.addSubview(indicatorLabel)
        play(frame: frame)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play(frame: CGRect) -> Void {
        //进度条开始转动
        tlPrint(message: "start loading")
        activityIndicator.frame = frame
        activityIndicator.startAnimating()
        indicatorView.isHidden = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //webView.isUserInteractionEnabled = false
        
    }
    
    func stop() -> Void {
        //进度条停止转动
        tlPrint(message: "stop loading")
        activityIndicator.stopAnimating()
        indicatorView.isHidden = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        //webView.isUserInteractionEnabled = true
    }

}

class RefreshIndicator: NSObject {
    var activityIndicator:UIActivityIndicatorView!
    init(view:UIView, frame:CGRect) {
        super.init()
        //添加指示视图
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        view.addSubview(activityIndicator)
        refreshPlay(frame: frame)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshPlay(frame: CGRect) -> Void {
        //进度条开始转动
        tlPrint(message: "start loading")
        activityIndicator.frame = frame
        activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
    }
    
    func refreshStop() -> Void {
        //进度条停止转动
        tlPrint(message: "stop loading")
        activityIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

