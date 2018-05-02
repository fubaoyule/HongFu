//
//  ZSLRSAHandler.h
//  DinpayDemo
//
//  Created by yangliang on 16/3/31.
//  Copyright (c) 2016年 yangliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSLRSAHandler : NSObject
- (instancetype)initWithSignKey:(NSString *)privateKey;
- (NSString *)signForString:(NSString *)string;
@end
