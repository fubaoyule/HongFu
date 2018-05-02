//
//  PersonModel.swift
//  FuTu
//
//  Created by Administrator1 on 19/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

//按钮tag标签枚举
enum personBtnTag: Int {
    
    
    //按钮
    case BackButton = 70,InfoEditButton, PersonInfoButton, BankCardButton, addButton, LogOutButton, GetVerifyCodeButton, finishVerifyButton
    //卡片初始tag
    case BankBaseTag = 80
    //卡片按钮初始tag
    case BankCardBtnTag = 100
    //默认标识初始tag
    case BankDefaultTag = 150
    //弹窗按钮Tag
    case BankAlertCloseBtnTag = 180, BankAlertSelectBtnTag, BankAlertConfirmBtnTag, BankAlertPickerConfirmBtnTag
    case BankAlertTextFieldTag = 190
    //个人资料Tag
    case InfoTextFeildTag = 200
    //进入下一页按钮的Tag
    case InfoNextViewBtnTag = 220
    //修改信息内容的Tag
    case InfoVerifyTextFieldTag = 250, InfoVerifyCodeFieldTag,AlertLableTag,RightImageTag
    //弹窗Tag
    case BankDeleteAlert = 260
    
    case infoAlertLabelTag = 270
    //修改密码
    case passwordModifyTextFieldTag = 280
    case passwordModifyRightImageTag = 290
    case passwordModifyConfirmBtnTag = 300
    case emailRedbagConfirmBtnTag = 310
    
    
}
//银行名称对应图片名称枚举类

enum bankName: Int {
    case 邮政银行 = 0, 中国银行, 交通银行, 建设银行, 民生银行, 光大银行 , 农业银行, 工商银行
    
    
    
    /*
     [{"BankName":"中国工商银行","BankCode":"ICBC"},
     {"BankName":"中国农业银行","BankCode":"ABC"},
     {"BankName":"中国招商银行","BankCode":"CMB"},
     {"BankName":"中国建设银行","BankCode":"CCB"},
     {"BankName":"中国交通银行","BankCode":"COMM "},
     {"BankName":"中国银行","BankCode":"BOC "},
     {"BankName":"中国光大银行","BankCode":"CEB "},
     {"BankName":"中国民生银行","BankCode":"CMBC"},
     {"BankName":"中信银行","BankCode":"CITIC"},
     {"BankName":"平安银行","BankCode":"SZPAB"},
     {"BankName":"上海浦东发展银行","BankCode":"SPDB"},
     {"BankName":"兴业银行","BankCode":"CIB"},
     {"BankName":"邮政银行","BankCode":"POST-NET"}]
     
     */
}

enum ModifyType {
    case edit, bind, password
}
//判断是个人信息界面还是银行卡界面

enum InfoType {
    case PersonInfo,BankInfo
}


class PersonModel: NSObject {
    
    
    //获取中心钱包余额地址
    let allAccountUrl = "Account"
    //发送基本休息修改的地址
    let infoModifyAddr = "Account/BindBaseInfo"
    
    //子导航栏高度
    let subTitleHeight: CGFloat = isPhone ? 44 : 30
    //子导航按钮字体颜色
    let subTitleBtnColor1 = UIColor.colorWithCustom(r: 129, g: 129, b: 129)
    let subTitleBtnColor2 = UIColor.colorWithCustom(r: 186, g: 9, b: 31)
    let subTitleBackColor = UIColor.colorWithCustom(r: 227, g: 228, b: 231)
    
    //个人资料一个栏位的高度
    let infoColumHeight:CGFloat = isPhone ? 54 : 40
    let infoLabel = ["真实姓名","出生日期","注册日期","手机号码","电子邮箱"," QQ 号码","微信号码","更改密码","",""]
    let passwordInfoLabel = ["请输入旧密码","请输入新密码","请再次输入您的新密码"]
    //
    let alertLabelText = ["","不得少于两位","卡号长度不对","不得小于五位"]
    //let infoDataSource = ["尼古拉赵四","1980-3-28","2016-5-10","13800138000","futu@gmail.com","23422323422","safari_123","",""] as [Any]
    
