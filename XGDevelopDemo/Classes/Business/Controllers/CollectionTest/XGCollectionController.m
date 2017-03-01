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
#import <AddressBook/AddressBook.h>

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
    [self gainContactAuthority];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 自定义方法
/// 先判断是否授权，再判断通讯录是否已经添加过名字，最后添加联系人
- (void)gainContactAuthority {
    
    // 判断当前的授权状态是否为"用户未决定"
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        // 1. 创建通讯录对象
        ABAddressBookRef bookRef = ABAddressBookCreate();
        
        // 2. 发送通讯录授权申请
        ABAddressBookRequestAccessWithCompletion(bookRef, ^(bool granted, CFErrorRef error) {
            // 3. 根据回调, 判断是否授权成功
            if (granted) {
                NSLog(@"授权成功");
            } else {
                NSLog(@"授权失败");
            }
        });
        CFRelease(bookRef);
    }
}

/// 获取联系人
- (BOOL)gainHaveContactWithName:(NSString *)name phone:(NSString *)phone {
    
    // 2. 获取通讯录对象
    ABAddressBookRef bookRef = ABAddressBookCreate();
    
    // 3. 获取通讯录中所有的联系人信息
    CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(bookRef);
    
    BOOL hasContact = NO;
    // 4. 遍历所有的联系人信息, 获取其中需要的内容
    CFIndex count = CFArrayGetCount(arrayRef);
    for (int i = 0; i < count; i++) {
        // 4.1 创建一个记录对象
        ABRecordRef record = CFArrayGetValueAtIndex(arrayRef, i);
        // 4.2 获取姓名
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
//        NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
//        NSLog(@"%@--%@", firstName, lastName);
//        NSString *allName = [NSString stringWithFormat:@"%@%@",firstName,lastName];
        
        if ([firstName isEqualToString:name]) {
            hasContact = YES;
            break;
        }
//        // 4.3 获取电话号码
//        ABMultiValueRef mutiValue = ABRecordCopyValue(record, kABPersonPhoneProperty);
//        CFIndex count = ABMultiValueGetCount(mutiValue);
//        
//        // 5. 遍历电话号码的数组
//        for (int i = 0; i < count; i++) {
//            NSString *label = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(mutiValue, i);
//            NSString *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(mutiValue, i);
//            NSLog(@"%@--%@", label, phone);
//        }
    }
    
    // 6. 释放对象
    CFRelease(bookRef);
    CFRelease(arrayRef);
    
    return hasContact;
}

/// 添加联系人
- (void)addNewContactWithName:(NSString *)name phone:(NSString *)phone {
    // 1. 判断当前的授权状态
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        NSLog(@"请先授权");
        return;
    }
    
    if ([self gainHaveContactWithName:name phone:phone]) {
        ///
        NSLog(@"通讯录已经有该联系人");
        return;
    }
    //创建新的联系人
    CFErrorRef error = NULL;
    //创建一个通讯录操作对象
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    //创建一条新的联系人纪录
    ABRecordRef newRecord = ABPersonCreate();
    //为新联系人记录添加属性值
    ABRecordSetValue(newRecord, kABPersonFirstNameProperty, (__bridge CFTypeRef)name, &error);
    //创建一个多值属性(电话)
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)phone, kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(newRecord, kABPersonPhoneProperty, multi, &error);
    //添加记录到通讯录操作对象
    ABAddressBookAddRecord(addressBook, newRecord, &error);
    //保存通讯录操作对象
    ABAddressBookSave(addressBook, &error);
    //通过此接口访问系统通讯录
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            NSLog(@"yesyesyesyesyesyes");
        } else {
           NSLog(@"失败了");
        }
    });
    
    CFRelease(multi);
    CFRelease(newRecord);
    CFRelease(addressBook);
}



// 布局UI
- (void)initSubViews {
    self.title = @"CollectionView测试";
    self.collectionView.alwaysBounceVertical = YES; // 此属性，可让collectionView未满一屏幕也能滚动
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
    
    [self addNewContactWithName:@"浙江省-西湖区-小广" phone:@"110112120"];
    NSLog(@"%ld",(long)indexPath.row);
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat sizeMax = (XGScreenWidth - 50.0) / 4;
    return CGSizeMake(sizeMax,sizeMax);
}

// 设置UIcollectionView整体的内边距（这样item不贴边显示）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
}

// 设置minimumLineSpacing：cell上下之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}


// 设置minimumInteritemSpacing：cell左右之间最小的距离
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
