//
//  TouchJSON_iPhoneDemoAppDelegate.m
//  TouchJSON-iPhoneDemo
//
//  Created by Luis de la Rosa on 4/9/09.
//  Copyright Happy Apps LLC 2009. All rights reserved.
//

#import "TouchJSON_iPhoneDemoAppDelegate.h"
#import "TouchJSON_iPhoneDemoViewController.h"

@implementation TouchJSON_iPhoneDemoAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
