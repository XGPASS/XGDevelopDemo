//
//  NSString+Ext.m
//  XGDevelopDemo
//
//  Created by 小广 on 2016/11/21.
//  Copyright © 2016年 小广. All rights reserved.
//  NSString的类别

#import "NSString+Ext.h"

@implementation NSString (Ext)

- (NSString *)trim {
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSString *)trimAnySpace {
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    
    return [[self stringByTrimmingCharactersInSet:set] stringByReplacingOccurrencesOfString:@" " withString:@""];
}



@end
