//
//  RedPacketView.swift
//  FuTu
//
//  Created by Administrator1 on 28/2/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

class RedPacketView: UIView {
    
    var scroll:UIScrollView!
    var height,width:CGFloat!
    var delegate:BtnActDelegate!
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
        self.delegate = rootVC as! BtnActDelegate
        self.backgroundColor = UIColor.black
        initRedPacketView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var redPacketImg:UIImageView!
    func initRedPacketView() -> Void {
        tlPrint(message: "initRedPacketView")
        
        
        self.redPacketView = UIView(frame: self.frame)
        self.addSubview(redPacketView)
        //back imgae
        let backImg = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height:adapt_H(height: 476)))
        backImg.image = UIImage(named: isPhone ? "redPacket_bg.png" : "redPacket_bg_Pad.png")
        self.redPacketView.addSubview(backImg)
        
        //back button
        //        let backFrame = CGRect(x: adapt_W(width: 12), y: adapt_H(height: 25), width: adapt_W(width: 35), height: adapt_W(width: 35))
        let backFrame = CGRect(x: adapt_W(width: isPhone ? 12 : 10), y: adapt_H(height: isPhone ? 25 : 20), width: adapt_W(width: isPhone ? 35 : 25), height: adapt_W(width: isPhone ? 35 : 25))
        
        let backBtn = baseVC.buttonCreat(frame: backFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named: "lobby_PT_back.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        backImg.isUserInteractionEnabled = true
        backImg.insertSubview(backBtn, at: 1)
        backBtn.tag = redPacketTag.backBtnTag.rawValue
        
        //机械手臂和红包的底部视图
        let handExtra = adapt_W(width: 9)//左右移动的距离
        let moveView = UIView(frame: CGRect(x: -handExtra, y: adapt_H(height: isPhone ? 235 : 160), width: width + handExtra * 2, height: adapt_H(height: isPhone ? 290 : 200)))
        self.redPacketView.insertSubview(moveView, aboveSubview: backImg)
        moveView.clipsToBounds  = false
        //hands and red packet images
        let handWidth = width / (isPhone ? 4 : 3.3)
        let redFrameArray = [CGRect(x: 0, y: adapt_H(height: isPhone ? 100 : 60), width: handWidth + handExtra, height: adapt_H(height: isPhone ? 196 : 120)),
                             //                             CGRect(x: handWidth + handExtra, y: 0, width: handWidth * (isPhone ? 2 : 1.2), height: adapt_H(height: isPhone ? 280 : 190)),
            CGRect(x: handWidth + handExtra, y: 0, width: width - (handWidth) * 2, height: adapt_H(height: isPhone ? 280 : 200)),
            CGRect(x: width - handWidth + handExtra, y: adapt_H(height: isPhone ? 100 : 60), width: handWidth + handExtra, height: adapt_H(height: isPhone ? 196 : 120))]
        let redImgArray = [isPhone ? "redPacket_hand.png" : "redPacket_hand_Pad.png","redPacket_paket.png",isPhone ? "redPacket_hand.png" : "redPacket_hand_Pad.png"]
        
        for i in 0 ..< 3 {
            var img = UIImage(named: redImgArray[i])
            if i == (isPhone ? 2 : 0) {
                //翻转右边的机械手臂
                let imgOritation = (img!.imageOrientation.rawValue + 4) % 8
                img = UIImage(cgImage: img!.cgImage!, scale: img!.scale, orientation: UIImageOrientation(rawValue: imgOritation)!)
            }
            let redImg = UIImageView(frame: redFrameArray[i])
            redImg.image = img
            moveView.addSubview(redImg)
            redImg.clipsToBounds = false
            if i == 1 {
                self.redPacketImg = redImg
            }
        }
        //get button
        //        let getFrame = CGRect(x: handWidth, y: adapt_H(height: isPhone ? 235 : 150), width: handWidth * (isPhone ? 2 : 1.2), height: adapt_H(height: isPhone ? 280 : 210))
        let getFrame = CGRect(x: handWidth, y: adapt_H(height: isPhone ? 235 : 150), width: (redFrameArray[1] as CGRect).width, height: (redFrameArray[1] as CGRect).height)
        let getBtn = baseVC.buttonCreat(frame: getFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"redPacket_getButton1.png"), hightImage: UIImage(named:"redPacket_getButton2.png"), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        getBtn.tag = redPacketTag.getBtnTag.rawValue
        self.redPacketView.insertSubview(getBtn, aboveSubview: moveView)
        
        //move animation
        self.floatAnimation(view: getBtn)
        self.floatAnimation(view: moveView)
        self.perspectiveAnimation()
        redPacketTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(self.perspectiveAnimation), userInfo: nil, repeats: true)
        
        //bomb image
        bombImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 0 : 50), y: height - adapt_H(height: isPhone ? 168 : 125), width: width - adapt_W(width: isPhone ? 0 : 100), height:adapt_H(height: isPhone ? 168 : 125)))
        bombImg.image = UIImage(named: "redPacket_bomb.png")
        self.redPacketView.insertSubview(bombImg, aboveSubview: moveView)
        
        //time image
        let timeImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 90 : 68), y: adapt_H(height: isPhone ? 25 : 18), width: adapt_W(width: isPhone ? 195 : 150), height:adapt_H(height: isPhone ? 32 : 28)))
        timeImg.image = UIImage(named: "redPacket_time.png")
        self.bombImg.addSubview(timeImg)
        timeImg.tag = redPacketTag.zeroTimeImgTag.rawValue
        
        
        //10-11修改红包，以下部分不用了
        return
