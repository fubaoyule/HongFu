//
//  Utility.swift
//  FuTu
//
//  Created by Administrator1 on 13/9/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import Foundation
import UIKit

//定制Log
public func tlPrint<T>(message:T,file:String = #file, fun:String = #function, lint:Int = #line) {
    print("\((file as NSString).lastPathComponent) [\(lint)]:  \n-->>  \(message)  <<--\n")
    //print("\((file as NSString).lastPathComponent) - \(fun) [\(lint)]: \(message)\n")
    return
}
public func TPrint<T>(message:T,file:String = #file, fun:String = #function, lint:Int = #line) {
    print("\((file as NSString).lastPathComponent) [\(lint)]:  \(message)\n")
    //print("\((file as NSString).lastPathComponent) - \(fun) [\(lint)]: \(message)\n")
}





//获取当前时间
public func  getTime() -> String {
    let date = Date()
    let timeFormatter = DateFormatter()
    //timeFormatter.dateFormat = "yyy-MM-dd 'at' HH:mm:ss.SSS"// (格式可俺按自己需求修整)
    timeFormatter.dateFormat = "yyyyMMddHHmmssSSS"
    let strNowTime = timeFormatter.string(from: date) as String
    tlPrint(message: "time:\(strNowTime)")
    return strNowTime
}


//生成随机数
public func getRandomValue (number:Int) -> String {
    var valueNumber:UInt32 = 0
    for _ in 1 ... number {
        valueNumber = valueNumber * 10 + (arc4random() % 10)
    }
    return String(valueNumber)
}

//生成随机数
public func getRandomValueInt (number:Int) -> Int {
    var valueNumber:UInt32 = 0
    for _ in 1 ... number {
        valueNumber = valueNumber * 10 + (arc4random() % 10)
    }
    return Int(valueNumber)
}


//========================
//Mark:- 根据URL获取图片
//========================
public func getImageByURL(url:String) -> UIImage {
    let urlStr = URL(string: url)
    let data = NSData(contentsOf: urlStr!)
    let image = UIImage(data: data! as Data)
    return image!
}


//============================
//Mark:- CLASS 网页跳转时的指示器
//============================


//class TTIndicators: NSObject {
//    
//    var activityIndicator:UIActivityIndicatorView!
//    var indicatorView: UIView!
//    var webView: WKWebView!
//    init(view:WKWebView, frame:CGRect) {
//        super.init()
//        
//        webView = view
//        
//        //添加指示器背景视图
//        indicatorView = UIView(frame: frame)
//        //indicatorView.center = view.center
//        indicatorView.layer.cornerRadius = 12
//        indicatorView.backgroundColor = UIColor.black
//        indicatorView.alpha = 0.6
//        view.insertSubview(indicatorView, at: 3)
//        
//        //添加指示视图
//        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
//        indicatorView.addSubview(activityIndicator)
//        activityIndicator.center = indicatorView.center
//        tlPrint(message: "indicatorView.frame = \(indicatorView.frame)")
//        tlPrint(message: "activityIndicator.center = \(activityIndicator.center)")
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.color = .red
//        //view.addSubview(activityIndicator)
//        
//        //添加提示文本标签
//        let indicatorLabel = UILabel(frame: CGRect(x: 0, y: 80, width: 120, height: 20))
//        indicatorLabel.text = "全力加载中"
//        indicatorLabel.font = UIFont.systemFont(ofSize: 12)
//        indicatorLabel.textColor = UIColor.white
//        indicatorLabel.textAlignment = .center
//        
//        indicatorView.addSubview(indicatorLabel)
//        play(frame: frame)
//        
//        view.isUserInteractionEnabled = false
//        
//    }
//    
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func play(frame: CGRect) -> Void {
//        //进度条开始转动
//        activityIndicator.frame = frame
//        activityIndicator.startAnimating()
//        indicatorView.isHidden = false
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        
//        webView.isUserInteractionEnabled = false
//        
//    }
//    
//    func stop() -> Void {
//        //进度条停止转动
//        activityIndicator.stopAnimating()
//        indicatorView.isHidden = true
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        webView.isUserInteractionEnabled = true
//    }
//}



