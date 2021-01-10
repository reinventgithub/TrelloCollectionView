//
//  BoardViewListTableViewCell.h
//  
//
//  Created by wxl on 16/3/23.
//  Copyright © 2016年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"

typedef NS_ENUM(NSUInteger, TrelloZoom) {
    TrelloZoomNot,
    TrelloZoomOut,
    TrelloZoomIn
};

@interface BoardViewListTableViewCell : UITableViewCell
@property (nonatomic, weak) TaskModel *taskModel;
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, getter=isCellHidden) BOOL cellHidden;
@end
