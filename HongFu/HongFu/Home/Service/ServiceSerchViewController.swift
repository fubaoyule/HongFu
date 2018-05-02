//
//  ServiceSerchViewController.swift
//  FuTu
//
//  Created by Administrator1 on 9/1/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

class ServiceSerchViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,BtnActDelegate  {

    var searchView:ServiceSearchView!
    // 所有组件
    var ctrls:[String] = ["Label","Button1","Button2","Switch"]
    // 搜索匹配的结果，Table View使用这个数组作为datasource
    var ctrlsel: [[String]]!
    var selectedCellIndexPaths:[NSIndexPath] = []
    let model = ServiceSearchModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 起始加载全部内容
        self.ctrlsel = model.answerInfo
        self.searchView = ServiceSearchView(frame: self.view.frame, param: "" as AnyObject, rootVC: self)
        self.view.addSubview(searchView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func btnAct(btnTag: Int) {
        tlPrint(message: "btnAct btnTag:\(btnTag)")
        switch btnTag {
        case ServiceSearchTag.backBtnTag.rawValue:
            _ = self.navigationController?.popViewController(animated: true)
        case ServiceSearchTag.allQuestionsBtnTag.rawValue:
            tlPrint(message: "所有问题按钮")
        default:
            tlPrint(message: "no such case")
        }
    }
    
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchView.searchBar.resignFirstResponder()
    }
    
    
    
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
        
        
        
        let characters:Int = (ctrlsel[indexPath[1]][1] ).characters.count
        let height = (CGFloat(characters / 20) + CGFloat(0.5)) * adapt_H(height: 25)
        
//        let textBackView = UITextView(frame:CGRect.zero)
//        textBackView.backgroundColor = UIColor.red
//        
//        
        
        
        
        
        
        let textview=UITextView(frame:CGRect.zero)
        textview.translatesAutoresizingMaskIntoConstraints = false
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = adapt_H(height: 8)
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
        self.searchView.searchBar.resignFirstResponder()
        
        self.searchView.tableView!.deselectRow(at: indexPath, animated: false)
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
    
    
    
    //****************    搜索代理    *****************
    
    
    // 搜索代理UISearchBarDelegate方法，每次改变搜索内容时都会调用
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tlPrint(message: "searchBar:\(searchText)")
        // 没有搜索内容时显示全部组件
        if searchText == "" {
            self.ctrlsel = model.answerInfo
        }
        else { // 匹配用户输入内容的前缀(不区分大小写)
            self.ctrlsel = [[]]
            for ctrl in self.model.answerInfo {
                //tlPrint(message: "ctrl:\(ctrl)")
//                if ctrl[0].lowercased().hasPrefix(searchText.lowercased()) {
//                    self.ctrlsel.append(ctrl)
//                }
                
                if (ctrl[0] ).components(separatedBy: searchText).count > 1 {
                    self.ctrlsel.append(ctrl)
                }
            }
        }
        tlPrint(message: "ctrlsel:\(ctrlsel)")
        self.ctrlsel.remove(at: 0)
        // 刷新Table View显示
        self.searchView.tableView.reloadData()
    }
    
    
    // 搜索代理UISearchBarDelegate方法，点击虚拟键盘上的Search按钮时触发
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
