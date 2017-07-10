//
//  SCShareCollectionViewCell.m
//  SmartCommunityForFamilyTime
//
//  Created by Jianying Wan on 16/7/11.
//  Copyright © 2016年 MCDuff. All rights reserved.
//

#import "SCShareCollectionViewCell.h"

@interface SCShareCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *shareImgView;
@property (weak, nonatomic) IBOutlet UILabel *shareLbl;

@end

@implementation SCShareCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)refreshViewWithTitle:(NSString *)title imageName:(NSString *)imageName {
    
    self.shareLbl.text = ISNULL(title);
    if (ISNULL(imageName).length > 0) {
        self.shareImgView.image = [UIImage imageNamed:ISNULL(imageName)];
    }
}


@end
