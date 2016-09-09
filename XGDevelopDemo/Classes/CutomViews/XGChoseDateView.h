//
//  XGChoseDateView.h
//  XGDevelopDemo
//
//  Created by 小广 on 15/8/18.
//  Copyright © 2015年 小广. All rights reserved.
//  选择日期的view

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DateType) {
    DateTypeNormal,       // 默认时间选择(月日时分)
    DateTypeModeDate      // 时间选择(只有年月日)
};

typedef void (^ConfirmDateBlock)(NSDate  *date);

@interface XGChoseDateView : UIView

- (instancetype)initWithFrame:(CGRect)frame
               datePickerMode:(UIDatePickerMode)datePickerMode
                     lastDate:(NSDate *)lastDate;

/**
 *  View显示
 */
- (void)showView;

/**
 *  确认所选时间
 *
 *  @param block 传出Date
 */
- (void)confirmDate:(ConfirmDateBlock)block;

@end
