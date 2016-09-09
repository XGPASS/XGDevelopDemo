//
//  XGNetBase.m
//  XGBaseDemo
//  网络相关的基类（与网络交互相关所要继承的基类）
//  Created by 绿漫小广 on 16/8/6.
//  Copyright © 2016年 绿漫小广. All rights reserved.
//

#import "XGNetBase.h"

#define kMessage @"message"           // 提示信息
#define kStatusCode @"statusCode"     // 状态码
#define kContent @"result"            // 返回内容

@interface XGNetBase ()

@end

@implementation XGNetBase


// 获取错误消息
- (NSString *)getMsg:(id)response {
    
    NSString *msg = @"";
    if (!response) {
        msg = @"获取数据失败";
    }
    // 从返回结果里获取提示信息
    if ([response isKindOfClass:[NSDictionary class]]) {
        msg = [response objectForKey:kMessage];
        if ([msg isKindOfClass:[NSNull class]]) {
            msg = @"";
        }
    }
    
    return msg;
}

// 获取是否调用成功
- (BOOL)getSuccess:(id)response {
    
    NSInteger code = [self getStatusCode:response];
    BOOL isSuccess = (code == 0);
    return isSuccess;
}

// 获取正文内容
- (id)getContent:(id)response {
    
    id content = nil;
    
    if (response && [response isKindOfClass:[NSDictionary class]]) {
        content = [response objectForKey:kContent];
    }
    
    return content;
}

// 获取状态码
- (NSInteger)getStatusCode:(id)response {
    NSInteger statusCode = -1;
    if (response && [response isKindOfClass:[NSDictionary class]]) {
        NSNumber *code = [response objectForKey:kStatusCode];
        statusCode = code.integerValue;
    }
    
    return statusCode;
}


/**
 *  通用网络请求方法
 *  有code
 *  @param action 需要请求的指令
 *  @param dic    参数
 *  @param block  回调方法
 */
- (void)requestCommon:(NSString *)action
            parameter:(NSDictionary *)parames
      callbackAndCode:(NetCompleteAndCodeBlock)block {
    
    kRequestCommon(action, parames, block)
}

/**
 *  取消当前网络请求
 */
- (void)cancel {
    [self.request cancel];
}

@end
