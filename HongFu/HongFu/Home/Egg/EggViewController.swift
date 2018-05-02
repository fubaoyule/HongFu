//
//  EggViewController.swift
//  HongFu
//
//  Created by Administrator1 on 08/02/18.
//  Copyright © 2018年 Taylor Tan. All rights reserved.
//

import UIKit

class EggViewController: UIViewController,BtnActDelegate {

    var eggView:EggView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.eggView = EggView(frame: self.view.frame, viewController: self)
        self.view.addSubview(eggView)
    }

    func btnAct(btnTag: Int) {
        switch btnTag {
        case EggTag.eggBackBtnTag.rawValue:
            self.navigationController?.popViewController(animated: true)
        default:
            if btnTag >= EggTag.eggControllViewTag.rawValue && btnTag < EggTag.eggTag.rawValue {
                tlPrint("点击了金蛋")
                self.eggView.initAlertView()
                
            }
            TLPrint("no such case!")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
