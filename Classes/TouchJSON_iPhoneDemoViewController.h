//
//  TouchJSON_iPhoneDemoViewController.h
//  TouchJSON-iPhoneDemo
//
//  Created by Luis de la Rosa on 4/9/09.
//  Copyright Happy Apps LLC 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchJSON_iPhoneDemoViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate> {
  IBOutlet UISearchBar *querySearchBar;
  IBOutlet UITableView *tweetsTableView;
  NSMutableArray *tweets;
}

@property (nonatomic, retain) IBOutlet UISearchBar *querySearchBar;
@property (nonatomic, retain) IBOutlet UITableView *tweetsTableView;

@end

