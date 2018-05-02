//
//  MessageTableViewCell.swift
//  FuTu
//
//  Created by Administrator1 on 29/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit




class MessageTableViewCell: UITableViewCell {

    var info:[String:Any]!
    var index:Int!
    var messageType: MessageType!
    var cellHeight:CGFloat!
    var delegate:messageDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

  
    init(cellHeight:CGFloat,messageType:MessageType,info:[String:Any],index:Int,rootVC:UIViewController) {
        super.init(style: .default, reuseIdentifier: "ABC")
        self.cellHeight = cellHeight
        self.messageType = messageType
        self.delegate = rootVC as! messageDelegate
        self.info = info
        self.index = index
        tlPrint(message: "self.frame2:\(self.frame)")
        if self.messageType == MessageType.Activity {
            activityCell()
        } else {
            messageCell()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func activityCell() -> Void {
        tlPrint(message: "activity cell")
//        self.backgroundColor = UIColor.white
//        
//        let imgView = UIImageView(frame: CGRect(x: adapt_W(width: 5), y: adapt_H(height: 7), width: deviceScreen.width - adapt_W(width: 10), height: cellHeight - adapt_H(height: 7)))
//        imgView.clipsToBounds = true
//        self.addSubview(imgView)
//        imgView.layer.shadowColor = UIColor.black.cgColor
//        imgView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        imgView.layer.shadowOpacity = 0.3
//        imgView.tag = MessageTag.ActiVityImgTag.rawValue + index
//        //获取网络图片
//        tlPrint(message: "info:\(info)")
//        let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
//        let url = URL(string: domain + (info["imgUrl"] as! String))
//        imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "auto-image.png"))
//        //添加触摸事件tap
//        imgView.isUserInteractionEnabled = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapAct(sender:)))
//        imgView.addGestureRecognizer(tapGesture)
        
    }
    
    func messageCell() -> Void {
        tlPrint(message: "message cell")
        
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
//        self.backgroundColor = UIColor.randomColor()
        
        //date label
//        let dateWidth =   adapt_W(width: isPhone ? ((info["Id"] as! Int == 0) ?  100 : 100) : (((info["Id"] as! Int == 0) ?  100 : 100)))
        let dateWidth = adapt_W(width: isPhone ? 120 : 80)
        let dateLabel = UILabel()
        self.addSubview(dateLabel)
        dateLabel.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(adapt_H(height:isPhone ? 13 : 5))
            _ = make?.width.equalTo()(dateWidth)
            _ = make?.height.equalTo()(adapt_H(height: isPhone ? 15 : 10))
            _ = make?.centerX.equalTo()
        }
        setLabelProperty(label: dateLabel, text: info["Created"] as! String, aligenment: .center, textColor: .white, backColor: .colorWithCustom(r: 197, g: 197, b: 197), font: fontAdapt(font: isPhone ? 12 : 8))
        dateLabel.clipsToBounds = true
        dateLabel.layer.cornerRadius = adapt_W(width: 3)
        
        
        let infoBackView = UIView(frame: CGRect(x: adapt_W(width: 6), y: adapt_H(height: isPhone ? 35 : 20), width: deviceScreen.width - adapt_W(width: 12), height: cellHeight - adapt_W(width: 35)))
        self.addSubview(infoBackView)
        infoBackView.backgroundColor = UIColor.white
        infoBackView.layer.cornerRadius = adapt_W(width: 5)
        
        
        //log img
        let logImg = UIImageView()
        infoBackView.addSubview(logImg)
        logImg.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(adapt_W(width: 12))
            _ = make?.centerY.equalTo()(infoBackView.mas_centerY)
            _ = make?.width.equalTo()(adapt_W(width: isPhone ? 45 : 30))
            _ = make?.height.equalTo()(adapt_W(width: isPhone ? 45 : 30))
        }
        
        logImg.image = UIImage(named: (info["Id"] as! Int == 0 ? "message_sysMessage_notify.png":"message_sysMessage_letter.png"))

        //message info
        let characters = CGFloat((info["Content"] as! String).characters.count)
        let textH:CGFloat = isPhone ? (characters / 20 * adapt_H(height: 25) + adapt_H(height: 20)) : (characters / 30 * adapt_H(height: 15) + adapt_H(height: 10))

//        let msgTextView = UITextView()
//        infoBackView.addSubview(msgTextView)
//        msgTextView.mas_makeConstraints { (make) in
//            _ = make?.left.equalTo()(adapt_W(width: 70))
//            _ = make?.right.equalTo()(adapt_W(width: -10))
//            _ = make?.centerY.equalTo()(infoBackView.mas_centerY)
//            _ = make?.height.equalTo()(textH)
//        }
//        
//        msgTextView.textColor = UIColor.colorWithCustom(r: 81, g: 81, b: 81)
//        
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = adapt_H(height: 8)
//        let atrributes = NSAttributedString(string: info["Content"] as! String, attributes: [NSParagraphStyleAttributeName:paragraphStyle])
//
//        msgTextView.attributedText = atrributes
//        msgTextView.font = UIFont.systemFont(ofSize: fontAdapt(font: 14))
//        msgTextView.isScrollEnabled = false
//        msgTextView.isEditable = false
        
        let msgLabel = UILabel()
        infoBackView.addSubview(msgLabel)
        msgLabel.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(adapt_W(width: isPhone ? 70 : 50))
            _ = make?.right.equalTo()(adapt_W(width: -10))
            _ = make?.centerY.equalTo()(infoBackView.mas_centerY)
            _ = make?.height.equalTo()(textH)
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = adapt_H(height: isPhone ? 8 : 5)
        let atrributes = NSAttributedString(string: info["Content"] as! String, attributes: [NSAttributedStringKey.paragraphStyle:paragraphStyle])
        msgLabel.textColor = UIColor.colorWithCustom(r: 81, g: 81, b: 81)
//        msgLabel.textColor = UIColor.colorWithCustom(r: 0, g: 101, b: 215)
        msgLabel.attributedText = atrributes
        msgLabel.font = UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 14 : 9))
        msgLabel.numberOfLines = 0//标签自动换行
        msgLabel.textAlignment = .left
        msgLabel.adjustsFontSizeToFitWidth = true//标签内容大小适配
//        msgLabel.backgroundColor = UIColor.randomColor()
        
        
    }
    func tapAct(sender:UITapGestureRecognizer) -> Void {
        tlPrint(message: "tapAct: \(sender.view!.tag)")
        self.delegate.messageTapAct(tapTag: sender.view!.tag)
    }

    

}
