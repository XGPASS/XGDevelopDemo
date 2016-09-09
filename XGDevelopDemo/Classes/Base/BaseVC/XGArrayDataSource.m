//
//  XGArrayDataSource.m
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/30.
//  Copyright © 2016年 小广. All rights reserved.
//  table分离出来的数据源

#import "XGArrayDataSource.h"

@interface XGArrayDataSource ()

@property (nonatomic, assign) BOOL hasSection;              // 是否有分组
@property (nonatomic, assign) BOOL isCanEdit;               // cell是否可编辑

@property (nonatomic, copy) TableViewCellEditingBlock editBlock;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@property (nonatomic, strong) NSArray *items;         // 临时数据源
@property (nonatomic, copy) NSString *cellIdentifier; // cell重用标识符

@end


@implementation XGArrayDataSource

- (id)init {
    return nil;
}

#pragma mark - 自定义方法

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock {
    
    self = [super init];
    if (self) {
        _items = anItems;
        _cellIdentifier = aCellIdentifier;
        _configureCellBlock = aConfigureCellBlock;
        _sectionCount = 1;
    }
    return self;
}


- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)block
         hasSection:(BOOL)hasSection
       sectionCount:(NSInteger)sectionCount {
    
    self = [super init];
    if (self) {
        _items = items;
        _cellIdentifier = cellIdentifier;
        _configureCellBlock = block;
        _hasSection = hasSection;
        _sectionCount = sectionCount < 1 ? 1 : sectionCount;
    }
    return self;
}

- (void)changeItems:(NSArray *)array {
    self.items = [array mutableCopy];
}

// cell侧滑删除的回调
- (void)configureCellEditBlock:(TableViewCellEditingBlock)block {
    self.editBlock = block;
    self.isCanEdit = (block != nil);
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sectionCount > 0 && self.hasSection) {
        return self.items[indexPath.section][indexPath.row];
    }
    
    // 防止崩溃 xcode7.3.1 array移除removeAllObjects 会有一段时间的缓存，可能会导致table刷新后crash
    NSInteger maxArrIndex = self.items.count - 1;
    NSInteger tempIndex = indexPath.row > maxArrIndex ? maxArrIndex : indexPath.row;
    // 最后判断tempIndex > -1 即判断self.items.count = 0 的情况
    return tempIndex > -1 ? self.items[tempIndex] : nil;
}


// 分组数 最少一组
- (void)setSectionCount:(NSUInteger)count {
    self.sectionCount = count > 1 ? count : 1;
}

#pragma mark - UITableViewDataSource
// 每个区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.hasSection) {
        if (self.items.count == 0) {
            return 0;
        }
        
        NSArray *array = self.items[section];
        if ([array isKindOfClass:[NSArray class]]) {
            return array.count;
        }
        return 0;
    }
    
    return self.items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionCount;
}

// 处理cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item, indexPath);
    return cell;
}

// cell侧滑删除功能
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.isCanEdit;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.editBlock(indexPath);
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // 插入新的cell 待完善
    }
}

@end
