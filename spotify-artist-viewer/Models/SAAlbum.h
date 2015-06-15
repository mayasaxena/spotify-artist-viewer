//
//  SAAlbum.h
//  spotify-artist-viewer
//
//  Created by Maya Saxena on 6/11/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface SAAlbum : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *albumName;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSString *identifier;



@end
