//
//  GiftBoxView.swift
//  FuBao
//
//  Created by Administrator1 on 4/8/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit



class GiftBoxView: UIView {
    
    
    var scroll:UIScrollView!
    var height,width:CGFloat!
    var delegate:BtnActDelegate!
    var shadowView,alertView: UIView!
    var alertBackImg:UIImageView!
    
    let baseVC = BaseViewController()
    init(frame:CGRect,rootVC:UIViewController) {
        super.init(frame: frame)
        self.width = frame.width
        self.height = frame.height
        
        self.delegate = rootVC as! BtnActDelegate
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        initScrollView()
    }
    
    func initScrollView() -> Void {
        
        scroll = UIScrollView(frame: frame)
        self.addSubview(scroll)
        scroll.contentSize = CGSize(width: frame.width, height: height + adapt_H(height: 0.5))
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        self.addSubview(scroll)
        
        //back button
        let backFrame = CGRect(x: adapt_W(width: isPhone ? 12 : 10), y: adapt_H(height: isPhone ? 25 : 20), width: adapt_W(width: isPhone ? 35 : 25), height: adapt_W(width: isPhone ? 35 : 25))
        let backBtn = baseVC.buttonCreat(frame: backFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named: "lobby_PT_back.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.scroll.insertSubview(backBtn, at: 1)
        backBtn.tag = giftBoxTag.backBtnTag.rawValue
        
        
        //background
        let backImg = UIImageView(frame: scroll.frame)
        backImg.image = UIImage(named: "GiftBox_bg.png")
        self.scroll.insertSubview(backImg, at: 0)
   
        
        //case base imgae
        let caseBaseImg = UIImageView(frame: CGRect(x: adapt_W(width: 40), y: adapt_H(height: isPhone ? 420 : 330), width: adapt_W(width: isPhone ? 180 : 120), height: adapt_H(height: isPhone ? 90 : 60)))
        caseBaseImg.center.x = self.center.x
        caseBaseImg.image = UIImage(named: "GiftBox_base.png")
        self.scroll.insertSubview(caseBaseImg, aboveSubview: backImg)
        self.alphaAnimatioin(view: caseBaseImg)
        
        //light image
        let lightImg = UIImageView(frame: CGRect(x: adapt_W(width: 80), y: adapt_H(height: isPhone ? 210 : 170), width: adapt_W(width: isPhone ? 340 : 220), height: adapt_H(height: isPhone ? 340 : 220)))
        lightImg.center.x = self.center.x
        lightImg.image = UIImage(named: "GiftBox_light.png")
        self.scroll.insertSubview(lightImg, aboveSubview: caseBaseImg)
        lightImg.isUserInteractionEnabled = true
        self.floatAnimation(view: lightImg)
        self.rotateAnimation(view: lightImg)
        
        
        //box imgae
        let boxImg = UIImageView(frame:lightImg.frame)
        boxImg.image = UIImage(named: "GiftBox_box.png")
        boxImg.tag = giftBoxTag.boxTapTag.rawValue
        self.scroll.insertSubview(boxImg, aboveSubview: lightImg)
        boxImg.isUserInteractionEnabled = true
        let boxTap = UITapGestureRecognizer(target: self, action: #selector(self.tapAct(sender:)))
        boxImg.addGestureRecognizer(boxTap)
        self.floatAnimation(view: boxImg)
        
        //get button
        let getBtnFrame = CGRect(x: adapt_W(width: 88), y: adapt_H(height: isPhone ? 550 : 420), width: adapt_W(width: isPhone ? 218 : 150), height: adapt_H(height: isPhone ? 66 : 44))
        let getBtn = baseVC.buttonCreat(frame: getBtnFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"GiftBox_button_get_normal.png"), hightImage: UIImage(named:"GiftBox_button_get_click.png"), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        getBtn.center.x = self.center.x
        getBtn.tag = giftBoxTag.getBtnTag.rawValue
        self.scroll.insertSubview(getBtn, aboveSubview: backImg)
        
    }
    
    //初始化礼盒弹窗视图
    //alertType:1 未开始  2 进行中  3 已结束
    func initAlertView(alertType:Int,amount:CGFloat?,alertMsg:String) -> Void {
        tlPrint(message: "initAlertView")
        if self.alertView != nil {
            for view in alertView.subviews {
                view.removeFromSuperview()
            }
            alertView.removeFromSuperview()
            alertView = nil
        }
        if self.shadowView != nil {
            shadowView.removeFromSuperview()
            shadowView = nil
        }
        self.alertView = UIView(frame: self.frame)
        self.insertSubview(self.alertView, aboveSubview: self.scroll)
        
        //mask view
        self.shadowView = UIView(frame: self.frame)
        self.shadowView.backgroundColor = UIColor.colorWithCustom(r: 7, g: 18, b: 35)
        self.shadowView.alpha = 0.7
        self.alertView.insertSubview(shadowView, at: 0)
        self.shadowView.tag = giftBoxTag.shadowViewTapTag.rawValue
        let shadowTap = UITapGestureRecognizer(target: self, action: #selector(self.tapAct(sender:)))
        self.shadowView.addGestureRecognizer(shadowTap)
        
        
        //alert back imgae
        alertBackImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 80), y: adapt_H(height: isPhone ? 100 : 140), width: width - adapt_W(width: isPhone ? 20 : 160), height: adapt_H(height: isPhone ? 550 : 360)))
        alertBackImg.center.x = self.center.x
        alertBackImg.image = UIImage(named: "GiftBox_alert_bg.png")
        self.alertView.insertSubview(alertBackImg, aboveSubview: shadowView)
        alertBackImg.isUserInteractionEnabled = true


        //label info array
        let hasGet = (amount == 0)
        let type2InfoText = (hasGet ? "\(alertMsg)" : "恭喜您！获得礼盒奖金：")
        
        let alertX = adapt_W(width: isPhone ? 50 : 20)
        let labelInfoArray = [["\(alertMsg)",
                                CGRect(x: alertX, y: adapt_H(height: isPhone ? 310 : 180), width: alertBackImg.frame.width - alertX * 2, height: adapt_H(height: 160)),
                                UIColor.colorWithCustom(r: 15, g: 78, b: 156),
                                fontAdapt(font: isPhone ? 16 : 11),
                                "",
                                CGRect(x: 0, y: 0, width: 0, height: 0),
                                UIColor.clear,
                                fontAdapt(font: 16),
                                "GiftBox_button_confirm.png"],
                              
                              [type2InfoText,
                               CGRect(x: alertX, y: adapt_H(height: isPhone ? (hasGet ? 380 : 350) : (hasGet ? 250 : 220)), width: alertBackImg.frame.width - alertX * 2, height: adapt_H(height: 50)),
                               (hasGet ? UIColor.colorWithCustom(r: 15, g: 78, b: 156) : UIColor.colorWithCustom(r: 245, g: 63, b: 0)),
                               fontAdapt(font: isPhone ? 16 : 11),
                               (hasGet ? "" : "\(amount!)元"),
                               CGRect(x: 0, y: adapt_H(height: isPhone ? 380 : 240), width: alertBackImg.frame.width, height: adapt_H(height: isPhone ? 50 : 30)),
                               UIColor.colorWithCustom(r: 245, g: 63, b: 0),
                               fontAdapt(font: isPhone ? 35 : 25),
                               "GiftBox_button_confirm.png"],
                              
                              ["礼盒已经被抢完！",
                               CGRect(x: alertX, y: adapt_H(height: isPhone ? 370 : 240), width: alertBackImg.frame.width - alertX * 2, height: adapt_H(height: 50)),
                               UIColor.colorWithCustom(r: 245, g: 63, b: 0),
                               fontAdapt(font: isPhone ? 25 : 14),
                               "",
                               CGRect(x: 0, y: adapt_H(height: isPhone ? 200 : 100), width: alertBackImg.frame.width, height: adapt_H(height: 20)),
                               UIColor.colorWithCustom(r: 245, g: 63, b: 0),
                               fontAdapt(font: isPhone ? 16 : 8),
                               "GiftBox_button_confirm.png"],]
        
        
        let alertGetBtnFrame = CGRect(x: (alertBackImg.frame.width - adapt_W(width: isPhone ? 175 : 120)) / 2, y: adapt_H(height: isPhone ? 450 : 300), width: adapt_W(width: isPhone ? 175 : 120), height: adapt_H(height: isPhone ? 54 : 35))
        let alertGetBtn = baseVC.buttonCreat(frame: alertGetBtnFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named: (labelInfoArray[alertType - 1][8] as! String)), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        alertGetBtn.tag = giftBoxTag.alergGetBtnTag.rawValue
        alertBackImg.addSubview(alertGetBtn)
        
        
        
        let alertLabel1 = baseVC.labelCreat(frame: labelInfoArray[alertType - 1][1] as! CGRect, text: labelInfoArray[alertType - 1][0] as! String, aligment: .center, textColor: labelInfoArray[alertType - 1][2] as! UIColor, backgroundcolor: .clear, fonsize: labelInfoArray[alertType - 1][3] as! CGFloat)
        alertLabel1.numberOfLines = 0//自动换行

        
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelInfoArray[alertType - 1][0] as! String)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = adapt_H(height: isPhone ? 6 : 4) //修改行间距
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0,  (labelInfoArray[alertType - 1][0] as! String).characters.count))
        alertLabel1.attributedText = attributedString
        alertLabel1.lineBreakMode = NSLineBreakMode.byWordWrapping//按照单词分割换行，保证换行时的单词完整。
