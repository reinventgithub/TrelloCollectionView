//
//  BaseApi.h
//
//
//  Created by wxl on 16/2/25.
//  Copyright © 2015年 Aim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKRequest.h"

@interface BaseApi : YTKRequest
@property (copy, nonatomic) NSString *access_token;
@property (copy, nonatomic) NSString *appsercert;
@property (copy, nonatomic) NSString *sign;
@end
