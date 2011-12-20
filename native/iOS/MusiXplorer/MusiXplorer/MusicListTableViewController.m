//
//  MusicListTableViewController.m
//  MusiXplorer
//
//  Created by Peter Friese on 19.12.11.
//  Copyright (c) 2011 http://peterfriese.de. All rights reserved.
//

#import "MusicListTableViewController.h"

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    id element = [self.elements objectAtIndex:[indexPath row]];
    cell.textLabel.text = [element objectForKey:@"collectionName"];    
    cell.detailTextLabel.text = [element objectForKey:@"artistName"];
    NSString *thumbUrl = (NSString *)[element objectForKey:@"artworkUrl60"];
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(concurrentQueue, ^{
        if (thumbUrl != nil && ![thumbUrl isKindOfClass:[NSNull class]]) {
            dispatch_sync(concurrentQueue, ^{
                NSURL *imageUrl = [NSURL URLWithString:thumbUrl];
                NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
                UIImage *image = [UIImage imageWithData:imageData];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [cell.imageView setImage:image];
                    [cell setNeedsLayout];
                });                
            });
        }
    });
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - Data fetching

- (NSArray *)filterResults:(NSArray *)searchresults
{
    return [searchresults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"collectionType == 'Album' && amgArtistId != NULL"]];
}

- (NSURL *)urlForSearchTerm:(NSString *)searchTerm
{
    NSString *searchUrl = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@&limit=200&country=DE&entity=album&attribute=artistTerm", searchTerm];
    return [NSURL URLWithString:searchUrl];    
}

@end
