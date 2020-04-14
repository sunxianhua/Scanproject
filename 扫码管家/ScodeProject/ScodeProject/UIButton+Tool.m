//
//  UIButton+Tool.m
//  巡店项目
//
//  Created by 孙先华 on 16/8/25.
//  Copyright © 2016年 سچچچچچچ. All rights reserved.
//

#import "UIButton+Tool.h"

@implementation UIButton (Tool)

- (void)layoutButtonWithEdgeInsetsStyle:(ButtonLayoutType)style
                        imageTitleSpace:(CGFloat)space
{
    
    CGFloat imageHeight = self.imageView.frame.size.height;
    CGFloat imageWidth  = self.imageView.frame.size.width;
    
    CGFloat lableHeight = 0.0;
    CGFloat lableWidth  = 0.0;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        lableWidth = self.titleLabel.intrinsicContentSize.width;
        lableHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        lableWidth = self.titleLabel.frame.size.width;
        lableHeight = self.titleLabel.frame.size.height;
    }
    
    UIEdgeInsets imageEdge;
    UIEdgeInsets lableEdge;
    
    switch (style) {
        case LeftImageType: {
            
            imageEdge = UIEdgeInsetsMake(0, -space/2, 0, space/2);
            lableEdge = UIEdgeInsetsMake(0, space/2, 0, -space/2);
            break;
        }
        case RightImageType: {
            
            imageEdge = UIEdgeInsetsMake(0, lableWidth+space/2.0, 0, -lableWidth-space/2.0);
            lableEdge = UIEdgeInsetsMake(0, -imageWidth-space/2.0, 0, imageWidth+space/2.0);            break;
        }
        case TopImageType: {
            
            imageEdge = UIEdgeInsetsMake(-space/2 - lableHeight, 0, 0, -lableWidth);
            lableEdge = UIEdgeInsetsMake(0, -imageWidth, -space/2 - imageHeight, 0);
            break;
        }
        case bottomImageType: {
            
            imageEdge = UIEdgeInsetsMake(0, 0, -space/2 - lableHeight, -lableWidth);
            lableEdge = UIEdgeInsetsMake(-space/2 - imageHeight, -imageWidth, 0, 0);
            break;
        }
    }
    
    self.titleEdgeInsets = lableEdge;
    self.imageEdgeInsets = imageEdge;
}

@end
