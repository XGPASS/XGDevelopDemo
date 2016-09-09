//
//  XGNetRequest.m
//  XGBaseDemo
//  请求相关的管理类
//  Created by 绿漫小广 on 16/8/6.
//  Copyright © 2016年 绿漫小广. All rights reserved.
//

#import "XGNetRequest.h"
#import "AFNetworking.h"

#define  kHttpBaseAddress  @"https://www.baidu.com/"  // 宏定义基础的域名

#define ISNIL(x) ((x) == nil ? @"" : (x))

/**
 same as NSMakeRange()
 */
static inline NSRange NSRangeMake(NSUInteger location, NSUInteger length) {
    NSRange r;
    r.location = location;
    r.length = length;
    return r;
}

@interface XGNetRequest ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;             // AF请求对象
@property (nonatomic, strong) NSString *action;                          // 指令
@property (nonatomic, strong) NSString *errMsg;                          // 错误信息

@end

@implementation XGNetRequest

#pragma mark - 对外方法
// POST请求方法
+ (XGNetRequest *)postWithAction:(NSString *)action
                      parameters:(id)parameters
                        complete:(XGCompleteBlock)block {
    XGNetRequest *request = [[XGNetRequest alloc] initWithPostAction:action
                                                               token:nil
                                                          otherParam:parameters
                                                       completeBlock:block];
    return request;
}


// GET请求方法
+ (XGNetRequest *)getWithAction:(NSString *)action
                     parameters:(id)parameters
                       complete:(XGCompleteBlock)block {
    
    NSString *url = [self converURL:action params:parameters];
    XGNetRequest *request = [[XGNetRequest alloc] initWithGetAction:url
                                                               token:nil
                                                          otherParam:nil
                                                       completeBlock:block];
    return request;
}

/*
 * 取消请求
 */
- (void)cancel {
    [self.manager.operationQueue cancelAllOperations];
    
    if (self.manager) {
        self.manager = nil;
    }
}

#pragma mark - 内部方法

/**
 * AFNetworking初始化HTTP
 */
- (void)httpInit {
    // 应用配置文件
    self.manager = [AFHTTPSessionManager manager];
    
    // 申明返回的结果是JSON类型
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 如果包接受类型不一致请替换
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    // 请求时间设置
    self.manager.requestSerializer.timeoutInterval = 20;
}

/*
 * 添加HTTP头
 * @param token 签名信息
 * @param mobileParam 设备信息
 */
- (void)addRequestHeader:(NSString *)token {
    
    [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.manager.requestSerializer setValue:@"application/json;charset=utf-8"
                          forHTTPHeaderField:@"Content-Type"];
    
    if (token.length > 0) {
        [self.manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    }
    
    /*
     // 设置请求包头一些信息
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [self.manager.requestSerializer setValue:appType forHTTPHeaderField:@"appType"];
    [self.manager.requestSerializer setValue:meid forHTTPHeaderField:@"meid"];
    [self.manager.requestSerializer setValue:clientVersion forHTTPHeaderField:@"clientVersion"];
    [self.manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"uutype"];
     
     // 经纬度信息
    __block NSNumber *longitudeString;
    __block NSNumber *latitudeString;
    [XSDBaiduMapTools getAddress:^(NSString *province, NSString *city, NSString *area, NSNumber *latitude, NSNumber *longitude) {
        longitudeString = longitude;
        latitudeString = latitude;
    }];
    NSString *longitude = [NSString stringWithFormat:@"%f", longitudeString.doubleValue]; // 经度
    NSString *latitude = [NSString stringWithFormat:@"%f", latitudeString.doubleValue]; // 纬度
    
    [self.manager.requestSerializer setValue:longitude forHTTPHeaderField:@"longitude"];
    [self.manager.requestSerializer setValue:latitude forHTTPHeaderField:@"latitude"];
    */
    
    NSLog(@"请求包头 ==== %@", self.manager.requestSerializer.HTTPRequestHeaders);
}

/**
 *	初始化post请求
 *
 *	@param 	action 	action
 *	@param 	token 	签名信息
 *	@param 	otherParam  postbody  json string
 *  @param  completeBlock 回调方法
 *	@return self id
 */
- (id)initWithPostAction:(NSString *)action
                   token:(NSString *)token
              otherParam:(id)otherParam
           completeBlock:(XGCompleteBlock)completeBlock {
    if (self = [super init]) {
        [self httpInit];
        
        NSString *params = @"";
        NSData *dataParam = nil;
        // 将请求参数转化为json字符串
        if ([otherParam isKindOfClass:[NSString class]]) {
            params = otherParam;
        } else if(otherParam) {
            params = [self jsonStringEncoded:otherParam];
        }
        
        dataParam = [params dataUsingEncoding:NSUTF8StringEncoding];
        
        // 添加HTPP头
        [self addRequestHeader:token];
        
        // 获取请求的域名地址
        NSString *ipAddress = [self ipAddress:kHttpBaseAddress];
        
        // 拼接url
        NSString *url = [NSString stringWithFormat:@"%@%@", ipAddress, ISNIL(action)];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"请求url:%@",url);
        NSLog(@"请求参数:%@",params);
        
        
        [self.manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            // 进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *error = [self checkToken:responseObject];
            if (error.length > 0 ) {
                NSNumber *code = responseObject[@"code"];
                NSDictionary *dic = @{@"errorCode":code, @"errorMsg":error};
                [[NSNotificationCenter defaultCenter] postNotificationName:kTokenError object:dic];
                NSError *err = [NSError errorWithDomain:error code:1000 userInfo:nil];
                completeBlock(nil, task, err);
                return;
            }
            
            completeBlock(responseObject, task, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"返回错误, error ==== %@", error);
            completeBlock(nil, task, error);
        }];

    }
    return  self;
}


