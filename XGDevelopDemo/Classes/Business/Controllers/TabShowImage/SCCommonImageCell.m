//
//  SCCommonImageCell.m
//  Butler
//
//  Created by sunyongguang on 2017/9/14.
//  Copyright © 2017年 UAMA Inc. All rights reserved.
//  通用的显示图片的cell（内部使用了UICollectionView）

#import "SCCommonImageCell.h"
#import "SCImageCollectionCell.h"

/// cell 上下左右之间的距离
#define SCCellMargin             10.0f
/// collectionView内边距
#define SCInsetMargin            15.0f
/// collectionView离顶部的距离
#define SCTopMargin              30.0f
/// cell的大小
#define SCImageSize             (XGScreenWidth - (2 * SCCellMargin + 3 * SCInsetMargin)) / 4


@interface SCCommonImageCell () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/// collectionView离顶部的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
/// 显示的图片的数组
@property (nonatomic, strong) NSMutableArray *imageArray;

@end


@implementation SCCommonImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.titleLabel.textColor = HEXCOLOR(0x334455);
    [self setupView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupView {
    
    self.collectionView.scrollEnabled = NO;
    // 1.创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView.collectionViewLayout = layout;
    [self registerNibWithTableView];
}

#pragma mark - 代理方法 Delegate Methods
// 设置分区

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SCImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SCImageCollectionCell class]) forIndexPath:indexPath];
    [cell refreshCellWithImage:self.imageArray[indexPath.row]];
    return cell;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat sizeMax = SCImageSize;
    return CGSizeMake(sizeMax,sizeMax);
}


// 设置UIcollectionView整体的内边距（这样item不贴边显示）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    return UIEdgeInsetsMake(SCInsetMargin, SCInsetMargin, SCInsetMargin, SCInsetMargin);
}

// 设置minimumLineSpacing：cell上下之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return SCCellMargin;
}

// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return SCCellMargin;
}

// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.imageTouchBlock) {
        self.imageTouchBlock(indexPath.row);
    }
}

#pragma mark - 对外方法 Public Methods
/// array数组里面放的元素 要么是UIImage类型，要么是string类型, 高度别忘了有title的高度
- (void)refreshCellWithImageDatas:(NSArray *)array title:(NSString *)title  {
    [self.imageArray removeAllObjects];
    [self.imageArray addObjectsFromArray:array];
    [self.collectionView reloadData];
    self.titleLabel.text = ISNULL(title);
    BOOL showTitle = ISNULL(title).length > 0 ? YES : NO;
    [self restTitleShow:showTitle];
    
}

/// cell 的高度
+ (CGFloat)cellHeightWithDatas:(NSArray *)array title:(NSString *)title {
    
    /// 计算有几行图片（小数）
    CGFloat tempNum = array.count / 4.0;
    /// 计算有几行图片（整数）例：3.2 得到的lastNum为 4
    NSInteger lastNum = (NSInteger)ceil(tempNum);
    /// 计算所有图片的高度
    CGFloat allImageHeight = lastNum * SCImageSize;
    /// 计算所有间隙的值
    CGFloat allMargin = 2 * SCInsetMargin + (lastNum - 1) * SCCellMargin;
    
    CGFloat titleHeight = 0.0f;
    if (title.length > 0) {
        titleHeight = 30.0f;
    }
    /// 计算最终高度高度
    return allImageHeight + allMargin + titleHeight;
}

#pragma mark - 内部方法 Private Methods
// 注册cell
- (void)registerNibWithTableView {
    [self.collectionView registerNib:[SCImageCollectionCell loadNib] forCellWithReuseIdentifier:NSStringFromClass([SCImageCollectionCell class])];
}

/// 是否显示title
- (void)restTitleShow:(BOOL)show {
    self.titleLabel.hidden = !show;
    self.topMargin.constant = show ? SCTopMargin : 0.0f;
    
}

#pragma mark - 点击/触碰事件 Action Methods

#pragma mark - 懒加载 Lazy Load

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageArray;
}

@end
