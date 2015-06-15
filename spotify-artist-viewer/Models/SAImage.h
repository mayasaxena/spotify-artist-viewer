//
//  SAImage.h
//  spotify-artist-viewer
//
//  Created by Maya Saxena on 6/15/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SAImage : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *url;
@property NSInteger width;
@property NSInteger height;

@end
