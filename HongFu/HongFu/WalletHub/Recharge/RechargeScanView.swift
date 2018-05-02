//
//  RechargeScanView.swift
//  FuTu
//
//  Created by Administrator1 on 11/4/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

class RechargeScanView: UIView {
    
    var delegate: BtnActDelegate!
    var width,height: CGFloat!
    var rootVC:UIViewController!
    var indicator:TTIndicators!
    var payType:PayType!
    var selectedBtnTag:Int = rechargeTag.TimeCardPayTypeBtnTag.rawValue
    let baseVC = BaseViewController()
    let totleNumberOfTimeCard = 15
    var textFeildDelegate: UITextFieldDelegate!
    var scroll:UIScrollView!
    
    init(frame:CGRect, payType:PayType,rootVC:UIViewController) {
        super.init(frame: frame)
        
        self.width = frame.width
        self.height = frame.height
        self.payType = payType
        self.delegate = rootVC as! BtnActDelegate
        self.textFeildDelegate = rootVC as! UITextFieldDelegate
        self.rootVC = rootVC
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        self.initNavigationBar()
        
        //        self.initScanInfoView()
        self.initScrollView {
            self.initUnionPayView(paytype: self.payType)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func initNavigationBar() -> Void {
        //view
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20 + navBarHeight))
        self.addSubview(navigationView)
        let gradientLayer = CAGradientLayer.GradientLayer(topColor: UIColor.colorWithCustom(r: 65, g: 50, b: 48), buttomColor: UIColor.colorWithCustom(r: 43, g: 38, b: 34))
        gradientLayer.frame = navigationView.frame
        navigationView.layer.insertSublayer(gradientLayer, at: 0)
        //label
        
        let titleText = self.payType == PayType.UnionPay ? "网银转账" : "微信转银行"
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: width, height: navBarHeight))
        setLabelProperty(label: titleLabel, text: titleText, aligenment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .clear, font: 17 )
        navigationView.addSubview(titleLabel)
        
        
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        backBtn.tag = rechargeTag.RechargeScanBackTag.rawValue
        navigationView.addSubview(backBtn)
        
        //back button image
        //        let backBtnImg = UIImageView(frame: CGRect(x: 10, y: 12, width: 12, height: 20))
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
        
    }
    
    func initScrollView(finished:@escaping() -> ()) -> Void {
        self.scroll = UIScrollView(frame: CGRect(x: 0, y: 64, width: width, height:height - 64))
        self.addSubview(scroll)
        self.scroll.contentSize = CGSize(width: frame.width, height: height)
        self.scroll.showsVerticalScrollIndicator = false
        self.scroll.showsHorizontalScrollIndicator = false
        self.scroll.canCancelContentTouches = true
        self.addSubview(scroll)
        finished()
    }
    
    
    
    //点卡支付
