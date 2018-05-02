//
//  RedPacketViewController.swift
//  FuTu
//
//  Created by Administrator1 on 28/2/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit
import AVFoundation

class RedPacketViewController: UIViewController,BtnActDelegate {
    
    var avAudioPlayer = AVAudioPlayer()
    var redPacketView:RedPacketView!
    let model = RedPacketModel()
    var alertMessage,startTime,endTime:String!
    var getBtnFlashTimer,timeoutTimer,leftTimeTimer:Timer!
    //    var getBtnFlashTimer,timeoutTimer,leftTimeTimer:Timer!
    var leftRedPacketNumber = 0, sendRedPacketCount = 0
    var indecator:TTIndicators!
    var redInfoDic:Dictionary<String,Any>!
    var haveStart = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.redPacketView = RedPacketView(frame: self.view.frame,haveStart:self.haveStart, rootVC: self)
        
        self.view.addSubview(self.redPacketView)
        
        //        self.timePointFlash = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(self.redPacketView.refreshTimePoint), userInfo: nil, repeats: true)
        //        self.timePointFlash = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.refreshTimePoint), userInfo: nil, repeats: true)
        
        
        self.getInfo(isFromDidLoad: true, finish: { (nil) in
            tlPrint(message: "alertType:nil")
        })
    }
    
    
    init(haveStart:Bool) {
        super.init(nibName: nil, bundle: nil)
        self.haveStart = haveStart
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.redPacketView.redPacketTimer.invalidate()
    }
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    var lastRequestDate:Date!
    func btnAct(btnTag: Int) {
        tlPrint(message: "btnAct")
        switch btnTag {
        case redPacketTag.backBtnTag.rawValue:
            
            self.timerInvalidate()
            
            _ = self.navigationController?.popViewController(animated: true)
        case redPacketTag.getBtnTag.rawValue:
            tlPrint(message: "点击了抢红包按钮")
            //已经抢过红包，判断是否未超过5秒
            if lastRequestDate != nil {
                let currentDate = Date()
                if currentDate.timeIntervalSinceReferenceDate - lastRequestDate.timeIntervalSinceReferenceDate <= 5 {
                
                    tlPrint(message: "很遗憾，您未能抢到红包！")
                    self.redPacketView.initAlertView(type: .finish, startTime: nil, redPacketAmount: nil, redPacketCount: nil, message: "很遗憾，您未能抢到红包！")
                    return
                }
            }
            
            let getBtn = self.redPacketView.viewWithTag(btnTag) as! UIButton
            getBtn.isUserInteractionEnabled = false
            if indecator == nil {
                indecator = TTIndicators(view: self.view, frame: portraitIndicatorFrame)
            }
            indecator.play(frame: portraitIndicatorFrame)
            self.getInfo(isFromDidLoad: false, finish: { (alertType, amount) in
                tlPrint(message: "alertType:\(String(describing: alertType)), amount:\(String(describing: amount))")
                self.indecator.stop()
                self.lastRequestDate = Date()
                
                self.redPacketView.initAlertView(type: alertType!, startTime: self.startTime, redPacketAmount: amount, redPacketCount: self.leftRedPacketNumber, message: self.alertMessage)
                getBtn.isUserInteractionEnabled = true
            })
        default:
            tlPrint(message: "no such case!")
        }
    }
    
    func getInfo(isFromDidLoad:Bool, finish:@escaping((redPacketAlertType?,String?)->())) -> Void {
        tlPrint(message: "getInfo")
        self.model.getRedPacketInfo(success: { (responseDic) in
            tlPrint(message: "responseDic = \(responseDic)")
            
            //test data
//            let responseDic = ["endTime": "2017-10-13T12:00:00", "startTime": "2017-10-11T10:11:00", "totalCount":10000, "sentRedbagCount": 9, "haveRedbag": false, "msg": "抢红包进行中....！"] as [String : Any]
            self.redInfoDic = responseDic
            self.startTime = responseDic["startTime"] as! String
            self.startTime = self.startTime.replacingOccurrences(of: "T", with: " ")
            
            self.endTime = responseDic["endTime"] as! String
            self.endTime = self.endTime.replacingOccurrences(of: "T", with: " ")
            
            self.model.redPacketStartTime = self.startTime
            self.sendRedPacketCount = responseDic["sentRedbagCount"] as! Int
            self.alertMessage = responseDic["msg"] as! String
            
            //            let leftTime = self.model.timeIntervalCalculate( end: self.startTime)
            let (_,leftTime) = self.model.timeIntervalCalculate(start: self.startTime, end: self.endTime)
            
            tlPrint(message: "leftTime\(leftTime)")
            let dateArray = self.model.changeDateDicToArray(dateDic: leftTime)
            let timeArray = self.model.separateDate(date: dateArray)
//            self.redPacketView.reloadLeftTimer(newTimeArray: timeArray)
            if isFromDidLoad {
                //开启刷新定时器
                self.leftTimeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(self.leftTimeTimerAct), userInfo: nil, repeats: true)
                finish(nil,nil)
            } else {
                let haveRedbag_t = responseDic["haveRedbag"]
                tlPrint(message: "haveRedbag_t = \(String(describing: haveRedbag_t))")
                if haveRedbag_t as! Bool {
                    tlPrint(message: "可以领取红包")
                    //获取红包金额
                    
                    self.model.getRedPacketAccount(success: { (amountDic) in
                        tlPrint(message: "获取红包金额成功")
                        
                        self.alertMessage = amountDic["msg"] as! String
                        if (amountDic["Amount"]as! Int) <= 0 {
                            finish(.finish,nil)
                        } else {
                            finish(.success,"\(amountDic["Amount"]!)")
                        }
                        
                        //播放爆炸音乐
                        if let soundURL = Bundle.main.url(forResource: "eggBombMusic", withExtension: "mp3") {
                            do {
                                self.avAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                                self.avAudioPlayer.prepareToPlay()
                                self.avAudioPlayer.play()
                            } catch {
                                tlPrint(message: "播放金蛋爆炸音乐错误")
                            }
                        }
                    }, failure: {
                        tlPrint(message: "获取红包金额失败")
                    })
                    
                } else {
                    tlPrint(message: "暂时不可以领取红包'")
                    let finishStatus = (responseDic["msg"] as! String).components(separatedBy: "结束")
                    if finishStatus.count > 1 {
                        finish(.finish,nil)
                    } else {
                        finish(.later,nil)
                    }
                }
            }
            tlPrint(message: "timeArray:\(timeArray)")
        }, failure: {
            tlPrint(message: "get red packet info failure")
        })
    }
    
    
    var isClearPoint = false
    func leftTimeTimerAct() -> Void {
        
        tlPrint(message: "leftTimeTimerAct  is from detail page:")
        let leftTimeImg = self.redPacketView.viewWithTag(redPacketTag.zeroTimeImgTag.rawValue) as! UIImageView
        leftTimeImg.isHidden = isClearPoint
        self.isClearPoint = !isClearPoint
        self.getBtnFlashAct()
        
//        let (haveStart,timeIntervalDic) = self.model.timeIntervalCalculate(start: self.startTime, end: self.endTime)
//        let timeArray = self.model.separateDate(date: self.model.changeDateDicToArray(dateDic: timeIntervalDic))
//        self.redPacketView.reloadLeftTimer(newTimeArray: timeArray)
//        
//        if !haveStart {
//            //            SystemTool.systemSound(soundNumber: 1103)
//            self.redPacketView.reloadRedNumLabel(number: self.redInfoDic["totalCount"] as! Int)
//        }
//        //时间中间的点进行闪烁
//        for i in 0 ..< 2 {
//            let pointLabel = self.redPacketView.bombImg.viewWithTag(redPacketTag.leftTimePointTag.rawValue + i) as! UILabel
//            pointLabel.textColor = self.isClearPoint ? UIColor.colorWithCustom(r: 255, g: 48, b: 15) : UIColor.clear
//        }
//        
//        self.isClearPoint = !isClearPoint
//        tlPrint(message: "timeIntervalDic:\(timeIntervalDic)")
//        if haveStart {
//            tlPrint(message: "时间已经到了")
//            let redBombBackImg = self.redPacketView.bombImg.viewWithTag(redPacketTag.redBombBackImgTag.rawValue) as! UIImageView
//            redBombBackImg.image = UIImage(named: "redPaket_bomb_timeBg_left.png")
////            self.redPacketView.reloadTimerFrame()
//            //红包已经开始以后
//            self.timeoutTimerAct(timeArray:timeArray)
//            if getBtnFlashTimer == nil {
//                self.getBtnFlashAct()
//                self.getBtnFlashTimer = Timer.scheduledTimer(timeInterval: 1.6, target: self, selector:#selector(self.getBtnFlashAct), userInfo: nil, repeats: true)
//            }
//            //            //快速滴答声
//            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
//            //                SystemTool.systemSound(soundNumber: 1103)
//            //            }
//            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//            //                SystemTool.systemSound(soundNumber: 1103)
//            //            }
//            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            //                SystemTool.systemSound(soundNumber: 1103)
//            //            }
//        }
    }
    
