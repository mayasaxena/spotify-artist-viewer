//
//  UIImage+SAImageScaling.h
//  spotify-artist-viewer
//
//  Created by Maya Saxena on 6/12/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SAImageScaling)

- (UIImage*)imageScaledToHeight: (float) i_height;

- (UIImage*)imageScaledToWidth: (float) i_width;


@end
