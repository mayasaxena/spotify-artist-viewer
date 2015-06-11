//
//  SASearchTableViewController.m
//  spotify-artist-viewer
//
//  Created by Maya Saxena on 6/9/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SASearchViewController.h"
#import "SAArtist.h"
#import "SAArtistViewController.h"
#import "SARequestManager.h"

@interface SASearchViewController () <UISearchBarDelegate>

@property (strong, nonatomic) __block NSArray *artists;
@property (nonatomic) BOOL isSearching;

@end

@implementation SASearchViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isSearching = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.artists count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArtistCell" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor whiteColor];
    SAArtist *artist = self.artists[indexPath.row];
    cell.textLabel.text = artist.name;
    
    return cell;
}


#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"showArtist"]) {
        SAArtistViewController* artistViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        SAArtist *artist = self.artists[indexPath.row];
        artistViewController.artist = artist;
        
    }
}


#pragma mark - Search Functions

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if ([searchText length] > 0) {
        
        NSString *escapedSearchText = [[searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [[SARequestManager sharedManager] getArtistsWithQuery:escapedSearchText
                                                      success:^(NSArray *artists) {
                                                          self.artists = artists;
                                                          [self.tableView reloadData];
                                                      }
                                                      failure:^(NSError *error) {
                                                          NSLog(@"%@",error);
                                                      }];
    } else {
        self.artists = nil;
        [self.tableView reloadData];
    }


}



@end
