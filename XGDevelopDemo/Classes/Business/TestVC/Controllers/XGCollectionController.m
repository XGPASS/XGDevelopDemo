//
//  XGCollectionController.m
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/30.
//  Copyright © 2016年 小广. All rights reserved.
//  网格测试

#import "XGCollectionController.h"
#import "XGCollectionCell.h"
#import "XGCollectionHeaderView.h"

@interface XGCollectionController () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation XGCollectionController

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
    self.title = @"CollectionView测试";
    // 1.创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView.collectionViewLayout = layout;
    [self registerNibWithTableView];
}

// 初始化数据
- (void)initDatas {
    self.titleArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
}

// 注册cell
- (void)registerNibWithTableView {
    [self.collectionView registerNib:[XGCollectionCell loadNib] forCellWithReuseIdentifier:[XGCollectionCell className]];
    [self.collectionView registerNib:[XGCollectionHeaderView loadNib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[XGCollectionHeaderView className]];
    
//    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
    // 添加到视图上
    
}

#pragma mark - action事件
#pragma mark - lazy load
#pragma mark - 代理方法
// 设置分区

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XGCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[XGCollectionCell className] forIndexPath:indexPath];
    cell.titleLabel.font = [UIFont fontWithName:@"Zapfino" size:16];
    cell.titleLabel.text = [NSString stringWithFormat:@"Button%@",self.titleArray[indexPath.row]];
    cell.layer.cornerRadius = 5;
    //[cell sizeToFit];
    cell.backgroundColor = [UIColor orangeColor];
    
    return cell;
}

// 返回增补视图 footerView/headerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if (kind == UICollectionElementKindSectionHeader) {
        XGCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                  withReuseIdentifier:[XGCollectionHeaderView className]
                                                                                       forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor brownColor];
        headerView.titleLabel.text = [NSString stringWithFormat:@"第%zd区",(indexPath.section + 1)];
        return headerView;
    }
    return nil;
}

// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row);
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(90.0,90.0);
}

// sectionInset：组内边距，设置UIcollectionView整体的组内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
}

// 设置minimumLineSpacing：最小行间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}


// 设置minimumInteritemSpacing：cell之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

// 设置headerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(XGScreenWidth,40.0);
}

//// 设置footerView的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    
//}


@end
