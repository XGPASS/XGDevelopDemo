//
//  NSObject+Ext.h
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/30.
//  Copyright © 2016年 小广. All rights reserved.
//  NSObject类别扩展

#import <Foundation/Foundation.h>

@interface NSObject (Ext)

/**
 Returns the class name in NSString.
 */
+ (NSString *)className;


/**
 方法替换

 @param class 类
 @param origSel 原始方法
 @param swizSel 自定义方法
 */
+ (void)swizzleMethods:(Class)class originalSelector:(SEL)origSel swizzledSelector:(SEL)swizSel;

@end
