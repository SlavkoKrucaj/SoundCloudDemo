//
//  UIImage+Crop.m
//  SoundcloudDemo
//
//  Created by Slavko Krucaj on 19.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "UIImage+Crop.h"

@implementation UIImage (Crop)

- (UIImage *)crop:(CGRect)rect {
    
    if (self.scale > 1.0) {
        
        rect = CGRectMake(rect.origin.x*self.scale,
                          rect.origin.y*self.scale,
                          rect.size.width*self.scale,
                          rect.size.height*self.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return result;
}

@end
