//
//  GlobalHeader.h
//  SCTrelloNavigation
//
//  Created by Yh c on 15/11/5.
//  Copyright © 2015年 Yh c. All rights reserved.
//

#ifndef GlobalHeader_h
#define GlobalHeader_h

#define BASE_URL @"http://api.xxx.com"
#define Global_trelloBlue [UIColor colorWithRed:0.0f/255.0f green:124.0f/255.0f blue:194.0f/255.0f alpha:1.0f]
#define Global_trelloDeepBlue [UIColor colorWithRed:13.0f/255.0f green:102.0f/255.0f blue:167.0f/255.0f alpha:1.0f]
#define Global_trelloGray [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f]
#define Global_trelloLightGray [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0f]

#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define SafeAreaInsetsBottom (@available(iOS 11.0, *) ? [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom : 0)
//#define NavBarHeight    40
#define Top               (StatusBarHeight+NavBarHeight)
#define NavigationBarHeight 44
#define NavAndStatusBarHeight (StatusBarHeight+NavigationBarHeight)

#define Global_cellHeight 44.0f
#define Global_ListHeaderHeight 46.0f
#define Global_ListFooterHeight 44.0f
#define Global_ClearColor [UIColor clearColor]
#define Global_BackgroundColor Global_trelloGray

//#define Global_cellHeight 80.0f
#endif /* GlobalHeader_h */
