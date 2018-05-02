//
//  RechargeModel.swift
//  FuTu
//
//  Created by Administrator1 on 27/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

enum rechargeTag:Int {
    case RechargeBackTag = 5,AlertLabelTag,WarmingLabelTag
//    case OnlinePayBtnTag = 10, WechatScanPayBtnTag, AliScanPayBtnTag, QQPayBtnTag, WechatPayBtnTag, AliPayBtnTag, UnionPayBtnTag, TimeCardPayBtnTag
    case WechatPayBtnTag = 10, WechaToBankPayBtnTag, QQPayBtnTag, WechatScanPayBtnTag, AliScanPayBtnTag, OnlinePayBtnTag, AliPayBtnTag, UnionPayBtnTag, TimeCardPayBtnTag
    case InputTextFieldTag = 25,preferentialTextField,NextBtnTag,PreferentialBtnTag,PickerConfirmBtnTag,UnionPayConfirmBtnTag,TimeCardPayConfirmBtnTag
    case PayTypeImg = 40
    case PayTypeText = 50
    case AmountBtnTag = 60
    case RechargeScanBackTag = 70
    case RechargeScanValueLabelTag = 80
    case RechargeScanQRImgTag = 90
    case TimeCardPayTypeBtnTag = 100
    case TimeCardPayInputTextFeildTag = 166
}

//enum PayType:String {
//    case OnlinePay = "1"
//    case WeChatPay = "13"
//    case AliPay = "12"
//    case UnionPay = "50"
//    case WechatScanPay = "51"
//    case AliScanPay = "52"
//    case TimePay = "00:"
//}

enum PayType:String {
    case OnlinePay = "1"
    case WeChatPay = "51"
    case AliPay = "52"
    case UnionPay = "50"
    case WechatScanPay = "13"
    case AliScanPay = "12"
    case TimePay = "14"
    case QQPay = "15"
    case FastPay = "16"
    case WechaToBank = "100"
}

class RechargeModel: NSObject {

    //支付类型视图的高度
    let payTypeViewHeight:CGFloat = isPhone ? 230 : 180
    
    //支付按钮图片的宽度
    let payImgWidth:CGFloat = isPhone ? 45 : 32
    
    //金额选择按钮的宽度
    let choiceBtnWidth:CGFloat = 115
    let choiceBtnHieght:CGFloat = 55
    //点卡类型数组
    let timeCardTypeArray = ["YDSZX","LTYKT","DXGK","JWYKT","SDYKT","QBCZK","WMYKT","ZTYKT","WYYKT","SHYKT","JYYKT","THYKT","ZYYKT","TXYKTZX","SFYKT"]
    
    //供选择的金额
    
    
    let choiceValue = ["100","300","500","1000","2000","3000"]
    
//    let bankCode = ["online","weixin","alipay"]
    
    
    var unionPayRnd:String!
    
    //支付类型数组
    let payTypeArray = [
                        PayType.WeChatPay,
                        PayType.WechaToBank,
                        PayType.QQPay,
                        PayType.WechatScanPay,
                        PayType.AliScanPay,
                        PayType.OnlinePay,
                        PayType.UnionPay,
                        PayType.FastPay,]
    let payNameDic = [PayType.WeChatPay:"微信支付",]
    //限额
    
