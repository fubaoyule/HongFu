////
////  GameListView.swift
////  FuTu
////
////  Created by Administrator1 on 4/1/17.
////  Copyright © 2017 Taylor Tan. All rights reserved.
////
//
//import UIKit
//
//class GameListView: UIView {
//
//    var width,height: CGFloat!
//    var scrollDelgate:UIScrollViewDelegate!
//    var delegate: BtnActDelegate!
//    //基础空间
//    let baseVC = BaseViewController()
//    let model = GameListModel()
//    let initFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
//    var scrollView: ScrollViewController!
//    var scrollVC: ScrollViewController!
//    var param:AnyObject!
//    
//    init(frame:CGRect,param:AnyObject, rootVC:UIViewController) {
//        super.init(frame: frame)
//        
//        self.width = deviceScreen.width
//        self.height = deviceScreen.height
//        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
//        self.delegate = rootVC as! BtnActDelegate
//        self.param = param
//        setBackGroundImage()    //添加背景图
//        initNavigationView()    //初始化导航栏
//        initScrollView()        //初始化滑动视图
//    }
//    private func setBackGroundImage() -> Void {
//        let imgView = UIImageView(frame: CGRect(x: 0, y: model.navHeight, width: width, height: height - model.navHeight))
//        imgView.image = UIImage(named: model.backgroundImage)
//        self.insertSubview(imgView, at: 0)
//    }
//    private func initNavigationView() -> Void {
//        //创建导航视图
//        let baseVC = BaseViewController()
//        let navFrame = CGRect(x: 0, y: 0, width: width, height: model.navHeight)
//        
//        let naviView = baseVC.viewCreat(frame: navFrame, backgroundColor: UIColor.clear)
//        self.addSubview(naviView)
//        
//        //导航视图背景图
//        let imgView = UIImageView(frame: navFrame)
//        imgView.image = UIImage(named: model.navBackgroundImg)
//        naviView.insertSubview(imgView, at: 0)
//        
//        //初始化返回按钮
//        let backFrame = CGRect(x: 5, y: 5, width: model.backBtnWidth * 0.8, height: model.backBtnWidth * 0.8)
//        let backBtn = baseVC.buttonCreat(frame: backFrame, title: "back", alignment: .center, target: self, myaction: #selector(btnAct), normalImage: nil , hightImage: nil, backgroundColor: .clear, fonsize: 18, events: .touchUpInside)
//        backBtn.setImage(UIImage(named: model.navBackBtnImg), for: .normal)
//        self.addSubview(backBtn)
//        //初始化游戏选择按钮
//        var items: Array<String>!
//        if let gameType = userDefaults.value(forKey: userDefaultsKeys.gameType.rawValue) {
//            self.gameType = gameType as! String
//            items = infoSwitchCase(type: "navItem", tag: nil) as! Array<String>
//        } else {
//            tlPrint(message: "get game type faild")
//            return
//        }
//        
//        for i in 0 ... items.count {
//            var gameBtnFrame: CGRect!
//            var gameBtn: UIButton!
//            let navBtnWidth = (naviView.frame.width - model.backBtnWidth - model.changeImg_right) / CGFloat(CGFloat(items.count) + 0.5)
//            if i < items.count {
//                //分类游戏按钮
//                gameBtnFrame = CGRect(x: model.backBtnWidth + CGFloat(i) * navBtnWidth, y: 0, width: navBtnWidth, height: model.navHeight)
//                gameBtn = baseVC.buttonCreat(frame: gameBtnFrame, title: items[i], alignment: .center, target: self, myaction: #selector(btnAct(sender:)) , normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: model.navBtnTextFont, events: .touchUpInside)
//                gameBtn.tag = baseTag + i
//                naviView.addSubview(gameBtn)
//                gameBtn.setTitleColor(model.navBtnTextColor, for: .normal)
//                if i == 0 {
//                    gameBtn.setImage(UIImage(named: model.diamond_allGame), for: .normal)
//                    gameBtn.setImage(UIImage(named: model.diamond_allGame2), for: .highlighted)
//                }
//            } else {
//                let changeBtnFrame = CGRect(x: model.backBtnWidth + (CGFloat(i)) * navBtnWidth, y: 0, width: navBtnWidth / 2, height: model.navHeight)
//                
//                changeBtn = baseVC.buttonCreat(frame: changeBtnFrame, title: "", alignment: .center, target: self, myaction: #selector(gameBtnAct(sender:)) , normalImage: UIImage(named:model.change_list), hightImage: UIImage(named:model.change_list2), backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
//                changeBtn.tag = baseTag + i
//                self.naviView.addSubview(changeBtn)
//            }
//        }
//    }
//    
//    
//    
//    private func initScrollView() -> Void {
//        scrollVC = ScrollViewController()
//        scrollVC.gameToken = param.value(forKey: "gameToken") as! String
//        scrollVC.delegate = self
//        
//        scrollVC.isPageControl = NSNumber(value: true as Bool)
//        self.addChildViewController(scrollVC)
//        self.view.addSubview(scrollVC.view)
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapAction(_:)))
//        scrollVC.view.addGestureRecognizer(tap)
//    }
//    
//    func btnAct(sender:UIButton) -> Void {
//        <#function body#>
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
