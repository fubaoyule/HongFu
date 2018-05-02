//
//  ServiceViewController.swift
//  FuTu
//
//  Created by Administrator1 on 22/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController, UIScrollViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource, serviceDelegate {

    
    let model = ServiceModel()
    var serviceView: ServiceView!
    //var searchView: SearchView!
    var scroll: UIScrollView!
    var width,height: CGFloat!
    var currentTextFeild: UITextField!
    var currentTextView:UITextView!
    // 搜索匹配的结果，Table View使用这个数组作为datasource
    var ctrlsel: [[String]]!
    var selectedCellIndexPaths:[NSIndexPath] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.width = self.view.frame.width
        self.height = self.view.frame.height
        self.automaticallyAdjustsScrollViewInsets = false
        serviceView = ServiceView(frame: self.view.frame, param: "我来自服务控制" as AnyObject, rootVC:self)
        //searchView = SearchView(frame: self.view.frame, param: "" as AnyObject, rootVC: self)
        self.scroll = serviceView.scroll
        self.view.addSubview(serviceView)
        
        
    }
    //===========================================
    //Mark:- set the style of status bar
    //===========================================
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //let offSetY:CGFloat = scrollView.contentOffset.y
    }
    
    
    
    func serviceBtnAct(btnTag: Int) {
        tlPrint(message: "serviceBtnAct tag = \(btnTag)")
        switch btnTag {
        case serviceTag.BackBtn.rawValue:
            tlPrint(message: "退出")
            _ = self.navigationController?.popViewController(animated: true)
        case serviceTag.SearchBtn.rawValue:
            tlPrint(message: "搜索按钮")
            let searchVC = ServiceSerchViewController()
            self.navigationController?.pushViewController(searchVC, animated: true)
        case serviceTag.OnlineServiceBtn.rawValue:
            tlPrint(message: "在线客服")
            let onlineService = GameViewController()
            onlineService.param = ["gameType":"service", "orientation":"portrait", "url":model.onlineServiceURL] as AnyObject
            
            self.navigationController?.pushViewController(onlineService, animated: true)
            userDefaults.setValue("service", forKey: userDefaultsKeys.gameType.rawValue)
        case serviceTag.AnswerCloseBtn.rawValue:
            tlPrint(message: "关闭答案")
            self.serviceView.scroll.contentSize = CGSize(width: width, height: height + 1)
            UIView.animate(withDuration: 1, animations: { 
                self.serviceView.answerView.removeFromSuperview()
                self.serviceView.answerView = nil
            })
        default:
            if btnTag >= serviceTag.QuestionBtn.rawValue && btnTag < serviceTag.AnswerBtn.rawValue{
                tlPrint(message: "提问按钮")
                
                self.ctrlsel = model.answerInfo[btnTag - serviceTag.QuestionBtn.rawValue]
                showAnswerView(btnTag: btnTag)
                
            }
//            else if btnTag >= serviceTag.AnswerBtn.rawValue && btnTag < serviceTag.AnswerInfoText.rawValue {
//                tlPrint(message: "问题编号：\(btnTag)")
//                showAnswerInfo(btnTag: btnTag)
//            } else {
//                tlPrint(message: "no such case")
//            }
        }
        
    }
    func searchBtnAct(btnTag: Int) {
        tlPrint(message: "searchBtnAct tag = \(btnTag)")
        switch btnTag {
//        case serviceTag.SearchBackBtn.rawValue:
//            searchView.removeFromSuperview()
//            searchView = nil
            
        case serviceTag.SearchQuesBtn.rawValue:
            if currentTextFeild != nil {
                currentTextFeild.resignFirstResponder()
            }
        default:
            if btnTag >= serviceTag.SearchInputTextFeild.rawValue {
                tlPrint(message: "点击了搜索页面的问题按钮")
            } else {
                tlPrint(message: "no such case")
            }
            
        }
    }
    
    
    func showAnswerView(btnTag:Int) -> Void {
        tlPrint(message: "showAnswerView")
        let selectedBtn = self.serviceView.viewWithTag(btnTag) as! UIButton
        let btnFrameArray = (isPhone ? self.model.quesFrame : self.model.quesFramePad)
        UIView.animate(withDuration: 0.5, animations: {
            
//            selectedBtn.frame = CGRect(x: adapt_W(width: isPhone ? 18 : 25),y:adapt_W(width: 15),width: btnFrameArray[btnTag - serviceTag.QuestionBtn.rawValue].width,height: btnFrameArray[btnTag - serviceTag.QuestionBtn.rawValue].height)
            selectedBtn.frame = CGRect(x: adapt_W(width: isPhone ? 0 : 0),y:adapt_W(width: 15),width: btnFrameArray[btnTag - serviceTag.QuestionBtn.rawValue].width,height: btnFrameArray[btnTag - serviceTag.QuestionBtn.rawValue].height)
            self.serviceView.questionView.alpha = 0
            selectedBtn.alpha = 1
        }, completion: { (finished) in
            self.serviceView.initAnswerTable(index: btnTag - serviceTag.QuestionBtn.rawValue)
//            selectedBtn.frame = self.model.quesFrame[btnTag - serviceTag.QuestionBtn.rawValue]
            selectedBtn.frame = btnFrameArray[btnTag - serviceTag.QuestionBtn.rawValue]
            
            self.serviceView.answerView.alpha = 0
            
            UIView.animate(withDuration: 0.1, animations: {
                self.serviceView.answerView.alpha = 1
            }, completion: { (finished) in
                 self.serviceView.questionView.alpha = 1
            })
        })
    }
    
