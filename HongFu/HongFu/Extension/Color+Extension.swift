//
//  Color+Extension.swift
//  FuTu
//
//  Created by Administrator1 on 13/9/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import Foundation


//========================
//Mark:- 渐变色
//========================
extension CAGradientLayer {
    
    class func GradientLayer(topColor:UIColor,buttomColor:UIColor) -> CAGradientLayer {
        
        let gradientColors: [CGColor] = [topColor.cgColor, buttomColor.cgColor]
        let gradientLocations: [CGFloat] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        
        
        return gradientLayer
    }
    class func gradientLayerTopLeft(topLeft:UIColor,bottomRight:UIColor) -> CAGradientLayer {
    
        let gradientColors: [CGColor] = [topLeft.cgColor, bottomRight.cgColor]
        let gradientLocations: [CGFloat] = [0.0, 1.0]
    
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint =  CGPoint(x: 1, y: 1)
        return gradientLayer
    }
    
    class func gradientLayerTopRight(topRight:UIColor,bottomleft:UIColor) -> CAGradientLayer {
    
        let gradientColors: [CGColor] = [topRight.cgColor, bottomleft.cgColor]
        let gradientLocations: [CGFloat] = [0.0, 1.0]
    
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint =  CGPoint(x: 0, y: 1)
        return gradientLayer
    }
    
}

//========================
//Mark:- 对颜色的扩展
//========================
extension UIColor {
    
    class func colorWithCustom(r: CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
    }
    
    class func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(256))
        let g = CGFloat(arc4random_uniform(256))
        let b = CGFloat(arc4random_uniform(256))
        return UIColor.colorWithCustom(r: r, g: g, b: b)
    }
    
    class func futuWhite() -> UIColor {
        let r = CGFloat(245)
        let g = CGFloat(245)
        let b = CGFloat(249)
        return UIColor.colorWithCustom(r: r, g: g, b: b)
    }
    
    class func futuBlue() -> UIColor {
        let r = CGFloat(0)
        let g = CGFloat(165)
        let b = CGFloat(231)
        return UIColor.colorWithCustom(r: r, g: g, b: b)
    }
}
