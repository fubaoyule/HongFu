//
//  TableViewController.swift
//  RelaxSwift
//
//  Created by xx11dragon on 16/6/22.
//  Copyright © 2016年 xx11dragon. All rights reserved.
//

import UIKit

typealias TableViewControllerBlock = (Int)->()

class TableViewController: UITableViewController {
    var selectEvent: TableViewControllerBlock?
    let textItems = ["鸿福首页","充值中心","平台转账","优惠活动","VIP特权","在线客服","个人信息"]
    let imgItems = ["home","recharge","transfer","preferent","VIP","sevice","self"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: kDeviceWidth() * 0.75, height: kDeviceHeight())
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.view.backgroundColor = UIColor.colorWithCustom(r: 31, g: 34, b: 38)
//        self.view.frame = CGRect(x: 0, y: adapt_H(height: 170), width: kDeviceWidth(), height: kDeviceHeight())
        self.setUpHeaderView()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textItems.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return adapt_H(height: isPhone ? 50 : 35)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let UItableViewCellIndetity = "MenuUItableViewCellIndetity"
        var cell:TableViewCell!
        if (cell == nil) {
            cell = TableViewCell(style: .default, reuseIdentifier: UItableViewCellIndetity)
        }
        cell.textArray = textItems
        cell.imgArray = imgItems
        cell.index = indexPath.row
        tableView.separatorStyle = .none
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectEvent?(indexPath.row)
    }
    
    func setUpHeaderView() {
        let headView = UIImageView()
        headView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:adapt_H(height: isPhone ? 170 : 120))
        headView.backgroundColor = UIColor.lightGray
        self.tableView.tableHeaderView = headView
        //background image
        let headBgImg = UIImageView(frame: headView.frame)
        headBgImg.image = UIImage(named: "Menu_headbg.png")
        headView.addSubview(headBgImg)
        //head image
        let headWidth = adapt_W(width: isPhone ? 87 : 50)
        let headImg = UIImageView(frame: CGRect(x: (self.view.frame.width - headWidth) / 2, y: adapt_H(height: 40), width: headWidth, height: headWidth))
        headImg.image = UIImage(named: "Menu_headImg.png")
        headBgImg.addSubview(headImg)
        
    }
    
    func setFooterView() -> Void {
        let headView = UIImageView()
        headView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:adapt_H(height: isPhone ? 50 : 30))
        headView.backgroundColor = UIColor.lightGray
        self.tableView.tableHeaderView = headView
    }

}
