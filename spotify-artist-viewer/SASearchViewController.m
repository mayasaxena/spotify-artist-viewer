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
#import "SAAlbum.h"
#import "SAAlbumViewController.h"
#import "SARequestManager.h"
#import "SATrack.h"

typedef NS_ENUM(NSInteger, SASearchType) {
    SAArtistSearchType = 0,
    SAAlbumSearchType = 1,
    SATrackSearchType = 2
};

@interface SASearchViewController () <UISearchBarDelegate>

@property (strong, nonatomic) __block NSArray *results;
@property (nonatomic) BOOL isSearching;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SASearchViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return [self.results count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (self.searchBar.selectedScopeButtonIndex == SAArtistSearchType) {
        SAArtist *artist = self.results[indexPath.row];
        cell.textLabel.text = artist.name;
    } else if (self.searchBar.selectedScopeButtonIndex == SAAlbumSearchType ) {
        SAAlbum *album = self.results[indexPath.row];
        cell.textLabel.text = album.albumName;
    } else if (self.searchBar.selectedScopeButtonIndex == SATrackSearchType ) {
        SAAlbum *album = self.results[indexPath.row];
        cell.textLabel.text = album.albumName;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchBar.selectedScopeButtonIndex == SAArtistSearchType) {
        [self performSegueWithIdentifier:@"showArtist" sender:self];
    } else if (self.searchBar.selectedScopeButtonIndex == SAAlbumSearchType ||
               self.searchBar.selectedScopeButtonIndex == SATrackSearchType) {
        [self performSegueWithIdentifier:@"showAlbum" sender:self];

    }
}


#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"showArtist"]) {
        SAArtistViewController* artistViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        SAArtist *artist = self.results[indexPath.row];
        artistViewController.artist = artist;
        
    } else if ([segue.identifier isEqual:@"showAlbum"]) {
        SAAlbumViewController* albumViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        SAAlbum *album = self.results[indexPath.row];
        albumViewController.album = album;
    }
}


#pragma mark - Search Functions

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self searchForText:searchBar.text];

}

- (void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    
    [self searchForText:searchBar.text];
    
}


- (void) searchForText:(NSString *)searchText {
    self.results = nil;
    [self.tableView reloadData];
    if ([searchText length] > 0) {
        
        NSString *escapedSearchText = [[searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        if (self.searchBar.selectedScopeButtonIndex == SAArtistSearchType) {
            
            [[SARequestManager sharedManager] getArtistsWithQuery:escapedSearchText
                                                          success:^(NSArray *artists) {
                                                              self.results = artists;
                                                              [self.tableView reloadData];
                                                          }
                                                          failure:^(NSError *error) {
                                                              NSLog(@"%@",error);
                                                          }];
            
        } else if (self.searchBar.selectedScopeButtonIndex == SAAlbumSearchType) {
            
            [[SARequestManager sharedManager] getAlbumsWithQuery:escapedSearchText
                                                          success:^(NSArray *albums) {
                                                              self.results = albums;
                                                              [self.tableView reloadData];
                                                          }
                                                          failure:^(NSError *error) {
                                                              NSLog(@"%@",error);
                                                          }];
            
        } else if (self.searchBar.selectedScopeButtonIndex == SATrackSearchType) {
            
            [[SARequestManager sharedManager] getAlbumsWithTracksContainingQuery:escapedSearchText
                                                         success:^(NSArray *albums) {
                                                             self.results = albums;
                                                             [self.tableView reloadData];
                                                         }
                                                         failure:^(NSError *error) {
                                                             NSLog(@"%@",error);
                                                         }];
        
        } else {
            self.results = nil;
            [self.tableView reloadData];
        }
    }
}



@end
