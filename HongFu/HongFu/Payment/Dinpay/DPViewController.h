//
//  DPViewController.h
//  DinpayPurse
//
//  Created by yangliang on 14-4-10.
//  Copyright (c) 2014年 yangliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DinPayPluginDelegate.h"
#define kOffsetX 20
#define kOffsetY 20
#define kHeight  40



@interface DPViewController : UIViewController<DinPayPluginDelegate>
{
    CGFloat _originY;
    BOOL _isKeyboardShow;
    CGFloat _keybardY;
    CGFloat _riseHeight;
    BOOL _isInitControls;
}

//当前处于第一响应状态的textfield在view中的frame
@property(nonatomic, assign)CGRect currentFieldRect;

@end
