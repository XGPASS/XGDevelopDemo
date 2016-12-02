//
//  XGSearchResultController.h
//  XGDevelopDemo
//
//  Created by 小广 on 2016/12/2.
//  Copyright © 2016年 小广. All rights reserved.
//  搜索结果页面

#import <UIKit/UIKit.h>

typedef void(^SearchResultSelectBlock)(id data);

@interface XGSearchResultController : UIViewController <UISearchResultsUpdating, UISearchBarDelegate>

- (void)selectRow:(SearchResultSelectBlock)block;

@end
