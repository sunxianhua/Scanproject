//
//  CBPersistenceTool.m
//  CreativeButton
//
//  Created by yizzuide on 15/11/20.
//  Copyright © 2015年 RightBrain-Tech. All rights reserved.
//

#import "KDBPersistenceTool.h"

@implementation KDBPersistenceTool

+ (void)savePrefWithKey:(NSString *)key stringValue:(NSString *)value {
    
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    [pref setObject:value forKey:key];
    [pref synchronize];
}

+ (void)savePrefWithKey:(NSString *)key boolValue:(BOOL)value {
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    [pref setBool:value forKey:key];
    [pref synchronize];
}

+ (NSString *)obtainStringWithKey:(NSString *)key {
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    return [pref stringForKey:key];
}

+ (BOOL)obtainBoolWithkey:(NSString *)key {
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    return [pref boolForKey:key];
    
}
@end
