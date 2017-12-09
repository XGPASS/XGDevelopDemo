//
//  XGShowImageController.m
//  XGDevelopDemo
//
//  Created by sunyongguang on 2017/9/14.
//  Copyright © 2017年 小广. All rights reserved.
//

#import "XGShowImageController.h"
#import "SCCommonImageCell.h"
#import "MWBrowsePhotoHelper.h"


@interface XGShowImageController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray      *dataArray;      // 数据源数组

@end

@implementation XGShowImageController

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
    self.title = @"显示图片测试";
    [self registerNibWithTableView];
}

- (void)initDatas {
    
    NSArray *arr1 = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505388844481&di=7e70b8cc0276001b6a612feaca79d2e7&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201507%2F24%2F20150724065246_myCKz.jpeg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505388844480&di=5e1eb8cc6ebcfac3083c767f8150ad14&imgtype=0&src=http%3A%2F%2Fs7.rr.itc.cn%2Fg%2FwapChange%2F20153_18_9%2Fa8q8q79359434422520.jpeg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505388844480&di=a1155b743c7017a19c2b84b487a4e96e&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20161219%2F5b2149b617054300a2e0b3515dda0cea_th.jpeg"];
    
    NSArray *arr2 = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505388844481&di=7e70b8cc0276001b6a612feaca79d2e7&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201507%2F24%2F20150724065246_myCKz.jpeg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505388844480&di=5e1eb8cc6ebcfac3083c767f8150ad14&imgtype=0&src=http%3A%2F%2Fs7.rr.itc.cn%2Fg%2FwapChange%2F20153_18_9%2Fa8q8q79359434422520.jpeg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505388844480&di=5e1eb8cc6ebcfac3083c767f8150ad14&imgtype=0&src=http%3A%2F%2Fs7.rr.itc.cn%2Fg%2FwapChange%2F20153_18_9%2Fa8q8q79359434422520.jpeg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505388844480&di=a1155b743c7017a19c2b84b487a4e96e&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20161219%2F5b2149b617054300a2e0b3515dda0cea_th.jpeg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505388844480&di=5e1eb8cc6ebcfac3083c767f8150ad14&imgtype=0&src=http%3A%2F%2Fs7.rr.itc.cn%2Fg%2FwapChange%2F20153_18_9%2Fa8q8q79359434422520.jpeg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505388844480&di=a1155b743c7017a19c2b84b487a4e96e&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20161219%2F5b2149b617054300a2e0b3515dda0cea_th.jpeg"];
    
    
    NSArray *arr3 = @[
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505388844480&di=5e1eb8cc6ebcfac3083c767f8150ad14&imgtype=0&src=http%3A%2F%2Fs7.rr.itc.cn%2Fg%2FwapChange%2F20153_18_9%2Fa8q8q79359434422520.jpeg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505388844480&di=a1155b743c7017a19c2b84b487a4e96e&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20161219%2F5b2149b617054300a2e0b3515dda0cea_th.jpeg"];
    
    NSDictionary *dic1 = @{@"images" : arr2,
                           @"title" : @"我就是个标题"};
    
    NSDictionary *dic2 = @{@"images" : arr1,
                           @"title" : @""};
    
    NSDictionary *dic3 = @{@"images" : arr3,
                           @"title" : @"标题再长，我设置的就只显示一行啊，就像这样，很长很长，也不过是一行，多行自己设置啊"};
    
    [self.dataArray addObjectsFromArray:@[dic1,dic2,dic3]];
    [self.tableView reloadData];
}

// 注册cell
- (void)registerNibWithTableView {
    
    [self.tableView registerNib:[SCCommonImageCell loadNib] forCellReuseIdentifier:[SCCommonImageCell className]];
    
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
    NSDictionary *dic = self.dataArray[indexPath.row];
    return [SCCommonImageCell cellHeightWithDatas:dic[@"images"] title:dic[@"title"]];
}

// cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SCCommonImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SCCommonImageCell class]) forIndexPath:indexPath];
    NSDictionary *dic = self.dataArray[indexPath.row];
    [cell refreshCellWithImageDatas:dic[@"images"] title:dic[@"title"]];
    // 分割线 设置
    cell.separatorInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
    
    cell.imageTouchBlock = ^(NSInteger index) {
        NSLog(@"第%ld行，第%ld张图片点击了",indexPath.row, index);
        [MWBrowsePhotoHelper showBigImages:dic[@"images"] currentIndex:index controller:self];
    };
    return cell;
}


// 选中的处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end

