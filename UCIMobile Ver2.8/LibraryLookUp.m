//
//  LibraryLookUp.m
//  UCIMobile
//
//  Created by Yoon Lee on 6/11/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "LibraryLookUp.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "TFHpple.h"
#import "ASIFormDataRequest.h"
#import "Book.h"
#import "BookCellController.h"
#import "BookInformation.h"
#import "LibraryWeb.h"

@interface LibraryLookUp ()

- (void)startIconDownload:(Book *)book forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation LibraryLookUp
@synthesize _tableView;
@synthesize _searchBar;
@synthesize searchedResults;
@synthesize layerView;
@synthesize bookCell, copier;
@synthesize imageDownloadsInProgress;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 180, 30)];
	label1.text = @"UCI Library Search";
	label1.textAlignment = UITextAlignmentLeft;
	label1.textColor = [UIColor whiteColor];
	label1.font = [UIFont boldSystemFontOfSize:14];
	label1.backgroundColor = [UIColor clearColor];
	label1.tag = 1;
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 200, 30)];
	label2.text = @"Search Book in the Library";
	label2.textAlignment = UITextAlignmentLeft;
	label2.textColor = [UIColor whiteColor];
	label2.font = [UIFont fontWithName:@"Georgia" size:12];
	label2.backgroundColor = [UIColor clearColor];
	label2.tag = 2;
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
	[imgView addSubview:label2];
	[imgView addSubview:label1];
	self.navigationItem.titleView = imgView;
	[imgView release];
	[label1 release];
	[label2 release];
	
	self._tableView.rowHeight = 75.0;
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
	UIBarButtonItem *rButton = [[UIBarButtonItem alloc] initWithTitle:@"LibWebpage" style:UIBarButtonItemStyleBordered target:self action:@selector(loadWebLibrary:)];
	self.navigationItem.rightBarButtonItem = rButton;
	[rButton release];
	self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
	
	searchedResults = [[NSMutableArray alloc] init];
    
    [_tableView setAutoresizesSubviews:YES];
    [_tableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
}

- (void) loadWebLibrary:(id)sender
{
	LibraryWeb *libraryWEB = [[LibraryWeb alloc] initWithNibName:@"LibraryWeb" bundle:nil];
	libraryWEB.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:libraryWEB animated:YES];
	[libraryWEB release];
}

