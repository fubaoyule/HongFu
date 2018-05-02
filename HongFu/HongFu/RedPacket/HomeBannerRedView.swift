//
//  HomeBannerRedView.swift
//  FuTu
//
//  Created by Administrator1 on 8/3/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

class HomeBannerRedView: UIView {
    
    
    var height,width:CGFloat!
    var delegate:BtnActDelegate!
    var startLabelImg,bombBgImg,bombImg,bombLeftImg: UIImageView!
    var redPacketTimer:Timer!
    var haveStart = false
    
    let baseVC = BaseViewController()
    init(frame:CGRect, haveStart:Bool, rootVC:UIViewController) {
        super.init(frame: frame)
        self.width = frame.width
        self.height = frame.height
        self.delegate = rootVC as! BtnActDelegate
        self.haveStart = haveStart
        self.backgroundColor = UIColor.black
        initRedPacketView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var redPacketImg:UIImageView!
    func initRedPacketView() -> Void {
        tlPrint(message: "initRedPacketView")
        //bomb background image
        bombBgImg = UIImageView(frame: self.frame)
        bombBgImg.image = UIImage(named: isPhone ? "redPacket_HomeBanner_bombBg.png" : "redPacket_HomeBanner_bombBg_Pad.png")
        self.addSubview(bombBgImg)
        bombBgImg.tag = redPacketTag.bannerBombTapTag.rawValue
        bombBgImg.isUserInteractionEnabled = true
        let bombTap = UITapGestureRecognizer(target: self, action: #selector(self.tapAct(sender:)))
        bombBgImg.addGestureRecognizer(bombTap)
        
        //bomb image
        bombImg = UIImageView(frame: self.frame)
        bombImg.image = UIImage(named: isPhone ? "redPacket_HomeBanner_bombText.png" : "redPacket_HomeBanner_bombText_Pad.png")
        self.insertSubview(bombImg, aboveSubview: bombBgImg)
        bombImg.tag = redPacketTag.bannerBombTapTag.rawValue
        bombImg.isUserInteractionEnabled = true
        bombImg.addGestureRecognizer(bombTap)
        
        
        //bomb left time image
        bombLeftImg = UIImageView(frame: self.frame)
        tlPrint(message: "haveStart: \(self.haveStart)")
        bombLeftImg.image = UIImage(named: (self.haveStart ? (isPhone ? "redPacket_HomeBanner_bombStart" : "redPacket_HomeBanner_bombStart_Pad") : (isPhone ? "redPacket_HomeBanner_bomb.png" : "redPacket_HomeBanner_bomb_Pad.png")))
        self.insertSubview(bombLeftImg, aboveSubview: bombImg)
        bombLeftImg.tag = redPacketTag.bannerBombTapTag.rawValue
        bombLeftImg.isUserInteractionEnabled = true
        bombLeftImg.addGestureRecognizer(bombTap)
        
        
        if self.haveStart {
            
            //            let leftNumFrame = CGRect(x: adapt_W(width: 155), y: adapt_H(height: 105), width: adapt_W(width: 112), height: adapt_H(height: 20))
            //            let leftNumFrame = CGRect(x: adapt_W(width: 155), y: adapt_H(height: (isPhone ? 105 : 59)), width: adapt_W(width: 112), height: adapt_H(height: 20))
            //            let leftNumLabel = baseVC.labelCreat(frame: leftNumFrame, text: "123123", aligment: .center, textColor: .colorWithCustom(r: 255, g: 205, b: 0), backgroundcolor: .clear, fonsize: fontAdapt(font: 30))
            //            leftNumLabel.font = UIFont(name: "Helvetica-BoldOblique", size: fontAdapt(font: 17))
            //            leftNumLabel.tag = redPacketTag.homeRedNumLabelTag.rawValue
            //            bombLeftImg.addSubview(leftNumLabel)
            //            //start image
            //            startLabelImg = UIImageView(frame: CGRect(x: (width - adapt_W(width: 97))/2, y: adapt_H(height: 140), width: adapt_W(width: 97), height: adapt_H(height: 22)))
            //            startLabelImg.image = UIImage(named: "redPaket_HomeBanner_startText.png")
            //            startLabelImg.tag = redPacketTag.startLabelImgTag.rawValue
            //            bombLeftImg.addSubview(startLabelImg)
            //
            //            tlPrint(message: "红包已经开抢")
            //            return
            initHomeRedPackStartView()
            return
        }
        // left time
        tlPrint(message: "******* 123")
        let leftWidth = adapt_W(width: 24)
        let leftTimeXArray:[CGFloat] = [87.5,108.5,130,170.5,191.5,230.5,252.5]
        let leftTimeXArrayPad:[CGFloat] = [127,140,151.5,175.3,187.8,212,224.5]
        //        let leftY = adapt_H(height: 105.5)
        let leftY = adapt_H(height: (isPhone ? 105.5 : 52.5))
        for i in 0 ..< 7 {
            let leftX = adapt_W(width: isPhone ? leftTimeXArray[i] : leftTimeXArrayPad[i])
            //            let leftTimeFrame = CGRect(x: leftX, y: leftY, width: leftWidth, height: adapt_H(height: 60))
            let leftTimeFrame = CGRect(x: leftX, y: leftY, width: leftWidth, height: adapt_H(height: (isPhone ? 60 : 40)))
            let leftTimeLabel = baseVC.labelCreat(frame: leftTimeFrame, text: "", aligment: .center, textColor: .colorWithCustom(r: 255, g: 48, b: 15), backgroundcolor: .clear, fonsize: fontAdapt(font: 28))
            //            leftTimeLabel.font = UIFont(name: "DBLCDTempBlack", size: fontAdapt(font: 28))
            leftTimeLabel.font = UIFont(name: "DBLCDTempBlack", size: fontAdapt(font: (isPhone ? 28 : 18)))
            leftTimeLabel.tag = redPacketTag.leftTimeTag.rawValue + i
            bombLeftImg.addSubview(leftTimeLabel)
        }
    }
    
    func initHomeRedPackStartView() -> Void {
        
        tlPrint(message: "***********\n\n\n\n\n\n************")
        //先去除倒计时
        for i in 0 ..< 7 {
            if let leftTimeLabel = self.viewWithTag(redPacketTag.leftTimeTag.rawValue + i) {
                (leftTimeLabel as! UILabel).removeFromSuperview()
            } else {
                break
            }
        }
        
        bombLeftImg.image = UIImage(named:  isPhone ? "redPacket_HomeBanner_bombStart" : "redPacket_HomeBanner_bombStart_Pad")
        let leftNumFrame = CGRect(x: adapt_W(width: isPhone ? 155 : 175), y: adapt_H(height: (isPhone ? 105 : 52)), width: adapt_W(width: isPhone ? 112 : 60), height: adapt_H(height: isPhone ? 22 : 20))
        let leftNumLabel = baseVC.labelCreat(frame: leftNumFrame, text: "", aligment: .center, textColor: .colorWithCustom(r: 255, g: 205, b: 0), backgroundcolor: .clear, fonsize: 0)
        leftNumLabel.font = UIFont(name: "Helvetica-BoldOblique", size: fontAdapt(font: isPhone ? 30 : 16))
        leftNumLabel.tag = redPacketTag.homeRedNumLabelTag.rawValue
        bombLeftImg.addSubview(leftNumLabel)
        //start image
        startLabelImg = UIImageView(frame: CGRect(x: (width - adapt_W(width: 97))/2, y: adapt_H(height: isPhone ? 140 : 78), width: adapt_W(width: isPhone ? 97 : 55), height: adapt_H(height: isPhone ? 22 : 14)))
        startLabelImg.image = UIImage(named: "redPaket_HomeBanner_startText.png")
        startLabelImg.tag = redPacketTag.startLabelImgTag.rawValue
        startLabelImg.center.x = bombLeftImg.center.x
        bombLeftImg.addSubview(startLabelImg)
        tlPrint(message: "红包已经开抢")
    }
    
    
    //缩放动画
    func scaleAnimation(view:UIView,delay:CGFloat,scale1:CGFloat,scale2:CGFloat,duration1:CGFloat,duration2:CGFloat) -> Void {
        //        tlPrint(message: "scaleAnimation")
        
        let durations = duration1 * 0.5
        UIView.animate(withDuration: TimeInterval(durations), delay: TimeInterval(delay), options: .allowUserInteraction, animations: {
            view.isHidden = false
            view.transform = CGAffineTransform(scaleX: scale1, y: scale1)
        }, completion: { (finisehd) in
            UIView.animate(withDuration: TimeInterval(durations), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: { (finisehd) in
                let durations = duration2 * 0.5
                UIView.animate(withDuration: TimeInterval(durations), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                    view.transform = CGAffineTransform(scaleX: scale2, y: scale2)
                }, completion: { (finisehd) in
                    UIView.animate(withDuration: TimeInterval(durations), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                        view.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }, completion: { (finisehd) in
                        //                            tlPrint(message: "动画完成")
                    })
                })
            })
        })
    }
    
    
    
    
    //重载倒计时
    func reloadLeftTimer(newTimeArray:Array<Int>) -> Void {
        //        tlPrint(message: "reloadLeftTimer newTimeArray:\(newTimeArray)")
        for i in 0 ..< 7 {
            let label = self.bombLeftImg.viewWithTag(redPacketTag.leftTimeTag.rawValue + i) as! UILabel
            label.text = "\(newTimeArray[i])"
        }
    }
    //触摸事件处理函数（dail）
    func tapAct(sender:UITapGestureRecognizer) -> Void {
        tlPrint(message: "tapAct: sender = \(String(describing: sender.view?.tag))")
        
        self.delegate.btnAct(btnTag: sender.view!.tag)
    }
    
}
