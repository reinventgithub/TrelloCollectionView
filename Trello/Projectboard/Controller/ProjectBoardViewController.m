//
//  ProjectBoardViewController.m
//  SCTrelloNavigation
//
//  Created by Yh c on 15/11/5.
//  Copyright © 2015年 Yh c. All rights reserved.
//

#import "ProjectBoardViewController.h"
#import "UINavigationBar+Awesome.h"
#import "UIImage+ImageWithColor.h"
#import "GetProjectBoardApi.h"
#import "ProjectBoardModel.h"
#import "BoardView.h"
#import "BoardViewList.h"
//#import "WTaskDetailViewController.h"
#import "SMPageControl.h"
#import "BoardViewListLayout.h"

@interface ProjectBoardViewController () <BoardViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) SMPageControl *pageControl;
@property (nonatomic, strong) BoardViewListLayout *layout;
@property (nonatomic) CGFloat scale;
@property (weak, nonatomic) UIView *currentAddCardListView;
@property (weak, nonatomic) UIView *currentAddCardFooter;
@property (nonatomic) CGFloat keyboardHeight;
@property (strong, nonatomic) NSMutableArray *listTableViewArray;
//@property (strong, nonatomic) NSMutableArray *listHeaderArray;
//@property (strong, nonatomic) NSMutableArray *listFooterArray;
@property (nonatomic, assign) CGFloat offer;
@end


