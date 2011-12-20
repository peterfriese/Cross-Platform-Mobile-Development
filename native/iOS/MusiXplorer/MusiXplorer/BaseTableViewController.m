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

- (void)fetchImageForCell:(UITableViewCell *)cell fromUrl:(NSString *)url
{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(concurrentQueue, ^{
        if (url != nil && ![url isKindOfClass:[NSNull class]]) {
            dispatch_sync(concurrentQueue, ^{
                NSURL *imageUrl = [NSURL URLWithString:url];
                NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
                UIImage *image = [UIImage imageWithData:imageData];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [cell.imageView setImage:image];
                    [cell setNeedsLayout];
                });                
            });
        }
    });    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self cellForIdentifier:CellIdentifier];
    }
    
    return [self setupCell:cell forRowAtIndexPath:indexPath];
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
    NSURL *url = [self urlForSearchTerm:searchTerm];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];        
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    if (json) {
        id results = [json objectForKey:@"results"];
        if ([results respondsToSelector:@selector(objectAtIndex:)]) {
            NSArray *resultsArray = (NSArray *)results;
            self.elements = [self filterResults:resultsArray];
            [self.tableView reloadData];
        }
    }
    
}

#pragma mark - UISearchDispalyControllerDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSString *urlEncoded = [searchString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    [self fetchData:urlEncoded];
    return YES;
}




@end
