//
//  SATrack.m
//  spotify-artist-viewer
//
//  Created by Maya Saxena on 6/12/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SATrack.h"

@implementation SATrack

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"number": @"track_number",
             @"duration": @"duration_ms",
             @"identifier": @"id"
             };
}




@end

