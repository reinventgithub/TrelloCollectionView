//
//  GetProjectBoardApi.m
//
//
//  Created by wxl on 16/1/23.
//  Copyright © 2016年 Yh c. All rights reserved.
//

#import "GetProjectBoardApi.h"

@implementation GetProjectBoardApi

- (NSString *)componentUrl{
    return @"/v1/task/task/board";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (NSString *)responseModelName {
    return @"ProjectBoardModel";
}

@end