//        //bomb nunber text img
//        let bombnumTextImg = UIImageView(frame: CGRect(x:0, y: 0, width:bombImg.frame.width, height:adapt_H(height: isPhone ? 172 : 125)))
//        bombnumTextImg.image = UIImage(named: (self.haveStart ? "redPaket_bomb_timeBg_left.png" : "redPaket_bomb_timeBg_totle.png"))
//        
//        
//        tlPrint(message: "self.havestart:\(self.haveStart)")
//        bombImg.addSubview(bombnumTextImg)
//        bombnumTextImg.tag = redPacketTag.redBombBackImgTag.rawValue
//        
//        let redNumFrame = CGRect(x: adapt_W(width: isPhone ? 155 : 120), y: adapt_H(height: isPhone ? 12 : 5), width: adapt_W(width: isPhone ? 115 : 80), height: adapt_H(height: 30))
//        let redNumLabel = baseVC.labelCreat(frame: redNumFrame, text: "", aligment: .center, textColor: .colorWithCustom(r: 255, g: 205, b: 0), backgroundcolor: .clear, fonsize: 0)
//        redNumLabel.font = UIFont(name: "Helvetica-BoldOblique", size: fontAdapt(font: isPhone ? 30 : 20))
//        redNumLabel.tag = redPacketTag.redNumLabelTag.rawValue
//        bombImg.addSubview(redNumLabel)
//        for i in 0 ..< 2 {
//            
//            
//            
//            //            let pointFrame = CGRect(x: adapt_W(width: (self.haveStart ? (i == 0 ? 181 : 238) : (i == 0 ? 162 : 226))), y: adapt_H(height: isPhone ? 45 : 26), width: adapt_W(width: 10), height: adapt_H(height: 60))
//            let pointFrame = CGRect(x: adapt_W(width: (self.haveStart ? (isPhone ? (i == 0 ? 181 : 238) : (i == 0 ? 135 : 178.5)) : (isPhone ? (i == 0 ? 162 : 226) : (i == 0 ? 120 : 170)))), y: adapt_H(height: isPhone ? 45 : 24), width: adapt_W(width: 10), height: adapt_H(height: 60))
//            let pointLabel = baseVC.labelCreat(frame: pointFrame, text: ":", aligment: .center, textColor: .colorWithCustom(r: 255, g: 48, b: 15), backgroundcolor: .clear, fonsize: 0)
//            pointLabel.font = UIFont(name: "DBLCDTempBlack", size: fontAdapt(font: isPhone ? 28 : 18))
//            pointLabel.tag = redPacketTag.leftTimePointTag.rawValue + i
//            bombImg.addSubview(pointLabel)
//            
//        }
//        // left time
//        let leftWidth = adapt_W(width: 20)//宽度
//        
//        let leftTimeXArray:[CGFloat] = (isPhone ? [92,114,135,178,200,243,265] : [67,84,101,132,149,182,198.5])
//        let leftTimeXArrayStart:[CGFloat] = (isPhone ? [159,159,159,194,216,251,273] : [118,118,118,144,161,188,204.5])
//        for i in 0 ..< 7 {
//            
//            
//            let leftX = adapt_W(width: (self.haveStart ? leftTimeXArrayStart[i] : leftTimeXArray[i]))
//            let leftY = adapt_H(height: isPhone ? 47 : 26)
//            let leftTimeFrame = CGRect(x: leftX, y: leftY, width: leftWidth, height: adapt_H(height: 60))
//            let leftTimeLabel = baseVC.labelCreat(frame: leftTimeFrame, text: "", aligment: .center, textColor: .colorWithCustom(r: 255, g: 48, b: 15), backgroundcolor: .clear, fonsize: 0)
//            leftTimeLabel.font = UIFont(name: "DBLCDTempBlack", size: fontAdapt(font: isPhone ? 28 : 18))
//            leftTimeLabel.tag = redPacketTag.leftTimeTag.rawValue + i
//            bombImg.addSubview(leftTimeLabel)
//            
//        }
    }
    
    
    
    
    func initAlertView(type:redPacketAlertType,startTime:String?, redPacketAmount:String?, redPacketCount:Int?, message:String?) -> Void {
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
        self.insertSubview(alertView, aboveSubview: self.redPacketView)
        
        //mask view
        shadowView = UIView(frame: self.frame)
        shadowView.backgroundColor = UIColor.colorWithCustom(r: 17, g: 2, b: 1)
        shadowView.alpha = 0.76
        self.alertView.insertSubview(shadowView, at: 0)
        shadowView.tag = redPacketTag.shadowViewTapTag.rawValue
        let shadowTap = UITapGestureRecognizer(target: self, action: #selector(self.tapAct(sender:)))
        shadowView.addGestureRecognizer(shadowTap)
        
        //结果弹窗
        var resultImg:UIImageView!
        
        switch type {
        case .success:
            tlPrint(message: "获取红包成功")
            let bombFrame = CGRect(x: adapt_W(width: 0), y: adapt_H(height: isPhone ? 80 : 40), width: width , height: adapt_W(width: 440))
            let bombImg = UIImageView(frame: bombFrame)
            self.alertView.insertSubview(bombImg, aboveSubview: shadowView)
            bombImg.image = UIImage(named: "redPacket_alert_bomb.png")
            bombImg.center.x = self.alertView.center.x
            
            let goldenImg = UIImageView(frame: bombFrame)
            self.alertView.insertSubview(goldenImg, aboveSubview: bombImg)
            goldenImg.image = UIImage(named: "redPacket_alert_golden.png")
            goldenImg.center = bombImg.center
            
            let resultFrame = CGRect(x: 0, y: adapt_H(height: 160), width: adapt_W(width: 235), height: adapt_H(height: 265))
            resultImg = UIImageView(frame: resultFrame)
            self.alertView.insertSubview(resultImg, aboveSubview: goldenImg)
            resultImg.image = UIImage(named: "redPacket_alert_success1.png")
            resultImg.center = bombImg.center
            //获得彩金标签
            let amountFrame = CGRect(x: adapt_W(width: 0), y: adapt_H(height: 60), width: resultFrame.width, height: adapt_H(height: 50))
            let amountLabel = baseVC.labelCreat(frame: amountFrame, text: "获得彩金：", aligment: .center, textColor: .colorWithCustom(r: 255, g: 204, b: 0), backgroundcolor: .clear, fonsize: fontAdapt(font: 15))
            //            amountLabel.font = UIFont(name: "Arial-BoldItalicMT", size: fontAdapt(font: 25))
            resultImg.addSubview(amountLabel)
            
            //红包金额
            let accountFrame = CGRect(x: 0, y: adapt_H(height: 110), width: resultFrame.width, height: adapt_H(height: 50))
            let accountLabel = baseVC.labelCreat(frame: accountFrame, text: "\(redPacketAmount!)元", aligment: .center, textColor: .colorWithCustom(r: 255, g: 204, b: 0), backgroundcolor: .clear, fonsize: fontAdapt(font: 35))
            accountLabel.font = UIFont(name: "Arial-BoldMT", size: fontAdapt(font: 35))
            resultImg.addSubview(accountLabel)
            accountLabel.textAlignment = .center
            //转入中心钱包标签
            let alertLabelFrame = CGRect(x: 0, y: adapt_H(height: 160), width: resultFrame.width, height: adapt_H(height: 50))
            let alertLabel = baseVC.labelCreat(frame: alertLabelFrame, text: "(已转入中心钱包)", aligment: .center, textColor: .colorWithCustom(r: 255, g: 204, b: 0), backgroundcolor: .clear, fonsize: fontAdapt(font: 15))
            resultImg.addSubview(alertLabel)
            
            
            
            bombImg.isHidden = true
            goldenImg.isHidden = true
            resultImg.isHidden = true
            self.scaleAnimation(view: bombImg, delay: 0, scale1:1.0, scale2:1.0, duration: 1, outDuration:0.1)
            self.scaleAnimation(view: goldenImg, delay: 0.2, scale1:1.0, scale2:0.8, duration: 0.9, outDuration:0.1)
            self.scaleAnimation(view: resultImg, delay: 0.35, scale1:1.2, scale2:0.7, duration: 0.85, outDuration:0.15)
        case .later:
            tlPrint(message: "发放时间还没有到")
            let resultFrame = CGRect(x: adapt_W(width: 0), y: adapt_H(height: isPhone ? 140 : 100), width: adapt_W(width: 273), height: adapt_H(height: 306))
            resultImg = UIImageView(frame: resultFrame)
            self.alertView.insertSubview(resultImg, aboveSubview: shadowView)
            resultImg.image = UIImage(named: "redPacket_alert_notStart.png")
            self.scaleAnimation(view: resultImg, delay: 0, scale1:1.2, scale2:0.7, duration: 0.85, outDuration:0.15)
            
            //红包开放时间
            let subDateArray1 = startTime?.components(separatedBy: "-")
            let month = subDateArray1![1]
            let subDateArray2 = subDateArray1![2].components(separatedBy: " ")
            let day = subDateArray2[0]
            let subDateArray3 = subDateArray2[1].components(separatedBy: ":")
            let hour = subDateArray3[0]
            let minute = subDateArray3[1]
            let startFrame = CGRect(x: 0, y: adapt_H(height: 120), width: resultFrame.width, height: adapt_H(height: 50))
            let startTimeLabel = baseVC.labelCreat(frame: startFrame, text: "\(month)月\(day)日 \(hour):\(minute)", aligment: .center, textColor: .colorWithCustom(r: 255, g: 204, b: 0), backgroundcolor: .clear, fonsize: 0)
            startTimeLabel.font = UIFont(name: "Arial-BoldMT", size: fontAdapt(font: 25))
            startTimeLabel.textAlignment = .center
            resultImg.addSubview(startTimeLabel)
            
        case .finish:
            tlPrint(message: "红包已经发完")
            let resultFrame = CGRect(x: 0, y: adapt_H(height: isPhone ? 160 : 100), width: adapt_W(width: 235), height: adapt_H(height: 265))
            resultImg = UIImageView(frame: resultFrame)
            self.alertView.insertSubview(resultImg, aboveSubview: shadowView)
            resultImg.image = UIImage(named: "redPacket_alert_gray2.png")
            self.scaleAnimation(view: resultImg, delay: 0, scale1:1.2, scale2:0.7, duration: 0.85, outDuration:0.15)
            
            //红包结束标签
            let finishFrame = CGRect(x: adapt_W(width: 20), y: adapt_H(height: 60), width: resultFrame.width - adapt_W(width: 40), height: adapt_H(height: 120))
            let finishLabel = baseVC.labelCreat(frame: finishFrame, text: message!, aligment: .center, textColor: .white, backgroundcolor: .clear, fonsize: fontAdapt(font: 17))
            finishLabel.font = UIFont(name: "Arial-BoldMT", size: fontAdapt(font: 17))
            finishLabel.numberOfLines = 0
            finishLabel.lineBreakMode = NSLineBreakMode.byWordWrapping//按照单词分割换行，保证换行时的单词完整。
            finishLabel.shadowColor = UIColor.black
            
            
            let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: message!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = adapt_H(height: 6)
            
            attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, message!.characters.count))
            finishLabel.attributedText = attributedString
            finishLabel.textAlignment = .center
            
            
            
            finishLabel.shadowOffset = CGSize(width: 0, height: adapt_H(height: 3))
            
            
            resultImg.addSubview(finishLabel)
        }
        resultImg.isUserInteractionEnabled = true
        resultImg.center.x = self.alertView.center.x
        
        //confirm button
        let confirmFrame = CGRect(x: adapt_W(width: isPhone ? 100 : 60), y: height - adapt_H(height: isPhone ? 150 : 100), width: width - adapt_W(width: isPhone ? 200 : 120), height: adapt_H(height: isPhone ? 50 : 40))
        let confirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"redPacket_confirmButton.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        confirmBtn.tag = redPacketTag.confirmBtnTag.rawValue
        confirmBtn.center.x = alertView.center.x
        alertView.insertSubview(confirmBtn, aboveSubview: shadowView)
        confirmBtn.isHidden = true
        self.scaleAnimation(view: confirmBtn, delay: 1.1, scale1:1, scale2:1, duration: 0.05, outDuration:0.15)
        
    }
    