    let limitAmount = [
                       PayType.WeChatPay:isRelease ? [20,50000] : [10,10000],
                       PayType.WechaToBank:isRelease ? [100,2999] : [10,999],
                       PayType.QQPay:isRelease ? [31,5000] : [11,999],
                       PayType.WechatScanPay:isRelease ? [30.01,999.99] : [11,999],
                       PayType.AliScanPay:isRelease ? [200.01,2999.99] : [11,999],
                       
                       PayType.OnlinePay: isRelease ? [20,100000] : [10,10000],
//                       PayType.AliPay:isRelease ? [20,49999] : [10,10000],
                       PayType.UnionPay:isRelease ? [20,100000] : [10,10000],
                       PayType.FastPay:isRelease ? [50,5000] : [10,10000]]
    
    
    func nextBtnAct(rechargeView:UIView, payType:PayType) -> Bool {
        
        
        let amountTextField = rechargeView.viewWithTag(rechargeTag.InputTextFieldTag.rawValue) as! UITextField
        let preferTextField = rechargeView.viewWithTag(rechargeTag.preferentialTextField.rawValue) as! UITextField
        var value:Double = 0
        if amountTextField.text != nil && amountTextField.text != ""{
            tlPrint(message: "text value:\(String(describing: amountTextField.text))")
            value = Double(amountTextField.text!)!
        }
        let lowLimit:Double = Double((limitAmount[payType]!)[0])
        let hightLimit:Double = Double((limitAmount[payType]!)[1])
        
        tlPrint(message: preferTextField.text)
        if value < lowLimit {
            tlPrint(message: "请输入正确金额")
            let alert = UIAlertView(title: "输入有误", message: "输入金额至少\(lowLimit)", delegate: nil, cancelButtonTitle: "重新输入")
            DispatchQueue.main.async {
                alert.show()
            }
            return false
        } else if value > hightLimit {
            let alert = UIAlertView(title: "输入有误", message: "输入金额不能大于\(hightLimit)", delegate: nil, cancelButtonTitle: "重新输入")
            DispatchQueue.main.async {
                alert.show()
            }
            return false
        } else if payType == PayType.WechatScanPay || payType == PayType.AliScanPay {
            if !amountTextField.text!.contains(".") {
                let alert = UIAlertView(title: "支付提醒", message: "为了您的支付更顺畅，请输入小数金额，如98.23 、508.01元", delegate: nil, cancelButtonTitle: "确  定")
                alert.show()
                return false
            }
        } else if payType == PayType.QQPay {
            //微信扫码，支付宝扫码和QQ扫码金额不能为10的倍数
            if (Int(value) % 10) == 0 {
                let alert = UIAlertView(title: "支付提醒", message: "为了您的支付更顺畅，请输入不是10倍数的金额，如98 、508元", delegate: nil, cancelButtonTitle: "好 的")
                alert.show()
                return false
            }
        }
        //贷款3785760
        if preferTextField.text == nil {
            if value < lowLimit {
                tlPrint(message: "请输入正确金额")
                let alert = UIAlertView(title: "输入有误", message: "输入金额至少\(lowLimit)", delegate: nil, cancelButtonTitle: "重新输入")
                DispatchQueue.main.async {
                    alert.show()
                }
                return false
            } else if value > hightLimit {
                let alert = UIAlertView(title: "输入有误", message: "输入金额不能大于\(hightLimit)", delegate: nil, cancelButtonTitle: "重新输入")
                DispatchQueue.main.async {
                    alert.show()
                }
                return false
            } else {
                tlPrint(message: "充值\(value)元")
                return true
            }
        } else if preferTextField.text!.components(separatedBy: "首存奖金").count > 1 {
            if value < (isRelease ? 100 : 10)  {
                tlPrint(message: "请输入正确金额")
                let alert = UIAlertView(title: "首存优惠", message: "申请首存优惠输入金额至少100", delegate: nil, cancelButtonTitle: "重新输入")
                DispatchQueue.main.async {
                    alert.show()
                }
                return false
            } else {
                tlPrint(message: "充值\(value)元")
                return true
            }
        
        } else if preferTextField.text!.components(separatedBy: "再存15%").count > 1 || preferTextField.text!.components(separatedBy: "再存25%").count > 1 || preferTextField.text!.components(separatedBy: "再存35%").count > 1 {
            if value < (isRelease ? 200 : 10) {
                tlPrint(message: "请输入正确金额")
                let alert = UIAlertView(title: "再存优惠", message: "申请再存优惠输入金额至少200", delegate: nil, cancelButtonTitle: "重新输入")
                DispatchQueue.main.async {
                    alert.show()
                }
                return false
            } else {
                tlPrint(message: "充值\(value)元")
                return true
            }
            
        } else {
            if value < lowLimit {
                tlPrint(message: "请输入正确金额")
                let alert = UIAlertView(title: "输入有误", message: "输入金额至少\(lowLimit)", delegate: nil, cancelButtonTitle: "重新输入")
                DispatchQueue.main.async {
                    alert.show()
                }
                return false
            } else if value > hightLimit {
                let alert = UIAlertView(title: "输入有误", message: "输入金额不能大于\(hightLimit)", delegate: nil, cancelButtonTitle: "重新输入")
                DispatchQueue.main.async {
                    alert.show()
                }
                return false
            } else {
                tlPrint(message: "充值\(value)元")
                return true
            }
        }
    }
    /*
     RechargeViewController.swift [148]:  params:{
     Amount = "100.0";
     BankCode =  ;
     ReturnDomain = "m2.toobet.co/WalletRecharge";
     paytype = 13;
     }
     */
    
//    func scanPayRequest(payType:PayType,amount:String,success:@escaping((payInfo:Dictionary<String,Any>))->(),failure:@escaping(()->())) -> Void {
//        tlPrint(message: "scanPayPost")
//        let userDefaults = UserDefaults.standard
//        let userId = userDefaults.value(forKey: userDefaultsKeys.userInfoId.rawValue)
//        let userLevel = userDefaults.value(forKey: userDefaultsKeys.userInfoUserLevel.rawValue)
//        
//        
//        let bankCode = (payType == PayType.WechatScanPay ? "weixin" : (payType == PayType.AliScanPay ? "alipay" : "unionpay" ))
//        let payTypeKey = (payType == PayType.WechatScanPay ? "3" : (payType == PayType.AliScanPay ? "2" : "ICBC" ))
//        
//        let url = (payType == PayType.WechatScanPay ? "AliPayDeposit/WxPayDeposite" : (payType == PayType.AliScanPay ? "AliPayDeposit/AliPayDeposite" : "Transact/FastDeposite"))
//        let param = ["Amount":amount,"BankCode":bankCode,"PayType":payTypeKey,"ReturnDomain":"/Wallet","UserId":userId,"UserLevel":userLevel]
//    
//    
//        futuNetworkRequest(type: .post, serializer: .json, url: url, params: param, success: { (response) in
//            tlPrint(message: "response:\(response)")
//            success(response as! Dictionary<String,Any>)
//        }, failure: { (error) in
//            tlPrint(message: "Error:\(error)")
//            failure()
//        })
//    }
    
