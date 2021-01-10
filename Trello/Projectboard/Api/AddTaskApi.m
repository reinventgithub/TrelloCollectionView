//
//  AddTaskApi.m
//  HandOneAPP
//
//  Created by wxl on 16/3/16.
//  Copyright © 2016年 jensen. All rights reserved.
//

#import "AddTaskApi.h"
#import "TaskModel.h"

@implementation AddTaskApi
- (NSString *)componentUrl {
    return @"/v1/task/tasks";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (NSString *)responseModelName {
    return NSStringFromClass([TaskModel class]);
}
@end
