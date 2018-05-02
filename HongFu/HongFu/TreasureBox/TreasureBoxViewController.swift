//
//  TreasureBoxViewController.swift
//  FuTu
//
//  Created by Administrator1 on 17/8/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit



class TreasureBoxViewController: UIViewController ,BtnActDelegate{
    let model = TreasureBoxModel()
    var treasureBoxView:TreasureBoxView!
    var status:Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        self.treasureBoxView = TreasureBoxView(frame: self.view.frame, rootVC: self)
        self.view.addSubview(treasureBoxView)
    }

    func btnAct(btnTag: Int) {
        tlPrint(message: "btnTag = \(btnTag)")
        switch btnTag {
        case TreasureBoxTag.TreasureBackBtnTag.rawValue:
            self.navigationController?.popViewController(animated: true)
        case TreasureBoxTag.alertConfirmBtnTag.rawValue:
            tlPrint(message: "宝盒弹窗确定按钮")
            self.treasureBoxView.dismissResultAlertView()
        default:
            if btnTag >= TreasureBoxTag.TreasureBoxViewTag.rawValue {
                self.treasureBoxView.isUserInteractionEnabled = false
                self.model.getTreasureBoxInfo(success: { (response) in
                    tlPrint(message: "response : \(response)")
                    let amount = response["amount"] as! CGFloat
                    let msg = response["msg"] as! String
                    let status = response["status"] as! Int
                    if status == 2 && amount > 0 {
                        self.treasureBoxView.amontInfo = amount > 0 ? "\(amount)" : msg
                        //正在进行中 && 可以领取
                        self.treasureBoxView.isUserInteractionEnabled = true
                        self.treasureBoxView.boxOpenAct(tag: btnTag)
                    } else {
                        self.treasureBoxView.isUserInteractionEnabled = true
                        self.treasureBoxView.initResultAlertView(alertInfo: msg)
                    }
                }) { tlPrint(message: "error") }
            }
            tlPrint(message: "no such case!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
