//
//  MWPhotoBrowser+Ext.m
//  XGDevelopDemo
//
//  Created by sunyongguang on 2017/10/21.
//  Copyright © 2017年 小广. All rights reserved.
//

#import "MWPhotoBrowser+Ext.h"
#import "MWPhotoBrowserPrivate.h"

@implementation MWPhotoBrowser (Ext)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethods:[self class] originalSelector:@selector(toggleControls) swizzledSelector:@selector(_toggleControls)];
    });
}

- (void)_toggleControls {
    [self dismissViewControllerAnimated:YES completion:^{ }];
}




@end
