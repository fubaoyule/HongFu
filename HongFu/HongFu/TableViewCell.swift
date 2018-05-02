//
//  TableViewCell.swift
//  HongFu
//
//  Created by Administrator1 on 05/12/17.
//  Copyright © 2017年 Taylor Tan. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var index = 0
    var textArray: [String]!
    var imgArray: [String]!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        self.backgroundColor = UIColor.colorWithCustom(r: 31, g: 34, b: 38)
    
        setUpUI()
    }
    
    
    func setUpUI() {
        let imgLeftDistance = adapt_W(width: isPhone ? 30 : 20)
        
        
        let labelLeftDistance = adapt_W(width: isPhone ? 70 : 50)
        let imageWidth = adapt_W(width: isPhone ? 22 : 16)
        let imageFrame =  CGRect(x: imgLeftDistance, y: (self.frame.height - imageWidth) / 2, width: imageWidth, height: imageWidth)
    
        let imageView = UIImageView(frame: imageFrame)
        imageView.image = UIImage(named: "Menu_\(self.imgArray[index])_0")
        self.addSubview(imageView)
        
        let labelFrame = CGRect(x: labelLeftDistance, y: 0, width: (self.frame.width - 2 * labelLeftDistance), height: self.frame.height)
        let label = UILabel(frame: labelFrame)
        setLabelProperty(label: label, text: "\(textArray[index])", aligenment: .left, textColor: .white, backColor: .clear, font: fontAdapt(font: isPhone ? 14 : 10))
        //第一行为标题行
        label.textColor = UIColor.colorWithCustom(r: 209, g: 209, b: 209)
        label.numberOfLines = 0
        
        self.addSubview(label)
        label.font = UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 17 : 12))
        label.textAlignment = NSTextAlignment.left
        
        if index == 0 {
            label.textColor = UIColor.colorWithCustom(r: 255, g: 210, b: 0)
        }
    }
}
