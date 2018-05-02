//
//  ServiceModel.swift
//  FuTu
//
//  Created by Administrator1 on 22/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit


enum serviceTag: Int{
    case BackBtn = 10, OnlineServiceBtn, SearchTextField, SearchBtn,AnswerCloseBtn, SearchBackBtn,SearchInputTextFeild,SearchQuesBtn, QuestionBtn
    
    case AnswerBtn = 30
    case AnswerInfoText = 40
    
    case SearchAnserBtn = 80
    case SearchAnserInfoText = 90
}

class ServiceModel: NSObject {

    //banner高度
    let bannerHeight:CGFloat = 222
    //各个视图之间的间距，漏底色部分高度
    let viewDistance:CGFloat = 6
    let viewDistancePad:CGFloat = 4
    //问题视图的高度
    let questionHeight:CGFloat = 390
    let questionHeightPad:CGFloat = 330
    
    //scroll可以滑动的最大距离
    let scrollDistance:CGFloat = 80
    
    
    let onlineServiceURL = "http://kefu.cckefu.com/vclient/chat/?websiteid=132526"
    let quesHeight:CGFloat = 44
    let quesHeightPad:CGFloat = 30
    let quesFrame = [CGRect(x: adapt_W(width: 31), y: adapt_H(height: 106), width: adapt_W(width: 136), height: adapt_H(height: 44)),
                     CGRect(x: adapt_W(width: 190), y: adapt_H(height: 137), width: adapt_W(width: 165), height: adapt_H(height: 44)),
                     CGRect(x: adapt_W(width: 88), y: adapt_H(height: 194), width: adapt_W(width: 130), height: adapt_H(height: 44)),
                     CGRect(x: adapt_W(width: 195), y: adapt_H(height: 260), width: adapt_W(width: 142), height: adapt_H(height: 44)),
                     CGRect(x: adapt_W(width: 21), y: adapt_H(height: 284), width: adapt_W(width: 150), height: adapt_H(height: 44)),
                     CGRect(x: adapt_W(width: 19), y: adapt_H(height: 172), width: adapt_W(width: 120), height: adapt_H(height: 44)),
                     CGRect(x: adapt_W(width: 250), y: adapt_H(height: 210), width: adapt_W(width: 120), height: adapt_H(height: 44)),
                     CGRect(x: adapt_W(width: 110), y: adapt_H(height: 253), width: adapt_W(width: 120), height: adapt_H(height: 44))]
    let quesFramePad = [CGRect(x: adapt_W(width: 31), y: adapt_H(height: 66), width: adapt_W(width: 136), height: adapt_H(height: 35)),
                        CGRect(x: adapt_W(width: 190), y: adapt_H(height: 97), width: adapt_W(width: 165), height: adapt_H(height: 35)),
                        CGRect(x: adapt_W(width: 88), y: adapt_H(height: 154), width: adapt_W(width: 130), height: adapt_H(height: 35)),
                        CGRect(x: adapt_W(width: 195), y: adapt_H(height: 220), width: adapt_W(width: 142), height: adapt_H(height: 35)),
                        CGRect(x: adapt_W(width: 21), y: adapt_H(height: 244), width: adapt_W(width: 150), height: adapt_H(height: 35)),
                        CGRect(x: adapt_W(width: 19), y: adapt_H(height: 132), width: adapt_W(width: 120), height: adapt_H(height: 35)),
                        CGRect(x: adapt_W(width: 250), y: adapt_H(height: 170), width: adapt_W(width: 120), height: adapt_H(height: 35)),
                        CGRect(x: adapt_W(width: 110), y: adapt_H(height: 213), width: adapt_W(width: 120), height: adapt_H(height: 35))]
    let quesText = [["存取款问题",UIColor.colorWithCustom(r: 109, g: 109, b: 239)],
                    ["账号／密码问题",UIColor.colorWithCustom(r: 264, g: 100, b: 152)],
                    ["资料安全问题",UIColor.colorWithCustom(r: 255, g: 138, b: 0)],
                    ["如何游戏",UIColor.colorWithCustom(r: 204, g: 86, b: 243)],
                    ["绑定银行卡",UIColor.colorWithCustom(r: 42, g: 186, b: 147)],
                    ["",UIColor.clear],
                    ["",UIColor.clear],
                    ["",UIColor.clear]]

    
//    let answerInfo = [
//                      [["",""]],
//                      [["如何注册鸿福娱乐账户？","您只需要简单一步，即可以拥有一个鸿福娱乐账户。点击网站首页上方“免费注册”或登录窗口下方的“没有账号？免费注册体验”，在弹出的注册表内输入您的用户名、密码、电子邮箱及个人资料并提交后就可以完成开户。请留意：用户名长度须为6~12位字符，由数字、字母及下划线组成，密码长度须为6~12位字符为数字和字母组合；注册前，请务必确认您已满18周岁并已阅读过我们的服务条款和隐私政策。"],
//                       ["如果忘记密码，怎样重置密码？","在输入密码前请确认密码长度为6~12位字符，如果您确认遗忘了密码，您可以点击登录框下方的“忘记登录密码？”进行找回密码操作。找回密码操作的前提是您的账户已绑定手机号码或已经绑定邮箱地址。如果上述两者您都没有绑定，请您点击“在线客户”获得帮助。"],
//                       ["注册后忘记了登录账户怎么办？","若因长时间未登录或其他原因忘记了您的鸿福娱乐账户用户名，请您点击“在线客服”获得帮助，为此您需要提供注册邮箱、绑定手机号码、绑定姓名或其他相关注册信息，我们在线客服会在审核通过后为您提供正确的账户用户名。"]],
//                      [["",""]],
//                      [["在网站注册后，我的个人资料安全有保障吗？","富途娱乐绝对不会泄露您的个人资料给任何第三方，除非收到法庭传单或可行性法律的要求及判决。但我们有权通过网站向有关第三方支付平台服务提供商以及金融保险机构提供必要的个人信息以完成支付要求。所有用户提供的个人信息，其传送都将通过安全端口（SSL 128 bit encryption Standard）并存放在公众无法进入的保密环境之下。所有数据的内部出入都受到限制及严密的监控。"],
//                       ["用户中心有哪些功能？","在您登录账户后，可以在网页上方找到“用户中心”；在进入“用户中心”后您可以办理存款、提款及转账到各游戏场馆、查询账户安全等级、更新和绑定个人资料、修改密码和查询账户交易记录及账号LV级别等。"],
//                       ["允许我在富途娱乐(TOOBET)进行游戏吗？","在您注册和投注前，请务必确保您已年满18周岁并同意我们的服务条款和隐私政策。不同的国家或地区有不同的监管条例，请在投注前遵循当地法规与法律。"]],
//                      [["",""]]]
    
    
    let answerInfo = [[["如何存款？","登录您的鸿福账户，然后点击首页上方的”存款“，选择微信、支付宝、在线充值或网银充值，填写存款金额提交后完成支付操作即可。"],
                       ["存款掉单(扣款成功但未到投注账户)","存款掉单现象，出现这个问题的原因是：一,由于区域网络延时导致;二是在操作存款过程中，没有在最后点击交易成功的步骤，导致信息没有及时发送到支付平台，从而出现掉单的情况，这个情况您不用担心，我们将及时联系支付平台进行对账。如若成功支付届时便会入账，如果支付失败，款项会被退回网银账户。"],
                       ["是否可以使用第三方账户存款？","用户账户交易必须由本人进行操作，原则上不能使用不同姓名的人银行卡进行交易，如果因第三方交易引发其它的法律事务本公司将不予办理，同时如果发现使用第三方交易，我们也有权要求用户提供相关资料进行审核  "],
                       ["存款多久可以到账?","存款提交并成功支付后，一般会在1--3分钟便可入账。"],
                       ["存款支持什么货币？什么银行都可以存款吗？","网站目前仅支持人民币交易，只要您的银行卡有开通网银和转账功能都是可以正常存款的。"],
                       ["提款限额是多少？","网站最低提款是100元，单笔最高提款20万，每日提款次数5次，每日最高100万。"],
                       ["提款处理时间是多少？","玩家提款申请成功提交后，相关工作人员会进行审核并移交财务，通常会在5-30分钟内完成整个提款流程。"]],
                      [["如何开设账户?","开设账户只需点击网站首页右上方“立即注册”，在弹出的注册表内输入您的用户名、密码、真实姓名、手机号、电子邮箱进行资料并提交后就可以完成开户。请留意：用户名长度须为6~12位字符，由数字、字母及下划线组成，密码长度须为6~12位字符为数字和字母组合；注册前，请务必确认您已满18周岁并已阅读过我们的服务条款和隐私政策。"],
                       ["同一个用户可否同时使用多个账号吗？","鸿福规定同一会员只能使用一个账号，如发现客户拥有多个户口，公司有权取消其账号以及投注所获得的盈利,同时保留取消或关闭您的账户权利，有权限制客户只保留其中一个户口。"],
                       ["如何修改账户资料？","为保障用户资金安全，账户一经成功注册，资料将不能随意更改，如需更改必须通过身份验证后才能办理。"],
                       ["如何转账到各游戏平台？","登陆账号后，点击右上角“转账”，进入后可以看到各游戏平台的余额，在各个平台下方有转入/转出功能，点击后可以填写金额，再确定即可~。"],
                       ["允许我在鸿福开户游戏吗？","在您注册和投注前，请务必确保您已年满18周岁并同意我们的服务条款和隐私政策。不同的国家或地区有不同的监管条例，请在投注前遵循当地法规与法律。"],
                       ["哪些地区或国家不能在鸿福注册？","以下地区或国家：菲律宾、马来西亚、香港、台湾、新加坡、美国及加拿大不被接受注册开户。"]],
                      [["在鸿福交易合法吗？","鸿福是一家拥有合法牌照的正规公司，在此交易都会受执照监管机构的法律保护。有的国家或地区当地法律禁止博彩，阁下有责任确保当地法律接受相关投注和游戏，并且不会阻止您在我们公司注册开户，鸿福不接受亦不受理因此引起的任何法务问题。"],
                       ["在这里开户注册，资料安全有保障吗？","会员的注册和交易资料都是通过加密处理，鸿福承诺绝对不会泄露您的个人资料给任何第三方，除非收到法庭传单或可行性法律的要求及判决。"],
                       ["网站是否有加密机制？","所有用户提供的个人信息，其传送都将通过安全端口（SSL 128 bit encryption Standard）并存放在公众无法进入的保密环境之下。所有数据的内部出入都受到限制及严密的监控，确保会员信息安全，请您放心！."]],
                      [["怎样转账到娱乐场？","登陆鸿福账号后，进入中心钱包，然后在对应的娱乐场平台“转入”/“转出”功能中操作即可。"],
                       ["投注出错或投诉结算有误？","通过在线客服或者发送邮件到cs@toobet.com联系我们的客服人员查询，并提供以下信息：您的鸿福账号和游戏详情（包括：娱乐场名称、游戏名称、投注编号、金额、时间）以便我们的工作人员为您核实查询。"],
                       ["怎样查看游戏投注流水？","登录到对应平台游戏中，点击“帮助”进行相关游戏流水查询，也可在用户中心点击“我的成长”选择“交易查询”即可查询相关信息"]],
                      [["如何绑定银行卡？最多绑定多少张？","登陆账号后，点击“提款”-“绑定银行卡”，按照提示选择银行卡进行绑定即可。每个会员最多可以绑定5张银行卡，姓名都必须与注册账户的户主本人姓名一致才能正常办理提款。"],
                       ["如何修改银行信息资料？","银行信息资料变更可以登录至“个人中心”---个人资料  银行信息进行绑定完善或变更。无法修改的情况下需联系网站客服人员提交相关验证信息完成电话核实后予以变更"]]]
    
//    
//    let answerInfo = [["如何注册富途娱乐账户？","您只需要简单一步，即可以拥有一个富途娱乐账户。点击网站首页上方“免费注册”或登录窗口下方的“没有账号？免费注册体验”，在弹出的注册表内输入您的用户名、密码、电子邮箱及个人资料并提交后就可以完成开户。请留意：用户名长度须为6~12位字符，由数字、字母及下划线组成，密码长度须为6~12位字符为数字和字母组合；注册前，请务必确认您已满18周岁并已阅读过我们的服务条款和隐私政策。"],
//                      ["如果忘记密码，怎样重置密码？","在输入密码前请确认密码长度为6~12位字符，如果您确认遗忘了密码，您可以点击登录框下方的“忘记登录密码？”进行找回密码操作。找回密码操作的前提是您的账户已绑定手机号码或已经绑定邮箱地址。如果上述两者您都没有绑定，请您点击“在线客户”获得帮助。"],
//                      ["注册后忘记了登录账户怎么办？","若因长时间未登录或其他原因忘记了您的富途娱乐账户用户名，请您点击“在线客服”获得帮助，为此您需要提供注册邮箱、绑定手机号码、绑定姓名或其他相关注册信息，我们在线客服会在审核通过后为您提供正确的账户用户名。"],
//                      ["在网站注册后，我的个人资料安全有保障吗？","富途娱乐绝对不会泄露您的个人资料给任何第三方，除非收到法庭传单或可行性法律的要求及判决。但我们有权通过网站向有关第三方支付平台服务提供商以及金融保险机构提供必要的个人信息以完成支付要求。所有用户提供的个人信息，其传送都将通过安全端口（SSL 128 bit encryption Standard）并存放在公众无法进入的保密环境之下。所有数据的内部出入都受到限制及严密的监控。"],
//                      ["用户中心有哪些功能？","在您登录账户后，可以在网页上方找到“用户中心”；在进入“用户中心”后您可以办理存款、提款及转账到各游戏场馆、查询账户安全等级、更新和绑定个人资料、修改密码和查询账户交易记录及账号LV级别等。"],
//                      ["允许我在富途娱乐(TOOBET)进行游戏吗？","在您注册和投注前，请务必确保您已年满18周岁并同意我们的服务条款和隐私政策。不同的国家或地区有不同的监管条例，请在投注前遵循当地法规与法律。"]]
    
    let answerInfoHeight: CGFloat = 150
    
    
    
    
    
    
    
    
    
    
    
    
    func searchAnswerByKeywords(key:String) -> [Array<Int>]? {
        tlPrint(message: "searchAnswerByKeywords key:\(key)")
        var result: [Array<Int>] = [[0]]
        for i in 0 ... answerInfo.count - 1 {
            for j in 0 ... answerInfo[i].count - 1 {
                tlPrint(message: "i: \(i)   j: \(j)")
                if (answerInfo[i][j][0] ).components(separatedBy: key).count > 1 {
                    result.append([i,j])
                    tlPrint(message: "result: \(result)")
                }
            }
        }
        result.remove(at: 0)
        
        return result.count > 0 ? result : nil
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
