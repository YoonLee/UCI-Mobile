//
//  DirectorySearch.m
//  MyUCI
//
//  Created by Yoon Lee on 4/24/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import "DirectorySearch.h"
#import "ASIFormDataRequest.h"
#import "SpecificViewController.h"
#import "DictionaryResults.h"
#import "TFHpple.h"
#import "Reachability.h"

//next to do list
//section by indexes.
@implementation DirectorySearch
@synthesize _tableView;
@synthesize loadingView, progressBar, indicator;
@synthesize managedObjectContext, layerView, searchBar;
@synthesize statusText, path;
@synthesize dictionaryObject;
@synthesize isClicked;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 280, 30)];
	label1.text = @"UCI Directory Search";
	label1.textAlignment = UITextAlignmentLeft;
	label1.textColor = [UIColor whiteColor];
	label1.font = [UIFont boldSystemFontOfSize:14];
	label1.backgroundColor = [UIColor clearColor];
	label1.tag = 1;
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 280, 30)];
	label2.text = @"Search email, homepage and contact";
	label2.textAlignment = UITextAlignmentLeft;
	label2.textColor = [UIColor whiteColor];
	label2.font = [UIFont fontWithName:@"Georgia" size:12];
	label2.backgroundColor = [UIColor clearColor];
	label2.tag = 2;
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 60)];
	[imgView addSubview:label2];
	[imgView addSubview:label1];
	self.navigationItem.titleView = imgView;
	[imgView release];
	[label1 release];
	[label2 release];
	
	if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) 
	{
		//show an alert to let the user know that they can't connect...
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status" 
														message:@"Sorry, the network is not available.\nPlease try again later." 
													   delegate:nil 
											  cancelButtonTitle:nil 
											  otherButtonTitles:@"OK", nil];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[alert show];
		[alert release];
	}
	
	self.loadingView.layer.cornerRadius = 15.0;
	self.searchDisplayController.searchResultsTableView.rowHeight = 60.0;
	self._tableView.rowHeight = 60.0;
	self._tableView.sectionHeaderHeight = 0.5;
	
	//tester
	
	path = [[NSMutableArray alloc] init];
	dictionaryObject = [[NSMutableArray alloc] init];
	self.statusText.text = @"UCI PEOPLE SEARCH";
	UIBarButtonItem *home = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:nil];
	self.navigationItem.backBarButtonItem = home;
    [searchBar setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	[home release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
    return [dictionaryObject count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
	static NSString *CellIdentifier = @"Cell";
	static NSString *LastNode = @"Last";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	UITableViewCell *last = [tableView dequeueReusableCellWithIdentifier:LastNode];
	if (indexPath.row==[dictionaryObject count]-1) 
	{
		if (last == nil) 
		{
			last = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastNode] autorelease];
		}
		NSString *describe = [dictionaryObject objectAtIndex:[dictionaryObject count]-1];
		last.selectionStyle = UITableViewCellSelectionStyleNone;
		last.alpha = .30;
		last.textLabel.textAlignment = UITextAlignmentCenter;
		last.textLabel.font = [UIFont boldSystemFontOfSize:13];
		last.textLabel.textColor = [UIColor grayColor];
		last.textLabel.text = describe;
		last.detailTextLabel.text = nil;
		last.imageView.image = nil;
		return last;
	}
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	// Configure the cell...
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	if (isNoResults) 
	{
		cell.textLabel.text = nil;
		cell.detailTextLabel.text = nil;
		cell.imageView.image = nil;
		return cell;
	}
	else if (indexPath.row==[dictionaryObject count]) 
	{
		if (last == nil) 
		{
			last = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastNode] autorelease];
		}
		last.alpha = .65;
		last.textLabel.textAlignment = UITextAlignmentCenter;
		last.textLabel.font = [UIFont boldSystemFontOfSize:13];
		last.textLabel.text = [[dictionaryObject objectAtIndex:[dictionaryObject count]-1] name];
		last.detailTextLabel.text = nil;
		return last;
	}
	
	statusText.hidden = YES;
	cell.imageView.image = [UIImage imageNamed:@"card.png"];
	cell.textLabel.text = [(DictionaryResults *)[dictionaryObject objectAtIndex:indexPath.row] name];
	cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:13];
	
	cell.detailTextLabel.text = [(DictionaryResults *)[dictionaryObject objectAtIndex:indexPath.row] major];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (indexPath.row%2!=0)
	{
		cell.backgroundColor = RGB(239, 239, 239);
	}
	else if (indexPath.row%2==0)
	{
		cell.backgroundColor = RGB(204, 204, 204);
	}
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.navigationItem.hidesBackButton = YES;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	if (isNoResults)
	{
		[self._tableView deselectRowAtIndexPath:indexPath animated:YES];
		self.navigationItem.hidesBackButton = NO;
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		return;
	}
	if (indexPath.row!=[dictionaryObject count]-1&&!isClicked) 
	{
		[self._tableView deselectRowAtIndexPath:indexPath animated:YES];
		isClicked = YES;
		SpecificViewController *launch = [[SpecificViewController alloc] initWithStyle:UITableViewStyleGrouped];
		[launch setSetter:self];
		[launch setManagedContext:self.managedObjectContext];
		[self.managedObjectContext release];
		[launch setPerson:[(DictionaryResults *)[dictionaryObject objectAtIndex:indexPath.row] name]];
		[launch setPersonID:[(DictionaryResults *)[dictionaryObject objectAtIndex:indexPath.row] ucinetID]];
		[launch setPersonMajor:[(DictionaryResults *)[dictionaryObject objectAtIndex:indexPath.row] major]];
		[self.navigationController pushViewController:launch animated:YES];
		[launch release];
	}
	self.navigationItem.hidesBackButton = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if ([dictionaryObject count]>0) 
	{
		if (indexPath.row==[dictionaryObject count]-1) 
		{
			return 60.0;
		}
		else 
		{
			return 60.0;
		}
	}
	return 60.0;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

