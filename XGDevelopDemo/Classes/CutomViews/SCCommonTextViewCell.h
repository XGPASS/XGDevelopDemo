//
//  SCCommonTextViewCell.h
//  SuperCommunity
//
//  Created by zhanglijiong on 2017/11/23.
//  Copyright © 2017年 uama. All rights reserved.
//  通用的Cell里是textView的cell 支持自动变高

#import <UIKit/UIKit.h>

/**
 使用说明
 1、需要设置tableView的预估高度 self.tableView.estimatedRowHeight = xx.0f;
 2、需要在对应的heightForRowAtIndexPath方法里设置，该cell行高 return UITableViewAutomaticDimension;
 3、本cell的tableView参数，外部必传；
 4、设置textview的textContainerInset属性可以控制外边距
 */

@interface SCCommonTextViewCell : UITableViewCell

@property (weak, nonatomic) UITableView *tableView;
// 输入框
@property (weak, nonatomic) IBOutlet UITextView *textView;
// 输入框文字(用来改变直接赋值而改变高度)
@property (strong, nonatomic) NSString *textStr;
// 最大多少字 默认是1000(这个值会影响高度)
@property (assign, nonatomic) NSInteger MAX_LIMIT_NUMS;
// 最小高度 默认100
@property (assign, nonatomic) CGFloat minHeight;

@end
