//
//  UIImage+MJ.h
//  04-图片裁剪
//
//  Created by apple on 14-4-14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NJ)
// 传入图片的名称, 以及圆的边框宽度 , 以及边框的颜色 返回一张绘制好的图片
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
@end
