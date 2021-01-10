//
//  BoardViewList.m
//  Trello
//
//  Created by xiao on 5/4/20.
//  Copyright © 2020 wxl. All rights reserved.
//

#import "BoardViewList.h"
#import "BoardViewListTableView.h"
#import "BoardViewListFooterView.h"
#import "BoardViewListHeaderView.h"
#import "BoardViewListTableViewCell.h"
#import "AddTaskApi.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "BoardView.h"

static CGFloat zoomIn = 1.8; //缩放因子
static CGFloat zoomOut = 1/1.8;
static CGFloat kVerticalSpacing = 20; //垂直间距
static CGFloat kListViewMaxHeight; //最大listView高度
static CGFloat kTotalCellMaxHeight; //cell区域最大高度
static CGFloat kListHeaderHeight = 46; //list header高度
static CGFloat kListFooterHeight = 44; //list footer高度
static CGFloat kCellDefaultHeight = 44; //cell 默认高度
static CGFloat kPageControlHeight = 20;

@interface BoardViewList()
@property (nonatomic) CGFloat keyboardHeight;
@property (nonatomic, weak) UIView *listView;
@property (nonatomic, weak) BoardViewListHeaderView *header;
@property (nonatomic, weak) UILabel *listTitle;
@property (nonatomic, weak) BoardViewListFooterView *footer;
@property (nonatomic, weak) UIButton *addCard;
@property (nonatomic, weak) UIButton *add;
@property (nonatomic, weak) UIButton *cancel;
@property (nonatomic, weak) UITextView *textView;


@end

@implementation BoardViewList
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        kListViewMaxHeight = frame.size.height-kVerticalSpacing*2-NavAndStatusBarHeight-kPageControlHeight-SafeAreaInsetsBottom;
        kTotalCellMaxHeight = kListViewMaxHeight - kListHeaderHeight - kListFooterHeight;
//        self.backgroundColor = [UIColor blueColor];
        [self setUpAllChildView];
    }
    return self;
}

- (NSInteger)collectionViewCellHeight {
    NSInteger tmp = kListHeaderHeight + self.listTableView.cellTotalHeight + kListFooterHeight;
    NSInteger listViewHeight = tmp < kListViewMaxHeight ? tmp : kListViewMaxHeight;
    _collectionViewCellHeight = listViewHeight + kVerticalSpacing;
    return _collectionViewCellHeight;
}

