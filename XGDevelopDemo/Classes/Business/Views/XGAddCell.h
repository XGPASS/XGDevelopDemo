//
//  XGAddCell.h
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/31.
//  Copyright © 2016年 小广. All rights reserved.
//  显示额外小cell

#import <UIKit/UIKit.h>
#import "XGAddCellModel.h"

@interface XGAddCell : UITableViewCell

- (void)refreshCellWithItem:(XGAddCellModel *)model block:(ButtonActionBlock)block;

@end
