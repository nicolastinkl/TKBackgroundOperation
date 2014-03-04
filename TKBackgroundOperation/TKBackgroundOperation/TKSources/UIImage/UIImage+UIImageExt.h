//
//  UIImage+UIImageExt.h
//  TKBackgroundOperation
//
//  Created by apple on 3/4/14.
//  Copyright (c) 2014 goe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageExt)

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize  ;
@end
