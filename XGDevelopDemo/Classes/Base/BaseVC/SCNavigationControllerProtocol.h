//
//  SCNavigationControllerProtocol.h
//  SuperCommunity
//
//  Created by MCDuff on 16/3/9.
//  Copyright © 2016年 All. All rights reserved.
//

#ifndef SCNavigationControllerProtocol_h
#define SCNavigationControllerProtocol_h

@class SCNavigationController;

@protocol SCNavigationControllerProtocol <NSObject>

/**
 *  可以重写navigationBar自带的back按钮事件
 *
 *  @param navigationController SCNavigationController
 *
 *  @return YES
 */
- (BOOL)sc_navigationControllerShouldPopWhenBackItemSelected:(SCNavigationController *)navigationController;

@end


#endif /* SCNavigationControllerProtocol_h */
