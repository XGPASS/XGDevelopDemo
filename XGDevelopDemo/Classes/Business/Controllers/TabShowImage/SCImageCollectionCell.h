//
//  SCImageCollectionCell.h
//  Butler
//
//  Created by 小广 on 2017/3/1.
//  Copyright © 2017年 UAMA Inc. All rights reserved.
//  添加图片页面的网格的cell

#import <UIKit/UIKit.h>

@interface SCImageCollectionCell : UICollectionViewCell

/// 要么是UIImage类型，要么是string类型
- (void)refreshCellWithImage:(id)image;

@end
