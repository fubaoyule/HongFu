//
//  EggView.swift
//  HongFu
//
//  Created by Administrator1 on 08/02/18.
//  Copyright © 2018年 Taylor Tan. All rights reserved.
//

import UIKit

class EggView: UIView {

    let baseVC = BaseViewController()
    var width,height:CGFloat!
    let model = EggModel()
    var delegate:BtnActDelegate!
    var shadowView:UIView!
    var resultImg:UIImageView!
    
    init(frame:CGRect,viewController:EggViewController) {
        super.init(frame: frame)
        self.width = frame.width
        self.height = frame.height
        self.delegate = viewController as BtnActDelegate
        self.initEggView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initEggView() -> Void {
        let bgImg = UIImageView(frame: self.frame)
        self.addSubview(bgImg)
        bgImg.image = UIImage(named:"Home_Egg_Bg.png")
        bgImg.isUserInteractionEnabled = true
        let eggControllW = adapt_W(width: 77)//识别区宽度
        let eggControllH = adapt_W(width: 110)//识别区高度
        let eggImgW = adapt_W(width: 77)//金蛋宽度
        let eggImgH = adapt_W(width: 97)//金蛋高度
        let labelImgW = adapt_W(width: 95)//按钮宽度
        let labelImgH = adapt_H(height: 29)//按钮高度
        let eggResultImgW = adapt_W(width: 73)//金蛋上的返回内容图片宽度
        let eggResultImgH = adapt_H(height: 73)//金蛋上的返回内容图片高度
        
        let controllDisWithLabel:CGFloat =  adapt_H(height: 90)//按钮距离识别区顶部的距离差
        let controllDisWithResult:CGFloat =  adapt_H(height: -10)//按钮距离识别区顶部的距离差
        let eggResultSize = CGSize(width: eggResultImgW, height: eggResultImgH)
        let eggControllSize = CGSize(width: eggControllW, height: eggControllH)
        let eggImgSize = CGSize(width: eggImgW, height: eggImgH)
        let eggLabelImgSize = CGSize(width: labelImgW, height: labelImgH)
        let eggImgPointArray = [CGPoint(x: adapt_W(width: 20), y: adapt_H(height: 275)),
                                CGPoint(x:(width - eggImgW) / 2, y: adapt_H(height: 235)),
                                CGPoint(x: width - (adapt_W(width: 20) + eggImgW), y: adapt_H(height: 275)),
                                CGPoint(x: adapt_W(width: 20), y: adapt_H(height: 430)),
                                CGPoint(x: (width - eggImgW) / 2, y: adapt_H(height: 470)),
                                CGPoint(x: width - (adapt_W(width: 20) + eggImgW), y: adapt_H(height: 430))]

        let pointArray = [CGPoint(x:(eggControllW - eggResultImgW) / 2, y:controllDisWithResult),CGPoint(x:0, y:0), CGPoint(x:(eggControllW - labelImgW) / 2, y:controllDisWithLabel)]
        let sizeArray = [eggResultSize, eggImgSize, eggLabelImgSize]
        let imgNameArray = ["Home_egg_resultBg2.png", "Home_egg_egg.png", "Home_egg_HitLabel1.png"]
        let tagArray = [ EggTag.eggResultImgTag.rawValue,EggTag.eggTag.rawValue,EggTag.eggLabelTag.rawValue]
        for i in 0 ..< 6 {
            //生成6个手势识别区
            let eggControllView = UIView(frame:CGRect(origin: eggImgPointArray[i], size: eggControllSize))
            bgImg.addSubview(eggControllView)
            eggControllView.tag = EggTag.eggControllViewTag.rawValue + i
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapAct(sender:)))
            eggControllView.addGestureRecognizer(tapGesture)
            
            for j in 0 ..< 3 {
                //在手势识别区上分别生成金蛋、按钮和返回结果图片
                let eggImg = UIImageView(frame: CGRect(origin: pointArray[j], size: sizeArray[j]))
                eggImg.image = UIImage(named:imgNameArray[j])
                eggControllView.addSubview(eggImg)
                eggImg.tag = tagArray[j] + i
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapAct(sender:)))
                eggImg.addGestureRecognizer(tapGesture)
                switch j {
                case 0:
                    tlPrint("结果图片隐藏")
                    eggImg.isHidden = true
                case 1:
                    //金蛋摇晃
                    self.shakeAnimation(view: eggImg, duration: 0.5 + 0.01 * CGFloat(arc4random_uniform(40)), fromValue: NSNumber(value: -0.2), toValue: NSNumber(value: 0.2))
                default:
                    tlPrint("no such case!")
                }
            }
        }
        //返回按钮
        let backFrame = CGRect(x: adapt_W(width: isPhone ? 12 : 18), y: adapt_H(height: isPhone ? 25 : 15), width: adapt_W(width: isPhone ? 35 : 25), height: adapt_W(width: isPhone ? 35 : 25))
        let backBtn = baseVC.buttonCreat(frame: backFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named: "lobby_PT_back.png"), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
        self.insertSubview(backBtn, at: 1)
        backBtn.tag = EggTag.eggBackBtnTag.rawValue
    }
    
    //金蛋结构界面
    func initAlertView() -> Void {
        self.shadowView = UIView(frame: self.frame)
        self.shadowView.backgroundColor = UIColor.black
        self.shadowView.alpha = 0.8
        self.addSubview(self.shadowView)
        let resultImgW = adapt_W(width: 375)
        let resultImgH = adapt_H(height: 375)
        self.resultImg = UIImageView(frame: CGRect(x: (deviceScreen.width - resultImgW) / 2, y: adapt_H(height: 150), width: resultImgW, height: resultImgH))
        self.insertSubview(self.resultImg, aboveSubview: self.shadowView)
        self.resultImg.image = UIImage(named: "Home_Egg_success.png")
        self.resultImg.tag = EggTag.resultTapTag.rawValue
        self.resultImg.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapAct(sender:)))
        self.resultImg.addGestureRecognizer(tapGesture)
        self.initAmountLabel(superView: self.resultImg)
        
        
        //缩放动效
        UIView.animate(withDuration: TimeInterval(0.0001), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
            self.resultImg.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { (finisehd) in
            UIView.animate(withDuration: TimeInterval(0.3), delay: TimeInterval(0.2), options: .allowUserInteraction, animations: {
                self.resultImg.isHidden = false
                self.resultImg.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: { (finisehd) in
                UIView.animate(withDuration: TimeInterval(0.3), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                    self.resultImg.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: { (finisehd) in
                    
                })
            })
        })
    }
    func initAmountLabel(superView:UIView) -> Void {
        let amount = 50
        let amountLabelFrame = CGRect(x: 0, y: adapt_H(height: 145), width: superView.frame.width, height: adapt_H(height: 50))
        let amountLabel = baseVC.labelCreat(frame: amountLabelFrame, text: "\(amount)元", aligment: .center, textColor:.colorWithCustom(r: 244, g: 51, b: 62), backgroundcolor: .clear, fonsize: fontAdapt(font: 48))
        amountLabel.font = UIFont(name: "Arial-BoldMT", size: fontAdapt(font: 35))
        superView.addSubview(amountLabel)
    }

    //触摸时候识别函数
    @objc func tapAct(sender:UITapGestureRecognizer) -> Void {
        if sender.view?.tag == EggTag.resultTapTag.rawValue {
            self.shadowView.removeFromSuperview()
            for view in self.resultImg.subviews {
                view.removeFromSuperview()
            }
            self.resultImg.removeFromSuperview()
            return
        }
        TLPrint("tagAction tag = \(String(describing: sender.view?.tag))")
        let eggNum = sender.view!.tag - EggTag.eggControllViewTag.rawValue
        TLPrint("选择了第 \(eggNum + 1) 个金蛋")
        self.eggOpen(eggNum: eggNum)
        self.delegate.btnAct(btnTag: sender.view!.tag)
    }
    //点击金蛋以后的事件处理函数
    func eggOpen(eggNum:Int) -> Void {
        
        for i in 0 ..< 6 {
            let controllView = self.viewWithTag(i + EggTag.eggControllViewTag.rawValue)!
            controllView.isUserInteractionEnabled = false
            let eggImg = self.viewWithTag(i + EggTag.eggTag.rawValue) as! UIImageView
            eggImg.image = UIImage(named:"Home_egg_broken.png")//切换金蛋图片为破损图片哦
            let resultImg = self.viewWithTag(i + EggTag.eggResultImgTag.rawValue) as! UIImageView
            resultImg.isHidden = false//显示结构图片
            
            self.shakeAnimationStop(view: eggImg)
            
            if i == eggNum {
                resultImg.image = UIImage(named:"Home_egg_resultBg1.png")//选择的金蛋的结果图片为红色
                let labelImg = self.viewWithTag(eggNum + EggTag.eggLabelTag.rawValue) as! UIImageView
                labelImg.image = UIImage(named:"Home_egg_HitLabel2.png")
                
            }
        }
    }
    
    @objc func btnAct(sender:UIButton) -> Void {
        self.delegate.btnAct(btnTag: sender.tag)
    }
    
