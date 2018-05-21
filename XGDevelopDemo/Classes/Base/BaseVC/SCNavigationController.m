//
//  SCNavigationController.m
//  SuperCommunity
//
//  Created by MCDuff on 16/3/9.
//  Copyright © 2016年 All. All rights reserved.
//

#import "SCNavigationController.h"
#import "SCNavigationControllerProtocol.h"

@interface UINavigationController (UInavigationControllerNeedshouldPopItem)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item;

@end

@interface SCNavigationController () <UINavigationBarDelegate>

@end

@implementation SCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    [super pushViewController:viewController animated:animated];
}


- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    UIViewController *vc = self.topViewController;
    if (item!=vc.navigationItem) {
        return [super navigationBar:navigationBar shouldPopItem:item];
    }
    if ([vc conformsToProtocol:@protocol(SCNavigationControllerProtocol)]) {
        if ([(id<SCNavigationControllerProtocol>)vc sc_navigationControllerShouldPopWhenBackItemSelected:self]) {
            return [super navigationBar:navigationBar shouldPopItem:item];
        }else{
            for(UIView *subview in [navigationBar subviews]) {
                if(0. < subview.alpha && subview.alpha < 1.) {
                    [UIView animateWithDuration:.25 animations:^{
                        subview.alpha = 1.;
                    }];
                }
            }
            return NO;
        }
    }else{
        return [super navigationBar:navigationBar shouldPopItem:item];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
