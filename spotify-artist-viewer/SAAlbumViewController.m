//
//  SAAlbumViewController.m
//  spotify-artist-viewer
//
//  Created by Maya Saxena on 6/11/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//


#import <SDWebImage/UIImageView+WebCache.h>

#import "SAAlbumViewController.h"
#import "SARequestManager.h"
#import "SATrack.h"
#import "SATrackTableViewCell.h"

#import "UIImage+SAImageScaling.h"

static NSInteger const kAlbumImageSize = 150;

@interface SAAlbumViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *tracks;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    
    
    if (self.album == nil) {
        [[SARequestManager sharedManager] getAlbumWithTrackID:self.selectedTrackID
                                                      success:^(SAAlbum *album) {
                                                          self.album = album;
                                                          NSLog(@"%@", album.identifier);
                                                          [self loadAlbumView];
                                                      } failure:^(NSError *error) {
                                                          NSLog(@"%@",error);
                                                      }];
    } else {
        [self loadAlbumView];
    }
    
  
    
//    self.albumImage.layer.cornerRadius = self.albumImage.frame.size.width / 4;
//    self.albumImage.clipsToBounds = YES;
//    self.albumImage.layer.borderWidth = 3.0f;
//    self.albumImage.layer.borderColor = [[UIColor grayColor] CGColor];
    
}

- (void) loadAlbumView {
    self.albumLabel.text = self.album.albumName;
    
    [self.albumImage sd_setImageWithURL:self.album.imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.albumImage.image = [self.albumImage.image imageScaledToHeight:kAlbumImageSize];
    }];
    
    [[SARequestManager sharedManager] getAlbumTracksAndArtistNameWithAlbumID:self.album.identifier
                                                                     success:^(NSArray *tracks, NSString *artistName) {
                                                                         self.tracks = tracks;
                                                                         self.album.artistName = artistName;
                                                                         self.artistLabel.text = self.album.artistName;
                                                                         [self.tableView reloadData];
                                                                         NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.selectedTrackNumber - 1 inSection:0];
                                                                         if (self.selectedTrackNumber != 0) {
                                                                             [self.tableView selectRowAtIndexPath:newIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                                                                         }

                                                                     }
                                                                     failure:^(NSError *error) {
                                                                         NSLog(@"%@",error);
                                                                     }];

}


#pragma mark - Table View Delegate and Data Source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SATrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrackCell" forIndexPath:indexPath];
    cell.numLabel.textColor = [UIColor whiteColor];
    cell.numLabel.text = [NSString stringWithFormat:@"%ld", (long)((SATrack *)self.tracks[indexPath.row]).number];
    cell.songLabel.textColor = [UIColor whiteColor];
    cell.songLabel.text = ((SATrack *)self.tracks[indexPath.row]).name;
    cell.durationLabel.textColor = [UIColor whiteColor];
    cell.durationLabel.text = [self formatInterval:((SATrack *)self.tracks[indexPath.row]).duration];
    
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tracks count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - Formatting

- (NSString *) formatInterval: (NSTimeInterval) interval{
    unsigned long milliseconds = interval;
    unsigned long seconds = milliseconds / 1000;
    milliseconds %= 1000;
    seconds += (int) roundf(milliseconds / 1000.0);
    unsigned long minutes = seconds / 60;
    seconds %= 60;
    unsigned long hours = minutes / 60;
    minutes %= 60;
    
    NSMutableString * result = [NSMutableString new];
    
    if(hours)
        [result appendFormat: @"%lu:", hours];
    
    [result appendFormat: @"%2lu:", minutes];
    [result appendFormat: @"%.2lu", seconds];
    
    return result;
}



@end
