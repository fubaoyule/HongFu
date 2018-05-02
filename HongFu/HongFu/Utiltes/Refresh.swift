//
//  Refresh.swift
//  FuTu
//
//  Created by Administrator1 on 7/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class Refresh: NSObject {

    
    
//    class func refreshPull(superView:UIScrollView,success: @escaping ((_ result: Any) -> ())) ->Void {
//        tlPrint(message: "refreshViewOfBlock")
//        let header = MJRefreshNormalHeader()
//        //let header = MJRefreshGifHeader()
//        //修改文字
//        //        header.setTitle("", for: .idle)
//        //        header.setTitle("", for: .pulling)
//        //        header.setTitle("", for: .refreshing)
//        //修改字体
//        header.stateLabel.font = UIFont.systemFont(ofSize: 15)
//        header.lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: 13)
//        
//        //修改文字颜色
//        //header.stateLabel.textColor = UIColor.red
//        //header.lastUpdatedTimeLabel.textColor = UIColor.blue
//        //隐藏上次刷新时间
//        header.lastUpdatedTimeLabel.isHidden = true
//        //header.setRefreshingTarget(self, refreshingAction: refreshAct)
//        
//        //下拉过程时的图片集合(根据下拉距离自动改变)
//        var idleImages = [UIImage]()
//        for i in 1...10 {
//            idleImages.append(UIImage(named:"home_game_TGP.png")!)
//        }
//        header.setImages(idleImages, for: .idle) //idle1，idle2，idle3...idle10
//        
//        //下拉到一定距离后，提示松开刷新的图片集合(定时自动改变)
//        var pullingImages = [UIImage]()
//        for i in 1...3 {
//            pullingImages.append(UIImage(named:"home_game_BS.png")!)
//        }
//        header.setImages(pullingImages, for: .pulling)
//        
//        //刷新状态下的图片集合(定时自动改变)
//        var refreshingImages = [UIImage]()
//        for i in 1...3 {
//            refreshingImages.append(UIImage(named:"home_game_GD.png")!)
//        }
//        header.setImages(refreshingImages, for: .refreshing)
//        
//        superView.mj_header = header
//        success(true)
//    
//    }
}