//    //重载倒计时
//    func reloadLeftTimer(newTimeArray:Array<Int>) -> Void {
//        tlPrint(message: "reloadLeftTimer newTimeArray:\(newTimeArray)")
//        for i in 0 ..< 7 {
//            let label = self.bombImg.viewWithTag(redPacketTag.leftTimeTag.rawValue + i) as! UILabel
//            label.text = "\(newTimeArray[i])"
//        }
//    }
    
//    func reloadTimerFrame() -> Void {
//        tlPrint(message: "reloadTimerFrame")
//        let leftTimeXArray:[CGFloat] = isPhone ? [159,159,159,194,216,251,273] : [118,118,118,144,161,188,204.5]
//        let leftWidth = adapt_W(width: 20)//宽度
//        for i in 0 ..< 7 {
//            let timeLabel = self.bombImg.viewWithTag(redPacketTag.leftTimeTag.rawValue + i) as! UILabel
//            let leftX = adapt_W(width: leftTimeXArray[i])
//            let leftY = adapt_H(height: isPhone ? 47 : 26)
//            timeLabel.frame = CGRect(x: leftX, y: leftY, width: leftWidth, height: adapt_H(height: 60))
//            if i < 2 {
//                timeLabel.isHidden = true
//            }
//        }
//        
//        for i in  0 ..< 2 {
//            let pointLabel = self.bombImg.viewWithTag(redPacketTag.leftTimePointTag.rawValue + i) as! UILabel
//            pointLabel.frame = CGRect(x: adapt_W(width: isPhone ? (i == 0 ? 181 : 238) : (i == 0 ? 135 : 178.5)), y: adapt_H(height: isPhone ? 45 : 24), width: adapt_W(width: 10), height: adapt_H(height: 60))
//        }
//    }
//    
//    func reloadRedNumLabel(number:Int) -> Void {
//        tlPrint(message: "reloadRedNumLabel")
//        let totleNumLabel = self.bombImg.viewWithTag(redPacketTag.redNumLabelTag.rawValue) as! UILabel
//        totleNumLabel.text = "\(number)"
//    }
    //
    //    //时间分隔字符闪烁函数
    //    func refreshTimePoint() -> Void {
    //        tlPrint(message: "refreshTimePoint")
    //        for i in 0 ..< 2 {
    //            let pointLabel = self.bombImg.viewWithTag(redPacketTag.leftTimePointTag.rawValue + i) as! UILabel
    //
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
    //                pointLabel.textColor = UIColor.clear
    //            }
    //
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    //                pointLabel.textColor = UIColor.colorWithCustom(r: 255, g: 48, b: 15)
    //            }
    //        }
    //    }
    
    //清除弹窗
    func removeAlertView() -> Void {
        tlPrint(message: "removeAlertView")
        for view in alertView.subviews {
            view.removeFromSuperview()
        }
        self.alertView.removeFromSuperview()
        self.alertView = nil
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
    //红包左右浮动动画
    func floatAnimation(view:UIView) -> Void {
        let moveDistance = adapt_W(width: 9)//左右移动的距离
        let float = CABasicAnimation(keyPath: "transform.translation.x")
        float.duration = CFTimeInterval(2.5)
        float.autoreverses = true//是否重复
        float.repeatCount = HUGE
        float.isRemovedOnCompletion = false
        float.fillMode = kCAFillModeForwards
        float.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        float.fromValue = NSNumber(value: Float(-moveDistance))
        float.toValue = NSNumber(value: Float(moveDistance))
        view.layer.animation(forKey: "handsFloat")
        view.layer.add(float, forKey: nil)
        
    }
    
    //红包透视动画
    func perspectiveAnimation() -> Void {
        tlPrint(message: "perspectiveAnimation")
        //红包透视动画
        UIView.animate(withDuration: 3, animations: {
            var transform = CATransform3DIdentity
            transform.m34 = -1.0 / 400.0   //透视投影
            let angle = CGFloat(Double.pi * 0.03)
            transform = CATransform3DRotate(transform, angle, -1, 0, 0)//旋转
            self.redPacketImg.layer.transform = transform
        }, completion: { (finish) in
            UIView.animate(withDuration: 3, animations: {
                var transform = CATransform3DIdentity
                transform.m34 = 1.0 / 400.0   //透视投影
                let angle = CGFloat(Double.pi * 0.03)
                transform = CATransform3DRotate(transform, angle, -1, 0, 0)//旋转
                self.redPacketImg.layer.transform = transform
            })
        })
    }
    
    
    func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct sender.tag = \(sender.tag)")
        if sender.tag ==  redPacketTag.confirmBtnTag.rawValue {
            self.removeAlertView()
            return
        }
        self.delegate.btnAct(btnTag: sender.tag)
        
    }
    
    func tapAct(sender:UITapGestureRecognizer) -> Void {
        tlPrint(message: "tapAct: sender = \(String(describing: sender.view?.tag))")
        self.removeAlertView()
    }
    
}