    func getDepositActivesList(success:@escaping([Dictionary<String,Any>])->(),failure:@escaping(()->())) -> (Void){
    
        let url = "Active/GetHfDepositActivesList"

        futuNetworkRequest(type: .get, serializer: .http, url: url, params: ["":""], success: { (response) in
            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
            tlPrint(message: string)
            string = string!.replacingOccurrences(of: "\"{", with: "{")
            string = string!.replacingOccurrences(of: "}\"", with: "}")
            string = string!.replacingOccurrences(of: "\\", with: "")
            if string == "Failed" || string == "\"Failed\"" || string == "\"Failed\"" || string == "\"null\"" {
                tlPrint(message: "error string: \(String(describing: string))")
                failure()
                return
            }
            //将数据处理为json字符串数组
            var array = string!.components(separatedBy: ",{")
            array[0] = array[0].replacingOccurrences(of: "[{", with: "{")
            array[array.count - 1] = array[array.count - 1].replacingOccurrences(of: "}]", with: "}")
            var listDicArray:[Dictionary<String,Any>]!
            for i in 0 ..< array.count {
                let sepArray = array[i].components(separatedBy: ",\"Id\":")
                array[i] = sepArray[0]
                if i == 0 {
                    array[i] = array[i].replacingOccurrences(of: "\"{", with: "")
                }
                    array[i] = "{" + array[i] + "}"
                tlPrint(message: array)
                //["{\"Activity_Code\":\"Second15\",\"Main_Title\":\"再存15%\",\"Id\":89}}", "\"Activity_Code\":\"Second25\",\"Main_Title\":\"再存25%\",\"Id\":90}", "\"Activity_Code\":\"AGFirstDpBonus\",\"Main_Title\":\"【AG首存优惠】\",\"Id\":100}", "\"Activity_Code\":\"AGSecond8\",\"Main_Title\":\"【AG再存优惠】\",\"Id\":101}\""]
                //将字符串转换为字典，放到字典数组里面
                if let activesInfo = array[i].toDictionary(dicString: array[i]) {
                    if listDicArray == nil {
                        listDicArray = [activesInfo]
                    } else {
                        listDicArray.insert(activesInfo, at: i)
                    }
                }
            }
            let defaultArray = ["Main_Title":"下回再参与","Activity_Code":"no_activiticode"]
            listDicArray.insert(defaultArray, at: 0)
            tlPrint(message: "listDicArray:\(listDicArray)")
            success(listDicArray)
        }, failure: { (error) in
            tlPrint(message: "Error:\(error)")
        })
    }
    /*
     
     [[Actclassid:6,Activity_Code:FirstDpBonus,Condition:,Main_Title:首存奖金,Sub_Title:针对老虎机的首存奖金,Description:?针对老虎机的首存奖金,Imagelink:/FileUpload/20170619170258416.png,Start_Time:2017-06-19T00:00:00,End_Time:2020-06-19T00:00:00,Fake_Number:0,Is_Need_Approve:0,Is_Published:1,Published_Admin_Id:,Is_Closed:1,Update_Admin_Id:95,Update_Time:2017-06-19T17:07:00,Create_Admin_Id:6,Create_Time:2017-06-19T10:57:00,Is_Del:0,Id:88],
     [Actclassid:6,Activity_Code:Second15,Condition:,Main_Title:再存15%,Sub_Title:老虎机再存15%优惠,Description:老虎机再存15%优惠,Imagelink:/FileUpload/20170619170246257.png,Start_Time:2017-06-19T00:00:00,End_Time:2019-06-19T00:00:00,Fake_Number:0,Is_Need_Approve:0,Is_Published:1,Published_Admin_Id:,Is_Closed:1,Update_Admin_Id:95,Update_Time:2017-06-19T17:07:00,Create_Admin_Id:6,Create_Time:2017-06-19T10:59:00,Is_Del:0,Id:89]]
     
     
     */
    
//    func timePayRequest(payType:PayType,amount:String,activityCode:String,cardCode:String,cardInfo:[String],success:@escaping((Dictionary<String,Any>))->(),failure:@escaping(()->())) -> Void {
//        tlPrint(message: "scanPayPost")
//        let url = "MobileOnlineDeposit/OnlineProcess"
//
//        let param = ["Amount":amount,"BankCode":"online","CardCode": cardCode,"CardNo":cardInfo[0],"CardPw":cardInfo[1],"PayType":payType.rawValue,"ActCode":activityCode,"ReturnDomain":"www.toobet.com/accountgrowth"]
//        
//        tlPrint(message: "param: \(param)")
//        
//        futuNetworkRequest(type: .post, serializer: .http, url: url, params: param, success: { (response) in
//            
//            tlPrint(message: "response:\(response)")
//            if "\(response)" == "Failed" || "\(response)" == "\"Failed\"" || "\(response)" == "\"null\"" {
//                tlPrint(message: "error response: \(String(describing: "\(response)"))")
//                failure()
//                return
//            }
//            
//            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
//            string = string!.replacingOccurrences(of: "\"{", with: "{")
//            string = string!.replacingOccurrences(of: "}\"", with: "}")
//            string = string!.replacingOccurrences(of: "\\", with: "")
//            tlPrint(message: "string:\(String(describing: string))")
//            if string == "Failed" || string == "\"Failed\"" || string == "\"Failed\"" || string == "\"null\"" {
//                tlPrint(message: "error string: \(String(describing: string))")
//                failure()
//                return
//            }
//            let scanPayDic = (string!).objectFromJSONString() as! Dictionary<String, Any>
//            success(scanPayDic)
//            
//        }, failure: { (error) in
//            tlPrint(message: "Error:\(error)")
//            failure()
//        })
//
//    }
    
