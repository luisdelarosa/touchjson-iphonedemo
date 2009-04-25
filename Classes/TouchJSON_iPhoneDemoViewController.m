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
- (void)handleError:(NSError *)error;
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
  
  // Don't try to autocapitalize.
  querySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
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
// This is triggered by the user pressing Enter in the Search Field or pressing the "Search" button in the keyboard.
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {  
  // The real URL
  // Note that there is a rate limit
	NSString *queryString = querySearchBar.text;
  NSString *searchString = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@", queryString];
  
  // URL for testing
//  NSString *searchString = [NSString stringWithFormat:@"file:///Users/louie/Downloads/search.json", queryString];
  
  // Execute search by performing an HTTP GET to the REST web service which returns JSON
  NSString *jsonString = [self jsonFromURLString:searchString];
  NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
  
  // Parse JSON results with TouchJSON.  It converts it into a dictionary.
  CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
  NSError *error;
  NSDictionary *resultsDictionary = [jsonDeserializer deserializeAsDictionary:jsonData error:&error];
  [self handleError:error];
  
  // Clear out the old tweets from the previous search
  [tweets removeAllObjects];

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

#pragma mark WebServiceCommunication

// This will issue a request to a web service API via HTTP GET to the URL specified by urlString.
// It will return the JSON string returned from the HTTP GET.
- (NSString *)jsonFromURLString:(NSString *)urlString {
  NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"GET"];
	
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
  [self handleError:error];
	NSString *resultString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
  return [resultString autorelease];
}

// This shows the error to the user in an alert.
- (void)handleError:(NSError *)error {
	if (error != nil) {
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [errorAlertView show];
    [errorAlertView release];
	}  
}

@end
