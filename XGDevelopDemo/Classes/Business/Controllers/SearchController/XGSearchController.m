//
//  XGSearchController.m
//  XGDevelopDemo
//
//  Created by 小广 on 2016/12/2.
//  Copyright © 2016年 小广. All rights reserved.
//  搜索页面

#import "XGSearchController.h"
#import "XGSearchResultController.h"
#import "XGTestCell.h"
#import "MJRefresh.h"

@interface XGSearchController ()<UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UIScrollViewDelegate> //

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;   //
@property (nonatomic, strong) UISearchController *searchController;         // 搜索框
@property (nonatomic, strong) XGSearchResultController *resultVC;   // 搜索结果的VC
@property (nonatomic, assign) BOOL       hasMore;


@end

@implementation XGSearchController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 重写父类
- (void)setupNav {
    self.navigationItem.title = @"搜索测试";
}

- (void)setupView {
    // definesPresentationContext 必须要设置为yes，否则会出现SearchBar位置错误
    self.definesPresentationContext = YES;
    [self registerNibWithTableView];
    [self setUpSearchController];
    [self addRefreshHeaderFooter];
}

#pragma mark - 自定义方法
// 注册cell
- (void)registerNibWithTableView {
    [self.tableView registerNib:[XGTestCell loadNib] forCellReuseIdentifier:[XGTestCell className]];
}

// 布局SearchController
- (void)setUpSearchController {
    self.resultVC = [[XGSearchResultController alloc] init];
    kWeakSelf
    [self.resultVC selectRow:^(id data) {
        [weakSelf.searchController setActive:NO];
    }];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultVC];
    
    self.searchController.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchResultsUpdater = self.resultVC;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.edgesForExtendedLayout = UIRectEdgeNone;
    //self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"请输入搜索内容";
    self.searchController.searchBar.delegate = self.resultVC;
    // 改变取消按钮字体颜色
    self.searchController.searchBar.tintColor = UIColorFromHexValue(0x0083e1);
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

// 添加刷新控件
- (void)addRefreshHeaderFooter {
    kWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadListDatas:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadListDatas:NO];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)endAllRefreshing {
    [self.tableView.mj_header endRefreshing];
    if (self.hasMore) {
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

// 加载list数据
- (void)loadListDatas:(BOOL)isFirst {
    
    if (isFirst) {
        [self.listArray removeAllObjects];
        NSArray *array = @[@"要是能重来 我要选李白", @"几百年前做的好坏 没那么多人猜",
                           @"要是能重来 我要选李白", @"至少我还能写写诗来澎湃 逗逗女孩",
                           @"要是能重来 我要选李白", @"创作也能到那么高端 被那么多人崇拜"];
        [self.listArray addObjectsFromArray:array];
        self.hasMore = YES;
    } else {
        NSArray *array = @[@"一天宛如一年 一年宛如一天", @"任时光流转 我还是我",
                           @"一遍用了千遍 千遍只为一遍", @"当回忆久远 初心始现"];
        [self.listArray addObjectsFromArray:array];
        self.hasMore = NO;
    }
    [self endAllRefreshing];
    [self.tableView reloadData];
    
}


#pragma mark - lazy load
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _listArray;
}

#pragma mark - 代理方法
// iOS8 分割线右移15像素 下面将其归零
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.listArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XGTestCell *cell = [tableView dequeueReusableCellWithIdentifier:[XGTestCell className] forIndexPath:indexPath];
    [cell refreshCellWithItem:self.listArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// UISearchControllerDelegate
- (void)didDismissSearchController:(UISearchController *)searchController {
}

- (void)willPresentSearchController:(UISearchController *)searchController {
}

@end
