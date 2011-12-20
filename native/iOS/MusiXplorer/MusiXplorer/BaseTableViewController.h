//
//  BaseTableViewController.h
//  
//
//  Created by Peter Friese on 20.12.11.
//  Copyright (c) 2011 http://peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate>

// should be overridden by subclasses
- (NSURL *)urlForSearchTerm:(NSString *)searchTerm;
- (NSArray *)filterResults:(NSArray *)searchresults;


// fetching data is performed by these two methods
- (void)fetchData:(NSString *)searchTerm;
- (void)fetchedData:(NSData *)responseData;

@property (strong, nonatomic) NSArray *elements;

@end
