//
//  BaseTableViewController.m
//  
//
//  Created by Peter Friese on 20.12.11.
//  Copyright (c) 2011 http://peterfriese.de. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end



@implementation BaseTableViewController

@synthesize elements;

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


@end
