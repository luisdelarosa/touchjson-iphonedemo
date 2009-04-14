//
//  TouchJSON_iPhoneDemoViewController.m
//  TouchJSON-iPhoneDemo
//
//  Created by Luis de la Rosa on 4/9/09.
//  Copyright Happy Apps LLC 2009. All rights reserved.
//

#import "TouchJSON_iPhoneDemoViewController.h"
#import "CJSONDeserializer.h"

@interface TouchJSON_iPhoneDemoViewController (PrivateMethods)
- (NSString *)jsonFromURLString:(NSString *)urlString;
@end

@implementation TouchJSON_iPhoneDemoViewController

@synthesize querySearchBar;
@synthesize tweetsTableView;

- (void)viewDidLoad {
  [super viewDidLoad];

  tweets = [[NSMutableArray alloc] init];
  
  querySearchBar.delegate = self;
  
  tweetsTableView.dataSource = self;
  tweetsTableView.delegate = self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
  [super dealloc];
}

#pragma mark TableDelegateAndDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Tweets";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
    // Set up the cell
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,0,0) reuseIdentifier:MyIdentifier] autorelease];
    cell.font = [UIFont fontWithName:@"Helvetica" size:12.0];
	}

	// Set the text of the cell to the tweet at the row
  cell.text = [tweets objectAtIndex:indexPath.row];
	return cell;
}

#pragma mark UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {  
  // The real URL
  // Note that there is a rate limit
	NSString *queryString = querySearchBar.text;
//  NSString *searchString = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@", queryString];
  
  // URL for testing
  NSString *searchString = [NSString stringWithFormat:@"file:///Users/louie/Downloads/search.json", queryString];
  
  // Execute search by performing an HTTP GET to the REST web service which returns JSON
  NSString *jsonString = [self jsonFromURLString:searchString];
  NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
  
  // Parse JSON results with TouchJSON.  It converts it into a dictionary.
  CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
  NSError *error;
  NSDictionary *resultsDictionary = [jsonDeserializer deserializeAsDictionary:jsonData error:&error];
	NSLog(@"error:%@", error);

  // Traverse through returned dictionary to populate tweets model
  NSArray *tweetsArray = [resultsDictionary objectForKey:@"results"];
  for (NSDictionary *tweetDictionary in tweetsArray) {
    NSString *tweetText = [tweetDictionary objectForKey:@"text"];
    [tweets addObject:tweetText];
  }
  
  // refresh table view
  [tweetsTableView reloadData];
  
  // hide the keyboard
	[searchBar resignFirstResponder];	
}

#pragma mark -

- (NSString *)jsonFromURLString:(NSString *)urlString {
  NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"GET"];
	
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSString *resultString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
	
	if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
		NSLog(@"response code:%d", [httpResponse statusCode]);
	}
	
	NSLog(@"error:%@", error);
	NSLog(@"resultString:%@", resultString);

  return resultString;
}

@end