- (BOOL)requestBookSearch:(NSString *)withKeywords 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSString *baseURLaddr = @"http://uci.worldcat.org/search?";
	//make sure to cover with if statement
	NSURL *connect = [NSURL URLWithString:baseURLaddr];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:connect];
	[request setPostValue:@"2" forKey:@"scope"];
	[request setPostValue:@"wc_org_uci" forKey:@"qt"];
	[request setPostValue:withKeywords forKey:@"q"];
	[request setPostValue:@"Search" forKey:@"wcsbtn2w"];
	
	[request startSynchronous];
	
	NSArray *bookContents = nil;
	TFHppleElement *imgElement = nil;
	TFHpple *lookup = [[TFHpple alloc] initWithHTMLData:[request responseData]];
	@try 
	{
		//TOTAL BOOKS THAT WERE SEARCHED FOR
		bookContents = [lookup search:@"//tr/td[1]/strong[2]"];
		
		imgElement = [bookContents objectAtIndex:1];
		
		NSString *total = [imgElement content];
		
		NSArray *comps = [total componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
		total = [comps componentsJoinedByString:@""];
		
		maximum = [total intValue];
		
		if (maximum==0) {
			return NO;
		}
		else if(maximum<10) 
		{
			dontLoadMore = YES;
			mutableInteger = maximum;
		}
		else 
		{
			mutableInteger = 10;
			maximum -= 10;
		}
	}
	@catch (NSException * e) 
	{
		NSLog(@"ERROR");
		return NO;
	}

	
	Book *book;
	
	//BUILD UP THE COUNT HOW MANY YOU HAVE FOUND
	//FIRST READ UNTIL IT REACHES THIS SENTENCE ->DO NOT ALTER ANYTHING BELOW THIS LINE
	NSString *urlOfBook;
	
	@try 
	{
		//loop part assemble
		//there are maximum 10 result exist per page
		for (int i=1; i<=mutableInteger; i++) 
		{
			book = [[Book alloc] init];
			
			//BOOK IMAGE
			bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[3]/a/img", i]];
			
			imgElement = [bookContents objectAtIndex:0];
			
			NSString *imageToDisplay = [imgElement.attributes valueForKey:@"src"];
			
			if (imageToDisplay) 
			{
				book.imgURL = imageToDisplay;
			}
			else 
			{
				book.imgURL = [imgElement objectForKey:@"src"];
			}
			@try 
			{
				
				//LET'S GET URL BOOK
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[1]/a", i]];
				
				imgElement = [bookContents objectAtIndex:0];
				urlOfBook = [[imgElement attributes] objectForKey:@"href"];
			}
			@catch (NSException * e)
			{
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[2]/a", i]];
				imgElement = [bookContents objectAtIndex:0];
				urlOfBook = [[imgElement attributes] objectForKey:@"href"];
			}
			
			
			book.urlInfo = [NSString stringWithFormat:@"http://uci.worldcat.org%@",urlOfBook];
			
			@try 
			{
				//LET'S GET BOOK TITLE
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[1]/a/strong", i]];
				book.title = [[[bookContents objectAtIndex:0] content] capitalizedString];
			}
			@catch (NSException * e) 
			{
				//LET'S GET BOOK TITLE
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[2]/a/strong", i]];
				book.title = [[[bookContents objectAtIndex:0] content] capitalizedString];
			}
			
			@try 
			{
				//LET'S GET BOOK AUTHOR
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[3]", i]];
				book.author = [[[bookContents objectAtIndex:0] content] capitalizedString];
				
			}
			@catch (NSException * e) 
			{
				//LET'S GET BOOK AUTHOR
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[2]", i]];
				book.author = [[[bookContents objectAtIndex:0] content] capitalizedString];		
			}
			NSString *typeOfBook;
			@try 
			{
				//CHECK POINT FOR TYPEOFBOOK
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[3]/span", i]];
				typeOfBook = [[bookContents objectAtIndex:0] content];
			}
			@catch (NSException * e) 
			{
				//CHECK POINT FOR TYPEOFBOOK
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[4]/span", i]];
				typeOfBook = [[bookContents objectAtIndex:0] content];
			}
			
			//IF TYPEOFBOOK IS EQUAL TO ARTICLE THEN IT MIGHT HAS MORE THAN
			//4 MORE LINE TO READ.
			if ([typeOfBook isEqualToString:@"Article"]) 
			{
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[5]/span", i]];
				book.language = [[bookContents objectAtIndex:0] content];
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[7]", i]];
				book.publisher = [[bookContents objectAtIndex:0] content];
			}
			
			//OF COURSE THERE IS LIBRARY CONTENTS THAT DOESN'T SPECIFIES THE BOOK AUTHOR
			//IT REPLACES TO N/A
			else if(!book.author) 
			{
				book.author = @"by N/A";
				
				book.language = typeOfBook;
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[5]/span", i]];
				
				book.publisher = [[bookContents objectAtIndex:0] content];
			}
			
			//IF THERE IS NOTHINGS WRONG WITH PARSING THEN JUST DO REGULAR OPERATION.
			else
			{
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[6]/span", i]];
				book.publisher = [[bookContents objectAtIndex:0] content];
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[5]/span", i]];
				book.language = [[bookContents objectAtIndex:0] content];
			}
			
			//INSERT INTO ARRAY.
			[searchedResults insertObject:book atIndex:i-1];
			[book release];
		}
	}
	@catch (NSException * e) 
	{
		//NSLog(@"%@", [book description]);
		//NSLog(@"ERROR OR NOT FOUND ANYRESULTS REGARDING SEARCH KEYWORD %@", [e description]);
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		return NO;
	}
	
	[self._tableView reloadData];
	
	
	return YES;
}