//    func showAnswerInfo(btnTag:Int) -> Void {
//        tlPrint(message: "showAnswerInfo btnTag:\(btnTag)")
//        let textTag = btnTag - serviceTag.AnswerBtn.rawValue + serviceTag.AnswerInfoText.rawValue
//        let textView = serviceView.answerView.viewWithTag(textTag) as! UITextView
//        let qusBtn = serviceView.answerView.viewWithTag(btnTag) as! UIButton
//        let oFrame = textView.frame
//        UIView.animate(withDuration: 0.2, animations: {
//            textView.frame = CGRect(x: 0, y: oFrame.origin.y, width: self.width, height: adapt_H(height: self.model.answerInfoHeight))
//            
//            textView.mas_remakeConstraints({ (make) in
//                _ = make?.top.equalTo()(qusBtn.mas_bottom)
//                _ = make?.left.equalTo()(self.serviceView.answerView.mas_left)
//                _ = make?.width.equalTo()(self.width)
//                _ = make?.height.equalTo()(adapt_H(height: self.model.answerInfoHeight))
//            })
//        })
//        var offsetY:CGFloat = self.serviceView.answerView.contentSize.height
//        if btnTag == serviceTag.AnswerBtn.rawValue {
//            offsetY -= adapt_H(height: self.model.answerInfoHeight)
//        }
//        
//        if offsetY >= self.serviceView.answerView.frame.height + adapt_H(height: self.model.answerInfoHeight) * CGFloat(model.answerInfo.count - 2) {
//            
//        } else {
//            offsetY += adapt_H(height: self.model.answerInfoHeight)
//        }
//        
//        self.serviceView.answerView.contentSize = CGSize(width: width, height: offsetY)
//    }
    
    
//    func showSearchAnswerInfo(btnTag:Int) -> Void {
//        tlPrint(message: "showSearchAnswerInfo btnTag:\(btnTag)")
//        let textTag = btnTag - serviceTag.SearchAnserBtn.rawValue + serviceTag.SearchAnserInfoText.rawValue
//        let textView = searchView.answerScroll.viewWithTag(textTag) as! UITextView
//        let qusBtn = searchView.answerScroll.viewWithTag(btnTag) as! UIButton
//        let oFrame = textView.frame
//        UIView.animate(withDuration: 0.2, animations: {
//            textView.frame = CGRect(x: 0, y: oFrame.origin.y, width: self.width, height: adapt_H(height: self.model.answerInfoHeight))
//            
//            textView.mas_remakeConstraints({ (make) in
//                _ = make?.top.equalTo()(qusBtn.mas_bottom)
//                _ = make?.left.equalTo()(self.searchView.answerScroll.mas_left)
//                _ = make?.width.equalTo()(self.width)
//                _ = make?.height.equalTo()(adapt_H(height: self.model.answerInfoHeight))
//            })
//        })
//        var offsetY:CGFloat = self.searchView.answerScroll.contentSize.height
//        if btnTag == serviceTag.SearchAnserBtn.rawValue {
//            offsetY -= adapt_H(height: self.model.answerInfoHeight)
//        }
//        if offsetY >= self.searchView.answerScroll.frame.height + adapt_H(height: self.model.answerInfoHeight) * CGFloat(model.answerInfo.count - 2) {
//            
//        } else {
//            offsetY += adapt_H(height: self.model.answerInfoHeight)
//        }
//        self.searchView.answerScroll.contentSize = CGSize(width: width, height: offsetY)
//        
//        currentTextView = textView
//    }
    
    
    
    
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tlPrint(message: "touchesEnded")
        //第一页的输入框不弹出键盘
        if currentTextFeild == nil {
            return
        }
        currentTextFeild.resignFirstResponder()
        //第二页收起TextView
        
        //packUpTextView()
        
        tlPrint(message: "touchesEnded end")
        
    }
    
