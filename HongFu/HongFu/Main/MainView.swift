//
//  MainView.swift
//  HongFu
//
//  Created by Administrator1 on 26/11/17.
//  Copyright © 2017年 Taylor Tan. All rights reserved.
//

import UIKit

class MainView: UIView {

    var scroll:UIScrollView!
    var height,width:CGFloat!
//    var delegate:BtnActDelegate!
    var redPacketView,shadowView,alertView: UIView!
    var alertBackImg:UIImageView!
    var redPacketTimer:Timer!
    var bombImg:UIImageView!
    var haveStart:Bool = false
    let baseVC = BaseViewController()
    init(frame:CGRect,haveStart:Bool,rootVC:UIViewController) {
        super.init(frame: frame)
        self.width = frame.width
        self.height = frame.height
        self.haveStart = haveStart
//        self.delegate = rootVC as! BtnActDelegate
        self.backgroundColor = UIColor.black
//        initRedPacketView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
