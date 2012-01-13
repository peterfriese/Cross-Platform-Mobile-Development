//
//  MyClass.h
//  HelloPhoneGap
//
//  Created by Peter Friese on 12.01.12.
//  Copyright (c) 2012 http://peterfriese.de. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PhoneGap/PGPlugin.h>

@interface MyClass : PGPlugin

- (void)print:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;

@end
