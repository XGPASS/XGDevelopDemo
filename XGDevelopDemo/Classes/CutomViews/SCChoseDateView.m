//
//  SCChoseDateView.m
//  SmartCommunityForShushu
//
//  Created by sunyongguang on 2017/8/30.
//  Copyright © 2017年 All. All rights reserved.
//

#import "SCChoseDateView.h"

#define SCButtonWidth           44.0f
#define SCTopBarHeight          44.0f
#define SCPickerHeight          216.0f

@interface SCChoseDateView ()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView       *bgView;        // 按钮背景View
@property (nonatomic, strong) UIButton     *cancelButton;  // 取消按钮
@property (nonatomic, strong) UIButton     *confirmButton; // 确定按钮
/// 标题
@property (nonatomic, strong) UILabel      *titleLabel;
@property (nonatomic, strong) NSDate       *currentDate;   // 当前显示时间
@property (nonatomic, assign) UIDatePickerMode datePickerMode; // datePicker显示形式

@end


@implementation SCChoseDateView

#pragma mark - 对外方法
- (instancetype)initWithFrame:(CGRect)frame
               datePickerMode:(UIDatePickerMode)datePickerMode {
    self = [super initWithFrame:frame];
    if (self) {
        _datePickerMode = datePickerMode;
        [self initSubViews];
    }
    return self;
}

// 显示view(此方法是加载在window上 ,遮住导航条)
- (void)showView {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
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
        CGFloat posY = XGScreenHeight - (SCPickerHeight + SCTopBarHeight);
        self.bgView.frame = CGRectMake(0.0, posY, XGScreenWidth, (SCPickerHeight + SCTopBarHeight));
    } completion:^(BOOL finished) {
        //
    }];
}

// 添加按钮
- (void)addButtons {
    
    CGFloat posY = 0.0;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, posY, XGScreenWidth, SCTopBarHeight)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 0.5f;
    view.layer.borderColor = HEXCOLOR(0xD8D8E1).CGColor;
    [self.bgView addSubview:view];
    
    // 取消按钮
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(0.0, posY, SCButtonWidth, SCTopBarHeight);
    self.cancelButton.tag = 0;
    [self.cancelButton setBackgroundColor:[UIColor clearColor]];
    [self.cancelButton setImage:[UIImage imageNamed:@"ic_box_cancel"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.cancelButton];
    
    // 确定按钮
    CGFloat posX = XGScreenWidth - SCButtonWidth;
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.frame = CGRectMake(posX, posY, SCButtonWidth, SCTopBarHeight);
    self.confirmButton.tag = 1;
    [self.confirmButton setBackgroundColor:[UIColor clearColor]];
    [self.confirmButton setImage:[UIImage imageNamed:@"ic_box_ok"] forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.confirmButton];
    
    /// 标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelButton.frame), posY, (XGScreenWidth - SCButtonWidth * 2), SCTopBarHeight)];
    self.titleLabel.text = @"时间选择";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = HEXCOLOR(0x999999);
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.bgView addSubview:self.titleLabel];
}

// 按钮点击事件
- (void)buttonClick:(UIButton *)sender {
    if (sender.tag == 1) {
        if (!self.currentDate) {
            self.currentDate = [NSDate date];
        }
        if (self.choseDateBlock) {
            self.choseDateBlock(self.currentDate);
        }
    }
    
    [self dismissContactView];
}

// 蒙板手势事件
- (void)coverViewDidTouch:(UITapGestureRecognizer *)sender {
//    if (!self.currentDate) {
//        self.currentDate = [NSDate date];
//    }
//    if (self.choseDateBlock) {
//        self.choseDateBlock(self.currentDate);
//    }
    [self dismissContactView];
}


// 移除view
- (void)dismissContactView {
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.frame = CGRectMake(0.0, XGScreenHeight, XGScreenWidth, 0.0);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/// 重写set方法
- (void)setLastDate:(NSDate *)lastDate {
    _lastDate = lastDate;
    if (lastDate) {
        _datePicker.date = lastDate;
    }
}

- (void)setTitile:(NSString *)titile {
    _titile = titile;
    if (titile.length > 0) {
        _titleLabel.text = titile;
    }
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    if (minimumDate) {
        _datePicker.minimumDate = minimumDate;
    }
}

#pragma mark - 懒加载
// PickerView和按钮的父视图view(为了做动画)
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0, XGScreenHeight, XGScreenWidth, (SCPickerHeight + SCTopBarHeight))];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, SCTopBarHeight, XGScreenWidth, SCPickerHeight)];
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
