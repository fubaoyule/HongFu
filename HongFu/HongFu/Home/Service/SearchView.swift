//
//  SearchView.swift
//  FuTu
//
//  Created by Administrator1 on 22/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class SearchView: UIView {

    var delegate: serviceDelegate!
    var textFeildDelegate: UITextFieldDelegate!
    var answerScroll:UIScrollView!
    var tableView:UITableView!
    var scrollDelegate: UIScrollViewDelegate!
    var width,height: CGFloat!
    let model = ServiceModel()
    var tableDelegate:UITableViewDelegate!
    var tableDataSource:UITableViewDataSource!
    
    let baseVC = BaseViewController()
    
    init(frame:CGRect, param:AnyObject,rootVC:UIViewController) {
        super.init(frame: frame)
        self.width = frame.width
        self.height = frame.height
        self.backgroundColor = UIColor.white
        self.scrollDelegate = rootVC as! UIScrollViewDelegate
        self.textFeildDelegate = rootVC as! UITextFieldDelegate
        self.delegate = rootVC as! serviceDelegate
        
        self.tableDelegate = rootVC as! UITableViewDelegate
        self.tableDataSource = rootVC as! UITableViewDataSource
        
        
        
        initTitleView()
        
        //initAnswerTable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func initTitleView() -> Void {
        //back button
        let backFrame = CGRect(x: adapt_W(width: 0), y: adapt_H(height: 40), width: adapt_W(width: 40), height: adapt_H(height: 40))
        let backBtn = baseVC.buttonCreat(frame: backFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"service_back2.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.addSubview(backBtn)
        backBtn.tag = serviceTag.SearchBackBtn.rawValue
        //input text
        let inputFrame = CGRect(x: adapt_W(width: 48), y: adapt_H(height: 40), width: adapt_W(width: 240), height: adapt_H(height: 23))
        let inputFeild = baseVC.textFieldCreat(frame: inputFrame, placeholderText: "请输入问题关键字，如：取款", aligment: .left, fonsize: fontAdapt(font: 16), borderWidth: 0, borderColor: .clear, tag: serviceTag.SearchInputTextFeild.rawValue)
        self.addSubview(inputFeild)
        inputFeild.delegate = textFeildDelegate
        //question button
        let quesFrame = CGRect(x: width - adapt_W(width: 80), y: adapt_H(height: 30), width: adapt_W(width: 80), height: adapt_H(height: 30))
        let quesBtn = baseVC.buttonCreat(frame: quesFrame, title: "常见问题", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: 16), events: .touchUpInside)
        quesBtn.setTitleColor(UIColor.colorWithCustom(r: 27, g: 123, b: 233), for: .normal)
        quesBtn.setTitleColor(UIColor.colorWithCustom(r: 177, g: 177, b: 177), for: .highlighted)
        quesBtn.tag = serviceTag.SearchQuesBtn.rawValue
        self.addSubview(quesBtn)
        quesBtn.center.y = inputFeild.center.y
        backBtn.center.y = inputFeild.center.y
        //line view
        let line = baseVC.viewCreat(frame: CGRect(x: 0, y: adapt_H(height: 75), width: width, height: adapt_H(height: 0.5)), backgroundColor: .colorWithCustom(r: 177, g: 177, b: 177))
        self.addSubview(line)
        
        
    }
    
    
    func initAnswerTable(quesTag:Int) -> Void {
        tlPrint(message: "initAnswerScroll: \n")
        if self.tableView != nil {
            let childrenViews = tableView.subviews
            for children in childrenViews {
                children.removeFromSuperview()
            }
            tableView.removeFromSuperview()
            tableView = nil
        }
        //scroll
        let answerFrame = CGRect(x: 0, y: adapt_H(height: 100), width: width, height: height - adapt_H(height: 100))
        
        tableView = UITableView(frame: answerFrame, style: .plain)
        self.addSubview(tableView)
    }
    
    
    
    func initAnswerScroll(infos:[Array<String>]) -> Void {
        tlPrint(message: "initAnswerScroll: \n\(infos)")
        if answerScroll != nil {
            let childrenViews = answerScroll.subviews
            for children in childrenViews {
                children.removeFromSuperview()
            }
            answerScroll.removeFromSuperview()
            answerScroll = nil
        }
        //scroll
        let answerFrame = CGRect(x: 0, y: adapt_H(height: 100), width: width, height: height - adapt_H(height: 100))
        
        answerScroll = baseVC.scrollViewCreat(frame: answerFrame, delegate: scrollDelegate, contentSize: CGSize(width: width, height: height / 2), showsIndicatorV: false, showsIndecatorH: false, backColor: .clear)
        self.addSubview(answerScroll)

        
        
        for i in 0 ... infos.count - 1 {
            let textWord = infos[i][0] as NSString
            let wordSize = textWord.size(withAttributes: [NSAttributedStringKey.font :  UIFont.systemFont(ofSize: fontAdapt(font: 14))])
            let quesBtn = UIButton()
            quesBtn.addTarget(self, action: #selector(self.btnAct(sender:)), for: .touchUpInside)
            quesBtn.setTitle(textWord as String, for: .normal)
            quesBtn.titleLabel?.font = UIFont.systemFont(ofSize: fontAdapt(font: 14))
            quesBtn.titleLabel?.textAlignment = .left
            quesBtn.setTitleColor(UIColor.colorWithCustom(r: 0, g: 101, b: 215), for: .normal)
            self.answerScroll.addSubview(quesBtn)
            quesBtn.tag = serviceTag.SearchAnserBtn.rawValue + i
            if i == 0 {
                quesBtn.frame = CGRect(x: adapt_W(width: isPhone ? 18 : 25), y: adapt_H(height: 20 + CGFloat(i) * 30), width: wordSize.width + adapt_W(width: 5), height: adapt_H(height: 25))
            } else {
                let lastInfoText = self.viewWithTag(serviceTag.SearchAnserInfoText.rawValue + i - 1) as! UITextView
                tlPrint(message: "lastInfoText: \(lastInfoText)")
                quesBtn.mas_makeConstraints({ (make) in
                    _ = make?.top.equalTo()(lastInfoText.mas_bottom)
                    _ = make?.left.equalTo()(adapt_W(width: isPhone ? 18 : 25))
                    _ = make?.width.equalTo()(wordSize.width + adapt_W(width: 5))
                    _ = make?.height.equalTo()(adapt_H(height: 25))
                })
            }
            TPrint(message: "********   &&&\(i)   *******")
            
            tlPrint(message: "********   &&&\(i)   *******")
            //answer textView
            let answerInfo = UITextView()
            self.answerScroll.addSubview(answerInfo)
            answerInfo.mas_makeConstraints({ (make) in
                _ = make?.top.equalTo()(quesBtn.mas_bottom)
                _ = make?.left.equalTo()(quesBtn.mas_left)
                _ = make?.width.equalTo()(self.width)
                _ = make?.height.equalTo()(0)
            })
            
            answerInfo.tag = serviceTag.SearchAnserInfoText.rawValue + i
            answerInfo.backgroundColor = UIColor.colorWithCustom(r: 244, g: 244, b: 244)
            answerInfo.isEditable = false
            answerInfo.isSelectable = true
            answerInfo.textColor = UIColor.colorWithCustom(r: 129, g: 129, b: 129)
            answerInfo.font = UIFont.systemFont(ofSize: fontAdapt(font: 15))
            answerInfo.textAlignment = .center
            
            answerInfo.isUserInteractionEnabled = true
            answerInfo.isScrollEnabled = true
            answerInfo.showsHorizontalScrollIndicator = false
            answerInfo.showsVerticalScrollIndicator = true
            tlPrint(message: "info:\(infos[i][1])")
            answerInfo.text = "\n\(infos[i][1])\n"
        }
    }
    
    func showSearchAnswerInfo(btnTag: Int) -> Void {
        tlPrint(message: "showSearchAnswerInfo btnTag: \(btnTag)")
    }
    
    
    @objc func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAction")
        delegate.searchBtnAct(btnTag: sender.tag)
    }
    
    

}
