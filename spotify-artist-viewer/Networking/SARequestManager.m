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
                    success:(void (^)(NSArray *artists))success
                    failure:(void (^)(NSError *error))failure {
    
    NSString *host = @"https://api.spotify.com/v1/search?type=artist&q=";
    NSString *searchURL = [host stringByAppendingString:query];
    
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
                   success:(void (^)(NSArray *albums))success
                   failure:(void (^)(NSError *error))failure {
    
    NSString *host = @"https://api.spotify.com/v1/search?type=album&q=";
    NSString *searchURL = [host stringByAppendingString:query];
    
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
             
             NSMutableArray *tracks = [[NSMutableArray alloc] init];
             
             NSDictionary *trackDict =[[responseObject objectForKey:@"tracks"] objectForKey:@"items"];
             
             for (NSDictionary *trackInfo in trackDict) {
                 SATrack *track = [[SATrack alloc] init];
                 
                 track.name = [trackInfo objectForKey:@"name"];
                 track.number = [[trackInfo objectForKey:@"track_number"] integerValue];
                 track.duration = [[trackInfo objectForKey:@"duration_ms"] integerValue];
                 track.identifier = [trackInfo objectForKey:@"id"];
                 [tracks addObject:track];
             }
//             NSLog(@"%@", responseObject);
//             NSError *error;
//             NSArray *tracks = [MTLJSONAdapter modelsOfClass:[SATrack class] fromJSONArray:[responseObject objectForKey:@"items"] error:&error];
             if (success) {
//                 NSLog(@"%lu", (unsigned long)[tracks count]);
                 success(tracks, [name copy]);
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             
             if (failure) {
                 failure(error);
             }
         }];

    
}

- (void) getAlbumsWithTracksContainingQuery:(NSString *)query
                                    success:(void (^)(NSArray *albums))success
                                    failure:(void (^)(NSError *error))failure {
    
    NSString *host = @"https://api.spotify.com/v1/search?type=track&q=";
    NSString *searchURL = [host stringByAppendingString:query];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:searchURL parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSMutableArray *albums = [[NSMutableArray alloc] init];
             
             NSArray *resultsArray =[[responseObject objectForKey:@"tracks"] objectForKey:@"items"];
             
             for (NSDictionary *result in resultsArray) {
                 SAAlbum *album = [[SAAlbum alloc] init];
                 NSDictionary* albumInfo = [result objectForKey:@"album"];
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



@end
