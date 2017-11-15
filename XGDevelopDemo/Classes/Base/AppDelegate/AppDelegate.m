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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 设置热修复引擎
    [JPEngine startEngine];
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"hotpatch" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    [JPEngine evaluateScript:script];
    
    IQKeyboardManager *keyBoardManager = [IQKeyboardManager sharedManager];
    keyBoardManager.enableAutoToolbar = NO;
    keyBoardManager.shouldResignOnTouchOutside = YES;
    keyBoardManager.shouldShowToolbarPlaceholder = NO;
    keyBoardManager.enable = YES;
    
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