//        alertLabel1.lineBreakMode = NSLineBreakMode.byCharWrapping//按照字符分割换行
        alertLabel1.textAlignment = NSTextAlignment.center
        self.alertBackImg.addSubview(alertLabel1)
        
        let alertLabel2 = baseVC.labelCreat(frame: labelInfoArray[alertType - 1][5] as! CGRect, text: labelInfoArray[alertType - 1][4] as! String, aligment: .center, textColor: labelInfoArray[alertType - 1][6] as! UIColor, backgroundcolor: .clear, fonsize: labelInfoArray[alertType - 1][7] as! CGFloat)
        self.alertBackImg.addSubview(alertLabel2)
        
        
        
        alertGetBtn.setImage(UIImage(named:labelInfoArray[alertType - 1][8] as! String), for: UIControlState.highlighted)
        
        self.scaleAnimation(view: alertBackImg, delay: 0, scale1: 1, scale2: 0.8, duration: 0.8, outDuration: 0.3)
        
    }
    
    //宝箱上下浮动动画
    func floatAnimation(view:UIView) -> Void {
        
        let float = CABasicAnimation(keyPath: "transform.translation.y")
        float.duration = CFTimeInterval(CGFloat(3))
        float.autoreverses = true//是否重复
        float.repeatCount = HUGE
        float.isRemovedOnCompletion = false
        float.fillMode = kCAFillModeForwards
        float.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        float.fromValue = NSNumber(value: Float(adapt_H(height: 10)))
        float.toValue = NSNumber(value: Float(adapt_H(height: -40)))
        view.layer.animation(forKey: "caseFloat")
        view.layer.add(float, forKey: nil)
        
    }
    //封印透明度变化动画
    func alphaAnimatioin(view:UIView) -> Void {
        let alpha = CABasicAnimation(keyPath: "opacity")
        alpha.duration = CFTimeInterval(CGFloat(3))
        alpha.autoreverses = true//是否重复
        alpha.repeatCount = HUGE
        alpha.isRemovedOnCompletion = false
        alpha.fillMode = kCAFillModeForwards
        alpha.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        alpha.fromValue = NSNumber(value: 1.0)
        alpha.toValue = NSNumber(value: 0.35)
        view.layer.add(alpha, forKey: nil)
    }
    //礼盒背景光环转动动画
    func rotateAnimation(view:UIView) -> Void {
        
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = NSNumber(value: 0)
        rotate.toValue = NSNumber(value: Double.pi * 40)
        rotate.duration = 400
        rotate.autoreverses = true//是否重复
        rotate.repeatCount = HUGE
        view.layer.animation(forKey: "giftbox")
        view.layer.add(rotate, forKey: nil)
    }
    
    
    func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct:sender.tag = \(sender.tag)")
        
        
        self.delegate.btnAct(btnTag: sender.tag)
    }
    func tapAct(sender:UITapGestureRecognizer) -> Void {
        tlPrint(message: "tapAct: sender = \(String(describing: sender.view?.tag))")
        if sender.view?.tag == giftBoxTag.shadowViewTapTag.rawValue {
            self.removeAlertView()
            return
        }
        self.delegate.btnAct(btnTag: sender.view!.tag)
    }
    
    
    
    func removeAlertView() -> Void {
        
        for view in self.alertView.subviews {
            view.removeFromSuperview()
        }
        self.alertView.removeFromSuperview()
        self.alertView = nil
        //        if self.shadowView != nil {
        //            self.shadowView.removeFromSuperview()
        //            self.shadowView = nil
        //        }
    }
    
    
    
    //缩放动画
    func scaleAnimation(view:UIView,delay:CGFloat,scale1:CGFloat,scale2:CGFloat,duration:CGFloat,outDuration:CGFloat) -> Void {
        tlPrint(message: "scaleAnimation")
        
        UIView.animate(withDuration: 0.0001, animations: {
            view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            view.isHidden = true
        }, completion: { (finished) in
            let durations = duration * 0.8
            UIView.animate(withDuration: TimeInterval(durations), delay: TimeInterval(delay), options: .allowUserInteraction, animations: {
                view.isHidden = false
                view.transform = CGAffineTransform(scaleX: scale1, y: scale1)
            }, completion: { (finisehd) in
                let durations = duration * 0.1
                UIView.animate(withDuration: TimeInterval(durations), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                    view.transform = CGAffineTransform(scaleX: scale2, y: scale2)
                }, completion: { (finisehd) in
                    let durations = duration * outDuration
                    UIView.animate(withDuration: TimeInterval(durations), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                        view.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }, completion: { (finisehd) in
                        tlPrint(message: "动画完成")
                    })
                })
            })
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

