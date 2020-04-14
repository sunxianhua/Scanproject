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



- (NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage*)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
    // 构造 NSURLRequest
    NSError* error = NULL;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"上传路径" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"someFileName" mimeType:@"multipart/form-data"];
        
        
    } error:&error];
    
    // 可在此处配置验证信息
    
    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:completionBlock];
    
    return uploadTask;
}


- (IBAction)runDispatchTest:(id)sender {
    // 需要上传的数据
    NSArray* images = [NSArray new];
    
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray* result = [NSMutableArray array];
    for (UIImage* image in images) {
        [result addObject:[NSNull null]];
    }
    
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i = 0; i < images.count; i++) {
        
        dispatch_group_enter(group);
        
        NSURLSessionUploadTask* uploadTask = [self uploadTaskWithImage:images[i] completion:^(NSURLResponse *response, NSDictionary* responseObject, NSError *error) {
            if (error) {
                NSLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                dispatch_group_leave(group);
            } else {
                NSLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    result[i] = responseObject;
                }
                dispatch_group_leave(group);
            }
        }];
        [uploadTask resume];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"上传完成!");
        for (id response in result) {
            NSLog(@"%@", response);
        }
    });
}


@end
