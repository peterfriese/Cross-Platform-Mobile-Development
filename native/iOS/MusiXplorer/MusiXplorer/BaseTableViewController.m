//
//  BaseTableViewController.m
//  
//
//  Created by Peter Friese on 20.12.11.
//  Copyright (c) 2011 http://peterfriese.de. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()
@property (strong, nonatomic) UISearchDisplayController *searchController;
@end


@implementation BaseTableViewController

@synthesize elements;
@synthesize searchController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        [searchBar sizeToFit];
        searchBar.delegate = self;
        self.tableView.tableHeaderView = searchBar;
        
        searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
        searchController.delegate = self;
        searchController.searchResultsDataSource = self;
        searchController.searchResultsDelegate = self;
    }
    return self;
}


#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (UITableView *)activeTableView
{
    if (searchController.active) {
        return searchController.searchResultsTableView;
    }
    else {
        return self.tableView;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [elements count];
}

- (UITableViewCell *)cellForIdentifier:(NSString *)identifier
{
   return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];     
}

- (UITableViewCell *)setupCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cell;
}

- (void)updateImageForCell:(UITableViewCell *)cell fromUrl:(NSString *)url
{
    // fetching images on a concurrent queue as we can fetch them in parallel
    dispatch_queue_t update_image_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(update_image_queue, ^{
        if (url != nil && ![url isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [NSURL URLWithString:url];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            UIImage *image = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.imageView setImage:image];
                [cell setNeedsLayout];
            });
        }
    });
    dispatch_release(update_image_queue);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self cellForIdentifier:CellIdentifier];
    }
    
    [self setupCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

#pragma mark - Data fetching

- (NSURL *)urlForSearchTerm:(NSString *)searchTerm 
{
    return nil;
}

- (NSArray *)filterResults:(NSArray *)searchresults 
{
    return searchresults;
}

- (void)fetchData:(NSString *)searchTerm
{
    // use a serial queue per view to make sure:
    // 1) data in one view is fetched serially as the user types
    // 2) we don't have to wait for queued data from an old view if the user has moved on to the next view
    NSString *queueName = [NSString stringWithFormat:@"de.peterfriese.musix.fetch_data.%@", [self class]];
    dispatch_queue_t fetch_data_queue = dispatch_queue_create([queueName cStringUsingEncoding:NSUTF8StringEncoding], NULL);
    dispatch_async(fetch_data_queue, ^{
        NSURL *url = [self urlForSearchTerm:searchTerm];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        [self fetchedData:data];
    });
    dispatch_release(fetch_data_queue);
}

- (void)fetchedData:(NSData *)responseData
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    if (json) {
        id results = [json objectForKey:@"results"];
        if ([results respondsToSelector:@selector(objectAtIndex:)]) {
            NSArray *resultsArray = (NSArray *)results;
            // TODO insert another Q for accessing the elements array?
            self.elements = [self filterResults:resultsArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activeTableView reloadData];
            });

        }
    }
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSString *urlEncoded = [searchString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    [self fetchData:urlEncoded];
    return NO;
}




@end
