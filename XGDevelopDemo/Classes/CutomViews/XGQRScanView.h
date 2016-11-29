//
//  XGQRScanView.h
//  XGDevelopDemo
//
//  Created by 小广 on 2016/11/29.
//  Copyright © 2016年 小广. All rights reserved.
//  二维码扫描区域的view

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XGSanSourceType) {
    XGSanSourceTypeUnknown = 0,
    XGSanSourceTypeQR = 1,//二维码扫描
    XGSanSourceTypeBar//条形码扫描
};

@interface XGQRScanView : UIView

/// 透明的扫描区域
@property (nonatomic, assign) CGSize transparentArea;
/// 扫描类型
@property (nonatomic, assign) XGSanSourceType scanType;
/// 扫描框下面的提示语句
@property (nonatomic, copy) NSString  *noteString;

@end
