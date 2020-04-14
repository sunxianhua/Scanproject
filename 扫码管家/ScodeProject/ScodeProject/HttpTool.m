//
//  HttpTool.m
//  ScodeProject
//
//  Created by 孙先华 on 2019/4/15.
//  Copyright © 2019年 سچچچچچچ. All rights reserved.
//

#import "HttpTool.h"
#import <AFNetworking.h>
#import <AFHTTPSessionManager.h>

@implementation HttpTool


+ (HttpTool *)sharedJsonClient {
    static HttpTool *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HttpTool alloc] init];
    });
    
    return _sharedClient;
}


-(AFHTTPSessionManager *)sharmanager {
    static AFHTTPSessionManager *manager = nil;
    if (manager == nil) {
        
        manager = [AFHTTPSessionManager manager];
    }
    return manager;
}



- (void)requestJsonDataWithPath:(NSString *)aPath
                       andBlock:(void (^)(id data, NSError *error))block
{
    if (!aPath || aPath.length <= 0) {
        return;
    }
    
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 直接使用“服务器本来返回的数据”，不做任何解析
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];

    
//    //显示状态栏的网络指示器
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    AFHTTPSessionManager *mgr = [self sharmanager];
//
//
//    //设置加载时间
//    mgr.requestSerializer=[AFHTTPRequestSerializer serializer];
//    mgr.requestSerializer.timeoutInterval = 45.0f;
//
//
//  //  _sharedCBClient.responseSerializer = [ serializer];
//    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
//    mgr.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//    [mgr.requestSerializer setValue:@"text/xmL" forHTTPHeaderField:@"Content-Type"];
//

    
    mgr.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [mgr GET:aPath parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSXMLParser *responseObject) {
        
        NSLog(@"成功");
        block(responseObject ,nil);
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil ,error);
        NSLog(@"失败");
        
    }];
    
}

@end
