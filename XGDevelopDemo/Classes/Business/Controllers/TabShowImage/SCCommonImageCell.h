//
//  SCCommonImageCell.h
//  Butler
//
//  Created by sunyongguang on 2017/9/14.
//  Copyright © 2017年 UAMA Inc. All rights reserved.
//  通用的显示图片的cell（内部使用了UICollectionView）

#import <UIKit/UIKit.h>

@interface SCCommonImageCell : UITableViewCell

/// 图片点击事件
@property (nonatomic, copy) void(^imageTouchBlock)(NSInteger index);

/// array数组里面放的元素 要么是UIImage类型，要么是string类型, 高度别忘了有title的高度
- (void)refreshCellWithImageDatas:(NSArray *)array title:(NSString *)title;

/// cell 的高度
+ (CGFloat)cellHeightWithDatas:(NSArray *)array title:(NSString *)title ;

@end
