//
//  DinpayViewController.m
//  FuTu
//
//  Created by Administrator1 on 24/9/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

#import "DinpayViewController.h"

#import "DinPayPluginDelegate.h"
#import "DPPlugin.h"
#import "ZSLRSAHandler.h"
#import "HongFu-Swift.h"

#define kNote @"提示"
#define kBtnOk @"确定"
#define kTn @"201403271021530078082"
#define kMdoe @"00"

@interface DinpayViewController ()<DinPayPluginDelegate, UIAlertViewDelegate>
{
    UIAlertView *_alertView;
}
@end

@implementation DinpayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"information=%@", _information);
    [self interface:_information];
    
}

#pragma mark- UPPayPluginDelegate
//智付完成以后的回调函数，是DinPayPluginDelegate协议中定义的方法。
- (void)DinPayPluginResult:(NSString *)result
{
    NSLog(@"result:  %@",result);
    NSString* str = nil;
    if ([result isEqualToString:@"success"]) {
        str = @"支付成功\n请到中心钱包刷新页面查看余额";
        //充值成功，发送通知回到中心钱包界面
        NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
        [notification postNotificationName: @"paySuccessReturn" object:self];
    } else if ([result isEqualToString:@"cancel"]) {
        str = @"您已取消支付";
    } else if ([result isEqualToString:@"fail"]) {
        str = @"支付失败\n请使用其他支付方式，或联系客服";
    }
    _alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
}


- (void)viewDidAppear:(BOOL)animated{

    [[self navigationController] popViewControllerAnimated:false];
    if ([[UIScreen mainScreen] bounds].size.width > [[UIScreen mainScreen] bounds].size.height) {
        self.navigationController.navigationBarHidden = NO;
    }
    [_alertView show];
}

