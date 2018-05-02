//
//  ServiceView.swift
//  FuTu
//
//  Created by Administrator1 on 22/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit



protocol serviceDelegate {
    func serviceBtnAct(btnTag:Int)
    func searchBtnAct(btnTag:Int)
}

class ServiceView: UIView {

    var delegate: serviceDelegate!
    var textFeildDelegate: UITextFieldDelegate!
    var scroll: UIScrollView!
    var answerView,questionView: UIView!
    var tableView:UITableView!
    var scrollDelegate: UIScrollViewDelegate!
    var width,height: CGFloat!
    let model = ServiceModel()
    var tableDelegate:UITableViewDelegate!
    var tableDataSource:UITableViewDataSource!
    
    let baseVC = BaseViewController()
    
    init(frame:CGRect, param:AnyObject,rootVC:UIViewController) {
        super.init(frame: frame)
        self.width = frame.width
        self.height = frame.height
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        self.scrollDelegate = rootVC as! UIScrollViewDelegate
        self.textFeildDelegate = rootVC as! UITextFieldDelegate
        self.delegate = rootVC as! serviceDelegate
        self.tableDelegate = rootVC as! UITableViewDelegate
        self.tableDataSource = rootVC as! UITableViewDataSource
        initNavigationBar()
        initScrollView()
        
        //initBtn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initBtn() -> Void {
        tlPrint(message: "service_banner.png")
        //back button
        //客服页返回按钮，该页放到tab以后不再需要返回
//        let backFrame = CGRect(x: adapt_W(width: 15), y: adapt_H(height: 24), width: adapt_W(width: 34), height: adapt_W(width: 34))
//        let backBtn = baseVC.buttonCreat(frame: backFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"service_back.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
//        
//        self.insertSubview(backBtn, at: 3)
//        backBtn.tag = serviceTag.BackBtn.rawValue
        //online service button


        
    }
    
    func initNavigationBar() -> Void {
        //view
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20 + navBarHeight))
        self.addSubview(navigationView)
        let gradientLayer = CAGradientLayer.GradientLayer(topColor: UIColor.colorWithCustom(r: 65, g: 50, b: 48), buttomColor: UIColor.colorWithCustom(r: 43, g: 38, b: 34))
        gradientLayer.frame = navigationView.frame
        navigationView.layer.insertSublayer(gradientLayer, at: 0)
        
        //label
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: width, height: navBarHeight))
        setLabelProperty(label: titleLabel, text: "在线客服", aligenment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .clear, font: 17)
        navigationView.addSubview(titleLabel)

        
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        navigationView.addSubview(backBtn)
        backBtn.tag = serviceTag.BackBtn.rawValue
        //back button image
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
        
    }
    
    func initScrollView() -> Void {
        
        scroll = UIScrollView(frame: CGRect(x: 0, y: navBarHeight + 20, width: width, height: height - navBarHeight - 20))
        self.addSubview(scroll)
        scroll.delegate = scrollDelegate
        scroll.contentSize = CGSize(width: frame.width, height: scroll.frame.height + 1 )
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        
        
        self.addSubview(scroll)
        let banner = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: adapt_H(height: isPhone ? 222 : 170)))
        scroll.insertSubview(banner, at: 0)
        banner.image = UIImage(named: isPhone ? "service_banner.png" : "service_banner_Pad.png")
        banner.isUserInteractionEnabled = true
        
        let onlineFrame = CGRect(x: adapt_W(width: 20), y: adapt_H(height: isPhone ? 150 : 120), width: adapt_W(width: isPhone ? 140 : 120), height: adapt_H(height: isPhone ? 55 : 40))
        let onlineBtn = baseVC.buttonCreat(frame: onlineFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"service_online_btnImg.png"), hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: 17), events: .touchUpInside)
        banner.addSubview(onlineBtn)
        banner.bringSubview(toFront: onlineBtn)
        onlineBtn.tag = serviceTag.OnlineServiceBtn.rawValue
        
        //question view