    //用于扫码添加支付(转账)
    func scanPayRequest(payType:PayType,amount:String!,activityCode:String!,success:@escaping((Dictionary<String,Any>))->(),failure:@escaping(()->())) -> Void {
        tlPrint(message: "scanPayPost，paytype = \(payType)")
        let userDefaults = UserDefaults.standard
        let userId = userDefaults.value(forKey: userDefaultsKeys.userInfoId.rawValue)!
        let userLevel = userDefaults.value(forKey: userDefaultsKeys.userInfoUserLevel.rawValue)!
        
        
        let bankCode:String! = (payType == PayType.WeChatPay ? "weixin" : (payType == PayType.AliPay ? "alipay" : "unionpay"))
        let payTypeKey:String! = (payType == PayType.WeChatPay ? "3" : (payType == PayType.AliPay ? "2" : "ICBC" ))
        
        let url:String! = (payType == PayType.WeChatPay ? "AliPayDeposit/WxPayDeposite" : (payType == PayType.AliPay ? "AliPayDeposit/AliPayDeposite" : "Transact/FastDeposite"))

        let param = ["Amount":amount,"BankCode":bankCode,"PayType":payTypeKey,"ActCode":activityCode,"ReturnDomain":"/Wallet","UserId":userId,"UserLevel":userLevel]
//        let param = ["Amount":amount,"ActCode":activityCode]
        
        futuNetworkRequest(type: .post, serializer: .http, url: url, params: param, success: { (response) in
            
            tlPrint(message: "response:\(response)")
            if "\(response)" == "Failed" || "\(response)" == "\"Failed\"" || "\(response)" == "\"null\"" {
                tlPrint(message: "error response: \(String(describing: "\(response)"))")
                failure()
                return
            }
            let string = String(data: response as! Data, encoding: String.Encoding.utf8)
            tlPrint(message: "string:\(String(describing: string))")
            
            if string == "Failed" || string == "\"Failed\"" || string == "null" || string == "\"null\"" {
                tlPrint(message: "error string: \(String(describing: string!))")
                failure()
                return
            }
            let scanPayDic = (string!).objectFromJSONString() as! Dictionary<String, Any>
            self.unionPayRnd = scanPayDic["Rnd"] as! String
            success(scanPayDic)
            
        }, failure: { (error) in
            tlPrint(message: "Error:\(error)")
            failure()
        })
    }
    
    
    
    
    /*
     ["Amount": Optional("2000"), "UserId": Optional(1900729), "UserLevel": Optional(1), "BankType": Optional("ICBC"), "ActCode": Optional("no"), "ReturnDomain": Optional("/Wallet"), "BankCode": Optional("unionpay")]
     ["Amount": Optional("2000"), "UserId": Optional(1900729), "PayType": Optional("3"), "UserLevel": Optional(1), "ActCode": Optional("no"), "ReturnDomain": Optional("/Wallet"), "BankCode": Optional("weixin")]
     ["BankCode": Optional("weixin"), "UserLevel": Optional(1), "Amount": Optional("200"), "UserId": Optional(1900729), "ReturnDomain": Optional("/Wallet"), "PayType": Optional("3")]

     
     
     */
    
    
    
