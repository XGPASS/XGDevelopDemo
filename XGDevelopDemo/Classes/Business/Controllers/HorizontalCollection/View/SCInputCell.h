//
//  SCInputCell.h
//  XGDevelopDemo
//
//  Created by sunyongguang on 2017/11/9.
//  Copyright © 2017年 小广. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCInputCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;

/// 最终的text回调
@property (nonatomic, copy) void(^textBlock)(NSString *text);

- (void)refreshCellWithText:(NSString *)text;

@end
