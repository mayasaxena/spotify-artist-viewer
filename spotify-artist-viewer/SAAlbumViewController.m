//
//  SAAlbumViewController.m
//  spotify-artist-viewer
//
//  Created by Maya Saxena on 6/11/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//


#import <SDWebImage/UIImageView+WebCache.h>

#import "SAAlbumViewController.h"
#import "SATrack.h"
#import "SATrackTableViewCell.h"
#import "UIImage+SAImageScaling.h"

static NSInteger const kAlbumImageSize = 150;

@interface SAAlbumViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *tracks;

@end

@implementation SAAlbumViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.albumLabel.text = self.album.albumName;
    self.artistLabel.text = self.album.artistName;
    
    [self.albumImage sd_setImageWithURL:self.album.imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.albumImage.image = [self.albumImage.image imageScaledToHeight:kAlbumImageSize];
    }];
//    self.albumImage.layer.cornerRadius = self.albumImage.frame.size.width / 4;
//    self.albumImage.clipsToBounds = YES;
//    self.albumImage.layer.borderWidth = 3.0f;
//    self.albumImage.layer.borderColor = [[UIColor grayColor] CGColor];
    
}



#pragma mark - Table View Delegate and Data Source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SATrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrackCell" forIndexPath:indexPath];
    cell.numLabel.textColor = [UIColor whiteColor];
    cell.numLabel.text = [NSString stringWithFormat:@"%ld", (long)((SATrack *)self.tracks[indexPath.row]).number];
    cell.songLabel.textColor = [UIColor whiteColor];
    cell.songLabel.text = ((SATrack *)self.tracks[indexPath.row]).name;
    cell.durationLabel.textColor = [UIColor whiteColor];
    cell.durationLabel.text = [NSString stringWithFormat:@"%ld", ((SATrack *)self.tracks[indexPath.row]).duration];
    
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tracks count];
}



@end
