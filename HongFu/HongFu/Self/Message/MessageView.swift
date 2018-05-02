//
//  MessageView.swift
//  FuTu
//
//  Created by Administrator1 on 29/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit



class MessageView: UIView {


    var scroll: UIScrollView!
    var delegate:messageDelegate!
    var width,height: CGFloat!
    let model = MessageModel()
    var tableDelegate: UITableViewDelegate!
    var tableDataSource: UITableViewDataSource!
    var messageType: MessageType!
    var infoTable: UITableView!
    
    var currentTabBtn:UIButton!
    var currentTabLine:UIView!
    
    let baseVC = BaseViewController()
    init(frame:CGRect, messageType:MessageType,rootVC:UIViewController) {
        super.init(frame: frame)
        
        self.width = frame.width
        self.height = frame.height
        
        self.backgroundColor = (messageType == MessageType.SystemMessage ? UIColor.colorWithCustom(r: 226, g: 227, b: 231) : UIColor.white)
        self.messageType = messageType
        
        self.delegate = rootVC as! messageDelegate
        self.tableDelegate = rootVC as! UITableViewDelegate
        self.tableDataSource = rootVC as! UITableViewDataSource
        
        initNavigationBar()
        initTabBtn()
        initInfoTable()
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
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: width, height: navBarHeight))
        setLabelProperty(label: titleLabel, text: "消 息", aligenment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .clear, font: 17)
        navigationView.addSubview(titleLabel)
        
        
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        navigationView.addSubview(backBtn)
        backBtn.tag = MessageTag.MessageBtnTag.rawValue
        //back button image
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
        
    }
    
    
    func initTabBtn() -> Void {
        
        for i in 0 ..< model.tabName.count {
            //button
            let tabFrame = CGRect(x: CGFloat(i) * width / CGFloat(model.tabName.count), y: 20 + navBarHeight, width: width / CGFloat(model.tabName.count), height: navBarHeight)
            let tabBtn = baseVC.buttonCreat(frame: tabFrame, title: model.tabName[i], alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: model.tabBtnBackColor, fonsize: 16, events: .touchUpInside)
            self.addSubview(tabBtn)
            tabBtn.tag = MessageTag.ActivityTabBtnTag.rawValue + i
            tabBtn.setTitleColor(model.tabBtnColorNormal, for: .normal)
            //line
            let lineFrame = CGRect(x: tabFrame.width * (isPhone ? 0.25 : 0.375), y: tabFrame.height - adapt_H(height: isPhone ? 3 : 1.5), width: tabFrame.width * (isPhone ? 0.5 : 0.25), height: adapt_H(height: isPhone ? 3 : 1.5))
            let line = baseVC.viewCreat(frame: lineFrame, backgroundColor: model.tabBtnBackColor)
            tabBtn.addSubview(line)
            line.tag = MessageTag.MessageTabLineTag.rawValue + i
            line.layer.cornerRadius = lineFrame.height / 2
            
            if (self.messageType == .Activity && i == 0) || (self.messageType == .SystemMessage && i == 1) {
                tabBtn.setTitleColor(model.tabBtnColorHigh, for: .normal)
                line.backgroundColor = model.tabBtnColorHigh
                currentTabBtn = tabBtn
                currentTabLine = line
            }
        }
    }
    
    func initInfoTable() -> Void {
        let tableY = 20 + tabBarHeight + navBarHeight
        infoTable = UITableView(frame: CGRect(x: 0, y: tableY, width: width, height: height - tableY))
        self.addSubview(infoTable)
        infoTable.separatorStyle = .none
        infoTable.separatorColor = UIColor.clear
        infoTable.backgroundColor = (messageType == MessageType.SystemMessage ? UIColor.colorWithCustom(r: 226, g: 227, b: 231) : UIColor.white)
        infoTable.delegate = self.tableDelegate
        infoTable.dataSource = self.tableDataSource
    }
    
    @objc func btnAct(sender:UIButton) -> Void {
        
        tlPrint(message: "btnAct sender.tag = \(sender.tag)")

        if sender.tag >= MessageTag.ActivityTabBtnTag.rawValue {
            tabBtnChanged(btnTag:sender.tag)
        }
        delegate.messageBtnAct(btnTag: sender.tag)
        
    }
    
    
    

    func tabBtnChanged(btnTag:Int) -> Void {
        tlPrint(message: "tabBtnChanged btnTag = \(btnTag)")
        if btnTag == currentTabBtn.tag {
            return
        }
        currentTabBtn.setTitleColor(model.tabBtnColorNormal, for: .normal)
        currentTabLine.backgroundColor = model.tabBtnBackColor
        let button = self.viewWithTag(btnTag) as! UIButton
        let line = self.viewWithTag(btnTag - MessageTag.ActivityTabBtnTag.rawValue + MessageTag.MessageTabLineTag.rawValue)! as UIView
        
        button.setTitleColor(model.tabBtnColorHigh, for: .normal)
        line.backgroundColor = model.tabBtnColorHigh
        currentTabBtn = button
        currentTabLine = line
        
    }
}
