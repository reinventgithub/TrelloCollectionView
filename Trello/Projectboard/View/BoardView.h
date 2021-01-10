//
//  ProjectBoardView.h
//  SCTrelloNavigation
//
//  Created by Yh c on 15/11/5.
//  Copyright © 2015年 Yh c. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardViewListTableView.h"

@class BoardView, ProjectBoardModel;

//@protocol BoardDataSource <NSObject>
//
//@required
//
////- (NSInteger)numberForListsInBoardView:(BoardView *)boardView;
////- (NSInteger)boardView:(BoardView *)boardView numberOfRowsInList:(NSInteger)list;
////
//////- (BoardViewCell *)boardView:(BoardView *)boardView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
//////- (BoardViewListHeaderView *)boardView:(BoardView *)boardView viewForHeaderInList:(NSInteger)list;
//////- (BoardViewListFooterView *)boardView:(BoardView *)boardView viewForFooterInList:(NSInteger)list;
////
////- (ListItem *)boardView:(BoardView *)boardView itemForListInList:(NSInteger)list;
////- (ListCellItem *)boardView:(BoardView *)boardView itemForCellAtIndexPath:(NSIndexPath *)indexPath;
//@end

@protocol BoardViewDelegate <NSObject>

- (void)boardView:(BoardView *)boardView listTableView:(BoardViewListTableView *)listTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface BoardView : UICollectionView <UIScrollViewDelegate>

//@property (nonatomic, weak) id<BoardDataSource> dataSource;
@property (weak, nonatomic) id<BoardViewDelegate> boardViewDelegate; ///< wefewfwef

//- (void)reloadData;
@property (copy, nonatomic) NSString *project_id;
@property (nonatomic, strong) ProjectBoardModel *model;
@property (nonatomic, weak) UICollectionViewFlowLayout *layout;

- (void)reloadListLayout;

@end

@interface NSIndexPath (BoardView)

+ (instancetype)indexPathForRow:(NSInteger)row inList:(NSInteger)list;
@property (nonatomic, readonly) NSInteger list;
@property (nonatomic, readonly) NSInteger row;

@end
