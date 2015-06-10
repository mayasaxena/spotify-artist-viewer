//
//  SAArtistViewController.m
//  spotify-artist-viewer
//
//  Created by Maya Saxena on 6/9/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAArtistViewController.h"
#import "SAArtist.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SAArtistViewController ()


@end

@implementation SAArtistViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.artistLabel.text = self.artist.name;
    self.artistBio.text = self.artist.bio;
    [self.artistImage sd_setImageWithURL:self.artist.imageURL];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
