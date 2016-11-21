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

@end
