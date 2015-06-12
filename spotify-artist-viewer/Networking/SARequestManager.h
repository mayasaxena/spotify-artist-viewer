//
//  SARequestManager.h
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SARequestManager : NSObject

+ (instancetype)sharedManager;

- (void) getArtistsWithQuery:(NSString *)query
                    success:(void (^)(NSArray *artists))success
                    failure:(void (^)(NSError *error))failure;

- (void) getArtistBiographyWithID:(NSString*)artistID
                         success:(void (^)(NSString *artistBio))success
                         failure:(void (^)(NSError *error))failure;

- (void) getAlbumsWithQuery:(NSString *)query
                   success:(void (^)(NSArray *albums))success
                   failure:(void (^)(NSError *error))failure;

- (void) getAlbumTracksWithAlbumID:(NSString *)albumID
                          success:(void (^)(NSArray *tracks))success
                          failure:(void (^)(NSError *error))failure;

@end
