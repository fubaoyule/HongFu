//
//  ServiceSearchView.swift
//  FuTu
//
//  Created by Administrator1 on 9/1/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

class ServiceSearchView: UIView {

    var searchBar:UISearchBar!
    var tableView:UITableView!
    
    var delegate: BtnActDelegate!
    var searchDelegate:UISearchBarDelegate!
    var tableDelegate:UITableViewDelegate!
    var tableDataSource:UITableViewDataSource!
    var width,height: CGFloat!
    let model = ServiceSearchModel()
    let baseVC = BaseViewController()
    init(frame:CGRect, param:AnyObject,rootVC:UIViewController) {
        super.init(frame: frame)
        self.width = frame.width
        self.height = frame.height
        self.backgroundColor = UIColor.white
        self.tableDelegate = rootVC as! UITableViewDelegate
        self.tableDataSource = rootVC as! UITableViewDataSource
        self.searchDelegate = rootVC as! UISearchBarDelegate
        self.delegate = rootVC as! BtnActDelegate
        
        initSearchView()
        
        
    }
    
    func initSearchView() -> Void {
        //back button
        let backFrame = CGRect(x: adapt_W(width: 0), y: isPhone ? 25 : 10, width: adapt_W(width: 40), height: adapt_H(height: 40))
        let backBtn = self.baseVC.buttonCreat(frame: backFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"service_back2.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.addSubview(backBtn)
        backBtn.tag = ServiceSearchTag.backBtnTag.rawValue
        
        //搜索框
        self.searchBar = UISearchBar(frame: CGRect(x: adapt_W(width: 40), y: isPhone ? 25 : 10, width: width - adapt_W(width: 50), height: adapt_H(height: 50)))
        //设置代理
        self.searchBar.delegate = self.searchDelegate
        self.searchBar.placeholder = "请输入问题关键字，如：取款"
//        self.searchBar.barTintColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
//        self.searchBar.tintColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
//        self.searchBar.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        self.searchBar.barStyle = .default
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.subviews.first?.subviews.last?.backgroundColor = UIColor.white
        self.searchBar.returnKeyType = .search
        
        
        
        
        
        self.addSubview(searchBar)
        
        backBtn.center.y = self.searchBar.center.y
        //line view
        let line = baseVC.viewCreat(frame: CGRect(x: 0, y: adapt_H(height: 75), width: width, height: adapt_H(height: 0.5)), backgroundColor: .colorWithCustom(r: 177, g: 177, b: 177))
        self.addSubview(line)
        
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: isPhone ? adapt_H(height: 70) : adapt_H(height: 50), width: self.frame.width, height: height - adapt_H(height: 65)), style: .plain)
        self.tableView.separatorStyle = .none//去掉cell之间的横线
        //设置代理
        self.tableView.delegate = self.tableDelegate
        self.tableView.dataSource = self.tableDataSource
        // 注册TableViewCell
        self.tableView.register(UITableViewCell.self,
                                forCellReuseIdentifier: "SwiftCell")
        self.addSubview(tableView)
        
        
        
        
    }
    
    @objc func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAction")
        delegate.btnAct(btnTag: sender.tag)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
