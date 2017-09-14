//
//  SCImageCollectionCell.m
//  Butler
//
//  Created by 小广 on 2017/3/1.
//  Copyright © 2017年 UAMA Inc. All rights reserved.
//  添加图片页面的网格的cell

#import "SCImageCollectionCell.h"
#import "UIImageView+WebCache.h"

@interface SCImageCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SCImageCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.cornerRadius = 3.0f;
}

- (void)refreshCellWithImage:(id)image {
    // 默认图片
    if ([image isKindOfClass:[UIImage class]]) {
        // 从相册直接选的
        self.imageView.image = (UIImage *)image;
    } else if ([image isKindOfClass:[NSString class]]) {
        
        NSString *imageString = (NSString *)image;
        if ([imageString hasPrefix:@"http://"] || [imageString hasPrefix:@"https://"]) {
            // 从服务器获取的Url
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageString]
                         placeholderImage:[UIImage imageNamed:@"placeholder-67"]];
        } else {
            /// 本地图片
            if (imageString.length > 0) {
                self.imageView.image = [UIImage imageNamed:imageString];
            }
        }
        
    } else {
        /// 其他不适image和string的，显示默认图
        self.imageView.image = [UIImage imageNamed:@"placeholder-67"];
    }
}

@end
