//
//  XGChoseDateView.m
//  XGDevelopDemo
//
//  Created by 小广 on 15/8/18.
//  Copyright © 2015年 小广. All rights reserved.
//  选择日期的view

#import "XGChoseDateView.h"

#define XGButtonWidth         60.0
#define TopBarHeight          44.0
#define PickerHeight          216.0

@interface XGChoseDateView ()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView       *bgView;        // 按钮背景View
@property (nonatomic, strong) UIButton     *cancelButton;  // 取消按钮
@property (nonatomic, strong) UIButton     *confirmButton; // 确定按钮
@property (nonatomic, strong) NSDate       *currentDate;   // 当前显示时间
@property (nonatomic, strong) NSDate       *lastDate;      // 上次选择时间
@property (nonatomic, assign) UIDatePickerMode datePickerMode; // datePicker显示形式
@property (nonatomic, copy) ConfirmDateBlock block;

@end

@implementation XGChoseDateView

#pragma mark - 对外方法
- (instancetype)initWithFrame:(CGRect)frame
               datePickerMode:(UIDatePickerMode)datePickerMode
                     lastDate:(NSDate *)lastDate {
    self = [super initWithFrame:frame];
    if (self) {
        _datePickerMode = datePickerMode;
        _lastDate = lastDate;
        [self initSubViews];
    }
    return self;
}

// 显示view(此方法是加载在window上 ,遮住导航条)
- (void)showView {
    UIWindow * window = [UIApplication sharedApplication].windows[0];
    [window addSubview:self];
}

// 传值到外面
- (void)confirmDate:(ConfirmDateBlock)block {
    self.block = block;
}

#pragma mark - 自定义方法
- (void)initSubViews {
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0;
    [self addCoverView];
    [self addBGView];
    self.datePicker.datePickerMode = self.datePickerMode;
    self.datePicker.date = self.lastDate ? self.lastDate : [NSDate date];
    self.currentDate = self.datePicker.date;
}

// 添加蒙板
- (void)addCoverView {
    UIView *coverView = [[UIView alloc] initWithFrame:self.frame];
    coverView.alpha = 0.3;
    coverView.backgroundColor = [UIColor blackColor];
    [self addSubview:coverView];
    
    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewDidTouch:)];
    tapGesture.numberOfTapsRequired = 1;
    [coverView addGestureRecognizer:tapGesture];
}

// 大view添加子view(为了做动画)
- (void)addBGView {
    [self addSubview:self.bgView];
    [self addButtons];
    [self.bgView addSubview:self.datePicker];
    [self.datePicker addTarget:self action:@selector(datePickerValueChange:) forControlEvents:UIControlEventValueChanged];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
        CGFloat posY = XGScreenHeight - (PickerHeight + TopBarHeight);
        self.bgView.frame = CGRectMake(0.0, posY, XGScreenWidth, (PickerHeight + TopBarHeight));
    } completion:^(BOOL finished) {
        //
    }];
}

// 添加按钮
- (void)addButtons {
    
    CGFloat posY = 0.0;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, posY, XGScreenWidth, TopBarHeight)];
    view.backgroundColor = UIColorFrom16RGB(0x334455);
    [self.bgView addSubview:view];
    
    // 取消按钮
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(0.0, posY, XGButtonWidth, TopBarHeight);
    self.cancelButton.tag = 0;
    [self.cancelButton setBackgroundColor:[UIColor clearColor]];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.cancelButton];
    
    // 确定按钮
    CGFloat posX = XGScreenWidth - XGButtonWidth;
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.frame = CGRectMake(posX, posY, XGButtonWidth, TopBarHeight);
    self.confirmButton.tag = 1;
    [self.confirmButton setBackgroundColor:[UIColor clearColor]];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.confirmButton];
    
}

// 按钮点击事件
- (void)buttonClick:(UIButton *)sender {
    if (sender.tag == 1) {
        if (!self.currentDate) {
            self.currentDate = [NSDate date];
        }
        if (self.block) {
            self.block(self.currentDate);
        }
    }
    
    [self dismissContactView];
}

// 蒙板手势事件
- (void)coverViewDidTouch:(UITapGestureRecognizer *)sender {
    if (!self.currentDate) {
        self.currentDate = [NSDate date];
    }
    if (self.block) {
        self.block(self.currentDate);
    }
    [self dismissContactView];
}


// 移除view
- (void)dismissContactView {
    kWeakSelf
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.bgView.frame = CGRectMake(0.0, XGScreenHeight, XGScreenWidth, 0.0);
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - 懒加载
// PickerView和按钮的父视图view(为了做动画)
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0, XGScreenHeight, XGScreenWidth, (PickerHeight + TopBarHeight))];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, TopBarHeight, XGScreenWidth, 216.0)];
        _datePicker.backgroundColor = [UIColor whiteColor];
    }
    return _datePicker;
}

#pragma mark - 代理方法
// UIDatePicker绑定方法
- (void)datePickerValueChange:(UIDatePicker *)sender {
    
    self.currentDate = sender.date;
}

@end
