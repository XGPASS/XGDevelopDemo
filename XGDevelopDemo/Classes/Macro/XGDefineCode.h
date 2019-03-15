//
//  XGDefineCode.h
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/31.
//  Copyright © 2016年 小广. All rights reserved.
//  常用的代码块

#ifndef XGDefineCode_h
#define XGDefineCode_h
// 按钮点击的回调
typedef void(^ButtonActionBlock)(UIButton *btn, NSInteger tag);


#define IPHONEX           isIPhoneX()

static inline BOOL isIPhoneX() {
    
    BOOL iPhoneX = NO;
    /// 先判断设备是否是iPhone/iPod
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneX;
    }
    
    if (@available(iOS 11.0, *)) {
        /// 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X。
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
        }
    }
    
    return iPhoneX;
}


#endif /* XGDefineCode_h */
