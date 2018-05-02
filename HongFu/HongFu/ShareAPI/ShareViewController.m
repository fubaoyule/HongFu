//
//  ShareViewController.m
//  FuTu
//
//  Created by Administrator1 on 15/9/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//
//错误码:TL0005**

#import "ShareViewController.h"
#import <ShareSDK/ShareSDK.h>
// 弹出分享菜单需要导入的头文件
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//自定义分享编辑界面所需要导入的头文件
#import <ShareSDKUI/SSUIEditorViewStyle.h>
//腾讯SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
@implementation ShareViewController

-(void)initShareSDK {
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。我们Demo提供的appKey为内部测试使用，可能会修改配置信息，请不要使用。
     *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"iosv1101"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy)]
     
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                              redirectUri:@"http://www.sharesdk.cn"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeWechat:
                      //设置微信应用信息
                      [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                            appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                      break;
                  case SSDKPlatformTypeQQ:
                      //设置QQ应用信息，其中authType设置为只用SSO形式授权
                      [appInfo SSDKSetupQQByAppId:@"100371282"
                                           appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                         authType:SSDKAuthTypeSSO];
                      break;
                      /*
                       case SSDKPlatformTypeTencentWeibo:
                       //设置腾讯微博应用信息
                       [appInfo SSDKSetupTencentWeiboByAppKey:@"801307650"
                       appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                       redirectUri:@"http://www.sharesdk.cn"];
                       break;
                       
                       case SSDKPlatformTypeFacebook:
                       //设置Facebook应用信息，其中authType设置为只用Web形式授权
                       [appInfo SSDKSetupFacebookByApiKey:@"107704292745179"
                       appSecret:@"38053202e1a5fe26c80c753071f0b573"
                       authType:SSDKAuthTypeWeb];
                       break;
                       case SSDKPlatformTypeTwitter:
                       //设置Twitter应用信息
                       [appInfo SSDKSetupTwitterByConsumerKey:@"LRBM0H75rWrU9gNHvlEAA2aOy"
                       consumerSecret:@"gbeWsZvA9ELJSdoBzJ5oLKX0TU09UOwrzdGfo9Tg7DjyGuMe8G"
                       redirectUri:@"http://mob.com"];
                       break;
                       */
                  default: break;
              }
          }];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)showActionSheet:(id)sender
{
    //info:["content": "", "src": "", "title": "", "urlImg": ""]
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSString* imageArray = [sender valueForKey:@"urlImg"];
    NSString* content = [sender valueForKey:@"content"];
    NSString* title = [sender valueForKey:@"title"];
    NSString* src = [sender valueForKey:@"src"];
//    NSString* content = @"分享内容12341234";
//    NSString* title = @"分享标题ABCD";
//    NSString* src = @"www.baidu.com";
    
    
    if (imageArray && title && src && content)
    {
        [shareParams SSDKSetupShareParamsByText:content
                                         images:imageArray
                                            url:[NSURL URLWithString:src]
                                          title:title
                                           type:SSDKContentTypeAuto];
        //定制短信分享内容,不分享图片。
        [shareParams SSDKSetupSMSParamsByText:content
                                        title:title
                                       images:nil
                                  attachments:nil
                                   recipients:nil
                                         type:SSDKContentTypeText];
        
        
        //        //设置分享菜单栏样式（非必要）
        //        //设置分享菜单的背景颜色
        //        [SSUIShareActionSheetStyle setActionSheetBackgroundColor:[UIColor colorWithRed:249/255.0 green:0/255.0 blue:12/255.0 alpha:0.5]];
        //        //设置分享菜单颜色
        //        [SSUIShareActionSheetStyle setActionSheetColor:[UIColor colorWithWhite:1 alpha:0.9]];
        //        //设置分享菜单－取消按钮背景颜色
        //        [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:[UIColor colorWithWhite:1 alpha:0.9]];
        //        //设置分享菜单－取消按钮的文本颜色
        //        [SSUIShareActionSheetStyle setCancelButtonLabelColor:[UIColor blackColor]];
        //        //设置分享菜单－社交平台文本颜色
        //        [SSUIShareActionSheetStyle setItemNameColor:[UIColor whiteColor]];
        //        // 设置分享菜单－社交平台文本字体
        //        [SSUIShareActionSheetStyle setItemNameFont:[UIFont systemFontOfSize:10]];
        //        //设置分享编辑界面的导航栏颜色
        //        [SSUIEditorViewStyle setiPhoneNavigationBarBackgroundColor:[UIColor blackColor]];
        //        //设置编辑界面标题颜色
        //        [SSUIEditorViewStyle setTitleColor:[UIColor redColor]];
        //        //设置取消发布标签文本颜色
        //        [SSUIEditorViewStyle setCancelButtonLabelColor:[UIColor blueColor]];
        //        [SSUIEditorViewStyle setShareButtonLabelColor:[UIColor blueColor]];
        //        //设置分享编辑界面状态栏风格
        //        [SSUIEditorViewStyle setStatusBarStyle:UIStatusBarStyleLightContent];
        //        //设置简单分享菜单样式
        //        [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSystem];
        //        //自定义支持的屏幕方向
        //        [ShareSDK setSupportedInterfaceOrientation:UIInterfaceOrientationMaskPortrait];
        
        
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享异常"
                                                            message:@"当前分享失败，错误码:TL00051"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    
    
    //    SSUIShareActionSheetCustomItem *wechatFriendItem = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"bicycle.jpg"]
    //                                                                                              label:@"生成二维码"
    //                                                                                            onClick:^{
    //                                                                                                NSLog(@"clicked self created share button");
    //                                                                                            }];
    
    //2、分享
    
    UIView* shareView = [[UIView alloc] initWithFrame:CGRectMake(100, 400, 100, 200)] ;
    [self.view addSubview:shareView];
//    SSUIShareActionSheetController* sheet = [ShareSDK showShareActionSheet:sender
    SSUIShareActionSheetController* sheet = [ShareSDK showShareActionSheet:shareView
                                             //将要自定义顺序的平台传入items参数中
                                                                     items:@[@(SSDKPlatformSubTypeWechatTimeline),
                                                                             @(SSDKPlatformSubTypeWechatSession),
                                                                             @(SSDKPlatformTypeQQ),
                                                                             @(SSDKPlatformTypeSinaWeibo),
                                                                             @(SSDKPlatformTypeSMS)]
                                                               shareParams:shareParams
                                                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                           
                                                           switch (state) {
                                                               case SSDKResponseStateSuccess: {
                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                                                       message:nil
                                                                                                                      delegate:nil
                                                                                                             cancelButtonTitle:@"确定"
                                                                                                             otherButtonTitles:nil];
                                                                   [alertView show];
                                                                   break;
                                                               } case SSDKResponseStateFail: {
                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                                                       message:[NSString stringWithFormat:@"%@", error]
                                                                                                                      delegate:nil
                                                                                                             cancelButtonTitle:@"确定"
                                                                                                             otherButtonTitles:nil];
                                                                   [alertView show];
                                                                   break;
                                                                   //                       } case SSDKResponseStateCancel: {
                                                                   //                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                   //                                                                               message:nil
                                                                   //                                                                              delegate:nil
                                                                   //                                                                     cancelButtonTitle:@"确定"
                                                                   //                                                                     otherButtonTitles:nil];
                                                                   //                           [alertView show];
                                                                   //                           break;
                                                               } default: break;
                                                           }
                                                       }];
    //直接分享，跳过编辑界面。
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSMS)];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
}

@end
