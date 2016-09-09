//
//  XGNetRequest.h
//  XGBaseDemo
//  请求相关的管理类
//  Created by 绿漫小广 on 16/8/6.
//  Copyright © 2016年 绿漫小广. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTokenError @"TokenError"       // token异常
typedef void (^XGCompleteBlock)(id response, NSURLSessionDataTask *task, NSError *error);

@interface XGNetRequest : NSObject

/*
 * 请求方法
 * @param action        指令
 * @param parameters    参数
 * @param block         回调block
 */
+ (XGNetRequest *)postWithAction:(NSString *)action
                      parameters:(id)parameters
                        complete:(XGCompleteBlock)block;


/*
 * 请求方法
 * @param action        指令
 * @param parameters    参数
 * @param block         回调block
 */
+ (XGNetRequest *)getWithAction:(NSString *)action
                     parameters:(id)parameters
                       complete:(XGCompleteBlock)block;

/*
 * 取消
 */
- (void)cancel;

@end
