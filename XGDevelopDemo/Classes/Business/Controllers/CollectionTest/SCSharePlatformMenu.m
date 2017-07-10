//
//  SCSharePlatformMenu.m
//  XGDevelopDemo
//
//  Created by 小广 on 2017/6/10.
//  Copyright © 2017年 小广. All rights reserved.
//

#import "SCSharePlatformMenu.h"
#import "SCShareCollectionViewCell.h"

#define SCCellSize             (XGScreenWidth - 3.0f) / 4.0

@interface SCSharePlatformMenu () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *shareWayArray;

@end

@implementation SCSharePlatformMenu

- (instancetype)initWithShareWay:(SCShareWay)shareWay {
    CGRect rect = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:rect];
    if (self) {
        [self setupDataWithShareWay:shareWay];
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDataWithShareWay:SCShareWayAll];
        [self setupView];
    }
    return self;
}

#pragma mark - 对外方法 Public Methods

- (void)presentMenu:(BOOL)animate {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
        self.collectionView.top = XGScreenHeight - SCCellSize;
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
}

#pragma mark - 代理方法 Delegate Methods
// 设置分区

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.shareWayArray.count;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SCShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SCShareCollectionViewCell className] forIndexPath:indexPath];
    
    if (self.shareWayArray.count > 0) {
        NSDictionary *dic = self.shareWayArray[indexPath.row];
        [cell refreshViewWithTitle:dic[@"title"] imageName:dic[@"imageName"]];
    }
    //[cell borderForColor:UIColorFromHexValue(0xAAAAAA) borderWidth:0.8f borderType:UIBorderSideTypeLeft];
    return cell;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat sizeMax = SCCellSize;
    return CGSizeMake(sizeMax,sizeMax);
}


// 设置UIcollectionView整体的内边距（这样item不贴边显示）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    return UIEdgeInsetsMake(CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN);
}

// 设置minimumLineSpacing：cell上下之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5f;
}

// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectPlatformType) {
        self.selectPlatformType(indexPath.row);
    }
    
    [self dismiss];
}

/// 手势的代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    /// 点触区域，不在网格区域内，方可关闭
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGPoint tapPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
    
    if (rect.size.height - tapPoint.y < SCCellSize) {
        /// 表示在网格区域内，手势不做响应
        return NO;
    }
    return YES;
}

#pragma mark - 内部方法 Private Methods
// 注册cell
- (void)registerNibWithTableView {
    [self.collectionView registerNib:[SCShareCollectionViewCell loadNib] forCellWithReuseIdentifier:[SCShareCollectionViewCell className]];
}

- (void)setupView {
    
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    
    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewDidTouch:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    
    
    if (!self.collectionView) {
        // 1.创建流水布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0,XGScreenHeight, XGScreenWidth, SCCellSize) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        //self.collectionView.collectionViewLayout = layout;
    }
    self.collectionView.scrollEnabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self registerNibWithTableView];
    
    [self addSubview:self.collectionView];
}

- (void)setupDataWithShareWay:(SCShareWay)shareWay {
    
    [self.shareWayArray removeAllObjects];
    NSArray *tempArray = nil;
    
    if (shareWay == SCShareWayAll) {
        tempArray = @[@{@"imageName":@"wechat_icon", @"title":@"微信好友"},
                      @{@"imageName":@"qq_icon", @"title":@"QQ"},
                      @{@"imageName":@"sms_icon", @"title":@"短信"}];
    } else if (shareWay == SCShareWayNoSMS) {
        tempArray = @[@{@"imageName":@"wechat_icon", @"title":@"微信好友"},
                      @{@"imageName":@"qq_icon", @"title":@"QQ"}];
    }
    
    if (tempArray.count > 0) {
        [self.shareWayArray addObjectsFromArray:tempArray];
    }
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.collectionView.top = XGScreenHeight;
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 点击/触碰事件 Action Methods

- (void)coverViewDidTouch:(UITapGestureRecognizer *)gesture {
    [self dismiss];
}

#pragma mark - 懒加载 Lazy Load

- (NSMutableArray *)shareWayArray {
    if (!_shareWayArray) {
        _shareWayArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _shareWayArray;
}

@end
