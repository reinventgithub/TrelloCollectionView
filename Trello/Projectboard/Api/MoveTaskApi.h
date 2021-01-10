//
//  MoveTaskApi.h
//  HandOneAPP
//
//  Created by wxl on 16/3/26.
//  Copyright © 2016年 jensen. All rights reserved.
//

#import "BaseApi.h"
//任务的移动
//任务
//作者
//zebra
//注解
//请求方式 POST
//接口地址 http://123.56.136.12:8088/v1/task/task/move?access-token=<:access-token>&sign=<:sign>
//参数
//sign	[string] Y 签名
//t_id	[int] Y 任务id
//t_sort	[int] Y 目标排序
//istop	[int] N 是否置顶（1固定置顶-1取消固定置顶）
//t_panel_id	[int] N 目标流程面板id
//t_time_id	[int] N 目标时间面板id（1:今天2:明天3:本周4:持续推进）
//返回
//[JSON]
//msg [string] 提示信息
//status [int] 成功状态（0失败1成功）
@interface MoveTaskApi : BaseApi
@property (strong, nonatomic) NSNumber *t_id;
@property (strong, nonatomic) NSNumber *t_sort;
@property (strong, nonatomic) NSNumber *istop;
@property (strong, nonatomic) NSNumber *t_panel_id;
@property (strong, nonatomic) NSNumber *t_time_id;
@end
