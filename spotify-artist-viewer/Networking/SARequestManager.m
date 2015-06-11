//
//  SARequestManager.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SARequestManager.h"
#import "SAArtist.h"
#import <AFNetworking/AFNetworking.h>

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

- (void)getArtistsWithQuery:(NSString *)query
                    success:(void (^)(NSArray *artists))success
                    failure:(void (^)(NSError *error))failure {
    // TODO: make network calls to spotify API
    //?q=Muse&type=artist
    
    NSString *host = @"https://api.spotify.com/v1/search?type=artist&q=";
    
    NSString *searchURL = [host stringByAppendingString:query];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:searchURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [manager GET:searchURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *bio = @"";
        
        NSDictionary *biographies = [[responseObject objectForKey:@"response"] objectForKey:@"biographies"];
        for (NSDictionary *biography in biographies) {
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






@end
