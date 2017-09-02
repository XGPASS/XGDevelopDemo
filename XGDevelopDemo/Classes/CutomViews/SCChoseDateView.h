//
//  SCChoseDateView.h
//  SmartCommunityForShushu
//
//  Created by sunyongguang on 2017/8/30.
//  Copyright © 2017年 All. All rights reserved.
//  选择时间的view

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SCDateType) {
    SCDateTypeNormal,       // 默认时间选择(月日时分)
    SCDateTypeModeDate      // 时间选择(只有年月日)
};


@interface SCChoseDateView : UIView

///  确认所选时间的回调
@property (nonatomic, copy) void(^choseDateBlock)(NSDate  *date);

/// 标题
@property (nonatomic, copy) NSString  *titile;
/// 上次所选时间
@property (nonatomic, strong) NSDate  *lastDate;
/// 显示的最小的时间
@property (nonatomic, strong) NSDate  *minimumDate;

/// 初始化
- (instancetype)initWithFrame:(CGRect)frame datePickerMode:(UIDatePickerMode)datePickerMode;

/**
 *  View显示
 */
- (void)showView;

@end
