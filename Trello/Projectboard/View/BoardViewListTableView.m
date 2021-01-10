//
//  BoardViewListTableView.m
//  SCTrelloNavigation
//
//  Created by Yh c on 15/11/6.
//  Copyright © 2015年 Yh c. All rights reserved.
//

#import "BoardViewListTableView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "BoardViewListTableViewCell.h"

@implementation BoardViewListTableView

- (CGFloat)cellTotalHeight {
    _cellTotalHeight = 0;
    for (int i=0; i<_listModel.tasks.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        CGFloat height = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
        _cellTotalHeight += height;
    }
    return _cellTotalHeight;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = Global_BackgroundColor;
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = YES;
}

@end