- (BOOL)requestNextBookSearch:(NSString *)withKeywords {
	//READING CURRENT HTML CONTENTS (NSURL)
	//SCAN FOR NEXT PAGE HTML CONTENTS (NSSCANNER OR XPATH)
	
	
	BOOL hasNextContents = YES;
	TFHpple *lookup;
	@try {
		int nextPageNumber = mutableInteger + 1;
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		NSString *baseURLaddr = @"http://uci.worldcat.org/search?";
		//make sure to cover with if statement
		NSURL *connect = [NSURL URLWithString:baseURLaddr];
		ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:connect];
		[request setPostValue:@"2" forKey:@"scope"];
		[request setPostValue:@"next_page" forKey:@"qt"];
		[request setPostValue:withKeywords forKey:@"q"];
		[request setPostValue:@"nodgr" forKey:@"se"];
		[request setPostValue:@"desc" forKey:@"sd"];
		[request setPostValue:@"638" forKey:@"dblist"];
		[request setPostValue:[NSString stringWithFormat:@"%d", nextPageNumber] forKey:@"start"];
		[request setPostValue:@"Search" forKey:@"wcsbtn2w"];
		
		[request startSynchronous];
		lookup = [[TFHpple alloc] initWithHTMLData:[request responseData]];
	}
	@catch (NSException * e) {
		hasNextContents = NO;
	}
	copier.indicatorCircle.hidden = YES;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSArray *bookContents = nil;
	TFHppleElement *imgElement = nil;
	
	int moreYet = maximum - 10;
	
	if (moreYet==0) {
		return NO;
	}
	else if(moreYet<10) {
		dontLoadMore = YES;
		moreYet = maximum;
	}
	else {
		moreYet = 10;
		maximum -= 10;
	}
	Book *book;
	@try {
		//loop part assemble
		//there is maximum 10 result exist per page
		for (int i=mutableInteger; i<moreYet+mutableInteger; i++) 
		{
			book = [[Book alloc] init];
			bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[3]/a/img", (i-mutableInteger)+1]];
			
			imgElement = [bookContents objectAtIndex:0];
			
			NSString *imageToDisplay = [imgElement.attributes valueForKey:@"src"];
			
			if (imageToDisplay) 
			{
				book.imgURL = imageToDisplay;
			}
			else 
			{
				book.imgURL = [imgElement objectForKey:@"src"];
			}
			
			//LET'S GET URL BOOK
			NSString *urlOfBook;
			@try 
			{
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[2]/a", (i-mutableInteger)+1]];
				//NSLog(@"%@", [bookContents description]);
				imgElement = [bookContents objectAtIndex:0];
				urlOfBook= [[imgElement attributes] objectForKey:@"href"];
			}
			@catch (NSException * e) 
			{
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[1]/a", (i-mutableInteger)+1]];
				//NSLog(@"%@", [bookContents description]);
				imgElement = [bookContents objectAtIndex:0];
				urlOfBook= [[imgElement attributes] objectForKey:@"href"];
			}
			
			book.urlInfo = [NSString stringWithFormat:@"http://uci.worldcat.org%@",urlOfBook];
			@try 
			{
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[2]/a/strong", (i-mutableInteger)+1]];
				book.title = [[[bookContents objectAtIndex:0] content] capitalizedString];
			}
			@catch (NSException * e) 
			{
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[1]/a/strong", (i-mutableInteger)+1]];
				book.title = [[[bookContents objectAtIndex:0] content] capitalizedString];
			}
			
			@try 
			{
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[3]", (i-mutableInteger)+1]];
				book.author = [[bookContents objectAtIndex:0] content];
			}
			@catch (NSException * e) 
			{
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[2]", (i-mutableInteger)+1]];
				book.author = [[bookContents objectAtIndex:0] content];
			}
			NSString *typeOfBook;
			@try 
			{
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[4]/span", (i-mutableInteger)+1]];
				typeOfBook = [[bookContents objectAtIndex:0] content];
			}
			@catch (NSException * e) 
			{
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[3]/div[4]/span", (i-mutableInteger)+1]];
				typeOfBook = [[bookContents objectAtIndex:0] content];
			}
			
			if ([typeOfBook isEqualToString:@"Article"]) 
			{
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[5]/span", i]];
				book.language = [[bookContents objectAtIndex:0] content];
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[6]", i]];
				book.publisher = [[bookContents objectAtIndex:0] content];
			}
			else if(!book.author) 
			{
				book.author = @"by N/A";
				
				book.language = typeOfBook;
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[5]/span", (i-mutableInteger)+1]];
				
				book.publisher = [[bookContents objectAtIndex:0] content];
			}
			
			else 
			{
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[6]/span", (i-mutableInteger)+1]];
				book.publisher = [[bookContents objectAtIndex:0] content];
				bookContents = [lookup search:[NSString stringWithFormat:@"//tr[%d]/td[4]/div[5]/span", (i-mutableInteger)+1]];
				book.language = [[bookContents objectAtIndex:0] content];
			}
			[searchedResults insertObject:book atIndex:mutableInteger+(i-mutableInteger)];
			[book release];
		}
	}
	@catch (NSException * e) 
	{
		NSLog(@"%@", [book description]);
		NSLog(@"ERROR OR NOT FOUND ANYRESULTS REGARDING SEARCH KEYWORD %@", [e description]);
		return NO;
	}
	[self._tableView reloadData];
	if (moreYet>=10) {
		mutableInteger += 10;
	}
	
	return hasNextContents;
}

