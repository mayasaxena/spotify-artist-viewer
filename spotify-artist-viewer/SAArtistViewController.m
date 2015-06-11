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
    [self.artistImage sd_setImageWithURL:self.artist.imageURL];
    self.artistImage.layer.cornerRadius = self.artistImage.frame.size.width / 4;
    self.artistImage.clipsToBounds = YES;
    self.artistImage.layer.borderWidth = 3.0f;
    
    self.artistImage.layer.borderColor = [[UIColor grayColor] CGColor];
    
    [self getArtistBioWithID:self.artist.identifier];
    // Do any additional setup after loading the view.
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