//    //抖动动画
//    func shakeAnimation(view:UIView,duration: CGFloat, fromValue:NSNumber, toValue:NSNumber) -> Void {
//        let shake = CABasicAnimation(keyPath: "transform.rotation.z")
//        shake.fromValue = fromValue
//        shake.toValue = toValue
//        shake.duration = CFTimeInterval(duration)
//        shake.autoreverses = true//是否重复
//        shake.repeatCount = HUGE
//        shake.isRemovedOnCompletion = false
//        shake.fillMode = kCAFillModeForwards
//        shake.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        view.layer.animation(forKey: "caseShake")
//        view.layer.add(shake, forKey: nil)
//    }
    
    //抖动动画
    func shakeAnimation(view:UIView,duration: CGFloat, fromValue:NSNumber, toValue:NSNumber) -> Void {
        let shake = CABasicAnimation(keyPath: "transform.rotation.z")
        shake.fromValue = fromValue
        shake.toValue = toValue
        shake.duration = CFTimeInterval(duration)
        shake.autoreverses = true//是否重复
        shake.repeatCount = HUGE
        shake.isRemovedOnCompletion = false
        shake.fillMode = kCAFillModeForwards
    
        shake.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.layer.animation(forKey: "caseShake")
        view.layer.add(shake, forKey: nil)
        view.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        view.layer.position = CGPoint(x: view.frame.width / 2, y: view.frame.height)
    }
    
    //停止抖动动画
    func shakeAnimationStop(view:UIView) -> Void {
        let shake = CABasicAnimation(keyPath: "transform.rotation.z")
        shake.fromValue = 0
        shake.toValue = 0
        shake.duration = CFTimeInterval(0)
        shake.autoreverses = false//是否重复
        shake.repeatCount = 1
        shake.isRemovedOnCompletion = false
        shake.fillMode = kCAFillModeForwards
        view.layer.animation(forKey: "caseShakeStop")
        view.layer.add(shake, forKey: nil)
    }
    
    
}
