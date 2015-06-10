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

@interface SASearchViewController () <UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate>

@property (nonatomic) NSMutableArray *artists;
@property (nonatomic) NSMutableArray *filteredArtists;
@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic) BOOL isSearching;

@end

@implementation SASearchViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isSearching = NO;
    
    #pragma mark - SearchController
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
    
    #pragma mark - Example Artists
    
    self.artists = [[NSMutableArray alloc] init];
    self.filteredArtists = [[NSMutableArray alloc] init];
    
    SAArtist *muse = [[SAArtist alloc]init];
    muse.name = @"Muse";
    muse.imageURL = nil;
    muse.bio = @"A band called Muse";
    
    SAArtist *imagineDragons = [[SAArtist alloc]init];
    imagineDragons.name = @"Imagine Dragons";
    imagineDragons.imageURL = nil;
    imagineDragons.bio = @"A band called Imagine Dragons";
    
    SAArtist *bastille = [[SAArtist alloc]init];
    bastille.name = @"Bastille";
    bastille.imageURL = nil;
    bastille.bio = @"A band called Bastille";
    
    [self.artists addObject:muse];
    [self.artists addObject:imagineDragons];
    [self.artists addObject:bastille];
    

    
    [self.tableView reloadData];
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    if (self.isSearching) {
        return [self.filteredArtists count];
    }
    else {
        return [self.artists count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArtistCell" forIndexPath:indexPath];
    
    SAArtist *artist;
    if (self.isSearching) {
        artist = self.filteredArtists[indexPath.row];
    } else {
        artist = self.artists[indexPath.row];

    }
    cell.textLabel.text = artist.name;
    
    return cell;
}


#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"showArtist"]) {
        SAArtistViewController* artistViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        SAArtist *artist;
        if (self.isSearching) {
            artist = self.filteredArtists[indexPath.row];
        } else {
            artist = self.artists[indexPath.row];
        }
        
        artistViewController.artist = artist;
        
    }
}


#pragma mark - Search Functions

- (void)searchForText:(NSString *)searchText {
    
    NSString *predicateFormat = @"name CONTAINS[cd] %@";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchText];
    
    self.filteredArtists = [[self.artists filteredArrayUsingPredicate:predicate] mutableCopy];
    
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.isSearching = YES;
}


- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.filteredArtists removeAllObjects];
    
    
    if([searchText length] != 0) {
        self.isSearching = YES;
        [self searchForText:searchText];
    }
    else {
        self.isSearching = NO;
    }
    
    [self.tableView reloadData];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.isSearching = NO;
}




@end
