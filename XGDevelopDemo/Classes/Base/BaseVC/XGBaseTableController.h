//
//  XGBaseTableController.h
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/30.
//  Copyright © 2016年 小广. All rights reserved.
//  封装好的有tableview的基类的VC

#import "XGBaseController.h"
#import "XGArrayDataSource.h"

#define kPageCount 10    // 每页显示的页数

@interface XGBaseTableController : XGBaseController

@property (assign, nonatomic) UITableViewStyle tableViewStyle;
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) BOOL hasMore;                 // 是否有下一页
@property (assign, nonatomic) BOOL autoLoad;                // 自动加载数据 YES-开启 NO-关闭 默认开启
@property (assign, nonatomic) BOOL closeRefresh;            // 关闭上/下拉刷新 YES-关闭 NO-开启 默认开启

@property (strong, nonatomic, readonly) NSMutableArray *arrayData;    // 所有数据
@property (strong, nonatomic) XGArrayDataSource *dataSource;          // 数据源


/**
 *  添加数据
 *  第一页需先清空原有数据
 *  @param items 新数据
 */
- (void)addItems:(NSArray *)items;

/**
 *  隐藏下拉刷新
 *
 *  @param visible
 */
- (void)hideHeaderView:(BOOL)hidden;

/**
 *  隐藏上拉加载更多
 *
 *  @param visible
 */
- (void)hideFooterView:(BOOL)hidden;

/**
 *  重新刷新表格
 */
- (void)reloadTableView;


/**
 *  替换无数据时显示的View
 *
 *  @param view 自定义View
 */
- (void)changeEmptyView:(UIView *)view;

/**
 *  设置无数据时显示的Viewframe
 */
- (void)resetEmptyViewFrame:(CGRect)frame;

/**
 *  开始刷新视图
 */
- (void)beginRefreshing;


/**
 *  结束刷新视图, 下拉刷新/上拉分页 都可调用此方法
 */
- (void)endRefreshing;


///**
// *  根据总条数计算出总页数
// *
// *  @param totalCount 总条数
// */
//- (void)calculateTotalPage:(NSUInteger)totalCount;


/**
 *  设置UITableView的数据源、注册Nib
 *
 *  @param dataSource 数据源
 *  @param nibs       自定义cell 数组
 */
- (void)configTableView:(XGArrayDataSource *)dataSource nibs:(NSArray *)nibs;


/**
 *  设置表视图的frame
 *
 *  @param rect frame
 */
- (void)updateTableViewFrame:(CGRect)frame;


/**
 *  更改每页显示数
 *
 *  @param count 条数
 */
- (void)changePageCount:(NSUInteger)count;


#pragma mark - 以下方法子类需要重写

/**
 *  网络请求方法
 *
 *  @param currentPage 当前页
 *  @param count       每页显示数
 */
- (void)requestData:(NSUInteger)currentPage pageCount:(NSUInteger)count;

/**
 *  配置TableView的数据源
 */
- (void)configTableViewSource;

/**
 *  选中单个cell时回调的方法
 *
 *  @param indexPath
 */
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