//    func timeoutTimerAct(timeArray:Array<Int>) -> Void {
//        tlPrint(message: "timeoutTimerAct")
//        
//        for i in 0 ..< 7 {
//            let leftLabel = self.redPacketView.bombImg.viewWithTag(redPacketTag.leftTimeTag.rawValue + i) as! UILabel
//            leftLabel.text = "\(timeArray[i])"
//        }
//        //时间中间的点进行闪烁
//        for i in 0 ..< 2 {
//            let pointLabel = self.redPacketView.bombImg.viewWithTag(redPacketTag.leftTimePointTag.rawValue + i) as! UILabel
//            pointLabel.textColor = (self.isClearPoint ? UIColor.colorWithCustom(r: 255, g: 48, b: 15) : UIColor.clear)
//        }
//        
//        //修改剩余红包个数
//        
//        if self.isClearPoint {
//            return
//        }
//        
//        let totle = self.redInfoDic["totalCount"] as! Int
//        var start = self.redInfoDic["startTime"] as! String
//        start = start.replacingOccurrences(of: "T", with: " ")
//        var end = self.redInfoDic["endTime"] as! String
//        end = end.replacingOccurrences(of: "T", with: " ")
//        leftRedPacketNumber = self.model.leftRedbagNumber(totleNum: totle, startTime: start, endTime: end)
//        let leastNumber = Int(CGFloat(totle) * model.leastRedPaket + 0.5)
//        if leftRedPacketNumber <= leastNumber {
//            self.timerInvalidate()
//        }
////        self.redPacketView.reloadRedNumLabel(number: leftRedPacketNumber)
//    }
    
    func getBtnFlashAct() -> Void {
        tlPrint(message: "getBtnFlashAct")
        
        let getImg = self.redPacketView.viewWithTag(redPacketTag.getBtnTag.rawValue) as! UIButton
        
        DispatchQueue.main.async {
            getImg.setImage(UIImage(named:"redPacket_getButton2.png"), for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                getImg.setImage(UIImage(named:"redPacket_getButton1.png"), for: .normal)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                getImg.setImage(UIImage(named:"redPacket_getButton2.png"), for: .normal)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                getImg.setImage(UIImage(named:"redPacket_getButton1.png"), for: .normal)
            }
        }
        tlPrint(message: "getBtnFlashAct finished")
    }
    
    
    func timerInvalidate() -> Void {
        
        if self.getBtnFlashTimer != nil {
            self.getBtnFlashTimer.invalidate()
        }
        if self.leftTimeTimer != nil {
            self.leftTimeTimer.invalidate()
        }
        if self.timeoutTimer != nil {
            self.timeoutTimer.invalidate()
        }
        
    }
    
//    //时间分隔字符闪烁函数
//    func refreshTimePoint() -> Void {
//        tlPrint(message: "refreshTimePoint")
//        for i in 0 ..< 2{
//            let pointLabel = self.redPacketView.bombImg.viewWithTag(redPacketTag.leftTimePointTag.rawValue + i) as! UILabel
//            //            pointLabel.textColor = UIColor.clear
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                pointLabel.textColor = UIColor.clear
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
//                pointLabel.textColor = UIColor.colorWithCustom(r: 255, g: 48, b: 15)
//            }
//        }
//    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
