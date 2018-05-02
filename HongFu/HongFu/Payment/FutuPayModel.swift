//
//  FutuPayModel.swift
//  FuTu
//
//  Created by Administrator1 on 6/10/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit


//public let webapi = "api.toobet.com"
//public let weburl = "/api/MobileOnlineDeposit/OnlineProcess"

class FutuPayModel: NSObject {

}
//Dinpay 为智付支付
class DinpayModel: NSObject {
    
    //商户号
    var merchant: String
    //用户ID
    var userId: String
    //订单金额
    var orderAmount: Float
    //订单时间
    var orderDate: String
    //订单号
    var orderNo: String
    //回调链接
    var returnUrl: String
    
    
    
    init(merchant: String, userId: String,orderAmount: Float, orderDate: String, orderNo: String, returnUrl: String) {
        self.merchant = merchant
        self.userId = userId
        self.orderAmount = orderAmount
        self.orderDate = orderDate
        self.orderNo = orderNo
        self.returnUrl = returnUrl
    }
    
    func me_dinpayKeyValue() -> (key:[String],value:[String]) {
        return (["","",""],["d","",""])
    }
}


//请求对象
public struct onPayModel {
    // 支付金额
    public var Amount: Float
    // 支付类型:在线支付:1
    public var paytype: String
}

//返回对象
public struct ResultMobile {
    // 成功:true  失败:false
    public var Success: Bool
    // 提示信息
    public var Message: String
    // 成功后,返回的数据结构
    public var OrderModel: OrderCommitModel
}


//参数数据结构
public struct OrderCommitModel {
    // 用户ID
    public var user_id: String
    // 我们的API 密匙
    public var KEYForApi: String
    // 我们自己系统定义的支付名称,如: ZF_02
    public var PayName: String
    // 在我们系统的订单号
    public var Billno: String
    // 充值金额
    public var Amount: Float
    // 订单日期
    public var BillDate: String
    // 货币类型（默认：RMB）
    public var Currency_Type: String
    // 支付卡种
    public var Gateway_Type: String
    // 商户数据包
    public var Attach: String
    // 显示金额
    public var DispAmount: Float
    // 交易返回接口加密方式
    public var RetEncodeType: String
    // Server to Server返回（必选Browser返回（必选）该字段赋值 1：选择
    public var Rettype: String
    // 商户号
    public var MerchantCode: String
    // 回调链接(回调我们中间过程的)
    public var ServerUrl: String
    // 决定商户是否参用直连方式 1为直连  0非直连（测试环境只支持非直连）
    public var DoCredit: Bool
    // 客户付款的银行编码
    public var BankCode: String
    // 有些支付平台需要的商户密码
    public var MerchantKey: String
    // 刷新余额链接
    public var ReturnParam: String
    // 选择在线或微信
    public var ChosePayType: String
    
}
