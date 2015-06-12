//
//  SATrackTableViewCell.h
//  spotify-artist-viewer
//
//  Created by Maya Saxena on 6/12/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SATrackTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end
