//
//  SARequestManager.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Mantle/Mantle.h>

#import "SAAlbum.h"
#import "SAArtist.h"
#import "SATrack.h"
#import "SARequestManager.h"

@implementation SARequestManager

+ (instancetype)sharedManager {
    // creates token so only one instance
    static dispatch_once_t onceToken;
    
    // object to be returned
    static id shared = nil;
    
    //Executes a block object only once for the lifetime of an application
    dispatch_once(&onceToken, ^{
        shared = [SARequestManager new];
    });
    return shared;
}

- (void) getArtistsWithQuery:(NSString *)query
                     andPage:(NSString *) page
                     success:(void (^)(NSArray *artists))success
                     failure:(void (^)(NSError *error))failure {
    
   NSString *searchURL = [NSString stringWithFormat:@"https://api.spotify.com/v1/search?offset=%@&limit=20&type=artist&q=%@", page, query];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:searchURL parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableArray *artists = [[NSMutableArray alloc] init];

            NSDictionary *artistDict =[[responseObject objectForKey:@"artists"] objectForKey:@"items"];

            for (NSDictionary *artistInfo in artistDict) {
                SAArtist *artist = [[SAArtist alloc] init];

                artist.name = [artistInfo objectForKey:@"name"];
                artist.identifier = [artistInfo objectForKey:@"id"];
                
                NSString *imageUrl = [[[artistInfo objectForKey:@"images"] firstObject] objectForKey:@"url"];
                artist.imageURL = [NSURL URLWithString: imageUrl];
                
                artist.bio = @"Loading...";
                [artists addObject:artist];
            }

            if (success) {
                success(artists);
            }
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            if (failure) {
                failure(error);
            }
    }];
    
}

- (void) getArtistBiographyWithID:(NSString *)artistID
                          success:(void (^)(NSString *artistBio))success
                          failure:(void (^)(NSError *error))failure {
    
    
    NSString *host = @"http://developer.echonest.com/api/v4/artist/biographies?api_key=4JKZ9YVDBABLYS8ZP&id=spotify:artist:";
    NSString *searchURL = [host stringByAppendingString:artistID];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:searchURL parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *bio = @"";

            NSDictionary *biographies = [[responseObject objectForKey:@"response"] objectForKey:@"biographies"];
            for (NSDictionary *biography in biographies) {
                // Find first non-truncated bio
                if (![biography objectForKey:@"truncated"]) {
                    bio = [biography objectForKey:@"text"];
                    break;
                }
            }

            if (success) {
                success(bio);
            }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            if (failure) {
                failure(error);
            }
    }];
    
}

- (void) getAlbumsWithQuery:(NSString *)query
                    andPage:(NSString *) page
                    success:(void (^)(NSArray *albums))success
                    failure:(void (^)(NSError *error))failure {
    
    NSString *searchURL = [NSString stringWithFormat:@"https://api.spotify.com/v1/search?offset=%@&limit=20&type=album&q=%@", page, query];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:searchURL parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSMutableArray *albums = [[NSMutableArray alloc] init];
             
             NSDictionary *albumDict =[[responseObject objectForKey:@"albums"] objectForKey:@"items"];
             
             for (NSDictionary *albumInfo in albumDict) {
                 SAAlbum *album = [[SAAlbum alloc] init];
                 
                 album.albumName = [albumInfo objectForKey:@"name"];
                 album.identifier = [albumInfo objectForKey:@"id"];
                 
                 NSString *imageUrl = [[[albumInfo objectForKey:@"images"] firstObject] objectForKey:@"url"];
                 album.imageURL = [NSURL URLWithString: imageUrl];
              
                 [albums addObject:album];
             }
             
             if (success) {
                 success(albums);
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             
             if (failure) {
                 failure(error);
             }
         }];
    
}

- (void) getAlbumTracksAndArtistNameWithAlbumID:(NSString *)albumID
                          success:(void (^)(NSArray *tracks, NSString *artistName))success
                          failure:(void (^)(NSError *error))failure {
    
    NSString *searchURL = [NSString stringWithFormat:@"https://api.spotify.com/v1/albums/%@", albumID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:searchURL parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSMutableString *name = [NSMutableString new];
             NSArray *artists =[responseObject objectForKey:@"artists"];
             for (NSDictionary *artistInfo in artists) {
                 if (artistInfo != [artists lastObject]) {
                     [name appendFormat:@"%@, ", [artistInfo objectForKey:@"name"]];
                 } else {
                     [name appendString:[artistInfo objectForKey:@"name"]];
                 }
                 
             }
             
             NSArray *tracks = [self getTracksFromSpotifyTrackObject:responseObject];

             if (success) {
                 success(tracks, [name copy]);
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Loading album viewer Error: %@", error);
             
             if (failure) {
                 failure(error);
             }
         }];

    
}

- (void) getAlbumWithTrackID:(NSString *)trackID
                                    success:(void (^)(SAAlbum *album))success
                                    failure:(void (^)(NSError *error))failure {
    
    NSString *searchURL = [NSString stringWithFormat:@"https://api.spotify.com/v1/tracks/%@", trackID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:searchURL parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary* albumDictionary = [responseObject objectForKey:@"album"];
//             SAAlbum *album = [MTLJSONAdapter modelOfClass:[SAAlbum class] fromJSONDictionary:albumDictionary error:nil];
             SAAlbum *album = [[SAAlbum alloc] init];
             
             album.albumName = [albumDictionary objectForKey:@"name"];
             album.identifier = [albumDictionary objectForKey:@"id"];
             
             NSString *imageUrl = [[[albumDictionary objectForKey:@"images"] firstObject] objectForKey:@"url"];
             album.imageURL = [NSURL URLWithString: imageUrl];
             
             if (success) {
                 success(album);
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Album with track idError: %@", error);
             
             if (failure) {
                 failure(error);
             }
         }];
    
}


- (void) getTracksWithQuery:(NSString *)query
                    andPage:(NSString *) page
                    success:(void (^)(NSArray *albums))success
                    failure:(void (^)(NSError *error))failure {

NSString *searchURL = [NSString stringWithFormat:@"https://api.spotify.com/v1/search?offset=%@&limit=20&type=track&q=%@", page, query];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:searchURL parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSArray *tracks = [self getTracksFromSpotifyTrackObject:responseObject];
             
             if (success) {
                 success(tracks);
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Track query Error: %@", error);
             
             if (failure) {
                 failure(error);
             }
         }];
    
}

- (NSArray *) getTracksFromSpotifyTrackObject:(id) responseObject {
    
    NSArray *trackArray =[[responseObject objectForKey:@"tracks"] objectForKey:@"items"];
    
    return [MTLJSONAdapter modelsOfClass:[SATrack class] fromJSONArray:trackArray error:nil];
}




@end
