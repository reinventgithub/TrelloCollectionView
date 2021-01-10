//
//  GetProjectBoardApi.h
//
//
//  Created by wxl on 16/1/23.
//  Copyright © 2016年 Aim. All rights reserved.
//

#import "BaseApi.h"
//敏捷流程看板下的项目任务搜索
//任务
//作者
//zebra
//注解
//请求方式 GET
//接口地址 http://123.56.136.12:8088/v1/task/task/board?access-token=<:access-token>&sign=<:sign>
//参数
//tid	[int] Y 项目id
//pid	[int] N 面板id
//word	[string] N 搜索词
//page	[int] N 页数
//返回
//[JSON]
//items [array] 数据
//–id [int] 面板id
//–name [string] 面板名称
//–task [array] 面板任务
//-—t_id [int] 任务id
//-—t_taskContent [string] 任务内容
//-—t_addTime [datetime] 任务创建时间
//-—t_taskEndTime [datetime] 任务截止时间
//-—t_sort [decimal] 顺序
//-—user [array] 任务创建者信息
//---—t_id [int] 用户id
//---—t_nickname [string] 用户昵称
//---—photo [string] 用户头像
//-—member [array] 相关成员信息
//---—user_id [int] 成员id
//---—complete_status [int] 成员任务完成状态
//---—user [array] 成员信息
//-----—t_id [int] 成员id
//-----—t_nickname [string] 成员昵称
//-----—photo [string] 成员头像
//-—panel [array] 所在面板信息
//---—id [int] 面板id
//---—name [string] 面板名称
//---—alias_id [int] 面板顺序
//-—team [array] 所在项目信息
//---—t_id [int] 项目id
//---—t_teamName [string] 项目名称
//_links [array] 相关链接
//–self [array] 本页
//-—href [string] 超链接
//–next [array] 下一页
//-—href [string] 超链接
//–last [array] 最后一页
//-—href [string] 超链接
//_meta [array] 元信息
//–totalCount [int] 总条数
//–pageCount [int] 总页数
//–currentPage [int] 当前页数
//–perPage [int] 每页条数
@interface GetProjectBoardApi : BaseApi
@property (strong, nonatomic) NSNumber *tid;
@property (strong, nonatomic) NSNumber *pid;
@property (copy, nonatomic) NSString *word;
@property (strong, nonatomic) NSNumber *page;
@end
