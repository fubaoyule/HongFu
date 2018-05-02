//
//  LottoryHistoryViewController.swift
//  FuTu
//
//  Created by Administrator1 on 10/11/17.
//  Copyright © 2017年 Taylor Tan. All rights reserved.
//

import UIKit

class LottoryHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate ,BtnActDelegate {

    
    
//    var dataSource = [["中奖时间","中奖名单","中奖号码","中奖号码"],
//                      ["2017-10-11","很遗憾今日无人中奖","6","111"],
//                      ["2017-10-12","很遗憾今日无人中奖","7","112"],
//                      ["2017-10-13","很遗憾今日无人中奖","8","113"],
//                      ["2017-10-14","很遗憾今日无人中奖","9","114"],
//                      ["2017-10-15","很遗憾今日无人中奖","10","115"],
//                      ["2017-10-16","很遗憾今日无人中奖","11","116"]]
    
    var lottertyDataSource:[Array<String>]!
//    let sourceKey:[String] = ["time", "winners" ,"mobileAccount", "number"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let lotteryHistoryView = LotteryHistoryView(frame: self.view.frame, rootVC: self)
        self.view.addSubview(lotteryHistoryView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func btnAct(btnTag: Int) {
        tlPrint(message: "btnAct: tag = \(btnTag)")
        switch btnTag {
        case lotteryTag.historyBackBtnTag.rawValue:
            self.navigationController?.popViewController(animated: true)
        default:
            tlPrint(message: "no such case!")
        }
        
    }
    
    
    //****************************************
    //      TablView delegate
    //****************************************
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tlPrint(message: "numberOfRowsInSection")
        return self.lottertyDataSource.count
    }
    //返回行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tlPrint(message: "heightForRowAt")
        return adapt_H(height: isPhone ? 60 : 40)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tlPrint(message: "cellForRowAt \(indexPath)")
        let reuStr:String = "ABC"
        var cell:LotteryHistoryCell!
//        if cell == nil {
            cell = LotteryHistoryCell(style:UITableViewCellStyle.default, reuseIdentifier: reuStr)
//        }
//        tableView.separatorStyle = .singleLine
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.index = indexPath[1]
        cell.info = self.lottertyDataSource[indexPath[1]]
        return cell
    }
}