//searchbar delegate method
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar 
{
	if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) 
	{
		//show an alert to let the user know that they can't connect...
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status" 
														message:@"Sorry, the network is not available.\nPlease try again later." 
													   delegate:nil 
											  cancelButtonTitle:nil 
											  otherButtonTitles:@"OK", nil];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[alert show];
		[alert release];
		return;
	}
	[self requestURL:self.searchBar.text];
}

// called when text starts editing
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {

	[self.navigationController setNavigationBarHidden:YES animated:YES];
	layerView.hidden = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	//this is after search tab was pressed and for all process is being done.
	layerView.hidden = YES;
	//plus, loading progressbar has to be out of the way
	self.loadingView.hidden = YES;
	
	progressBar.progress = 0.0;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	for (UIView* viewed in self.view.subviews) {
		if ([viewed isKindOfClass:[UIView class]])
			[viewed resignFirstResponder];
	}	
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void) requestURL:(NSString *)keywords 
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	loadingView.hidden = NO;
	statusText.hidden = NO;
	progressBar.progress += 0.15;
	isNoResults = NO;
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update:) userInfo:self repeats:YES];
	
	if ([dictionaryObject count]>0) {
		[path removeAllObjects];
		for (int y=0, k=[dictionaryObject count]-1; k >= 0;y++, k--) {
			[path insertObject:[NSIndexPath indexPathForRow:k inSection:0] atIndex:y];
		}
		[dictionaryObject removeAllObjects];
		[self._tableView deleteRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationFade];
		[path removeAllObjects];
		
		
		//temp
		[dictionaryObject removeAllObjects];
	}
	
	//conversion for the html that when the keywords requested,
	//if any empty space require to replace with '+' mark instead.
	NSString *repStr = [keywords stringByReplacingOccurrencesOfString:@" " withString:@"+"];
	
	NSString *address = @"http://directory.uci.edu/?basic_keywords=";
	address = [NSString stringWithFormat:@"%@%@&modifier=Starts+With&basic_submit=Search&checkbox_employees=Employees&checkbox_students=Students&checkbox_departments=Departments&form_type=basic_search", address, repStr];
	
	NSURL *url = [NSURL URLWithString:address];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:keywords forKey:@"basic_keywords"];
	[request setPostValue:@"Search" forKey:@"Search"];
	[request setPostValue:@"Employees" forKey:@"checkbox_employees"];
	[request setPostValue:@"Students" forKey:@"checkbox_students"];
	[request setPostValue:@"Departments" forKey:@"checkbox_departments"];
	[request setPostValue:@"basic_search" forKey:@"form_type"];
	[request startSynchronous];
	
	//STEP 1: FOUND MANY OF RESULTS
	//THIS IS WHAT WE EXACTLY WANTED TO DISPLAY
	//PERSON'S NAME RELATIVE TO SEARCH KEYWORDS
	//STEP 2: ONLY ONE PERSON RESULTS
	//WILL DIRECTLY LOAD UP THE PERSON'S INFORMATION.
	//BUT WE DON'T WANT THAT IN THIS VIEWCONTROLLER.
	//STEP 3: NONE FOUND
	//GRR CHECKING CONDITION TO BE MIS-TYPED OR NOTEXIST.
	TFHppleElement *e;
	NSData *data = [request responseData];
	TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
	//read until next available name exist
	NSArray *nameElements = [doc search:@"//td[1]/a"];
	NSArray *departmentElements = [doc search:@"//td[1]/span"];
	NSArray *nonFoundElements = [doc search:@"//div[1]/p[1]"];
	
	//statistically, when there is unique person found
	//the first element of nonFoundElements get NULL.
	//if more than 100 result exist then its string value gets '.'.
	if ([nonFoundElements count]==1) {
		NSString *identity = [[nonFoundElements objectAtIndex:0] content];
		if (!identity) {
			progressBar.progress += 0.10;
		}
		else if([identity isEqualToString:@"."]) {
			progressBar.progress += 0.10;
		}
		else {
			progressBar.progress += 0.90;
			statusText.text = @"NO SEARCH RESULTS";
			layerView.hidden = YES;
			//plus, loading progressbar has to be out of the way
			self.loadingView.hidden = YES;
			progressBar.progress = 0.0;
			isNoResults = YES;
			[self._tableView reloadData];
			[self.searchBar resignFirstResponder];
			[self.navigationController setNavigationBarHidden:NO animated:YES];
			[doc release];
			return;
		}
	}
	
	NSString *name;
	NSString *_major;
	NSString *userID = nil;
	NSScanner *scan = nil;
	NSCharacterSet *toBeSkiped = [NSCharacterSet characterSetWithCharactersInString: @"="];
	DictionaryResults *object = nil;
	
	
	//CASE 2:ONLY ONE PERSON RESULTS APPEARS
	if ([nameElements count]==0) {
		progressBar.progress += 0.10;
		nameElements = [doc search:@"//p[1]/span[2]"];
		e = [nameElements objectAtIndex:0];
		
		//store name with capitalized
		name = [(NSString *)[e content] capitalizedString];
		object = [NSEntityDescription insertNewObjectForEntityForName:@"DictionaryResults" inManagedObjectContext:self.managedObjectContext];
		object.name = name;
		scan = [NSScanner scannerWithString:[request responseString]];
		[scan scanUpToString:@"UCInetID</span>" intoString:nil];
		[scan scanUpToString:@"resultData\">" intoString:nil];
		[scan scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@">"] intoString:nil];
		[scan setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@">"]];
		[scan scanUpToString:@"</span>" intoString:&userID];
		
		object.alphabetIndex = [name stringByPaddingToLength:3 withString:@"" startingAtIndex:0];
		departmentElements = [doc search:@"//td[2]/span"];
		
		if ([departmentElements count]>1) {
			//pattis&&taylor type
			e = [departmentElements objectAtIndex:1];
		}
		else if([departmentElements count]==1) {
			//raquel type
			e = [departmentElements objectAtIndex:0];
		}
		else if([departmentElements count]==0) {
			//student like yoon
			//research over through
			departmentElements = [doc search:@"//p[4]/span[2]"];
			e = [departmentElements objectAtIndex:0];
		}
		if (![e content]) {
			_major = @"N/R";
		}
		else {
			_major = [e content];
		}
		
		object.major = _major;
		object.ucinetID = userID;
		[dictionaryObject addObject:object];
	}
	//CASE 1:FOUND MANY OF RESULTS APPEARS
	else {
		progressBar.progress += 0.10;
		for (int i=0; i<[nameElements count]; i++) {
			e = [nameElements objectAtIndex:i];
			
			scan = [NSScanner scannerWithString:[e objectForKey:@"href"]];
			
			///index.php?uid=
			[scan scanUpToString:@"=" intoString:nil];
			[scan setCharactersToBeSkipped:toBeSkiped];
			//leeyc&return=basic_keywords
			[scan scanUpToString:@"&" intoString:&userID];
			
			name = [(NSString *)[e content] capitalizedString];
			e = [departmentElements objectAtIndex:i];
			if (![e content]) {
				_major = @"N/R";
			}
			else {
				_major = [e content];
			}
			object = [NSEntityDescription insertNewObjectForEntityForName:@"DictionaryResults" inManagedObjectContext:self.managedObjectContext];
			object.name = name;
			object.ucinetID = userID;
			object.alphabetIndex = [name stringByPaddingToLength:1 withString:@"" startingAtIndex:0];
			object.major = _major;
			
			[dictionaryObject addObject:object];
		}
	}
	int targetCreator = [dictionaryObject count];
	//store -> sort -> add status at the end.
	//sort
	NSSortDescriptor *descrSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	[dictionaryObject sortUsingDescriptors:[NSArray arrayWithObject:descrSort]];
	[descrSort release];
	[dictionaryObject insertObject:[NSString stringWithFormat:@"TOTAL %d PEOPLE", targetCreator] atIndex:[dictionaryObject count]];
	for (int j=0; j < [dictionaryObject count]; j++) {
		[path insertObject:[NSIndexPath indexPathForRow:j inSection:0] atIndex:j];
	}
	[self._tableView beginUpdates];
	[self._tableView insertRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationTop];
	
	[self._tableView endUpdates];
	
	//at the end of search result,
	//data should be reload through tableview
	//but also release the keyboard layer view
	[searchBar resignFirstResponder];
	[doc release];
}

- (void) update:(NSTimer *)sender
{
	progressBar.progress =+ progressBar.progress + 0.15;
	
	if (progressBar.progress==1) 
	{
		progressBar.progress = 0.0;
		[sender invalidate];
	}
}

- (void)viewDidUnload 
{
	layerView = nil;
	statusText = nil;
	progressBar = nil;
	searchBar = nil;
	indicator = nil;
	_tableView = nil;
	loadingView = nil;
	path = nil;
	dictionaryObject = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    switch (toInterfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            [searchBar setFrame:CGRectMake(0, 0, 320, 50)];
            [_tableView setFrame:CGRectMake(0, 50, 320, 372)];
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            [searchBar setFrame:CGRectMake(0, 0, 480, 50)];
            [_tableView setFrame:CGRectMake(0, 50, 480, 220)];
            break;
    }
}

- (void)dealloc 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[dictionaryObject release];
	[path release];
	[layerView release];
	[statusText release];
	[progressBar release];
	[searchBar release];
	[indicator release];
	[_tableView release];
	[loadingView release];
    [super dealloc];
}


@end

