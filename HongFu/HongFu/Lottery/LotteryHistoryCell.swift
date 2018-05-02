//
//  LotteryHistoryCell.swift
//  FuTu
//
//  Created by Administrator1 on 10/11/17.
//  Copyright © 2017年 Taylor Tan. All rights reserved.
//

import UIKit

class LotteryHistoryCell: UITableViewCell {

    
    var index = 0
    var info: [Any]!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.backgroundColor = index % 2 == 1 ? UIColor.colorWithCustom(r: 135, g: 16, b: 53) : UIColor.colorWithCustom(r: 110, g: 14, b: 44)
        setUpUI()
    }

    
    func setUpUI() {
        let leftDistance = adapt_W(width: isPhone ? 30 : 20)
        let wordLocationArray = [NSTextAlignment.left, NSTextAlignment.center, NSTextAlignment.right]
        for i in 0 ..< 3 {
            let labelFrame = CGRect(x: leftDistance, y: 0, width: (self.frame.width - 2 * leftDistance), height: self.frame.height)
            let label = UILabel(frame: labelFrame)
            setLabelProperty(label: label, text: "\(info[i])", aligenment: .left, textColor: .white, backColor: .clear, font: fontAdapt(font: isPhone ? 14 : 10))
            //第一行为标题行
            if  index == 0 {
                label.textColor = UIColor.colorWithCustom(r: 255, g: 210, b: 98)
                label.numberOfLines = 0
                self.addSubview(label)
                label.font = UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 17 : 12))
                
            } else {
                if i == 1 {
                    label.text = "\(info[i])\nOPPO手机累计\(info[i + 1])部"
                }
                if i == 2 {
                    label.text = "\(info[i + 1])"
                }
                label.numberOfLines = 0
                self.addSubview(label)
            }
            label.textAlignment = wordLocationArray[i]
            
        }
    }
}