//        questionView = UIView(frame: CGRect(x: 0, y: adapt_H(height: model.bannerHeight + model.viewDistance), width: width, height: adapt_H(height: model.questionHeight)))
        questionView = UIView(frame: CGRect(x: 0, y: banner.frame.height + adapt_H(height: isPhone ? model.viewDistance : model.viewDistancePad), width: width, height: adapt_H(height: isPhone ? model.questionHeight : model.questionHeightPad)))
        questionView.backgroundColor = UIColor.white
        scroll.addSubview(questionView)
        
        //search view
        let searchView = UIView(frame: CGRect(x: adapt_W(width: 26), y: adapt_H(height: isPhone ? 14 : 10), width: width - adapt_W(width: 52), height: adapt_H(height: isPhone ? 45 : 31)))
        questionView.addSubview(searchView)
        searchView.layer.cornerRadius = adapt_W(width: isPhone ? 10 : 5)
        searchView.layer.borderColor = UIColor.colorWithCustom(r: 176, g: 0, b: 17).cgColor
        searchView.layer.borderWidth = adapt_H(height: 0.5)
        searchView.clipsToBounds = true
        //search textfield
        let searchTextFrame = CGRect(x: 0, y: 0, width: searchView.frame.width * 0.78, height: searchView.frame.height)
        let searchTextField = baseVC.textFieldCreat(frame: searchTextFrame, placeholderText: "请输入问题关键字 如：取款", aligment: .left, fonsize: fontAdapt(font: isPhone ? 14 : 10), borderWidth: 0, borderColor: .clear, tag: serviceTag.SearchTextField.rawValue)
        searchView.addSubview(searchTextField)
        searchTextField.tag = serviceTag.SearchTextField.rawValue
        searchTextField.backgroundColor = UIColor.colorWithCustom(r: 244, g: 244, b: 244)
        searchTextField.delegate = self.textFeildDelegate
        //leftView
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: searchTextFrame.height, height: searchTextFrame.height))
        let leftImg = UIImageView(frame: CGRect(x: adapt_W(width: 8), y: adapt_H(height: isPhone ? 10 : 8), width: adapt_W(width: isPhone ? 25 : 15), height: adapt_W(width: isPhone ? 25 : 15)))
        leftImg.image = UIImage(named: "service_search.png")
        leftView.addSubview(leftImg)
        searchTextField.leftView = leftView
        searchTextField.leftViewMode = .always
        //search button
        let buttonFrame = CGRect(x: searchView.frame.width * 0.78, y: 0, width: searchView.frame.width * 0.22, height: searchTextFrame.height)
        let searchBtn = baseVC.buttonCreat(frame: buttonFrame, title: "搜 索", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 176, g: 0, b: 17), fonsize: fontAdapt(font: isPhone ? 16 : 12), events: .touchUpInside)
        searchView.addSubview(searchBtn)
        searchBtn.setTitleColor(UIColor.white, for: .normal)
        searchBtn.tag = serviceTag.SearchBtn.rawValue
        //cutting line
        let cuttingLine = baseVC.viewCreat(frame: CGRect(x: 0, y: adapt_H(height: isPhone ? 74 : 51), width: width, height: adapt_H(height: 1)), backgroundColor: .colorWithCustom(r: 226, g: 227, b: 231))
        questionView.addSubview(cuttingLine)
        //question button

        
        
        for i in 0 ... 7 {
            //button
            let quesBtn = baseVC.buttonCreat(frame: isPhone ? model.quesFrame[i] :model.quesFramePad[i] , title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: model.quesText[i][1] as! UIColor, fonsize: fontAdapt(font: 15), events: .touchUpInside)
            questionView.addSubview(quesBtn)
            quesBtn.tag = serviceTag.QuestionBtn.rawValue + i
            quesBtn.layer.cornerRadius = adapt_W(width: isPhone ? 10 : 5)
            quesBtn.clipsToBounds = true
            
            //image
            let img = UIImageView(frame: CGRect(x: adapt_W(width: 12), y: adapt_H(height: isPhone ? 10 : 8), width: adapt_W(width:isPhone ? 22 : 20), height: adapt_W(width: isPhone ? 22 : 20)))
            quesBtn.addSubview(img)
            img.image = UIImage(named: "service_icon-\(i+1).png")
            //text
            let text = UILabel(frame: CGRect(x: adapt_W(width: isPhone ? 35 : 30 ), y: 0, width: isPhone ? (model.quesFrame[i].width - adapt_W(width: 35)) : (model.quesFramePad[i].width - adapt_W(width: 35)), height: quesBtn.frame.height))
            quesBtn.addSubview(text)
            setLabelProperty(label: text, text: model.quesText[i][0] as! String, aligenment: .center, textColor: .white, backColor: .clear, font: fontAdapt(font: isPhone ? 15 : 11))
            
            if i >= 5 {
                img.frame = CGRect(x: 0, y: 0, width: adapt_W(width: 120), height: adapt_H(height: model.quesHeight))
                quesBtn.isUserInteractionEnabled = false
                questionView.sendSubview(toBack: quesBtn)
            }
        }
    }
    
    func initAnswerTable(index:Int) -> Void {
        tlPrint(message: "initAnswerScroll: \n")
        //进入答案页面时，禁止scroll滑动，关闭时开启滑动功能
        scroll.contentSize = CGSize(width: width, height: 0)
        if self.answerView != nil {
            let childrenViews = answerView.subviews
            for children in childrenViews {
                children.removeFromSuperview()
            }
            answerView.removeFromSuperview()
            answerView = nil
        }
        self.answerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: adapt_H(height: isPhone ? model.questionHeight : model.questionHeightPad)))
        self.questionView.addSubview(answerView)
        self.answerView.backgroundColor = UIColor.white
        
        
        //selected button
        let btnFrameArray = (isPhone ? model.quesFrame : model.quesFramePad)
        let btnView = baseVC.viewCreat(frame: CGRect(x: adapt_W(width: isPhone ? 18 : 25),y:adapt_W(width: 15),width: btnFrameArray[index].width,height:btnFrameArray[index].height), backgroundColor: model.quesText[index][1] as! UIColor)
        answerView.addSubview(btnView)
        btnView.layer.cornerRadius = adapt_W(width: isPhone ? 10 : 5)
        btnView.clipsToBounds = true
        //image
