//
//  XGAddCellController.m
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/31.
//  Copyright © 2016年 小广. All rights reserved.
//  弹出额外小cell 测试

#import "XGAddCellController.h"
#import "XGAddCell.h"

@interface XGAddCellController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray      *dataArray;      // 数据源数组
@property (nonatomic, assign) BOOL                 isOpen;         // 记录是否打开小cell的
@property (nonatomic, strong) NSIndexPath         *popNSIndexPath; // 记录打开小cell的IndexPath

@end

@implementation XGAddCellController

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
- (void)initSubViews {
    self.title = @"显示额外小cell测试";
    [self registerNibWithTableView];
}

- (void)initDatas {
    NSString *file = [[NSBundle mainBundle] pathForResource:@"AddCellDatas" ofType:@"plist"];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:file];
    for (NSDictionary *dict in dataArr) {
        XGAddCellModel  *model = [XGAddCellModel mj_objectWithKeyValues:dict];
        [self.dataArray addObject:model];
    }
}

// 注册cell
- (void)registerNibWithTableView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell className]];
    [self.tableView registerNib:[XGAddCell loadNib] forCellReuseIdentifier:[XGAddCell className]];
    
}

#pragma mark - action事件

/**
 * 更新弹出cell显示状态
 */
- (void)updateTableShow:(NSIndexPath *)indexPath {
    // 开始刷新
    [self.tableView beginUpdates];
    if (self.isOpen) {
        
        if (indexPath.row == _popNSIndexPath.row || indexPath.row == (_popNSIndexPath.row - 1)) {
            // 若是点击的是当前cell或者小cell本身 关闭弹出的cell
            [self closePopCell];
        } else {
            // 先关闭当前显示的cell
            [self.dataArray removeObjectAtIndex:_popNSIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[_popNSIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            if (indexPath.row < _popNSIndexPath.row){
                
                [self insertPopCell:indexPath];
                
            } else {
                //
                [self insertPopCell:[NSIndexPath indexPathForItem:(indexPath.row - 1) inSection:indexPath.section]];
            }
        }
        
    } else {
        // 弹出插入的Cell
        [self insertPopCell:indexPath];
    }
    
    // 结束刷新
    [self.tableView endUpdates];
}

/**
 *插入弹出KLCallPopCell
 */
- (void)insertPopCell:(NSIndexPath *)indexPath {
    XGAddCellModel *model = [[XGAddCellModel alloc] init];
    model.isSmall = YES;
    NSIndexPath *popIndexPath = [NSIndexPath indexPathForItem:(indexPath.row + 1) inSection:indexPath.section];
    self.popNSIndexPath = popIndexPath;
    [self.dataArray insertObject:model atIndex:popIndexPath.row];
    [self.tableView insertRowsAtIndexPaths:@[popIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    self.isOpen = YES;
}

/**
 * 关闭弹出的cell
 */
- (void)closePopCell {
    if(_isOpen && _popNSIndexPath){
        [self.dataArray removeObjectAtIndex:_popNSIndexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[_popNSIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        _popNSIndexPath = nil;
        _isOpen = NO;
    }
}

#pragma mark - lazy load
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
#pragma mark - 代理方法
// cell的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// 区头和区脚的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

// cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

// cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    XGAddCellModel *model = self.dataArray[indexPath.row];
    if (model.isSmall) {
        UITableViewCell *smallCell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell className] forIndexPath:indexPath];
        smallCell.textLabel.text = @"这就是个小Cell";
        smallCell.backgroundColor = UIColorFrom16RGB(0x81b9ea);
        cell = smallCell;
    } else {
        XGAddCell *normalCell = [tableView dequeueReusableCellWithIdentifier:[XGAddCell className] forIndexPath:indexPath];
        kWeakSelf
        [normalCell refreshCellWithItem:model block:^(UIButton *btn, NSInteger tag) {
            [weakSelf updateTableShow:indexPath];
        }];
        cell = normalCell;
    }
    
    // 分割线 设置
    cell.separatorInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
    // 选中状态设置
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


// 选中的处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self closePopCell];
//    [self selectRowAction:indexPath.row];
    
}


@end