//    func initTimePayView() -> Void {
//        tlPrint(message: "initUnionPayView")
//        //点卡选择按钮视图
//        let numPerLine:CGFloat = isPhone ? 3 : 4
//        let btnNum = self.totleNumberOfTimeCard % Int(numPerLine) == 0 ? self.totleNumberOfTimeCard : (self.totleNumberOfTimeCard / Int(numPerLine) + 1) * Int(numPerLine)
//        let leftDistance = adapt_W(width: isPhone ? 5 : 20)
//        let typeView = UIView(frame: CGRect(x: leftDistance, y: adapt_H(height: isPhone ? 5 : 12), width: width - leftDistance * 2, height: adapt_H(height: isPhone ? 300 : 180)))
//        typeView.layer.cornerRadius = adapt_W(width: 4)
//        typeView.clipsToBounds = true
//        typeView.layer.borderColor = UIColor.colorWithCustom(r: 209, g: 209, b: 209).cgColor
//        typeView.layer.borderWidth = adapt_W(width: 0.5)
//        self.scroll.addSubview(typeView)
//        typeView.backgroundColor = UIColor.white
//        
//        tlPrint(message: "btnNum:\(btnNum)")
//        for i in 0 ..< btnNum {
//            let timeCardHeight:CGFloat = adapt_H(height: isPhone ? 60 : 45)
//            let timeCardWidth:CGFloat = (width - leftDistance * 2) / numPerLine
//            let timeCardX:CGFloat = CGFloat(i % Int(numPerLine)) * timeCardWidth
//            let timeCardY:CGFloat = CGFloat(i / Int(numPerLine)) * timeCardHeight
//            let timeCardFrame = CGRect(x: timeCardX, y: timeCardY, width: timeCardWidth, height: timeCardHeight)
//            let timeCardBtn = baseVC.buttonCreat(frame: timeCardFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .white, fonsize: 0, events: .touchUpInside)
//            timeCardBtn.tag = rechargeTag.TimeCardPayTypeBtnTag.rawValue + i
//            typeView.addSubview(timeCardBtn)
//            timeCardBtn.layer.borderColor = UIColor.colorWithCustom(r: 255, g: 192, b: 0).cgColor
//            timeCardBtn.layer.borderWidth = adapt_H(height: isPhone ? 0.25 : 0.125)
//            
//            
//            let imgView = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 8 : 10), y: adapt_H(height: isPhone ? 8 : 10), width: timeCardWidth - adapt_W(width: isPhone ? 16 : 20), height: timeCardHeight - adapt_H(height: isPhone ? 16 : 20)))
//            //imgView.center = timeCardBtn.center
//            let model = RechargeModel()
//            if i < self.totleNumberOfTimeCard {
//                imgView.image = UIImage(named: "wallet_timecard_\(model.timeCardTypeArray[i]).png")
//            } else {
//                imgView.image = UIImage(named: "wallet_timecard_0.png")
//            }
//            timeCardBtn.addSubview(imgView)
//            if i == 0 {
//                timeCardBtn.layer.borderWidth = adapt_W(width: isPhone ? 2 : 1.5)
//                timeCardBtn.layer.borderColor = UIColor.colorWithCustom(r: 255, g: 192, b: 0).cgColor
//            }
//        }
//        
//        //信息输入视图
//        let inputView = UIView(frame: CGRect(x: leftDistance, y: adapt_H(height: isPhone ? 315 : 205), width: width - leftDistance * 2, height: adapt_H(height: isPhone ? 112 : 70)))
//        inputView.layer.cornerRadius = adapt_W(width: 4)
//        self.scroll.addSubview(inputView)
//        inputView.clipsToBounds = true
//        inputView.layer.borderColor = UIColor.colorWithCustom(r: 209, g: 209, b: 209).cgColor
//        inputView.layer.borderWidth = adapt_H(height: isPhone ? 0.25 : 0.125)
//        inputView.backgroundColor = UIColor.white
//        let labelText = ["点卡账号：","点卡密码："]
//        let keyboardType = [UIKeyboardType.default,UIKeyboardType.numberPad]
//        for i in 0 ..< 2 {
//            let inputFrame = CGRect(x: 0, y: CGFloat(i) * inputView.frame.height / 2, width: inputView.frame.width, height: inputView.frame.height / 2)
//            let inputTextField = baseVC.textFieldCreat(frame: inputFrame, placeholderText: "", aligment: .left, fonsize: fontAdapt(font: isPhone ? 20 : 11), borderWidth: adapt_W(width: 0.5), borderColor: .colorWithCustom(r: 193, g: 193, b: 193), tag: rechargeTag.TimeCardPayInputTextFeildTag.rawValue + i)
//            inputView.addSubview(inputTextField)
//            inputTextField.textColor = UIColor.colorWithCustom(r: 35, g: 35, b: 35)
//            inputTextField.delegate = self.textFeildDelegate
//            
//            let leftLabel = baseVC.labelCreat(frame: CGRect(x: 0, y: 0, width: adapt_W(width: isPhone ? 90 : 60),height:inputTextField.frame.height), text: labelText[i], aligment: .right, textColor: .colorWithCustom(r: 35, g: 35, b: 35), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 16 : 10))
//            leftLabel.center.y = inputTextField.center.y
//            inputTextField.leftView = leftLabel
//            inputTextField.leftViewMode = .always
//            inputTextField.keyboardType = keyboardType[i]
//            inputTextField.layer.borderColor = UIColor.colorWithCustom(r: 209, g: 209, b: 209).cgColor
//            inputTextField.layer.borderWidth = adapt_H(height: isPhone ? 0.25 : 0.125)
//            
//        }
//        
//        //确认按钮视图
//        let confirmFrame = CGRect(x: adapt_W(width: isPhone ? 20 : 50), y: adapt_H(height: isPhone ? 450 : 295), width: width - adapt_W(width: isPhone ? 40 : 100), height: adapt_H(height: isPhone ? 50 : 30))
//        let confirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "充值确认", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 186, g: 10, b: 27), fonsize: fontAdapt(font: isPhone ? 20 : 12), events: .touchUpInside)
//        self.scroll.addSubview(confirmBtn)
//        confirmBtn.layer.cornerRadius = adapt_W(width: 4)
//        confirmBtn.tag = rechargeTag.TimeCardPayConfirmBtnTag.rawValue
//        //4,confirmBtn.isUserInteractionEnabled = true
//        
//    }
//    
//    func timeCardSelected(tag:Int) -> Void {
//        tlPrint(message: "timeCardSelected tag: \(tag)")
//        if tag == self.selectedBtnTag {
//            tlPrint(message: "the same button do nothing for this action")
//            return
//        }
//        if tag - rechargeTag.TimeCardPayTypeBtnTag.rawValue >= self.totleNumberOfTimeCard {
//            tlPrint(message: "超出了可选择的个数")
//            return
//            
//        }
//        let lastBtn = self.viewWithTag(self.selectedBtnTag) as! UIButton
//        lastBtn.layer.borderColor = UIColor.colorWithCustom(r: 209, g: 209, b: 209).cgColor
//        lastBtn.layer.borderWidth = adapt_W(width: 0.25)
//        let selectedBtn = self.viewWithTag(tag) as! UIButton
//        selectedBtn.layer.borderWidth = adapt_W(width: isPhone ? 2 : 1.5)
//        selectedBtn.layer.borderColor = UIColor.colorWithCustom(r: 255, g: 192, b: 0).cgColor
//        self.selectedBtnTag = tag
//    }
//    
//    func timeCardViewMoveUp(isNeedUp: Bool) -> Void {
//        tlPrint(message: "timeCardViewMoveUp")
//        let resultFrame = CGRect(x: 0, y: isNeedUp ? adapt_H(height: isPhone ? -180 : -50) : 0, width: self.frame.width, height: self.frame.height)
//        if resultFrame == self.frame {
//            tlPrint(message: "no need animations")
//            return
//        }
//        UIView.animate(withDuration: 0.2) {
//            self.frame = resultFrame
//        }
//    }
//    
    
    //微信转网银，网银转网银 支付
    func initUnionPayView(paytype:PayType) -> Void {
        tlPrint(message: "initUnionPayView")
        
        let labelArray = ["姓 名","账 号","金 额","地 址","附 言"]
        let methodInfoArray = paytype == PayType.WechaToBank ? [["微信转银行卡支付说明：",fontAdapt(font: 15),UIColor.colorWithCustom(r: 35, g: 35, b: 35)],
                               ["1、进入微信钱包-收付款-转行到银行卡，填写以上信息，选择‘2小时内到账’\n2、准确填写附言将缩短到账时间",fontAdapt(font: 12),UIColor.colorWithCustom(r: 35, g: 35, b: 35)],
                               ["（注：请确保’微信转账‘和确认的充值金额一直，以及选择‘2小时内到账，否则无法及时到账。）",fontAdapt(font: 12),UIColor.colorWithCustom(r: 211, g: 18, b: 0)]] : [
                                ["网银转账支付说明：",fontAdapt(font: 15),UIColor.colorWithCustom(r: 35, g: 35, b: 35)],
                                ["1、进入网银，输入转账信息，选择‘2小时内到账’\n2、准确填写附言将缩短到账时间",fontAdapt(font: 12),UIColor.colorWithCustom(r: 35, g: 35, b: 35)],
                                ["（注：请确保’网银转账‘和确认的充值金额一直，否则无法及时到账。）",fontAdapt(font: 12),UIColor.colorWithCustom(r: 211, g: 18, b: 0)]]
        let infoView = UIView(frame: CGRect(x: adapt_W(width: 10), y: adapt_W(width: 15), width: width - adapt_W(width: 20), height: adapt_W(width: isPhone ? 300 : 175)))
        self.scroll.addSubview(infoView)
        infoView.layer.cornerRadius = adapt_W(width: 6)
        infoView.layer.borderColor = UIColor.colorWithCustom(r: 228, g: 228, b: 228).cgColor
        infoView.layer.borderWidth = adapt_W(width: 1)
        infoView.backgroundColor = UIColor.white
        infoView.clipsToBounds = true
        
        let payImgArray = [self.payType == PayType.WechaToBank ? "wallet_scan_wechatLogo.png":"wallet_recharge_unionImg.png","wallet_recharge_toImg.png","wallet_recharge_unionImg.png"]
        let payImgWidth = adapt_W(width: isPhone ? 125 : 80)
        let payImgFrameArray = [CGRect(x: adapt_W(width: isPhone ? 15 : 10),
                                       y: adapt_H(height: isPhone ? 15 : 10),
                                       width: payImgWidth,
                                       height: adapt_H(height: isPhone ? 45 : 30)),
                                CGRect(x: adapt_W(width: isPhone ? 160 : 120),
                                       y: adapt_H(height: isPhone ? 15 : 10),
                                       width: adapt_W(width: isPhone ? 23 : 15),
                                       height: adapt_H(height: isPhone ? 45 : 30)),
                                CGRect(x: infoView.frame.width - payImgWidth - adapt_W(width: isPhone ? 15 : 10),
                                       y: adapt_H(height: isPhone ? 15 : 10),
                                       width: payImgWidth,
                                       height: adapt_H(height: isPhone ? 45 : 30))]
        for i in 0 ... labelArray.count {
            if i == 0 {
                let imgView = UIView(frame: CGRect(x: 0, y: 0, width: infoView.frame.width, height: adapt_H(height: isPhone ? 75 : 50)))
                imgView.backgroundColor = UIColor.white
                infoView.addSubview(imgView)
                for j in 0 ..< 3 {
                    let img = UIImageView(frame: payImgFrameArray[j])
                    img.image = UIImage(named: payImgArray[j])
                    imgView.addSubview(img)
                    if j == 1 {
                        img.center.x = imgView.center.x
                    }
                }
                //line
                let line = UIView(frame: CGRect(x: 0, y: imgView.frame.height - adapt_H(height: isPhone ? 1 : 0.5), width: imgView.frame.width, height: adapt_H(height: isPhone ? 1 : 0.5)))
                line.backgroundColor = UIColor.colorWithCustom(r: 228, g: 228, b: 228)
                imgView.addSubview(line)
                continue
            }
            
            let labelView = UIView(frame: CGRect(x: 0, y: adapt_H(height: isPhone ? 75 + CGFloat(i - 1) * 45 : 50 + CGFloat(i - 1) * 25), width: infoView.frame.width, height: adapt_H(height: isPhone ? 45 : 25)))
            labelView.backgroundColor = UIColor.white
            infoView.addSubview(labelView)
            let infoLabelFrame = CGRect(x: 0, y: 0, width: adapt_W(width: isPhone ? 100 : 60), height:labelView.frame.height)
            let infoLabel = baseVC.labelCreat(frame: infoLabelFrame, text: labelArray[i - 1], aligment: .center, textColor: .colorWithCustom(r: 35, g: 35, b: 35), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 15 : 9))
            labelView.addSubview(infoLabel)
            
            let infoValueFrame = CGRect(x: adapt_W(width: isPhone ? 100 : 60), y: 0, width: labelView.frame.width - adapt_W(width: isPhone ? 100 : 60), height: labelView.frame.height)
            let valueLabel = baseVC.labelCreat(frame: infoValueFrame, text: "", aligment: .left, textColor: .colorWithCustom(r: 211, g: 18, b: 0), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 17 : 11))
            valueLabel.tag = rechargeTag.RechargeScanValueLabelTag.rawValue + i - 1
            labelView.addSubview(valueLabel)
            
            //line
            let line = UIView(frame: CGRect(x: 0, y: labelView.frame.height - adapt_H(height: 1), width: labelView.frame.width, height: adapt_H(height: isPhone ? 1 : 0.5)))
            line.backgroundColor = UIColor.colorWithCustom(r: 228, g: 228, b: 228)
            labelView.addSubview(line)
            
            //微信转银行，金额进行提示
            if self.payType == PayType.WechaToBank && i == 3 {
                let amountAlertText = "为了能及时到账\n请按照该金额进行充值"
                let amoutAlertLabelFrame = CGRect(x: labelView.frame.width - adapt_H(height: isPhone ? 155 : 115), y: adapt_H(height: 5), width: adapt_W(width: isPhone ? 150 : 160), height:labelView.frame.height - adapt_H(height: 10))
                let infoLabel = baseVC.labelCreat(frame: amoutAlertLabelFrame, text: amountAlertText, aligment: .center, textColor: .red, backgroundcolor: UIColor.colorWithCustom(r: 225, g: 225, b: 225), fonsize: fontAdapt(font: isPhone ? 12 : 8))
                infoLabel.numberOfLines = 0
                infoLabel.layer.borderColor = UIColor.colorWithCustom(r: 185, g: 185, b: 185).cgColor
                infoLabel.layer.borderWidth = adapt_H(height: 1)
                labelView.addSubview(infoLabel)
            }
            
        }
        let confirmFrame = CGRect(x: adapt_W(width: isPhone ? 60 : 50), y: adapt_H(height: isPhone ? 350 : 220), width: width - adapt_W(width: isPhone ? 120 : 100), height: adapt_H(height: isPhone ? 40 : 20))
        let confirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "充值确认", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 186, g: 10, b: 27), fonsize: fontAdapt(font: isPhone ? 17 : 11), events: .touchUpInside)
        self.scroll.addSubview(confirmBtn)
        confirmBtn.layer.cornerRadius = adapt_W(width: isPhone ? 4 : 3)
        confirmBtn.tag = rechargeTag.UnionPayConfirmBtnTag.rawValue