    //银行标签的高度及间距
    let bankInterval:CGFloat = isPhone ? 14 : 10
    let bankHeight:CGFloat = isPhone ? 115 : 80
    //    var dataSource = [["中国工商银行","ICBC","6214830256861849",true],
    //                      ["邮政银行","POST-NET","6217830256861859",false],
    //                      ["中国招商银行","CMB","6219830256861869",false],
    //                      ["中国建设银行","CCB","6210830256861879",false],
    //                      ["中国农业银行","ABC","6210830256861879",false],
    //                      ["中国交通银行","COMM","6210830256861879",false],
    //                      ["中国银行","BOC","6210830256861879",false],
    //                      ["中国光大银行","CEB","6210830256861879",false],
    //                      ["中国民生银行","CMBC","6210830256861879",false],
    //                      ["中信银行","CITIC","6210830256861879",false],
    //                      ["上海浦东发展银行","SPDB","6210830256861889",false]]
    
    var bankDataSource = [["加载中..","","88888888888",false,"","",""]]
    
    let bankName = ["中国工商银行","中国农业银行","邮政银行","中国招商银行","中国建设银行","中国交通银行","中国银行","中国光大银行","中国民生银行","中信银行","平安银行","上海浦东发展银行","兴业银行"]
    let bankCode = ["ICBC","ABC","POST-NET","CMB","CCB","COMM","BOC","CEB","CMBC","CITIC","SZPAB","SPDB","CIB"]
    
