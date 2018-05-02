//
//  ScrollViewController.swift
//  FuTu
//
//  Created by Administrator1 on 7/11/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit



@objc protocol UnlimitedSlideVCDelegate{
    
    func backDataSourceArray()->NSMutableArray
    func backGameLink() -> String
    @objc optional func backScrollerViewForWidthAndHeight()->CGSize
    
    func prepareStartGame(url: String)->Void
    
    
}

class ScrollViewController: UIViewController, UIScrollViewDelegate {

    var delegate : UnlimitedSlideVCDelegate!
    var scrollerView : UIScrollView?
    
    var leftListView, middleListView, rightListView: UIView?
    let model = GameListModel()
    let userDefaults = UserDefaults.standard
    //当前展示的图片
    var currentIndex : Int?
    //数据源
    var dataSource : NSMutableArray?
    //scrollView的宽和高
    var scrollerViewWidth, scrollerViewHeight : CGFloat?
    var pageControl : UIPageControl?
    var isPageControl : NSNumber!
    //当前游戏列表的总页数 >= 1
    var pageCount: Int!
    var gameToken: String!
    //当前每个页面最大显示的游戏个数
    var gameNumPerPage: Int!
    //当前列表的显示方式是列表还是图表
    var isShowList = false
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.currentIndex = 0
        let size: CGSize = self.delegate.backScrollerViewForWidthAndHeight!()
        self.scrollerViewWidth = size.width
        self.scrollerViewHeight = size.height
        //默认为图片页的个数
        gameNumPerPage = model.gameNumPerPage1
        self.view.frame = CGRect(origin: model.scrollPoint, size: CGSize(width: scrollerViewWidth!, height: scrollerViewHeight!))
        
        self.dataSource =  NSMutableArray(array: self.delegate.backDataSourceArray())
        //当前游戏列表的总页数
        self.pageCount = (dataSource!.count + gameNumPerPage - 1) / gameNumPerPage
        
        self.configureScrollerView()
        
