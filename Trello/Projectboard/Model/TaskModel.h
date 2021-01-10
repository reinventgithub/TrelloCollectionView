//
//  TaskModel.h
//  
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 jensen. All rights reserved.
//

#import "BaseModel.h"

@interface TaskModel : BaseModel

@property(nonatomic,copy)NSString *t_id;
@property(nonatomic,copy)NSString *t_taskContent;

@end
