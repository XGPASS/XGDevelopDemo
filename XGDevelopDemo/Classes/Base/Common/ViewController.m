//
//  ViewController.m
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/30.
//  Copyright © 2016年 小广. All rights reserved.
//  主页

#import "ViewController.h"
#import "XGTableTestController.h"
#import "XGCollectionController.h"
#import "XGAddCellController.h"
#import "XGChoseDateView.h"
#import "XGDatePicerViewController.h"
#import "UIViewController+MJPopupViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSDate *choseDate;
//@property (nonatomic, strong) XGChoseDateView *choseView;

@end

@implementation ViewController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self initDatas];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 自定义方法
- (void)initSubViews {
    self.title = @"开发模板";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self registerNibWithTableView];

}

- (void)initDatas {
    self.titleArray = @[@"封装的Tab测试", @"CollectionView网格测试",
                        @"Tab弹出小cell测试", @"选择日期的测试一",
                        @"选择日期的测试二"];
}

// 注册cell
- (void)registerNibWithTableView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell className]];

}

#pragma mark - action事件
// 列表cell点击事件的处理
- (void)selectRowAction:(NSInteger)row {
    NSString *tempTitle = self.titleArray[row];
    UIViewController *controller = nil;
    if ([tempTitle isEqualToString:@"封装的Tab测试"]) {
        controller = [[XGTableTestController alloc] init];
    } else if ([tempTitle isEqualToString:@"CollectionView网格测试"]) {
        controller = [[XGCollectionController alloc] init];
    } else if ([tempTitle isEqualToString:@"Tab弹出小cell测试"]) {
        controller = [[XGAddCellController alloc] init];
    } else if ([tempTitle isEqualToString:@"选择日期的测试一"]) {
        [self showDateView:0];
        return;
    } else if ([tempTitle isEqualToString:@"选择日期的测试二"]) {
        [self showDateView:1];
        return;
    }
    
    if (controller) {
//        [self presentViewController:controller animated:YES completion:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

// 选择日期的view
- (void)showDateView:(NSInteger)index {
    
    kWeakSelf
    if (index == 0) {
        // 选择日期的测试一
        XGChoseDateView *choseView = [[XGChoseDateView alloc] initWithFrame:XGScreenBounds
                                                             datePickerMode:UIDatePickerModeDate
                                                                   lastDate:self.choseDate];
        [choseView showView];
        [choseView confirmDate:^(NSDate *date) {
            weakSelf.choseDate = date;
            NSLog(@"当前选择的时间是==%@==",date);
        }];
        return;
    }
    
    // 选择日期的测试二
    XGDatePicerViewController *datePickerVC = [[XGDatePicerViewController alloc] init];
    datePickerVC.curDate = [NSDate date];
    datePickerVC.datePickerMode = UIDatePickerModeDate;
    datePickerVC.title = @"请选择";
    
    [datePickerVC choseDateFinishBlock:^(ButtonType btnType, NSDate *date) {
        NSLog(@"当前的date是====%@===", date);
        [weakSelf dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    }];
    [self presentPopupViewController:datePickerVC animationType:MJPopupViewAnimationFade];
    
}

#pragma mark - lazy load
#pragma mark - 代理方法
// cell的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell className] forIndexPath:indexPath];
    cell.textLabel.text = self.titleArray[indexPath.row];
    // 分割线 设置
    cell.separatorInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
    // 选中状态设置
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


// 选中的处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectRowAction:indexPath.row];
    
}


@end
