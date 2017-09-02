//
//  SVProgressHUD+Duration.h
//
//  Created by sunyongguang on 2017/8/30.
//  Copyright © 2017年 All. All rights reserved.
//

#import "SVProgressHUD.h"

typedef void(^DismissBlock)(void);

@interface SVProgressHUD (Duration)

+ (void)showSuccessWithStatus:(NSString*)status
                     duration:(NSTimeInterval)duration
                      dismiss:(DismissBlock)dismiss;

+ (void)showErrorWithStatus:(NSString*)status
                   duration:(NSTimeInterval)duration
                    dismiss:(DismissBlock)dismiss;

+ (void)showWithStatus:(NSString *)status
              duration:(NSTimeInterval)duration
               dismiss:(DismissBlock)dismiss;

+ (void)showInfoWithStatus:(NSString *)status
                  duration:(NSTimeInterval)duration
                   dismiss:(DismissBlock)dismiss;

@end
