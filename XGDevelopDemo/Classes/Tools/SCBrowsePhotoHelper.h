//
//  SCBrowsePhotoHelper.h
//  XGDevelopDemo
//
//  Created by sunyongguang on 2017/10/19.
//  Copyright © 2017年 小广. All rights reserved.
//  浏览大图Helper

#import <Foundation/Foundation.h>

@interface SCBrowsePhotoHelper : NSObject

/**
 浏览大图方法(调用的时候需申明成全局变量)
 
 @param photos 图片数组
 @param index 当前显示第几张
 @param controller 容器
 */
+ (instancetype)browseBigPhotos:(NSArray<NSString *> *)photos
                   currentIndex:(NSInteger)index
                     controller:(UIViewController *)controller;

@end
