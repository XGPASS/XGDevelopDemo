//
//  UIDynamicImageTestController.m
//  XGDevelopDemo
//
//  Created by sunyongguang on 2017/10/13.
//  Copyright © 2017年 小广. All rights reserved.
//

#import "UIDynamicImageTestController.h"

@interface UIDynamicImageTestController ()
// 拖了一个UIImageView控件,并设置图片
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
// 物理仿真器
@property (strong, nonatomic) UIDynamicAnimator *animator ;

@end

@implementation UIDynamicImageTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // 获取触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    //捕捉行为
    //1.物理仿真器
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    // 2.创建捕捉行为
    // 只要遵守UIDynamicItem协议的对象，我们称这个对象为 “物理仿真元素”
    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:self.pictureView snapToPoint:point];
    // dampoint取值只能 0～1
    // 振幅的幅度 值越小幅度越大，值越大幅度越小
    snapBehavior.damping = 0.3;
//    self.pictureView.center = point;
    // 3.把捕捉行为 添加到 仿真器
    [self.animator addBehavior:snapBehavior];
}

@end
