//
//  CBPersistenceTool.h
//  CreativeButton
//
//  Created by yizzuide on 15/11/20.
//  Copyright © 2015年 RightBrain-Tech. All rights reserved.
//  持久化存储工具

#import <Foundation/Foundation.h>
@class KDBUserPossnItemsModel;

@interface KDBPersistenceTool : NSObject

/**
 *  保数据到配置单
 *
 *  @param key   键
 *  @param value 字条串对象
 */
+ (void)savePrefWithKey:(NSString *)key stringValue:(NSString *)value;

/**
 *  保存状态配置
 *
 *  @param key   键
 *  @param value 状态
 */
+ (void)savePrefWithKey:(NSString *)key boolValue:(BOOL)value;


/**
 *  获得一个字符串
 *
 */
+ (NSString *)obtainStringWithKey:(NSString *)key;

/**
 *  获得一个状态
 *
 */
+ (BOOL)obtainBoolWithkey:(NSString *)key;


@end