- (void)setUpAllChildView {
    //tableView背景视图
        UIView *listView = ({
            UIView *listView = UIView.new;
            listView.backgroundColor = Global_BackgroundColor;
            listView.backgroundColor = [UIColor greenColor];
            [self addSubview:listView];
            //通过Masonry设置autolayout，设置前一定要先添加在父视图上
            [listView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
                make.top.equalTo(kVerticalSpacing);
                make.width.equalTo(ScreenWidth-60);
                make.bottom.equalTo(0);
            }];
            _listView = listView;
            //初始化tableView
            UIView *listTableView = ({
                BoardViewListTableView *listTableView = [BoardViewListTableView new];
                //设置tableView的contentInset(也可以通过设置tableView的autolayout来做，可以避免长按header时识别成cell的情况，长按头部应该是移动整个list)
                listTableView.contentInset = UIEdgeInsetsMake(kListHeaderHeight, 0, kListFooterHeight, 0);
                listTableView.backgroundColor = Global_ClearColor;
                listTableView.delegate = self;
                listTableView.dataSource = self;
                listTableView.rowHeight = UITableViewAutomaticDimension;
                //估算rowHeight，必须设置，否则会引起卡顿
                listTableView.estimatedRowHeight = kCellDefaultHeight;
                //每一个tableView保存自己的数据源指针
//                listTableView.listModel = self.listModel;
                [listTableView registerClass:[BoardViewListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BoardViewListTableViewCell class])];
                listTableView.tableFooterView = UIView.new;
                //显示每一列的滚动条（现在有Bug不显示）
                listTableView.showsVerticalScrollIndicator = NO;
                [listView addSubview:listTableView];
                [listTableView makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(0);
                    make.top.equalTo(0);
                    make.right.equalTo(0);
                    make.bottom.equalTo(0);
                }];
                _listTableView = listTableView;

    //                    //设置偏移量
    //                    nextX = (idx+1)*(ScreenWidth-60+15);

    //                    //保存listTableView指针
    //                    [self.listTableViewArray addObject:listTableView];

                //初始化list的header
                UIView *header = ({
                    BoardViewListHeaderView *header = [[BoardViewListHeaderView alloc] init];
                    [listView addSubview:header];
                    listTableView.header = header;
    //                    [self.listHeaderArray addObject:header];
                    [header makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(0);
                        make.top.equalTo(0);
                        make.right.equalTo(0);
                        make.height.equalTo(kListHeaderHeight);
                    }];
                    _header = header;
                    header.backgroundColor = Global_BackgroundColor;

                    //list圆角设置，更换autolayout后失效，待解决
    //                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:header.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    //                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //                    maskLayer.frame = header.bounds;
    //                    maskLayer.path = maskPath.CGPath;
    //                    header.layer.mask = maskLayer;

                    //列名，header title
                    UILabel *listTitle = ({
                        UILabel *view = [UILabel new];
                        view.backgroundColor = [UIColor clearColor];
//                        view.text = listTableView.listModel.name;
                        [header addSubview:view];
                        [view makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(pt(25));
                            make.top.equalTo(pt(16));
                            make.right.equalTo(-pt(25));
                            make.height.equalTo(pt(64));
                        }];
                        _listTitle = view;
                        view;
                    });

                    //header右侧的menu按钮，未做功能暂时隐藏
    //                    UIImageView *imageView = ({
    //                        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_dropdown_menu_100_16pt18box"]];
    ////                        imageView.center = CGPointMake(header.yyWidth-pt(29)-pt(36)/2, header.center.y);
    //                        [header addSubview:imageView];
    //                        [imageView makeConstraints:^(MASConstraintMaker *make) {
    ////                            make.centerX.equalTo(-pt(29)-pt(36)/2);
    ////                            make.centerY.equalTo(0);
    //                            make.right.equalTo(-pt(29));
    //                            make.centerY.equalTo(0);
    //                        }];
    //                        [imageView sizeToFit];
    //                        imageView.alpha = 0.25;
    //                        imageView;
    //                    });

                    header;
                });
                //初始化list的footer
                UIView *footer = ({
                    BoardViewListFooterView *footer = [BoardViewListFooterView new];
                    footer.backgroundColor = Global_BackgroundColor;
                    listTableView.footer = footer;
    //                    [self.listFooterArray addObject:footer];
                    [listView addSubview:footer];
                    [footer makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(0);
                        make.right.equalTo(0);
                        make.bottom.equalTo(0);
                        // pt(<#Px#>)可以根据设置的机型把像素坐标自动转换成点（根据机型设置自动进行除二或除三运算）
                        make.height.equalTo(pt(88));
                    }];
                    _footer = footer;
                    //初始化addCard按钮
                    UIView *addCard = ({
                        UIButton *addCard = UIButton.new;
                        [footer addSubview:addCard];
                        [addCard makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(0);
                            make.top.equalTo(0);
                            make.right.equalTo(0);
                            make.bottom.equalTo(0);
                        }];
                        _addCard = addCard;
                        
                        [addCard setTitle:@"addCard" forState:UIControlStateNormal];
                        [addCard setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

                        //                            [addCard addTarget:self action:@selector(addCard:) forControlEvents:UIControlEventTouchUpInside];
                        //使用ReactiveCocoa处理点击事件，相当于上面的addTarget:方法
                        //addCard点击事件
                        [[addCard rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                            //隐藏addCard
                            addCard.alpha = 0;
                            UITextView *textView = ({
                                UITextView *view = [UITextView new];
                                [footer addSubview:view];
                                [view makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo(10);
//                                    make.top.equalTo(2);
                                    make.right.equalTo(-10);
                                    make.bottom.equalTo(-44+2);
                                }];
                                _textView = view;
                                //因为footer变大，所以改变tableView的contentInset
                                listTableView.contentInset = UIEdgeInsetsMake(kListHeaderHeight, 0, kListFooterHeight*2, 0);
                                //立即刷新视图
                                [self layoutIfNeeded];
                                view;
                            });

                            //初始化add按钮
                            UIButton *add = ({
                                UIButton *view = [UIButton new];
                                [view setTitle:@"Add" forState:UIControlStateNormal];
                                [view setTitleColor:Global_trelloBlue forState:UIControlStateNormal];
                                view.titleLabel.font = [UIFont systemFontOfSize:15];
                                [footer addSubview:view];
                                [view makeConstraints:^(MASConstraintMaker *make) {
                                    make.right.equalTo(-20);
                                    make.bottom.equalTo(-5);
                                }];
                                [view sizeToFit];
                                _add = view;

                                //初始化后隐藏(为了动画效果)
                                view.alpha = 0;
                                //立即刷新
                                [self layoutIfNeeded];

                                //add点击事件，创建新的tast
                                [[view rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                                    TaskModel *model = [[TaskModel alloc] init];
                                    model.t_taskContent = textView.text;
                                    textView.text = nil;
                                    //更新数据源
                                    [listTableView.listModel.tasks addObject:model];
                                    //插入行
                                    [listTableView insertRow:listTableView.listModel.tasks.count-1 inSection:0 withRowAnimation:UITableViewRowAnimationBottom];
                                    //计算rowHeight
                                    CGFloat rowHeight = [self tableView:listTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:listTableView.listModel.tasks.count-1 inSection:0]];
                                    //根据当前列高度和rowHeight决定列高度是否增加
                                    //updateConstraints:方法更新autolayout
                                    [listView updateConstraints:^(MASConstraintMaker *make) {
                                        //增加新的rowHeight后list超出允许最大高度，之前不满最大高度
                                        if (listTableView.cellTotalHeight > (kTotalCellMaxHeight+NavAndStatusBarHeight-_keyboardHeight-kCellDefaultHeight) && (listTableView.cellTotalHeight-rowHeight) < (kTotalCellMaxHeight+NavAndStatusBarHeight-_keyboardHeight-kCellDefaultHeight)) {
                                            make.height.equalTo(listView.yyHeight+((kTotalCellMaxHeight+NavAndStatusBarHeight-_keyboardHeight-kCellDefaultHeight)-(listTableView.cellTotalHeight-rowHeight)));
                                        }
                                        //增加新的rowHeight后list没有超过允许最大高度
                                        if (listTableView.cellTotalHeight <= (kTotalCellMaxHeight+NavAndStatusBarHeight-_keyboardHeight-kCellDefaultHeight)) {
                                            make.height.equalTo(listView.yyHeight+rowHeight);
                                        }
                                    }];
                                    //autolayout动画
                                    [UIView animateWithDuration:0.25 animations:^{
                                        [self layoutIfNeeded];
                                    }];
                                    //tableView滚动到最底部，显示新添加行
                                    [listTableView scrollToRow:listTableView.listModel.tasks.count-1 inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                                    }];
                                view;
                            });

                            //初始化cancel按钮
                            UIView *cancel = ({
                                UIButton *view = [UIButton new];
                                [view setTitle:@"Cancel" forState:UIControlStateNormal];
                                [view setTitleColor:Global_trelloBlue forState:UIControlStateNormal];
                                view.titleLabel.font = [UIFont systemFontOfSize:15];
                                [footer addSubview:view];
                                [view makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo(20);
                                    make.bottom.equalTo(-5);
                                }];
                                [view sizeToFit];
                                _cancel = view;
                                
                                view.alpha = 0;
                                [self layoutIfNeeded];
                                //cancel点击事件
                                @weakify(self, view, textView, footer, listView, add, addCard)
                                [[view rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                                    @strongify(self, view, textView, footer, listView, add, addCard)
                                    //footer高度还原
                                    [footer updateConstraints:^(MASConstraintMaker *make) {
                                        make.height.equalTo(kListFooterHeight);
                                    }];
                                    //list减去footer增加的高度(在这里做是为了动效)
                                    [listView updateConstraints:^(MASConstraintMaker *make) {
                                        make.height.equalTo(listView.yyHeight-kListFooterHeight);
                                    }];
                                    //tableView的contentInset还原
                                    listTableView.contentInset = UIEdgeInsetsMake(kListHeaderHeight, 0, kListFooterHeight, 0);
                                    //隐藏textView
                                    textView.alpha = 0;

                                    [UIView animateWithDuration:0.25 animations:^{
                                        //cancel隐藏
                                        view.alpha = 0;
                                        //add隐藏
                                        add.alpha = 0;
                                        //addCard显示
                                        addCard.alpha = 1;
                                        [self.viewController.navigationController setNavigationBarHidden:NO animated:YES];
                                        [self layoutIfNeeded];
                                    }];
                                    [textView resignFirstResponder];
                                }];
                                view;
                            });
                            
                            //addCard点击后动效
                            [footer updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(kListFooterHeight*2);
                            }];
                            
                            [textView updateConstraints:^(MASConstraintMaker *make) {
                               make.top.equalTo(2);
                            }];
                            
                            [listView updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(listView.yyHeight+kListFooterHeight);
                            }];
                            
                            [UIView animateWithDuration:0.25 animations:^{
                                [self.viewController.navigationController setNavigationBarHidden:YES animated:YES];
                                add.alpha = 1;
                                cancel.alpha = 1;
                                [self layoutIfNeeded];
                            }];
                            //弹出键盘
                            [textView becomeFirstResponder];
                        }];
                        addCard;
                    });
                    footer;
                });
                listTableView;
            });
            listView;
        });
}

