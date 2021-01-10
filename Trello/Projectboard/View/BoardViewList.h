//
//  BoardViewList.h
//  Trello
//
//  Created by xiao on 5/4/20.
//  Copyright © 2020 wxl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardViewListTableView.h"

@class ListModel, BoardView;

NS_ASSUME_NONNULL_BEGIN

@interface BoardViewList : UICollectionViewCell <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) ListModel *listModel;
@property (copy, nonatomic) NSString *project_id;
@property (nonatomic, weak) BoardViewListTableView *listTableView;
@property (nonatomic, weak) BoardView *boardView;
@property (nonatomic, assign) NSInteger collectionViewCellHeight;
@end

NS_ASSUME_NONNULL_END
