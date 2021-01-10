//
//  BaseModel.h
//  
//
//  Created by wxl on 16/2/25.
//  Copyright © 2016年 jensen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
异常结果
msg [string] 提示信息
status [int] 成功状态（0失败1成功）
 */
@interface BaseModel : NSObject
@property (copy, nonatomic) NSString *msg;
@property (strong, nonatomic) NSNumber *status;
@end
