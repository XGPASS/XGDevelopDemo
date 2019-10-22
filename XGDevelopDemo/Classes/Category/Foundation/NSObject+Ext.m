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

/**
 方法替换
 
 @param class 类
 @param origSel 原始方法
 @param swizSel 自定义方法
 */
+ (void)swizzleMethods:(Class)class originalSelector:(SEL)origSel swizzledSelector:(SEL)swizSel {
    
    if (!class) return;
    if (!origSel) return;
    if (!swizSel) return;
    
    Method origMethod = class_getInstanceMethod(class, origSel);
    Method swizMethod = class_getInstanceMethod(class, swizSel);
    
    //class_addMethod will fail if original method already exists
    
    BOOL didAddMethod = class_addMethod(class,
                                        origSel,
                                        method_getImplementation(swizMethod),
                                        method_getTypeEncoding(swizMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizSel,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    } else {
        //origMethod and swizMethod already exist
        method_exchangeImplementations(origMethod, swizMethod);
    }
}

@end
