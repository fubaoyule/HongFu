//
//  LotteryHistoryView.swift
//  FuTu
//
//  Created by Administrator1 on 11/11/17.
//  Copyright © 2017年 Taylor Tan. All rights reserved.
//

import UIKit

class LotteryHistoryView: UIView {

    var scroll: UIScrollView!
    var delegate:BtnActDelegate!
    var textFieldDelegate: UITextFieldDelegate!
    var width,height: CGFloat!
    let model = LotteryModel()
    var tableDelegate: UITableViewDelegate!
    var tableDataSource: UITableViewDataSource!
    var infoTable: UITableView!
    
    var currentTabBtn:UIButton!
    var currentTabLine:UIView!
    
    let baseVC = BaseViewController()
    init(frame:CGRect, rootVC:UIViewController) {
        super.init(frame: frame)
        
        self.width = frame.width
        self.height = frame.height
        self.backgroundColor = UIColor.colorWithCustom(r: 135, g: 16, b: 44)
        
        self.delegate = rootVC as! BtnActDelegate
        self.tableDelegate = rootVC as! UITableViewDelegate
        self.tableDataSource = rootVC as! UITableViewDataSource
        
        initNavigationBar()
        initTabBtn()
//        initDateView()
        initInfoTable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initNavigationBar() -> Void {
        //view
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20 + navBarHeight))
        self.addSubview(navigationView)
        navigationView.backgroundColor = UIColor.colorWithCustom(r: 135, g: 16, b: 44)
        //label
        let imgWidth = adapt_W(width: isPhone ? 167 : 120)
        let titleImg = UIImageView(frame: CGRect(x: 0, y: 20 + adapt_H(height: isPhone ? 10 : 6), width: imgWidth, height:adapt_H(height: isPhone ? 20 : 12)))
        titleImg.center.x = navigationView.center.x
        titleImg.image = UIImage(named: "lottery_historyList.png")
        navigationView.addSubview(titleImg)
        
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        navigationView.addSubview(backBtn)
        backBtn.tag = lotteryTag.historyBackBtnTag.rawValue
        //back button image
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
        
    }
    
    
    func initTabBtn() -> Void {
        
        
    }
    
    func initDateView() -> Void {
        
        let dateBackFrame = CGRect(x: 0, y: 64 + navBarHeight, width: width, height: adapt_H(height: isPhone ? 60 : 40))
        let dateBackView = baseVC.viewCreat(frame: dateBackFrame, backgroundColor: .colorWithCustom(r: 244, g: 244, b: 244))
        self.addSubview(dateBackView)
        let currentDate:String = NSDate.getDate(type: .all)
        //first date selector
        let dateFrame1 = CGRect(x: adapt_W(width: isPhone ? 7 : 27), y: adapt_H(height: isPhone ? 10 : 7.5), width: adapt_W(width: isPhone ? 120 : 100), height: adapt_H(height: isPhone ? 40 : 25))
        let dateSelector1 = baseVC.textFieldCreat(frame: dateFrame1, placeholderText: currentDate, aligment: .left, fonsize: fontAdapt(font: isPhone ? 13 : 9), borderWidth: adapt_W(width: 0.5), borderColor: .colorWithCustom(r: 169, g: 169, b: 169), tag: tradeSearchTag.DateSelector1.rawValue)
        dateSelector1.textColor = UIColor.colorWithCustom(r: 35, g: 35, b: 35)
        dateBackView.addSubview(dateSelector1)
        dateSelector1.layer.cornerRadius = adapt_W(width: 5)
        dateSelector1.delegate = textFieldDelegate
        dateSelector1.backgroundColor = UIColor.white
        
        let leftView = baseVC.viewCreat(frame: CGRect(x: 0, y: 0, width: adapt_W(width: 30), height: adapt_H(height: 40)), backgroundColor: .clear)
        let leftImg = UIImageView(frame: CGRect(x: adapt_W(width: 5), y: adapt_H(height: 10), width: adapt_W(width: 20), height: adapt_H(height: 20)))
        leftImg.image = UIImage(named: "wallet_recorde_date.png")
        leftView.addSubview(leftImg)
        dateSelector1.leftView = leftView
        dateSelector1.leftViewMode = .always
        
        //secend date selector
        let dateFrame2 = CGRect(x: adapt_W(width: isPhone ? 150 : 150), y: dateFrame1.origin.y, width: dateFrame1.width, height: dateFrame1.height)
        let dateSelector2 = baseVC.textFieldCreat(frame: dateFrame2, placeholderText: currentDate, aligment: .left, fonsize: fontAdapt(font: isPhone ? 13 : 9), borderWidth: adapt_W(width: 0.5), borderColor: .colorWithCustom(r: 169, g: 169, b: 169), tag: tradeSearchTag.DateSelector2.rawValue)
        dateSelector2.textColor = UIColor.colorWithCustom(r: 35, g: 35, b: 35)
        dateSelector2.layer.cornerRadius = adapt_W(width: 5)
        dateBackView.addSubview(dateSelector2)
        dateSelector2.delegate = textFieldDelegate
        dateSelector2.backgroundColor = UIColor.white
        
        let leftView2 = baseVC.viewCreat(frame: CGRect(x: 0, y: 0, width: adapt_W(width: 30), height: adapt_H(height: 40)), backgroundColor: .clear)
        let leftImg2 = UIImageView(frame: CGRect(x: adapt_W(width: 5), y: adapt_H(height: 10), width: adapt_W(width: 20), height: adapt_H(height: 20)))
        leftImg2.image = UIImage(named: "wallet_recorde_date.png")
        leftView2.addSubview(leftImg2)
        dateSelector2.leftView = leftView2
        dateSelector2.leftViewMode = .always
        dateSelector2.delegate = textFieldDelegate
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAct(sender:)))
        dateSelector1.addGestureRecognizer(tapGest)
        dateSelector2.addGestureRecognizer(tapGest)
        
        
        let label = baseVC.labelCreat(frame: CGRect(x: adapt_W(width: isPhone ? 130 : 130), y: adapt_H(height: isPhone ? 24 : 15), width: adapt_W(width: 15), height: adapt_H(height: isPhone ? 15 : 10)), text: "至", aligment: .center, textColor: .colorWithCustom(r: 35, g: 35, b: 35), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 17 : 11))
        dateBackView.addSubview(label)
        
        //search button
        let searchFrame = CGRect(x: width - adapt_W(width: isPhone ? 90 : 60), y: adapt_H(height: isPhone ? 15 : 10), width: adapt_W(width: isPhone ? 80 : 50), height: adapt_H(height: isPhone ? 30 : 20))
        let searchBtn = baseVC.buttonCreat(frame: searchFrame, title: "查询", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 27, g: 123, b: 233), fonsize: fontAdapt(font: isPhone ? 17 : 11), events: .touchUpInside)
        dateBackView.addSubview(searchBtn)
        searchBtn.tag = tradeSearchTag.DateSearchBtnTag.rawValue
        searchBtn.layer.cornerRadius = searchFrame.height / 2
        
    }
    
    func initInfoTable() -> Void {
        let tableY:CGFloat = 64
        infoTable = UITableView(frame: CGRect(x: 0, y: tableY, width:  width, height: height - tableY))
        self.addSubview(infoTable)
        infoTable.delegate = self.tableDelegate
        infoTable.dataSource = self.tableDataSource
        infoTable.backgroundColor = UIColor.colorWithCustom(r: 135, g: 16, b: 53)
        infoTable.separatorStyle = .none
    }
    
    func reloadInfoTable() -> Void {
        infoTable.reloadData()
    }
    
    
    func btnAct(sender:UIButton) -> Void {
        
        tlPrint(message: "btnAct sender.tag = \(sender.tag)")
        delegate.btnAct(btnTag: sender.tag)
        
    }
    
    
    
    
    func tapGestureAct(sender:UITapGestureRecognizer) -> Void {
        tlPrint(message: "sender.view.tag: \(String(describing: sender.view?.tag))")
    }

}