//        let img = UIImageView(frame: CGRect(x: adapt_W(width: 12), y: adapt_H(height: 10), width: adapt_W(width: 22), height: adapt_W(width: 22)))
        let img = UIImageView(frame: CGRect(x: adapt_W(width: 12), y: adapt_H(height: isPhone ? 10 : 8), width: adapt_W(width:isPhone ? 22 : 20), height: adapt_W(width: isPhone ? 22 : 20)))
        btnView.addSubview(img)
        img.image = UIImage(named: "service_icon-\(index+1).png")
        //text
        let text = UILabel(frame: CGRect(x: adapt_W(width: isPhone ? 35 : 30), y: 0, width: isPhone ? (model.quesFrame[index].width - adapt_W(width: 35)) : (model.quesFramePad[index].width - adapt_W(width: 35)), height: adapt_H(height: isPhone ? model.quesHeight : model.quesHeightPad)))
        btnView.addSubview(text)
        setLabelProperty(label: text, text: model.quesText[index][0] as! String, aligenment: .center, textColor: .white, backColor: .clear, font: fontAdapt(font: 15))
        //close button
        let closeFrame = CGRect(x: adapt_W(width: 300), y: adapt_H(height: 28), width: adapt_W(width: 75), height: adapt_H(height: 30))
        let closeBtn = baseVC.buttonCreat(frame: closeFrame, title: "关闭", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 14 : 11), events: .touchUpInside)
        closeBtn.setTitleColor(UIColor.colorWithCustom(r: 0, g: 101, b: 215), for: .normal)
        answerView.addSubview(closeBtn)
        closeBtn.tag = serviceTag.AnswerCloseBtn.rawValue
        closeBtn.center.y = btnView.center.y
        
        
        
        
        //table view
        let answerFrame = CGRect(x: 0, y: adapt_H(height: isPhone ? 80 : 60), width: width, height: adapt_H(height: model.questionHeight - (isPhone ? 80 : 60)))
        
        tableView = UITableView(frame: answerFrame, style: .plain)
        tableView.delegate = self.tableDelegate
        tableView.dataSource = self.tableDataSource
        answerView.addSubview(tableView)
        self.tableView.separatorStyle = .none//去掉cell之间的横线
        
        //tableView.
        
    }
    
