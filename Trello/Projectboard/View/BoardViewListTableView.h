//
//  BoardViewListTableView.h
//  SCTrelloNavigation
//
//  Created by Yh c on 15/11/6.
//  Copyright © 2015年 Yh c. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListModel.h"
#import "BoardViewListHeaderView.h"
#import "BoardViewListFooterView.h"
@class BoardViewList;

@interface BoardViewListTableView : UITableView

@property (weak, nonatomic) ListModel *listModel;
@property (nonatomic) CGFloat cellTotalHeight;
@property (weak, nonatomic) BoardViewListHeaderView *header;
@property (weak, nonatomic) BoardViewListFooterView *footer;
@property (nonatomic, weak) BoardViewList *collectionViewCell;
@end