//        confirmBtn.isUserInteractionEnabled = false
        confirmBtn.isHidden = true
        
        
        //提示文本
        for i in 0 ..< 3 {
            let textFrameArray = [CGRect(x: adapt_W(width: 30),
                                         y: adapt_H(height: isPhone ? 410 : 120),
                                         width: adapt_W(width: 250),
                                         height: adapt_H(height: isPhone ? 15 : 15)),
                                  CGRect(x: adapt_W(width: 30),
                                         y: adapt_H(height: isPhone ? 430 : 120 + 15),
                                         width: infoView.frame.width - adapt_W(width: 60),
                                         height: adapt_H(height: isPhone ? 60 : 60)),
                                  CGRect(x: adapt_W(width: 30),
                                         y: adapt_H(height: isPhone ? 480 : 120 + 7 + 60),
                                         width: infoView.frame.width - adapt_W(width: 60),
                                         height: adapt_H(height: isPhone ? 70 : 40))]
            
            let label = baseVC.labelCreat(frame: textFrameArray[i],
                                          text: methodInfoArray[i][0]as! String,
                                          aligment: .left,
                                          textColor: methodInfoArray[i][2] as! UIColor,
                                          backgroundcolor: .clear,
                                          fonsize: methodInfoArray[i][1] as! CGFloat)
            
            self.scroll.addSubview(label)
            label.numberOfLines = 0 //自动换行            
            let attributedString:NSMutableAttributedString = NSMutableAttributedString(string:  (methodInfoArray[i][0] as! String))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = adapt_H(height: isPhone ? 6 : 4) //修改行间距
            
            attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0,  (methodInfoArray[i][0]  as! String).characters.count))
            label.attributedText = attributedString
        }
    }
    
    
    //微信和支付宝支付
    func initScanInfoView() -> Void {
        tlPrint(message: "initScanInfoView")
        let labelArray = (self.payType == PayType.WeChatPay ? ["微信号","金 额"] : ["附 言","姓 名","账 号","金 额","地 址"])
        
        let methodInfoArray = (self.payType == PayType.WeChatPay ? [["微信支付方式说明：",fontAdapt(font: 15),UIColor.colorWithCustom(r: 35, g: 35, b: 35)],["1、添加鸿福微信收款专员，通过“微信－转账”付款\n\n2、将您的“会员账号”和“姓名”通过微信告诉鸿福收款专员。等待充值成功",fontAdapt(font: 12),UIColor.colorWithCustom(r: 35, g: 35, b: 35)],["（注：请确保“微信支付”和确认的充值金额一直，否则无法及时到账。）",fontAdapt(font: 12),UIColor.colorWithCustom(r: 211, g: 18, b: 0)]] : [["",fontAdapt(font: 0),UIColor.clear],["",fontAdapt(font: 0),UIColor.clear],["（注：填写正确的备注（附言后的红色6位阿拉伯数字）秒存秒到，若填写附言错误，请您联系在线客服处理，但还请耐心等待！）",fontAdapt(font: 12),UIColor.colorWithCustom(r: 211, g: 18, b: 0)]])
        let methodInfoArrayPad = (self.payType == PayType.WeChatPay ? [["微信支付方式说明：",fontAdapt(font: 9),UIColor.colorWithCustom(r: 35, g: 35, b: 35)],["1、扫描下侧二维码，添加鸿福微信收款专员，通过“微信－转账”付款，并将“附言”输入微信转账说明\n2、将您的“会员账号”和“姓名”通过微信告诉鸿福收款专员。等待充值成功",fontAdapt(font: 7),UIColor.colorWithCustom(r: 35, g: 35, b: 35)],["（注：请确保“微信支付”和确认的充值金额一直，否则无法及时到账。）",fontAdapt(font: 7),UIColor.colorWithCustom(r: 211, g: 18, b: 0)]] : [["",fontAdapt(font: 0),UIColor.clear],["",fontAdapt(font: 0),UIColor.clear],["（注：填写正确的备注（附言后的红色6位阿拉伯数字）秒存秒到，若填写附言错误，请您联系在线客服处理，但还请耐心等待！）",fontAdapt(font: 7),UIColor.colorWithCustom(r: 211, g: 18, b: 0)]])
        
        let infoView = UIView(frame: CGRect(x: adapt_W(width: 10),
                                            y: adapt_W(width: 5),
                                            width: width - adapt_W(width: 20),
                                            height: adapt_W(width: isPhone ? 380 : 250)))
        self.scroll.addSubview(infoView)
        infoView.layer.cornerRadius = adapt_W(width: 5)
        infoView.layer.borderColor = UIColor.colorWithCustom(r: 228, g: 228, b: 228).cgColor
        infoView.layer.borderWidth = adapt_W(width: 1)
        infoView.backgroundColor = UIColor.colorWithCustom(r: 244, g: 244, b: 244)
        infoView.clipsToBounds = true
        let payImgArray = [self.payType == PayType.WeChatPay ? "wallet_scan_wechatLogo.png" : "wallet_scan_aliLogo.png","wallet_recharge_toImg.png",self.payType == PayType.WeChatPay ? "wallet_scan_wechatLogo.png" :"wallet_recharge_unionImg.png"]
        let payImgWidth = adapt_W(width: isPhone ? 125 : 80)
        let payImgFrameArray = [CGRect(x: adapt_W(width: isPhone ? 15 : 10),
                                       y: adapt_H(height: isPhone ? 15 : 10),
                                       width: payImgWidth,
                                       height: adapt_H(height: isPhone ? 45 : 30)),
                                CGRect(x: adapt_W(width: isPhone ? 160 : 120),
                                       y: adapt_H(height: isPhone ? 15 : 10),
                                       width: adapt_W(width: isPhone ? 23 : 15),
                                       height: adapt_H(height: isPhone ? 45 : 30)),
                                CGRect(x: infoView.frame.width - payImgWidth - adapt_W(width: isPhone ? 15 : 10),
                                       y: adapt_H(height: isPhone ? 15 : 10),
                                       width: payImgWidth,
                                       height: adapt_H(height: isPhone ? 45 : 30))]
        for i in 0 ... labelArray.count {
            if i == 0 {
                let imgView = UIView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: infoView.frame.width,
                                                   height: adapt_H(height: isPhone ? 75 : 50)))
                imgView.backgroundColor = UIColor.white
                infoView.addSubview(imgView)
                for j in 0 ..< 3 {
                    let img = UIImageView(frame: payImgFrameArray[j])
                    img.image = UIImage(named: payImgArray[j])
                    imgView.addSubview(img)
                    if j == 1 {
                        img.center.x = imgView.center.x
                    }
                }
                //line
                let line = UIView(frame: CGRect(x: 0,
                                                y: imgView.frame.height - adapt_H(height: isPhone ? 1 : 0.5),
                                                width: imgView.frame.width,
                                                height: adapt_H(height: isPhone ? 1 : 0.5)))
                line.backgroundColor = UIColor.colorWithCustom(r: 228, g: 228, b: 228)
                imgView.addSubview(line)
                continue
            }
            let labelView = UIView(frame: CGRect(x: 0,
                                                 y: adapt_H(height: isPhone ? 75 + CGFloat(i - 1) * 45 : 50 + CGFloat(i - 1) * 25),
                                                 width: infoView.frame.width,
                                                 height: adapt_H(height: isPhone ? 45 : 25)))
            labelView.backgroundColor = UIColor.white
            infoView.addSubview(labelView)
            let infoLabelFrame = CGRect(x: 0,
                                        y: 0,
                                        width: adapt_W(width: isPhone ? 100 : 60),
                                        height:labelView.frame.height)
            let infoLabel = baseVC.labelCreat(frame: infoLabelFrame,
                                              text: labelArray[i - 1],
                                              aligment: .center,
                                              textColor: .colorWithCustom(r: 35, g: 35, b: 35),
                                              backgroundcolor: .clear,
                                              fonsize: fontAdapt(font: isPhone ? 15 : 9))
            labelView.addSubview(infoLabel)
            
            let infoValueFrame = CGRect(x: adapt_W(width: isPhone ? 100 : 60),
                                        y: 0,
                                        width: labelView.frame.width - adapt_W(width: isPhone ? 100 : 60),
                                        height: labelView.frame.height)
            let valueLabel = baseVC.labelCreat(frame: infoValueFrame, text: "", aligment: .left, textColor: .colorWithCustom(r: 211, g: 18, b: 0), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 17 : 11))
            valueLabel.tag = rechargeTag.RechargeScanValueLabelTag.rawValue + i - 1
            labelView.addSubview(valueLabel)
            
            //line
            let line = UIView(frame: CGRect(x: 0,
                                            y: labelView.frame.height - adapt_H(height: 1),
                                            width: labelView.frame.width,
                                            height: adapt_H(height: isPhone ? 1 : 0.5)))
            line.backgroundColor = UIColor.colorWithCustom(r: 228, g: 228, b: 228)
            labelView.addSubview(line)
        }
        
        
        for i in 0 ..< 3 {
            let textFrameArray = [CGRect(x: adapt_W(width: 30),
                                         y: adapt_H(height: isPhone ? 190 : 120),
                                         width: adapt_W(width: 250),
                                         height: adapt_H(height: isPhone ? 15 : 15)),
                                  CGRect(x: adapt_W(width: 30),
                                         y: adapt_H(height: isPhone ? 210 : 120 + 15),
                                         width: infoView.frame.width - adapt_W(width: 60),
                                         height: adapt_H(height: isPhone ? 100 : 60)),
                                  CGRect(x: adapt_W(width: 30),
                                         y: adapt_H(height: isPhone ? 300 : 120 + 7 + 60),
                                         width: infoView.frame.width - adapt_W(width: 60),
                                         height: adapt_H(height: isPhone ? 70 : 40))]
            
            let label = baseVC.labelCreat(frame: textFrameArray[i],
                                          text: (isPhone ? methodInfoArray[i][0] : methodInfoArrayPad[i][0]) as! String,
                                          aligment: .left,
                                          textColor: (isPhone ? methodInfoArray[i][2] : methodInfoArrayPad[i][2]) as! UIColor,
                                          backgroundcolor: .clear,
                                          fonsize: (isPhone ? methodInfoArray[i][1] : methodInfoArrayPad[i][1]) as! CGFloat)
            
            infoView.addSubview(label)
            label.numberOfLines = 0 //自动换行
            
            let attributedString:NSMutableAttributedString = NSMutableAttributedString(string:  (isPhone ? methodInfoArray[i][0] : methodInfoArrayPad[i][0]) as! String)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = adapt_H(height: isPhone ? 6 : 4) //修改行间距
            
            attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0,  ((isPhone ? methodInfoArray[i][0] : methodInfoArrayPad[i][0]) as! String).characters.count))
            label.attributedText = attributedString
            
        }
        let confirmFrameY = adapt_H(height: isPhone ? 400 : 280)
        if self.payType == PayType.AliPay || self.payType == PayType.WeChatPay {
            //添加提交按钮
            let confirmFrame = CGRect(x: adapt_W(width: isPhone ? 60 : 50), y: confirmFrameY, width: width - adapt_W(width: isPhone ? 120 : 100), height: adapt_H(height: isPhone ? 40 : 25))
            let confirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "充值确认", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor:.colorWithCustom(r: 186, g: 10, b: 27), fonsize: fontAdapt(font: isPhone ? 17 : 11), events: .touchUpInside)
            self.scroll.addSubview(confirmBtn)
            confirmBtn.layer.cornerRadius = adapt_W(width: isPhone ? 4 : 3)
            confirmBtn.tag = rechargeTag.UnionPayConfirmBtnTag.rawValue
