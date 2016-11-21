//
//  XGAddCell.m
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/31.
//  Copyright © 2016年 小广. All rights reserved.
//  显示额外小cell

#import "XGAddCell.h"

@interface XGAddCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonnull, copy) ButtonActionBlock block;

@end

@implementation XGAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)buttonClick:(UIButton *)sender {
    if (self.block) {
        self.block(sender, 0);
    }
}

- (void)refreshCellWithItem:(XGAddCellModel *)model block:(ButtonActionBlock)block {
    self.block = block;
    self.titleLabel.text = ISNIL(model.title);
}

@end
