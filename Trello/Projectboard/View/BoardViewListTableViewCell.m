//
//  BoardViewListTableViewCell.m
//  
//
//  Created by wxl on 16/3/23.
//  Copyright © 2016年 jensen. All rights reserved.
//

#import "BoardViewListTableViewCell.h"

@implementation BoardViewListTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(10.0f, 5.0f, self.yyWidth - 20.0f, self.yyWidth - 5.0f)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 5.0f;
    [self.contentView addSubview:_bgView];
    [self.bgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(0);
        make.right.equalTo(-10);
        make.bottom.equalTo(-5); 
    }];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _contentLabel.textColor = [UIColor blackColor];
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(5);
        make.right.equalTo(-15);
        make.bottom.equalTo(-10);
    }];
}

- (void)setTaskModel:(TaskModel *)taskModel {
    _taskModel = taskModel;
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.text = taskModel.t_taskContent;
    if (self.isCellHidden) {
        self.hidden = YES;
    }
    else {
        self.hidden = NO;
    }
}

@end
