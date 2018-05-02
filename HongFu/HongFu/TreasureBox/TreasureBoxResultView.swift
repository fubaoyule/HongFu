//
//  TreasureBoxResultView.swift
//  FuTu
//
//  Created by Administrator1 on 25/8/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

class TreasureBoxResultView: UIView {

    var delegate: BtnActDelegate!
    var rootVC: UIViewController!
    var width,height: CGFloat!
    let baseVC = BaseViewController()
    var resultView:UIView!
    
    init(frame:CGRect,rootVC:UIViewController) {
        super.init(frame: frame)
        self.width = frame.width
        self.height = frame.height
        self.rootVC = rootVC
        
        
        _ = initMaskView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initMaskView() -> UIView {
        let mask = UIView(frame: self.frame)
        mask.backgroundColor = UIColor.colorWithCustom(r: 24, g: 5, b: 29)
        mask.alpha = 0.8
        self.insertSubview(mask, at: 0)
        return mask
    }
    
    
    
    
    
//    func initbackLightView() -> UIView {
//        let result = UIView(frame: self.frame)
//        
//        //back light
//        let backLightImg = UIImageView(frame: CGRect(x: isPhone ? 0 : 50, y: adapt_H(height: isPhone ? 60 : 40), width: width - adapt_W(width: isPhone ? 0 : 100), height: width - adapt_W(width: isPhone ? 0 : 100)))
//        backLightImg.image = UIImage(named: "egg_opened_light.png")
//        rotateAnimation(view: backLightImg)
//        
//        self.addSubview(backLightImg)
//        return result
//    }
    
    
//    var dataSource: String = "??"
//    func initResultView() -> UIView {
//        
//        let resultFrame = CGRect(x: isPhone ? 0 : 50, y: adapt_H(height: isPhone ? 60 : 40), width: width - adapt_W(width: isPhone ? 0 : 100), height: width - adapt_W(width: isPhone ? 0 : 100))
//        let resultView = UIView(frame: resultFrame)
//        resultView.center.x = self.center.x
//        resultView.clipsToBounds = true
//        //back light
//        let backLightImg = UIImageView(frame: CGRect(x: 0, y: 0, width: resultView.frame.width, height: resultView.frame.width))
//        backLightImg.image = UIImage(named: "egg_opened_light.png")
//        rotateAnimation(view: backLightImg)
//        resultView.addSubview(backLightImg)
//        
//        //result account image
//        let accoutImg = UIImageView(frame: CGRect(x: 0, y: resultView.frame.height * 0.3, width: resultView.frame.width, height: resultView.frame.width * 0.3))
//        accoutImg.image = UIImage(named: "egg_opened_labelBg.png")
//        resultView.insertSubview(accoutImg, aboveSubview: backLightImg)
//        // result account label
//        accountLabel = UILabel(frame: CGRect(x: adapt_W(width: 90), y: adapt_H(height: isPhone ? 56 : 44), width: self.width - adapt_W(width: isPhone ? 180 : 280), height: adapt_H(height: isPhone ? 30 : 20)))
//        accoutImg.addSubview(accountLabel)
//        setLabelProperty(label: accountLabel, text: "处理中，请稍后查看", aligenment: .center, textColor: .white, backColor: .red, font: 0)
//        accountLabel.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: fontAdapt(font: isPhone ? 18 : 12))
//        tlPrint(message: "awardAccountLabelInfo = \(awardAccountLabelInfo) **************")
//        let text = awardAccountLabelInfo
//        accountLabel.text = text
//        accountLabel.tag = EggTag.awardAmountLbelTag.rawValue
//        
//        //base image
//        let baseImg = UIImageView(frame: CGRect(x: resultView.frame.width * 0.35, y: resultView.frame.width * 0.6, width: resultView.frame.width * 0.3, height: resultView.frame.width * 0.23))
//        baseImg.image = UIImage(named: "egg_opened_base.png")
//        resultView.insertSubview(baseImg, aboveSubview: backLightImg)
//        
//        UIView.animate(withDuration: 0.001, animations: {
//            resultView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
//            
//        }, completion: { (finished) in
//            UIView.animate(withDuration: 1.6, animations: {
//                resultView.transform = CGAffineTransform(scaleX: 1, y: 1)
//            }, completion: { (finished) in
//                UIView.animate(withDuration: 0.25, animations: {
//                    accoutImg.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
//                    baseImg.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
//                }, completion: { (finished) in
//                    UIView.animate(withDuration: 0.20, animations: {
//                        accoutImg.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                        baseImg.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                    }, completion: { (finished) in
//                        tlPrint(message: "完成动画")
//                        DispatchQueue.main.async {
//                            let text = self.awardAccountLabelInfo
//                            self.accountLabel.text = text
//                        }
//                    })
//                })
//            })
//        })
//        return resultView
//    }

    
    
    
    

}
