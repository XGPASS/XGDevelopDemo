//
//  SCVisitorInputAccessoryView.h
//  SuperCommunity
//
//  Created by sunyongguang on 2017/11/7.
//  Copyright © 2017年 uama. All rights reserved.
//  访客通行录入页面--访客姓名输入历史的InputAccessory

#import <UIKit/UIKit.h>

static const CGFloat SCInputAccessoryViewHeight = 55.0f;

@interface SCInputAccessoryView : UIView

/// 选中的row
@property (nonatomic, copy) void(^selectRowBlock)(NSInteger index, NSString *title);

+ (instancetype)loadNibView;

/// array数组里面放的元素 必须字符串类型的
- (void)refreshUIWithNameArray:(NSArray<NSString *> *)array;

@end
