//
//  XGWKWebViewController.m
//
//  Created by 小广 on 2016/10/31.
//  Copyright © 2016年 All. All rights reserved.
//  新的WKWebView测试

#import "XGWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "XGWKDelegateController.h"
#import "MJRefresh.h"

#define kMessageHandlerName       @"RemoteH5"

@interface XGWKWebViewController ()<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate, XGWKDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;           // webview
@property (nonatomic, strong) UIProgressView *progressView;   // 进度条
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, assign) BOOL  isFirst;  // 是否第一次进入自动刷新

@end

@implementation XGWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupView];
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[self.wkWebView configuration].userContentController removeScriptMessageHandlerForName:kMessageHandlerName];
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
    [self cleanWebKitCaches];
    NSLog(@"%s",__func__);
}

#pragma mark - 重写父类
- (void)setupNav {
    self.isFirst = YES;
    self.title = @"普通WKWebView使用";
    [self setUpNavBar];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpProgressView];
    [self setUpWKWebView];
    [self setUpKVOMethods];
    [self addRefreshHeader];
}

- (void)setupData {
    
}

#pragma mark - UIContent SetUp Method
// 初始化WKWebView
- (void)setUpWKWebView {
    // 创建配置
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    
    WKPreferences  *preferences = [[WKPreferences alloc] init];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    
    // 创建UserContentController（提供JavaScript向webView发送消息的方法）
    WKUserContentController* userContent = [[WKUserContentController alloc] init];
    // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
    //注册方法
    XGWKDelegateController * delegateController = [[XGWKDelegateController alloc]init];
    delegateController.delegate = self;
    [userContent addScriptMessageHandler:delegateController name:kMessageHandlerName];
    // 将UserConttentController设置到配置文件
    configuration.userContentController = userContent;
    // 高端的自定义配置创建WKWebView
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, XGScreenWidth, XGScreenHeight) configuration:configuration];
    self.wkWebView.scrollView.showsVerticalScrollIndicator = NO;
    // 设置所需代理
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    
    // 将WKWebView添加到视图
    [self.view insertSubview:self.wkWebView belowSubview:self.progressView];
}

// 进度条
- (void)setUpProgressView {
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0.0, 0.0, XGScreenWidth, 0.0)];
    self.progressView.tintColor = [UIColor greenColor];
    self.progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:self.progressView];
}

// 进度条
- (void)setUpKVOMethods {
    // 进度条
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
}

// 设置导航相关
- (void)setUpNavBar {
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 90.0, 32.0)];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 45.0, 32.0);
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -20.0, 0.0, 0.0);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, -20.0, 0.0, 0.0);
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:backButton];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(35.0, 0.0, 40.0, 32.0);
    [self.closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.closeButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton.hidden = YES;
    [leftView addSubview:self.closeButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
}

// 下拉加载
- (void)addRefreshHeader {
    kWeakSelf
    self.wkWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isFirst) {
            [weakSelf loadH5FromServer:NO];
            weakSelf.isFirst = NO;
            return ;
        }
        [weakSelf.wkWebView reload];
    }];
    
    [self.wkWebView.scrollView.mj_header beginRefreshing];
}

// 更改nav按钮的显示
- (void)updateCloseButton {
    if ([self.wkWebView canGoBack]) {
        if (self.closeButton.hidden) {
            self.closeButton.hidden = NO;
        }
    } else {
        if (!self.closeButton.hidden) {
            self.closeButton.hidden = YES;
        }
    }
}

//  加载H5页面 isLocal是否是本地
- (void)loadH5FromServer:(BOOL)isLocal {
    if (isLocal) {
        
        NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"xxx" ofType:@"html"];
        NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
        [self.wkWebView loadHTMLString:appHtml baseURL:baseURL];
        return;
    }
    
    // 网络
    NSString *urlString = @"http://bababbababababab.com";
    if (ISNULL(urlString).length > 0) {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    } else {
        [SVProgressHUD showErrorWithStatus:@"网页地址为空"];
    }
}

// 清除web缓存
- (void)cleanWebKitCaches {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9) {
        NSLog(@"------System Version >= 9.0");
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes
                                                   modifiedSince:dateFrom completionHandler:^{
                                                       NSLog(@"------成功清除9.0系统的WKWebView缓存------");
                                                   }];
    } else {
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [storage cookies])
        {
            [storage deleteCookie:cookie];
        }
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        NSLog(@"------成功清除8.0系统的WKWebView缓存------");
    }
}

#pragma mark - User Action Methods

// 返回按钮
- (void)backButtonAction:(id)sender {
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// 关闭按钮
- (void)closeButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 拦截的js事件
- (void)dispatchMessage:(id)message {
    NSLog(@"message==%@==",message);
}

#pragma mark - 代理方法
// KVO回调方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat progress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (progress == 1.0) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        } else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:progress animated:YES];
        }
    }
}

//===== WKScriptMessageHandler Methods
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"message.body==%@", message.body);
    if ([message.name isEqualToString:kMessageHandlerName]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray, NSDictionary, and NSNull类型
        [self dispatchMessage:message.body];
    }
}

//===== WKUIDelegate Methods
// 必须这样写UIAlert才会显示  completionHandler();不可少
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:
                                UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                    completionHandler();
                                }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

//===== WKNavigationDelegate Methods 页面跳转的代理方法
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    
    // 处理拨打电话
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        [XGTool callPhone:resourceSpecifier];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [SVProgressHUD dismiss];
    [self updateCloseButton];
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    [self updateCloseButton];
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 当main frame的导航开始请求时，会调用此方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
//    self.title = NSLocalizedString(@"Loading...", @"");
    [self updateCloseButton];
}

// 当main frame导航完成时，会回调
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    //say()是JS方法名，completionHandler是异步回调block
//    [webView evaluateJavaScript:@"say()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        NSLog(@"%@",result);
//    }];
    [self.wkWebView.scrollView.mj_header endRefreshing];
    [self updateCloseButton];
}

// 这与用于授权验证的API，与AFN、UIWebView的授权验证API是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
   
    if (![self.wkWebView canGoBack]) {
        self.isFirst = YES;
    }
    [self.wkWebView.scrollView.mj_header endRefreshing];
    [self updateCloseButton];
}



@end
