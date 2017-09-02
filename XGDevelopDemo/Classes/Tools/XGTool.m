//
//  XGTool.m
//  XGDevelopDemo
//
//  Created by sunyongguang on 2017/9/2.
//  Copyright © 2017年 小广. All rights reserved.
//

#import "XGTool.h"

@implementation XGTool

// 拨打电话
+ (void)callPhone:(NSString *)phoneNum {
    
    if ([ISNULL(phoneNum) length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"拨打失败，手机号码不存在" duration:1.0 dismiss:nil];
        return;
    }
    
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phoneNum];
    
    /// 解决iOS10及其以上系统弹出拨号框延迟的问题
    /// 方案一
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        /// 10及其以上系统
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        /// 10以下系统
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
    
    /// 方案二
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
//    });
    
}

@end
