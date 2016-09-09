//
//  UIView+Ext.h
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/30.
//  Copyright © 2016年 小广. All rights reserved.
//  UIView类别扩展

#import <UIKit/UIKit.h>

@interface UIView (Ext)

/**
 *  获取当前 View 的 Nib
 *
 *  @return Nib
 */
+ (UINib *)loadNib;

/**
 *  根据 NibName 获取对应的 Nib
 *
 *  @param nibName
 *
 *  @return Nib
 */
+ (UINib *)loadNibNamed:(NSString*)nibName;

/**
 *  根据 NibName bundle 获取对应的 Nib
 *
 *  @param nibName
 *  @param bundle
 *
 *  @return Nib
 */
+ (UINib *)loadNibNamed:(NSString*)nibName bundle:(NSBundle *)bundle;

@end
