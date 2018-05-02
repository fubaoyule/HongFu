//
//  LotteryView.swift
//  FuTu
//
//  Created by Administrator1 on 18/10/17.
//  Copyright © 2017年 Taylor Tan. All rights reserved.
//

import UIKit

class LotteryView: UIView {

    
    var scroll:UIScrollView!
    var height,width:CGFloat!
    var delegate:BtnActDelegate!
    let baseVC = BaseViewController()
    var selectedNumberArray: Array<Int>!//动态修改的号码数组
    var lotteryTimer:Timer!
    
    var unselectView,selectView:UIView!
    init(frame:CGRect,rootVC:UIViewController) {
        super.init(frame: frame)
        self.width = frame.width
        self.height = frame.height
        self.delegate = rootVC as! BtnActDelegate
        self.backgroundColor = UIColor.black
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        self.initScrollView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initScrollView() -> Void {
        
        scroll = UIScrollView(frame: frame)
        self.addSubview(scroll)
        let scrollContentHeight:CGFloat = self.height + adapt_H(height: 0.3)
        tlPrint(message: "*** scrollContentHeight:  \(scrollContentHeight)")
        scroll.contentSize = CGSize(width: frame.width, height: scrollContentHeight)
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        self.initLotteryView()
        self.initBackBtn()
    }
    
    func initBackBtn() {
        //back button
        let backBtnFrame = CGRect(x: adapt_W(width: isPhone ? 12 : 10), y: adapt_H(height: isPhone ? 25 : 20), width: adapt_W(width: isPhone ? 35 : 25), height: adapt_W(width: isPhone ? 35 : 25))
        let backBtn = baseVC.buttonCreat(frame: backBtnFrame, title: "", alignment: .center, target: self, myaction: #selector(btnAct(sender:)), normalImage: UIImage(named: "lobby_PT_back.png"), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
        self.insertSubview(backBtn, at: 1)
        backBtn.tag = lotteryTag.backBtnTag.rawValue
    }
    
    func initLotteryView() -> Void {
        
        //大背景图
        let backImg = UIImageView(frame: self.frame)
        backImg.image = UIImage(named: "lottery_bg_img.png")
        self.scroll.addSubview(backImg)
        
        //vivo 图
        let titleFrame = CGRect(x: adapt_W(width: isPhone ? 0 : 25), y: adapt_H(height: isPhone ? 10 : 8), width: isPhone ? width : adapt_W(width: 300), height: adapt_H(height: isPhone ? 150 : 100))
        let titleImg = UIImageView(frame: titleFrame)
        titleImg.image = UIImage(named: "lottery_title_img.png")
        self.scroll.addSubview(titleImg)
        titleImg.tag = lotteryTag.titleImgTag.rawValue
        
        lotteryTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.titleAnimation), userInfo: nil, repeats: true)
//        self.initUnselectView(scroll: self.scroll)
//        self.initSelectView(scroll: self.scroll)
        self.titleAnimation()
        
        
        
    }
    
    
    func initUnselectView(scroll:UIScrollView,confirmStatus:Bool) -> Void {
        tlPrint(message: "initUnselectView")
        self.unselectView = baseVC.viewCreat(frame: self.frame, backgroundColor: .clear)
        scroll.addSubview(unselectView)
        //历史记录按钮
        let historyWidth = adapt_W(width: isPhone ? 120 : 90)
        let historyFrame = CGRect(x: (width - historyWidth) / 2, y: adapt_H(height:  isPhone ? 115 : 72), width: historyWidth, height: adapt_H(height: isPhone ? 35 : 25))
        let historyBtn = baseVC.buttonCreat(frame: historyFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"lottery_result_btnImg.png"), hightImage: UIImage(named:"lottery_result_btnImg.png"), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.unselectView.addSubview(historyBtn)
        historyBtn.tag = lotteryTag.historyBtnTag.rawValue
        self.unselectView.bringSubview(toFront: historyBtn)
        
        //时间提醒背景图
        let timeBgWidth = adapt_W(width: 273)
        let timeBgFrame = CGRect(x: (width - timeBgWidth) / 2, y: adapt_H(height: (isPhone ? 150 : 100)), width: timeBgWidth, height: adapt_H(height: isPhone ? 75 : 50))
        let timeBgImg = UIImageView(frame: timeBgFrame)
        timeBgImg.image = UIImage(named: "lottery_time_bg.png")
        unselectView.addSubview(timeBgImg)
        //时间提醒文本label
        let timeLabelLeftDistance = adapt_W(width: isPhone ? 43 : 28)
        let timeLabelText = "每日提交时间：0:00 - 20:30\n每日开奖时间：21:30"
        let timeLabelFrame = CGRect(x: timeLabelLeftDistance, y: 0, width: timeBgWidth - 2 * timeLabelLeftDistance, height: timeBgFrame.height - adapt_H(height: 18))
        let timeLabel = baseVC.labelCreat(frame: timeLabelFrame, text: timeLabelText, aligment: .left, textColor: .white, backgroundcolor: .clear, fonsize: 0)
        timeLabel.numberOfLines = 0
        timeBgImg.addSubview(timeLabel)
        timeLabel.font = UIFont(name: "Arial-BoldMT", size: fontAdapt(font: 15))
        
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: timeLabelText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = adapt_H(height: isPhone ? 6 : 4) //修改行间距
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0,  timeLabelText.characters.count))
        timeLabel.attributedText = attributedString
    
        //选择号码文字图
        let selectTextWidth = adapt_W(width: 120)
        let selectTextFrame = CGRect(x: (width - selectTextWidth) / 2, y: adapt_H(height: isPhone ? 225 : 150), width: selectTextWidth, height: adapt_H(height: isPhone ? 34 : 25))
        let selectTextImg = UIImageView(frame: selectTextFrame)
        selectTextImg.image = UIImage(named: "lottery_choose_text.png")
        unselectView.addSubview(selectTextImg)
        //已选号码背景图
        let selectedBgWidth = adapt_W(width: isPhone ? 340 : 200)
        let selectedBgHeight = adapt_H(height: isPhone ? 124 : 80)
        let selectedBgFrame = CGRect(x: (width - selectedBgWidth) / 2, y: adapt_H(height: isPhone ? 250 : 170), width: selectedBgWidth, height: selectedBgHeight)
        let selectedBgImg = UIImageView(frame: selectedBgFrame)
        selectedBgImg.image = UIImage(named: "lottery_selected_bg0.png")
        unselectView.addSubview(selectedBgImg)
        selectedBgImg.tag = lotteryTag.selectBgImgTag.rawValue
        selectedBgImg.isUserInteractionEnabled = true
        //已选号码删除按钮
        let cancelHeight = adapt_H(height: isPhone ? 40 : 25)
        let cancelFrame = CGRect(x: selectedBgWidth - cancelHeight * 1.1, y: (selectedBgHeight - cancelHeight) / 2, width: adapt_W(width: isPhone ? 45 : 30), height: cancelHeight)
        let cancelBtn = baseVC.buttonCreat(frame: cancelFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"lottery_cancel_img.png"), hightImage: UIImage(named:"lottery_cancel_img2.png"), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        selectedBgImg.addSubview(cancelBtn)
        cancelBtn.tag = lotteryTag.cancelBtnTag.rawValue
        //选择区域
        let selectBgHeight = adapt_H(height: isPhone ? 153 : 100)
        let selectBgFrame = CGRect(x: 0, y: adapt_H(height: isPhone ? 385 : 280), width: width, height: selectBgHeight)
        let selectBgImg = UIImageView(frame: selectBgFrame)
        selectBgImg.image = UIImage(named: "lottery_bg_img2.png")
        unselectView.addSubview(selectBgImg)
        selectBgImg.isUserInteractionEnabled = true
        //号球
        let interDistance:CGFloat = adapt_W(width: isPhone ? 10 : 5)//两个球之间的距离
        let numberBallWidth:CGFloat = adapt_H(height: isPhone ? 47 : 30)
        let leftDistance:CGFloat = (width - interDistance * 4 - numberBallWidth * 5) / 2
        let topDistance:CGFloat = (selectBgHeight - interDistance - numberBallWidth * 2) / 2
        for i in 0 ..< 10 {
            //球
            let numberBallFrame = CGRect(x: leftDistance + CGFloat(i % 5) * (interDistance + numberBallWidth), y: topDistance + CGFloat(Int(i / 5)) * (interDistance + numberBallWidth), width: numberBallWidth, height: numberBallWidth)
            let numberBallImg = UIImageView(frame: numberBallFrame)
            numberBallImg.image = UIImage(named: "lottery_ball_img.png")
            selectBgImg.addSubview(numberBallImg)
            numberBallImg.tag = lotteryTag.numberBallImgTag.rawValue + i
            //添加点击事件
            let gesture = UITapGestureRecognizer(target: self, action: #selector(ballTouchAct(sender:)))
            gesture.numberOfTapsRequired = 1
            numberBallImg.isUserInteractionEnabled = true
            numberBallImg.addGestureRecognizer(gesture)
            //号
            let numberLabelFrame = CGRect(x: 0, y: 0, width: numberBallWidth, height: numberBallWidth)
            let labelText = i < 9 ? i + 1 : 0
            let numberLabel = baseVC.labelCreat(frame: numberLabelFrame, text: "\(labelText)", aligment: .center, textColor: .colorWithCustom(r: 113, g: 21, b: 6), backgroundcolor: .clear, fonsize: 0)
            numberBallImg.addSubview(numberLabel)
            numberLabel.font = UIFont(name: "ArialRoundedMTBold", size: fontAdapt(font: 36))
        }
        if confirmStatus {
            //confirmStatus 为1，不显示确认按钮，为0 显示确认按钮
            return
        }
        
        //确认按钮
        let confirmWidth = adapt_W(width: isPhone ? 200 : 150)
        let confirmFrame = CGRect(x: (width - confirmWidth) / 2, y: adapt_H(height:  isPhone ? 560 : 360), width: confirmWidth, height: adapt_H(height: isPhone ? 64 : 40))
        let confirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"lottery_comfirmBtnImg0.png"), hightImage: UIImage(named:"lottery_comfirmBtnImg1.png"), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        unselectView.addSubview(confirmBtn)
        confirmBtn.tag = lotteryTag.confirmBtnTag.rawValue
        
        
    }

    
    func initSelectView(scroll:UIScrollView, numberArray:[[Int]],winStatus:Int) -> Void {
        tlPrint(message: "initSelectView")
        //test data
//        let winStatus = 2
//        let numberArray = [[8,8,8],numberArray[1]]
        
        
        self.selectView = baseVC.viewCreat(frame: self.frame, backgroundColor: .clear)
        scroll.addSubview(selectView)
        let selectTextArray = ["lottery_today_number.png","lottery_selected_img.png"]
        let selectTextRectArray:[[CGFloat]] = [[221,42],[150,36]]
        let selectTextRectArrayPad:[[CGFloat]] = [[221,42],[150,36]]
        let imgYArray:[[CGFloat]] = [[150,180],[325,350]]
        let imgYArrayPad:[[CGFloat]] = [[100,130],[300,330]]
        for i in 0 ..< 2 {
            //今日中奖/已选号码文字图
            let selectTextWidth = adapt_W(width: selectTextRectArray[i][0])
            let selectTextFrame = CGRect(x: (width - selectTextWidth) / 2,
                                         y: adapt_H(height: isPhone ? imgYArray[i][0] : imgYArrayPad[i][0]),
                                         width: selectTextWidth,
                                         height: adapt_H(height: isPhone ? selectTextRectArray[i][1] : selectTextRectArrayPad[i][1]))
            
            let selectTextImg = UIImageView(frame: selectTextFrame)
            selectTextImg.image = UIImage(named: selectTextArray[i])
            selectView.addSubview(selectTextImg)
            selectTextImg.center.x = selectView.center.x
            
            //今日中奖/已选号码背景图
            let selectedBgWidth = adapt_W(width: isPhone ? 340 : 200)
            let selectedBgHeight = adapt_H(height: isPhone ? 124 : 80)
            let selectedBgFrame = CGRect(x: (width - selectedBgWidth) / 2,
                                         y: adapt_H(height: isPhone ? imgYArray[i][1] : imgYArrayPad[i][1]),
                                         width: selectedBgWidth,
                                         height: selectedBgHeight)
            
            let selectedBgImg = UIImageView(frame: selectedBgFrame)
            selectedBgImg.image = UIImage(named: "lottery_selected_bg0.png")
            selectView.addSubview(selectedBgImg)
            selectedBgImg.isUserInteractionEnabled = true
            selectedBgImg.tag = lotteryTag.winBgImgTag.rawValue + i
            
            
            //还未开奖
            if i == 0 && numberArray[0].count < 3 {
                tlPrint(message: "还未开奖")
                let notStartFrame = CGRect(x: 0, y: 0, width: selectedBgFrame.width, height: selectedBgFrame.height)
                let notStartLable = baseVC.labelCreat(frame: notStartFrame, text: "开奖时间：今日21:30", aligment: .center, textColor: .white, backgroundcolor: .clear, fonsize: fontAdapt(font: 20))
                selectedBgImg.addSubview(notStartLable)
                continue
            }
            self.initSelectedNumberBallView(backView: selectedBgImg, selectedNumberArray: numberArray[i])
            
        }
        
        //中奖结果图片
        
        let resultFrame1 = CGRect(x: 0, y: adapt_H(height: isPhone ? 530 : 400), width: adapt_W(width: isPhone ? 312 : 200), height: adapt_H(height: isPhone ? 50 : 30))
        let resultFrame2 = CGRect(x: 0, y: adapt_H(height: isPhone ? 500 : 400), width: adapt_W(width: isPhone ? 354 : 250), height: adapt_H(height: isPhone ? 101 : 75))
        let resultFrameArray = [resultFrame1,resultFrame1,resultFrame2]
        let resultImg = UIImageView(frame: resultFrameArray[winStatus])
        resultImg.image = UIImage(named: "lottery_result\(winStatus).png")
//        let resultImg = UIImageView(frame: resultFrameArray[1])
//        resultImg.image = UIImage(named: "lottery_result1.png")
        selectView.addSubview(resultImg)
        resultImg.tag = lotteryTag.resultImgTag.rawValue
        resultImg.center.x = selectView.center.x   
    }
    
    
    func initSelectedNumberBallView(backView:UIView, selectedNumberArray:Array<Int>) -> Void {
        tlPrint(message: "initSelectedNumberBallView selectedNumberArray = \(String(describing: selectedNumberArray))")
        //清空已经选择的号码球
        if backView.tag == lotteryTag.selectBgImgTag.rawValue {
            for i in 0 ..< 3 {
                if let selectedBallImg_t = self.viewWithTag(lotteryTag.selectedBallImgTag.rawValue + i) {
                    let selectedBallImg = selectedBallImg_t as! UIImageView
                    for view in selectedBallImg.subviews {
                        view.removeFromSuperview()
                    }
                    selectedBallImg.removeFromSuperview()
                } else {
                    break
                }
            }
        }
        //如果数组为空，不显示号码球
        if selectedNumberArray.count <= 0 {
            return
        }
        //数组不为空，显示相应号码球
        let ballAccount = selectedNumberArray.count
        let selectedBgWidth = backView.frame.width
        let selectedBgHeight = backView.frame.height
        let interDistance:CGFloat = adapt_W(width: isPhone ? 10 : 5)//两个球之间的距离
        let numberBallWidth:CGFloat = adapt_H(height: isPhone ? 47 : 30)
        let leftDistance:CGFloat = (selectedBgWidth - interDistance * CGFloat(ballAccount - 1) - numberBallWidth * CGFloat(ballAccount)) / 2
        let topDistance:CGFloat = (selectedBgHeight - numberBallWidth) / 2
        for i in 0 ..< ballAccount {
            //球
            let selectedBallFrame = CGRect(x: leftDistance + CGFloat(i % 5) * (interDistance + numberBallWidth), y: topDistance + CGFloat(Int(i / 5)) * (interDistance + numberBallWidth), width: numberBallWidth, height: numberBallWidth)
            let selectedBallImg = UIImageView(frame: selectedBallFrame)
            selectedBallImg.image = UIImage(named: "lottery_ball_img.png")
            backView.addSubview(selectedBallImg)
            selectedBallImg.tag = lotteryTag.selectedBallImgTag.rawValue + i
            backView.bringSubview(toFront: selectedBallImg)
            //号
            let numberLabelFrame = CGRect(x: 0, y: 0, width: numberBallWidth, height: numberBallWidth)
            let labelText = selectedNumberArray[i]
            let numberLabel = baseVC.labelCreat(frame: numberLabelFrame, text: "\(labelText)", aligment: .center, textColor: .colorWithCustom(r: 113, g: 21, b: 6), backgroundcolor: .clear, fonsize: 0)
            selectedBallImg.addSubview(numberLabel)
            numberLabel.font = UIFont(name: "ArialRoundedMTBold", size: fontAdapt(font: 36))
        }
    }
    //头部Vivo手机图缩放选择动效
    func titleAnimation() -> Void {
        tlPrint(message: "titleAnimation")
        let titleImgView = self.viewWithTag(lotteryTag.titleImgTag.rawValue) as! UIImageView
        //缩放动画
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.scaleAnimation(view: titleImgView, delay: 0, scale1: 1.1, scale2: 0.8, duration: 1)
        }
        //翻转动画
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.overturnAnimation(view: titleImgView, duration: 0.6)
        }
    }
    //缩放动画
    func scaleAnimation(view:UIView,delay:CGFloat,scale1:CGFloat,scale2:CGFloat,duration:CGFloat) -> Void {
        tlPrint(message: "scaleAnimation")
        let durations = duration * 0.6
        UIView.animate(withDuration: TimeInterval(durations), delay: TimeInterval(delay), options: .allowUserInteraction, animations: {
            view.isHidden = false
            view.transform = CGAffineTransform(scaleX: scale1, y: scale1)
        }, completion: { (finisehd) in
            let durations = duration * 0.4
            UIView.animate(withDuration: TimeInterval(durations), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
                view.transform = CGAffineTransform(scaleX: scale2, y: scale2)
            }, completion: { (finisehd) in
            })
        })
        
    }
    //翻转动画
    func overturnAnimation(view: UIView,duration:CGFloat) -> Void {
        tlPrint(message: "overturnAnimation")
        UIView.beginAnimations("overturnAnimation", context: nil)
        UIView.setAnimationDuration(TimeInterval(duration))
        UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
        UIView.setAnimationTransition(.flipFromLeft, for: view, cache: false)
        UIView.commitAnimations()
    }
    
    func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct : btnTag: \(sender.tag)")
        if sender.tag == lotteryTag.cancelBtnTag.rawValue {
            SystemTool.systemSound(soundNumber: 1057)
            if selectedNumberArray == nil {
                return
            }
            if selectedNumberArray.count >= 1 {
                selectedNumberArray.remove(at: selectedNumberArray.count - 1)
                let selectedBgImg = self.viewWithTag(lotteryTag.selectBgImgTag.rawValue) as! UIImageView
                initSelectedNumberBallView(backView: selectedBgImg, selectedNumberArray: selectedNumberArray)
            }
            return
        }
        self.delegate.btnAct(btnTag: sender.tag)
    }
    
    
    
    func ballTouchAct(sender:UITapGestureRecognizer) -> Void {
        tlPrint(message: "gameTouchAct.tag = \(String(describing: sender.view?.tag))")
        SystemTool.systemSound(soundNumber: 1057)
        var selectedNumber = sender.view!.tag - lotteryTag.numberBallImgTag.rawValue
        selectedNumber = selectedNumber >= 9 ? 0 : selectedNumber + 1
        if selectedNumberArray  == nil {
            selectedNumberArray = [selectedNumber]
        } else if selectedNumberArray.count <= 2{
            selectedNumberArray.insert(selectedNumber, at: selectedNumberArray.count)
        } else {
            selectedNumberArray[2] = selectedNumber
        }
        let selectedBgImg = self.viewWithTag(lotteryTag.selectBgImgTag.rawValue) as! UIImageView
        initSelectedNumberBallView(backView: selectedBgImg, selectedNumberArray: selectedNumberArray)
    }
}
