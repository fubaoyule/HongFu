//
//  MessageViewController.swift
//  FuTu
//
//  Created by Administrator1 on 29/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

protocol messageDelegate {
    func messageBtnAct(btnTag:Int)
    func messageTapAct(tapTag:Int)
}

class MessageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,messageDelegate {

    var messageView:MessageView!
    var messageType:MessageType!
    var dataSource:[[String:Any]]!
    let model = MessageModel()
    var allMessageInfo:[[String:Any]]! = [["Id":0,"UserId":"","AlreadyRead":true,"Content":"","Created":""]]
    override func viewDidLoad() {
        super.viewDidLoad()
//        getAllMessageInfo {
//            
//            self.getActivityInfo{
//                if self.messageView != nil {
//                    self.messageView.infoTable.reloadData()
//                    return
//                } else {
//                    tlPrint(message: "视图还没有初始化")
//                }
//            }
//        }

        
        
        self.dataSource = model.changeDataSource(messageType: messageType)
        
        
        tlPrint(message: "dataSource:\(dataSource)")
        self.messageView = MessageView(frame: self.view.frame, messageType: self.messageType, rootVC: self)
        self.view.addSubview(messageView)
        
        
        if self.messageType == MessageType.Activity {
            let activeBtn = self.messageView.viewWithTag(MessageTag.MessageTabBtnTag.rawValue) as! UIButton
            activeBtn.isUserInteractionEnabled = false
            self.getAllMessageInfo {
                activeBtn.isUserInteractionEnabled = true
            }
        } else {
            let messageBtn = self.messageView.viewWithTag(MessageTag.ActivityTabBtnTag.rawValue) as! UIButton
            messageBtn.isUserInteractionEnabled = false
            self.getActivityInfo {
                messageBtn.isUserInteractionEnabled = true
            }
        } 
    }
    
