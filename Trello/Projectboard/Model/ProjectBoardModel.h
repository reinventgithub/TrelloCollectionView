//
//  TrelloBoardModel.h
//  SCTrelloNavigation
//
//  Created by wxl on 16/1/22.
//  Copyright © 2016年 Yh c. All rights reserved.
//

#import "BaseModel.h"
#import "ListModel.h"
//[JSON]
//id [int] 面板id
//name [string] 面板名称
//task [array] 面板任务
//–t_id [int] 任务id
//–t_taskContent [string] 任务内容
//–t_addTime [datetime] 任务创建时间
//–t_taskEndTime [datetime] 任务截止时间
//–user [array] 任务创建者信息
//-—t_id [int] 用户id
//-—t_nickname [string] 用户昵称
//-—photo [string] 用户头像
//–member [array] 相关成员信息
//-—user_id [int] 成员id
//-—complete_status [int] 成员任务完成状态
//-—user [array] 成员信息
//---—t_id [int] 成员id
//---—t_nickname [string] 成员昵称
//---—photo [string] 成员头像
//–panel [array] 所在面板信息
//-—id [int] 面板id
//-—name [string] 面板名称
//-—alias_id [int] 面板顺序
//–team [array] 所在项目信息
//-—t_id [int] 项目id
//-—t_teamName [string] 项目名称

@interface ProjectBoardModel : BaseModel

@property (nonatomic, strong) NSMutableArray<ListModel *> *lists;


@end