- (void)setListModel:(ListModel *)listModel {
    _listModel = listModel;
    _listTableView.listModel = listModel;
    _listTitle.text = _listModel.name;
    [_listTableView reloadData];
}

- (void)layoutSubviews {
//    //通过Masonry设置autolayout，设置前一定要钱添加在父视图上
//    [_listView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(0);
//        make.top.equalTo(NavigationBarHeight+kVerticalSpacing);
//        make.width.equalTo(ScreenWidth-60);
//        make.height.equalTo(kListViewMaxHeight);
//    }];
//    PowerLog(_listView.frame);
//    _listView.backgroundColor = [UIColor blueColor];
//
//    [_listTableView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(0);
//        make.top.equalTo(0);
//        make.right.equalTo(0);
//        make.bottom.equalTo(0);
//    }];
//    _listTableView.backgroundColor = [UIColor redColor];
//    [_listTableView reloadData];
//    PowerLog(_listTableView);
//    PowerLog(_listTableView.frame);
//
//    [_header makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(0);
//        make.top.equalTo(0);
//        make.right.equalTo(0);
//        make.height.equalTo(kListHeaderHeight);
//    }];
//
//    [_listTitle makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(pt(25));
//        make.top.equalTo(pt(16));
//        make.right.equalTo(-pt(25));
//        make.height.equalTo(pt(64));
//    }];
//
//    [_footer makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(0);
//        make.right.equalTo(0);
//        make.bottom.equalTo(0);
//        // pt(<#Px#>)可以根据设置的机型把像素坐标自动转换成点（根据机型设置自动进行除二或除三运算）
//        make.height.equalTo(pt(88));
//    }];
//
//    [_addCard makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(0);
//        make.top.equalTo(0);
//        make.right.equalTo(0);
//        make.bottom.equalTo(0);
//    }];
//
//    [_add makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(-20);
//        make.bottom.equalTo(-5);
//    }];
//    [_add sizeToFit];
//
//    [_cancel makeConstraints:^(MASConstraintMaker *make) {
//       make.left.equalTo(20);
//       make.bottom.equalTo(-5);
//    }];
//    [_cancel sizeToFit];
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    //解决collectionViewcell重用listView高度问题
    [_listView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(kListViewMaxHeight);
    }];
}

