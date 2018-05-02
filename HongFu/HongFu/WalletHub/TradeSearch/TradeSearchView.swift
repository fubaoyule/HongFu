//
//  TradeSearchView.swift
//  FuTu
//
//  Created by Administrator1 on 28/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class TradeSearchView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    var scroll: UIScrollView!
    var delegate:BtnActDelegate!
    var textFieldDelegate: UITextFieldDelegate!
    var width,height: CGFloat!
    let model = TradeSearchModel()
    var tableDelegate: UITableViewDelegate!
    var tableDataSource: UITableViewDataSource!
    var searchType: tradeSearchType!
    var infoTable, betInfoTable: UITableView!
    
    
    var currentTabBtn,currentSubTabBtn:UIButton!
    var currentTabLine:UIView!
    let dateArray0:[[String]] = [["2010","2012","2013","1014","2015","2016","2017","2018"],
                                 ["01","02","03","04","05","06","07","08","09","10","11","12"],
                                 ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]]
    let pickerUnit0:[String] = ["年","月","日"]
    let pickerUnit1:[String] = ["","",""]
    let dateArray1:[[String]] = [[""],["新PT","MG老虎机","SG老虎机","PNG老虎机","HB老虎机","TTG老虎机","BS老虎机"],[""]]
    var dateArray:[[String]]!
    var pickerUnit:[String]!
    //是否为游戏类型选择项
    var isGameType = false
    let baseVC = BaseViewController()
    init(frame:CGRect, searchType:tradeSearchType,rootVC:UIViewController) {
        super.init(frame: frame)
        
        self.width = frame.width
        self.height = frame.height
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        self.searchType = searchType
        
        self.delegate = rootVC as! BtnActDelegate
        self.textFieldDelegate = rootVC as! UITextFieldDelegate
        self.tableDelegate = rootVC as! UITableViewDelegate
        self.tableDataSource = rootVC as! UITableViewDataSource
        
        initNavigationBar()
        initTabBtn()
        initSubTabBtn()
        
        self.dateArray = dateArray0
        self.pickerUnit = pickerUnit0
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
        setLabelProperty(label: titleLabel, text: "记录查询", aligenment: .center, textColor: .colorWithCustom(r: 255, g: 192, b: 0), backColor: .clear, font: 17)
        navigationView.addSubview(titleLabel)
        
        
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        navigationView.addSubview(backBtn)
        backBtn.tag = tradeSearchTag.TradeSearchBackBtnTag.rawValue
        //back button image
//        let backBtnImg = UIImageView(frame: CGRect(x: 10, y: 12, width: 12, height: 20))
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
        
    }
    func initTabBtn() -> Void {
        
        for i in 0 ..< model.tabName.count {
            //button
            let tabFrame = CGRect(x: CGFloat(i) * width / CGFloat(model.tabName.count), y: 20 + navBarHeight, width: width / CGFloat(model.tabName.count), height: 44)
            let tabBtn = baseVC.buttonCreat(frame: tabFrame, title: model.tabName[i], alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .white, fonsize: 16, events: .touchUpInside)
            self.addSubview(tabBtn)
            tabBtn.tag = tradeSearchTag.TradeSearchTabBtnTag.rawValue + i
            tabBtn.setTitleColor(model.tabBtnColorNormal, for: .normal)
            tabBtn.backgroundColor = model.tabBtnBgColorNormal
            if i == 0 {
                tabBtn.backgroundColor = model.tabBtnBgColorHigh
                tabBtn.setTitleColor(model.tabBtnColorHigh, for: .normal)
                currentTabBtn = tabBtn
            }
        }
    }
    //初始化投注记录页面
    var betRecordView:UIView!
    func initBetRecordView() -> Void {
        if self.tradeRecordView != nil {
            self.tradeRecordView.isHidden = true
        }
        if betRecordView != nil {
            self.betRecordView.isHidden = false
            return
        }
        self.betRecordView = UIView(frame: CGRect(x: 0, y: 20 + navBarHeight * 2, width: width, height: height - (20 + navBarHeight * 2)))
        self.addSubview(betRecordView)
        tradeRecordView.backgroundColor = UIColor.red
        
        self.initDateView(recordType: .betRecord)
        self.initInfoTable(recordType: .betRecord, superView: betRecordView)
    }
    
    //交易记录的子选项
    var tradeRecordView:UIView!
    func initSubTabBtn() -> Void {
        if self.betRecordView != nil {
            self.betRecordView.isHidden = true
        }
        if tradeRecordView != nil {
            self.tradeRecordView.isHidden = false
            return
        }
        self.tradeRecordView = UIView(frame: CGRect(x: 0, y: 20 + navBarHeight * 2, width: width, height: height - (20 + navBarHeight * 2)))
        self.addSubview(tradeRecordView)
        tradeRecordView.backgroundColor = UIColor.green
        for i in 0 ..< model.subTabName.count {
            //button
            let tabFrame = CGRect(x: CGFloat(i) * width / CGFloat(model.subTabName.count), y: 0, width: width / CGFloat(model.subTabName.count), height: 44)
            let tabBtn = baseVC.buttonCreat(frame: tabFrame, title: model.subTabName[i], alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .white, fonsize: 16, events: .touchUpInside)
            tradeRecordView.addSubview(tabBtn)
            tabBtn.tag = tradeSearchTag.TradeSearchSubTabBtnTag.rawValue + i
            tabBtn.setTitleColor(model.subTabBtnColorNormal, for: .normal)
            //line
            let lineFrame = CGRect(x: tabFrame.width * (isPhone ? 0.25 : 0.35), y: tabFrame.height - adapt_W(width: isPhone ? 3 : 2), width: tabFrame.width * (isPhone ? 0.5 : 0.3), height: adapt_H(height: isPhone ? 3 : 2))
            let line = baseVC.viewCreat(frame: lineFrame, backgroundColor: .white)
            tabBtn.addSubview(line)
            line.tag = tradeSearchTag.TradeSearchTabLineTag.rawValue + i
            line.layer.cornerRadius = lineFrame.height / 2
            
            if (self.searchType == tradeSearchType.Recharge && i == 0) || (self.searchType == tradeSearchType.Withdraw && i == 1) || (self.searchType == tradeSearchType.Transfer && i == 2) || (self.searchType == tradeSearchType.Bonus && i == 3) {
                tabBtn.setTitleColor(model.subTabBtnColorHigh, for: .normal)
                line.backgroundColor = model.subTabBtnColorHigh
                currentSubTabBtn = tabBtn
                currentTabLine = line
            }
        }
        
        self.initDateView(recordType: .tradeRecord)
        self.initInfoTable(recordType: .tradeRecord, superView: tradeRecordView)
    }
    
    func initDateView(recordType: tradeSearchType) -> Void {
        
        let isTradeRecord = (recordType == tradeSearchType.tradeRecord)
        let currentView = (isTradeRecord ? self.tradeRecordView : self.betRecordView)
        let dateBackFrame = CGRect(x: 0, y: isTradeRecord ? 44 : 0, width: width, height: adapt_H(height: isTradeRecord ? 60 : 100))
        let dateBackView = baseVC.viewCreat(frame: dateBackFrame, backgroundColor: .colorWithCustom(r: 244, g: 244, b: 244))
        currentView?.addSubview(dateBackView)
        let currentDate:String = NSDate.getDate(type: .all)
        let dateFrame1 = CGRect(x: adapt_W(width: isPhone ? 7 : 27), y: adapt_H(height: isPhone ? 10 : 7.5), width: adapt_W(width: isPhone ? 120 : 104), height: adapt_H(height: isPhone ? 40 : 25))
        let dateFrame2 = CGRect(x: adapt_W(width: isPhone ? 150 : 150), y: dateFrame1.origin.y, width: dateFrame1.width, height: dateFrame1.height)
        let dateFrame3 = CGRect(x: adapt_W(width: isPhone ? 275 : 150), y: dateFrame1.origin.y, width: adapt_W(width: 94), height: dateFrame1.height)
        let dateFrameArray = [dateFrame1,dateFrame2,dateFrame3]
        for i in 0 ..< 3 {
            if isTradeRecord && i == 2 {
                break
            }
            //first date selector
            let dateSelector = baseVC.textFieldCreat(frame: dateFrameArray[i], placeholderText: i == 2 ? "新PT" : currentDate, aligment: .left, fonsize: fontAdapt(font: isPhone ? 13 : 9), borderWidth: adapt_W(width: 0.5), borderColor: .colorWithCustom(r: 169, g: 169, b: 169), tag: tradeSearchTag.DateSelectorTag.rawValue + i)
            dateSelector.textColor = UIColor.colorWithCustom(r: 35, g: 35, b: 35)
            dateBackView.addSubview(dateSelector)
            dateSelector.layer.cornerRadius = adapt_W(width: 5)
            dateSelector.delegate = textFieldDelegate
            dateSelector.backgroundColor = UIColor.white
            dateSelector.textAlignment = .center

            tlPrint("searchType:\(searchType.rawValue)")
            if recordType == tradeSearchType.betRecord {
                dateSelector.tag = tradeSearchTag.BetDateSelectorTag.rawValue + i
            }
            if i < 2 {
                let leftView = baseVC.viewCreat(frame: CGRect(x: 0, y: 0, width: adapt_W(width: 30), height: adapt_H(height: 40)), backgroundColor: .clear)
                let leftImg = UIImageView(frame: CGRect(x: adapt_W(width: 5), y: adapt_H(height: 10), width: adapt_W(width: 20), height: adapt_H(height: 20)))
                leftImg.image = UIImage(named: "wallet_recorde_date.png")
                leftView.addSubview(leftImg)
                dateSelector.leftView = leftView
                dateSelector.leftViewMode = .always
            } else if i == 2 {
                let rightView = baseVC.viewCreat(frame: CGRect(x: 0, y: 0, width: adapt_W(width: 30), height: adapt_H(height: 40)), backgroundColor: .clear)
                let rightImg = UIImageView(frame: CGRect(x: adapt_W(width: 5), y: adapt_H(height: 10), width: adapt_W(width: 20), height: adapt_H(height: 20)))
                rightImg.image = UIImage(named: "wallet_recorde_pulldown.png")
                rightView.addSubview(rightImg)
                dateSelector.rightView = rightView
                dateSelector.rightViewMode = .always
            }
            
            
            
            //初始化游戏下拉按钮
        }
        let label = baseVC.labelCreat(frame: CGRect(x: adapt_W(width: isPhone ? 130 : 130), y: adapt_H(height: isPhone ? 24 : 15), width: adapt_W(width: 15), height: adapt_H(height: isPhone ? 15 : 10)), text: "至", aligment: .center, textColor: .colorWithCustom(r: 35, g: 35, b: 35), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 17 : 11))
        dateBackView.addSubview(label)
        
        //search button
        let searchFrame1 = CGRect(x: width - adapt_W(width: isPhone ? 90 : 60), y: adapt_H(height: isPhone ? 15 : 10), width: adapt_W(width: isPhone ? 80 : 50), height: adapt_H(height: isPhone ? 30 : 20))
        let searchFrame2 = CGRect(x: (width - adapt_W(width: isPhone ? 250 : 180)) / 2, y: adapt_H(height: isPhone ? 60 : 40), width: adapt_W(width: isPhone ? 250 : 180), height: adapt_H(height: isPhone ? 30 : 20))
        let searchFrame = isTradeRecord ? searchFrame1 : searchFrame2
        let searchBtn = baseVC.buttonCreat(frame: searchFrame, title: "查询", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 186, g: 9, b: 31), fonsize: fontAdapt(font: isPhone ? 17 : 11), events: .touchUpInside)
        dateBackView.addSubview(searchBtn)
        searchBtn.tag = tradeSearchTag.DateSearchBtnTag.rawValue
        searchBtn.layer.cornerRadius = searchFrame.height / 2
    }
    
    func initInfoTable(recordType:tradeSearchType, superView:UIView) -> Void {
        let tableY = 44 + adapt_H(height: 60)
        let infoTable = UITableView(frame: CGRect(x: 0, y: tableY, width:  width, height: height - tableY))
        
        superView.addSubview(infoTable)
        infoTable.delegate = self.tableDelegate
        infoTable.dataSource = self.tableDataSource
        if recordType == tradeSearchType.betRecord {
            self.betInfoTable = infoTable
        } else {
            self.infoTable = infoTable
        }
    }
    
    var pickerView:UIView!
    var picker:UIPickerView!
    var currentTextField:UITextField!
    //时间选择器
    func initDatePickerView(textField:UITextField) {
        tlPrint("时间选择器 isgame：\(isGameType)")
        if isGameType {
            self.isGameType = false
            //投注记录
            if self.pickerView != nil {
                for view in pickerView.subviews{
                    view.removeFromSuperview()
                }
                pickerView.removeFromSuperview()
                pickerView = nil
            }
        }
        //先修改textField的日期为今日日期
        self.dateArray = dateArray0
        self.pickerUnit = pickerUnit0
        let currentDate:String = NSDate.getDate(type: .all)
        textField.text = currentDate
        currentTextField = textField
        let pickerHeight = adapt_H(height: isPhone ? 267 : 90)
        if pickerView != nil {
            pickerView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: { 
                self.pickerView.frame = CGRect(x: 0, y: self.height - pickerHeight, width: self.width, height: pickerHeight)
            })
            return
        }
        pickerView = UIView(frame: CGRect(x: 0, y: height, width: width, height: pickerHeight))
        self.addSubview(pickerView)
        
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.width, height: pickerHeight - adapt_H(height: isPhone ? 50 : 30)))
        picker.backgroundColor = UIColor(white: 1, alpha: 1)
        picker.dataSource = self
        picker.delegate = self

        let year = getDate(type: "yyyy")
        let month = getDate(type: "MM")
        let day = getDate(type: "dd")
        picker.selectRow(year - 2011, inComponent: 0, animated: true)
        picker.selectRow(month - 1, inComponent: 1, animated: true)
        picker.selectRow(day - 1, inComponent: 2, animated: true)
        pickerView.addSubview(picker)
        
        //confirm button
        let confirmFrame = CGRect(x: 0, y: picker.frame.height, width: width, height: adapt_H(height: isPhone ? 50 : 30))
        
        let confirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "确     定", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 186, g: 9, b: 31), fonsize: fontAdapt(font: isPhone ? 17 : 11), events: .touchUpInside)
        confirmBtn.tag = tradeSearchTag.DateSelectConfirmBtnTag.rawValue
        pickerView.addSubview(confirmBtn)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.pickerView.frame = CGRect(x: 0, y: self.height - pickerHeight, width: self.width, height: pickerHeight)
        })
    }
    //YYYY  -  年份
    //MM   -   月份
    //dd  - 日期
    func getDate(type:String) -> Int{
    
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_EN")
        dateFormatter.setLocalizedDateFormatFromTemplate(type)
        let dateStr = dateFormatter.string(from: Date())
        tlPrint("\(dateStr) 年/月/日")
        return Int(dateStr)!
    }
    
    //游戏类型选择器
    func initGameTypePickerView(textField:UITextField) -> Void {
        tlPrint("游戏选择器 isgame：\(isGameType)")
        if !isGameType {
            self.isGameType = true
            //投注记录
            if self.pickerView != nil {
                for view in pickerView.subviews{
                    view.removeFromSuperview()
                }
                pickerView.removeFromSuperview()
                pickerView = nil
            }
        }
        self.dateArray = dateArray1
        self.pickerUnit = pickerUnit1
        textField.text = dateArray1[1][0]
        currentTextField = textField
        let pickerHeight = adapt_H(height: isPhone ? 267 : 90)
        if pickerView != nil {
            pickerView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.pickerView.frame = CGRect(x: 0, y: self.height - pickerHeight, width: self.width, height: pickerHeight)
            })
            return
        }
        pickerView = UIView(frame: CGRect(x: 0, y: height, width: width, height: pickerHeight))
        self.addSubview(pickerView)
        
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.width, height: pickerHeight - adapt_H(height: isPhone ? 50 : 30)))
        picker.backgroundColor = UIColor(white: 1, alpha: 1)
        picker.dataSource = self
        picker.delegate = self
        
        pickerView.addSubview(picker)
        
        //confirm button
        let confirmFrame = CGRect(x: 0, y: picker.frame.height, width: width, height: adapt_H(height: isPhone ? 50 : 30))
        
        let confirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "确     定", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 186, g: 9, b: 31), fonsize: fontAdapt(font: isPhone ? 17 : 11), events: .touchUpInside)
        confirmBtn.tag = tradeSearchTag.DateSelectConfirmBtnTag.rawValue
        pickerView.addSubview(confirmBtn)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.pickerView.frame = CGRect(x: 0, y: self.height - pickerHeight, width: self.width, height: pickerHeight)
        })
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dateArray[component].count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dateArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(dateArray[component][row])\(pickerUnit[component])"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        tlPrint(message: "didSelectRow: \(dateArray[component][row])")
        
        let oldDate = currentTextField.text
        var newDate:String!
        if self.isGameType {
            newDate = dateArray[component][row]
        } else {
            var singleDate:[String] = oldDate!.components(separatedBy: "/")
            singleDate[component] = String(dateArray[component][row])
            newDate = singleDate[0] + "/" + singleDate[1] + "/" + singleDate[2]
        }
        
        currentTextField.text = newDate
    }
    
    func tabBtnChanged(btnTag:Int) -> Void {
        tlPrint(message: "subTabBtnChanged btnTag = \(btnTag)")
        if btnTag == currentTabBtn.tag {
            return
        }
        currentTabBtn.setTitleColor(model.tabBtnColorNormal, for: .normal)
        currentTabBtn.backgroundColor = model.tabBtnBgColorNormal
        let button = self.viewWithTag(btnTag) as! UIButton
        button.setTitleColor(model.tabBtnColorHigh, for: .normal)
        button.backgroundColor = model.tabBtnBgColorHigh
        currentTabBtn = button
        if btnTag == tradeSearchTag.TradeSearchTabBtnTag.rawValue {
            //交易记录
            self.initSubTabBtn()
        } else {
            //投注记录
            self.initBetRecordView()
        }
    }
    
    func subTabBtnChanged(btnTag:Int) -> Void {
        tlPrint(message: "subTabBtnChanged btnTag = \(btnTag)")
        if btnTag == currentSubTabBtn.tag {
            return
        }
        currentSubTabBtn.setTitleColor(model.subTabBtnColorNormal, for: .normal)
        currentTabLine.backgroundColor = UIColor.white
        let button = self.viewWithTag(btnTag) as! UIButton
        let line = self.viewWithTag(btnTag - tradeSearchTag.TradeSearchSubTabBtnTag.rawValue + tradeSearchTag.TradeSearchTabLineTag.rawValue)! as UIView
        
        button.setTitleColor(model.subTabBtnColorHigh, for: .normal)
        line.backgroundColor = model.subTabBtnColorHigh
        currentSubTabBtn = button
        currentTabLine = line
        
    }
    
    func reloadInfoTable() -> Void {
        if self.searchType == tradeSearchType.betRecord {
            self.betInfoTable.reloadData()
        } else {
            infoTable.reloadData()
        }
        
    }

    
    @objc func btnAct(sender:UIButton) -> Void {

        tlPrint(message: "btnAct sender.tag = \(sender.tag)")
        
        if sender.tag >= tradeSearchTag.TradeSearchSubTabBtnTag.rawValue && sender.tag < tradeSearchTag.TradeSearchTabLineTag.rawValue {
            subTabBtnChanged(btnTag:sender.tag)
        } else if sender.tag  >= tradeSearchTag.TradeSearchTabBtnTag.rawValue {
            self.tabBtnChanged(btnTag: sender.tag)
        }
        
        if sender.tag == tradeSearchTag.DateSelectConfirmBtnTag.rawValue {
            hiddenPikerView()
            return
        }
        if sender.tag == tradeSearchTag.DateSearchBtnTag.rawValue {
            self.hiddenPikerView()
            let selectorTag = (self.searchType == tradeSearchType.betRecord ? tradeSearchTag.BetDateSelectorTag.rawValue : tradeSearchTag.DateSelectorTag.rawValue)
            let dateView1 = self.viewWithTag(selectorTag) as! UITextField
            let dateView2 = self.viewWithTag(selectorTag + 1) as! UITextField
            
            let date1 = dateView1.text
            let date2 = dateView2.text
            var date3 = ""
            if self.searchType == tradeSearchType.betRecord {
                let gameNameView = self.viewWithTag(selectorTag + 2) as! UITextField
                date3 = gameNameView.text!
            }
            
            let dateArray1 = date1?.components(separatedBy: "/")
            let dateArray2 = date2?.components(separatedBy: "/")
            tlPrint(message: "date1 = \(date1)  date2 = \(date2) date3 = \(date3) ")
            if date1 == nil || date1 == "" || date2 == nil || date2 == "" {
                
                tlPrint(message: "请输入有效的日期 date1 = \(date1)  date2 = \(date2)")
                let alert = UIAlertView(title: "查询失败", message: "请输入有效的日期", delegate: nil, cancelButtonTitle: "确 定")
                DispatchQueue.main.async {
                    alert.show()
                }
                return
            }
            if dateArray1![0] > dateArray2![0] {
                tlPrint(message: "请输入有效的年份")
                let alert = UIAlertView(title: "查询失败", message: "请输入有效的日期", delegate: nil, cancelButtonTitle: "确 定")
                DispatchQueue.main.async {
                    alert.show()
                }
                return
            } else if dateArray1![0] == dateArray2![0] && dateArray1![1] > dateArray2![1] {
                tlPrint(message: "请输入有效的月份")
                let alert = UIAlertView(title: "查询失败", message: "请输入有效的日期", delegate: nil, cancelButtonTitle: "确 定")
                DispatchQueue.main.async {
                    alert.show()
                }
                return
            }  else if dateArray1![1] == dateArray2![1] && dateArray1![2] > dateArray2![2] {
                tlPrint(message: "请输入有效的日期")
                let alert = UIAlertView(title: "查询失败", message: "请输入有效的日期", delegate: nil, cancelButtonTitle: "确 定")
                DispatchQueue.main.async {
                    alert.show()
                }
                return
            }
        }
        delegate.btnAct(btnTag: sender.tag)
    }
    
    
    func hiddenPikerView() -> Void {
        if self.pickerView != nil {
            UIView.animate(withDuration: 0.5, animations: {
                self.pickerView.frame = CGRect(x: 0, y: self.height, width: self.width, height: self.height - adapt_H(height: 400))
            }, completion: { (finished) in
                self.pickerView.isHidden = true
                if self.isGameType {
                    self.picker.selectRow(0, inComponent: 1, animated: true)
                } else {
                    let year = self.getDate(type: "YYYY")
                    let month = self.getDate(type: "MM")
                    let day = self.getDate(type: "dd")
                    self.picker.selectRow(year - 2011, inComponent: 0, animated: true)
                    self.picker.selectRow(month - 1, inComponent: 1, animated: true)
                    self.picker.selectRow(day - 1, inComponent: 2, animated: true)
                }
            })
        }
    }
    
    
    @objc func tapGestureAct(sender:UITapGestureRecognizer) -> Void {
        tlPrint(message: "sender.view.tag: \(String(describing: sender.view?.tag))")
    }
}
