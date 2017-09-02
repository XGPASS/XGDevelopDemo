//
//  XGBaseTableController.m
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/30.
//  Copyright © 2016年 小广. All rights reserved.
//  封装好的有tableview的基类的VC

#import "XGBaseTableController.h"
#import "MJRefresh.h"

@interface XGBaseTableController () <UITableViewDelegate>

@property (strong, nonatomic) UIView *emptyView;             // 无数据时的图片view
@property (strong, nonatomic) NSMutableArray *arrayData;     // 所有数据
@property (assign, nonatomic) NSUInteger currentPage;        // 当前页
@property (assign, nonatomic) NSUInteger pageCount;          // 每次请求的条数


@end

@implementation XGBaseTableController

#pragma mark - 生命周期方法

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _currentPage = 1;
        _pageCount = kPageCount;
        _autoLoad = YES;
        _closeRefresh = NO;
        _tableViewStyle = UITableViewStylePlain;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _currentPage = 1;
        _pageCount = kPageCount;
        _autoLoad = YES;
        _closeRefresh = NO;
        _tableViewStyle = UITableViewStylePlain;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_layoutViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 自定义方法
// 一进自动加载刷新
- (void)setAutoLoad:(BOOL)autoLoad {
    _autoLoad = autoLoad;
}

- (void)addItems:(NSArray *)items {
    
    BOOL isClear = (self.currentPage == 1);
    if (isClear) {
        [self.arrayData removeAllObjects];
    }
    
    if (items.count == 0) return;
    
    [self.arrayData addObjectsFromArray:items];
}


- (void)reloadTableView {
    
    // 添加为空时显示的View
    if (self.arrayData.count == 0) {
        self.hasMore = NO;
        [self.tableView addSubview:self.emptyView];
        self.emptyView.hidden = NO;
    } else {
        [self.emptyView removeFromSuperview];
        self.emptyView.hidden = YES;
    }
    
    // 判断隐藏底部刷新控件
    [self hideFooterView:!self.hasMore];
    
    [self.tableView reloadData];
}


- (void)changePageCount:(NSUInteger)count {
    self.pageCount = count;
}


- (void)beginRefreshing {
    self.currentPage = 1;
    [self.tableView.mj_header beginRefreshing];
}

- (void)endRefreshing {
    if (self.currentPage > 1) {
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_header endRefreshing];
    }
    if (self.arrayData.count == 0) {
        [self reloadTableView];
    }
}


- (void)changeEmptyView:(UIView *)view {
    _emptyView = view;
    [self.tableView reloadData];
}

- (void)resetEmptyViewFrame:(CGRect)frame {
    self.emptyView.frame = frame;
}


- (void)configTableView:(XGArrayDataSource *)dataSource nibs:(NSArray *)nibs {
    self.tableView.dataSource = dataSource;
    kWeakSelf
    [nibs enumerateObjectsUsingBlock:^(NSString *nibName, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [weakSelf.tableView registerNib:nib forCellReuseIdentifier:nibName];
    }];
}


- (void)updateTableViewFrame:(CGRect)frame {
    self.tableView.frame = frame;
}
#pragma mark - 对内方法

// 初始化UI
- (void)p_layoutViews {
    self.view.backgroundColor =  HEXCOLOR(0xECECF0);
    [self.view addSubview:self.tableView];
    
    [self configTableViewSource];
    if (!self.closeRefresh) {
        [self p_addHeader];
        [self p_addFooter];
    }
}

- (void)p_addHeader {
    kWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf p_headerWithRefreshing];
    }];
    
    if (self.autoLoad) {
        [self.tableView.mj_header beginRefreshing];
    }
    
}


- (void)p_addFooter {
    kWeakSelf
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf p_footerWithRefreshing];
    }];
    self.tableView.mj_footer.automaticallyHidden = NO; // 关闭自动分页刷新
    self.tableView.mj_footer.hidden = YES;
}


// 下拉刷新 添加数据
- (void)p_headerWithRefreshing {
    self.currentPage = 1;
    [self requestData:self.currentPage pageCount:self.pageCount];
}

// 上拉加载更多
- (void)p_footerWithRefreshing {
    
    self.currentPage ++;
    if (!self.hasMore) {
        [SVProgressHUD showErrorWithStatus:@"无数据"];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    
    [self requestData:self.currentPage pageCount:self.pageCount];
}


#pragma mark - lazy load
- (UITableView *)tableView {
    if (!_tableView ) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XGScreenWidth, XGScreenHeight)
                                                              style:_tableViewStyle];
        tableView.backgroundColor = HEXCOLOR(0xECECF0);
        tableView.backgroundView = nil;
        tableView.delegate = self;
        tableView.rowHeight = 70.f;
        tableView.tableFooterView = [[UIView alloc] init];
        
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        _tableView = tableView;
    }
    
    return _tableView;
}

/* 目前基本可以兼容有表头的tableView
 * 无表头的话  请在所使用的类里加上self.emptyView.frame = self.tableView.frame;
 */
- (UIView *)emptyView {
    if (!_emptyView) {
        
        CGFloat  posY = self.tableView.tableHeaderView.frame.size.height;
        CGFloat  height = 0.0;
        if (self.tableView.frame.origin.y == 0.0 && posY == 0.0) {
            posY = 64.0;
        } else {}
        
        if (self.tableView.tableHeaderView.frame.size.height != 0.0){
            height = self.tableView.frame.size.height - self.tableView.tableHeaderView.frame.size.height;
        } else {
            height = self.tableView.frame.size.height;
        }
        
        _emptyView = [[UIView alloc]initWithFrame:CGRectMake(0.0, posY, self.tableView.frame.size.width, height)];
        UIImage *image = [UIImage imageNamed:@"配服默认图_图片加载失败"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        CGFloat  centerY = 0.0;
        if (self.tableView.tableHeaderView.frame.size.height != 0.0) {
            centerY = _emptyView.center.y - 120.0;
        } else {
            centerY = _emptyView.center.y - 90.0;
        }
        imageView.center = CGPointMake(_emptyView.center.x, centerY);
        // imageView.center = view.center;
        _emptyView.hidden = YES;
        _emptyView.backgroundColor = [UIColor clearColor];
        [_emptyView addSubview:imageView];
        
        UILabel *emptyLbl = [[UILabel alloc] initWithFrame:CGRectMake(16.0, imageView.frame.origin.y + imageView.frame.size.height, XGScreenWidth - 32.0, 30.0)];
        emptyLbl.text = @"暂无数据";
        emptyLbl.textAlignment = NSTextAlignmentCenter;
        emptyLbl.font = [UIFont systemFontOfSize:16.0];
        emptyLbl.textColor = HEXCOLOR(0x787878);
        [_emptyView addSubview:emptyLbl];
    }
    
    return _emptyView;
}


- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return _arrayData;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectRowAtIndexPath:indexPath];
}

#pragma mark - 对外方法

- (void)hideHeaderView:(BOOL)hidden {
    self.tableView.mj_header.hidden = hidden;
}


- (void)hideFooterView:(BOOL)hidden {
    self.tableView.mj_footer.hidden = hidden;
}


#pragma mark - 以下方法子类需要重写

- (void)requestData:(NSUInteger)currentPage pageCount:(NSUInteger)count {
    DAssert(0)
}

/**
 *  配置TableView的数据源
 */
- (void)configTableViewSource {
    DAssert(0)
}

/**
 *  选中单个cell时回调的方法
 *
 *  @param indexPath
 */
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
   //
}

@end
