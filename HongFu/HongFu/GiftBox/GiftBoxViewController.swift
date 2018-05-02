//
//  GiftBoxViewController.swift
//  FuBao
//
//  Created by Administrator1 on 4/8/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

class GiftBoxViewController: UIViewController,BtnActDelegate {

    var giftBoxView:GiftBoxView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.giftBoxView = GiftBoxView(frame: self.view.frame, rootVC: self)
        self.view.addSubview(giftBoxView)
        // Do any additional setup after loading the view.
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func btnAct(btnTag: Int) {
        tlPrint(message: "btnAct  btnTag = \(btnTag)")
        
        switch btnTag {
        case giftBoxTag.backBtnTag.rawValue:
            self.navigationController?.popViewController(animated: true)
        case giftBoxTag.boxTapTag.rawValue:
            reqeustGiftBox()
            self.giftBoxView.isUserInteractionEnabled = false
        case giftBoxTag.getBtnTag.rawValue:
            reqeustGiftBox()
            self.giftBoxView.isUserInteractionEnabled = false
        case giftBoxTag.alergGetBtnTag.rawValue:
            self.giftBoxView.removeAlertView()
            
        default:
            tlPrint(message: "no such case")
        }
    }
    
    func reqeustGiftBox() -> Void {
        let giftModel = GiftBoxModel()
        giftModel.getGiftBox(success: { (response) in
            tlPrint(message: "获取礼盒信息成功")
            tlPrint(message: "礼盒信息:\(response)")
            let giftDic = response
            self.giftBoxView.initAlertView(alertType: giftDic["status"] as! Int, amount: giftDic["amount"] as? CGFloat, alertMsg:giftDic["msg"] as! String)
            self.giftBoxView.isUserInteractionEnabled = true
        }) {
            tlPrint(message: "获取礼盒信息失败")
            let alert = UIAlertView(title: "提 醒", message: "获取礼盒信息失败", delegate: nil, cancelButtonTitle: "确 认")
            self.giftBoxView.isUserInteractionEnabled = true
            alert.show()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