#pragma mark TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BoardViewListTableView *listTableView = (BoardViewListTableView *)tableView;
    //没有task的列更新高度
    if (listTableView.listModel.tasks.count == 0) {
        [tableView.superview updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kListHeaderHeight+kListFooterHeight);
        }];
    }
//    else { //解决collectionViewcell重用listView高度问题
//        [tableView.superview updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(kListViewMaxHeight);
//        }];
//    }
    return listTableView.listModel.tasks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableView+FDTemplateLayoutCell库做cell自适应（- fd_heightForCellWithIdentifier: configuration: 不带cache的方法可以避免极速拖动cell时的高度混乱问题，但流程性会下降）
    CGFloat height = [tableView fd_heightForCellWithIdentifier:NSStringFromClass([BoardViewListTableViewCell class]) cacheByIndexPath:indexPath configuration:^(id cell) {
        //配置cell
        [self tableView:tableView configureCell:cell atIndexPath:indexPath];
    }];
    //算高不满默认高度时返回默认高度
//    PowerLog(height>kCellDefaultHeight?height:kCellDefaultHeight);
    return height>kCellDefaultHeight?height:kCellDefaultHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BoardViewListTableView *listTableView = (BoardViewListTableView *)tableView;
    BoardViewListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BoardViewListTableViewCell class]) forIndexPath:indexPath];
    
    [self tableView:tableView configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//单列最后一个cell加载时更新当前列高度，不更新即为默认最大高度
//    NSInteger collectionViewCellHeight = self.collectionViewCellHeight;
//    NSInteger listViewHeight = collectionViewCellHeight - kVerticalSpacing;
    if(([indexPath row] == ((NSIndexPath *)[[tableView indexPathsForVisibleRows] lastObject]).row) && (_keyboardHeight == 0)) {
//    if (indexPath.row+1 == listTableView.listModel.tasks.count && _keyboardHeight == 0) {
        [self.boardView reloadListLayout];
//        if (listViewHeight < kListViewMaxHeight) {
//            [_listView updateConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(listViewHeight);
//            }];
//        } else {
//            [_listView updateConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(kListViewMaxHeight);
//            }];
//        }
    }
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    //点击cell跳转
//    if ([self.boardViewDelegate respondsToSelector:@selector(boardView:listTableView:didSelectRowAtIndexPath:)]) {
//        [self.boardViewDelegate boardView:self listTableView:(BoardViewListTableView *)tableView didSelectRowAtIndexPath:indexPath];
//    }
//}
//配置cell，fd会根据此进行算高
- (void)tableView:(UITableView *)tableView configureCell:(BoardViewListTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    BoardViewListTableView *listTableView = (BoardViewListTableView *)tableView;
    cell.taskModel = listTableView.listModel.tasks[indexPath.row];
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
//        //循环遍历改变列高度
//        [self.listTableViewArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [obj.superview updateConstraints:^(MASConstraintMaker *make) {
//                if (StatusBarHeight+obj.superview.yyHeight+kVerticalSpacing+_keyboardHeight>ScreenHeight) {
//                    make.height.equalTo(ScreenHeight-(StatusBarHeight+kVerticalSpacing+_keyboardHeight));
//                }
//                else {
//                    make.height.equalTo(obj.superview.yyHeight);
//                }
//            }];
//        }];
    }
    else {
        NSValue *keyboardFrameVal = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = [keyboardFrameVal CGRectValue];
        //        CGFloat height = isPortrait ? keyboardFrame.size.height : keyboardFrame.size.width;
        _keyboardHeight = keyboardFrame.size.height;
        // adjust the constraint constant to include the keyboard's height
        
//        [_listTableViewArray enumerateObjectsUsingBlock:^(BoardViewListTableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [obj.superview updateConstraints:^(MASConstraintMaker *make) {
//                if(kListHeaderHeight+obj.cellTotalHeight+kListFooterHeight>kListViewMaxHeight) {
//                    make.height.equalTo(kListViewMaxHeight);
//                }
//                else {
//                    make.height.equalTo(kListHeaderHeight+obj.cellTotalHeight+kListFooterHeight);
//                }
//            }];
//        }];
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
@end