//    func initAnswerView(index:Int){
//        //进入答案页面时，禁止scroll滑动，关闭时开启滑动功能
//        scroll.contentSize = CGSize(width: width, height: 0)
//        
//        if answerView != nil {
//            let childrenViews = answerView.subviews
//            for children in childrenViews {
//                children.removeFromSuperview()
//            }
//            answerView.removeFromSuperview()
//            answerView = nil
//        }
//        let answerFrame = CGRect(x: 0, y: 0, width: width, height: adapt_H(height: model.questionHeight))
//        answerView = baseVC.scrollViewCreat(frame: answerFrame, delegate: scrollDelegate, contentSize: CGSize(width: width, height: adapt_H(height: model.questionHeight) + 1), showsIndicatorV: true, showsIndecatorH: false, backColor: .white)
//        questionView.addSubview(answerView)
//        
//        //selected button 
//        let btnView = baseVC.viewCreat(frame: CGRect(x: adapt_W(width: 18),y:adapt_W(width: 15),width: model.quesFrame[index].width,height:model.quesFrame[index].height), backgroundColor: model.quesText[index][1] as! UIColor)
//        answerView.addSubview(btnView)
//        btnView.layer.cornerRadius = adapt_W(width: 10)
//        btnView.clipsToBounds = true
//        //image
//        let img = UIImageView(frame: CGRect(x: adapt_W(width: 12), y: adapt_H(height: 10), width: adapt_W(width: 22), height: adapt_W(width: 22)))
//        btnView.addSubview(img)
//        img.image = UIImage(named: "service_icon-\(index+1).png")
//        //text
//        let text = UILabel(frame: CGRect(x: adapt_W(width: 35), y: 0, width: model.quesFrame[index].width - adapt_W(width: 35), height: adapt_H(height: model.quesHeight)))
//        btnView.addSubview(text)
//        setLabelProperty(label: text, text: model.quesText[index][0] as! String, aligenment: .center, textColor: .white, backColor: .clear, font: fontAdapt(font: 15))
//        //close button 
//        let closeFrame = CGRect(x: adapt_W(width: 300), y: adapt_H(height: 28), width: adapt_W(width: 75), height: adapt_H(height: 30))
//        let closeBtn = baseVC.buttonCreat(frame: closeFrame, title: "关闭", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: 14), events: .touchUpInside)
//        closeBtn.setTitleColor(UIColor.colorWithCustom(r: 0, g: 101, b: 215), for: .normal)
//        answerView.addSubview(closeBtn)
//        closeBtn.tag = serviceTag.AnswerCloseBtn.rawValue
//        closeBtn.center.y = btnView.center.y
//        
//        //for i in 0 ... 0 {
//        for i in 0 ... model.answerInfo[index].count - 1 {
//            let textWord = model.answerInfo[index][i][0] as NSString
//            let wordSize = textWord.size(attributes: [NSFontAttributeName :  UIFont.systemFont(ofSize: fontAdapt(font: 14))])
//            let answerBtn = UIButton()
//            
//            answerBtn.addTarget(self, action: #selector(self.btnAct(sender:)), for: .touchUpInside)
//            answerBtn.setTitle(textWord as String, for: .normal)
//            answerBtn.titleLabel?.font = UIFont.systemFont(ofSize: fontAdapt(font: 14))
//            answerBtn.titleLabel?.textAlignment = .left
//            answerBtn.setTitleColor(UIColor.colorWithCustom(r: 0, g: 101, b: 215), for: .normal)
//            answerView.addSubview(answerBtn)
//            answerBtn.tag = serviceTag.AnswerBtn.rawValue + i
//            
//            if i == 0 {
//                answerBtn.frame = CGRect(x: adapt_W(width: 18), y: adapt_H(height: 80 + CGFloat(i) * 30), width: wordSize.width + adapt_W(width: 5), height: adapt_H(height: 25))
//            } else {
//                let lastInfoText = self.viewWithTag(serviceTag.AnswerInfoText.rawValue + i - 1) as! UITextView
//                tlPrint(message: "lastInfoText: \(lastInfoText)")
//                answerBtn.mas_makeConstraints({ (make) in
//                    _ = make?.top.equalTo()(lastInfoText.mas_bottom)
//                    _ = make?.left.equalTo()(adapt_W(width: 18))
//                    _ = make?.width.equalTo()(wordSize.width + adapt_W(width: 5))
//                    _ = make?.height.equalTo()(adapt_H(height: 25))
//                })
//            }
//            
//            tlPrint(message: "********   \(i)   *******")
//            //answer textView
//            //let textFrame = CGRect(x: 0, y: adapt_H(height: 110 + CGFloat(i) * 30), width: width, height: 0)
//            let answerInfo = UITextView()
//            answerView.addSubview(answerInfo)
//            answerInfo.mas_makeConstraints({ (make) in
//                _ = make?.top.equalTo()(answerBtn.mas_bottom)
//                _ = make?.left.equalTo()(self.answerView.mas_left)
//                _ = make?.width.equalTo()(self.width)
//                _ = make?.height.equalTo()(0)
//            })
//            
//            
//            answerInfo.tag = serviceTag.AnswerInfoText.rawValue + i
//            answerInfo.backgroundColor = UIColor.colorWithCustom(r: 244, g: 244, b: 244)
//            answerInfo.isEditable = false
//            answerInfo.isSelectable = true
//            answerInfo.textColor = UIColor.colorWithCustom(r: 129, g: 129, b: 129)
//            answerInfo.font = UIFont.systemFont(ofSize: fontAdapt(font: 15))
//            answerInfo.textAlignment = .center
//            
//            answerInfo.isUserInteractionEnabled = true
//            answerInfo.isScrollEnabled = true
//            answerInfo.showsHorizontalScrollIndicator = false
//            answerInfo.showsVerticalScrollIndicator = true
//            answerInfo.text = "\n\(model.answerInfo[index][i][1])\n"
//            
//            
//        }
//    }
    
    
    @objc func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct tag:\(sender.tag)")
        delegate.serviceBtnAct(btnTag: sender.tag)
    }
    

}
