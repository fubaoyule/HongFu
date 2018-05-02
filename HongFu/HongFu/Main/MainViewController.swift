//
//  MainViewController.swift
//  hangge_1028
//
//  Created by hangge on 16/1/19.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.blue
        let nav = self.initNavigateView(rootView: self.view, rootVC: self, navColor: .green, title: "Main控制器")
        self.view.addSubview(nav)
        
        let homeVC = HomeViewController()
//        self.addChildViewController(homeVC)
        self.view.addSubview(homeVC.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func initNavigateView(rootView:UIView, rootVC:UIViewController, navColor:UIColor? ,title:String?) -> UIView {
        //导航头
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: deviceScreen.width, height: 20 + navBarHeight))
        rootView.addSubview(navigationView)
        if navColor != nil {
            navigationView.backgroundColor = navColor
        }
        //label
        if title != nil {
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: deviceScreen.width, height: navBarHeight))
            setLabelProperty(label: titleLabel, text: title!, aligenment: .center, textColor: .white, backColor: .clear, font: 17)
            navigationView.addSubview(titleLabel)
        }
        
        //back button
        let baseVC = BaseViewController()
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight), title: "", alignment: .center, target: self, myaction: #selector(self.backBtnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        navigationView.addSubview(backBtn)
        backBtn.tag = rechargeTag.RechargeBackTag.rawValue
        //back button image
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
        
        return navigationView
        
    }
    
    
    @objc func backBtnAct(sender:UIButton) -> Void {
        TLPrint("backBtnAct")
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
