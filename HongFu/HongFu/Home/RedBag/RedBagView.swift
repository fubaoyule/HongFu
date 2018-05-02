//
//  RedBagView.swift
//  HongFu
//
//  Created by Administrator1 on 07/02/18.
//  Copyright © 2018年 Taylor Tan. All rights reserved.
//

import UIKit

class RedBagView: UIView {

    var alertType:redBagAlertType!
    var amount:String!
    let baseVC = BaseViewController()
    init(type:Int, amount:String?, frame:CGRect) {
        super.init(frame: frame)
        switch type {
        case 0:
            self.alertType = redBagAlertType.success
        case 1:
            self.alertType = redBagAlertType.unstart
        case 2:
            self.alertType = redBagAlertType.finish
        case 3:
            self.alertType = redBagAlertType.failed
        default:
            self.alertType = redBagAlertType.end
        }
        if let amount_t = amount {
            self.amount = amount_t
        }
        self.initAlertView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func initAlertView() -> Void {
        let shadowView = UIView(frame: self.frame)
        shadowView.backgroundColor = UIColor.black
        shadowView.alpha = 0.8
        self.addSubview(shadowView)
        
        let imgArray = ["Home_Redbag_success.png","Home_Redbag_unstart.png","Home_Redbag_finish.png","Home_Redbag_failed.png","Home_Redbag_failed.png"]
        let redbagImgW = adapt_W(width: 220)
        let redbagImgH = adapt_H(height: 300)
        let redbagImg = UIImageView(frame: CGRect(x: (deviceScreen.width - redbagImgW) / 2, y: adapt_H(height: 150), width: redbagImgW, height: redbagImgH))
        self.insertSubview(redbagImg, aboveSubview: shadowView)
        redbagImg.image = UIImage(named: "Home_Redbag_redbag.png")
        
        
        var redbagResultImgW = adapt_W(width: 183)
        var redbagResultImgH = adapt_H(height: 204)
        let redbagResultImg = UIImageView(frame: CGRect(x: (redbagImgW - redbagResultImgW) / 2, y: (redbagImgH - redbagResultImgH)  / 2, width: redbagResultImgW, height: redbagResultImgH))
        redbagImg.addSubview(redbagResultImg)
        redbagResultImg.image = UIImage(named: imgArray[self.alertType.rawValue])
        
        
        
        
        let confirmFrame = CGRect(x: (deviceScreen.width - adapt_W(width: 144)) / 2, y: adapt_H(height: 490), width: adapt_W(width: 144), height: adapt_H(height: 35))
        let confrimBtn = baseVC.buttonCreat(frame: confirmFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"Home_Redbag_confirmBtn.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.insertSubview(confrimBtn, aboveSubview: shadowView)
        
        switch self.alertType.rawValue {
        case redBagAlertType.unstart.rawValue:
            redbagResultImg.frame = CGRect(x: 0, y: 0, width: redbagImgW, height: redbagImgH)
        case redBagAlertType.success.rawValue:
            redbagResultImgW = adapt_W(width: 375)
            redbagResultImgH = adapt_H(height: 481)
            redbagResultImg.frame = CGRect(x: (redbagImgW - redbagResultImgW) / 2, y: (redbagImgH - redbagResultImgH)  / 2, width: redbagResultImgW, height: redbagResultImgH)
            self.initAmountLabel(superView: redbagResultImg)
            //缩放
            UIView.animate(withDuration: TimeInterval(0.0001), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                redbagImg.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: { (finisehd) in
                UIView.animate(withDuration: TimeInterval(0.3), delay: TimeInterval(0.2), options: .allowUserInteraction, animations: {
                    redbagImg.isHidden = false
                    redbagImg.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                }, completion: { (finisehd) in
                    UIView.animate(withDuration: TimeInterval(0.3), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                        redbagImg.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }, completion: { (finisehd) in
                        
                    })
                })
               
            })
            
            

            
        default:
            TLPrint("no such case!")
        }
        
        
    }
    func initAmountLabel(superView:UIView) -> Void {
        let amountLabelFrame = CGRect(x: 0, y: adapt_H(height: 180), width: superView.frame.width, height: adapt_H(height: 50))
        let amountLabel = baseVC.labelCreat(frame: amountLabelFrame, text: "\(self.amount!)元", aligment: .center, textColor:.colorWithCustom(r: 230, g: 25, b: 10), backgroundcolor: .clear, fonsize: fontAdapt(font: 48))
        amountLabel.font = UIFont(name: "Arial-BoldMT", size: fontAdapt(font: 48))
        superView.addSubview(amountLabel)
    }
    
    @objc func btnAct(sender:UIButton) -> Void {
        TLPrint("button action")
        for view in self.subviews {
            view.removeFromSuperview()
        }
        self.removeFromSuperview()
        
        
    }
    
    

}
