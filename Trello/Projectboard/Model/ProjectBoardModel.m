//
//  TrelloBoardModel.m
//  SCTrelloNavigation
//
//  Created by wxl on 16/1/22.
//  Copyright © 2016年 Yh c. All rights reserved.
//

#import "ProjectBoardModel.h"

@implementation ProjectBoardModel


+ (NSDictionary *)objectClassInArray{
    return @{@"lists" : [ListModel class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"lists" : @"items"};
}

@end
