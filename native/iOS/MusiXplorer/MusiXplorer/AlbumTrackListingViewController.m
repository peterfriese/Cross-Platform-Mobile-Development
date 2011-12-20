//
//  AlbumTrackListingViewController.m
//  MusiXplorer
//
//  Created by Peter Friese on 20.12.11.
//  Copyright (c) 2011 http://peterfriese.de. All rights reserved.
//

#import "AlbumTrackListingViewController.h"

@implementation AlbumTrackListingViewController

@synthesize albumId;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Track listing";
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated
{
    [self fetchData:albumId];    
}

- (NSURL *)urlForSearchTerm:(NSString *)searchTerm
{
    NSString *searchUrl = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@&country=DE&entity=song", searchTerm];
    return [NSURL URLWithString:searchUrl];
}

-(NSArray *)filterResults:(NSArray *)searchresults
{
    return [searchresults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"kind == 'song'"]];
}

- (UITableViewCell *)setupCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id element = [self.elements objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = [element objectForKey:@"trackName"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", [element objectForKey:@"artistName"], [element objectForKey:@"collectionName"]];
    
    NSString *artworkUrl = [element objectForKey:@"artworkUrl60"];
    [self fetchImageForCell:cell fromUrl:artworkUrl];
    
    return cell;
}

@end
