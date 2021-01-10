//
//  UIGestureRecognizer+Superview.m
//  SCTrelloNavigation
//
//  Created by wxl on 16/1/8.
//  Copyright © 2016年 Yh c. All rights reserved.
//

#import "UIGestureRecognizer+Superview.h"
#import "objc/runtime.h"

static NSString *superviewKey = @"superview";

@implementation UIGestureRecognizer (Superview)
- (void)setSuperview:(UIView *)superview {
    objc_setAssociatedObject(self, (__bridge const void *)(superviewKey), superview,OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)superview {
    return objc_getAssociatedObject(self, (__bridge const void *)(superviewKey));
}
@end
