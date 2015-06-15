//
//  SAAlbumViewController.h
//  spotify-artist-viewer
//
//  Created by Maya Saxena on 6/11/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAAlbum.h"

@interface SAAlbumViewController : UIViewController

@property (strong, nonatomic) SAAlbum *album;
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property NSInteger selectedTrackNumber;
@property (nonatomic, strong) NSString *selectedTrackID;

@end
