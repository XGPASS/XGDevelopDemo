//
//  WKWebViewBridgeController.m
//  XGDevelopDemo
//
//  Created by 小广 on 2016/11/4.
//  Copyright © 2016年 小广. All rights reserved.
//  WebViewJavascriptBridge 第三方使用WKWebView
// WebViewJavascriptBridge地址 https://github.com/marcuswestin/WebViewJavascriptBridge
// WebViewJavascriptBridge iOS使用地址 http://www.jianshu.com/p/e951af9e5e74
// WebViewJavascriptBridge Java使用地址 http://blog.csdn.net/sk719887916/article/details/47189607

#import "WKWebViewBridgeController.h"
#import "WKWebViewJavascriptBridge.h"
#import <WebKit/WebKit.h>

@interface WKWebViewBridgeController ()<WKNavigationDelegate, WKUIDelegate>

@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic, strong) WKWebView *wkWebView;           // webview

@end

@implementation WKWebViewBridgeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpWKWebView];
}

- (void)setUpWKWebView {
    self.wkWebView =  [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    [self.view addSubview:self.wkWebView];
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    [_bridge setWebViewDelegate:self];
    
    // 注册一下
    
    __weak __typeof(self)weakSelf = self;
    // js调用oc
    [_bridge registerHandler:@"_app_setTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@" 这就是回传js数据");
        if ([data isKindOfClass:[NSString class]]) {
            weakSelf.title = (NSString *)data;
            return ;
        }
        if (data) {
            weakSelf.title = [NSString stringWithFormat:@"%@",data];
        }
    }];
    
    // oc调用js
//    [_bridge callHandler:@"getCodeScan" data:@"oc调用js端方法" responseCallback:^(id responseData) {
//        //
//        NSLog(@"responseData===%@==",responseData);
//    }];
    
    [self loadExamplePage:self.wkWebView];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
}

- (void)loadExamplePage:(WKWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"xg_test" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 处理拨打电话
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        // 这种拨打电话的写法，真机可显示效果，模拟器不显示
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 处理拨打电话
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


@end
