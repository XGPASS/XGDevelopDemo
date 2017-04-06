//
//  UIControl+Delay.h
//  XGDevelopDemo
//
//  Created by 小广 on 2017/4/6.
//  Copyright © 2017年 小广. All rights reserved.
//  按钮之类的防止重复点击

#import <UIKit/UIKit.h>

@interface UIControl (Delay)

/// 可以用这个给重复点击加时间间隔
@property (nonatomic, assign) NSTimeInterval acceptEventInterval;

@end