@implementation ProjectBoardViewController {
    BoardView *_boardView;
    ProjectBoardModel *_model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Global_trelloDeepBlue;
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //禁止ScrollViewInset自动调整
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//                                                         forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"header_leftbtn_white_nor"] style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = back;
    self.title = _project_name;
#pragma mark navBar上的搜索图标初始化
//    UIBarButtonItem *search = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search:)];
//    search.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = search;
    // Do any additional setup after loading the view, typically from a nib.
/*
#pragma mark 初始化BoardView(scrollView)
    _boardView = [[BoardView alloc] initWithFrame:CGRectMake(30.0f, 0, ScreenWidth - 45.0f, ScreenHeight-NavAndStatusBarHeight)];
    _boardView.boardViewDelegate = self;
    _boardView.delegate = self;
//    PowerLog(_boardView.frame);
    _boardView.project_id = _project_id;
    _boardView.backgroundColor = [UIColor redColor];
//    _boardView.layer.masksToBounds = NO;
    //显示超出父控件范围的视图
    _boardView.clipsToBounds = NO;
*/
#pragma mark 初始化BoardView(collectionView)
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake(self.view.bounds.size.width - 60, self.view.bounds.size.height);
//    layout.sectionInset = UIEdgeInsetsMake(0, 30, 0, 30);
//    layout.minimumLineSpacing = 15;
//    layout.minimumInteritemSpacing = 0;
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    _layout = layout;
////    _boardView = [[BoardView alloc] initWithFrame:CGRectMake(30.0f, 0, ScreenWidth - 45.0f, ScreenHeight-NavAndStatusBarHeight) collectionViewLayout:layout];
    BoardViewListLayout *layout = [[BoardViewListLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.bounds.size.width - 60, self.view.bounds.size.height);
    _layout = layout;
    
    BoardView *boardView = [[BoardView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
    boardView.layout = _layout;
    boardView.dataSource = self;
    boardView.delegate = self;
    boardView.decelerationRate = 10;//我改的是10
    [boardView registerClass:[BoardViewList class] forCellWithReuseIdentifier:NSStringFromClass([BoardViewList class])];
    boardView.backgroundColor = Global_trelloDeepBlue;
    _boardView = boardView;
    
    [self.view addSubview:_boardView];
    //请求看板数据
    [self loadData];
}

- (void)back:(id)sender {
//    _boardView.clipsToBounds = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)search:(id)sender {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [PixelLayout setDevice:iPhone6 isPixel:pixel isScale:allScale];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [PixelLayout setDevice:iPhone5 isPixel:point isScale:allScaleWithFont];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 请求看板数据
- (void)loadData {
    
    NSDictionary *dict = @{@"items" : @[  @{  @"id" : @"1",
                                              @"name" : @"面朝大海，春暖花开",
                                              @"task" : @[@{@"t_taskContent" : @"从明天起，做一个幸福的人"},
                                                          @{@"t_taskContent" : @"喂马，劈柴，周游世界"},
                                                          @{@"t_taskContent" : @"从明天起，关心粮食和蔬菜"},
                                                          @{@"t_taskContent" : @"我有一所房子，面朝大海，春暖花开"},
                                                          @{@"t_taskContent" : @"从明天起，和每一个亲人通信"},
                                                          @{@"t_taskContent" : @"告诉他们我的幸福"},
                                                          @{@"t_taskContent" : @"那幸福的闪电告诉我的"},
                                                          @{@"t_taskContent" : @"我将告诉每一个人"},
                                                          @{@"t_taskContent" : @"给每一条河每一座山取一个温暖的名字"},
                                                          @{@"t_taskContent" : @"陌生人，我也为你祝福"},
                                                          @{@"t_taskContent" : @"愿你有一个灿烂的前程"},
                                                          @{@"t_taskContent" : @"愿你有情人终成眷属"},
                                                          @{@"t_taskContent" : @"愿你在尘世获得幸福"},
                                                          @{@"t_taskContent" : @"我只愿面朝大海，春暖花开"}] },
                                          @{  @"id" : @"2",
                                              @"name" : @"礼物",
                                              @"task" : @[ @{@"t_taskContent" : @"在这五光十色的世界里"},
                                                           @{@"t_taskContent" : @"我要的只是公园里的一把长椅"},
                                                           @{@"t_taskContent" : @"有一只猫在上面晒太阳"},
                                                           @{@"t_taskContent" : @"在这五光十色的世界里"},
                                                           @{@"t_taskContent" : @"我要的只是公园里的一把长椅"},
                                                           @{@"t_taskContent" : @"有一只猫在上面晒太阳"}] },
                                          @{  @"id" : @"3",
                                              @"name" : @"再别康桥",
                                              @"task" : @[ @{@"t_taskContent" : @"轻轻的我走了，正如我轻轻的来；我轻轻的招手，作别西天的云彩。"},
                                                           @{@"t_taskContent" : @"那河畔的金柳，是夕阳中的新娘；波光里的艳影，在我的心头荡漾。"},
                                                           @{@"t_taskContent" : @"软泥上的青荇，油油的在水底招摇；在康河的柔波里，我甘心做一条水草！"},
                                                           @{@"t_taskContent" : @"那榆荫下的一潭，不是清泉，是天上虹；揉碎在浮藻间，沉淀着彩虹似的梦。"},
                                                           @{@"t_taskContent" : @"寻梦？撑一支长篙，向青草更青处漫溯；满载一船星辉，在星辉斑斓里放歌。"},
                                                           @{@"t_taskContent" : @"但我不能放歌，悄悄是别离的笙箫；夏虫也为我沉默，沉默是今晚的康桥！"},
                                                           @{@"t_taskContent" : @" 悄悄的我走了，正如我悄悄的来；我挥一挥衣袖，不带走一片云彩。"}] },
                                           @{  @"id" : @"5",
                                               @"name" : @"I have a dream",
                                               @"task" : @[ @{@"t_taskContent" : @" 1 Five score years ago, a great American, in whose symbolic shadow we stand today, signed the Emancipation Proclamation. This momentous decree came as a great beacon light of hope to millions of Negro slaves who had been seared in the flames of withering injustice. It came as a joyous daybreak to end the long night of bad captivity."},
                                               @{@"t_taskContent" : @" 2 But one hundred years later, the Negro still is not free. One hundred years later, the life of the Negro is still sadly crippled by the manacles of segregation and the chains of discrimination. One hundred years later, the Negro lives on a lonely island of poverty in the midst of a vast ocean of material prosperity. One hundred years later, the Negro is still languished in the corners of American society and finds himself an exile in his own land. So we’ve come here today to dramatize a shameful condition."},
                                               @{@"t_taskContent" : @" 3 I am not unmindful that some of you have come here out of great trials and tribulations. Some of you have come fresh from narrow jail cells. Some of you have come from areas where your quest for freedom left you battered by the storms of persecution and staggered by the winds of police brutality. You have been the veterans of creative suffering. Continue to work with the faith that unearned suffering is redemptive."},
                                               @{@"t_taskContent" : @" 4 Go back to Mississippi, go back to Alabama, go back to South Carolina, go back to Georgia, go back to Louisiana, go back to the slums and ghettos of our northern cities, knowing that somehow this situation can and will be changed. Let us not wallow in the valley of despair."},
                                               @{@"t_taskContent" : @" 5 I say to you today, my friends, so even though we face the difficulties of today and tomorrow, I still have a dream. It is a dream deeply rooted in the American dream."},
                                               @{@"t_taskContent" : @" 6 I have a dream that one day on the red hills of Georgia the sons of former slaves and the sons of former slave-owners will be able to sit down together at the table of brotherhood."},
                                               @{@"t_taskContent" : @" 7 I have a dream that one day even the state of Mississippi, a state sweltering with the heat of injustice, sweltering with the heat of oppression, will be transformed into an oasis of freedom and justice."},
                                               @{@"t_taskContent" : @" 8 I have a dream that my four children will one day live in a nation where they will not be judged by the color if their skin but by the content of their character."},
                                               @{@"t_taskContent" : @" 9 I have a dream today."},
                                               @{@"t_taskContent" : @" 10 I have a dream that one day down in Alabama with its governor having his lips dripping with the words of interposition and nullification, one day right down in Alabama little black boys and black girls will be able to join hands with little white boys and white girls as sisters and brothers."},
                                               @{@"t_taskContent" : @" 11 I have a dream today."},
                                               @{@"t_taskContent" : @" 12 I have a dream that one day every valley shall be exalted, every hill and mountain shall be made low, the rough places will be made plain, and the crooked places will be made straight, and the glory of the Lord shall be revealed, and all flesh shall see it together."},
                                               @{@"t_taskContent" : @" 13 This is our hope. This is the faith that I go back to the South with. With this faith we will be able to hew out of the mountain of despair a stone of hope. With this faith we will be able to transform the jangling discords of our nation into a beautiful symphony of brotherhood. With this faith we will be able to work together, to pray together, to struggle together, to go to jail together, to stand up for freedom together, knowing that we will be free one day."}] } ],
                           @"_links" : @"",
                           @"_meta"  : @""};
            
    _model = [ProjectBoardModel mj_objectWithKeyValues:dict];
    _boardView.model = _model;
    [_boardView reloadData];
#pragma mark page control初始化
    SMPageControl *pageControl = [[SMPageControl alloc] init];
    pageControl.numberOfPages = _model.lists.count;
//        pageControl.backgroundColor = [UIColor redColor];
    [self.view addSubview:pageControl];
    [pageControl sizeToFit];
    //自适应后高度过高，手动调整
    pageControl.yyHeight = 20;
    CGFloat pageControlY;
    if (@available(iOS 11.0, *)) {
        pageControlY = ScreenHeight-NavAndStatusBarHeight-pageControl.yyHeight/2-SafeAreaInsetsBottom;
    } else {
        // Fallback on earlier versions
        pageControlY = ScreenHeight-NavAndStatusBarHeight-pageControl.yyHeight/2;
    }
    
    pageControl.center = CGPointMake(self.view.yyCenterX, pageControlY);
    _pageControl = pageControl;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _model.lists.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BoardViewList * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BoardViewList class]) forIndexPath:indexPath];
    cell.listModel = _model.lists[indexPath.row];
    cell.project_id = _project_id;
    cell.boardView = (BoardView *)collectionView;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

//用户慢慢拖拽时调用
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    if (fabs(scrollView.contentOffset.x -_offer) > (self.view.bounds.size.width-40)/2+10) {
//    if (scrollView.contentOffset.x == _offer) {
//           return;
//    }
    if ((scrollView.contentOffset.x-_offer) > (_layout.itemSize.width/2+10)||(_offer > scrollView.contentOffset.x && (_offer-scrollView.contentOffset.x)<(_layout.itemSize.width/2+10))){
        int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - 30)+1;
        if (i >= _model.lists.count) {
            return;
        }
        NSIndexPath * index =  [NSIndexPath indexPathForRow:i inSection:0];
        [_boardView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    else {
        int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - 30);
        //        if (i < 1) {
        //            return;
        //        }
        NSIndexPath * index =  [NSIndexPath indexPathForRow:i inSection:0];
        [_boardView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

//滑动减速时触发的代理，当用户用力滑动或者清扫时触发
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.x == _offer) {
//        return;
//    }
    if (scrollView.contentOffset.x-_offer > 15 || (_offer > scrollView.contentOffset.x && _offer-scrollView.contentOffset.x < 15)) {
        int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - 30)+1;
              if (i >= _model.lists.count) {
                  return;
              }
              NSIndexPath * index =  [NSIndexPath indexPathForRow:i inSection:0];
              [_boardView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    else {
         int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - 30);
        //        if (i < 1) {
        //            return;
        //        }
                NSIndexPath * index =  [NSIndexPath indexPathForRow:i inSection:0];
                [_boardView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

//系统动画停止是刷新当前偏移量_offer是我定义的全局变量
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    _offer = scrollView.contentOffset.x;
}


- (void)scrollToNextPage:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x > _offer) {
        int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - 30)+1;
        if (i >= _model.lists.count) {
            return;
        }
        NSIndexPath * index =  [NSIndexPath indexPathForRow:i inSection:0];
        [_boardView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }else{
        int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - 30);
//        if (i < 1) {
//            return;
//        }
        NSIndexPath * index =  [NSIndexPath indexPathForRow:i inSection:0];
        [_boardView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BoardViewListTableView *listTableView = (BoardViewListTableView *)tableView;
    //没有task的列更新高度
    if (listTableView.listModel.tasks.count == 0) {
        [tableView.superview updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(Global_ListHeaderHeight+Global_ListFooterHeight);
        }];
    }
    return listTableView.listModel.tasks.count;
}

#pragma mark cell点击后跳转
- (void)boardView:(BoardView *)boardView listTableView:(BoardViewListTableView *)listTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ListModel *listModel = listTableView.listModel;
//    WTaskDetailViewController *vc = [[WTaskDetailViewController alloc] init];
//    vc.task = model.tasks[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma page control当前页切换
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
     _pageControl.currentPage = scrollView.contentOffset.x / (ScreenWidth - 45.0f);
}

@end
