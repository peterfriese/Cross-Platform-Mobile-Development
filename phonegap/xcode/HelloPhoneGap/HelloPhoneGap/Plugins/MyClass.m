//
//  MyClass.m
//  HelloPhoneGap
//
//  Created by Peter Friese on 12.01.12.
//  Copyright (c) 2012 http://peterfriese.de. All rights reserved.
//

#import "MyClass.h"

@implementation MyClass

- (void)print:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString *message = [arguments objectAtIndex:1];
    NSLog(@"You just said: %@", message);
    [[[UIAlertView alloc] initWithTitle:@"Message from your broeser" message:message delegate:nil cancelButtonTitle:@"Cool" otherButtonTitles:nil] show];
}

@end
