//
//  TradeSearchViewController.swift
//  FuTu
//
//  Created by Administrator1 on 28/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit



class TradeSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, BtnActDelegate {

    
    var searchView:TradeSearchView!
    var searchType:tradeSearchType!
    var model = TradeSearchModel()
    var dataSource: [[Any]]! = [["","",false,"",""]]
    var betDataSource: [[Any]]! = [["","","","",""]]
    var width,height: CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.width = self.view.frame.width
        self.height = self.view.frame.height
        self.searchView = TradeSearchView(frame: self.view.frame, searchType: searchType, rootVC: self)
        self.view.addSubview(self.searchView)
        
        notifyRegister()
    }

    //查询类型： 
    //0 表示充值提现查询，默认显示充值页
    //1 表示转账查询，默认显示转账页
    //2 表示红利查询，默认显示红利界面
    init(searchType:tradeSearchType) {
        super.init(nibName: nil, bundle: nil)
        self.dataSource = model.dataSource
        self.betDataSource = model.betDataSource
        self.searchType = searchType
        initSearchInfo(type: searchType)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initSearchInfo(type:tradeSearchType) -> Void {
        
        let year = NSDate.getDate(type: .year)
        let month = NSDate.getDate(type: .month)
        let day = NSDate.getDate(type: .day)
        let lastYear = (month == "01" ? "\(Int(year)! - Int("1")!)" : year)
        let lastMonth = (month == "01" ? "12" : month)
        tlPrint(message: "year:\(year)-month:\(month)-day:\(day)-lastYear:\(lastYear)-lastMonth:\(lastMonth)")
        model.getSearchedData(type: type, startDate: "\(lastYear)-\(lastMonth)-\(day)", endDate: "\(year)-\(month)-\(day)")
    }
    
    
    //消息通知
    func notifyRegister() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadInfoTable(sender:)), name: NSNotification.Name(rawValue: notificationName.TradeSearchInfoTableRefresh.rawValue), object: nil)
        
    }


    func searchTypeChoose(index:Int) -> tradeSearchType {
        var type:tradeSearchType!
        switch index {
        case 0:
            type = tradeSearchType.Recharge
        case 1:
            type = tradeSearchType.Withdraw
        case 2:
            type = tradeSearchType.Transfer
        case 3:
            type = tradeSearchType.Bonus
        default:
            TLPrint("no such case!")
        }
        return type
    }
    
    func btnAct(btnTag: Int) {
        tlPrint(message: "tradeSearchBtnAct btnTag:\(btnTag)")
        switch btnTag {
        case tradeSearchTag.TradeSearchBackBtnTag.rawValue:
            _ = self.navigationController?.popViewController(animated: true)
            
        case tradeSearchTag.DateSearchBtnTag.rawValue:
            tlPrint(message: "查询按钮")
            let selectorTag = (self.searchType == tradeSearchType.betRecord ? tradeSearchTag.BetDateSelectorTag.rawValue : tradeSearchTag.DateSelectorTag.rawValue)
            let dateView1 = self.searchView.viewWithTag(selectorTag) as! UITextField
            let dateView2 = self.searchView.viewWithTag(selectorTag + 1) as! UITextField
            
            
            let date1 = dateView1.text
            let date2 = dateView2.text
            var date3 = "新PT"
            
            let dataArray1 = date1!.components(separatedBy: "/")
            let dataArray2 = date2!.components(separatedBy: "/")
            tlPrint(message: "dataArray1:\(dataArray1)     dataArray2:\(dataArray2)")
            if self.searchType == tradeSearchType.betRecord {
                let dateView3 = self.searchView.viewWithTag(selectorTag + 2) as! UITextField
                if dateView3.text != nil && dateView3.text != "" {
                    date3 = dateView3.text!
                }
                
                let gameCodeDic = ["新PT":"newPT","MG老虎机":"MG","SG老虎机":"SG","PNG老虎机":"PNG","HB老虎机":"HABA","TTG老虎机":"TTG","BS老虎机":"BTS"]
                
                model.getSearchedBetData(type: self.searchType, startDate: "\(dataArray1[0])-\(dataArray1[1])-\(dataArray1[2]) 00:00", endDate: "\(dataArray2[0])-\(dataArray2[1])-\(dataArray2[2]) 23:59", gameType: gameCodeDic[date3]!)
            } else {
                model.getSearchedData(type: self.searchType, startDate: "\(dataArray1[0])-\(dataArray1[1])-\(dataArray1[2])", endDate: "\(dataArray2[0])-\(dataArray2[1])-\(dataArray2[2])")
            }
            
        default:
            if btnTag >= tradeSearchTag.TradeSearchSubTabBtnTag.rawValue && btnTag < tradeSearchTag.TradeSearchTabLineTag.rawValue {
                tlPrint(message: "子 tab button")
                let index = btnTag - tradeSearchTag.TradeSearchSubTabBtnTag.rawValue
                let type = self.searchTypeChoose(index: index)
                self.initSearchInfo(type: type)
                self.searchType = type
                
                let dateView1 = self.searchView.viewWithTag(tradeSearchTag.DateSelectorTag.rawValue) as! UITextField
                let dateView2 = self.searchView.viewWithTag(tradeSearchTag.DateSelectorTag.rawValue + 1) as! UITextField
                dateView1.text = ""
                dateView2.text = ""
            } else if btnTag >= tradeSearchTag.TradeSearchTabBtnTag.rawValue {
                TLPrint("记录分类按钮")
                if btnTag == tradeSearchTag.TradeSearchTabBtnTag.rawValue {
                    //交易记录按钮
                    self.searchType = tradeSearchType.tradeRecord
                } else {
                    //投注记录按钮
                    self.searchType = tradeSearchType.betRecord
                }
            } else {
                tlPrint(message: "no such case")
            }
            self.searchView.searchType = self.searchType
            tlPrint("self.searchView.searchType = \(self.searchView.searchType.rawValue)")
        }
    }
    
    @objc func reloadInfoTable(sender:NotificationCenter) -> Void {
        if self.searchType == tradeSearchType.betRecord {
            tlPrint("model.betDS = \(model.betDataSource)")
            self.betDataSource = model.betDataSource
            self.searchView.betInfoTable.reloadData()
        } else {
            self.dataSource = model.dataSource
            self.searchView.infoTable.reloadData()
        }
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        self.searchView.hiddenPikerView()
    }
    
    
    //****************************************
    //      TextField delegate
    //****************************************
    
    var currentTextField:UITextField!
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tlPrint(message: "textFieldShouldBeginEditing")
        textField.resignFirstResponder()
        currentTextField = textField
        if textField.tag == tradeSearchTag.BetDateSelectorTag.rawValue + 2 {
            //游戏选择按钮
            tlPrint("游戏选择中 textField.tag = \(textField.tag)")
            searchView.initGameTypePickerView(textField: textField)
            
        } else  {
            //时间选择
            searchView.initDatePickerView(textField:textField)
            
        }
        return false
    }
    
    //****************************************
    //      TablView delegate
    //****************************************
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tlPrint(message: "numberOfRowsInSection")
        if self.searchType == tradeSearchType.betRecord {
            return betDataSource.count
        } else {
            return dataSource.count
        }
        
    }
    //返回行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tlPrint(message: "heightForRowAt")
        return adapt_H(height: isPhone ? 75 : 50)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tlPrint(message: "cellForRowAt \(indexPath)")
        
        let reuStr:String = "ABC"
        var cell:TradeTableViewCell!
        if cell == nil {
            cell=TradeTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: reuStr)
        }
        tableView.separatorStyle = .singleLine
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if self.searchType == tradeSearchType.betRecord {
            cell.betInfo = self.betDataSource[indexPath[1]]
            
            tlPrint("betDataSource:\(self.betDataSource[indexPath[1]])")

        } else {
            cell.info = self.dataSource[indexPath[1]]
            
            tlPrint("self.datasource:\(self.dataSource[indexPath[1]])")
        }
        tlPrint("dataSource:\(dataSource)")
        tlPrint("betDataSource:\(betDataSource)")
        cell.searchType = self.searchType
        return cell
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
