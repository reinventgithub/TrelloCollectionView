//
//  UIColor+Extension.m
//  Reader
//
//  Created by wxl on 15/1/10.
//  Copyright (c) 2015年 wxl. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

UIColor* WXLColor(double r, double g, double b)
{
    return [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0];
}

UIColor* WXLRandomColor()
{
    return WXLColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
}
@end
