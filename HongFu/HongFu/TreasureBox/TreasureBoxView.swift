//
//  TreasureBoxView.swift
//  FuTu
//
//  Created by Administrator1 on 17/8/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

class TreasureBoxView: UIView {

    
    var delegate: BtnActDelegate!
    var scroll: UIScrollView!
    var rootVC: UIViewController!
    var width,height: CGFloat!
    let baseVC = BaseViewController()
    var resultMaskView,lightView:UIView!
    var alertImg:UIImageView!

    
    var boxFrameArray:[CGRect]!
    var amontInfo = "获取失败"
    init(frame:CGRect,rootVC:UIViewController) {
        super.init(frame: frame)
        self.width = frame.width
        self.height = frame.height
        self.delegate = rootVC as! BtnActDelegate
        self.rootVC = rootVC
        
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        self.initScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initScrollView() -> Void {
        
        scroll = UIScrollView(frame: frame)
        self.addSubview(scroll)
        scroll.contentSize = CGSize(width: frame.width, height: height + adapt_H(height: 0.5))
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.canCancelContentTouches = true
        self.addSubview(scroll)
        initTitleView()
    }


    private func initTitleView() -> Void {
        tlPrint(message: "initEggView")
        //back button
        let backBtnFrame = CGRect(x: adapt_W(width: isPhone ? 12 : 10), y: adapt_H(height: isPhone ? 25 : 20), width: adapt_W(width: isPhone ? 35 : 25), height: adapt_W(width: isPhone ? 35 : 25))
        let backBtn = baseVC.buttonCreat(frame: backBtnFrame, title: "", alignment: .center, target: self, myaction: #selector(btnAct(sender:)), normalImage: UIImage(named: "lobby_PT_back.png"), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
        self.insertSubview(backBtn, at: 1)
        backBtn.tag = TreasureBoxTag.TreasureBackBtnTag.rawValue
        
      
        // init background image
        let backImgFrame = CGRect(x: 0, y: 0, width: width, height: height)
        let backImg = baseVC.imageViewCreat(frame: backImgFrame, image: UIImage(named:"TreasureBox_bg.png")!, highlightedImage: UIImage(named:"TreasureBox_bg.png")!)
        scroll.addSubview(backImg)
        backImg.isUserInteractionEnabled = true
        
        
        
        //golden image
        let goldenFrame = CGRect(x: 0, y: -adapt_H(height: isPhone ? 20 : 15), width: width, height: adapt_H(height: isPhone ? 250 : 200))
        let goldenImg = baseVC.imageViewCreat(frame: goldenFrame, image: UIImage(named:"TreasureBox_golden.png")!, highlightedImage: UIImage(named:"TreasureBox_golden.png")!)
        scroll.insertSubview(goldenImg, aboveSubview: backImg)
        
        UIView.animate(withDuration: TimeInterval(0.01), delay: 0, options: .allowUserInteraction, animations: {
            goldenImg.isHidden = false
            goldenImg.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { (finisehd) in
             self.scaleAnimation(view: goldenImg, delay: 0, scale: 1.3, duration: 0.65)
        })
        //title name
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            
            let nameFrame = CGRect(x: adapt_W(width: isPhone ? 0 : 60), y: 0, width: self.width - adapt_W(width: isPhone ? 0 : 120), height: adapt_H(height: isPhone ? 198 : 130))
            let nameImg = self.baseVC.imageViewCreat(frame: nameFrame, image: UIImage(named:"TreasureBox_title.png")!, highlightedImage: UIImage(named:"TreasureBox_title.png")!)
            self.scroll.insertSubview(nameImg, aboveSubview: goldenImg)
            
            UIView.animate(withDuration: TimeInterval(0.01), delay: 0, options: .allowUserInteraction, animations: {
                nameImg.isHidden = false
                nameImg.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: { (finisehd) in
                self.scaleAnimation(view: nameImg, delay: 0.4, scale: 1.3, duration: 0.5)
            })
        }

        
        
        let boxWidth = adapt_W(width: isPhone ? 150 : 100)
        let boxHeight = adapt_H(height: isPhone ? 170 : 110)
        boxFrameArray = [CGRect(x: adapt_W(width: isPhone ? 112.5 : 150), y: adapt_H(height: isPhone ? 250 : 220), width: boxWidth, height: boxHeight),
                             CGRect(x: adapt_W(width: isPhone ? 20 : 70), y: adapt_H(height: isPhone ? 400 : 300), width: boxWidth, height: boxHeight),
                             CGRect(x: adapt_W(width: isPhone ? 205 : 220), y: adapt_H(height: isPhone ? 400 : 300), width: boxWidth, height: boxHeight)]
        
        //box
        for i in 0 ..< 3 {
            //boxs
            let boxBtn = baseVC.buttonCreat(frame: self.boxFrameArray[i], title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"TreasureBox_blueCase.png"), hightImage: UIImage(named:"TreasureBox_blueCase.png"), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
            
            boxBtn.tag = TreasureBoxTag.TreasureBoxViewTag.rawValue + i
            scroll.insertSubview(boxBtn, aboveSubview: backImg)
            self.floatAnimation(view: boxBtn)
            boxBtn.isUserInteractionEnabled = true
            if i == 0 {
                boxBtn.center.x = self.scroll.center.x
            }
//            let boxImg = UIImageView(image: UIImage(named:"TreasureBox_blueCase.png"))
//            boxImg.tag = TreasureBoxTag.TreasureBoxViewTag.rawValue + i
//            boxImg.frame = self.boxFrameArray[i]
//            scroll.insertSubview(boxImg, aboveSubview: backImg)
//            self.floatAnimation(view: boxImg)
//            boxImg.isUserInteractionEnabled = true
//            let boxTap = UITapGestureRecognizer(target: self, action: #selector(self.btnAct(sender:)))
//            boxImg.addGestureRecognizer(boxTap)
//            if i == 0 {
//                boxImg.center.x = self.scroll.center.x
//            }
        }
    }
    
    
    
    //触摸处理事件
    func boxTapAct(sender:UITapGestureRecognizer) -> Void {
        tlPrint(message: "boxTapAct tag:\(sender.view!.tag)")
        
        if sender.view?.tag == TreasureBoxTag.ResultMaskViewTapTag.rawValue || sender.view?.tag == TreasureBoxTag.ResultLightViewTapTag.rawValue {
            //蒙版或者光圈视图的点击事件
            
            //删除蒙版视图
            if self.resultMaskView != nil {
                self.resultMaskView.removeFromSuperview()
                self.resultMaskView = nil
            }
            //删除光效视图
            if self.lightView != nil {
                for view in self.lightView.subviews {
                    view.removeFromSuperview()
                }
                lightView.removeFromSuperview()
                self.lightView = nil
            }
            //宝箱归位
            self.moveAnimation(view: selectedBox, isUnClicked: false)
            //所有宝箱可点击
            self.changeBoxEnableStatus(Enable: true)
            
            //开启选择的宝箱的可触摸属性
            selectedBox.isUserInteractionEnabled = true
            //换回未打开宝箱
            self.selectedBox.setImage(UIImage(named: "TreasureBox_blueCase.png"), for: .normal)
            return
        }
    }
    
    
    //开宝箱事件处理函数
    var selectedBox:UIButton!
    var selectedBoxFrame:CGRect!
    func boxOpenAct(tag:Int) -> Void {
        tlPrint(message: "boxOpenAct")
        
        let box = self.scroll.viewWithTag(tag) as! UIButton
        self.selectedBox = box
        selectedBoxFrame = box.frame
        
        selectedBox.isUserInteractionEnabled = false
        self.scroll.bringSubview(toFront: box)
        //移动宝箱
        moveAnimation(view: box,isUnClicked: true)
        //所有宝箱禁止点击
        self.changeBoxEnableStatus(Enable: false)

        //添加遮罩
        if self.resultMaskView == nil {
            self.resultMaskView = initMaskView()
            self.scroll.insertSubview(self.resultMaskView, belowSubview: self.selectedBox)
            resultMaskView.tag = TreasureBoxTag.ResultMaskViewTapTag.rawValue
            let maskTap = UITapGestureRecognizer(target: self, action: #selector(self.boxTapAct(sender:)))
            resultMaskView.addGestureRecognizer(maskTap)
            resultMaskView.isUserInteractionEnabled = false
            
        } else {
            self.resultMaskView.isHidden = false
        }
        let boxShakeTimes = 25
        let shakeIntervalTime:CGFloat = 0.05

        //晃动宝箱
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5), execute: {
            self.frameAnimation(view: box, shakeTimes: boxShakeTimes, duration: shakeIntervalTime)
            SystemTool.systemVibration(loopTimes: 1, intervalTime: UInt32(0.1))
        })
        //打开宝箱、开启光圈动画
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(CGFloat(boxShakeTimes) * shakeIntervalTime + 0.5), execute: {
            //更换宝箱图片
            self.selectedBox.setImage(UIImage(named: "TreasureBox_alert_blueCase_open.png"), for: .normal)
            //初始化光圈视图
            self.initLightView()
        })
        //        //宝箱爆炸效果
        //        var clickedView:UIImageView!
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(1), execute: {
        //            clickedView = self.resultView.initEggClickedView()
        //            self.scroll.addSubview(clickedView)
        //            box.isHidden = true
        //
        //            //
        //            //let soundURL = Bundle.main.url(forResource: "eggBombMusic", withExtension: "mp3")
        //            if let soundURL = Bundle.main.url(forResource: "eggBombMusic", withExtension: "mp3") {
        //                do {
        //                    self.avAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
        //                    self.avAudioPlayer.prepareToPlay()
        //                    self.avAudioPlayer.play()
        //                } catch {
        //                    tlPrint(message: "播放金蛋爆炸音乐错误")
        //                }
        //            }
        //
        //            //self.audioPlayer.play(soundURL!)
        //
        //        })
        //1、播放完爆炸GIF以后将GIF删掉
        //2、显示获得结果界面
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(1.8), execute: {
        //            clickedView.removeFromSuperview()
        //            clickedView = nil
        //            //let soundURL = Bundle.main.url(forResource: "eggResultMusic", withExtension: "mp3")
        //            if let soundURL = Bundle.main.url(forResource: "eggResultMusic", withExtension: "mp3") {
        //                do {
        //                    self.avAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
        //                    self.avAudioPlayer.prepareToPlay()
        //                    self.avAudioPlayer.play()
        //                } catch {
        //                    tlPrint(message: "播放金蛋结果音乐错误")
        //                }
        //            }
        //            //self.audioPlayer.play(soundURL!)
        //
        //            self.accountView = self.resultView.initResultView()
        //            self.scroll.addSubview(self.accountView)
        //        })
        //        //1、显示获得结果界面结束，出现确认按钮
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(4), execute: {
        //            
        //            let confirmBtn = self.resultView.initConfirmBtn()
        //            self.scroll.addSubview(confirmBtn)
        //        })
    }
    
    private func initLightView() -> Void {
        tlPrint(message: "startLight")
        //lightView
        if self.lightView != nil {
            //删除光效视图
            for view in self.lightView.subviews {
                view.removeFromSuperview()
            }
            self.lightView = nil
        }
        let lightViewFrame = CGRect(x: 0, y: adapt_H(height: isPhone ? 80 : 50), width: width, height: width)
        self.lightView = baseVC.viewCreat(frame: lightViewFrame, backgroundColor: .clear)
        self.lightView.tag = TreasureBoxTag.ResultLightViewTapTag.rawValue
        self.scroll.insertSubview(lightView, aboveSubview: selectedBox)
        self.lightView.isUserInteractionEnabled = false
        let lightTap = UITapGestureRecognizer(target: self, action: #selector(self.boxTapAct(sender:)))
        self.lightView.addGestureRecognizer(lightTap)
        
        
        //初始化light0（爆炸光效💥）
        let lightFrame = CGRect(x: 0, y: 0, width: lightViewFrame.width, height: lightViewFrame.height)
        let light0 = baseVC.imageViewCreat(frame: lightFrame, image: UIImage(named:"TreasureBox_alert_light0.png")!, highlightedImage: UIImage(named:"TreasureBox_alert_light0.png")!)
        lightView.addSubview(light0)
        self.scaleAnimation(view: self.selectedBox, delay: 0, scale: 1.2, duration: 0.5)
        self.scaleAnimation(view: light0, delay: 0, scale: 1.5, duration: 0.8)
        self.rotateAnimation(view: light0, value: -2)
        
        var light1:UIImageView!
        var light2:UIImageView!
        //初始化light1（大光圈🌞）
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.4), execute: {
            //初始化light1
            light1 = self.baseVC.imageViewCreat(frame: lightFrame, image: UIImage(named:"TreasureBox_alert_light1.png")!, highlightedImage: UIImage(named:"TreasureBox_alert_light1.png")!)
            self.lightView.insertSubview(light1, belowSubview: light0)
            self.rotateAnimation(view: light1, value: -6)
        })
        
        //初始化light2（小光圈🌛）
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.6), execute: {
            //初始化light2
            light2 = self.baseVC.imageViewCreat(frame: lightFrame, image: UIImage(named:"TreasureBox_alert_light2.png")!, highlightedImage: UIImage(named:"TreasureBox_alert_light2.png")!)
            self.lightView.insertSubview(light2, belowSubview: light1)
            self.rotateAnimation(view: light2, value: 3)
        })
        
        let diamondFrame = CGRect(x: adapt_W(width: isPhone ? -50 : -30), y: adapt_H(height: isPhone ? -50 : -30), width: lightViewFrame.width + adapt_W(width: isPhone ? 100 : 60), height: lightViewFrame.height + adapt_H(height: isPhone ? 100 : 60))
        //初始化宝石视图（结果视图💎）
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(1), execute: {
            
            let diamond = self.baseVC.imageViewCreat(frame: diamondFrame, image: UIImage(named:"TreasureBox_alert_diamond.png")!, highlightedImage: UIImage(named:"TreasureBox_alert_diamond.png")!)
            self.lightView.insertSubview(diamond, aboveSubview: light0)
            //金额标签
            let resultLabelFrame = CGRect(x: 0, y: 0, width: self.width / 2, height: adapt_H(height: 200))
            let resultLabel = self.baseVC.labelCreat(frame: resultLabelFrame, text: "\(self.amontInfo)元", aligment: .center, textColor: .white, backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 17 : 12))
            resultLabel.numberOfLines = 0//自动换行
            self.lightView.addSubview(resultLabel)
            resultLabel.center = diamond.center
            resultLabel.layer.shadowColor = UIColor.black.cgColor
            resultLabel.layer.shadowOpacity = 0.5
            resultLabel.layer.shadowOffset = CGSize(width: 0, height: adapt_W(width: isPhone ? 4 : 3))
            resultLabel.font = UIFont(name: "HelveticaNeue-Bold", size: fontAdapt(font: isPhone ? 20 : 14))
            
            
            //宝石图和结果金额缩放动画
            UIView.animate(withDuration: 0.01, animations: { 
                diamond.frame = CGRect(x: 0, y: 0, width: 0.1, height: 0.1)
                diamond.center = light0.center
                resultLabel.frame = CGRect(x: 0, y: 0, width: 0.1, height: 0.1)
                resultLabel.center = diamond.center
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.6, animations: {
                    diamond.frame = diamondFrame
                    resultLabel.frame = resultLabelFrame
                    resultLabel.center = diamond.center
                })
            })
        })
        
        //开启蒙版以及光效视图可点击效果
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(2), execute: {
            if self.resultMaskView != nil {
                self.resultMaskView.isUserInteractionEnabled = true
            }
            if self.lightView != nil {
                self.lightView.isUserInteractionEnabled = true
            }
        })
    }
    
    
    private func changeBoxEnableStatus(Enable:Bool) {
        
        for i in 0 ..< 3 {
            let boxBtn = self.viewWithTag(TreasureBoxTag.TreasureBoxViewTag.rawValue + i) as! UIButton
            boxBtn.isUserInteractionEnabled = Enable
        }
    }
    
    
    private func initMaskView() -> UIView {
        let mask = UIView(frame: self.frame)
        mask.backgroundColor = UIColor.black
        mask.alpha = 0.8
        return mask
    }
    
    func initResultAlertView(alertInfo:String) -> Void {
        tlPrint(message: "initResultAlertView")
        
        
        //添加蒙版
        self.resultMaskView = self.initMaskView()
        self.scroll.addSubview(self.resultMaskView)
        //添加弹窗底图
        let alertW = adapt_W(width: isPhone ? 323 : 232)
        let alertH = adapt_H(height: isPhone ? 197 : 120)
        let alertImgFrame = CGRect(x: (width - alertW) / 2, y: height, width: alertW, height: alertH)
        self.alertImg = baseVC.imageViewCreat(frame: alertImgFrame, image: UIImage(named:"TreasureBox_alert_bg.png")!, highlightedImage: UIImage(named:"TreasureBox_alert_bg.png")!)
        self.scroll.insertSubview(alertImg, aboveSubview: self.resultMaskView)
        
        //内容显示label
        let infoFrame = CGRect(x: adapt_W(width: 75), y: adapt_H(height: isPhone ? 50 : 30), width: alertImgFrame.width - adapt_W(width: 150), height: adapt_H(height: 80))
        let infoLabel = baseVC.labelCreat(frame: infoFrame, text: alertInfo, aligment: .center, textColor: .colorWithCustom(r: 255, g: 228, b: 0), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 17 : 12))
        alertImg.addSubview(infoLabel)
        infoLabel.numberOfLines = 0
        infoLabel.font = UIFont(name: "HelveticaNeue-Bold", size: fontAdapt(font: isPhone ? 17 : 12))
        
        //确定按钮
        let confirmW = adapt_W(width: isPhone ? 147 : 120)
        let confirmH = adapt_H(height: isPhone ? 38 : 25)
        let confirmFrame = CGRect(x: (width - confirmW) / 2, y: height - adapt_H(height: isPhone ? 200 : 130), width: confirmW, height: confirmH)
        let confirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"TreasureBox_alert_confirm.png"), hightImage: UIImage(named:"TreasureBox_alert_confirm.png"), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        confirmBtn.tag = TreasureBoxTag.alertConfirmBtnTag.rawValue
        self.scroll.addSubview(confirmBtn)
        confirmBtn.isHidden = true
        
        //弹窗上弹动画
        UIView.animate(withDuration: 0.5, animations: {
            self.alertImg.frame = CGRect(x: (self.width - alertW) / 2, y: adapt_H(height: isPhone ? 160 : 110), width: alertW, height: alertH)
        }) { (finished) in
            //显示确认按钮
            confirmBtn.isHidden = false
            self.isUserInteractionEnabled = true
        }
    }
    
    func dismissResultAlertView() -> Void {
        tlPrint(message: "dismissResultAlertView")
        
        if self.resultMaskView != nil {
            self.resultMaskView.removeFromSuperview()
            self.resultMaskView = nil
        }
        if self.alertImg != nil {
            for view in alertImg.subviews {
                view.removeFromSuperview()
            }
            self.alertImg.removeFromSuperview()
            self.alertImg = nil
        }
        if let confirmBtn = self.viewWithTag(TreasureBoxTag.alertConfirmBtnTag.rawValue) {
            (confirmBtn as! UIButton).removeFromSuperview()
        }
    }
    
    
    
    //抖动动画
    private func shakeAnimation(view:UIView) -> Void {
        
        let shake = CABasicAnimation(keyPath: "transform.rotation.z")
        shake.fromValue = NSNumber(value: -0.5)
        shake.toValue = NSNumber(value: 0.5)
        shake.duration = 0.1
        shake.autoreverses = true//是否重复
        shake.repeatCount = 5
        view.layer.animation(forKey: "boxShake")
        view.layer.add(shake, forKey: nil)
        
    }
    //frame变动动画
    private func frameAnimation(view:UIView,shakeTimes:Int,duration:CGFloat) -> Void {
        tlPrint(message: "frameAnimation")
        
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: .allowAnimatedContent, animations: {
            for i in 0 ..< shakeTimes {
                UIView.animate(withDuration: TimeInterval(duration), delay: TimeInterval(CGFloat(i) * duration), options: .allowAnimatedContent, animations: {
                    view.frame = CGRect(x: view.frame.origin.x + adapt_W(width: self.getRandom()) , y: view.frame.origin.y + adapt_H(height: self.getRandom()) , width: view.frame.width + adapt_W(width: self.getRandom()), height: view.frame.height + adapt_H(height: self.getRandom()))
                    
                }, completion: { (finished) in
                })
            }
        }, completion: { (finished) in
            let index = self.selectedBox.tag - TreasureBoxTag.TreasureBoxViewTag.rawValue
            view.frame = self.boxFrameArray[index]
        })
    }
    
    private func getRandom() -> CGFloat {
    
        let signed = CGFloat((arc4random() % 10) % 2 == 0 ? 1 : -1)
        let number = CGFloat(arc4random() % 5)
        return CGFloat(signed * number)
    }
    
    //宝箱上下浮动动画
    private func floatAnimation(view:UIView) -> Void {
        
        let float = CABasicAnimation(keyPath: "transform.translation.y")
        float.duration = CFTimeInterval(CGFloat(1.5) + CGFloat(view.tag - TreasureBoxTag.TreasureBoxViewTag.rawValue) * CGFloat(0.2))
        float.autoreverses = true//是否重复
        float.repeatCount = HUGE
        float.isRemovedOnCompletion = false
        float.fillMode = kCAFillModeForwards
        float.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        float.fromValue = NSNumber(value: Float(adapt_H(height: view.tag % 2  != 0 ? 10 : -5)))
        float.toValue = NSNumber(value: Float(adapt_H(height: view.tag % 2  != 0 ? -5 : 10)))
        view.layer.animation(forKey: "eggFloat")
        view.layer.add(float, forKey: nil)
        
    }
    //选中宝箱移动动画
    private func moveAnimation(view: UIView,isUnClicked:Bool) -> Void {
        
        tlPrint(message: "moveAnimation \(isUnClicked)")
        let boxIndex = view.tag - TreasureBoxTag.TreasureBoxViewTag.rawValue
        let float = CABasicAnimation(keyPath: "transform.translation")
        float.autoreverses = false//是否重复
        float.fillMode = kCAFillModeForwards
        float.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        float.fromValue = NSNumber(value: 0)
        if isUnClicked {
            float.duration = 0.5
            float.isRemovedOnCompletion = false
            switch boxIndex {
            case 0:
                float.toValue = NSValue(cgPoint: CGPoint(x: 0, y: -adapt_H(height: isPhone ? 50 : 30)))
            case 1:
                float.toValue = NSValue(cgPoint: CGPoint(x: adapt_W(width: isPhone ? 92 : 60), y: -adapt_H(height: isPhone ? 200 : 150)))
            case 2:
                float.toValue = NSValue(cgPoint: CGPoint(x: -adapt_W(width: isPhone ? 92 : 60), y: -adapt_H(height: isPhone ? 200 : 150)))
            default:
                tlPrint(message: "no such case!")
            }
            
        } else {
            float.duration = 0.5
            float.isRemovedOnCompletion = true
            self.floatAnimation(view: selectedBox)
        }
        view.layer.animation(forKey: "boxAnimate\(boxIndex)")
        view.layer.add(float, forKey: "box\(boxIndex)")
        

    }

    
    //缩放动画
    private func scaleAnimation(view:UIView,delay:CGFloat,scale:CGFloat,duration:CGFloat) -> Void {
        tlPrint(message: "scaleAnimation")
        
        UIView.animate(withDuration: TimeInterval(duration), delay: TimeInterval(delay), options: .allowUserInteraction, animations: {
            view.isHidden = false
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: { (finisehd) in
            UIView.animate(withDuration: TimeInterval(duration), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: { (finisehd) in

            })
        })
    }

    
    //转动动画
    func rotateAnimation(view:UIView,value:Double) -> Void {
        
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = NSNumber(value: 0)
        rotate.toValue = NSNumber(value: Double.pi * value * 2)
        rotate.duration = 40
        rotate.autoreverses = true//是否重复
        rotate.repeatCount = HUGE
        view.layer.animation(forKey: "boxRotate")
        view.layer.add(rotate, forKey: nil)
    }

    
    func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct sender.tag = \(sender.tag)")
        
        self.delegate.btnAct(btnTag: sender.tag)
    }


}