    func unionPayRequest(amount:String,activityCode:String,success:@escaping((Dictionary<String,Any>))->(),failure:@escaping(()->())) -> Void {
        tlPrint(message: "unionPayRequest")
        let userDefaults = UserDefaults.standard
        let userId = userDefaults.value(forKey: userDefaultsKeys.userInfoId.rawValue)
        let userLevel = userDefaults.value(forKey: userDefaultsKeys.userInfoUserLevel.rawValue)
        
        let param = ["Amount":amount,"BankCode":"unionpay","BankType":"ICBC","ActCode":activityCode,"ReturnDomain":"/Wallet","UserId":userId,"UserLevel":userLevel]
        
        
        futuNetworkRequest(type: .post, serializer: .http, url: "Transact/FastDeposite", params: param, success: { (response) in
            let string = String(data: response as! Data, encoding: String.Encoding.utf8)
            TLPrint("string: \(string)")
            if string == "Failed" || string == "\"Failed\"" || string == "\"Failed\"" || string == "\"null\""{
               
                tlPrint(message: "error string: \(String(describing: string))")
                failure()
                return
            }
            var unionPayDic : Dictionary<String, Any>
            if string!.contains("请重新登录!") {
                unionPayDic = ["reLogin":"您的账户在别的地方登录，请重新登录!"]
            } else {
                unionPayDic = (string!).objectFromJSONString() as! Dictionary<String, Any>
                self.unionPayRnd = unionPayDic["Rnd"] as! String
            }
            success(unionPayDic)
        }, failure: { (error) in
            tlPrint(message: "Error:\(error)")
            failure()
        })
    }
    
    func unionPayConfirmRequest(actCode:String,rnd:String,success:@escaping(()->()),failure:@escaping(()->())) -> Void {
        tlPrint(message: "unionPayConfirmRequest")
        
        let param = ["rnd":rnd,"ActCode":actCode]
        futuNetworkRequest(type: .post, serializer: .http, url: "Transact/ConfirmDeposit", params: param, success: { (response) in
            tlPrint(message: "response:\(response)")
            let string = String(data: response as! Data, encoding: String.Encoding.utf8)
            tlPrint("string:\(String(describing: string))")
            if string == "Failed" || string == "\"Failed\"" || string == "" || string == "null"{
                failure()
                return
            }
            success()
        }, failure: { (error) in
            tlPrint(message: "Error:\(error)")
            failure()
        })
    }
    
    
    //获取微信支付号码
    func getWechatAccount(success:@escaping((String)->()),failure:@escaping(()->())) -> Void {
        let url = "AliPayDeposit/GetWxDpConfig"
        futuNetworkRequest(type: .get, serializer: .http, url: url, params: nil, success: { (response) in
            tlPrint(message: "response:\(response)")
            let string = String(data: response as! Data, encoding: String.Encoding.utf8)
            tlPrint(message: "string:\(String(describing: string))")
            if string == "Failed" || string == "" || string == "\"Failed\""{
                failure()
                return
            }
            let wechatPayDic = (string!).objectFromJSONString() as! Dictionary<String, Any>
            let wechatAccount = wechatPayDic["AccountName"] as! String
            success(wechatAccount)
            
        }) { (error) in
            tlPrint(message: "error:\(error)")
            failure()
        }
    }
    
}
