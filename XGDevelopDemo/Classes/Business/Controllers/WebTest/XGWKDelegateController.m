//
//  XGWKDelegateController.m
//  XGDevelopDemo
//
//  Created by 小广 on 2016/11/18.
//  Copyright © 2016年 小广. All rights reserved.
//  [userContentController addScriptMessageHandler:self  name:@"XXX"];这句代码造成无法释放内存 所以写一个新的controller来处理,新的controller再绕用delegate绕回来

#import "XGWKDelegateController.h"

@interface XGWKDelegateController ()

@end

@implementation XGWKDelegateController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([self.delegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
