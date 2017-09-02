//
//  SVProgressHUD+Duration.m
//
//  Created by sunyongguang on 2017/8/30.
//  Copyright © 2017年 All. All rights reserved.
//

#import "SVProgressHUD+Duration.h"

@implementation SVProgressHUD (Duration)

+ (void)showSuccessWithStatus:(NSString*)status
                     duration:(NSTimeInterval)duration
                      dismiss:(DismissBlock)dismiss {
    [SVProgressHUD showSuccessWithStatus:status];
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [SVProgressHUD dismiss];
        !dismiss?:dismiss();
    });
}

+ (void)showErrorWithStatus:(NSString*)status
                   duration:(NSTimeInterval)duration
                    dismiss:(DismissBlock)dismiss {
    [SVProgressHUD showErrorWithStatus:status];
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [SVProgressHUD dismiss];
        !dismiss?:dismiss();
    });
}

+ (void)showWithStatus:(NSString *)status
              duration:(NSTimeInterval)duration
               dismiss:(DismissBlock)dismiss {
    [SVProgressHUD showWithStatus:status];
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [SVProgressHUD dismiss];
        !dismiss?:dismiss();
    });
}

+ (void)showInfoWithStatus:(NSString *)status
                  duration:(NSTimeInterval)duration
                   dismiss:(DismissBlock)dismiss {
    [SVProgressHUD showInfoWithStatus:status];
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [SVProgressHUD dismiss];
        !dismiss?:dismiss();
    });
}

@end
