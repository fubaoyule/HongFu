//
//  ZSLRSAHandler.m
//  DinpayDemo
//
//  Created by yangliang on 16/3/31.
//  Copyright (c) 2016年 yangliang. All rights reserved.
//

#import "ZSLRSAHandler.h"
#import "rsa.h"
#include "pem.h"
#include "md5.h"
#include "bio.h"
#include "sha.h"
#include <string.h>

@interface ZSLRSAHandler ()
{
    NSString *_privateKey;
    RSA* _rsa_pri;
}
@end
@implementation ZSLRSAHandler
- (instancetype)initWithSignKey:(NSString *)privateKey
{
    self = [super init];
    if (self) {
        _privateKey = [privateKey copy];
    }
    return self;
}
//数据签名  仅供参考
- (NSString *)signForString:(NSString *)string{
    if (!string) {
        return nil;
    }
    BOOL status = NO;
    BIO *bio = NULL;
    RSA *rsa = NULL;
    bio = BIO_new(BIO_s_file());
    NSString* temPath = NSTemporaryDirectory();
    NSString* rsaFilePath = [temPath stringByAppendingPathComponent:@"Dinpay_RSAKEY"];
    NSString* formatRSAKeyString = [self formatRSAKeyWithKeyString:_privateKey];
    
    BOOL writeSuccess = [formatRSAKeyString writeToFile:rsaFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (!writeSuccess) {
        return nil;
    }
    const char* cPath = [rsaFilePath cStringUsingEncoding:NSUTF8StringEncoding];
    BIO_read_filename(bio, cPath);
    
    rsa = PEM_read_bio_RSAPrivateKey(bio, NULL, NULL, NULL);
    _rsa_pri = rsa;
    if (rsa != NULL && 1 == RSA_check_key(rsa)) {
        status = YES;
    } else {
        status = NO;
    }
    BIO_free_all(bio);
    [[NSFileManager defaultManager] removeItemAtPath:rsaFilePath error:nil];
    
    if (status) {
        return [self signRSAMD5:string];
    }
    return nil;
}

- (NSString *)signRSAMD5:(NSString *)string{
    if (!_rsa_pri) {
        return nil;
    }
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char *sig = (unsigned char *)malloc(256);
    unsigned int sig_len;
    
    unsigned char digest[MD5_DIGEST_LENGTH];
    MD5_CTX ctx;
    MD5_Init(&ctx);
    MD5_Update(&ctx, message, strlen(message));
    MD5_Final(digest, &ctx);
    
    int rsa_sign_valid = RSA_sign(NID_md5
                                  , digest, MD5_DIGEST_LENGTH
                                  , sig, &sig_len
                                  , _rsa_pri);
    
    if (rsa_sign_valid == 1) {
        NSData* data = [NSData dataWithBytes:sig length:sig_len];
        
        NSString * base64String = [data base64EncodedStringWithOptions:0];
        free(sig);
        return base64String;
    }
    
    free(sig);
    return nil;
}
-(NSString*)formatRSAKeyWithKeyString:(NSString*)keyString
{
    const char *pstr = [keyString UTF8String];
    int len = (int)[keyString length];
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-----BEGIN PRIVATE KEY-----\n"];
    int index = 0;
    int count = 0;
    while (index < len) {
        char ch = pstr[index];
        if (ch == '\r' || ch == '\n') {
            ++index;
            continue;
        }
        [result appendFormat:@"%c", ch];
        if (++count == 79)
        {
            [result appendString:@"\n"];
            count = 0;
        }
        index++;
    }
    [result appendString:@"\n-----END PRIVATE KEY-----"];
    return result;
    
}
@end
