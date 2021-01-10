//
//  ListModel.h
//  
//
//  Created by wxl on 16/3/11.
//  Copyright © 2016年 jensen. All rights reserved.
//

#import "BaseModel.h"
#import "TaskModel.h"

@interface ListModel : BaseModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSMutableArray<TaskModel *> *tasks;

@end
