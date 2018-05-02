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
    var rootVC: UIViewController!
    var width,height: CGFloat!
    let baseVC = BaseViewController()
    var resultMaskView: UIView!
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
        initResultAlertView(alertInfo: "宝箱成功0000000")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.addSubview(resultMaskView)
        //添加弹窗底图
        let alertW = adapt_W(width: isPhone ? 323 : 232)
        let alertH = adapt_H(height: isPhone ? 197 : 120)
        let alertImgFrame = CGRect(x: (width - alertW) / 2, y: height, width: alertW, height: alertH)
        self.alertImg = baseVC.imageViewCreat(frame: alertImgFrame, image: UIImage(named:"TreasureBox_alert_bg.png")!, highlightedImage: UIImage(named:"TreasureBox_alert_bg.png")!)
        self.insertSubview(alertImg, aboveSubview: self.resultMaskView)
        
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
        self.addSubview(confirmBtn)
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
    
    
    

    
    private func getRandom() -> CGFloat {
    
        let signed = CGFloat((arc4random() % 10) % 2 == 0 ? 1 : -1)
        let number = CGFloat(arc4random() % 5)
        return CGFloat(signed * number)
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

    
    @objc func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct sender.tag = \(sender.tag)")
        
        self.delegate.btnAct(btnTag: sender.tag)
    }


}
