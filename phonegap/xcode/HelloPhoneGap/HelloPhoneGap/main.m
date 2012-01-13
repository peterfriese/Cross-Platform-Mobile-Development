//
//  main.m
//  HelloPhoneGap
//
//  Created by Peter Friese on 12.01.12.
//  Copyright http://peterfriese.de 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate");
    [pool release];
    return retVal;
}
