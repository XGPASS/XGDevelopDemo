//
//  UIDynamicTestController.m
//  XGDevelopDemo
//
//  Created by sunyongguang on 2017/10/13.
//  Copyright © 2017年 小广. All rights reserved.
//

#import "UIDynamicTestController.h"

@interface UIDynamicTestController ()

@property (weak, nonatomic) IBOutlet UILabel *grayLable;
@property (weak, nonatomic) IBOutlet UILabel *yellowLable;
@property (weak, nonatomic) IBOutlet UILabel *greenLable;
// 物理仿真器
@property (strong, nonatomic) UIDynamicAnimator *animator ;

@end

@implementation UIDynamicTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //1.物理仿真器
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    //2.1创建碰撞行为
    // items 设置可以碰撞元素
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.grayLable, self.yellowLable, self.greenLable]];
    // 以 参数的view 为边界
    collision.translatesReferenceBoundsIntoBoundary = YES;
    // 2.2创建“重力”仿真行为
    // items指定 可以仿真 “重力”行为元素
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.grayLable]];
    // 3.1把 重力行为 添加到 仿真器
    [self.animator addBehavior:gravity];
    // 3.2把碰撞行为 添加 到仿真器
    [self.animator addBehavior:collision];
    
}

@end
