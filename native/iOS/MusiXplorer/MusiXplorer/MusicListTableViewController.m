//
//  MusicListTableViewController.m
//  MusiXplorer
//
//  Created by Peter Friese on 19.12.11.
//  Copyright (c) 2011 http://peterfriese.de. All rights reserved.
//

#import "MusicListTableViewController.h"
#import "AlbumTrackListingViewController.h"

@implementation MusicListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Music";
    }
    return self;
}

#pragma mark - Table view data source

- (UITableViewCell *)setupCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id element = [self.elements objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = [element objectForKey:@"collectionName"];    
    cell.detailTextLabel.text = [element objectForKey:@"artistName"];
    
    NSString *thumbUrl = (NSString *)[element objectForKey:@"artworkUrl60"];
    [self updateImageForCell:cell fromUrl:thumbUrl];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Elemenst: %@", self.elements);
    
    id element = [self.elements objectAtIndex:[indexPath row]];
    
    AlbumTrackListingViewController *albumTrackListingViewController = [[AlbumTrackListingViewController alloc] init];
    albumTrackListingViewController.albumId = [element objectForKey:@"collectionId"];
    [self.navigationController pushViewController:albumTrackListingViewController animated:YES];
}

#pragma mark - Data fetching

- (NSArray *)filterResults:(NSArray *)searchresults
{
    // by filtering all Albums that do have an AMG artist id, we make sure we don't get any samplers and other trash
    return [searchresults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"collectionType == 'Album' && amgArtistId != NULL"]];
}

- (NSURL *)urlForSearchTerm:(NSString *)searchTerm
{
    NSString *searchUrl = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@&limit=200&country=DE&entity=album&attribute=artistTerm", searchTerm];
    return [NSURL URLWithString:searchUrl];    
}

@end
