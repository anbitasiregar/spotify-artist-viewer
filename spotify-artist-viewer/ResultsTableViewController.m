//
//  ResultsTableViewController.m
//  spotify-artist-viewer
//
//  Created by Anbita Siregar on 6/9/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "ResultsTableViewController.h"
#import "SARequestManager.h"
#import "SAArtist.h"
#import "ArtistViewController.h"

@interface ResultsTableViewController ()
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *artistArray;
@property (strong, nonatomic) IBOutlet UITableView *resultsTable;

@end

@implementation ResultsTableViewController

@synthesize artistArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.searchBar setBackgroundColor:[UIColor blackColor]];
}

#pragma mark - search bar methods

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self handleSearch:searchBar];
}

- (void) searchBarSearchButtonClicked: (UISearchBar *) searchBar {
    [self handleSearch:searchBar];
}

- (void) searchBarTextDidEndEditing: (UISearchBar *) searchBar {
    [self handleSearch:searchBar];
}

- (void) handleSearch: (UISearchBar *) searchBar {
    NSLog(@"User searched for %@", searchBar.text);
    NSString *queryString = searchBar.text;
    //[searchBar resignFirstResponder];
    
    [[SARequestManager sharedManager] getArtistsWithQuery:queryString success:^(NSArray *artists) {
            artistArray = artists;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - Table view data source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [artistArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *TableViewCellIdentifier = @"ArtistCells";

    UITableViewCell *cellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                       reuseIdentifier:TableViewCellIdentifier];
    
    if (self.artistArray.count > 0) {
        SAArtist *artist = [self.artistArray objectAtIndex:indexPath.row];
        NSString *artistName = artist.name;
        cellView.textLabel.text = [NSString stringWithFormat:@"%@", artistName];
    }
    [cellView.textLabel setTextColor:[UIColor whiteColor]];
    [cellView setBackgroundColor:[UIColor clearColor]];
    return cellView;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //segue to artist details
    
    [self performSegueWithIdentifier:@"artistDetail" sender:self.tableView];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"artistDetail"]) {
        ArtistViewController *artistViewController = [segue destinationViewController];
        
        if (sender == self.searchDisplayController.searchResultsTableView) {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            //NSString *destinationTitle = [[artistArray objectAtIndex:[indexPath row]] name];
            //[artistViewController setTitle:destinationTitle];
            artistViewController.artist = [artistArray objectAtIndex:[indexPath row]];
            NSLog(@"artist passed was %@", artistViewController.artist.name);
        } else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            //NSString *destinationTitle = [[artistArray objectAtIndex:[indexPath row]] name];
            //[artistViewController setTitle:destinationTitle];
            artistViewController.artist = [artistArray objectAtIndex:[indexPath row]];
            NSLog(@"artist passed was %@", artistViewController.artist.name);
        }
    }
}


@end
