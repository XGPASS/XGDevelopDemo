//
//  XGTableTestController.m
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/30.
//  Copyright © 2016年 小广. All rights reserved.
//  测试table刷新

#import "XGTableTestController.h"
#import "XGTestCell.h"

@interface XGTableTestController () 

@property (nonatomic, strong) NSArray *testArray;

@end

@implementation XGTableTestController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self initDatas];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 自定义方法

// 布局UI
- (void)initSubViews {
    self.title = @"封装Table测试";
    
    [self resetEmptyViewFrame:self.tableView.frame];
}

// 初始化数据
- (void)initDatas {
    self.testArray = @[@"要是能重来 我要选李白 几百年前做的好坏 没那么多人猜",
                       @"要是能重来 我要选李白 至少我还能写写诗来澎湃 逗逗女孩",
                       @"要是能重来 我要选李白 创作也能到那么高端 被那么多人崇拜",
                       @"一天宛如一年 一年宛如一天 任时光流转 我还是我",
                       @"一遍用了千遍 千遍只为一遍 当回忆久远 初心始现"];
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0;
}

#pragma mark - 重写父类
// 请求数据
- (void)requestData:(NSUInteger)currentPage pageCount:(NSUInteger)count {
    
    kWeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf endRefreshing];
        BOOL haveMore = YES;
        if (currentPage > 3) {
            haveMore = NO;
        }
        weakSelf.hasMore = haveMore;
        [weakSelf addItems:self.testArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf reloadTableView];
        });
    });
    
}

// 配置数据源
- (void)configTableViewSource {
    
    self.dataSource = [[XGArrayDataSource alloc] initWithItems:self.arrayData
                                                cellIdentifier:NSStringFromClass([XGTestCell class])
                                            configureCellBlock:
                       ^(XGTestCell *cell, id item, NSIndexPath *indexPath) {
                           [cell refreshCellWithItem:item];
                       }];
    [self configTableView:self.dataSource nibs:@[NSStringFromClass([XGTestCell class])]];
    
}

// 选中cell的操作
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
