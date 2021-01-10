//
//  TrelloViewController.m
//  Trello
//
//  Created by wxl on 16/1/14.
//  Copyright © 2016年 wxl. All rights reserved.
//

#import "TrelloViewController.h"
#import <MJExtension/MJExtension.h>
#import "ProjectBoardViewController.h"

@interface TrelloViewController () <UICollectionViewDelegate>

@end

@implementation TrelloViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = Global_trelloDeepBlue;
    
////    TrelloCollectionViewFlowLayout *flowLayout = [[TrelloCollectionViewFlowLayout alloc] init];
////    int marginW = 20;
////    int marginH = 20;
////    CGFloat cellW = ScreenWidth - marginW*4;
////    CGFloat cellH = ScreenHeight - Top - marginH*2;
////    flowLayout.minimumInteritemSpacing = marginW;
////    flowLayout.minimumLineSpacing = marginH;
////    flowLayout.itemSize = CGSizeMake(cellW, cellH);
////    flowLayout.sectionInset = UIEdgeInsetsMake(0, marginW*2, 0, marginW*2);
////    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    CustomCardCollectionViewFlowLayout *customCardFlowLayout = [[CustomCardCollectionViewFlowLayout alloc] init];
//    int marginW = 20;
//    int marginH = 20;
//    CGFloat cellW = ScreenWidth - marginW*4;
//    CGFloat cellH = ScreenHeight - Top - marginH*2;
//    customCardFlowLayout.internalItemSpacing = 20;
//    customCardFlowLayout.itemSize = CGSizeMake(cellW, cellH);
//
//    TrelloCollectionView *collectionView = [[TrelloCollectionView alloc] initWithFrame:CGRectMake(0, Top, ScreenWidth, ScreenHeight-Top) collectionViewLayout:customCardFlowLayout];
//    collectionView.backgroundColor = Global_trelloDeepBlue;
//    collectionView.decelerationRate = 1;
////    collectionView.pagingEnabled = YES;
////    collectionView.layer.masksToBounds = NO;
////    collectionView.clipsToBounds = NO;
//    [self.view addSubview:collectionView];
//    _collectionView = collectionView;
    
    
//    TrelloCollectionView *collectionView = [[TrelloCollectionView alloc] initWithFrame:CGRectMake(marginW*2, Top, ScreenWidth-marginW*3, ScreenHeight-Top) collectionViewLayout:flowLayout];
//    collectionView.backgroundColor = Global_trelloDeepBlue;
//    collectionView.pagingEnabled = YES;
//    //    collectionView.layer.masksToBounds = NO;
//        collectionView.clipsToBounds = NO;
//    [self.view addSubview:collectionView];
//    _collectionView = collectionView;
    ProjectBoardViewController *pbVC = [[ProjectBoardViewController alloc] init];
    [self.navigationController pushViewController:pbVC animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
