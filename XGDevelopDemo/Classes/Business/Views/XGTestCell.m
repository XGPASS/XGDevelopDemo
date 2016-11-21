//
//  XGTestCell.m
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/30.
//  Copyright © 2016年 小广. All rights reserved.
//  test cell 

#import "XGTestCell.h"

@interface XGTestCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation XGTestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)refreshCellWithItem:(id)model {
    self.titleLabel.text = (NSString *)model;
    
}

@end
