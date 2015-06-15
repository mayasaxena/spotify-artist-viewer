//
//  SAAlbum.m
//  spotify-artist-viewer
//
//  Created by Maya Saxena on 6/11/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAAlbum.h"

@implementation SAAlbum

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"albumName": @"name",
             @"imageURL": @"images[0].url",
             @"identifier": @"id"
             };
}


@end
