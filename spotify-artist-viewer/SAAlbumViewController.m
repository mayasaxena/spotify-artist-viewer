//
//  SAAlbumViewController.m
//  spotify-artist-viewer
//
//  Created by Maya Saxena on 6/11/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//


#import <SDWebImage/UIImageView+WebCache.h>

#import "SAAlbumViewController.h"

@interface SAAlbumViewController ()

@end

@implementation SAAlbumViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.albumLabel.text = self.album.albumName;
    self.artistLabel.text = self.album.artistName;
    
    
    [self.albumImage sd_setImageWithURL:self.album.imageURL];
    self.albumImage.layer.cornerRadius = self.albumImage.frame.size.width / 4;
    self.albumImage.clipsToBounds = YES;
    self.albumImage.layer.borderWidth = 3.0f;
    self.albumImage.layer.borderColor = [[UIColor grayColor] CGColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
