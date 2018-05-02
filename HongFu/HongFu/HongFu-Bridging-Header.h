//
//  ViewController.swift
//  FuTu
//
//  Created by Administrator1 on 13/9/16.
//  Copyright © 2016 BESVICT. All rights reserved.
//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#ifndef ShareSDK____Swift_ShareSDK_Bridging_Header_h
#define ShareSDK____Swift_ShareSDK_Bridging_Header_h

//＝＝＝＝＝＝＝＝＝＝ShareSDK头文件＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//以下是ShareSDK必须添加的依赖库：
//1、libicucore.dylib
//2、libz.dylib
//3、libstdc++.dylib
//4、JavaScriptCore.framework

//＝＝＝＝＝＝＝＝＝＝ShareSDKUI头文件，使用ShareSDK提供的UI需要导入＝＝＝＝＝
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "ShareViewController.h"
//＝＝＝＝＝＝＝＝＝＝以下是各个平台SDK的头文件，根据需要继承的平台添加＝＝＝
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//以下是腾讯SDK的依赖库：
//libsqlite3.dylib

//微信SDK头文件
#import "WXApi.h"
//以下是微信SDK的依赖库：
//libsqlite3.dylib

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
//以下是新郎微博SDK的依赖库：
//ImageIO.framework

//人人SDK头文件
#import <RennSDK/RennSDK.h>
//＝＝＝＝＝＝＝＝＝＝ShareSDKUI头文件引用结束＝＝＝＝＝

//＝＝＝＝＝＝＝＝＝＝Dinpay头文件，使用智付支付提供的UI需要导入＝＝＝＝＝
#import "DPPlugin.h"
#import "ZSLRSAHandler.h"
#import "DinpayViewController.h"



//刷新控件
#import "MJRefresh.h"
//加载网页图片
#import "UIImageView+WebCache.h"

//相对布局的头文件
#import "Masonry.h"

//网络请求的头文件
#import "AFNetworking.h"
#import "NetWork.h"
#import "TTNetworking.h"


//提示窗头文件
//#import "MBProgressHUD.h"


//String 加密扩展需要的头文件
#import <CommonCrypto/CommonHMAC.h>

//JSON数据解析
#import "JSONKit.h"
//音频播放
//#import <StreamingKit/STKAudioPlayer.h>
//轮播器
#import "SDCycleScrollView.h"

#endif