        if (self.isPageControl.boolValue != false) {
            self.configurePageController()
        }
        //Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ScrollViewController.letItScroll), userInfo: nil, repeats: true)
        tlPrint(message: "*****")
        
    }
    

    
    
    func letItScroll(){
        tlPrint(message: "letItScroll")
        self.scrollerView?.setContentOffset( CGPoint(x: 2 * scrollerViewWidth!, y: 0), animated: true)
    }
    
    //==============================
    //Mark:- 配置滚动视图
    //==============================
    func configureScrollerView(){
        tlPrint(message: "configureScrollerView")
        self.scrollerView = UIScrollView(frame: CGRect(x: 0,y: 0,width: self.scrollerViewWidth!,height: self.scrollerViewHeight!))
        self.scrollerView?.delegate = self
        self.scrollerView?.contentSize = CGSize(width: self.scrollerViewWidth! * 3, height: self.scrollerViewHeight!)
        self.scrollerView?.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
        self.scrollerView?.isPagingEnabled = true
        self.scrollerView?.bounces = false
        self.view.addSubview(self.scrollerView!)
        
        //配置滚动视图的页面
        self.configureListView()
    }
    
    //==============================
    //Mark:- 配置滚动视图的页面
    //==============================
    func configureListView(){
        tlPrint(message: "configureListView")
        if(self.dataSource?.count != 0){
            slideDeal(leftIndex: pageCount - 1, midlleIndex: 0, rightIndex: 1)
            self.scrollerView?.addSubview(leftListView!)
            self.scrollerView?.addSubview(middleListView!)
            self.scrollerView?.addSubview(rightListView!)
        }
        
        self.scrollerView?.showsHorizontalScrollIndicator = false
    }
    

    //==============================
    //Mark:- 滚动视图滑动处理函数
    //==============================
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tlPrint(message: "scrollViewDidScroll")
        let offset = scrollView.contentOffset.x
        if(self.dataSource?.count != 0 && pageCount >= 3){
            //三页及以上
            if(offset >= self.scrollerViewWidth!*2 ){
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
                self.currentIndex = self.currentIndex! + 1
                
                if (self.currentIndex == pageCount - 1){
                    slideDeal(leftIndex: currentIndex! - 1, midlleIndex: currentIndex!, rightIndex: 0)
                    self.pageControl?.currentPage = self.currentIndex!;
                    self.currentIndex = -1
                    
                } else if (self.currentIndex == pageCount){
                    slideDeal(leftIndex: pageCount - 1, midlleIndex: 0, rightIndex: 1)
                    self.pageControl?.currentPage = 0
                    self.currentIndex = 0
                    
                } else if (self.currentIndex == 0){
                    slideDeal(leftIndex: pageCount - 1, midlleIndex: currentIndex!, rightIndex: currentIndex! + 1)
                    self.pageControl?.currentPage = self.currentIndex!
                    
                } else {
                    slideDeal(leftIndex: currentIndex! - 1, midlleIndex: currentIndex!, rightIndex: currentIndex! + 1)
                    self.pageControl?.currentPage = self.currentIndex!
                }
            }
            if (offset <= 0){
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0);
                self.currentIndex = self.currentIndex! - 1
                if (self.currentIndex == -2 ){
                    self.currentIndex = pageCount - 2
                    slideDeal(leftIndex: pageCount - 2, midlleIndex: currentIndex!, rightIndex: pageCount - 1)
                    self.pageControl?.currentPage = self.currentIndex!;
                    
                } else if (self.currentIndex == -1 ){
                    self.currentIndex = pageCount - 1
                    slideDeal(leftIndex: currentIndex! - 1, midlleIndex: currentIndex!, rightIndex: 0)
                    
                    self.pageControl?.currentPage = self.currentIndex!
                    
                } else if (self.currentIndex == 0){
                    slideDeal(leftIndex: pageCount - 1, midlleIndex: currentIndex!, rightIndex: currentIndex! + 1)
                    self.pageControl?.currentPage = self.currentIndex!
                    
                } else {
                    slideDeal(leftIndex: currentIndex! - 1, midlleIndex: currentIndex!, rightIndex: currentIndex! + 1)
                    self.pageControl?.currentPage = self.currentIndex!
                }
            }
        } else if (self.dataSource?.count != 0 && pageCount == 1) {
            //只有一页
            if offset >= self.scrollerViewWidth! * 2 {
                //左滑动
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
            }
            if offset <= 0 {
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
            }
            
        } else if (self.dataSource?.count != 0 && pageCount == 2) {
            //只有两页
            if offset >= self.scrollerViewWidth! * 2 {
                //左滑动
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
                self.currentIndex = self.currentIndex! + 1
                if (self.currentIndex == 0) {
                    slideDeal(leftIndex: 1, midlleIndex: 0, rightIndex: 1)
                    self.pageControl?.currentPage = 0;
                } else if (self.currentIndex == 1) {
                    slideDeal(leftIndex: 0, midlleIndex: 1, rightIndex: 0)
                    self.pageControl?.currentPage = 1;
                    self.currentIndex = -1
                } else if (self.currentIndex == 2) {
                    slideDeal(leftIndex: 1, midlleIndex: 0, rightIndex: 1)
                    self.pageControl?.currentPage = 0;
                    self.currentIndex = 0
                }
            }
            if offset <= 0 {
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0);
                self.currentIndex = self.currentIndex! - 1
                //右滑动
                if (self.currentIndex == -2){
                    self.currentIndex = 0
                    slideDeal(leftIndex: 1, midlleIndex: 0, rightIndex: 1)
                    self.pageControl?.currentPage = 0
                    
                } else if (self.currentIndex == -1){
                    self.currentIndex = 1
                    slideDeal(leftIndex: 0, midlleIndex: 1, rightIndex: 0)
                    
                    self.pageControl?.currentPage = 1
                    
                } else if (self.currentIndex == 0){
                    slideDeal(leftIndex: 1, midlleIndex: 0, rightIndex: 1)
                    self.pageControl?.currentPage = 0
                }
            }
        }
    }
    //==============================
    //Mark:- 游戏列表显示处理函数
    //==============================
    func slideDeal(leftIndex:Int, midlleIndex: Int, rightIndex:Int) -> Void {
        tlPrint(message: "slideDeal leftIndex: \(leftIndex)    midlleIndex: \(midlleIndex)   rightIndex: \(rightIndex)")
        
        if leftListView != nil {
            leftListView?.removeFromSuperview()
        }
        if middleListView != nil {
            middleListView?.removeFromSuperview()
        }
        if rightListView != nil {
            rightListView?.removeFromSuperview()
        }
        tlPrint(message: "*****  pageCount:\(pageCount)")
    
        //处理只有一个或者两个页面的情况
        switch pageCount {
        case 1:
            self.scrollerView?.contentSize = CGSize(width: self.scrollerViewWidth!, height: self.scrollerViewHeight!)
        default:
            self.scrollerView?.contentSize = CGSize(width: self.scrollerViewWidth! * 3, height: self.scrollerViewHeight!)
        }
        leftListView = initListPage(index: leftIndex, pageLocation:0)
        middleListView = initListPage(index: midlleIndex, pageLocation:1)
        rightListView = initListPage(index: rightIndex, pageLocation:2)
    }
    
    
    //==============================
    //Mark:- 游戏列表的单个界面
    //==============================
    func initListPage(index: Int,pageLocation: Int) -> UIView {
        

        let frame = CGRect(x: CGFloat(pageLocation) * self.scrollerViewWidth!, y: 0, width:self.scrollerViewWidth!, height:self.scrollerViewHeight! )
        let listPage = UIView(frame: frame)
        scrollerView?.addSubview(listPage)
        
        tlPrint(message: "datasource.count = \(String(describing: dataSource?.count))")
        //获取当前屏幕的游戏个数
        let gameNumberInPage: Int = (dataSource!.count - ((index ) * gameNumPerPage)) > (gameNumPerPage - 1) ? (gameNumPerPage ) : (dataSource!.count % gameNumPerPage )
        tlPrint(message: "index = \(index), gameNumberInPage = \(gameNumberInPage)")
        
        for i in 0 ..< gameNumberInPage {
            let cellBtn = gameCellView(index: i,pageNumber: pageLocation)
            listPage.addSubview(cellBtn)
        }
        tlPrint(message: "current page finished")
        return listPage
    }
    
    //==============================
    //Mark:- 单个界面的单个游戏的入口视图
    //==============================
    func gameCellView(index: Int, pageNumber: Int) -> UIButton {
        
        let baseVC = BaseViewController()
        //tlPrint(message: "gameCellView(indext: \(index), pageNumber: \(pageNumber)")
        var width,height,x,y,labelTextSize: CGFloat!
        var btnImgName1,btnImgName2, imgName: String!
        var btnFrame, imgFrame, labelFrame: CGRect!
        var labelTextColor,btnBackColor: UIColor!
        var labelTextAligment: NSTextAlignment!
        if !isShowList {
            //图表显示
            width = (scrollerView!.frame.width - 5 * adapt_W(width: model.gameBtnDistLascap1)) / 4
            height = isPhone ? (scrollerView!.frame.height - 4 * adapt_H(height: model.gameBtnDistPortrait1)) / 2 : adapt_H(height: 120)
            x = adapt_W(width: model.gameBtnDistLascap1) + CGFloat(index % 4) * (width + adapt_W(width: model.gameBtnDistLascap1))
            y = adapt_H(height: model.gameBtnDistPortrait1 * 0.9) + CGFloat(index / 4) * (height + adapt_H(height: model.gameBtnDistPortrait1))
            
            btnImgName1 = "list_cell_bg.png"
            btnImgName2 = "list_cell_bg.png"
            btnFrame = CGRect(x: x, y: y, width: width, height: height)
            btnBackColor = UIColor.clear
            
            imgFrame = CGRect(x: adapt_W(width: 6), y: adapt_W(width: 6), width: width - adapt_W(width: 12), height: height - adapt_H(height: 36))
            
            labelFrame = CGRect(x: 0, y: height - adapt_H(height: 25), width: width, height: adapt_H(height: 15))
            labelTextColor = UIColor.white
            labelTextSize = model.gameTextSize1
            labelTextAligment = NSTextAlignment.center
            
        } else {
            //列表显示
            width = (scrollerView!.frame.width - 4 * adapt_W(width: model.gameBtnDistLascap2)) / 3
            height = isPhone ? (scrollerView!.frame.height - 15 * adapt_H(height: model.gameBtnDistPortrait2)) / 6 : adapt_H(height: 35)
            x = adapt_W(width: model.gameBtnDistLascap2) + CGFloat(index % 3) * (width + adapt_W(width: model.gameBtnDistLascap2))
            y = adapt_H(height: model.gameBtnDistPortrait2 * 3.5) + CGFloat(index / 3) * (height + adapt_H(height: model.gameBtnDistPortrait2))
            
            btnImgName1 = "list_listCell_bg.png"
            btnImgName2 = "list_listCell_bg.png"
            btnFrame = CGRect(x: x, y: y, width: width, height: height)
            btnBackColor = UIColor.clear
            
            imgFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
            imgName = ""
            
            labelFrame = CGRect(x: 0, y: 0, width: width, height: height)
            labelTextColor = UIColor.colorWithCustom(r: 199, g: 237, b: 255)
            labelTextSize = model.gameTextSize2    
            labelTextAligment = NSTextAlignment.center
        }
        

        //创建单个游戏按钮
        let cellBtn = UIButton(frame: btnFrame)
        cellBtn.backgroundColor = btnBackColor
        cellBtn.setBackgroundImage(UIImage(named: btnImgName1), for: .normal)
        cellBtn.setBackgroundImage(UIImage(named: btnImgName2), for: .highlighted)
        cellBtn.tag = 200 + pageNumber * gameNumPerPage + index
        cellBtn.addTarget(self, action: #selector(prepareToGame(sender:)), for: .touchUpInside)
        cellBtn.layer.shadowColor = UIColor.black.cgColor
        cellBtn.layer.shadowOffset = CGSize(width: 0, height: adapt_H(height: isPhone ? 5 : 3))
        cellBtn.layer.shadowOpacity = 0.3
        
        
        //创建图片视图
        let imgView = UIImageView(frame: imgFrame)
        cellBtn.addSubview(imgView)
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = model.gameBtnImgCorner
        //计算资源索引
        var page = currentIndex! + pageNumber - 1
        page = page >= self.pageCount ? 0 : page
        page = page < 0 ? self.pageCount - 1 : page
        let currentGameNumber: Int = page * gameNumPerPage + index
        //tlPrint(message: "game number: \(currentGameNumber)")
        if !isShowList {
            imgName = (dataSource![currentGameNumber] as! NSArray)[1] as! String
        }
        imgView.image = UIImage(named: imgName)
        
        //创建游戏名称
        let gameName = (dataSource![currentGameNumber] as! NSArray)[0] as! String
        let label = baseVC.labelCreat(frame: labelFrame, text: gameName, aligment: labelTextAligment, textColor: labelTextColor, backgroundcolor: .clear, fonsize: labelTextSize)
        cellBtn.addSubview(label)
        return cellBtn
    }
    
    //==============================
    //Mark:- 
    //==============================
    @objc func prepareToGame(sender:UIButton) -> Void {
        tlPrint(message: "sender.tag = \(sender.tag)")
        var page = currentIndex!
        page = page >= self.pageCount ? 0 : page
        page = page < 0 ? self.pageCount - 1 : page
        let currentGameNumber:Int = page * gameNumPerPage+sender.tag - gameNumPerPage - 200 + 1//200为tag的起始位置
        tlPrint(message: "currentIndex ＝ \(String(describing: currentIndex))     game number: \(currentGameNumber)")
        startGame(gameNumber: currentGameNumber)
    }
    
    //==============================
    //Mark:- 开始游戏
    //==============================
    func startGame(gameNumber:Int) -> Void {
        
        tlPrint(message: "game number: \(gameNumber)   game token: \(self.gameToken)")
        let gameId = (dataSource![gameNumber - 1] as! Array<String>)[2]
        if let token = self.gameToken {
            var url = "\(delegate.backGameLink())token=\(token)&gameId=\(gameId)"
            let gameType = userDefaults.value(forKey: userDefaultsKeys.gameType.rawValue) as! String
            tlPrint(message: "gameUrl:\(url)")
            let userName = userDefaults.value(forKey: userDefaultsKeys.userName.rawValue)as! String
            let passWord = userDefaults.value(forKey: userDefaultsKeys.passWord.rawValue)as! String

            switch gameType {
            case "BS":
                url = "\(delegate.backGameLink())&token=\(token)&gameId=\(gameId)"
            case "AV":
                url = "\(delegate.backGameLink())&token=\(token)&gameconfig=\(gameId)"
            case "PT":
                url = "\(delegate.backGameLink())&token=\(token)&gameconfig=\(gameId)"
            case "TTG":
                url = "\(delegate.backGameLink())&playerHandle=\(token)&gameId=\(gameId)&gameName=\((self.model.TTGDataSource[gameNumber - 1] as! Array<String>)[3])&gameType=0"
            case "SG":
                url = "\(delegate.backGameLink())&acctId=ft\(userName)&token=\(token)&game=\(gameId)"
            case "HB":
                url = "\(delegate.backGameLink())&token=\(token)&keyname=\(gameId)"
            case "MG":
                let xmanEndPoints = "https://xplay22.gameassists.co.uk/xman/x.x"
                url = "\(delegate.backGameLink())\(gameId)/zh-cn/?lobbyURL=&bankingURL=&username=ft\(userName)&password=\(passWord)&currencyFormat=%23%2C%23%23%23.%23%23&logintype=fullUPE&xmanEndPoints=\(xmanEndPoints)"
            case "PNG":
                url = "\(delegate.backGameLink())&gameid=\(gameId)&ticket=\(token)"
            case "newPT":
                url = "\(delegate.backGameLink())&gameCode=\(gameId)&ticket=\(token)"
//            case "AG":
//                tlPrint(message: "currentIndex = \(String(describing: currentIndex))")
//                url = "\(delegate.backGameLink())&gameCode=\(gameId)&ticket=\(token)"
                
            default:
                tlPrint(message: "no such game type")
            }
            tlPrint(message: "url:\(url)")
            delegate.prepareStartGame(url: url)
        }
        tlPrint(message: "gameToken: \(self.gameToken)")
    }
    
    
    //重新加载游戏列表页面 dataArray 为当前界面的游戏列表数据
    func reloadGameList(dataArray: Array<Int>) {
        tlPrint(message: "---------  reloadGameList dataArray:\(dataArray) ---------")
        var currentDataSource = model.BSDataSource
        let gameType = userDefaults.value(forKey: userDefaultsKeys.gameType.rawValue) as! String
        //增加游戏需要修改
        let dataSourceDic = ["newPT":model.newPTDataSource,"BS":model.BSDataSource,"PT":model.PTDataSource,"MG":model.MGDataSource,"TTG":model.TTGDataSource,"SG":model.SGDataSource,"HB":model.HBDataSource,"PNG":model.PNGDataSource]
        currentDataSource = dataSourceDic[gameType]!
        
        self.dataSource?.removeAllObjects()
        for i in 0 ..< dataArray.count {
            dataSource![i] = currentDataSource[dataArray[i]]
        }
        //选择当前每个界面的游戏个数
        self.gameNumPerPage = self.isShowList ? model.gameNumPerPage2 : model.gameNumPerPage1
        tlPrint(message: "dataSouce:\(String(describing: dataSource))")
        self.currentIndex = 0
        
        self.pageCount = (dataSource!.count + self.gameNumPerPage - 1) / self.gameNumPerPage
        self.pageControl?.numberOfPages = pageCount
        self.pageControl?.currentPage = 0
        slideDeal(leftIndex: pageCount - 1, midlleIndex: 0, rightIndex: 1)
    }
    
    
    
    
    func listView() -> UIView {
        tlPrint(message: "listView")
        let baseVC = BaseViewController()
        let listView = baseVC.viewCreat(frame: self.scrollerView!.frame, backgroundColor: UIColor.randomColor())
        
        return listView
    }
    
    func configurePageController() {
        tlPrint(message: "configurePageController")
        let pageWidth = adapt_W(width: isPhone ? 160 : 100)
         self.pageControl = UIPageControl(frame: CGRect(x: (scrollerViewWidth! - pageWidth) / 2,y: self.scrollerViewHeight! - adapt_H(height: isPhone ? 20 : 60),width: pageWidth,height: adapt_H(height: 20)))
        self.pageControl?.numberOfPages = pageCount
        self.pageControl?.isUserInteractionEnabled = false
        self.pageControl?.currentPageIndicatorTintColor = UIColor.colorWithCustom(r: 241, g: 124, b: 65)
        self.pageControl?.pageIndicatorTintColor = UIColor(red: 159/255, green: 11/255, blue: 67/255, alpha: 0.3)
        
        
        self.view.addSubview(self.pageControl!)
        tlPrint(message: "configurePageController 2")
        
    }
    
    
    
    func backCurrentClickPicture()-> NSInteger{
        tlPrint(message: "backCurrentClickPicture")
        return (self.pageControl?.currentPage)!
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
