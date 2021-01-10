//
//  MoveTaskApi.m
//  HandOneAPP
//
//  Created by wxl on 16/3/26.
//  Copyright © 2016年 jensen. All rights reserved.
//

#import "MoveTaskApi.h"
#import "TaskModel.h"

@implementation MoveTaskApi
- (NSString *)componentUrl {
    return @"/v1/task/task/move";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (NSString *)responseModelName {
    return NSStringFromClass([TaskModel class]);
}

@end
