//
//  SCInputAccessoryController.m
//  XGDevelopDemo
//
//  Created by sunyongguang on 2017/11/9.
//  Copyright © 2017年 小广. All rights reserved.
//  键盘的自定义InputView

#import "SCInputAccessoryController.h"
#import "SCInputCell.h"

@interface SCInputAccessoryController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/// 输入的内容
@property (nonatomic, copy) NSString  *inputString;

@end

@implementation SCInputAccessoryController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupData];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        //self.navigationController.navigationBar.translucent = YES;
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    NSLog(@"--%s--",__func__);
}

#pragma mark - 固定方法
- (void)setupNav {
    self.navigationItem.title = @"大标题";
}

- (void)setupView {
    
    [self registerNibWithTableView];
}

- (void)setupData {
}

#pragma mark - 代理方法 Delegate Methods
#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SCInputCell *cell = [tableView dequeueReusableCellWithIdentifier:[SCInputCell className] forIndexPath:indexPath];
    [cell refreshCellWithText:self.inputString];
    weakify(self)
    cell.textBlock = ^(NSString *text) {
        strongify(self)
        self.inputString = text;
        NSLog(@"输入的文字==%@==",text);
    };
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 对外方法 Public Methods
#pragma mark - 内部方法 Private Methods
// 注册cell
- (void)registerNibWithTableView {
    [self.tableView registerNib:[UINib nibWithNibName:[SCInputCell className] bundle:nil] forCellReuseIdentifier:[SCInputCell className]];
}
#pragma mark - 懒加载 Lazy Load

@end
