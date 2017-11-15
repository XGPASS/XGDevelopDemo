//
//  SCInputCell.m
//  XGDevelopDemo
//
//  Created by sunyongguang on 2017/11/9.
//  Copyright © 2017年 小广. All rights reserved.
//  输入框

#import "SCInputCell.h"
#import "SCInputAccessoryView.h"

//缓存的输入历史记录
static NSString * const kInputHistoryRecord       = @"kInputHistoryRecord";

@interface SCInputCell () <UITextFieldDelegate>
/// 自定义的inputView
@property (nonatomic, strong) SCInputAccessoryView *inputView;
/// 显示的输入记录
@property (nonatomic, strong) NSMutableArray   *showArray;

@end

@implementation SCInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //self.textField.borderStyle = UITextBorderStyleNone;
    
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldTextDidChange) forControlEvents:UIControlEventEditingChanged|UIControlEventEditingDidEnd];
    
    self.showArray = [NSMutableArray array];
    [self loadOffenceHistory];
    self.inputView = [SCInputAccessoryView loadNibView];
    self.inputView.frame = CGRectMake(0.0, 0.0, XGScreenWidth, SCInputAccessoryViewHeight);
    //    [self.inputView refreshUIWithNameArray:self.showArray];
    self.textField.inputAccessoryView = self.inputView;
    
    kWeakSelf
    self.inputView.selectRowBlock = ^(NSInteger index, NSString *title) {
        weakSelf.textField.text = title;
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)refreshCellWithText:(NSString *)text {
    self.textField.text = ISNULL(text);
}

/// 收到内容改变的通知
- (void)textFieldTextDidChange {
    if (self.textBlock) {
        self.textBlock(self.textField.text);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self updateHistoryRecordWithName:textField.text];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.inputView refreshUIWithNameArray:self.showArray];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 处理名字输入历史记录
/// 更新历史记录 (最多八条记录)
- (void)updateHistoryRecordWithName:(NSString *)name {
    
    if ([name.trim length] == 0) {
        return;
    }
    
    if ([self.showArray containsObject:name]) {
        [self.showArray removeObject:name];
    }
    
    [self.showArray insertObject:name atIndex:0];
    
    if ([self.showArray count] > 8) {
        [self.showArray removeLastObject];
    }
    
    [self storeNameHistory];
}


/// 加载历史记录数据
- (void)loadOffenceHistory {
    NSArray *nameHistoryArray = [[NSUserDefaults standardUserDefaults] objectForKey:kInputHistoryRecord];
    [self.showArray addObjectsFromArray:nameHistoryArray];
}

/// 存历史记录数据
- (void)storeNameHistory {
    [[NSUserDefaults standardUserDefaults] setObject:[self.showArray copy] forKey:kInputHistoryRecord];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
