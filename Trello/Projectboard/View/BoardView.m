//
//  BoardView.m
//  SCTrelloNavigation
//
//  Created by Yh c on 15/11/5.
//  Copyright © 2015年 Yh c. All rights reserved.
//

#import "BoardView.h"
#import "UIGestureRecognizer+Superview.h"
#import "ProjectBoardModel.h"
#import "BoardViewListTableView.h"
#import "BoardViewListTableViewCell.h"
#import "BoardViewListHeaderView.h"
#import "BoardViewListFooterView.h"
#import "UITableView+FDTemplateLayoutCell.h"
//#import "WTaskDetailViewController.h"
#import "MoveTaskApi.h"
#import "AddTaskApi.h"
#import "SMPageControl.h"
#import "BoardViewList.h"
#import "BoardViewListLayout.h"


static CGFloat zoomIn = 1.8; //缩放因子
static CGFloat zoomOut = 1/1.8;
static CGFloat kVerticalSpacing = 20; //垂直间距
static CGFloat kListViewMaxHeight; //最大listView高度
static CGFloat kTotalCellMaxHeight; //cell区域最大高度
static CGFloat kListHeaderHeight = 46; //list header高度
static CGFloat kListFooterHeight = 44; //list footer高度
static CGFloat kCellDefaultHeight = 44; //cell 默认高度

@interface BoardView() <UIGestureRecognizerDelegate, UITextViewDelegate>
@property (nonatomic) CGFloat scale;
@property (weak, nonatomic) UIView *currentAddCardListView;
@property (weak, nonatomic) UIView *currentAddCardFooter;
@property (strong, nonatomic) MoveTaskApi *moveTaskApi;
@property (nonatomic) CGFloat keyboardHeight;
@property (strong, nonatomic) NSMutableArray *listTableViewArray;
@property (nonatomic, weak) BoardViewListTableView *listTableView;
//@property (strong, nonatomic) NSMutableArray *listHeaderArray;
//@property (strong, nonatomic) NSMutableArray *listFooterArray;
@property (nonatomic, assign) CGFloat offer;
@end