    init(messageType:MessageType) {
        super.init(nibName: nil, bundle: nil)
        self.messageType = messageType
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func getAllMessageInfo(success:@escaping(()->())) -> Void {
        //self.allMessageInfo = [["Id":0,"UserId":"","AlreadyRead":true,"Content":"","Created":""]]
        self.view.isUserInteractionEnabled = false
//        model.getSysMsg { (sysMsg) in
//            tlPrint(message: "系统消息:\(sysMsg)")
//            
//            for sysValue in sysMsg {
//                if sysValue["Id"] != nil {
//                    self.allMessageInfo.append(sysValue)
//                }
//            }
//            self.model.getInternalMsg { (internalMsg) in
//                tlPrint(message: "站内信消息:\(internalMsg)")
//                
//                
//                
//                for internalValue in internalMsg {
//                    if internalValue["Id"] != nil {
//                        self.allMessageInfo.append(internalValue)
//                    }
//                    
//                }
//                self.allMessageInfo.remove(at: 0)
//                tlPrint(message: "self.allMessageInfo:\(self.allMessageInfo)")
//                
//                self.model.messageDataSource = self.allMessageInfo
//                //self.dataSource = self.allMessageInfo
//                
//                
//                userDefaults.set(self.allMessageInfo, forKey: userDefaultsKeys.messageInfo.rawValue)
//                self.dataSource = self.model.changeDataSource(messageType: self.messageType)
//                success()
//                self.view.isUserInteractionEnabled = true
//            }
//        }
//        
//        model.getInternalMsgCount { (account) in
//            tlPrint(message: "未读站内信条数:\(account)")
//        }
        
        //不再获取系统消息，只获取站内信
        self.model.getInternalMsg { (internalMsg) in
            tlPrint(message: "站内信消息:\(internalMsg)")
            for internalValue in internalMsg {
                if internalValue["Id"] != nil {
                    self.allMessageInfo.append(internalValue)
                }
                
            }
            self.allMessageInfo.remove(at: 0)
            tlPrint(message: "self.allMessageInfo:\(self.allMessageInfo)")
            
            self.model.messageDataSource = self.allMessageInfo
            //self.dataSource = self.allMessageInfo
            
            
            userDefaults.set(self.allMessageInfo, forKey: userDefaultsKeys.messageInfo.rawValue)
            self.dataSource = self.model.changeDataSource(messageType: self.messageType)
            success()
            self.view.isUserInteractionEnabled = true
        }
        
        model.getInternalMsgCount { (account) in
            tlPrint(message: "未读站内信条数:\(account)")
        }
    }
    
    func getActivityInfo(success:@escaping(()->())) -> Void {
        tlPrint(message: "getActivityInfo)")
        self.view.isUserInteractionEnabled = false
        model.getActivityInfo { (activityInfo) in
            tlPrint(message: "activityInfo:\(activityInfo)")
            self.model.activityDataSource = activityInfo
            userDefaults.set(activityInfo, forKey: userDefaultsKeys.activityInfo.rawValue)
            self.dataSource = self.model.changeDataSource(messageType: self.messageType)
            success()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func messageBtnAct(btnTag: Int) {
        tlPrint(message: "messageBtnAct  btnTag = \(btnTag)")
        
        switch btnTag {
        case MessageTag.MessageBtnTag.rawValue:
            _ = self.navigationController?.popViewController(animated: true)
            
        default:
            if btnTag >= MessageTag.ActivityTabBtnTag.rawValue {
                tlPrint(message: "tab button")
                var type:MessageType!
                switch btnTag - MessageTag.ActivityTabBtnTag.rawValue {
                case 0:
                    type = MessageType.Activity
                    messageView.infoTable.backgroundColor = UIColor.white
                default:
                    type = MessageType.SystemMessage
                    messageView.infoTable.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
                }
                self.messageType = type
                self.dataSource = model.changeDataSource(messageType: messageType)
                if self.model.messageDataSource == nil {
                    self.getAllMessageInfo {
                        self.messageView.infoTable.reloadData()
                        return
                    }
                }
                messageView.infoTable.reloadData()
                
            } else {
                tlPrint(message: "no such case")
            }
        }
    }
    
    func messageTapAct(tapTag: Int) {
        tlPrint(message: "messageTapAct tapTag:\(tapTag)")
//        self.model.getActivityInfo { (activityInfo) in
//            tlPrint(message: "activityInfo:\(activityInfo)")
//        }
        let index = tapTag - MessageTag.ActiVityImgTag.rawValue
        tlPrint(message: "*** .TT. ***")
        if dataSource == nil {
            tlPrint(message: "当前还没有数据")
            return
        }
        let selectedInfo = self.dataSource[index]
        tlPrint(message: "selectedInfo:\(selectedInfo)")
//        let detailVC = ActivityDetailViewController(selecedInfo: selectedInfo as AnyObject)
//        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    //****************************************
    //      TablView delegate
    //****************************************
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tlPrint(message: "numberOfRowsInSection")
        if self.dataSource == nil {
            return 0
        }
        return self.dataSource.count
    }
    //返回行高
    var currentCellHeight:CGFloat!
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tlPrint(message: "heightForRowAt indexPath:\(indexPath)")
        var cellHeight:CGFloat = adapt_H(height: isPhone ? 100 : 80)
        if dataSource == nil {
            return 0
        }
        if messageType == MessageType.SystemMessage {
            
            let characters = (dataSource[indexPath[1]]["Content"] as! String).characters.count
            if characters >= (isPhone ? 40 : 60) {
//                cellHeight += ((CGFloat(characters - 40) / 20) * adapt_H(height: 50))
                cellHeight += (isPhone ? ((CGFloat(characters - 40) / 20) * adapt_H(height: 50)) : ((CGFloat(characters - 60) / 30) * adapt_H(height: 80)))
            }
        }
        //currentCellHeight = cellHeight
        return cellHeight
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tlPrint(message: "-----------  cellForRowAt \(indexPath)")
        tlPrint(message: "&*&*&**&*&*&*&*&*&   self.dataSource:\(self.dataSource)")
        
        var cell:MessageTableViewCell!
        var cellHeight:CGFloat = adapt_H(height: isPhone ? 100 : 80)
        if messageType == MessageType.SystemMessage {
            if self.dataSource != nil {
                let characters = (dataSource[indexPath[1]]["Content"] as! String).characters.count
                if characters >= (isPhone ? 40 : 60) {
                    cellHeight += (isPhone ? ((CGFloat(characters - 40) / 20) * adapt_H(height: 50)) : ((CGFloat(characters - 60) / 30) * adapt_H(height: 80)))
                }
            }
        }
        if cell == nil {
            if self.dataSource != nil {
                cell = MessageTableViewCell(cellHeight: cellHeight,messageType: self.messageType, info: dataSource[indexPath[1]], index: indexPath[1],rootVC:self)
                if self.messageType == MessageType.SystemMessage {
                    if dataSource[indexPath[1]]["AlreadyRead"] as? Bool == false {
                        dataSource[indexPath[1]]["AlreadyRead"] = false
                        let id = dataSource[indexPath[1]]["Id"]
                        futuNetworkRequest(type: .get, serializer: .http, url: "Message/MarkAsRead", params: ["messageId":id ?? 0], success: { (response) in
                            tlPrint(message: "response:\(response)")
                            self.getAllMessageInfo {
                                
                            }
                        }, failure: { (error) in
                            tlPrint(message: "error:\(error)")
                        })
                    }
                }
            }
        }
        tableView.separatorStyle = .singleLine
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tlPrint(message: "didSelectRowAt:\(indexPath[1])")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
