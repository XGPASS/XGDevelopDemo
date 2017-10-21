//
//  SCBrowsePhotoHelper.m
//  XGDevelopDemo
//
//  Created by sunyongguang on 2017/10/19.
//  Copyright © 2017年 小广. All rights reserved.
//

#import "SCBrowsePhotoHelper.h"
#import "MWPhotoBrowser.h"
#import "MWPhotoBrowser+Ext.h"

@interface SCBrowsePhotoHelper () <MWPhotoBrowserDelegate>

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) MWPhotoBrowser *browser;
@property (nonatomic, copy) NSArray *photos;

@end


@implementation SCBrowsePhotoHelper

+ (instancetype)browseBigPhotos:(NSArray<NSString *> *)photos
                   currentIndex:(NSInteger)index
                     controller:(UIViewController *)controller {
    SCBrowsePhotoHelper *helper = [[SCBrowsePhotoHelper alloc] initWithPhotos:photos currentIndex:index controller:controller];
    return helper;
}

- (id)initWithPhotos:(NSArray<NSString *> *)photos
        currentIndex:(NSInteger)index
          controller:(UIViewController *)controller {
    if (self = [super init]) {
        
        self.photos = photos;
        self.index = index;
        self.controller = controller;
        
        self.browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        // 是否显示分享按钮
        self.browser.displayActionButton = NO;
        // 底部前进后退的按钮
        self.browser.displayNavArrows = NO;
        // 选中的按钮(右上角)
        self.browser.displaySelectionButtons = NO;
        // 导航条底部的tabbar是否一直显示
        self.browser.alwaysShowControls = NO;
        // 放大以填充
        self.browser.zoomPhotosToFill = YES;
        // 是否允许查看所有图片缩略图的网格
        self.browser.enableGrid = YES;
        self.browser.enableSwipeToDismiss = YES;
        [self.browser showNextPhotoAnimated:YES];
        [self.browser showPreviousPhotoAnimated:YES];
        [self.browser setCurrentPhotoIndex:self.index];
        
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:self.browser];
        navVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.controller presentViewController:navVC animated:YES completion:nil];
    }
    return self;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return [MWPhoto photoWithURL:[NSURL URLWithString:self.photos[index]]];;
}

@end
