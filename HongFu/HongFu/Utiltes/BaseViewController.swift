//
//  BaseViewController.swift
//  种果得果
//
//  Created by 譚龍 on 16/7/19.
//  Copyright © 2016年 譚龍. All rights reserved.

import UIKit

func kDeviceWidth()->CGFloat{
    return UIScreen.main.bounds.size.width
}

func kDeviceHeight()->CGFloat{
    return UIScreen.main.bounds.size.height
}

func hexRGB(rgbValue:Int) ->UIColor{
    let r = CGFloat((rgbValue & 0xffffff) >> 16)/255.0
    let g = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
    let b = CGFloat(rgbValue & 0xFF)/255.0
    return  UIColor(red: r, green: g, blue: b, alpha: 1)
}

func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)->UIColor {
    return UIColor(red: r/255.0, green: r/255.0, blue: r/255.0, alpha: 1.0)
    //    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    //设置NavigationBar TitleView
    func titleView(image:UIImage,title:String?){
        let customView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 27))
        customView.center = CGPoint(x: kDeviceWidth()/2-2, y: 20)
        customView.backgroundColor = UIColor.clear
        if image != NSNull(){
            let aa:UIImageView = UIImageView(frame: CGRect(x: 0, y: 2, width:222, height: 25))
            aa.image = image
            aa.isUserInteractionEnabled = true
            customView.addSubview(aa)
            self.navigationItem.titleView = customView
        } else if title != nil {
            let aa:UILabel = UILabel(frame: CGRect(x: 0, y: 2, width: 150, height: 25))
            aa.isUserInteractionEnabled = true
            aa.text = title
            aa.textAlignment = NSTextAlignment.center
            aa.font = UIFont.systemFont(ofSize: 15)
            aa.backgroundColor = UIColor.clear
            aa.textColor = UIColor.white
            customView.addSubview(aa)
            self.navigationItem.titleView = customView
        }
        
    }
    //设置 左按钮
    
    func leftButton(image:UIImage?,hlIimage:UIImage?,title:String,size:CGSize,action:Selector,target:AnyObject){
        
        if image != nil{
            let fonesize:CGFloat = 0
            let leftNavButton = self.buttonCreat(frame: CGRect(x:0,y:0,width:size.width, height:size.height), title:"", alignment: NSTextAlignment.center, target: target, myaction: action, normalImage: image!, hightImage: hlIimage!, backgroundColor: UIColor.clear , fonsize:fonesize,events: UIControlEvents.touchDragInside)
            let sendButtonItem = UIBarButtonItem(customView: leftNavButton)
            self.navigationItem.leftBarButtonItem = sendButtonItem
        }else{
            let fonesize:CGFloat = 15
            let leftNavButton = self.buttonCreat(frame: CGRect(x:0,y:0,width:size.width, height:size.height), title:title, alignment: NSTextAlignment.center, target: target, myaction: action, normalImage: UIImage(), hightImage: UIImage(), backgroundColor: UIColor.clear
                ,fonsize:fonesize,events: UIControlEvents.touchDragInside)
            
            let sendButtonItem = UIBarButtonItem(customView: leftNavButton)
            self.navigationItem.leftBarButtonItem = sendButtonItem
        }
        
    }
    
    
    //设置 右按钮
    func rightButton(image:UIImage?,hlIimage:UIImage?,title:String,size:CGSize,action:Selector,target:AnyObject){
        
        if image != nil{
            let fonesize:CGFloat = 0
            let rightNavButton = self.buttonCreat(frame: CGRect(x:0,y:0,width:size.width, height:size.height), title:"", alignment: NSTextAlignment.center, target: target, myaction: action, normalImage: image!, hightImage: hlIimage!, backgroundColor: UIColor.clear,fonsize:fonesize,events: UIControlEvents.touchDragInside)
            let sendButtonItem = UIBarButtonItem(customView: rightNavButton)
            self.navigationItem.rightBarButtonItem = sendButtonItem
        }else{
            let fonesize:CGFloat = 15
            let rightNavButton = self.buttonCreat(frame: CGRect(x:0,y:0,width:size.width, height:size.height), title:title, alignment: NSTextAlignment.center, target: target, myaction: action, normalImage: UIImage(), hightImage: UIImage(), backgroundColor: UIColor.clear,fonsize:fonesize,events:  UIControlEvents.touchDragInside)
            let sendButtonItem = UIBarButtonItem(customView: rightNavButton)
            self.navigationItem.rightBarButtonItem = sendButtonItem
        }
        
    }
    
    
    
    
    
    //button创建
    func buttonCreat(frame:CGRect,title:String,alignment:NSTextAlignment,target:AnyObject ,myaction:Selector,normalImage:UIImage?,hightImage:UIImage?,backgroundColor:UIColor, fonsize:CGFloat,events:UIControlEvents)->UIButton{
        
        let button:UIButton! = UIButton(type: UIButtonType.custom);
        button.frame = frame
        button.titleLabel?.font = UIFont.systemFont(ofSize: fonsize)
        button.setTitle(title, for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        if let image = normalImage {
            button.setImage(image, for: UIControlState.normal)
        }
        if let image = hightImage {
            button.setImage(image, for: UIControlState.highlighted)
        }
        button.backgroundColor = backgroundColor
        button.addTarget(target, action: myaction, for: events)
        return button
    }
    
    
    
    //button完善
    func buttonFinish(button:UIButton,frame:CGRect,title:String,alignment:NSTextAlignment,target:AnyObject ,myaction:Selector,normalImage:UIImage,hightImage:UIImage,backgroundColor:UIColor, fonsize:CGFloat,events:UIControlEvents)->UIButton{
        
        button.frame = frame
        button.titleLabel?.font = UIFont.systemFont(ofSize: fonsize)
        button.setTitle(title, for: UIControlState.normal)
        button.setTitleColor(hexRGB(rgbValue: 0x807f7f), for: UIControlState.normal)
        button.setTitleColor(hexRGB(rgbValue: 0xffca00), for: UIControlState.highlighted)
        
        button.setBackgroundImage(normalImage, for: UIControlState.normal)
        button.setBackgroundImage(hightImage, for: UIControlState.highlighted)
        button.backgroundColor = backgroundColor
        button.addTarget(target, action: myaction, for: events)
        return button
        
    }
    
    
    
    //label创建
    
    func labelCreat(frame:CGRect,text:String,aligment:NSTextAlignment,textColor:UIColor,backgroundcolor:UIColor,fonsize:CGFloat) -> UILabel{
        
        let label = UILabel(frame: frame)
        label.backgroundColor = backgroundcolor
        label.textColor = textColor
        label.text = text
        label.textAlignment = aligment
        label.font = UIFont.systemFont(ofSize: fonsize)
        label.tintColor = textColor
        label.backgroundColor = backgroundcolor
        return label
    }
    //label完善
    func labelFinish(label:UILabel,frame:CGRect,text:String,aligment:NSTextAlignment,textColor:UIColor,backgroundcolor:UIColor,fonsize:CGFloat) {
        
        label.frame = frame
        label.backgroundColor = backgroundcolor
        label.textColor = textColor
        label.text = text
        label.textAlignment = aligment
        label.font = UIFont(name:"SAppleGothic" , size: fonsize)
        label.tintColor = textColor
        
        label.backgroundColor = backgroundcolor
    }
    
    
    //textField创建
    
    func textFieldCreat(frame:CGRect,placeholderText:String,aligment:NSTextAlignment, fonsize:CGFloat, borderWidth:CGFloat, borderColor:UIColor, tag:Int) -> UITextField {
        
        let textField = UITextField(frame: frame)
        
        textField.placeholder = placeholderText
        textField.textAlignment = aligment
        textField.font = UIFont(name: "AppleGothic", size: fonsize)
        textField.tag = tag
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.borderStyle = UITextBorderStyle.none
        textField.layer.borderWidth = borderWidth
        textField.layer.borderColor = borderColor.cgColor
        
        
        
        return textField
    }
    
    
    //textField完善
    
    func textFieldFinish(textField:UITextField,frame:CGRect,placeholderText:String,aligment:NSTextAlignment, fonsize:CGFloat, borderWidth:CGFloat, borderColor:UIColor, tag:Int)  -> UITextField {
        
        textField.frame = frame
        textField.placeholder = placeholderText
        textField.textAlignment = aligment
        textField.font = UIFont(name: "AppleGothic", size: fonsize)
        textField.tag = tag
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.borderStyle = UITextBorderStyle.none
        textField.layer.borderWidth = borderWidth
        textField.layer.borderColor = borderColor.cgColor
        
        return textField
    }
    
    
    //imageView创建
    
    func imageViewCreat(frame:CGRect,image:UIImage,highlightedImage:UIImage) -> UIImageView {
        let imageView = UIImageView(image: image, highlightedImage: highlightedImage)
        imageView.frame = frame
        return imageView
    }
    
    //view 创建
    
    func viewCreat(frame:CGRect,backgroundColor:UIColor) -> UIView{
        let view = UIView(frame: frame)
        view.backgroundColor = backgroundColor
        return view
    }

    
    //scroll view创建
    func scrollViewCreat(frame:CGRect,delegate: UIScrollViewDelegate,contentSize:CGSize,showsIndicatorV:Bool,showsIndecatorH:Bool,backColor:UIColor) -> UIScrollView {
        let scroll = UIScrollView(frame: frame)
        scroll.contentSize = contentSize
        scroll.showsVerticalScrollIndicator = showsIndicatorV
        scroll.showsHorizontalScrollIndicator = showsIndecatorH
        scroll.backgroundColor = backColor
        scroll.delegate = delegate
        return scroll
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
