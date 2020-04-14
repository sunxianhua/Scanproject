//
//  UIButton+Tool.h
//  巡店项目
//
//  Created by 孙先华 on 16/8/25.
//  Copyright © 2016年 سچچچچچچ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonLayoutType) {
    LeftImageType,     //图片在左边
    RightImageType,    //图片在右边
    TopImageType,      //图片在上面
    bottomImageType    //图片在下面
};


@interface UIButton (Tool)

/**
 *  设置按钮图片和文字间距
 *
 *  @param style 按钮布局类型
 *  @param space 图片和文字间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(ButtonLayoutType)style
                        imageTitleSpace:(CGFloat)space;
@end