/**
 *	初始化 GET请求
 *
 *	@param 	action 	action
 *	@param 	token 	签名
 *	@param 	otherParam  postbody  json string
 *  @param  completeBlock 回调方法
 *	@return self id
 */
- (id)initWithGetAction:(NSString *)action
                  token:(NSString *)token
             otherParam:(id)otherParam
          completeBlock:(XGCompleteBlock)completeBlock {
    if (self = [super init]) {
        [self httpInit];
        
        NSString *params = @"";
        NSData *dataParam = nil;
        // 将请求参数转化为json字符串
        if ([otherParam isKindOfClass:[NSString class]]) {
            params = otherParam;
        } else if(otherParam) {
            params = [self jsonStringEncoded:otherParam];
        }
        
        dataParam = [params dataUsingEncoding:NSUTF8StringEncoding];
        
        // 添加HTPP头
        [self addRequestHeader:token];
        
        // 获取请求的域名地址
        NSString *ipAddress = [self ipAddress:kHttpBaseAddress];
        
        // 拼接url
        NSString *url = [NSString stringWithFormat:@"%@%@", ipAddress, ISNIL(action)];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"请求url:%@",url);
        NSLog(@"请求参数:%@",params);
        
        [self.manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            // 进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *error = [self checkToken:responseObject];
            if (error.length > 0 ) {
                NSNumber *code = responseObject[@"code"];
                NSDictionary *dic = @{@"errorCode":code, @"errorMsg":error};
                [[NSNotificationCenter defaultCenter] postNotificationName:kTokenError object:dic];
                NSError *err = [NSError errorWithDomain:error code:1000 userInfo:nil];
                completeBlock(nil, task, err);
                return;
            }
            completeBlock(responseObject, task, nil);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"返回错误, error ==== %@", error);
            completeBlock(nil, task, error);
        }];
        
    }
    return  self;
}


// 拼接域名 判断是否是 http/https 开头
- (NSString *)ipAddress:(NSString *)ip {
    
    NSString *ipAddress = ip;
    BOOL isHttp = [ipAddress hasPrefix:@"http://"];
    BOOL isHttps = [ipAddress hasPrefix:@"https://"];
    
    if (!isHttp && !isHttps) {
        ipAddress = [NSString stringWithFormat:@"http://%@/", ipAddress];
    }
    
    return ipAddress;
}


// 拼接get请求参数
+ (NSString *)converURL:(NSString *)url params:(id)parameters {
    NSMutableString *newURL = [NSMutableString stringWithFormat:@"%@", url];
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        NSDictionary *params = (NSDictionary *)parameters;
        
        NSArray *columnArray = [params allKeys];
        if (columnArray.count > 0) {
            [newURL appendString:@"?"];
            for (NSString *key in columnArray) {
                NSString *value = ISNIL(params[key]);
                NSString *param = [NSString stringWithFormat:@"%@=%@", key, value];
                [newURL appendFormat:@"%@&", param];
            }
        }
        
        NSRange range = NSRangeMake(newURL.length - 1,  1);
        [newURL deleteCharactersInRange:range];
        
    } else if ([parameters isKindOfClass:[NSString class]]) {
        NSString *paramt = (NSString *)parameters;
        if (paramt.length > 0) {
            [newURL appendFormat:@"?%@", paramt];
        }
    }
    
    return newURL;
}

/*
 -11  token不存在
 -12  该账号已在其他地方登录
 -13  token过期
 -14  非法请求
 */
- (NSString *)checkToken:(id)responseObject {
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSNumber *code = responseObject[@"code"];
        
        NSString *error = [XGNetRequest tokenErrorMsg:code.integerValue];
        return error;
    }
    
    return nil;
}


// 错误code对应的msg
+ (NSString *)tokenErrorMsg:(NSInteger)code {
    NSString *error = nil;
    switch (code) {
            
        case -14: {                // 非法请求
            error = @"非法请求";
        }
            break;
        case -12: {                // 该账号已在其他地方登录
            error = @"该账号已在其他地方登录";
        }
            break;
        case -11:                  // token不存在
        case -13: {                // token过期
            error = @"该账号登录已过期, 请重新登录";
        }
            break;
        default:
            break;
    }
    
    return error;
}



// 字典/数组对象转换为json字符串
- (NSString *)jsonStringEncoded:(id)obj {
    if ([NSJSONSerialization isValidJSONObject:obj]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

@end
