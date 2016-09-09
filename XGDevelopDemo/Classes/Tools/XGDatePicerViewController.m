//
//  SCDatePicerViewController.m
//  SmartCommunity
//
//  Created by LHP on 15/2/6.
//  Copyright (c) 2015年 UAMA Inc. All rights reserved.
//

#import "XGDatePicerViewController.h"

@interface XGDatePicerViewController ()

@property (nonatomic, copy) ChoseDateBlock block;

@end

@implementation XGDatePicerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.datepicerView.minimumDate = self.minimumDate;
    self.datepicerView.maximumDate = self.maximumDate;
    self.datepicerView.date = self.curDate;
    self.datepicerView.datePickerMode = self.datePickerMode;
    self.titleLabel.text = self.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)choseDateFinishBlock:(ChoseDateBlock)block {
    self.block = block;
}

- (IBAction)onCancelAction:(UIButton *)sender {
    if (self.block) {
        self.block(ButtonTypeCancel, nil);
    }
}
- (IBAction)onOkAction:(UIButton *)sender {
    if (self.block) {
        self.block(ButtonTypeOK, self.datepicerView.date);
    }
}





@end