@implementation BoardView {
    CGFloat _increment;
    CGFloat _listIncrement;
    TrelloZoom zoom;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if(self) {
#pragma mark 监听键盘显示消失通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHidden:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        kListViewMaxHeight = frame.size.height-kVerticalSpacing*2;
        kTotalCellMaxHeight = kListViewMaxHeight - kListHeaderHeight - kListFooterHeight;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
//        self.contentSize = CGSizeMake(_listItems.count * (ScreenWidth - 45.0f), self.yyHeight);
        self.contentOffset = CGPointMake(0.0f, 0.0f);
        
        //设为YES，会产生长按collectionView偏移的bug
//        self.pagingEnabled = YES;
        self.bouncesZoom = NO;
        self.bounces = YES;
        self.alwaysBounceVertical = NO;
        self.alwaysBounceHorizontal = NO;
        
#pragma mark 给boardView添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
        [self addGestureRecognizer:longPress];
        //单击手势2
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
//        tap.delegate = self;
//        [self addGestureRecognizer:tap];
//        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (NSMutableArray *)listTableViewArray {
    if (!_listTableViewArray) {
        _listTableViewArray = [NSMutableArray array];
    }
    return _listTableViewArray;
}

//- (NSMutableArray *)listHeaderArray {
//    if (!_listHeaderArray) {
//        _listHeaderArray = [NSMutableArray array];
//    }
//    return _listHeaderArray;
//}
//
//- (NSMutableArray *)listFooterArray {
//    if (!_listFooterArray) {
//        _listFooterArray = [NSMutableArray array];
//    }
//    return _listFooterArray;
//}

#pragma mark 设置数据源
- (void)setModel:(ProjectBoardModel *)model {
    _model = model;
}

- (CGFloat)scale {
    if (_scale == 0) {
        _scale = 1;
    }
    return _scale;
}

#pragma mark 长按手势时间相应
- (void)longPressGestureRecognized:(id)sender {
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    
    //获得长按点在collectionView中的坐标
    CGPoint location = [longPress locationInView:self];
    //获取长按点在window中的坐标
    CGPoint inWindow = [longPress locationInView:self.window];
    
    CGPoint inListTableView;
    BoardViewListTableView *listTableView;
    
    for (int i = 0; i<_model.lists.count; i++) {
        BoardViewList *listCell = (BoardViewList *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        //把该点在collectionView中的相对坐标转换成tableView中的相对坐标
        CGPoint point = [self convertPoint:location toView:listCell.listTableView];
        //判断得到的相对坐标判断该点在不在tableView中
        if ([listCell.listTableView pointInside:point withEvent:nil]) {
            //记录点击的tableView
            listTableView = listCell.listTableView;
            self.listTableView = listTableView;
            //记录该点在tableView中的相对坐标
            inListTableView = point;
        }
    }
    
//    //使缓存失效
//    [listTableView.fd_indexPathHeightCache invalidateAllHeightCache];
    
//    //单列上下拖动的另一种做法
//    CGPoint inListHeader;
//    CGPoint point = [self convertPoint:location toView:listTableView.header];
//    PowerLog(point);
//    PowerLog(inListHeader);
//    if ([listTableView.header pointInside:point withEvent:nil]) {
//        inListHeader = point;
//    }
//
//    CGPoint inListFooter;
//    point = [self convertPoint:location toView:listTableView.footer];
//    if ([listTableView.footer pointInside:point withEvent:nil]) {
//        inListFooter = point;
//    }
//    CGPoint inListHeader;
//    BoardViewListHeaderView *listHeader;
//    for (BoardViewListHeaderView *view in _listHeaderArray) {
//        CGPoint point = [self convertPoint:location toView:view];
//        if ([view pointInside:point withEvent:nil]) {
//            listHeader = view;
//            inListHeader = point;
//        }
//    }
//    CGPoint inListFooter;
//    BoardViewListFooterView *listFooter;
//    for (BoardViewListFooterView *view in _listFooterArray) {
//        CGPoint point = [self convertPoint:location toView:view];
//        if ([view pointInside:point withEvent:nil]) {
//            listFooter = view;
//            inListFooter = point;
//        }
//    }
    
    //获取该点所在行
    NSIndexPath *indexPath = [listTableView indexPathForRowAtPoint:inListTableView];
    
    static UIView *snapshot;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath; ///< Initial index path, where gesture begins.
    static BoardViewListTableView *sourceListTableView;
    static BoardViewListTableViewCell *sourceListCell;
    static TaskModel *sourceListCellModel;
    static CGFloat rollBeginMaxX;
    static CGFloat rollBeginMinX;
    static CGFloat offsetX;
    static CGFloat offsetY;
    static CADisplayLink *link;
    static CADisplayLink *listLink;
    static CGFloat headerMaxY;
    static CGFloat headerMinY;
    static CGFloat footerMaxY;
    static CGFloat footerMinY;
    
    //该列header的最大Y值，坐标都是相对于window的
    headerMaxY = Global_ListHeaderHeight+NavAndStatusBarHeight+kVerticalSpacing;
    //同上
    headerMinY = NavAndStatusBarHeight+kVerticalSpacing;
    footerMaxY = listTableView.yyHeight+NavAndStatusBarHeight+kVerticalSpacing;
    footerMinY = listTableView.yyHeight-Global_ListFooterHeight+NavAndStatusBarHeight+kVerticalSpacing;
    
    UIGestureRecognizerState state = longPress.state;
    
#pragma mark 手势状态分支
    switch (state) {
        //手势开始
        case UIGestureRecognizerStateBegan: {
            //记录该点所在tableView指针
            sourceListTableView = listTableView;
            //判断该点是否在cell上
            if (indexPath) {
                //记录indexPath
                sourceIndexPath = indexPath;
                UITableViewCell *cell = [listTableView cellForRowAtIndexPath:indexPath];
                sourceListCell = (BoardViewListTableViewCell *)cell;
                sourceListCellModel = sourceListCell.taskModel;
                //点所在cell截图
                snapshot = [self customSnapshoFromView:cell];
                
                //tableView坐标转换成window坐标
                __block CGPoint cellCenterInWindow = [listTableView convertPoint:cell.center toView:self.window];
                //计算该点和cell中心的x偏移量
                offsetX = cellCenterInWindow.x - inWindow.x;
                snapshot.center = cellCenterInWindow;
                snapshot.alpha = 1.0;
                //把截图添加到window上
                [self.window addSubview:snapshot];
                
                [UIView animateWithDuration:0.25 animations:^{
                    //中心y移动到手指所在坐标y
                    cellCenterInWindow.y = inWindow.y;
                    snapshot.center = cellCenterInWindow;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    //隐藏cell，模拟一个拿起效果
                    cell.hidden = YES;
                    sourceListCell.cellHidden = YES;
                } completion:^(BOOL finished) {

                }];
                
                //初始化cell横向滚动边界
                if (CGRectGetMaxX(snapshot.frame) > ScreenWidth) {
                    rollBeginMaxX = CGRectGetMaxX(snapshot.frame);
                }
                else {
                    rollBeginMaxX = ScreenWidth;
                }

                if (CGRectGetMinX(snapshot.frame) < 0) {
                    rollBeginMinX = CGRectGetMinX(snapshot.frame);
                }
                else {
                    rollBeginMinX = 0;
                }
                
//                初始化cell横向滚动边界
//                rollBeginMaxX = ScreenWidth;
//                rollBeginMinX = 0;
                //初始化移动请求
//                _moveTaskApi = [[MoveTaskApi alloc] init];
            }
//            else if (listTableView) { //判断该点是否在tableView上（整个list移动）,因为现在header也属于tableView范围，这个功能被屏蔽了，可以把tableView加上上下间距，去掉contentInset解决这个问题。缩放最好改用截图技术去做，否则很难达到好的动效
//                CGFloat offset = location.x - self.contentOffset.x;
//                switch (zoom) {
//                    case TrelloZoomOut: {
//                        [UIView animateWithDuration:0.5 animations:^{
//                            self.frame = CGRectMake(0, self.yyTop, ScreenWidth, self.yyHeight);
//                            [_listTableViewArray enumerateObjectsUsingBlock:^(BoardViewListTableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                                obj.frame = CGRectMake(obj.yyLeft*zoomOut, obj.yyTop*zoomOut, obj.yyWidth*zoomOut, obj.yyHeight);
//                            }];
//                            self.contentOffset = CGPointMake((self.contentOffset.x+offset)*zoomOut, self.contentOffset.y);
//                            self.contentSize = CGSizeMake(self.contentSize.width*zoomOut, self.contentSize.height);
//                        } completion:^(BOOL finished) {
//                            // Take a snapshot of the selected row using helper method.
//                            snapshot = [self customSnapshoFromView:listTableView];
//
//                            // Add the snapshot as subview, centered at cell's center...
//                            CGPoint tableViewCenterInWindow = [self convertPoint:listTableView.center toView:nil];
//                            snapshot.center = tableViewCenterInWindow;
//                            offsetX = tableViewCenterInWindow.x - inWindow.x;
//                            offsetY = tableViewCenterInWindow.y - inWindow.y;
//                            snapshot.alpha = 1.0;
//                            [self.window addSubview:snapshot];
//                            [UIView animateWithDuration:0.25 animations:^{
//
//                                // Offset for gesture location.
//                                snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
//                                snapshot.alpha = 0.98;
//                                listTableView.hidden = YES;
//                            } completion:^(BOOL finished) {
//
//                            }];
//                            self.pagingEnabled = NO;
//                        }];
//                        zoom = TrelloZoomIn;
//                    }
//                        break;
//                    case TrelloZoomIn: {
//                        // Take a snapshot of the selected row using helper method.
//                        snapshot = [self customSnapshoFromView:listTableView];
//
//                        // Add the snapshot as subview, centered at cell's center...
//                        CGPoint tableViewCenterInWindow = [self convertPoint:listTableView.center toView:nil];
//                        snapshot.center = tableViewCenterInWindow;
//                        offsetX = tableViewCenterInWindow.x - inWindow.x;
//                        offsetY = tableViewCenterInWindow.y - inWindow.y;
//                        snapshot.alpha = 1.0;
//                        [self.window addSubview:snapshot];
//                        [UIView animateWithDuration:0.25 animations:^{
//
//                            // Offset for gesture location.
//                            snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
//                            snapshot.alpha = 0.98;
//                            listTableView.hidden = YES;
//                        } completion:^(BOOL finished) {
//
//                        }];
//                        self.pagingEnabled = NO;
//                    }
//                        break;
//                }
//            }
        }
            break;
        //手势移动
        case UIGestureRecognizerStateChanged: {
            //跟随手指移动截图
            snapshot.center = CGPointMake(inWindow.x+offsetX, inWindow.y+offsetY);
            //初始化横向滚动边界
            if (CGRectGetMaxX(snapshot.frame) <= ScreenWidth) {
                rollBeginMaxX = ScreenWidth;
            }
            if (CGRectGetMinX(snapshot.frame) >= 0) {
                rollBeginMinX = 0;
            }
            
            //向右滚动
            if (CGRectGetMaxX(snapshot.frame) > rollBeginMaxX) {
                if (!link) {
                    //初始化CADisplayLink，一秒调用60次plusContentOffset
                    link = [CADisplayLink displayLinkWithTarget:self selector:@selector(plusContentOffset)];
                    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
                }
                //根据截图范围与边界的关系，调整滚动快慢参数
                if ((CGRectGetMaxX(snapshot.frame) - rollBeginMaxX)/5 < 1) {
                    _increment = 1;
                }
                else if((CGRectGetMaxX(snapshot.frame) - rollBeginMaxX)/5 > 20) {
                    _increment = 20;
                }
                else {
                    _increment = (CGRectGetMaxX(snapshot.frame) - rollBeginMaxX)/5;
                }
            } else if (CGRectGetMinX(snapshot.frame) < rollBeginMinX) {//向左滚动
                if (!link) {
                    link = [CADisplayLink displayLinkWithTarget:self selector:@selector(minusContentOffset)];
                    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
                }
                
                if (-(CGRectGetMinX(snapshot.frame) - rollBeginMinX)/5 < 1) {
                    _increment = 1;
                }
                else if(-(CGRectGetMinX(snapshot.frame) - rollBeginMinX)/5 > 20) {
                    _increment = 20;
                }
                else {
                    _increment = -(CGRectGetMinX(snapshot.frame) - rollBeginMinX)/5;
                }
            } else { //截图大小范围没有超过左右边界时，滚动停止
                [link invalidate];
                link = nil;
            }
            
            //列中cell超出屏幕时上下滚动
            //向上滚动
            if(sourceIndexPath && CGRectGetMaxY(snapshot.frame) >= footerMinY && CGRectGetMinY(snapshot.frame) <= footerMaxY) {
                if (!listLink) {
                    listLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(plusListTableViewContentOffset)];
                    [listLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
                }
                 //根据截图与footer重叠大小决定滚动速度快慢
                if ((CGRectGetMaxY(snapshot.frame) - footerMinY)/5 < 1) {
                    _listIncrement = 1;
                } else if((CGRectGetMaxY(snapshot.frame) - footerMinY)/5 > 5) {
                    _listIncrement = 5;
                } else {
                    _listIncrement = (CGRectGetMaxY(snapshot.frame) - footerMinY)/5;
                }
            }
            else if(sourceIndexPath && CGRectGetMinY(snapshot.frame) <= headerMaxY  && CGRectGetMaxY(snapshot.frame) >= headerMinY) { //向下滚动
                if (!listLink) {
                    listLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(minusListTableViewContentOffset)];
                    [listLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
                }
                //根据截图与header重叠大小决定滚动速度快慢
                if ((headerMaxY - CGRectGetMinY(snapshot.frame))/5 < 1) {
                    _listIncrement = 1;
                } else if((headerMaxY - CGRectGetMinY(snapshot.frame))/5 > 5) {
                    _listIncrement = 5;
                } else {
                    _listIncrement = (headerMaxY - CGRectGetMinY(snapshot.frame))/5;
                }
            } else { //不重叠时停止滚动
                [listLink invalidate];
                listLink = nil;
            }
            
            //目标列为空列时，手动创建indexPath
            if (listTableView && listTableView.listModel.tasks.count == 0) {
                indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            }
            
            //多排混拖
            if( indexPath && sourceIndexPath && (listTableView != sourceListTableView) ) {
                
                //原列数据源移除
                [sourceListTableView.listModel.tasks removeObjectAtIndex:sourceIndexPath.row];
                //原列该行删除
                [sourceListTableView deleteRowsAtIndexPaths:@[sourceIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                //记录当前列为原列
                sourceListTableView = listTableView;
                //当前行为原行
                sourceIndexPath = indexPath;
                
                //更新当前列的数据源
                [listTableView.listModel.tasks insertObject:sourceListCellModel atIndex:indexPath.row];
                
                //插入cell到当前列
                [listTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                UITableViewCell *cell = [listTableView cellForRowAtIndexPath:indexPath];
                //隐藏该cell
                cell.hidden = YES;
                sourceListCell.cellHidden = YES;
                
                [self performBatchUpdates:^{
                    [self.layout invalidateLayout];
                } completion:^(BOOL finished) {
                    
                }];
            }
            else if (indexPath && sourceIndexPath && indexPath != sourceIndexPath) { //单列内部拖拽
                //更新数据源
                [listTableView.listModel.tasks exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                NSIndexPath *copy = sourceIndexPath;
                //记录当前行为原行
                sourceIndexPath = indexPath;
                //移动行
                [listTableView moveRowAtIndexPath:copy toIndexPath:indexPath];
            }
            else if (!sourceIndexPath && listTableView && listTableView != sourceListTableView) { //整个列移动
                [UIView animateWithDuration:0.5f animations:^{
                    CGRect frame = listTableView.superview.frame;
                    listTableView.superview.frame = CGRectMake(sourceListTableView.yyLeft, sourceListTableView.yyTop, frame.size.width, frame.size.height);
                    sourceListTableView.superview.frame = CGRectMake(frame.origin.x, frame.origin.y, sourceListTableView.yyWidth, sourceListTableView.yyHeight);
                } completion:^(BOOL finished) {
                    
                }];
                NSInteger sourceIndex = [_listTableViewArray indexOfObject:sourceListTableView];
                NSInteger index = [_listTableViewArray indexOfObject:listTableView];
                [_listTableViewArray exchangeObjectAtIndex:sourceIndex withObjectAtIndex:index];
            }
        }
            break;
        //手势结束
        case UIGestureRecognizerStateEnded: {
            //停止link
            [link invalidate];
            link = nil;
            [listLink invalidate];
            link = nil;
            
            //原行存在
            if (sourceIndexPath) {
                UITableViewCell *cell = [sourceListTableView cellForRowAtIndexPath:sourceIndexPath];
                //显示cell
                cell.hidden = NO;
                sourceListCell.cellHidden = NO;
                cell.alpha = 0.0;
                
                //目标行存在
                if(indexPath) {
                    //发起移动请求
                    TaskModel *taskModel = listTableView.listModel.tasks[indexPath.row];
//                    _moveTaskApi.t_id = @(taskModel.t_id.integerValue);
//                    [_moveTaskApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
//                        BaseModel *model = (BaseModel *)request.responseModel;
//                        if (model.status.boolValue == YES) {
                            //请求成功后截图返回到cell所在位置动画
                            [UIView animateWithDuration:0.25 animations:^{
                                __block CGPoint cellCenterInWindow = [sourceListTableView convertPoint:cell.center toView:nil];
                                snapshot.center = cellCenterInWindow;
                                snapshot.transform = CGAffineTransformIdentity;
                                snapshot.alpha = 1.0;
                            } completion:^(BOOL finished) {
                                sourceIndexPath = nil;
                                [snapshot removeFromSuperview];
                                snapshot = nil;
                                cell.alpha = 1.0;
                                //松手后根据contentOffset滚动分页
//                                if (self.pagingEnabled) {
                                    NSInteger page = (NSInteger)(self.contentOffset.x/self.yyWidth+0.5);
                                    [self setContentOffset:CGPointMake(page * (ScreenWidth - 45.0f), 0) animated:YES];
//                                };
                            }];
//                        }
//                        else {
////                            [MBProgressHUD showOnlyText:model.msg];
//                        }
//                    } failure:^(YTKBaseRequest *request) {
//
//                    }];
                }
                else { //处理cell在空白区域放手的情况
                    [UIView animateWithDuration:0.25 animations:^{
                        __block CGPoint cellCenterInWindow = [sourceListTableView convertPoint:cell.center toView:nil];
                        snapshot.center = cellCenterInWindow;
                        snapshot.transform = CGAffineTransformIdentity;
                        snapshot.alpha = 1.0;
                    } completion:^(BOOL finished) {
                        sourceIndexPath = nil;
                        [snapshot removeFromSuperview];
                        snapshot = nil;
                        cell.alpha = 1.0;
//                        if (self.pagingEnabled) {
                            NSInteger page = (NSInteger)(self.contentOffset.x/self.yyWidth+0.5);
                            [self setContentOffset:CGPointMake(page * (ScreenWidth - 45.0f), 0) animated:YES];
//                        };
                    }];
                }
            }
            else if(sourceListTableView) { //移动list后的动画
                offsetY = 0;
                sourceListTableView.hidden = NO;
                sourceListTableView.alpha = 0.0;
                __block CGPoint tableViewCenterInWindow = [self convertPoint:sourceListTableView.center toView:nil];
                [UIView animateWithDuration:0.25 animations:^{
                    snapshot.center = tableViewCenterInWindow;
                    snapshot.transform = CGAffineTransformIdentity;
                    snapshot.alpha = 1.0;
                } completion:^(BOOL finished) {
                    [snapshot removeFromSuperview];
                    snapshot = nil;
                    sourceListTableView.alpha = 1.0;
                    sourceListTableView = nil;
                }];
            }
        }
            break;
        default:
            break;
    }
}

//单击空白处list整体缩放
- (void)tapGestureRecognized:(UITapGestureRecognizer *)tap {
    if (zoom == TrelloZoomNot) {
        zoom = TrelloZoomOut;
    }

//    [_visibleTableViewArray enumerateObjectsUsingBlock:^(UITableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        __block UIView *snapshot = [self customSnapshoFromView:obj];
//        CGPoint center = [self convertPoint:obj.center toView:nil];
//        snapshot.center = center;
//        snapshot.alpha = 1.0;
//        obj.hidden = YES;
//        [self.window addSubview:snapshot];
//        
//        [UIView animateWithDuration:0.25 animations:^{
//            snapshot.frame = CGRectMake(snapshot.yyLeft*zoomOut, snapshot.yyTop, snapshot.yyWidth*zoomOut, snapshot.yyHeight*zoomOut);
//        } completion:^(BOOL finished) {
//            snapshot.hidden = YES;
//            snapshot = nil;
//            obj.hidden = NO;
//        }];
//    }];
    
    CGPoint location = [tap locationInView:self];
    CGFloat offset = location.x - self.contentOffset.x;
    switch (zoom) {
        case TrelloZoomOut: {
            self.pagingEnabled = NO;
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(0, self.yyTop, ScreenWidth, self.yyHeight);
                self.contentOffset = CGPointMake(self.contentOffset.x*zoomOut, self.contentOffset.y);
                self.contentSize = CGSizeMake(self.contentSize.width*zoomOut, self.contentSize.height);
                [_listTableViewArray enumerateObjectsUsingBlock:^(BoardViewListTableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.frame = CGRectMake(obj.yyLeft*zoomOut, obj.yyTop*zoomOut, obj.yyWidth*zoomOut, obj.yyHeight*zoomOut);
                }];
            }];
            zoom = TrelloZoomIn;
            break;
        }
        case TrelloZoomIn: {
            self.pagingEnabled = YES;
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(30, self.yyTop, ScreenWidth-45, self.yyHeight);
                self.contentOffset = CGPointMake(self.contentOffset.x*zoomIn+offset, self.contentOffset.y);
                self.contentSize = CGSizeMake(self.contentSize.width*zoomIn, self.contentSize.height);
                [_listTableViewArray enumerateObjectsUsingBlock:^(BoardViewListTableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.frame = CGRectMake(obj.yyLeft*zoomIn, obj.yyTop*zoomIn, obj.yyWidth*zoomIn, obj.yyHeight*zoomIn);
                }];
            }];
            zoom = TrelloZoomOut;
            break;
        }
    }
}
//手势拦截
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    PowerLog(touch.view);
//    PowerLog(gestureRecognizer);
////    if ([touch.view isKindOfClass:[BoardViewclass]]) {
////        return YES;
////    }
//    if ([gestureRecognizer isMemberOfClass:NSClassFromString(@"UIScrollViewPagingSwipeGestureRecognizer")]) {
//        return NO;
//    }
//    return YES;
//}

//向左滚动
- (void)plusContentOffset {
    if (self.contentOffset.x < self.contentSize.width-(ScreenWidth-60.0f/2)) {
        self.contentOffset = CGPointMake(self.contentOffset.x+_increment, self.contentOffset.y);
    }
}
//向右滚动
- (void)minusContentOffset {
    if (self.contentOffset.x > 0) {
        self.contentOffset = CGPointMake(self.contentOffset.x-_increment, self.contentOffset.y);
    }
}
//向上滚动
- (void)plusListTableViewContentOffset {
    BoardViewListTableView *tableView = self.listTableView;
    CGPoint contentOffset = tableView.contentOffset;
    if (tableView.contentSize.height-tableView.yyHeight >= contentOffset.y) {
        contentOffset.y+=_listIncrement;
    }
    tableView.contentOffset = contentOffset;
}
//向下滚动
- (void)minusListTableViewContentOffset {
    BoardViewListTableView *tableView = self.listTableView;
    CGPoint contentOffset = tableView.contentOffset;
    if (contentOffset.y >= 0) {
        contentOffset.y-=_listIncrement;
    }
    tableView.contentOffset = contentOffset;
}

#pragma mark - Responding to keyboard events
//键盘事件处理
- (void)adjustTextViewByKeyboardState:(BOOL)showKeyboard keyboardInfo:(NSDictionary *)info {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    // transform the UIViewAnimationCurve to a UIViewAnimationOptions mask

    UIViewAnimationCurve animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    UIViewAnimationOptions animationOptions = UIViewAnimationOptionBeginFromCurrentState;
    if (animationCurve == UIViewAnimationCurveEaseIn) {
        animationOptions |= UIViewAnimationOptionCurveEaseIn;
    }
    else if (animationCurve == UIViewAnimationCurveEaseInOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseInOut;
    }
    else if (animationCurve == UIViewAnimationCurveEaseOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseOut;
    }
    else if (animationCurve == UIViewAnimationCurveLinear) {
        animationOptions |= UIViewAnimationOptionCurveLinear;
    }
    
//    [self.textView setNeedsUpdateConstraints];
    
    if (showKeyboard) {
//        UIDeviceOrientation orientation = self.interfaceOrientation;
//        BOOL isPortrait = UIDeviceOrientationIsPortrait(orientation);
        
        NSValue *keyboardFrameVal = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = [keyboardFrameVal CGRectValue];
//        CGFloat height = isPortrait ? keyboardFrame.size.height : keyboardFrame.size.width;
        //保存键盘高度
        _keyboardHeight = keyboardFrame.size.height;
        // adjust the constraint constant to include the keyboard's height
        //循环遍历改变列高度
        [self.listTableViewArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.superview updateConstraints:^(MASConstraintMaker *make) {
                if (StatusBarHeight+obj.superview.yyHeight+kVerticalSpacing+_keyboardHeight>ScreenHeight) {
                    make.height.equalTo(ScreenHeight-(StatusBarHeight+kVerticalSpacing+_keyboardHeight));
                }
                else {
                    make.height.equalTo(obj.superview.yyHeight);
                }
            }];
        }];
    }
    else {
        NSValue *keyboardFrameVal = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = [keyboardFrameVal CGRectValue];
        //        CGFloat height = isPortrait ? keyboardFrame.size.height : keyboardFrame.size.width;
        _keyboardHeight = keyboardFrame.size.height;
        // adjust the constraint constant to include the keyboard's height
        
        [_listTableViewArray enumerateObjectsUsingBlock:^(BoardViewListTableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.superview updateConstraints:^(MASConstraintMaker *make) {
                if(Global_ListHeaderHeight+obj.cellTotalHeight+Global_ListFooterHeight>kListViewMaxHeight) {
                    make.height.equalTo(kListViewMaxHeight);
                }
                else {
                    make.height.equalTo(Global_ListHeaderHeight+obj.cellTotalHeight+Global_ListFooterHeight);
                }
            }];
        }];
        //键盘消失，高度置0
        _keyboardHeight = 0;
    }
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //跟随键盘动画
    [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
        [self layoutIfNeeded];
    } completion:nil];
    
    // now that the frame has changed, move to the selection or point of edit
