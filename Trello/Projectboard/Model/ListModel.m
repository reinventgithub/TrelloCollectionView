//
//  ListModel.m
//  
//
//  Created by wxl on 16/3/11.
//  Copyright © 2016年 jensen. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel
+ (NSDictionary *)objectClassInArray{
    return @{@"tasks" : [TaskModel class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"tasks" : @"task"};
}
@end 