    let bankInfo:Dictionary<String,String> = ["中国工商银行":"ICBC","中国农业银行":"ABC","邮政银行":"POST-NET","中国招商银行":"CMB","中国建设银行":"CCB","中国交通银行":"COMM","中国银行":"BOC","中国光大银行":"CEB","中国民生银行":"CMBC","中信银行":"CITIC","平安银行":"SZPAB","上海浦东发展银行":"SPDB","兴业银行":"CIB"]
    
    
    func getAccount(success: @escaping (() -> ())) -> Void {
        //获取中心钱包余额
        if userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue) != nil {
            futuNetworkRequest(type: .get,serializer: .json, url: self.allAccountUrl, params: ["":""], success: { (response) in
                tlPrint(message: "response:\(response)")
                let value = (response as AnyObject).value(forKey: "Value") as AnyObject
                
                self.userInfoDeal(userInfo: value as AnyObject, success: {
                    success()
                })
                //self.userInfoDeal(userInfo: value as AnyObject)
            }, failure: { (error) in
                tlPrint(message: "error:\(error)")
            })
        }
    }
    
    func userInfoDeal(userInfo:AnyObject,success: @escaping (() -> ())) -> Void {
        let userInfoKey:[String] = ["AccountName","Balance","BirthDate","DayWithdrawCount","DayWithdrawMax","Email","Id","IsBankBound","IsBasicBound","IsEmailBound","IsPhoneBound","LastLogin","Mobile","QQ","Wechat","RealName","RegisterTime","Sex","UserLevel","VipLevel"]
        
        for i in 0 ..< userInfoKey.count {
            let value = userInfo.value(forKey: userInfoKey[i])
            //此接口的数据，存储在userdefaults的键名为“userInfo”加上收到的键名
            
            if value == nil || value is NSNull {
                continue
            }
            tlPrint(message: "i = \(i)")
            let savedValue = userDefaults.value(forKey: "userInfo\(userInfoKey[i])")
            if savedValue == nil || "\(String(describing: value))" != "\(String(describing: savedValue))" {
                userDefaults.setValue(value, forKey: "userInfo\(userInfoKey[i])")
            }
        }
        success()
    }
    
    
    //获取银行卡的信息
    func getBankInfo(success: @escaping (([[Any]]) -> ())) -> Void {
        tlPrint(message: "getBankInfo")
        
        futuNetworkRequest(type: .get, serializer: .json, url: "UserBankInfo", params: ["":""], success: { (response) in
            tlPrint(message: "response:\(response)")
            let bankArray = response as! NSArray
            let infoKeys = ["BankName"
                ,"BankCode","CardNo","IsDefault","BankAddress","CardOwnerName","Id"]
            if bankArray.count <= 0 {
                tlPrint(message: "没有绑定银行卡")
            } else {
                self.bankDataSource.removeAll()
                self.bankDataSource = [["加载中..","","88888888888",false,"","",""]]
                
                for i in 1 ... bankArray.count {
                    if i <= bankArray.count  {
                        self.bankDataSource.append([""])
                    }
                    for j in 0 ..< infoKeys.count {
                        if let infoValue = (bankArray[i-1] as AnyObject).value(forKey: infoKeys[j]) {
                            self.bankDataSource[i].append(infoValue)
                        } else {
                            self.bankDataSource[i].append("")
                        }
                    }
                    self.bankDataSource[i].remove(at: 0)
                }
            }
            
            if self.bankDataSource[0][0] as! String == "加载中.." {
                tlPrint(message: "self.dataSource[0][0]:\(self.bankDataSource[0][0])")
                self.bankDataSource.remove(at: 0)
            }
            
            //排序将默认的银行 放到第一位
            tlPrint(message: "**********  bankDataSource:\n\(self.bankDataSource)")
            
            for i in 0 ..< self.bankDataSource.count {
                if i == 0 {
                    continue
                }
                if self.bankDataSource[i][3] as! Bool {
                    TLPrint("0:\(self.bankDataSource[0])    i:\(i)  \(self.bankDataSource[i])")
//                    swap(&self.bankDataSource[0], &self.bankDataSource[i])
                    let temp = self.bankDataSource[0]
                    let temp2 = self.bankDataSource[i]
                    self.bankDataSource[0] = temp2
                    self.bankDataSource[i] = temp
                }
            }
            tlPrint(message: "sorted datasource:\(self.bankDataSource)")
            success(self.bankDataSource)
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
        })
    }
    
    
    func changePassword(passwordDic:Dictionary<String,String>,success:@escaping(()->()),failed:@escaping(()->())) -> Void {
        tlPrint(message: "changePassword passwordDic = \(passwordDic)")
        let url = "Account/ChangePassword"

        
        let param = ["OldPassword":passwordDic["OldPassword"],"NewPassword":passwordDic["NewPassword"],"ConfirmPassword":passwordDic["ConfirmPassword"]!]
        
        
        futuNetworkRequest(type: .post, serializer: .http, url: url, params: param, success: { (response) in
            tlPrint(message: "response:\(response)")
            let string = String(data: response as! Data, encoding: String.Encoding.utf8)
            
            tlPrint(message: "string0:\(String(describing: string))")
            if string == nil || string == "\"Failed\"" || string == "" {
                failed()
                return
            }
            //修改PT密码
//            let ptUrl = "Game/PTChangePassword"
            let ptUrl = "Game/GameChangePassword"
            futuNetworkRequest(type: .post, serializer: .http, url: ptUrl, params: ["NewPassword":passwordDic["NewPassword"] ?? "123456"], success: { (response) in
                tlPrint(message: "PT response")
                let ptString = String(data: response as! Data, encoding: String.Encoding.utf8)
                
                tlPrint(message: "ptString:\(String(describing: ptString))")
//                if ptString == nil || ptString == "\"Failed\"" || ptString == "" {
//                    failed()
//                    return
//                }
                if ptString != nil || ptString != "" {
                    success()
                }
            }, failure: { (error) in
                tlPrint(message: "pt error")
            })
           
            
            
            
        }) { (error) in
            tlPrint(message: error)
            failed()
        }
        
        
        
    }
}