//            confirmBtn.isUserInteractionEnabled = false
            confirmBtn.isHidden = true
        }
        if self.payType == PayType.AliPay || self.payType == PayType.WeChatPay {
            //阿里转账没有二维码  //微信转账也没有二维码了
            return
        }
        
        //微信转账有二维码
        let QRImgWidth = adapt_W(width: isPhone ? 125 : 80)
        let QRImg = UIImageView(frame: CGRect(x: (self.width - QRImgWidth) / 2, y: adapt_H(height: isPhone ? 390 : 300), width: QRImgWidth, height: QRImgWidth))
        QRImg.tag = rechargeTag.RechargeScanQRImgTag.rawValue
        QRImg.image = UIImage(named: self.payType == PayType.WeChatPay ? "wallet_scan_wechatQR.png" : "wallet_scan_aliQR.png")
        self.scroll.addSubview(QRImg)
        
        let saveLabelFrame = CGRect(x: 0, y: adapt_H(height: isPhone ? 570 : 390), width: width, height: adapt_H(height: isPhone ? 60 : 35))
        let saveText = self.payType == PayType.WeChatPay ? "长按保存图片\n将图片保存至手机相册后，打开微信扫一扫\n点击右上角相册选取二维码图片即可添加" : "长按保存图片\n将图片保存至手机相册后，打开支付宝扫一扫\n点击右上角图片选取二维码图片即可添加"
        let saveTextLabel = baseVC.labelCreat(frame: saveLabelFrame, text: saveText, aligment: .center, textColor: .colorWithCustom(r: 129, g: 129, b: 129), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 12 : 8))
        self.scroll.addSubview(saveTextLabel)
        saveTextLabel.numberOfLines = 0
        //修改行间距
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string:  saveText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = adapt_H(height: isPhone ? 3 : 2)//修改行间距
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0,  (saveText).characters.count))
        saveTextLabel.attributedText = attributedString
        saveTextLabel.textAlignment = .center
    }
    
    //添加长按手势
    func addLongPressGestureRecognizer(QRImgView:UIImageView) {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressClick))
        QRImgView.isUserInteractionEnabled = true
        QRImgView.addGestureRecognizer(longPress)
    }
    
    //长按手势事件
    @objc func longPressClick() {
        let alert = UIAlertController(title: "请选择", message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "保存到相册", style: .default) { (alertAction) in
            //按着command键，同是点击UIImageWriteToSavedPhotosAlbum方法可以看到
            let QRImgView = self.viewWithTag(rechargeTag.RechargeScanQRImgTag.rawValue) as! UIImageView
            UIImageWriteToSavedPhotosAlbum(QRImgView.image!, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.rootVC.present(alert, animated: true, completion: nil)
    }
    
    func updatePayInfo(info:Dictionary<String,Any>) -> Void {
        tlPrint(message: "updatePayInfo:\(info)")
        
        var keyArray = ["Rnd","Name","AccountName","Money","Address"]
        switch self.payType.rawValue {
//        case PayType.AliPay.rawValue:
//            tlPrint(message: "支付宝转账支付")
//            keyArray = ["Rnd","Name","AccountName","Money","Address"]
        case PayType.WechaToBank.rawValue:
            tlPrint(message: "微信转银行卡支付")
            keyArray = ["BankAccount","BankCardNum","Money","BankAddr","Rnd"]
        case PayType.UnionPay.rawValue:
            tlPrint(message: "银联转微信支付")
            keyArray = ["BankAccount","BankCardNum","Money","BankAddr","Rnd"]
        default:
            tlPrint(message: "no such case")
        }
        for i in 0 ..< keyArray.count {
            let valueLabel = self.viewWithTag(rechargeTag.RechargeScanValueLabelTag.rawValue + i) as! UILabel
            var infoText = "\(info[keyArray[i]]!)"
            if keyArray[i] == "Rnd" {
                //取附言后6为
                let index = infoText.index(infoText.endIndex, offsetBy: -6)
                infoText = infoText.substring(from: index)
            }
            
            valueLabel.text = infoText
            if self.payType == PayType.UnionPay {
                
                continue
            }
            if self.payType == PayType.WeChatPay {
                tlPrint(message: "微信、支付宝转账不再使用二维码")
//                let QRImg = self.viewWithTag(rechargeTag.RechargeScanQRImgTag.rawValue) as! UIImageView
//                if let QRImgUrl = info["TwoBitCodeLink"] {
//                    QRImg.sd_setImage(with: URL(string: QRImgUrl as! String))
//                    addLongPressGestureRecognizer(QRImgView: QRImg)
//                }
            }
        }
    }
    
    
    //保存二维码  保存到相册
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            let ac = UIAlertController(title: "", message: "保存成功", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "好的", style: .default, handler: nil))
            self.rootVC.present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "保存失败", message: error?.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "好的", style: .default, handler: nil))
            self.rootVC.present(ac, animated: true, completion: nil)
        }
    }
    
    
    @objc func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct:sender.tag = \(sender.tag)")
        self.delegate.btnAct(btnTag: sender.tag)
    }
    
    
}
