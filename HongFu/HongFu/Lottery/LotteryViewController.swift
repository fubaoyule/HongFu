//
//  LotteryViewController.swift
//  FuTu
//
//  Created by Administrator1 on 18/10/17.
//  Copyright © 2017年 Taylor Tan. All rights reserved.
//

import UIKit

class LotteryViewController: UIViewController, BtnActDelegate {
    let model = LotteryModel()
    var lotteryView: LotteryView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.lotteryView = LotteryView(frame: self.view.frame, rootVC: self)
        self.view.addSubview(self.lotteryView)
        self.model.getLotteryInfo(success: { (responseDic) in
            tlPrint(message: "responseDIc = \(responseDic)")
            
            let select3DValue = responseDic["Select3DValue"] as! Int
            let isUnOpen = responseDic["Isopen"] as! Bool
            let message = responseDic["Msg"] as! String
//            if isUnOpen {
//                //未开启，不进入
//                let alert = UIAlertView(title: "提 醒", message: message, delegate: nil, cancelButtonTitle: "确 定")
//                alert.show()
//                
//                self.lotteryView.lotteryTimer.invalidate()
//                self.navigationController?.popViewController(animated: true)
//                return
//            }
            
            //test
            let confirmStatus = responseDic["Status"] as! Bool
            self.lotteryView.initUnselectView(scroll: self.lotteryView.scroll, confirmStatus: confirmStatus)
            //test finish
            
            if select3DValue == 0 {
                //当前没有选择号码，进入号码选择页面
                let confirmStatus = responseDic["Status"] as! Bool
                self.lotteryView.initUnselectView(scroll: self.lotteryView.scroll, confirmStatus: confirmStatus)
                return
            }
            
            //当前已经选择过号码，进入结果查询界面
            let winStatus = responseDic["Success"] as! Int
            let selectedNumber = self.model.transferIntToIntArray(value: select3DValue)
            let winNumber = self.model.transferIntToIntArray(value: responseDic["Today3D"] as! Int)
            self.lotteryView.initSelectView(scroll: self.lotteryView.scroll, numberArray: [winNumber,selectedNumber],winStatus:winStatus)
        }) { 
            tlPrint(message: "获取失败")
            let alert = UIAlertView(title: "提 醒", message: "发生未知错误，请稍后再试或联系客服", delegate: nil, cancelButtonTitle: "确 定")
            alert.show()
            self.lotteryView.lotteryTimer.invalidate()
            self.navigationController?.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func cleanView() -> Void {
        for item in self.view.subviews {
            item.removeFromSuperview()
        }
    }
    
    func btnAct(btnTag: Int) {
        tlPrint(message: "btnAct btnTag = \(btnTag)")
        switch btnTag {
        case lotteryTag.backBtnTag.rawValue:
            self.lotteryView.lotteryTimer.invalidate()
            self.navigationController?.popViewController(animated: true)
        case lotteryTag.confirmBtnTag.rawValue:
            self.confirmBtnAct(tag:btnTag)
        case lotteryTag.historyBtnTag.rawValue:
            self.historyBtnAct()
        default:
            tlPrint(message: "no such case!")
        }
    }
    
    
    
    
    func confirmBtnAct(tag:Int) -> Void {
        if self.lotteryView.selectedNumberArray.count < 3 {
            let alert = UIAlertView(title: "提 醒", message: "请输入正确的号码", delegate: nil, cancelButtonTitle: "确 定")
            alert.show()
            return
        }
        
        let confirmBtn = self.lotteryView.viewWithTag(tag) as! UIButton
        confirmBtn.isEnabled = false
        let selectedNumber = 100 * self.lotteryView.selectedNumberArray[0] + 10 * self.lotteryView.selectedNumberArray[1] + self.lotteryView.selectedNumberArray[2]
        self.model.commitLotteryInfo(selectedNumber: selectedNumber, success: { (responseDic) in
            tlPrint(message: "responseDic: \(responseDic)")
            let message = responseDic["Msg"] as! String
            let alert = UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "确 定")
            alert.show()
            confirmBtn.isEnabled = true
            for view in self.lotteryView.unselectView.subviews {
                view.removeFromSuperview()
            }
            self.lotteryView.unselectView.removeFromSuperview()
            self.lotteryView.initSelectView(scroll: self.lotteryView.scroll, numberArray: [[],self.lotteryView.selectedNumberArray], winStatus: 0)
            
            
        }, failure: {
            let alert = UIAlertView(title: "提 醒", message: "发生未知错误，请稍后再试或联系客服", delegate: nil, cancelButtonTitle: "确 定")
            alert.show()
            confirmBtn.isEnabled = true
        })
    }
    
    func historyBtnAct() -> Void {
        self.model.getHistoryInfo(success: { (response) in
            tlPrint(message: "response:\(response)")
            var historyArray = response
            historyArray.insert(["中奖时间","中奖名单","中奖号码","中奖号码"] , at: 0)
            tlPrint(message: "lotteryHistory : \(String(describing: historyArray))")
            let historyVC = LottoryHistoryViewController()
            
            historyVC.lottertyDataSource = historyArray
            self.navigationController?.pushViewController(historyVC, animated: true)
            
            
        }) { 
            tlPrint(message: "error")
        }
    }
}
