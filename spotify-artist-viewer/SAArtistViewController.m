//
//  SAArtistViewController.m
//  spotify-artist-viewer
//
//  Created by Maya Saxena on 6/9/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAArtistViewController.h"
#import "SAArtist.h"
#import "SARequestManager.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface SAArtistViewController ()


@end

@implementation SAArtistViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.artistLabel.text = self.artist.name;
    self.artistBio.text = self.artist.bio;
    
    
    [self.artistImage sd_setImageWithURL:self.artist.imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.artistImage.image = [self imageWithImage:self.artistImage.image scaledToHeight:125];
    }];
//    
//    self.artistImage.layer.cornerRadius = self.artistImage.frame.size.width / 4;
//    self.artistImage.clipsToBounds = YES;
//    self.artistImage.layer.borderWidth = 3.0f;
//    self.artistImage.layer.borderColor = [[UIColor grayColor] CGColor];
    
    [self getArtistBioWithID:self.artist.identifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getArtistBioWithID:(NSString *)artistID {
    
    [[SARequestManager sharedManager] getArtistBiographyWithID:artistID success:^(NSString *artistBio) {
        self.artistBio.text = artistBio;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    NSLog(@"%f", oldWidth);

    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToHeight: (float) i_height
{
    float oldHeight = sourceImage.size.height;
    
    float scaleFactor = i_height / oldHeight;
    
    float newWidth = sourceImage.size.width * scaleFactor;
    float newHeight = oldHeight * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
