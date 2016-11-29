//
//  UIImage+XJHResize.h
//  CCNScan
//
//  Created by abeihaha on 2016/11/29.
//  Copyright © 2016年 CCN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XJHResize)

- (UIImage *)resizedImageToSize:(CGSize)dstSize;
- (UIImage *)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;

@end
