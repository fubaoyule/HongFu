 //
//  GameListViewController.swift
//  FuTu
//
//  Created by Administrator1 on 7/11/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//
//  tag = 100+
//  game tag = 200 ~ 399
import WebKit
import UIKit

class GameListViewController: UIViewController,WKNavigationDelegate, UnlimitedSlideVCDelegate {


    var param: AnyObject!
    let baseTag = 100
    var naviView: UIView!
    var scrollView: ScrollViewController!
    let initFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var model = GameListModel()
    //var dataSource: GameListDataSource!
    var gameType: String!
    
    var changeBtn:UIButton!
    var scrollVC: ScrollViewController!
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RotateScreen.right()
        setBackGroundImage()    //添加背景图
        initNavigationView()    //初始化导航栏
        initScrollView()        //初始化滑动视图
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        tlPrint(message: "rotate screen to right")
        //self.rotateToLanscap()
        RotateScreen.right()
        tlPrint(message: "current orientation: \(currentScreenOritation.rawValue)")
    }
    
    private func setBackGroundImage() -> Void {
        
        let imgView = UIImageView(frame: self.view.frame)
        imgView.image = UIImage(named: model.backgroundImage)
        self.view.insertSubview(imgView, at: 0)
    }
    
    var itemImgNormal: Array<String>!
    var itemImgSelect: [String]!
    private func initNavigationView() -> Void {
        //创建导航视图
        let baseVC = BaseViewController()
        let navFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: adapt_H(height: model.navHeight))
        
        naviView = baseVC.viewCreat(frame: navFrame, backgroundColor: UIColor.clear)
        self.view.addSubview(naviView)
        
        //导航视图背景图
        let imgView = UIImageView(frame: navFrame)
        imgView.image = UIImage(named: model.navBackgroundImg)
        naviView.insertSubview(imgView, at: 0)
        
        //初始化游戏选择按钮
        var items: Array<String>!
        
        
        if let gameType = userDefaults.value(forKey: userDefaultsKeys.gameType.rawValue) {
            self.gameType = gameType as! String
            tlPrint(message: "gameType:\(self.gameType)")
            items = infoSwitchCase(type: "navItem", tag: nil) as! Array<String>
            itemImgNormal = infoSwitchCase(type: "navImgNormal", tag: nil) as! Array<String>
            itemImgSelect = infoSwitchCase(type: "navImgSelect", tag: nil) as! Array<String>
        } else {
            tlPrint(message: "get game type faild")
            return
        }
        
        //初始化返回按钮
        let navBtnWidth:CGFloat = navFrame.width / CGFloat(CGFloat(6) + 1.3)
        let backFrame = CGRect(x: 0, y: 0, width: navBtnWidth * 0.65, height: navFrame.height)
        let backBtn = baseVC.buttonCreat(frame: backFrame, title: "back", alignment: .center, target: self, myaction: #selector(navBackBtnAct), normalImage: nil , hightImage: nil, backgroundColor: .clear, fonsize: 18, events: .touchUpInside)
        backBtn.setImage(UIImage(named: "list_nav_back0.png"), for: .normal)
        backBtn.setImage(UIImage(named: "list_nav_back1.png"), for: .highlighted)
        self.view.addSubview(backBtn)
        //游戏名称文案
        let gameNameImg = UIImageView(frame: CGRect(x: 0, y: 0, width: adapt_W(width: isPhone ? 250 : 150), height: adapt_H(height: isPhone ? 37 : 25)))
        imgView.addSubview(gameNameImg)
        gameNameImg.image = UIImage(named:"list_nav_Text_\(self.gameType!).png")
        gameNameImg.center = imgView.center
       
        tlPrint("self.gameType=list_nav_Text_\(self.gameType!).png")
        
        
        for i in 0 ... items.count {
            
            var gameBtnFrame: CGRect!
            var gameBtn: UIButton!
            if i < items.count {
                //分类游戏按钮
                gameBtnFrame = CGRect(x: backFrame.width + CGFloat(i) * navBtnWidth, y: 0, width: navBtnWidth, height:navFrame.height)
                gameBtn = baseVC.buttonCreat(frame: gameBtnFrame, title: "", alignment: .center, target: self, myaction: #selector(gameBtnAct(sender:)) , normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
                gameBtn.tag = GameListTag.gameTypeBtnTag.rawValue + i
                self.naviView.addSubview(gameBtn)
                
                //background image
                let backImg = UIImageView(frame: CGRect(x: 0, y: 0, width: gameBtnFrame.width, height: gameBtnFrame.height))
                backImg.image = UIImage(named: "")
                gameBtn.insertSubview(backImg, at: 0)
                backImg.tag = GameListTag.gameTypeBtnBackImg.rawValue + i
                //title image
                let titleImg = UIImageView(frame: CGRect(x: adapt_W(width: 3), y: adapt_H(height: isPhone ? 15 : 10), width: gameBtnFrame.width - adapt_W(width: 6), height: adapt_H(height: isPhone ? 25 : 20)))
                titleImg.image = UIImage(named: itemImgNormal[i])
                gameBtn.insertSubview(titleImg, aboveSubview: backImg)
                titleImg.tag = GameListTag.gameTypeBtnTextImg.rawValue + i
                if i == 0 {
                    backImg.image = UIImage(named: model.navBtnImgSelectBack)
                    titleImg.image = UIImage(named: model.navBtnImg_BS_select[0])
                }
            } else {
                let changeBtnFrame = CGRect(x: backFrame.width + (6) * navBtnWidth, y: 0, width: navBtnWidth * 0.65, height:navFrame.height)
                changeBtn = baseVC.buttonCreat(frame: changeBtnFrame, title: "", alignment: .center, target: self, myaction: #selector(gameBtnAct(sender:)) , normalImage: UIImage(named:"list_button_list0.png"), hightImage: UIImage(named:"list_button_list1.png"), backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
                changeBtn.tag = GameListTag.changeViewListBtnTag.rawValue
                self.naviView.addSubview(changeBtn)
            }
        }
    }
    
    private func initScrollView() -> Void {
        tlPrint(message: "initScrollView")
        
        scrollVC = ScrollViewController()
        scrollVC.gameToken = param.value(forKey: "gameToken") as! String
        scrollVC.delegate = self
        scrollVC.isPageControl = NSNumber(value: true as Bool)
        self.addChildViewController(scrollVC)
        self.view.addSubview(scrollVC.view)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapAction(_:)))
        scrollVC.view.addGestureRecognizer(tap)
    }
    
    
    //**********************************
    //   PT 单独处理
    
    var ptWebView :WKWebView!
    func initPTWebView() -> Void {
        tlPrint(message: "initPTWebView")
        self.ptWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        let url = URL(string: "https://login.mightypanda88.com/jswrapper/integration.js.php?casino=drunkenmonkey88" )
        let request = URLRequest(url: url!)
        tlPrint(message: "reqeust: \(request) \t url: \(String(describing: url))")
        self.ptWebView.load(request)
        
        //self.ptWebView.evaluateJavaScript(<#T##javaScriptString: String##String#>, completionHandler: <#T##((Any?, Error?) -> Void)?##((Any?, Error?) -> Void)?##(Any?, Error?) -> Void#>)
        
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        tlPrint(message: "ptWebView didFinish")
    }
    //   PT 处理结束
    //**********************************
    

    func backDataSourceArray() -> NSMutableArray {
        tlPrint(message: "backDataSourceArray")
        var dataSourceArray:NSMutableArray = model.BSDataSource
        dataSourceArray = infoSwitchCase(type: "dataSource", tag: nil) as! NSMutableArray
        return dataSourceArray
    }
    
    
    func backGameLink() -> String {
        tlPrint(message: "backGameLink")
        var gameUrl = ""
        //let gameType = userDefaults.value(forKey: userDefaultsKeys.gameType.rawValue) as! String
        gameUrl = infoSwitchCase(type: "gameAddr", tag: nil) as! String
        return gameUrl
    }
    
    
    func backScrollerViewForWidthAndHeight() -> CGSize {
        tlPrint(message: "backScrollerViewForWidthAndHeight")
        return CGSize(width: self.view.frame.width, height: self.view.frame.height - model.navHeight)
    }
    
    
    @objc func handleTapAction(_ tap:UITapGestureRecognizer)->Void{
        tlPrint(message: "handleTapAction")
        let page : Int = scrollVC.backCurrentClickPicture()
        tlPrint(message: "handleTapAction \(page)")
    }
    
    //==============================
    //Mark:- 列表页返回按钮点击事件
    //==============================
    @objc func navBackBtnAct() -> Void {
        tlPrint(message: "navBackBtnAct")
        
        //RotateScreen.portrait()
        self.rotateToPortrait()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //==============================
    //Mark:- 列表页各按钮点击事件
    //==============================
    var lastBtnTag: Int = GameListTag.gameTypeBtnTag.rawValue
    @objc func gameBtnAct(sender: UIButton) -> Void {
        tlPrint(message: "gameBtnAct tag = \(sender.tag)")
        switch sender.tag {
        
        case GameListTag.changeViewListBtnTag.rawValue://列表视图按钮
            tlPrint(message: "列表视图按钮 tag:\(sender.tag)")
            changeBtn.tag = GameListTag.changeViewImgBtnTag.rawValue
            changeBtn.setImage(UIImage(named:model.change_img), for: .normal)
            changeBtn.setImage(UIImage(named:model.change_img2), for: .highlighted)
            scrollVC.isShowList = true
            scrollVC.reloadGameList(dataArray: infoSwitchCase(type: "itemDataSource", tag: lastBtnTag) as! Array<Int>)
        case GameListTag.changeViewImgBtnTag.rawValue://图片视图按钮
            tlPrint(message: "图片视图按钮 tag:\(sender.tag)")
            changeBtn.tag = GameListTag.changeViewListBtnTag.rawValue
            changeBtn.setImage(UIImage(named:model.change_list), for: .normal)
            changeBtn.setImage(UIImage(named:model.change_list2), for: .highlighted)
            scrollVC.isShowList = false
            scrollVC.reloadGameList(dataArray: infoSwitchCase(type: "itemDataSource", tag: lastBtnTag) as! Array<Int>)
        default:
            tlPrint(message: "tag:\(sender.tag)")
            scrollVC.reloadGameList(dataArray: infoSwitchCase(type: "itemDataSource", tag: sender.tag) as! Array<Int>)
            let items = infoSwitchCase(type: "navItem", tag: nil) as! Array<String>
            for i in 0 ..< items.count {
                let backImg = self.view.viewWithTag(GameListTag.gameTypeBtnBackImg.rawValue + i) as! UIImageView
                let textImg = self.view.viewWithTag(GameListTag.gameTypeBtnTextImg.rawValue + i) as! UIImageView
                backImg.image = UIImage(named: "")
                textImg.image = UIImage(named: self.itemImgNormal[i])
                if i == (sender.tag - GameListTag.gameTypeBtnTag.rawValue) {
                    backImg.image = UIImage(named: model.navBtnImgSelectBack)
                    textImg.image = UIImage(named: self.itemImgSelect[i])
                }
            }
            
        }
        if sender.tag >= GameListTag.gameTypeBtnTag.rawValue {
            lastBtnTag = sender.tag
        }
    }
    
    func infoSwitchCase(type: String, tag: Int?) -> AnyObject {
        tlPrint(message: "-------- infoSwitchCase --------")
        tlPrint(message: "type:\(type)  tag:\(String(describing: tag))")
        //游戏分类字典
        //增加游戏需要修改
        let navItemsDic = ["newPT":model.navItems_newPT,"BS":model.navItems_BS,"PT":model.navItems_PT,"MG":model.navItems_MG,"TTG":model.navItems_TTG,"SG":model.navItems_SG,"HB":model.navItems_HB,"PNG":model.navItems_PNG]
        //游戏地址字典
        //增加游戏需要修改
        let gameAddrDic = ["newPT":isRelease ? model.newPTGameAddr : model.newPTGameAddrTest,
                           "BS":model.BSGameAddr,
                           "PT":model.PTGameAddr,
                           "MG":model.MGGameAddr,
                           "TTG":model.TTGGameAddr,
                           "SG":model.SGGameAddr,
                           "HB":model.HBGameAddr,
                           "PNG":model.PNGGameAddr]
        //游戏资源字典
        let dataSourceDic = ["newPT":model.newPTDataSource,"BS":model.BSDataSource,"PT":model.PTDataSource,"MG":model.MGDataSource,"TTG":model.TTGDataSource,"SG":model.SGDataSource,"HB":model.HBDataSource,"PNG":model.PNGDataSource]
        //所有游戏字典
        let navItem0Dic = ["newPT":model.navItem_newPT0,"BS":model.navItem_BS0,"PT":model.navItems_PT,"MG":model.navItem_MG0,"TTG":model.navItem_TTG0,"SG":model.navItem_SG0,"HB":model.navItem_HB0,"PNG":model.navItem_PNG0] as [String : Any]
        
//        var returnValue: AnyObject = "" as AnyObject
        var returnValue: AnyObject!

        switch type {
        case "navItem":
            //导航头
            returnValue = navItemsDic[gameType]! as AnyObject
        case "navImgNormal":
            switch gameType {
            default:
                returnValue = model.navBtnImg_BS_normal as AnyObject
            }
        case "navImgSelect":
            switch gameType {
            default:
                returnValue = model.navBtnImg_BS_select as AnyObject
            }
        case "dataSource":
            returnValue = dataSourceDic[gameType]!
        case "gameAddr":
            returnValue = gameAddrDic[gameType]! as AnyObject
        case "itemDataSource":
            let index = tag! - GameListTag.gameTypeBtnTag.rawValue
            tlPrint(message: "itemDataSource index = \(index), tag = \(String(describing: tag)), ")
            switch gameType {
            default:
                tlPrint(message: "通用<所有游戏>Item")
                returnValue = navItem0Dic[gameType] as AnyObject
            }
        default:
            tlPrint(message: "no such case")
        }
        tlPrint(message: "return value: \(returnValue)")
        return returnValue
    }
    
    func prepareStartGame(url: String) {
        
        tlPrint(message: "startGame")
        tlPrint(message: "url: \(url)")
        let gameVC = GameViewController()
        gameVC.param = ["orientation":"right","url":url] as AnyObject
        gameVC.isFromLandscap = true
        rotateToLanscap()
        tlPrint(message: "开始跳转到游戏界面")
        
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    
    
    //旋转到横屏
    func rotateToLanscap() -> Void {
        //currentScreenOritation = UIInterfaceOrientationMask.landscapeRight
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = UIInterfaceOrientationMask.landscapeRight
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    //旋转到竖屏
    func rotateToPortrait() -> Void {
        //currentScreenOritation = UIInterfaceOrientationMask.landscapeRight
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = UIInterfaceOrientationMask.portrait
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
