//
//  SATrack.h
//  spotify-artist-viewer
//
//  Created by Maya Saxena on 6/12/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface SATrack : MTLModel

@property (nonatomic, strong) NSString *name;
@property NSInteger number;
@property NSInteger duration;


@end