//    func packUpTextView() -> Void {
//        if currentTextView != nil {
//            
//            DispatchQueue.main.async {
//                let qusBtn = self.searchView.answerScroll.viewWithTag(self.currentTextView.tag - serviceTag.SearchAnserInfoText.rawValue + serviceTag.SearchAnserBtn.rawValue) as! UIButton
//                
//                UIView.animate(withDuration: 0.5, animations: {
//                    self.currentTextView.mas_remakeConstraints({ (make) in
//                        _ = make?.top.equalTo()(qusBtn.mas_bottom)
//                        _ = make?.left.equalTo()(self.searchView.answerScroll.mas_left)
//                        _ = make?.width.equalTo()(self.width)
//                        _ = make?.height.equalTo()(0)
//                    })
//                }, completion: { (finished) in
//                    self.currentTextView = nil
//                })
//            }
//        }
//    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tlPrint(message: "textFieldShouldBeginEditing")
        currentTextFeild = textField
        tlPrint(message: "current textField:\(currentTextFeild)")
        if textField.tag == serviceTag.SearchTextField.rawValue {
//            //服务页的搜索框
//            if searchView == nil {
//                searchView = SearchView(frame: self.view.frame, param: "" as AnyObject, rootVC: self)
//                self.view.addSubview(searchView)
//            } else {
//                self.view.bringSubview(toFront: searchView)
//            }
//            
////            let custSearch = CustomSearchViewController()
////            self.navigationController?.pushViewController(custSearch, animated: true)
//            currentTextFeild.resignFirstResponder()
            let searchVC = ServiceSerchViewController()
            self.navigationController?.pushViewController(searchVC, animated: true)
            return false
        }
        
        tlPrint(message: "textFieldShouldBeginEditing end")
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        tlPrint(message: "shouldChangeCharactersIn")
//        if textField.tag == serviceTag.SearchInputTextFeild.rawValue {
//            //当前是搜索框
//            if textField.text == nil {
//                return false
//            }
//            let inputText = string
//            let resultIndex = model.searchAnswerByKeywords(key: inputText)
//            var resultInfo: [[String]] = [[""]]
//            tlPrint(message: "result infomation: \(resultInfo)")
//            if let resultIndex = resultIndex {
//                for i in 0 ... resultIndex.count - 1 {
//                    tlPrint(message: "result infomation: \(model.answerInfo[resultIndex[i][0]][resultIndex[i][1]] )")
//                    resultInfo.append(model.answerInfo[resultIndex[i][0]][resultIndex[i][1]])
//                }
//                resultInfo.remove(at: 0)
//                DispatchQueue.main.async {
//                    //self.searchView.initAnswerScroll(infos: resultInfo)
//                    self.searchView.initAnswerTable()
//                }
//            }
//        }
        return true
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tlPrint(message: "textFieldShouldReturn")
        textField.resignFirstResponder()
        tlPrint(message: "textFieldShouldReturn end")
        return true
    }

    
    
    //
    //****************    表格视图代理    *****************
    // 返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tlPrint(message: "numberOfRowsInSection")
        return self.ctrlsel.count
    }
    
    // 创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
        
    {
        tlPrint(message: "cellForRowAt")
        //        // 为了提供表格显示性能，已创建完成的单元需重复使用
        //        let identify:String = "SwiftCell"
        //        // 同一形式的单元格重复使用，在声明时已注册
        //        let cell = tableView.dequeueReusableCell(withIdentifier: identify,
        //                                                 for: indexPath as IndexPath) as UITableViewCell
        //        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        //        cell.textLabel?.text = self.ctrlsel[indexPath.row]
        //        return cell
        
        let label =  UILabel(frame:CGRect.zero)
        setLabelProperty(label: label, text: self.ctrlsel[indexPath.row][0], aligenment: .left, textColor: .colorWithCustom(r: 0, g: 101, b: 215), backColor: .clear, font: fontAdapt(font: isPhone ? 16 : 11))
        label.translatesAutoresizingMaskIntoConstraints = false
        
        TPrint(message: "$$$$$$$")
        let characters:Int = (ctrlsel[indexPath[1]][1] ).characters.count
        let height = (CGFloat(characters / 20) + CGFloat(0.5)) * adapt_H(height: 25)
        let textview=UITextView(frame:CGRect.zero)
        textview.translatesAutoresizingMaskIntoConstraints = false
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = adapt_H(height: isPhone ? 8 : 10)
        let atrributes = NSAttributedString(string: self.ctrlsel[indexPath.row][1] , attributes: [NSAttributedStringKey.paragraphStyle:paragraphStyle])
        textview.attributedText = atrributes
        textview.textColor = UIColor.gray
        textview.backgroundColor = UIColor.colorWithCustom(r: 244, g: 244, b: 244)
        textview.isEditable = false
        textview.font = UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 14 : 9))
        
        let identify:String = "SwiftCell"
        let cell = UITableViewCell(style: .default, reuseIdentifier:identify)
        //自动遮罩不可见区域,超出的不显示
        cell.layer.masksToBounds = true
        cell.contentView.addSubview(label)
        cell.contentView.addSubview(textview)
        
        //创建一个控件数组
        let views = ["label":label, "textview":textview]
        cell.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-\(adapt_W(width: isPhone ? 15 : 25))-[label]-\(adapt_W(width: isPhone ? 15 : 25))-|", options: [], metrics: nil, views: views))
        cell.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-\(adapt_W(width: isPhone ? 10 : 25))-[textview]-\(adapt_W(width: isPhone ? 10 : 25))-|", options: [], metrics: nil, views: views))
        cell.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[label(40)]", options: [], metrics: nil, views: views))
        cell.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-40-[textview(\(height))]", options: [], metrics: nil, views: views))
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tlPrint(message: "didSelectRowAt")
        //        self.tableView!.deselectRow(at: indexPath, animated: false)
        //        if let index = selectedCellIndexPaths.index(of: indexPath as NSIndexPath) {
        //            selectedCellIndexPaths.remove(at: index)
        //
        //        }else{
        //
        //            selectedCellIndexPaths.append(indexPath as NSIndexPath)
        //        }
        //        // Forces the table view to call heightForRowAtIndexPath
        //        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        self.serviceView.tableView!.deselectRow(at: indexPath, animated: false)
        selectedCellIndexPaths = [indexPath as NSIndexPath]
        // Forces the table view to call heightForRowAtIndexPath
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tlPrint(message: "heightForRowAt")
        if selectedCellIndexPaths.contains(indexPath as NSIndexPath) {
            //let textHeight = ((self.ctrlsel[indexPath.row][1] as String).characters.count / 22 + 0.5) * adapt_H(height: 20)
            let characters:Int = (ctrlsel[indexPath[1]][1] ).characters.count
            var height = (CGFloat(characters / 20) + CGFloat(0.5)) * adapt_H(height: 25) + adapt_H(height: 40)
            if !isPhone {
               height = (CGFloat(characters / 36) + CGFloat(0.6)) * adapt_H(height: 25) + adapt_H(height: 20)
            }
            return CGFloat(height)
        }
        return adapt_H(height: isPhone ? 40 : 20)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
