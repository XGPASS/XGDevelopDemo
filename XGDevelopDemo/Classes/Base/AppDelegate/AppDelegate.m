//
//  AppDelegate.m
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/30.
//  Copyright © 2016年 小广. All rights reserved.
//

#import "AppDelegate.h"
#import "JPEngine.h"
#import "IQKeyboardManager.h"
#import "SCHomePageController.h"
#import "SCNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 设置热修复引擎
//    [JPEngine startEngine];
//    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"hotpatch" ofType:@"js"];
//    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
//    [JPEngine evaluateScript:script];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    IQKeyboardManager *keyBoardManager = [IQKeyboardManager sharedManager];
    keyBoardManager.enableAutoToolbar = NO;
    keyBoardManager.shouldResignOnTouchOutside = YES;
    keyBoardManager.shouldShowToolbarPlaceholder = NO;
    keyBoardManager.enable = YES;
    
    /// 设置导航条自带的返回按钮图片
//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back_black"]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back_black"]];
    /// 设置导航条的背景颜色
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:HEXCOLOR(0x333333)];
        
    SCHomePageController *vc = [[SCHomePageController alloc] initWithNibName:NSStringFromClass([SCHomePageController class]) bundle:nil];
    SCNavigationController *nav = [[SCNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // 
}

@end