//    NSRange selectedRange = self.textView.selectedRange;
//    [self.textView scrollRangeToVisible:selectedRange];
}
//键盘显示通知
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    [self adjustTextViewByKeyboardState:YES keyboardInfo:userInfo];
}
//键盘隐藏通知
- (void)keyboardWillHidden:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    [self adjustTextViewByKeyboardState:NO keyboardInfo:userInfo];
}

#pragma mark - Helper methods
//截图方法
/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

//视图响应触摸事件拦截方法，hitTest：
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    if (point.x>0.0f && point.x<15.0f && self.listView.contentOffset.x>=330 && point.y>self.listView.yyTop && point.y<self.listView.yyBottom) {
//        return self.listView.visibleTableViewArray[(NSInteger)self.listView.contentOffset.x/330-1];
//    }
//    else if (point.x>ScreenWidth-15.0f && self.listView.contentOffset.x!=self.listView.contentSize.width-330 && point.x<ScreenWidth && point.y>self.listView.yyTop && point.y<self.listView.yyBottom){
//        CGPoint convertPoint = [self convertPoint:point toView:self.listView.visibleTableViewArray[(NSInteger)self.listView.contentOffset.x/330+1]];
//        //        return [self.listView.visibleTableViewArray[(NSInteger)self.listView.contentOffset.x/330+1] hitTest:convertPoint withEvent:event];
//        return self.listView.visibleTableViewArray[(NSInteger)self.listView.contentOffset.x/330+1];
//    }
//    else {
//        return [super hitTest:point withEvent:event];
//    }
//}

- (void)reloadListLayout {
    BoardViewListLayout *listLayout = (BoardViewListLayout *)self.collectionViewLayout;
    [listLayout invalidateLayout];
}

@end
