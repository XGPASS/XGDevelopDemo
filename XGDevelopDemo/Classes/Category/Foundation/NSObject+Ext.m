//
//  NSObject+Ext.m
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/30.
//  Copyright © 2016年 小广. All rights reserved.
//  NSObject类别扩展

#import "NSObject+Ext.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (Ext)

+ (NSString *)className {
    return NSStringFromClass(self);
}

- (NSString *)className {
    return [NSString stringWithUTF8String:class_getName([self class])];
}

@end
