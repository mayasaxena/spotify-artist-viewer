//
//  SARequestManager.h
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SAAlbum;

@interface SARequestManager : NSObject

+ (instancetype)sharedManager;

- (void) getArtistsWithQuery:(NSString *)query
                     andPage:(NSString *) page
                     success:(void (^)(NSArray *artists))success
                     failure:(void (^)(NSError *error))failure;

- (void) getArtistBiographyWithID:(NSString*)artistID
                          success:(void (^)(NSString *artistBio))success
                          failure:(void (^)(NSError *error))failure;

- (void) getAlbumsWithQuery:(NSString *)query
                    andPage:(NSString *) page
                    success:(void (^)(NSArray *albums))success
                    failure:(void (^)(NSError *error))failure;

- (void) getAlbumTracksAndArtistNameWithAlbumID:(NSString *)albumID
                                        success:(void (^)(NSArray *tracks, NSString *artistName))success
                                        failure:(void (^)(NSError *error))failure;

- (void) getTracksWithQuery:(NSString *)query
                    andPage:(NSString *) page
                    success:(void (^)(NSArray *albums))success
                    failure:(void (^)(NSError *error))failure;

- (void) getAlbumWithTrackID:(NSString *)trackID
                     success:(void (^)(SAAlbum *album))success
                     failure:(void (^)(NSError *error))failure;



@end
