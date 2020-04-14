//
//  HttpTool.h
//  ScodeProject
//
//  Created by 孙先华 on 2019/4/15.
//  Copyright © 2019年 سچچچچچچ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpTool : NSObject
+ (HttpTool *)sharedJsonClient;
- (void)requestJsonDataWithPath:(NSString *)aPath
                       andBlock:(void (^)(id data, NSError *error))block;

@end

NS_ASSUME_NONNULL_END
