////
////  GameLobbyView.swift
////  FuTu
////
////  Created by Administrator1 on 3/12/16.
////  Copyright © 2016 Taylor Tan. All rights reserved.
////
//
//import UIKit
//
//class GameLobbyView: ScrollViewController {
//
//    var scroll:UIScrollView!
//    var imgDataSource: Array<String>!
//    var lobbyModel:LobbyModel!
//    let baseVC = BaseViewController()
//    let initFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
//    var width,height: CGFloat!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tlPrint(message: "game lobby view")
//        width = deviceScreen.width
//        height = deviceScreen.height
//        // Do any additional setup after loading the view.
//        
//        initScrollView()
//        
//        
//    }
//    
//    
//    //初始化滚动视图
//    func initScrollView() -> Void {
//        
//        let scrollFrame = CGRect(x: 0, y: 0, width: width, height: height)
//        scroll = UIScrollView(frame: scrollFrame)
//        self.view.insertSubview(scroll, at: 0)
//        self.automaticallyAdjustsScrollViewInsets = false
//        //scroll.backgroundColor = UIColor.green
//        scroll.contentSize = CGSize(width: width, height: 2 * height)
//        scroll.showsVerticalScrollIndicator = false
//        scroll.showsHorizontalScrollIndicator = false
//        
//        
//        initBackBtn()
//        initImageView()
//        initPlayBtn()
//    }
//
//    
//    //初始化返回按钮
//    func initBackBtn() -> Void {
//        let backFrame = CGRect(x: 15, y: 23, width: 35, height: 35)
//        let backBtn = baseVC.buttonCreat(frame: backFrame, title: "", alignment: .center, target: self, myaction: #selector(backBtnAct(sender:)), normalImage: UIImage(named: imgDataSource[0]), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
//        self.scroll.insertSubview(backBtn, at: 1)
//    }
//    //返回按钮事件
//    func backBtnAct(sender: UIButton) -> Void {
//        tlPrint(message: "backBtnAct")
//        _ = self.navigationController?.popViewController(animated: true)
//    }
//    
//    
//    //初始化游戏图片视图
//    func initImageView() -> Void {
//        
//        let imgFrame = CGRect(x: 0, y: 0, width: width, height: height * lobbyModel.imgHeight)
//        let imgView = UIImageView(frame: imgFrame)
//        imgView.image = UIImage(named: imgDataSource[1])
//        self.view.insertSubview(imgView, at: 0)
//    }
//    
//    func initPlayBtn() -> Void {
//        let playBtn = baseVC.buttonCreat(frame: initFrame, title: "", alignment: .center, target: self, myaction: #selector(playBtnAct), normalImage: UIImage(named: imgDataSource[2]), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
//        self.view.addSubview(playBtn)
//        playBtn.frame = CGRect(x: width * (1 - lobbyModel.playBtnWidth) / 2 , y: height * lobbyModel.imgHeight - width * lobbyModel.playBtnWidth / 2, width: width * lobbyModel.playBtnWidth, height: width * lobbyModel.playBtnWidth)
//    }
//    
//    func playBtnAct() -> Void {
//        tlPrint(message: "playBtnAct")
//    }
//}
