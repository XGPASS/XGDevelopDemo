//
//  SCDatePicerViewController.h
//  SmartCommunity
//
//  Created by LHP on 15/2/6.
//  Copyright (c) 2015年 UAMA Inc. All rights reserved.
//  年月日控件弹出框

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ButtonType) {
    ButtonTypeCancel,
    ButtonTypeOK
};

typedef void(^ChoseDateBlock)(ButtonType btnType, NSDate *date);

@interface XGDatePicerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datepicerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSDate *minimumDate;
@property (strong, nonatomic) NSDate *maximumDate;
@property (strong, nonatomic) NSDate *curDate;
@property (assign, nonatomic) UIDatePickerMode datePickerMode;

- (void)choseDateFinishBlock:(ChoseDateBlock)block;

@end


