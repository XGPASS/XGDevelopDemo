//
//  MapTool.m
//  kingLei
//
//  Created by kingLei on 2018/5/21.
//  Copyright © 2018年 miwei. All rights reserved.
//  调用地图导航APP的工具类

#import "MapTool.h"

@implementation MapTool

/**
 调用三方导航
 
 @param coordinate 目的地经纬度
 @param name 目的地名字
 @param VC
 */
+ (void)navigationActionWithCoordinate:(CLLocationCoordinate2D)coordinate name:(NSString *)name viewController:(UIViewController *)vc {

  weakify(self)
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"开始导航" preferredStyle:UIAlertControllerStyleActionSheet];
  
  [alert addAction:[UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    strongify(self)
    [self navigationForAppleMapWithCoordinate:coordinate name:name];
    
  }]];
  // 判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
  if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
    [alert addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      strongify(self)
      [self navigationForAMapWithCoordinate:coordinate name:name];
    }]];
  }
  // 判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
  if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
    [alert addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        strongify(self)
      [self navigationForBaiduMapWithCoordinate:coordinate name:name];
      
    }]];
  }
  // 添加取消选项
  [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
  }]];
  
    if (!vc) {
        vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
    }
  
    weakify(vc);
    dispatch_async(dispatch_get_main_queue(), ^{
        strongify(vc);
        /// 在iOS 11.3.1 iPhone 6Plus上，会延迟弹出，放在主线程，无此问题；
        [vc presentViewController:alert animated:YES completion:nil];
    });
  
}

/// 唤醒苹果自带导航
+ (void)navigationForAppleMapWithCoordinate:(CLLocationCoordinate2D)coordinate name:(NSString *)name {
  
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *tolocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
    tolocation.name = name;
    [MKMapItem openMapsWithItems:@[currentLocation,tolocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
}


/// 高德导航
+ (void)navigationForAMapWithCoordinate:(CLLocationCoordinate2D)coordinate name:(NSString *)name {
    // 地址:http://lbs.amap.com/api/amap-mobile/guide/ios/route
    /*
     * sourceApplication 第三方调用应用名称。如applicationName
     * sid 起点ID
     * slat 起点纬度，经纬度参数同时存在或同时为空，视为有效参数
     * slon 起点经度，经纬度参数同时存在或同时为空，视为有效参数
     * sname 起点名称（可为空）
     * did 目的ID
     * dlat 终点纬度，经纬度参数同时存在或同时为空，视为有效参数
     * dlon 终点经度，经纬度参数同时存在或同时为空，视为有效参数
     * dname 终点名称（可为空）
     * dev 起终点是否偏移。0:lat和lon是已经加密后的,不需要国测加密;1:需要国测加密，可为空，但起点或终点不为空时，不能为空
     * t t = 0 驾车； t = 1 公交； t = 2 步行； t = 3 骑行（骑行仅在V788以上版本支持）；
     
     备注：
     1.  起点经纬度参数不为空，则路线以此坐标发起路线规划 。
     2.  起点经纬度参数为空，且起点名称不为空，则以此名称发起路线规划。
     3.  起点经纬度参数为空，且起点名称为空，则以“我的位置”发起路线规划。
     4.  终点经纬度参数不为空，则路线以此坐标发起路线规划 。
     5.  终点经纬度参数为空，且终点名称不为空，则以此名称发起路线规划。
     6.  终点经纬度参数为空，且终点点名称为空，则以“我的位置”发起路线规划
     
     栗子：
     iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=39.92848272&slon=116.39560823&sname=A&did=BGVIS2&dlat=39.98848272&dlon=116.47560823&dname=B&dev=0&t=0
     */
    
    NSString *str = name;
    NSString *urlSting =[[NSString stringWithFormat:@"iosamap://path?sourceApplication=测试应用&sid=BGVIS1&slat=&slon=&sname=&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&t=0",coordinate.latitude,coordinate.longitude,str] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self openURL:urlSting];
}

/// 百度地图导航
+ (void)navigationForBaiduMapWithCoordinate:(CLLocationCoordinate2D)coordinate name:(NSString *)name {
    
    ///  地址：http://lbsyun.baidu.com/index.php?title=uri/api/ios
    /*
     * origin (必选)起点名称戒经纬度，戒者可同时提供 名称和经纬度，此时经纬度优先级高， 将作为导航依据，名称只负责展示。 名 称 和 经 纬 度 : name: 天 安 门 |latlng:39.98871,116.43234;
     * destination (必选)终点名称戒经纬度，戒者可同时提供 名称和经纬度，此时经纬度优先级高， 将作为导航依据，名称只负责展示。
     * mode (必选)导航模式，固定为 transit、driving、 walking，分别表示公交、驾车和步行;
     * region 城市名戒县名  当给定region时，认为起点和终点都在同一城市，除非单独给定起点戒终点的城市;
     * origin_region 起点所在城市戒县;
     * destination_region 终点所在城市戒县;
     * output 表示输出类型，web 上必须指定为 html 才能展现地图产品结果。 手机客户端忽略此参数
     * coord_type 坐标类型，可选参数。  默认为 bd09 经纬度坐标。允许的值为 bd09ll、bd09mc、gcj02、wgs84。bd09ll 表示百度经纬度坐标，bd09mc 表示百度墨卡托坐标，gcj02 表示经过国测局加密的坐 标，wgs84 表示 gps 获取的坐标
     * zoom (可选)展现地图的级别，默认为视觉最优级别。
     * src  (必选)调用来源，规则: companyName|appName。
     
     栗子：
     http://api.map.baidu.com/direction?origin=latlng:34.264642646862,108.95108518068|name:我家&destinatio n=大雁塔&mode=driving&region=西安&output=html&src=yourCompanyName|yourAppName
     // 调起百度 PC 戒 Web 地图，展示“西安市”从(lat:34.264642646862,lng:108.95108518068 )“我家”到“大雁 塔”的驾车路线。
     */
    
    NSString *urlSting =[[NSString stringWithFormat:@"baidumap://map/direction?origin=name:我的位置&destination=latlng:%f,%f|name:%@&mode=driving&src=快健康快递",coordinate.latitude,coordinate.longitude,name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self openURL:urlSting];
}

/// openURL 处理
+ (void)openURL:(NSString *)urlSting {
    if (urlSting.length == 0) {
        return;
    }
    
    if (@available(iOS 10.0, *)) {
        /// 10及其以上系统
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlSting] options:@{} completionHandler:nil];
    } else {
        /// 10以下系统
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlSting]];
    }
}


@end
