//
//  XGNetBase.h
//  XGBaseDemo
//  网络相关的基类（与网络交互相关所要继承的基类）
//  Created by 绿漫小广 on 16/8/6.
//  Copyright © 2016年 绿漫小广. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XGNetRequest.h"

// 宏
#define kPageCount 20       // 分页条数

/**
 *  返回结果处理的宏定义
 */
#define kFetchResponseValues    NSString *msg = [self getMsg:response];\
                                NSInteger code = [self getStatusCode:response]; \
                                if (msg.length == 0) {msg = @"操作失败";} \
                                BOOL isSuccess = [self getSuccess:response]; \
                                id content = [self getContent:response];\
                                if (error.code == CancelRequestError) {\
                                    msg = [NSString stringWithFormat:@"%ld", (long)error.code];\
                                }\

/**
 *  结果处理后回调的通用写法
 */
#define kRequestCommon(action, parames, block) \
self.request = [XGNetRequest postWithAction:action\
                                  parameters:parames\
                                    complete:^(id response, NSURLSessionDataTask *task, NSError *error) {\
                                        if(block) {\
                                            kFetchResponseValues\
                                            block(msg, code, isSuccess, content);\
                                        }\
                                    }];

/**
 *  返回数据的block
 *
 *  @param msg       提示消息
 *  @param code      状态码
 *  @param isSuccess 是否成功
 *  @param response  返回实体类
 */
typedef void (^NetCompleteAndCodeBlock)(NSString *msg, NSInteger code, BOOL isSuccess , id response);
// 网络请求取消的状态码
static const NSInteger  CancelRequestError  = -999;

@interface XGNetBase : NSObject

// 请求类的实例
@property (nonatomic, strong) XGNetRequest *request;

// 获取错误消息
- (NSString *)getMsg:(id)response;

// 获取是否调用成功
- (BOOL)getSuccess:(id)response;

// 获取正文内容
- (id)getContent:(id)response;

// 获取状态码
- (NSInteger)getStatusCode:(id)response;


/**
 *  通用网络请求方法
 *  有code
 *  @param action 需要请求的指令
 *  @param dic    参数
 *  @param block  回调方法
 */
- (void)requestCommon:(NSString *)action
            parameter:(NSDictionary *)parames
      callbackAndCode:(NetCompleteAndCodeBlock)block;

/**
 *  取消当前网络请求
 */
- (void)cancel;

@end
