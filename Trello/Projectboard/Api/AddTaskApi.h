//
//  AddTaskApi.h
//  HandOneAPP
//
//  Created by wxl on 16/3/16.
//  Copyright © 2016年 jensen. All rights reserved.
//

#import "BaseApi.h"
//任务的创建
//任务
//作者
//zebra
//注解
//请求方式 POST
//接口地址 http://123.56.136.12:8088/v1/task/tasks?access-token=<:access-token>&sign=<:sign>
//参数
//t_taskContent	string Y 任务内容
//t_time_id	int N 时间面板id(1今天截止2明天截止3本周截止4持续推进)
//t_sort	int N 排序
//remind_time	datetime N 提醒时间
//t_projectId	int N 项目小组id
//t_panel_id	int N 敏捷流程面板id
//member	string N 任务相关成员id(多个成员用逗号隔开)
//返回
//[JSON] msg [string] 提示信息
//status [int] 成功状态（0失败1成功）
@interface AddTaskApi : BaseApi
@property (copy, nonatomic) NSString *t_taskContent;
@property (strong, nonatomic) NSNumber *t_time_id;
@property (strong, nonatomic) NSNumber *t_sort;
@property (strong, nonatomic) NSDate *remind_time;
@property (strong, nonatomic) NSNumber *t_projectId;
@property (strong, nonatomic) NSNumber *t_panel_id;
@property (copy, nonatomic) NSString *member;
@end
