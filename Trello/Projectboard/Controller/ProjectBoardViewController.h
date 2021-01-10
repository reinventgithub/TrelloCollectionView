//
//  ProjectBoardViewController.h
//  SCTrelloNavigation
//
//  Created by Yh c on 15/11/5.
//  Copyright © 2015年 Yh c. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectBoardViewController : BaseViewController <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (copy, nonatomic) NSString *project_id;
@property (copy, nonatomic) NSString *project_name;
@end

