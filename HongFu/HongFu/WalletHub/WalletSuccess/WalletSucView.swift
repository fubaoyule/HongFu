//
//  WalletSucView.swift
//  FuTu
//
//  Created by Administrator1 on 28/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class WalletSucView: UIView {

    var delegate: BtnActDelegate!
    var inputTextField:UITextField!
    var width,height: CGFloat!
    let model = RechargeModel()
    var info: [Any]!
    
    let baseVC = BaseViewController()
    init(frame:CGRect, param:[Any],rootVC:UIViewController) {
        super.init(frame: frame)
        
        self.width = frame.width
        self.height = frame.height
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        self.delegate = rootVC as! BtnActDelegate
        tlPrint(message: "收到数据：\(param)")
        info = param
        initNavigationBar()
        
        initResultView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initNavigationBar() -> Void {
        //view
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20 + navBarHeight))
        self.addSubview(navigationView)
        navigationView.backgroundColor = UIColor.colorWithCustom(r: 26, g: 123, b: 233)
        //label
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: width, height: navBarHeight))
        setLabelProperty(label: titleLabel, text: "\(info[0])", aligenment: .center, textColor: .white, backColor: .clear, font: 17)
        navigationView.addSubview(titleLabel)
        
        
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        navigationView.addSubview(backBtn)
        backBtn.tag = walletSuccessTag.BackBtnTag.rawValue
        //back button image
//        let backBtnImg = UIImageView(frame: CGRect(x: 10, y: 12, width: 12, height: 20))
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
        
    }
    
    func initResultView() -> Void {
        
        let resultView = baseVC.viewCreat(frame: CGRect(x: 0, y: 20 + navBarHeight, width: width, height: adapt_H(height: 350)), backgroundColor: .white)
        
        self.addSubview(resultView)
        
        
        //image
        let img = UIImageView(frame: CGRect(x: (width - adapt_W(width: 60)) / 2, y: adapt_H(height: 30), width: adapt_W(width: 60), height: adapt_W(width: 60)))
        resultView.addSubview(img)
        if info[1] as! Bool {
            img.image = UIImage(named: "wallet_recharge_success_icon.png")
        } else {
            img.image = UIImage(named: "wallet_recharge_success_icon2.png")
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            img.frame = CGRect(x: (self.width - adapt_W(width: 90)) / 2, y: adapt_H(height: 15), width: adapt_W(width: 90), height: adapt_W(width: 90))
            img.center = img.center
        }, completion: { (finished) in
            UIView.animate(withDuration: 0.5, animations: {
                img.frame = CGRect(x: (self.width - adapt_W(width: 60)) / 2, y: adapt_H(height: 30), width: adapt_W(width: 60), height: adapt_W(width: 60))
                img.center = img.center
            })
        })
        
        
        //result label
        let labelText = info[1] as! Bool ? "\(info[0])成功！":"\(info[0])失败！"
        let resultFrame = CGRect(x: adapt_W(width: 10), y: adapt_H(height: 108), width: width, height: adapt_H(height: 19))
        let resultLabel = baseVC.labelCreat(frame: resultFrame, text: labelText, aligment: .center, textColor: .colorWithCustom(r: 35, g: 35, b: 35), backgroundcolor: .clear, fonsize: fontAdapt(font: 20))
        resultView.addSubview(resultLabel)
        
        let alertFrame = CGRect(x: 0, y: adapt_H(height: 137), width: width, height: adapt_H(height: 15))
        var alertText = "（可前往中心钱包查看余额）"
        if info[0] as! String == "存款" {
            alertText = "（可前往中心钱包查看余额）"
        } else if info[0] as! String == "取款" {
            alertText = "（一般情况下 10 分钟内到账）"
        }
        let alertLabel = baseVC.labelCreat(frame: alertFrame, text: alertText, aligment: .center, textColor: .colorWithCustom(r: 193, g: 193, b: 193), backgroundcolor: .clear, fonsize: fontAdapt(font: 15))
        resultView.addSubview(alertLabel)
        //amount label
        let amountFrame = CGRect(x: 0 , y: adapt_H(height: 172), width: width, height: adapt_H(height: 18))
        let amountLabel = baseVC.labelCreat(frame: amountFrame, text: "\(info[0])金额：\(info[2])", aligment: .center, textColor: .colorWithCustom(r: 245, g: 63, b: 0), backgroundcolor: .clear, fonsize: fontAdapt(font: 17))
        resultView.addSubview(amountLabel)
        setLabelWithDiff(label: amountLabel, text: "\(info[0])金额：\(info[2])", font: fontAdapt(font: 17), color: .colorWithCustom(r: 35, g: 35, b: 35), range: NSRange(location: 0, length: 5))
        //recharge type
        let typeFrame = CGRect(x: 0, y: adapt_H(height: 200), width: width, height: adapt_H(height: 18))
        let typeLable = baseVC.labelCreat(frame: typeFrame, text: "\(info[0])方式：\(info[3])", aligment: .center, textColor: .colorWithCustom(r: 35, g: 35, b: 35), backgroundcolor: .clear, fonsize: fontAdapt(font: 17))
        resultView.addSubview(typeLable)
        
        
        //finish button
        let finishFrame = CGRect(x: adapt_W(width: 20), y: adapt_H(height: 260), width: width - adapt_W(width: 40), height: adapt_H(height: 50))
        let finishBtn = baseVC.buttonCreat(frame: finishFrame, title: "完 成", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 0, g: 101, b: 215), fonsize: fontAdapt(font: 17), events: .touchUpInside)
        resultView.addSubview(finishBtn)
        finishBtn.tag = walletSuccessTag.FinishBtnTag.rawValue
        finishBtn.layer.cornerRadius = adapt_W(width: 5)
        
    }
    
    
    
    @objc func btnAct(sender:UIButton) -> Void {
        delegate.btnAct(btnTag: sender.tag)
    }
    
    func setLabelWithDiff(label:UILabel, text:String, font:CGFloat, color:UIColor, range:NSRange) -> Void {
        label.text = text
        let attStr = NSMutableAttributedString(string: text)
        attStr.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        attStr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: font), range: range)
        label.attributedText = attStr
    }
    
}
