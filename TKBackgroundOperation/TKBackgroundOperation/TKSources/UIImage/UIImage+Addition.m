//
//  UIImage+Addition.m
//  XianchangjiaAlbum
//
//  Created by JIJIA &&&&& ljh on 12-12-13.
//  Copyright (c) 2012年 SlowsLab. All rights reserved.
//

#import "UIImage+Addition.h"

static BOOL isRetinaScreen = YES;

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.width == 640) : NO)

@implementation UIImage (Addition)

+(void)initialize{
    [super initialize];
    
    isRetinaScreen = isRetina;
}

+(UIImage *)imageWithFileName:(NSString *)imageName{
    return [self imageWithFileName:imageName type:@"png"];
}

+(UIImage *)imageWithFileName:(NSString *)imageName type:(NSString *)type{
    NSString *resource = [NSString stringWithFormat:@"%@@2x", imageName];
    if(!isRetinaScreen && ![imageName hasSuffix:@"-568h"]){
        resource = [NSString stringWithFormat:@"%@", imageName];
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
    
    return image;
}

@end
