//
//  NetWork.m
//  FuTu
//
//  Created by Administrator1 on 30/9/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

#import "NetWork.h"
#import "AFNetworking.h"

@implementation NetWork

-(void) get {
    
    NSString *urlStr = [NSString stringWithFormat:@"http://image.zcool.com.cn/56/13/1308200901454.jpg"];
    NSString *newStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:newStr];
    NSURLRequest *requst = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    //异步链接(形式1,较少用)
    [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //self.imageView.image = [UIImage imageWithData:data];
        // 解析
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", dic);
    }];

}

- (void) urlSession {

    NSString *urlStr = [NSString stringWithFormat:@"http://image.zcool.com.cn/56/13/1308200901454.jpg"];
    NSString *newStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:newStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSURLSession *session =  [NSURLSession
                              sessionWithConfiguration:
                              [NSURLSessionConfiguration defaultSessionConfiguration]
                              delegate:nil
                              delegateQueue:[NSOperationQueue mainQueue]];
    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
//                                                completionHandler:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    
    [dataTask resume];
}


- (void) AFNetworkPost {

    
    NSString* url = @"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx?";
    // 请求的参数
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"20131129", @"date", @"1", @"startRecord", @"5", @"len", @"1234567890", @"udid", @"Iphone", @"terminalType", @"213", @"cid", nil];
    
    
    //initial manager.
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //post request.
    [manager POST:url
       parameters:dic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             NSLog(@"uploadProgress:%@",uploadProgress);
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog(@"success! response:%@",responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"error:%@",error);
         }];

}



- (void) AFNetworkGet {
    
    NSString* url = @"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx?";
    // 请求的参数
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"20131129", @"date", @"1", @"startRecord", @"5", @"len", @"1234567890", @"udid", @"Iphone", @"terminalType", @"213", @"cid", nil];
    
    //initial manager.
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url
      parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
          NSLog(@"downloadProgress:%@",downloadProgress);
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"success! response:%@",responseObject);
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"error:%@",error);
      }];

}






























@end
