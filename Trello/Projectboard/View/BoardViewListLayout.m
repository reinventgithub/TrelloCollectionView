//
//  BoardViewListLayout.m
//  Trello
//
//  Created by xiao on 1/7/21.
//  Copyright © 2021 wxl. All rights reserved.
//

#import "BoardViewListLayout.h"
#import "BoardViewList.h"

@implementation BoardViewListLayout
- (instancetype)init {
    if (self = [super init]) {
//        self.itemSize = CGSizeMake(self.view.bounds.size.width - 60, self.view.bounds.size.height);
        self.sectionInset = UIEdgeInsetsMake(0, 30, 0, 30);
        self.minimumLineSpacing = 15;
        self.minimumInteritemSpacing = 0;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *array = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    for (UICollectionViewLayoutAttributes *attrs in array) {
//        NSInteger section = attrs.indexPath.section;
//        NSInteger item = attrs.indexPath.item;
//        NSInteger numberItems = section*2+item;
//            PowerLog(attrs);
        if (!attrs.representedElementKind) {
            BoardViewList *list = (BoardViewList *)[self.collectionView cellForItemAtIndexPath:attrs.indexPath];
            NSInteger collectionViewCellHeight = list.collectionViewCellHeight;
            if (collectionViewCellHeight) {
                attrs.frame = CGRectMake(attrs.frame.origin.x, 0, ScreenWidth - 60, collectionViewCellHeight);
            }
            //              attrs.size = CGSizeMake(ScreenWidth, 100);
        }
    }
    return array;
}
@end
