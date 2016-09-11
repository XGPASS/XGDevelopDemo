//
//  XGAutoHeightTabController.m
//  XGDevelopDemo
//
//  Created by 小广 on 16/9/9.
//  Copyright © 2016年 小广. All rights reserved.
//   自动算高的table

#import "XGAutoHeightTabController.h"
#import "XGTestCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface XGAutoHeightTabController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray            *dataArray;
@end

@implementation XGAutoHeightTabController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUIContent];
    [self initDatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 自定义方法
// 布局UI
- (void)setUpUIContent {
    self.title = @"自动算高的table";
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self registerNibWithTableView];
}

// 初始化数据
- (void)initDatas {
    NSArray *array = @[@"要是能重来 我要选李白 几百年前做的好坏 没那么多人猜", @"要是能重来 我要选李白 至少我还能写写诗来澎湃 逗逗女孩", @"要是能重来 我要选李白 创作也能到那么高端 被那么多人崇拜", @"一天宛如一年 一年宛如一天 任时光流转 我还是我", @"一遍用了千遍 千遍只为一遍 当回忆久远 初心始现", @"一天宛如一年 一年宛如一天 任时光流转 我还是我 一遍用了千遍 千遍只为一遍 当回忆久远 初心始现 我做了那么多改变 只是为了我心中不变 默默地深爱着你无论相见不相见 我做了那么多改变 只是为了我心中不变 我多想你看见", @"《李白》 AND 《我变了 我没变》"];
    [self.dataArray addObjectsFromArray:array];
}

// 注册cell
- (void)registerNibWithTableView {
    [self.tableView registerNib:[XGTestCell loadNib] forCellReuseIdentifier:[XGTestCell className]];
}



// 去地图页面
- (void)gotoMapVC {
    // 去地图页面
}

#pragma mark - action事件

#pragma mark - lazy load
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

#pragma mark - 代理方法
//// iOS8 分割线右移15像素 下面将其归零
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:[XGTestCell className]
                                    cacheByIndexPath:indexPath
                                       configuration:^(XGTestCell *cell) {
                                           [cell refreshCellWithItem:self.dataArray[indexPath.row]];
                                       }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}


// cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    //
    if (indexPath.section == 0) {
        XGTestCell *infoCell = [tableView dequeueReusableCellWithIdentifier:[XGTestCell className] forIndexPath:indexPath];
        [infoCell refreshCellWithItem:self.dataArray[indexPath.row]];
        infoCell.separatorInset = UIEdgeInsetsMake(0.f, 15.0f, 0.f, 15.0f);
        cell = infoCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
