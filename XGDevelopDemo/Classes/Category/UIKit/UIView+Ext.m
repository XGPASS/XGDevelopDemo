//
//  UIView+Ext.m
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/30.
//  Copyright © 2016年 小广. All rights reserved.
//  UIView类别扩展

#import "UIView+Ext.h"

@implementation UIView (Ext)

+ (UINib *)loadNib {
    return [self loadNibNamed:NSStringFromClass([self class])];
}


+ (UINib *)loadNibNamed:(NSString *)nibName {
    return [self loadNibNamed:nibName bundle:[NSBundle mainBundle]];
}


+ (UINib *)loadNibNamed:(NSString *)nibName bundle:(NSBundle *)bundle {
    return [UINib nibWithNibName:nibName bundle:bundle];
}

@end
