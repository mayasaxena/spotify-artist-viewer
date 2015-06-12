//
//  UIImage+SAImageScaling.m
//  spotify-artist-viewer
//
//  Created by Maya Saxena on 6/12/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "UIImage+SAImageScaling.h"


@implementation UIImage (SAImageScaling)

- (UIImage*)imageScaledToHeight: (float) i_height{
    float oldHeight = self.size.height;
    
    float scaleFactor = i_height / oldHeight;
    
    float newWidth = self.size.width * scaleFactor;
    float newHeight = oldHeight * scaleFactor;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight), NO, 0);
    [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)imageScaledToWidth: (float) i_width{
    float oldWidth = self.size.width;
    NSLog(@"%f", oldWidth);
    
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = self.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight), NO, 0);
    [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