- (void) movement
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

//*************************UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
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
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(movement) userInfo:nil repeats:NO];
	if ([self.searchedResults count]>0) 
	{
		
		dontLoadMore = NO;
		mutableInteger = 0;
		dontLoadMore = 0;
		[searchedResults removeAllObjects];
		[imageDownloadsInProgress removeAllObjects];
	}
	[self requestBookSearch:self._searchBar.text];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

// called when text starts editing
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar 
{
	
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	layerView.hidden = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar 
{
	//this is after search tab was pressed and for all process is being done.
	layerView.hidden = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	for (UIView* viewed in self.view.subviews) {
		if ([viewed isKindOfClass:[UIView class]])
			[viewed resignFirstResponder];
	}	
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

//*************************UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
	int count = [self.searchedResults  count];
	//	
	//	// ff there's no data yet, return enough rows to fill the screen
    if (count == 0)
	{
        return 3;
    }
	
    return count + 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Book";
	
	int nodeCount = [self.searchedResults count];
	
	BookCellController *bookCello = (BookCellController *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (bookCello == nil) 
	{
        bookCell = [[UITableViewCell alloc] init];
		[[NSBundle mainBundle] loadNibNamed:@"BookCellController" owner:self options:nil];
		bookCello = bookCell;
		self.bookCell = nil;
    }
	
	if (nodeCount == 0)
	{
		switch (indexPath.row) 
		{
			case 2:
				bookCello._titles.hidden = YES;
				bookCello.author.hidden = YES;
				bookCello.publisher.hidden = YES;
				bookCello.language.hidden = YES;
				bookCello.frontCover.hidden = YES;
				bookCello.decoy1.hidden = YES;
				bookCello.decoy2.hidden = YES;
				bookCello.standBy.numberOfLines = 0;
				bookCello.standBy.text = @"SEARCH FOR UCI LIBRARY";
				bookCello.standBy.hidden = NO;
				break;
			default:
				bookCello._titles.hidden = YES;
				bookCello.author.hidden = YES;
				bookCello.publisher.hidden = YES;
				bookCello.language.hidden = YES;
				bookCello.frontCover.hidden = YES;
				bookCello.decoy1.hidden = YES;
				bookCello.decoy2.hidden = YES;
				
				bookCello.standBy.hidden = YES;
				break;
		}
		
		bookCello.selectionStyle = UITableViewCellSelectionStyleNone;
		
		return bookCello;
    }
	
	if (nodeCount>0&&indexPath.row!=nodeCount) 
	{
		//Set up the cell
		Book *book = [searchedResults objectAtIndex:indexPath.row];
		bookCello._titles.hidden = NO;
		bookCello.author.hidden = NO;
		bookCello.publisher.hidden = NO;
		bookCello.language.hidden = NO;
		bookCello.frontCover.hidden = NO;
		bookCello.decoy1.hidden = NO;
		bookCello.decoy2.hidden = NO;
		
		bookCello.standBy.hidden = YES;
		
		bookCello._titles.text = book.title;
		bookCello.author.text = book.author;
		bookCello.language.text = book.language;
		bookCello.publisher.text = book.publisher;
		
		bookCello.selectionStyle = UITableViewCellSelectionStyleBlue;
		
		if (!book.resourceImage) 
		{
			
			if (self._tableView.dragging == NO && self._tableView.decelerating == NO) 
			{
				[self startIconDownload:book forIndexPath:indexPath];
			}
			bookCello.frontCover.layer.masksToBounds = YES;
			bookCello.frontCover.image = [UIImage imageNamed:@"Placeholder.png"];
		}
		else 
		{
			bookCello.frontCover.layer.masksToBounds = YES;
			bookCello.frontCover.image = book.resourceImage;
		}
		bookCello.indicatorCircle.hidden = YES;
	}
	
	else if (indexPath.row==nodeCount&&!dontLoadMore)
	{
		bookCello._titles.hidden = YES;
		bookCello.author.hidden = YES;
		bookCello.publisher.hidden = YES;
		bookCello.language.hidden = YES;
		bookCello.frontCover.hidden = YES;
		bookCello.decoy1.hidden = YES;
		bookCello.decoy2.hidden = YES;
		bookCello.standBy.numberOfLines = 0;
		bookCello.standBy.text = @"SEARCH FOR MORE RESULT";
		bookCello.standBy.hidden = NO;
		copier = bookCello;
		copier.indicatorCircle.hidden = YES;
	}
	else if (dontLoadMore) 
	{
		bookCello._titles.hidden = YES;
		bookCello.author.hidden = YES;
		bookCello.publisher.hidden = YES;
		bookCello.language.hidden = YES;
		bookCello.frontCover.hidden = YES;
		bookCello.decoy1.hidden = YES;
		bookCello.decoy2.hidden = YES;
		bookCello.standBy.text = [NSString stringWithFormat:@"RESULTS LESS EQUAL TO %d", [searchedResults count]];
		bookCello.standBy.hidden = NO;
		bookCello.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
    // Configure the cell...
    return bookCello;
}
#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(movement) userInfo:nil repeats:NO];
	
	int nodeCount = [self.searchedResults count];
	
	if (nodeCount>0&&nodeCount!=indexPath.row)
	{
		[self._tableView deselectRowAtIndexPath:indexPath animated:YES];
		copier.indicatorCircle.hidden = YES;
		
		//PUSH THE BOOK OBJECT INTO NEXT PAGE VIEWCONTROLLER
		Book *book = [searchedResults objectAtIndex:indexPath.row];
		BookInformation *fetchInformation = [[BookInformation alloc] initWithNibName:@"BookInformation" bundle:nil];
		[fetchInformation initWithContents:book];
		
		//EXECUTE THE WEBLAUNCH METHOD BEFORE LOAD PAGE.
		
		[self.navigationController pushViewController:fetchInformation animated:YES];
		[fetchInformation release];
	}
	else if (!dontLoadMore&&indexPath.row==nodeCount)
	{
		[self._tableView deselectRowAtIndexPath:indexPath animated:YES];
		copier.indicatorCircle.hidden = NO;
		[self requestNextBookSearch:self._searchBar.text];
	}
	else 
	{
		copier.indicatorCircle.hidden = YES;
	}
	
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(Book *)book forIndexPath:(NSIndexPath *)indexPath
{	
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.book = book;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
		
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.searchedResults count] > 0)
    {
        NSArray *visiblePaths = [self._tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
			if (indexPath.row!=[searchedResults count]) {
				Book *book = [self.searchedResults objectAtIndex:indexPath.row];
				
				if (!book.resourceImage) // avoid the app icon download if the app already has an icon
				{
					[self startIconDownload:book forIndexPath:indexPath];
				}
			}
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{	
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        bookCell = (BookCellController *)[self._tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
		bookCell.frontCover.layer.masksToBounds = YES;
        bookCell.frontCover.image = iconDownloader.book.resourceImage;
    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

// Display customization

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 75.0;
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
            [_searchBar setFrame:CGRectMake(0, 0, 320, 50)];
            [_tableView setFrame:CGRectMake(0, 50, 320, 410)];
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            [_searchBar setFrame:CGRectMake(0, 0, 480, 50)];
            [_tableView setFrame:CGRectMake(0, 50, 480, 250)];
            break;
    }
}

- (void)dealloc 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[_searchBar release];
	_searchBar = nil;
	
	[searchedResults release];
	searchedResults = nil;
	
	[layerView release];
	layerView = nil;
	
	[bookCell release];
	bookCell = nil;
	
	[imageDownloadsInProgress release];
	imageDownloadsInProgress = nil;
	
	[copier release];
	copier = nil;
	
    [super dealloc];
}


@end

