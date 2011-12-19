//
//  MusicListTableViewController.m
//  MusiXplorer
//
//  Created by Peter Friese on 19.12.11.
//  Copyright (c) 2011 http://peterfriese.de. All rights reserved.
//

#import "MusicListTableViewController.h"


@interface MusicListTableViewController()

@property (strong, nonatomic) NSMutableDictionary *images;
@property (strong, nonatomic) NSArray *albums;

- (void)fetchedData:(NSData *)responseData;
- (void)fetchData;
@end


@implementation MusicListTableViewController

@synthesize images;
@synthesize albums;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.images = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [albums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    id element = [albums objectAtIndex:[indexPath row]];
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

- (void)fetchedData:(NSData *)responseData
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    if (json) {
        id results = [json objectForKey:@"results"];
        NSLog(@"Result:%@", results);
        if ([results respondsToSelector:@selector(objectAtIndex:)]) {
            NSArray *resultsArray = (NSArray *)results;
            albums = [resultsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"collectionType == 'Album' && amgArtistId != NULL"]];
            
            [self.tableView reloadData];
        }
    }
    
}

- (void)fetchData
{
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/search?term=sophie+ellis-bextor&limit=200&country=DE&entity=album&attribute=artistTerm"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];        
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

@end
