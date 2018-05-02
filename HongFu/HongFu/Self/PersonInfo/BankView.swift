//
//  BankView.swift
//  FuTu
//
//  Created by Administrator1 on 19/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

protocol personDelegate {
    func bankBtnAct(btnTag:Int)
    func persongBtnAct(btnTag:Int)
}

class BankView: UIView, UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate {

    var delegate: personDelegate!
    var textFeildDelegate: UITextFieldDelegate!
    var scroll: UIScrollView!
    var width,height: CGFloat!
    let model = PersonModel()
    let baseVC = BaseViewController()
    var pickerConfirmBtn,personBtn,bankBtn: UIButton!
    var backView,alertView,personLine,bankLine: UIView!
    var picker: UIPickerView!
    var dataSource:[[Any]]!
    init(frame:CGRect, param:AnyObject,dataSource:[[Any]]!) {
        super.init(frame: frame)
        tlPrint(message: "您已经进入银行卡界面")
        self.width = frame.width
        self.height = frame.height
        //self.backgroundColor = UIColor.colorWithCustom(r: 227, g: 228, b: 231)
        self.dataSource = dataSource
        tlPrint(message: "datasource:\(self.dataSource)")
        initNavigationBar()
        initScrollView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func initNavigationBar() -> Void {
        tlPrint(message: "initNavigationBar")
        //view
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20 + navBarHeight))
        self.addSubview(navigationView)
        let gradientLayer = CAGradientLayer.GradientLayer(topColor: UIColor.colorWithCustom(r: 65, g: 50, b: 48), buttomColor: UIColor.colorWithCustom(r: 43, g: 38, b: 34))
        gradientLayer.frame = navigationView.frame
        navigationView.layer.insertSublayer(gradientLayer, at: 0)
        //label
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: width, height: navBarHeight))
        setLabelProperty(label: titleLabel, text: "个人资料", aligenment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .clear, font: 17)
        navigationView.addSubview(titleLabel)
        
        
        //back button
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        navigationView.addSubview(backBtn)
        backBtn.tag = personBtnTag.BackButton.rawValue
        //back button image