- (void)interface: (NSDictionary *)info
{
    
    NSLog(@"interface info:%@",info);
    Order* ors = [[Order alloc]init];
    
//#warning --提示--

    //商家号，商户签约时，智付支付平台分配的唯一商家号，必选参数
//    ors.merchant = @"2000297791";
    ors.merchant = [info valueForKey:@"merchant"];
    
    //私钥
//    NSString * RSAKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAM4ph6bMczv7lHOInOduswQy4QgomsNbWp0XfjLBZHqsynzIWBnNDQRwCOCga8Y/h5z3xRBRc5HRT7ELMN1cEXJpXQ+8YmV7avSM/K1BC4nblwp1M3WgTK+FFOf/pcvz2TjfFej17o6dfrrUoLDJYcGVWqmy9DefaZBtrj9KgVhLAgMBAAECgYBD+R1ouXAlDsXbceeJxs3vTHc1oW2li7FMqjpJscnXSLFagxPJLfpkxCupJDtkmf20m1y2DKT2JvUHgpER6xE0+CSyf1yRfCTGXXZzslNHJTrD/5iEsK2YovHbj0bKFRp+mmxcjSXzeNg0huGumUlFTpPcRApEutferlTPsgDrwQJBAPInVZrUjhi+iZi5U5gubz8pa2XkC45SNeELpS8emNrdd3DZenhqpYebw+wNgfFt9Jt2M3RmppDJaNN9Rrk98t8CQQDZ81mY5I4Ee6vaC/wylzvfajHYeVnZRed76jDjRETevAULiQaYBiFmHxYBzrwHuQ3OqLeMerJDpdLLuD637RQVAkEA22K1lOvDvTlK0fn9eV+AXFn7OjmsGony1GvHgPQYihmhb7Uo1tXQGBcQHtlyA7iZpwskvO2PNJe1B/50x7kPQwJAJ8SFVqZtW1gNdU22iKybmhpQWgVaZZChujRzEyTDxDheW0p3T4ne0jld1JqaKHaVlF2okBNbL4i0O8O0fe7eOQJAPqKfC6uZVfjjRZEecPQorIU2q1jJ0PA8NQQCOi2bWC9LCNzC3ejbPCu/vPc6hpnBCsAeNejs21iMnwLLqwtD6Q==";

    NSString * RSAKey = [info valueForKey:@"RSAKey"];
    NSLog(@"RSAKey:%@",RSAKey);
    
    // RSA-S签名所需要的私钥 ,<私钥获取请查看RSA-S密钥对生成文档>
    // RSA签名方式 把从后台获取证书放在商家自己的后台服务端服进行签名传输给客户端
    //----------------------------------

    
    //服务器异步通知地址 ,支付成功后，智付支付平台会主动通知商家系统，商家系统必须指定接收通知的地址，必选参数
    NSString * notifyDomain = [info valueForKey:@"notify_url"];
    NSString * notifyUrl = [notifyDomain stringByAppendingString:@"Notify.aspx"];
    
    ors.notify_url = notifyUrl;
    NSLog(@"info:%@",info);
    NSLog(@"notify_url:%@",ors.notify_url);
    //如果支付请求时传递该参数，则通知商户支付成功时回传该参数，可选参数
    NSString * extraReturnParam = [[info valueForKey:@"extra_return_param"] stringByAppendingString:@"www.toobet.com"];
    ors.extra_return_param = extraReturnParam;
    //商户网站唯一订单号,由商户系统保证唯一性，最长64位字母、数字组成，必选参数
    ors.order_no = [info valueForKey:@"order_no"];
    //商户订单时间, 格式：yyyy-MM-dd HH:mm:ss，必选参数
    NSDateFormatter* fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    ors.order_time = [fmt stringFromDate:[NSDate date]];
    //商户订单总金额,该笔订单的总金额，以元为单位，精确到小数点后两位，必选参数
    NSString* amount = [[NSString alloc] initWithFormat:@"%@",[info valueForKey:@"order_amount"]];
    ors.oreder_amount = amount;
    //接口版本，固定值：V3.0，必选参数
    ors.interface_version = @"V3.0";
    //商品名称，不超过100个字符，必选参数
    ors.product_name = [info valueForKey:@"product_name"];
    //RSA 或RSA_S，不参与签名，必选参数
    ors.sign_type = @"RSA-S";
    //1 订单号不允许重复  0 订单号允许重复,可选参数
    ors.redo_flag = @"1";
    
    NSLog(@"ors=%@",ors);
    
    //需要签名的参数排序后组成的字符串
    NSMutableString* signStr = [ors getSortStrFromOrder];
    
    if ([ors.merchant isEqualToString:@""] || [RSAKey isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写商家号或者秘钥" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    ZSLRSAHandler *handler = [[ZSLRSAHandler alloc] initWithSignKey:RSAKey];
    
    //--------------------数据签名，支持RSA，和RSA-S两种签名方式，在后台进行数据签名传给客户端调起插件--------------
    //--------------------RSA 签名方式 需在后台调用后台开发包的方法进行签名，本Demo只演示RSA-S签名方式-------------
    //--------------------具体后台签名规则，签名方法见文档及后台开发包------------------------------------------
    
    if ([ors.sign_type isEqualToString:@"RSA-S"]) {
        //此处签名仅为Demo测试，所有数据签名建议在后台进行。
        ors.sign = [handler signForString:signStr];
        if (!ors.sign) {
            return;
        }
        
        ors.sign = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)ors.sign,
                                                                                 NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                 kCFStringEncodingUTF8);
        
    } else {
        return;
    }
    
    //调起智付插件
//    [DPPlugin startDinPay:ors mode:@"00" viewController:self delegate:self];
    
    [DPPlugin startDinPay:ors fromScheme:@"HongFuDinPay" mode:@"00" viewController:self delegate:self];
}



//获取唯一单号
-(NSUInteger)currentUTC
{
    NSDateComponents *comp= [[NSDateComponents alloc]init];
    [comp setYear:2010];
    [comp setMonth:1];
    [comp setDay:1];
    [comp setHour:0];
    [comp setMinute:0];
    [comp setSecond:0];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //[calendar setTimeZone:[NSTimeZone timeZoneWithName:@"Pacific/Kwajalein"]];
    NSDate *startDate = [calendar dateFromComponents:comp];
    NSUInteger utc = -[startDate timeIntervalSinceNow];
    return utc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
