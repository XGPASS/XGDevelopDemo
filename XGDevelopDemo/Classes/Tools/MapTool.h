//
//  MapTool.h
//  kingLei
//
//  Created by kingLei on 2018/5/21.
//  Copyright © 2018年 miwei. All rights reserved.
//  调用地图导航APP的工具类

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapTool : NSObject

/**
 调用三方导航

 @param coordinate 目的地经纬度
 @param name 目的地名字
 @param VC
 */
+ (void)navigationActionWithCoordinate:(CLLocationCoordinate2D)coordinate name:(NSString *)name viewController:(UIViewController *)vc;

@end
