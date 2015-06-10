//
//  SAArtistViewController.h
//  spotify-artist-viewer
//
//  Created by Maya Saxena on 6/9/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SAArtist;

@interface SAArtistViewController : UIViewController

@property (strong, nonatomic) SAArtist *artist;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artistImage;
@property (weak, nonatomic) IBOutlet UITextView *artistBio;

@end
