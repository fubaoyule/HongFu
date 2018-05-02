//
//  WalletSucViewController.swift
//  FuTu
//
//  Created by Administrator1 on 28/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit



class WalletSucViewController: UIViewController,BtnActDelegate {
    
    
    var info:[Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    init(params:[Any]) {
        super.init(nibName: nil, bundle: nil)
        info = params
        
        let successView = WalletSucView(frame: self.view.frame, param: info , rootVC: self)
        self.view.addSubview(successView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func btnAct(btnTag: Int) {
        tlPrint(message: "rechargeSuccessDelgate btnTag = \(btnTag)")
        switch btnTag {
        case walletSuccessTag.BackBtnTag.rawValue:
            tlPrint(message: "返回")
            _ = self.navigationController?.popViewController(animated: true)
        case walletSuccessTag.FinishBtnTag.rawValue:
            tlPrint(message: "完成")
            _ = self.navigationController?.popViewController(animated: true)
        default:
            tlPrint(message: "no such case")
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
