//
//  SCSharePlatformMenu.h
//  XGDevelopDemo
//
//  Created by 小广 on 2017/6/10.
//  Copyright © 2017年 小广. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 分享渠道
typedef NS_ENUM(NSInteger, SCShareWay) {
    SCShareWayAll = 0, // 分享 qq、微信、短信
    SCShareWayNoSMS, // 分享 qq 微信
};

@interface SCSharePlatformMenu : UIView

@property (nonatomic, copy) void(^selectPlatformType)(NSInteger platformType);

- (instancetype)initWithShareWay:(SCShareWay)shareWay;

- (void)presentMenu:(BOOL)animate;

@end