//        let backBtnImg = UIImageView(frame: CGRect(x: 10 , y:12 , width:12, height:20))
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
        
        
        
        //subTitle
        //person button
        let personFrame = CGRect(x: 0, y: navigationView.frame.height, width: width / 2, height: adapt_H(height: model.subTitleHeight))
        personBtn = baseVC.buttonCreat(frame: personFrame , title: "个人信息", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: model.subTitleBackColor, fonsize: fontAdapt(font: isPhone ? 16 : 10), events: .touchUpInside)
        self.addSubview(personBtn)
        personBtn.tag = personBtnTag.PersonInfoButton.rawValue
        personBtn.setTitleColor(model.subTitleBtnColor1, for: .highlighted)
        personBtn.setTitleColor(model.subTitleBtnColor1, for: .normal)
        //person button blue line
        let lineHeight:CGFloat = isPhone ? 4 : 2
        let lineWidth:CGFloat = isPhone ? 70 : 45
        personLine = UIView(frame: CGRect(x: width / 4 - adapt_W(width: lineWidth / 2), y: adapt_H(height: model.subTitleHeight - lineHeight), width: adapt_W(width: lineWidth), height: adapt_H(height: lineHeight)))
        personBtn.addSubview(personLine)
        personLine.layer.cornerRadius = adapt_W(width: lineHeight / 2)
        personLine.backgroundColor = model.subTitleBackColor
        
        //bank card button
        let bankFrame = CGRect(x: width / 2, y: navigationView.frame.height, width: width / 2, height: adapt_H(height: model.subTitleHeight))
        bankBtn = baseVC.buttonCreat(frame: bankFrame , title: "银行卡", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: model.subTitleBackColor, fonsize: fontAdapt(font: isPhone ? 16 : 10), events: .touchUpInside)
        self.addSubview(bankBtn)
        //bankBtn.tag = personBtnTag.BankCardButton.rawValue
        bankBtn.setTitleColor(model.subTitleBtnColor1, for: .highlighted)
        bankBtn.setTitleColor(model.subTitleBtnColor2, for: .normal)
        
        //person button blue line
        bankLine = UIView(frame: CGRect(x: width / 4 - adapt_W(width: lineWidth / 2), y: adapt_H(height: model.subTitleHeight - lineHeight), width: adapt_W(width: lineWidth), height: adapt_H(height: lineHeight)))
        bankBtn.addSubview(bankLine)
        bankLine.layer.cornerRadius = adapt_W(width: lineHeight / 2)
        bankLine.backgroundColor = model.subTitleBtnColor2
        
    }

    
    func initScrollView() -> Void {
        tlPrint(message: "initScrollView")
        if scroll != nil {
            scroll.removeFromSuperview()
            scroll = nil
        }
        
        scroll = UIScrollView(frame: CGRect(x: 0, y: 20 + navBarHeight + adapt_H(height: model.subTitleHeight), width: width, height: height - 20 - navBarHeight - adapt_H(height: model.subTitleHeight)))
        self.addSubview(scroll)
        let scrollHeight = CGFloat(self.dataSource.count) * adapt_H(height: model.bankInterval + model.bankHeight) + adapt_H(height: model.bankInterval) + adapt_H(height: 60)
        let scrollContentHeight = self.dataSource.count >= 1 ? scrollHeight : (scroll.frame.height + 1)
        scroll.contentSize = CGSize(width: frame.width, height: scrollContentHeight)
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.backgroundColor = UIColor.colorWithCustom(r: 224, g: 224, b: 224)
        self.addSubview(scroll)
        
//        let bankCount = self.dataSource.count
        for i in 0 ..< self.dataSource.count  {
            tlPrint(message: "self.datasource.count\(i):\(self.dataSource.count)")
            let bankFrame = CGRect(x: adapt_W(width: 5), y: CGFloat(i) * adapt_H(height: model.bankInterval + model.bankHeight) + adapt_H(height: model.bankInterval), width: width - adapt_W(width: 10), height: adapt_H(height: model.bankHeight))
            
            let bankView = UIImageView(frame: bankFrame)
            scroll.addSubview(bankView)
            //Tag
            bankView.tag = personBtnTag.BankBaseTag.rawValue + i
            bankView.isUserInteractionEnabled = true
            let imgName = (self.dataSource[i][1] as! String).replacingOccurrences(of: " ", with: "")
            bankView.image = UIImage(named: isPhone ? "person_bank-\(imgName).png" : "person_bank-\(imgName)_iPad.png")
            bankView.layer.shadowColor = UIColor.black.cgColor
            bankView.layer.shadowOffset = CGSize(width: 0, height: adapt_W(width: isPhone ? 4 : 3))
            bankView.layer.shadowOpacity = 0.3
            
            //bank name label
            let bankName = UILabel(frame: CGRect(x: adapt_W(width: 105), y: adapt_H(height: 18), width: adapt_W(width: 150), height: adapt_H(height: 22)))
            bankView.addSubview(bankName)
            setLabelProperty(label: bankName, text: self.dataSource[i][0] as! String, aligenment: .left, textColor: .white, backColor: .clear, font: fontAdapt(font: isPhone ? 17 : 11))
            //bank card number
            let bankNumber = UILabel(frame: CGRect(x: bankName.frame.origin.x, y: adapt_H(height: 50), width: adapt_W(width: 250), height: adapt_H(height: isPhone ? 16 : 13)))
            bankView.addSubview(bankNumber)
            let carNum = self.dataSource[i][2] as! String
            //银行卡如果小于4位数，则前后只显示2位数字
            var displayNum = 4
            if carNum.characters.count < 4 {
                displayNum = 2
            }
            var showNum = carNum.substring(to: carNum.index(carNum.startIndex, offsetBy: displayNum))
            showNum.append(displayNum > 2 ? " **** **** " : "****** ******")
            //测试信息没有那么多位数
//            showNum.append(carNum.substring(from: carNum.index(carNum.startIndex, offsetBy: 12)))
            showNum.append(carNum.substring(from: carNum.index(carNum.endIndex, offsetBy: -displayNum)))
            setLabelProperty(label: bankNumber, text: showNum, aligenment: .left, textColor: .white, backColor: .clear, font: fontAdapt(font: isPhone ? 20 : 13))
            
            //bank name label
            let realName = UILabel(frame: CGRect(x: adapt_W(width: 105), y: adapt_H(height: 78), width: adapt_W(width: 150), height: adapt_H(height: 22)))
            bankView.addSubview(realName)
            setLabelProperty(label: realName, text: self.dataSource[i][5] as! String, aligenment: .left, textColor: .white, backColor: .clear, font: fontAdapt(font: isPhone ? 17 : 11))
            
            
            
            //default flag
            let defaultFlag = UIImageView()
            bankView.addSubview(defaultFlag)
            defaultFlag.tag = personBtnTag.BankDefaultTag.rawValue + i
            defaultFlag.mas_makeConstraints({ (make) in
                _ = make?.top.equalTo()
                _ = make?.right.equalTo()
                _ = make?.height.equalTo()(adapt_W(width: isPhone ? 35 : 25))
                _ = make?.width.equalTo()(adapt_W(width: isPhone ? 35 : 25))
            })
            defaultFlag.image = UIImage(named: "person_bank_default.png")
            defaultFlag.isHidden = true
            if self.dataSource[i][3] as! Bool{
                defaultFlag.isHidden = false
            }
            //set button
            let setFrame = CGRect(x: adapt_W(width: isPhone ? 212 : 250), y: adapt_H(height: isPhone ? 80 : 45), width: adapt_W(width: isPhone ? 70 : 48), height: adapt_H(height: isPhone ? 25 : 18))
            let setBtn = baseVC.buttonCreat(frame: setFrame, title: "设为默认", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 12 : 9), events: .touchUpInside)
            bankView.addSubview(setBtn)
            if self.dataSource[i][3] as! Bool == true {
                setBtn.setTitle("默认卡片", for: .normal)
            }
            setBtn.setTitleColor(UIColor.white, for: .normal)
            setBtn.setTitleColor(UIColor.gray, for: .highlighted)
            setBtn.tag = personBtnTag.BankCardBtnTag.rawValue + i * 2
            
            
            //delete button
            let deleteFrame = CGRect(x: adapt_W(width: isPhone ? 284 : 298), y: adapt_H(height: isPhone ? 80 : 45), width: setFrame.width, height: setFrame.height)
            let deleteBtn = baseVC.buttonCreat(frame: deleteFrame, title: "删除卡片", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 12 : 9), events: .touchUpInside)
            bankView.addSubview(deleteBtn)
            deleteBtn.setTitleColor(UIColor.white, for: .normal)
            deleteBtn.setTitleColor(UIColor.gray, for: .highlighted)
            deleteBtn.tag = personBtnTag.BankCardBtnTag.rawValue + i * 2 + 1
            //background image
            let backImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 212 : 250), y: adapt_H(height: isPhone ? 80 : 45), width: setFrame.width * 2, height: setFrame.height))
            backImg.image = UIImage(named: "person_bank_btnBg.png")
            bankView.insertSubview(backImg, belowSubview: setBtn)
        }
        let addBtn = UIButton(type: .contactAdd)
        addBtn.frame = CGRect(x: adapt_W(width: isPhone ? 37 : 50), y: height - adapt_H(height: isPhone ? 45 + 17 : 25 + 12), width: width - adapt_W(width: isPhone ? 74 : 100), height: adapt_H(height: isPhone ? 45 : 25))
        addBtn.setTitle(" 添加银行卡", for: .normal)
        addBtn.setTitleColor(UIColor.white, for: .normal)
        addBtn.titleLabel?.font = UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 20 : 11))
        addBtn.backgroundColor = UIColor.colorWithCustom(r: 186, g: 9, b: 31)
        addBtn.tintColor = UIColor.white
        addBtn.addTarget(self, action: #selector(self.btnAct(sender:)), for: .touchUpInside)
        self.insertSubview(addBtn, aboveSubview: scroll)
        addBtn.tag = personBtnTag.addButton.rawValue
        addBtn.layer.cornerRadius = addBtn.frame.height / 2
        addBtn.layer.shadowColor = UIColor.black.cgColor
        addBtn.layer.shadowOffset = CGSize(width: 0, height: adapt_H(height: 3))
        addBtn.layer.shadowOpacity = 0.3
        
    }

    var currentCarNumber:Int!
    func bankCardBtnAct(sender: Int) -> Void {
        tlPrint(message: "bankCardBtnAct")
        let cardNumber = (sender - personBtnTag.BankCardBtnTag.rawValue) / 2
        self.currentCarNumber = cardNumber
        let subTag = (sender - personBtnTag.BankCardBtnTag.rawValue) % 2
        tlPrint(message: "cardNumber: \(cardNumber)  subTag: \(subTag)")
        if subTag == 0 {
            tlPrint(message: "设为默认按钮")
//            if cardNumber <= 0 {
//                tlPrint(message: "当前已经是默认值了")
//                return
//            }
            //let infoKeys = ["BankName","BankCode","CardNo","IsDefault","BankAddress","CardOwnerName","Id"]
            let data = self.dataSource[cardNumber]
            let param = ["Id":data[6],"BankName":data[0],"CardOwnerName":data[5],"CardNo":data[2],"BankAddress":data[4],"BankCode":data[1],"IsDefault":[3]]
            futuNetworkRequest(type: .post, serializer: .http, url: "UserBankInfo/SetDefault", params: param, success: { (response) in
                tlPrint(message: "response = \(response)")
                let string = String(data: response as! Data, encoding: String.Encoding.utf8)!
                tlPrint(message: "string:\(string)")
                
                self.setDefaultBankAnimate(sender: sender)
                
            }, failure: { (error) in
                tlPrint(message: "response = \(error)")
            })
            
            
//            UIView.animate(withDuration: 1, animations: {
//                //已经选择的卡片移到第一个位置
//                let selectedBankCard = self.viewWithTag(personBtnTag.BankBaseTag.rawValue + cardNumber) as! UIImageView
//                
//                let selectedOriginFrame = selectedBankCard.frame
//                selectedBankCard.frame = CGRect(x: selectedOriginFrame.origin.x, y: adapt_W(width: self.model.bankInterval), width: selectedOriginFrame.width, height: selectedOriginFrame.height)
//                
//                let selectedDefaultBtn = self.viewWithTag(sender) as! UIButton
//                selectedDefaultBtn.setTitle("默认卡片", for: .normal)
//                let selectedDeleteBtn = self.viewWithTag(sender + 1) as! UIButton
//                let selectedDefaultFlag = self.viewWithTag(personBtnTag.BankDefaultTag.rawValue + cardNumber) as! UIImageView
//                
//                
//                //选择卡片纸上的卡片依次下移
//                for i in 0 ... cardNumber - 1 {
//                    let nextCardTag = personBtnTag.BankBaseTag.rawValue + cardNumber - i - 1
//                    tlPrint(message: "i: \(i)  tag: \(nextCardTag)")
//                    let nextBankCard = self.viewWithTag(nextCardTag) as! UIImageView
//                    let nextOriginFrame = nextBankCard.frame
//                    nextBankCard.frame = CGRect(x: nextOriginFrame.origin.x, y: nextOriginFrame.origin.y + adapt_H(height: self.model.bankHeight + self.model.bankInterval), width: nextOriginFrame.width, height: nextOriginFrame.height)
//                    //修改卡片tag
//                    nextBankCard.tag += 1
//                    tlPrint(message: "第\(i)张卡片移到\(nextBankCard.tag - personBtnTag.BankBaseTag.rawValue)号位置")
//                    //修改默认按钮tag
//                    let nextDefaultBtn = self.viewWithTag(personBtnTag.BankCardBtnTag.rawValue + 2 * (cardNumber - i - 1)) as! UIButton
//                    
//                    nextDefaultBtn.tag += 2
//                    //修改删除卡片按钮tag
//                    let nextDeleteBtn = self.viewWithTag(personBtnTag.BankCardBtnTag.rawValue + 2 * (cardNumber - i - 1) + 1) as! UIButton
//                    nextDeleteBtn.tag += 2
//                    
//                    //默认标识
//                    let defaultFlag = self.viewWithTag(personBtnTag.BankDefaultTag.rawValue + cardNumber - i - 1) as! UIImageView
//                    defaultFlag.tag += 1
//                    
//                    
//                    if i == cardNumber - 1 {
//                        nextDefaultBtn.setTitle("设为默认", for: .normal)
//                        defaultFlag.isHidden = true
//                    }
//                }
//                
//                //处理完毕以后修改选择卡片的tag
//                selectedBankCard.tag = personBtnTag.BankBaseTag.rawValue
//                //修改默认按钮tag
//                selectedDefaultBtn.tag = personBtnTag.BankCardBtnTag.rawValue
//                //修改删除卡片按钮tag
//                selectedDeleteBtn.tag = personBtnTag.BankCardBtnTag.rawValue + 1
//                //添加默认标识
//                selectedDefaultFlag.tag = personBtnTag.BankDefaultTag.rawValue
//                selectedDefaultFlag.isHidden = false
//                
//            })
            
        } else if subTag == 1 {
            if cardNumber == 0 {
                let alert = UIAlertView(title: "删除失败", message: "默认银行卡不允许删除", delegate: self, cancelButtonTitle: "确定")
                DispatchQueue.main.async {
                    alert.show()
                }
                return
            }
            let alert = UIAlertView(title: "提醒", message: "确定要删除该银行信息吗？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alert.tag = personBtnTag.BankDeleteAlert.rawValue
            DispatchQueue.main.async {
                alert.show()
            }
            
//            tlPrint(message: "删除卡片按钮")
//            var selectedBankCard : UIImageView!
//            UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
//                tlPrint(message: "左侧滑动删除选中卡片")
//                selectedBankCard = self.viewWithTag(personBtnTag.BankBaseTag.rawValue + cardNumber) as! UIImageView
//                
//                let selectedOriginFrame = selectedBankCard.frame
//                tlPrint(message: "deleted frame before: \(selectedBankCard.frame)")
//                selectedBankCard.frame = CGRect(x: -selectedOriginFrame.width, y: selectedOriginFrame.origin.y, width: selectedOriginFrame.width, height: selectedOriginFrame.height)
//                tlPrint(message: "deleted frame after: \(selectedBankCard.frame)")
//                /*
//                 此处需要修改dataSource,去掉删除掉的数据，其他数据前移
//                 */
//            }, completion: { (finished) in
//                tlPrint(message: "finished")
//                selectedBankCard.removeFromSuperview()
//                
//                UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
//                    tlPrint(message: "选中页面之下的页面上移")
//                    if cardNumber >= self.model.dataSource.count - 1 {
//                        tlPrint(message: "删除的是最后一个，不再上移卡片")
//                        return
//                    }
//                    
//                    for i in 0 ... (self.model.dataSource.count - cardNumber - 2) {
//                        tlPrint(message: "i = \(i)")
//                        
//                        let nextBankCard = self.viewWithTag(personBtnTag.BankBaseTag.rawValue + cardNumber + i + 1) as! UIImageView
//                        let originFrame = nextBankCard.frame
//                        tlPrint(message: "originFrame: \(originFrame)")
//                        nextBankCard.frame = CGRect(x: originFrame.origin.x , y: originFrame.origin.y - adapt_H(height: self.model.bankHeight + self.model.bankInterval), width: originFrame.width, height: originFrame.height)
//                        tlPrint(message: "currentFrame: \(nextBankCard.frame)")
//                        tlPrint(message: "tag before: \(nextBankCard.tag)")
//                        nextBankCard.tag -= 1
//                        tlPrint(message: "tag after: \(nextBankCard.tag)")
//                        
//                        //修改默认按钮tag
//                        let nextDefaultTag = personBtnTag.BankCardBtnTag.rawValue + 2 * (cardNumber + i + 1)
//                        let nextDefaultBtn = self.viewWithTag(nextDefaultTag) as! UIButton
//                        nextDefaultBtn.tag -= 2
//                        
//                        //修改删除卡片按钮tag
//                        //let nextDeleteTag = personBtnTag.BankCardBtnTag.rawValue + 2 * (self.model.dataSource.count - cardNumber + i - 1) - 1
//                        tlPrint(message: "nextDefaultTag = \(nextDefaultTag)")
//                        
//                        let nextDeleteBtn = self.viewWithTag(nextDefaultTag + 1) as! UIButton
//                        nextDeleteBtn.tag -= 2
//                        
//                        //默认标识
//                        let flagTag = personBtnTag.BankDefaultTag.rawValue + cardNumber + i + 1
//                        let defaultFlag = self.viewWithTag(flagTag) as! UIImageView
//                        defaultFlag.tag -= 1
//                        
//                        
//                    }
//                }, completion: { (finished) in
//                    tlPrint(message: "dataSource before: \(self.model.dataSource)")
//                    self.model.dataSource.remove(at: cardNumber)
//                    tlPrint(message: "dataSource after: \(self.model.dataSource)")
//                })
//            })
        }
    }
    
    
    func bankBackHideView() -> UIView {
        tlPrint(message: "bankBackHideView")
        backView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        backView.backgroundColor = UIColor.black
        backView.alpha = 0.5
        return backView
    }
    func setDefaultBankAnimate(sender:Int) -> Void {
        
        
        let cardNumber = (sender - personBtnTag.BankCardBtnTag.rawValue) / 2
        UIView.animate(withDuration: 1, animations: {
            //已经选择的卡片移到第一个位置
            let selectedBankCard = self.viewWithTag(personBtnTag.BankBaseTag.rawValue + cardNumber) as! UIImageView
            
            let selectedOriginFrame = selectedBankCard.frame
            selectedBankCard.frame = CGRect(x: selectedOriginFrame.origin.x, y: adapt_W(width: self.model.bankInterval), width: selectedOriginFrame.width, height: selectedOriginFrame.height)
            
            let selectedDefaultBtn = self.viewWithTag(sender) as! UIButton
            selectedDefaultBtn.setTitle("默认卡片", for: .normal)
            let selectedDeleteBtn = self.viewWithTag(sender + 1) as! UIButton
            let selectedDefaultFlag = self.viewWithTag(personBtnTag.BankDefaultTag.rawValue + cardNumber) as! UIImageView
            
            if cardNumber <= 0 {
                return
            }
            //选择卡片纸上的卡片依次下移
            for i in 0 ... cardNumber - 1 {
                let nextCardTag = personBtnTag.BankBaseTag.rawValue + cardNumber - i - 1
                tlPrint(message: "i: \(i)  tag: \(nextCardTag)")
                let nextBankCard = self.viewWithTag(nextCardTag) as! UIImageView
                let nextOriginFrame = nextBankCard.frame
                nextBankCard.frame = CGRect(x: nextOriginFrame.origin.x, y: nextOriginFrame.origin.y + adapt_H(height: self.model.bankHeight + self.model.bankInterval), width: nextOriginFrame.width, height: nextOriginFrame.height)
                //修改卡片tag
                nextBankCard.tag += 1
                tlPrint(message: "第\(i)张卡片移到\(nextBankCard.tag - personBtnTag.BankBaseTag.rawValue)号位置")
                //修改默认按钮tag
                let nextDefaultBtn = self.viewWithTag(personBtnTag.BankCardBtnTag.rawValue + 2 * (cardNumber - i - 1)) as! UIButton
                
                nextDefaultBtn.tag += 2
                //修改删除卡片按钮tag
                let nextDeleteBtn = self.viewWithTag(personBtnTag.BankCardBtnTag.rawValue + 2 * (cardNumber - i - 1) + 1) as! UIButton
                nextDeleteBtn.tag += 2
                
                //默认标识
                let defaultFlag = self.viewWithTag(personBtnTag.BankDefaultTag.rawValue + cardNumber - i - 1) as! UIImageView
                defaultFlag.tag += 1
                
                
                if i == cardNumber - 1 {
                    nextDefaultBtn.setTitle("设为默认", for: .normal)
                    defaultFlag.isHidden = true
                }
            }
            
            //处理完毕以后修改选择卡片的tag
            selectedBankCard.tag = personBtnTag.BankBaseTag.rawValue
            //修改默认按钮tag
            selectedDefaultBtn.tag = personBtnTag.BankCardBtnTag.rawValue
            //修改删除卡片按钮tag
            selectedDeleteBtn.tag = personBtnTag.BankCardBtnTag.rawValue + 1
            //添加默认标识
            selectedDefaultFlag.tag = personBtnTag.BankDefaultTag.rawValue
            selectedDefaultFlag.isHidden = false
            
        })
    }
    
    
    //绑定银行卡信息弹窗视图
    func addBankAlertView() -> UIView {
        tlPrint(message: "addBankAlertView")
        alertView = UIView(frame: CGRect(x: adapt_W(width: isPhone ? 20 : 50), y: adapt_H(height: 80), width: width - adapt_W(width: isPhone ? 40 : 100), height: adapt_H(height: isPhone ? 330 : 240)))
        alertView.backgroundColor = UIColor.colorWithCustom(r: 244, g: 244, b: 244)
        alertView.layer.cornerRadius = adapt_W(width: 10)
        alertView.clipsToBounds = true
        //title text
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: alertView.frame.width, height: alertView.frame.height / 6))
        alertView.addSubview(titleLabel)
        
        setLabelProperty(label: titleLabel, text: "绑定银行卡", aligenment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .white, font: fontAdapt(font: isPhone ? 17 : 12))
        //close button
        let closeFrame = CGRect(x: alertView.frame.width - adapt_W(width: isPhone ? 40 : 30), y: (alertView.frame.height / 6 - adapt_W(width: isPhone ? 30 : 20)) / 2, width: adapt_W(width: isPhone ? 30 : 20 ), height: adapt_W(width: isPhone ? 30 : 20))
    
        let closeBtn = baseVC.buttonCreat(frame: closeFrame, title: "", alignment: .center, target: self, myaction: #selector(self.alertBtnAct(sender:)), normalImage: UIImage(named:"self_title_remind.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        alertView.addSubview(closeBtn)
//        closeBtn.backgroundColor = UIColor.green
        closeBtn.setImage(UIImage(named:"person_piker_close.png"), for: .normal)
        closeBtn.tag = personBtnTag.BankAlertCloseBtnTag.rawValue
        let describeLabelName = ["开户银行","开户姓名","银行账号","开户地址"]
        let textFeildPlaceholder = ["选择开户银行","输入您的姓名","输入您的卡号","输入您的开户地址"]
        for i in 0 ... 3 {
        
            let line = UIView(frame:CGRect(x: 0, y: (alertView.frame.height / 6) * CGFloat(i + 1), width: alertView.frame.width, height: 0.5))
            line.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            alertView.addSubview(line)
            //label
            let describeLabel = UILabel(frame: CGRect(x: adapt_W(width: isPhone ? 23 : 15), y: (alertView.frame.height / 6) * CGFloat(i + 1), width: adapt_W(width: isPhone ? 65 : 50), height: alertView.frame.height / 6))
            alertView.addSubview(describeLabel)
            setLabelProperty(label: describeLabel, text: describeLabelName[i], aligenment: .center, textColor: .colorWithCustom(r: 81, g: 81, b: 81), backColor: .clear, font: fontAdapt(font: isPhone ? 15 : 10))
            if i == 0 {
                //bank name
                let bankName = UILabel(frame: CGRect(x: adapt_W(width: isPhone ? 100 : 70), y: alertView.frame.height / 6, width: adapt_W(width: isPhone ? 220 : 210), height: alertView.frame.height / 6))
                alertView.addSubview(bankName)
                bankName.tag = personBtnTag.BankAlertTextFieldTag.rawValue + i
                bankName.isUserInteractionEnabled = false
                setLabelProperty(label: bankName, text: "选择开户银行", aligenment: .left, textColor: .colorWithCustom(r: 193, g: 193, b: 193), backColor: .clear, font: fontAdapt(font: isPhone ? 15 : 10))
                //selection button(pull down)
//                let selectFrame = CGRect(x: adapt_W(width: 80), y: adapt_H(height: describeLabel.frame.height), width: adapt_W(width: isPhone ? 250 :160), height: describeLabel.frame.height)
                let selectFrame = CGRect(x: adapt_W(width: isPhone ? 80 : 60), y: adapt_H(height: isPhone ? 55 : 40), width: adapt_W(width: isPhone ? 250 :200), height: describeLabel.frame.height)
                let selectBtn = baseVC.buttonCreat(frame: selectFrame, title: "", alignment: .center, target: self, myaction: #selector(self.alertBtnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
                alertView.addSubview(selectBtn)
//                selectBtn.backgroundColor = UIColor.yellow
                selectBtn.tag = personBtnTag.BankAlertSelectBtnTag.rawValue
                //pull down button image
                let selectBtnImg = UIImageView(frame: CGRect(x: selectFrame.width - adapt_W(width: isPhone ? 43 : 32), y: adapt_H(height: isPhone ? 15 : 10), width: adapt_W(width: isPhone ? 43 : 32), height: adapt_H(height: isPhone ? 30 : 20)))
                selectBtnImg.image = UIImage(named: "person_alert_pulldown.png")
                selectBtn.addSubview(selectBtnImg)
                
            } else {
                //textField
                let textFeildFrame = CGRect(x: adapt_W(width: isPhone ? 100 : 70), y: describeLabel.frame.origin.y, width: adapt_W(width: isPhone ? 220 : 210), height: describeLabel.frame.height)
                let textFeild = baseVC.textFieldCreat(frame: textFeildFrame, placeholderText: textFeildPlaceholder[i], aligment: .left, fonsize: fontAdapt(font: isPhone ? 17 : 12), borderWidth: 0, borderColor: .clear, tag: personBtnTag.BankAlertTextFieldTag.rawValue + i)
                if i == 1 {
                    let realName = userDefaults.value(forKey: userDefaultsKeys.userInfoRealName.rawValue) as! String
                    textFeild.text = realName
                }
                if i == 2 {
                    textFeild.keyboardType = .phonePad
                }
                alertView.addSubview(textFeild)
                textFeild.tag = personBtnTag.BankAlertTextFieldTag.rawValue + i
                tlPrint(message: "textfield tag = \(textFeild.tag)")
                textFeild.delegate = textFeildDelegate
                
                //添加右侧视图:红色错误提示文字
                let alertLabel = UILabel()
                alertLabel.frame = CGRect(x: textFeildFrame.width - adapt_W(width: isPhone ? 80 : 120), y: 0, width: adapt_W(width: isPhone ? 90 : 60), height: adapt_H(height: 20))
                setLabelProperty(label: alertLabel, text: self.model.alertLabelText[i], aligenment: .right, textColor: .red, backColor: .clear, font: fontAdapt(font: isPhone ? 12 : 8))
                alertLabel.tag = personBtnTag.infoAlertLabelTag.rawValue + i
                tlPrint(message: "alertLabel[\(i)].tag = \(alertLabel.tag)")
                textFeild.rightView = alertLabel
                textFeild.rightViewMode = .always
                alertLabel.isHidden = true
            }
        }
        
        //confirm button
        let confirmFrame = CGRect(x: 0, y: alertView.frame.height / 6 * 5, width: alertView.frame.width, height: alertView.frame.height / 6)
        let confirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "确 定", alignment: .center, target: self, myaction: #selector(self.alertBtnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 186, g: 10, b: 27), fonsize: fontAdapt(font: 20), events: .touchUpInside)
        alertView.addSubview(confirmBtn)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.tag = personBtnTag.BankAlertConfirmBtnTag.rawValue
        return alertView
    }
    
    func initUIPickerView() -> UIPickerView {
        tlPrint(message: "initUIPickerView")
        if picker != nil {
            picker.isHidden = false
            if pickerConfirmBtn != nil {
                pickerConfirmBtn.isHidden = false
            }
            return picker
        }
        picker = UIPickerView(frame: CGRect(x: 0, y: alertView.frame.height / 6, width: alertView.frame.width, height: alertView.frame.height / 6 * 4))
        picker.backgroundColor = UIColor(white: 1, alpha: 0.8)
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(6, inComponent: 0, animated: true)
        let confirmFrame = CGRect(x: 0, y: alertView.frame.height / 6 * 5, width: alertView.frame.width, height: alertView.frame.height / 6)
        pickerConfirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "选 择", alignment: .center, target: self, myaction: #selector(self.alertBtnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 27, g: 123, b: 233), fonsize: fontAdapt(font: isPhone ? 20 : 13), events: .touchUpInside)
        pickerConfirmBtn.setTitleColor(UIColor.white, for: .normal)
        pickerConfirmBtn.tag = personBtnTag.BankAlertPickerConfirmBtnTag.rawValue
        alertView.insertSubview(pickerConfirmBtn, aboveSubview: picker)
        return picker
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return model.bankName.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return model.bankName[row]
    }
    
    
    @objc func alertBtnAct(sender:UIButton) -> Void {
        tlPrint(message: "alertBtnAct")
        switch sender.tag {
        case personBtnTag.BankAlertCloseBtnTag.rawValue:
            tlPrint(message: "关闭")
            bankAlertClose()
        case personBtnTag.BankAlertSelectBtnTag.rawValue:
            tlPrint(message: "下拉选择开户银行")
            alertView.addSubview(initUIPickerView())
            
        case personBtnTag.BankAlertConfirmBtnTag.rawValue:
            tlPrint(message: "确认按钮")
            confirmInfoBtnAct()
        case personBtnTag.BankAlertPickerConfirmBtnTag.rawValue:
            tlPrint(message: "选中了银行")
            modefyBankNameLabel(btnTag: sender.tag)
            
        default:
            tlPrint(message: "no such case")
        }
    }
    
    //关闭弹窗以后的处理函数
    func bankAlertClose() -> Void {
        tlPrint(message: "bankAlertClose")
        if backView != nil {
            backView.isHidden = true
        }
        if alertView != nil {
            alertView.isHidden = true
        }
        for i in 1 ... 3 {
            tlPrint(message: "选择的tag: \(personBtnTag.BankAlertTextFieldTag.rawValue + i)")
            let textFeild = self.alertView.viewWithTag(personBtnTag.BankAlertTextFieldTag.rawValue + i) as! UITextField
            textFeild.resignFirstResponder()
        }
        alertView.center = self.center
        
    }
    
    //选中了银行以后的处理函数
    func modefyBankNameLabel(btnTag:Int) -> Void {
        tlPrint(message: "modefyBankNameLabel")
        let selectedBankName = model.bankName[picker.selectedRow(inComponent: 0)]
        tlPrint(message: "selected bank name is \(selectedBankName)")
        let bankNameLabel = self.alertView.viewWithTag(personBtnTag.BankAlertTextFieldTag.rawValue) as! UILabel
        bankNameLabel.text = selectedBankName
        bankNameLabel.textColor = UIColor.colorWithCustom(r: 35, g: 35, b: 35)
        
        
        if picker != nil {
            picker.isHidden = true
        }
        
        if pickerConfirmBtn != nil {
            pickerConfirmBtn.isHidden = true
        }
    }
    
    func confirmInfoBtnAct() -> Void {
        tlPrint(message: "confirmInfoBtnAct")
        var isInfoError = false
        var index = 0
        let bankNameLabel = alertView.viewWithTag(personBtnTag.BankAlertTextFieldTag.rawValue) as! UILabel
        if bankNameLabel.text == "选择开户银行" || bankNameLabel.text == "" {
            //bankNameLabel.textColor = UIColor.red
            return
        }
        
        let bankAddrFeild = alertView.viewWithTag(personBtnTag.BankAlertTextFieldTag.rawValue + 3) as! UITextField
        if bankAddrFeild.text == nil {
            isInfoError = true
            index = 3
            //            return
        } else if bankAddrFeild.text!.characters.count < 5 {
            //bankAddr.textColor = UIColor.red
            tlPrint(message: "开度地址长度不对")
            isInfoError = true
            index = 3
        }
        
        let bankNumberFeild = alertView.viewWithTag(personBtnTag.BankAlertTextFieldTag.rawValue + 2) as! UITextField
        if bankNumberFeild.text == nil {
            isInfoError = true
            index = 2
//            return
        } else if bankNumberFeild.text!.characters.count < 8 || bankNumberFeild.text!.characters.count > 22 {
            tlPrint(message: "银行卡号码长度不对")
            isInfoError = true
            index = 2
//            return
        }
        

        let ownerNameFeild = alertView.viewWithTag(personBtnTag.BankAlertTextFieldTag.rawValue + 1) as! UITextField
        tlPrint(message: "ownerNameFeild.text = \(String(describing: ownerNameFeild.text))")
        if ownerNameFeild.text == nil {
            isInfoError = true
            index = 1
//            return
        } else if ownerNameFeild.text!.characters.count < 2 {
            //ownerName.textColor = UIColor.red
            tlPrint(message: "开户名长度不对")
            isInfoError = true
            index = 1
            //            return
        }
        
        if isInfoError {
            let alertLabel = self.alertView.viewWithTag(personBtnTag.infoAlertLabelTag.rawValue + index) as! UILabel
            alertLabel.text = self.model.alertLabelText[index]
            alertLabel.isHidden = false
            SystemTool.systemVibration(loopTimes: 1, intervalTime: 0)
            return
        }
        
        let bankName = bankNameLabel.text
        let ownerName = ownerNameFeild.text
        let bankNumber = bankNumberFeild.text
        let bankAddr = bankAddrFeild.text
        tlPrint(message: "bankName: \(String(describing: bankName)),  ownerName: \(String(describing: ownerName)),  bankNumber: \(String(describing: bankNumber)),  bankAddr: \(String(describing: bankAddr))")
        
        let confirmBtn = self.alertView.viewWithTag(personBtnTag.BankAlertConfirmBtnTag.rawValue) as! UIButton
        confirmBtn.isUserInteractionEnabled = false
        
        /*
         拿到数据和后台对接
         */
        let bankCode = (self.model.bankInfo as AnyObject).value(forKey: bankName!) as! String
        let param = ["Id":0, "BankName":bankCode, "CardOwnerName":ownerName!, "CardNo":bankNumber!, "BankAddress":bankAddr!,"IsDefault":true,"BankCode":bankCode] as [String : Any]
        futuNetworkRequest(type: .post, serializer: .http, url: "UserBankInfo/PostUserBankInfo", params: param, success: { (response) in
            tlPrint(message: "response:\(response)")
            let string = String(data: response as! Data, encoding: String.Encoding.utf8)!
            tlPrint(message: "string:\(string)")
            
            self.model.getBankInfo(success: { (datasource) in
                tlPrint(message: "bankView.dataSource:\(datasource)")
                self.dataSource = datasource
                let notify = NSNotification.Name(rawValue: notificationName.BankInfoRefresh.rawValue)
                NotificationCenter.default.post(name: notify, object: datasource)
                self.bankAlertClose()
                confirmBtn.isUserInteractionEnabled = true
            })
            
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
            confirmBtn.isUserInteractionEnabled = true
        })
        
    }
    
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        tlPrint(message: "alertView")
        if alertView.tag == personBtnTag.BankDeleteAlert.rawValue {
            if buttonIndex == 0 {
                tlPrint(message: "取消")
                return
            } else {
                tlPrint(message: "确认")
                let data = self.dataSource[self.currentCarNumber]
                let param = ["Id":data[6], "BankName":data[0], "CardOwnerName":data[5], "CardNo":data[2], "BankAddress":data[4], "BankCode":data[1], "IsDefault":[3]]
                futuNetworkRequest(type: .post, serializer: .http, url: "UserBankInfo/MarkDelete", params: param, success: { (response) in
                    tlPrint(message: "response:\(response)")
                    let string = String(data: response as! Data, encoding: String.Encoding.utf8)!
                    tlPrint(message: "string:\(string)")
                    self.deleteBankCard()
                }, failure: { (error) in
                    tlPrint(message: "error:\(error)")
                })
            }
        }
    }
    
    
    func deleteBankCard() -> Void {
        tlPrint(message: "删除卡片按钮")
        var selectedBankCard : UIImageView!
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
            tlPrint(message: "左侧滑动删除选中卡片")
            selectedBankCard = self.viewWithTag(personBtnTag.BankBaseTag.rawValue + self.currentCarNumber) as! UIImageView
            
            let selectedOriginFrame = selectedBankCard.frame
            tlPrint(message: "deleted frame before: \(selectedBankCard.frame)")
            selectedBankCard.frame = CGRect(x: -selectedOriginFrame.width, y: selectedOriginFrame.origin.y, width: selectedOriginFrame.width, height: selectedOriginFrame.height)
            tlPrint(message: "deleted frame after: \(selectedBankCard.frame)")
            /*
             此处需要修改dataSource,去掉删除掉的数据，其他数据前移
             */
        }, completion: { (finished) in
            tlPrint(message: "finished")
            selectedBankCard.removeFromSuperview()
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
                tlPrint(message: "选中页面之下的页面上移")
                if self.currentCarNumber >= self.dataSource.count - 1 {
                    tlPrint(message: "删除的是最后一个，不再上移卡片")
                    return
                }
                
                for i in 0 ... (self.dataSource.count - self.currentCarNumber
                    - 2) {
                    tlPrint(message: "i = \(i)")
                    
                    let nextBankCard = self.viewWithTag(personBtnTag.BankBaseTag.rawValue + self.currentCarNumber + i + 1) as! UIImageView
                    let originFrame = nextBankCard.frame
                    tlPrint(message: "originFrame: \(originFrame)")
                    nextBankCard.frame = CGRect(x: originFrame.origin.x , y: originFrame.origin.y - adapt_H(height: self.model.bankHeight + self.model.bankInterval), width: originFrame.width, height: originFrame.height)
                    tlPrint(message: "currentFrame: \(nextBankCard.frame)")
                    tlPrint(message: "tag before: \(nextBankCard.tag)")
                    nextBankCard.tag -= 1
                    tlPrint(message: "tag after: \(nextBankCard.tag)")
                    
                    //修改默认按钮tag
                    let nextDefaultTag = personBtnTag.BankCardBtnTag.rawValue + 2 * (self.currentCarNumber + i + 1)
                    let nextDefaultBtn = self.viewWithTag(nextDefaultTag) as! UIButton
                    nextDefaultBtn.tag -= 2
                    
                    //修改删除卡片按钮tag
                    //let nextDeleteTag = personBtnTag.BankCardBtnTag.rawValue + 2 * (self.dataSource.count - cardNumber + i - 1) - 1
                    tlPrint(message: "nextDefaultTag = \(nextDefaultTag)")
                    
                    let nextDeleteBtn = self.viewWithTag(nextDefaultTag + 1) as! UIButton
                    nextDeleteBtn.tag -= 2
                    
                    //默认标识
                    let flagTag = personBtnTag.BankDefaultTag.rawValue + self.currentCarNumber + i + 1
                    let defaultFlag = self.viewWithTag(flagTag) as! UIImageView
                    defaultFlag.tag -= 1
                    
                    
                }
            }, completion: { (finished) in
                tlPrint(message: "dataSource before: \(self.dataSource)")
                self.dataSource.remove(at: self.currentCarNumber)
                tlPrint(message: "dataSource after: \(self.dataSource)")
            })
        })
    }
    
    
    @objc func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct sender.tag = \(sender.tag)")

        
        delegate.bankBtnAct(btnTag: sender.tag)
    }

}
