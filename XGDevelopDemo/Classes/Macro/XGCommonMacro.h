//
//  XGCommonMacro.h
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/30.
//  Copyright © 2016年 小广. All rights reserved.
//  通用的宏

#ifndef XGCommonMacro_h
#define XGCommonMacro_h

// 获取应用屏幕大小
// ios 版本判断
#define XGSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define XGAppFrame [[UIScreen mainScreen] applicationFrame]
#define XGScreenBounds [UIScreen mainScreen].bounds
#define XGScreenWidth XGScreenBounds.size.width
#define XGScreenHeight XGScreenBounds.size.height
#define XGViewHeight CGRectGetHeight(XGScreenBounds) - 44 - 20 // 去掉导航条的高度

// 根据16位进制值转换成颜色，格式:HEXCOLOR(0xFF0000)

#define HEXCOLOR(hexVal)  [UIColor colorWithRed:((float)((hexVal & 0xFF0000) >> 16))/255.0 green:((float)((hexVal & 0xFF00) >> 8))/255.0 blue:((float)(hexVal & 0xFF))/255.0 alpha:1.0]

// VC通用的背景颜色
#define BGColor   HEXCOLOR(0xECECF0)

//定义UIImage对象
#define IMAGENAMED(_pointer) [UIImage imageNamed:_pointer]

// 对于block的弱引用
#define kWeakSelf __weak __typeof(self)weakSelf = self;
#define kStrongSelf __strong __typeof(weakSelf)strongSelf = weakSelf;
#define kBlockSelf __block __typeof(self)blockSelf = self;

// 对字符串做特殊的宏，即保证返回的值不为空
#define ISNIL(x) ((x) == nil ? @"" : (x))
#define ISNILDefault(x, y) ((x) == nil ? y : (x))
#define ISNULL(x) ((x) == nil || [(x) isEqualToString:@"(null)"] ? @"" : (x))
#define ISNSNull(x) ([(x) isKindOfClass:[NSNull class]] ? nil : (x))

// 断言宏
#ifdef DEBUG
#define	DAssert(x) if(!(x)) {int a=1; int b=0;int c=a/b; c++;}
#else
#define	DAssert(x) if(!(x)) {}
#endif

#endif /* XGCommonMacro_h */
