//
//  PixelLayout.h
//  PixelLayout 1.8
//
//  Created by wxl on 15/3/5.
//  Updated by wxl on 20/3/6.
//  Copyright (c) 2015年 wxl. All rights reserved.
//  https://github.com/reinventgithub/WXLAutolayout

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define layout(PxOrPt)        [PixelLayout layout:PxOrPt]
#define partLayout(PxOrPt, unLayout)    [PixelLayout partLayout:PxOrPt unLayoutPart:unLayout]
#define prelayout(PxOrPt)     [PixelLayout prelayout:PxOrPt]
#define layoutPxToPx(Px)      [PixelLayout layoutPxToPx:Px]
#define layoutV(PxOrPt)       [PixelLayout layoutV:PxOrPt]
#define prelayoutV(PxOrPt)    [PixelLayout prelayoutV:PxOrPt]
#define layoutY(Y, Height)    [PixelLayout layoutY:Y withHeight:Height]
#define prelayoutY(Y, Height) [PixelLayout prelayoutY:Y withHeight:Height]
#define unlayout(PxOrPt)      [PixelLayout unlayout:PxOrPt]
#define preunlayout(PxOrPt)   [PixelLayout preunlayout:PxOrPt]
#define font(PxOrPt)          [PixelLayout font:PxOrPt]
#define ptString(Px)          [PixelLayout pixelToPointString:Px]
#define pt(Px)                [PixelLayout pixelToPoint:Px]
#define zero                  @"0"
#define IOS_VERSION_8_OR_BELOW (([[[UIDevice currentDevice] systemVersion] floatValue] <= 9.0)? (YES):(NO))

typedef NS_ENUM(NSInteger, PLPixelOrPoint) {
    point = 1,
    pixel,
    pixelWithFont,
};

typedef NS_ENUM(NSInteger, PLScale) {
    notScale = 1,
    iPadScale,
    iPadScaleWithFont,
    allScale,
    allScaleWithFont
};

static NSString *const iPhone       = @"iPhone";
static NSString *const iPhone3G     = @"iPhone3G";
static NSString *const iPhone3GS    = @"iPhone3GS";
static NSString *const iPhone4      = @"iPhone4";
static NSString *const iPhone4S     = @"iPhone4S";
static NSString *const iPhone5      = @"iPhone5";
static NSString *const iPhone5s     = @"iPhone5s";
static NSString *const iPhone6      = @"iPhone6";
static NSString *const iPhone6Plus  = @"iPhone6Plus";
static NSString *const iPhone6s     = @"iPhone6s";
static NSString *const iPhone6sPlus = @"iPhone6sPlus";
static NSString *const iPad         = @"iPad";
static NSString *const iPad2        = @"iPad2";
static NSString *const iPad3        = @"iPad3";
static NSString *const iPad4        = @"iPad4";
static NSString *const iPadAir      = @"iPadAir";
static NSString *const iPadAir2     = @"iPadAir2";
static NSString *const iPadMini1G   = @"iPadMini1G";
static NSString *const iPadMini2    = @"iPadMini2";
static NSString *const iPadMini3    = @"iPadMini3";
static NSString *const iPadMini4    = @"iPadMini3";

@interface PixelLayout : NSObject

+ (void)setDevice:(NSString *)device isPixel:(PLPixelOrPoint)pixel isScale:(PLScale)isScale;
+ (void)setDevice:(NSString *)device isPixel:(PLPixelOrPoint)pixel isScale:(PLScale)isScale unlayoutHeight:(NSInteger)unlayoutHeight;
+ (void)setDevice:(NSString *)device isPixel:(PLPixelOrPoint)pixel isScale:(PLScale)isScale unlayoutHeight:(NSInteger)unlayoutHeight preScale:(double)preScale;
+ (double)layout:(double)pxOrPt;
+ (double)partLayout:(double)pxOrPt unLayoutPart:(double)unLayout;
+ (double)prelayout:(double)pxOrPt;
+ (double)layoutPxToPx:(double)px;
+ (double)iPadMini4:(double)pxOrPt;
+ (double)prelayoutV:(double)pxOrPt;
+ (double)layoutY:(double)y withHeight:(double)height;
+ (double)prelayoutY:(double)y withHeight:(double)height;
+ (double)unlayout:(double)pxOrPt;
+ (double)preunlayout:(double)pxOrPt;
+ (UIFont *)font:(double)pxOrPt;
+ (NSString *)pixelToPointString:(double)px;
+ (double)pixelToPoint:(double)px;

CGSize PLCGSizeMake(CGFloat x, CGFloat y);
CGRect PLCGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
CGRect PLPreScaleCGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
CGRect PLImageCGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
CGRect PLPreScaleImageCGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height);

@end
