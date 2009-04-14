//
//  TouchJSON_iPhoneDemoAppDelegate.h
//  TouchJSON-iPhoneDemo
//
//  Created by Luis de la Rosa on 4/9/09.
//  Copyright Happy Apps LLC 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchJSON_iPhoneDemoViewController;

@interface TouchJSON_iPhoneDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TouchJSON_iPhoneDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TouchJSON_iPhoneDemoViewController *viewController;

@end

