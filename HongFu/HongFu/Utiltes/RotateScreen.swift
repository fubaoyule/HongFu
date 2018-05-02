//
//  RotateScreen.swift
//  FuTu
//
//  Created by Administrator1 on 17/10/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit
import WebKit




class RotateScreen: NSObject {

    
    
    class func left() {
        
        tlPrint(message: "left")
        currentScreenOritation = UIInterfaceOrientationMask.landscapeLeft
        //获取判别变量
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = UIInterfaceOrientationMask.landscapeLeft
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    class func right() {
        
        tlPrint(message: "right")
        currentScreenOritation = UIInterfaceOrientationMask.landscapeRight
        //获取判别变量
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = UIInterfaceOrientationMask.landscapeRight
        
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    class func portrait() {
        
        tlPrint(message: "portraint")
        
        currentScreenOritation = UIInterfaceOrientationMask.portrait
        //获取判别变量
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = UIInterfaceOrientationMask.portrait
        
        let value = UIInterfaceOrientation.portrait.rawValue
        
        UIDevice.current.setValue(value, forKey: "orientation")
        
    }
    
    class func all() {
        
        tlPrint(message: "portraint")
        
        currentScreenOritation = UIInterfaceOrientationMask.all
        //获取判别变量
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = UIInterfaceOrientationMask.all
        
        let value = UIInterfaceOrientation.portrait.rawValue
        
        UIDevice.current.setValue(value, forKey: "orientation")
        
    }
    
    
//    class func anyRotation() {
//        
//        tlPrint(message: "anyRotation")
//        
//        currentScreenOritation = UIInterfaceOrientationMask.all
//        //获取判别变量
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.blockRotation = UIInterfaceOrientationMask.all
//        
//        let value = UIInterfaceOrientation.landscapeLeft
//        
//        UIDevice.current.setValue(value, forKey: "orientation")
//        
//    }

    
    
    
//    //========================
//    //Mark:-旋转当前屏幕方向-逆时针(右)
//    //========================
//    class func right(view: UIView){
//        tlPrint(message: "[rotateScreenRight]")
//        UIApplication.shared.setStatusBarOrientation(.landscapeRight, animated: true)
//        //UIApplication.shared.setStatusBarHidden(true, with: .fade)
//
//        UIView.beginAnimations(nil, context: nil)
//        
//        UIApplication.shared.setStatusBarOrientation(UIInterfaceOrientation.landscapeRight, animated: true)
////        let screen = UIScreen.main.bounds
////        view.frame = CGRect(x: -20, y: -20, width: screen.width, height: screen.height)
//        view.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI*0.5))
//        UIView.commitAnimations()
//    }
//    
//    //========================
//    //Mark:-旋转当前屏幕方向-顺时针(左)
//    //========================
//    class func left(view: UIView){
//        tlPrint(message: "[rotateScreenLeft]")
//        UIApplication.shared.setStatusBarOrientation(.landscapeLeft, animated: true)
//        //UIApplication.shared.setStatusBarHidden(true, with: .slide)
//        UIView.beginAnimations(nil, context: nil)
//        
//        UIApplication.shared.setStatusBarOrientation(UIInterfaceOrientation.landscapeLeft, animated: true)
//        let screen = UIScreen.main.bounds
//        view.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
//        view.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI*0.5))
//        UIView.commitAnimations()
//    }
//    
//    //========================
//    //Mark:-恢复当前屏幕方向－竖屏
//    //========================
//    class func portrait(view: UIView){
//        tlPrint(message: "[rotateScreenPortrait]")
//        UIApplication.shared.setStatusBarHidden(false , with: .slide)
//        UIView.beginAnimations(nil, context: nil)
//        
//        UIApplication.shared.setStatusBarOrientation(.portrait, animated: true)
//        
//        view.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height - 20)
//        view.transform = CGAffineTransform(rotationAngle: CGFloat(0))
//        UIView.commitAnimations()
//    }
}
