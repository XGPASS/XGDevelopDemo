//
//  SCVisitorInputAccessoryCell.m
//  SuperCommunity
//
//  Created by sunyongguang on 2017/11/7.
//  Copyright © 2017年 uama. All rights reserved.
//  访客通行录入页面--访客姓名输入历史的cell

#import "SCInputAccessoryCell.h"


@interface SCInputAccessoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation SCInputAccessoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = HEXCOLOR(0xF2F2F2);
    self.contentView.layer.cornerRadius = 17.5f;
    self.contentView.clipsToBounds = YES;
    self.titleLabel.textColor = HEXCOLOR(0x333333);
}

/// 填充cell
- (void)refreshCellWithTitle:(NSString *)title {
    self.titleLabel.text = ISNULL(title);
}


@end
