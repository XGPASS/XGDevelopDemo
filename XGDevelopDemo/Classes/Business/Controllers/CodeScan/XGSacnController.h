//
//  XGSacnController.h
//  XGDevelopDemo
//
//  Created by 小广 on 2016/11/29.
//  Copyright © 2016年 小广. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XGScanResultBlock)(NSString *result);

@interface XGSacnController : UIViewController

// 扫描结果的block
- (void)scanCompleteBlock:(XGScanResultBlock)block;

@end
