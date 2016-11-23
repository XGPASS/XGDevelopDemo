//
//  NSString+Ext.h
//  XGDevelopDemo
//
//  Created by 小广 on 2016/11/21.
//  Copyright © 2016年 小广. All rights reserved.
//  NSString的类别

#import <Foundation/Foundation.h>

@interface NSString (Ext)

/**
 去除字符串首尾两端的空格
 */
- (NSString *)trim;

/**
 去除字符串所有的空格
 */
- (NSString *)trimAnySpace;


#pragma mark - 用于货币的高精度数字的加减乘除

/// 加
- (NSString *)calculateByAdding:(NSString *)stringNumer;

/// 减
- (NSString *)calculateBySubtracting:(NSString *)stringNumer;

/// 乘
- (NSString *)calculateByMultiplying:(NSString *)stringNumer;

/// 除
- (NSString *)calculateByDividing:(NSString *)stringNumer;

/// 幂运算
- (NSString *)calculateByRaising:(NSUInteger)power;

/// 四舍五入
- (NSString *)calculateByRounding:(NSUInteger)scale;

/// 是否相等
- (BOOL)calculateIsEqual:(NSString *)stringNumer;

/// 是否大于
- (BOOL)calculateIsGreaterThan:(NSString *)stringNumer;

/// 是否小于
- (BOOL)calculateIsLessThan:(NSString *)stringNumer;

/// 转成小数
- (double)calculateDoubleValue;

@end
