//
//  HomeItemModel.h
//  ScodeProject
//
//  Created by 孙先华 on 2019/4/15.
//  Copyright © 2019年 سچچچچچچ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HomeItemModel;

NS_ASSUME_NONNULL_BEGIN


@interface HomeModel : NSObject
@property (strong,nonatomic) NSString *code;
@property (strong,nonatomic) NSString *username;
@property (strong,nonatomic) NSString *password;
@property (strong,nonatomic) NSArray<HomeItemModel *> *wordname;
@end


@interface HomeItemModel : NSObject
@property (strong,nonatomic) NSString *id;
@property (strong,nonatomic) NSString *name;
@end

NS_ASSUME_NONNULL_END
