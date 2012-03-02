//
//  BookInformation.m
//  UCIMobile
//
//  Created by Yoon Lee on 6/17/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "BookInformation.h"
#import "BookViewController.h"
#import "LibraryMapViewController.h"
#import "Reachability.h"

static NSUInteger kNumberOfPages = 2;

@interface BookInformation (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation BookInformation

@synthesize book;
@synthesize scrollView, pageControl, viewControllers;

- (void)dealloc {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [viewControllers release];
	viewControllers = nil;
    [scrollView release];
	scrollView = nil;
    [pageControl release];
	pageControl = nil;
	[book release];
    [super dealloc];
}

- (void)initWithContents:(Book *)books {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
		//show an alert to let the user know that they can't connect...
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status" 
														message:@"Sorry, the network is not available.\nPlease try again later." 
													   delegate:self 
											  cancelButtonTitle:nil 
											  otherButtonTitles:@"OK", nil];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[alert show];
		[alert release];
		[self.navigationController popViewControllerAnimated:YES];
	}

	
	self.book = books;
	
	@try {
		//LETS READ BASE URL
		NSURL *baseLink = [NSURL URLWithString:book.urlInfo];
		NSString *responsedHTML = [NSString stringWithContentsOfURL:baseLink encoding: NSUTF8StringEncoding error:nil];
		//THEN GETS THE OCLC
		NSScanner *scan = [NSScanner scannerWithString:responsedHTML];
		NSString *ptrHTML;
		ptrHTML = responsedHTML;
		NSString *oCLC = nil;
		NSString *isBNs = nil;
		NSString *summary = nil;
		NSString *library = nil;
		NSString *callNumber = nil;
		NSString *statusOftheBook = nil;
		
		[scan scanUpToString:@"/oclc/" intoString:nil];
		[scan scanUpToString:@"\"" intoString:&oCLC];
		oCLC = [oCLC substringFromIndex:6];
		//COPY TO THE BOOK OBJECT
		book.oCLCs = oCLC;
		//USE THAT OCLC AS ALSO TO GET XML
		baseLink = [NSURL URLWithString:[NSString stringWithFormat:@"http://uci.worldcat.org/wcpa/servlet/org.oclc.lac.deliveryresolverclient.AvailabilityFulfillmentServlet?oclcno=%@", book.oCLCs]];
		//OVER WRITES IT!!
		responsedHTML = [NSString stringWithContentsOfURL:baseLink encoding: NSUTF8StringEncoding error:nil];

		scan = [NSScanner scannerWithString:responsedHTML];
		
		//READ WHAT LIBRARY
		[scan scanUpToString:@"Libraries/" intoString:nil];
		[scan scanUpToString:@"," intoString:&library];
		library = [library substringFromIndex:10];
		book.location = library;
		
		[scan scanUpToString:@"(" intoString:&callNumber];
		callNumber = [callNumber substringFromIndex:2];
		book.callNumber = callNumber;
		
		[scan scanUpToString:@")" intoString:&statusOftheBook];
		statusOftheBook = [NSString stringWithFormat:@"%@)", statusOftheBook];
		book.status = statusOftheBook;
		
		//GET ISBN
		scan = [NSScanner scannerWithString:ptrHTML];
		[scan scanUpToString:@"isbn=" intoString:nil];
		[scan scanUpToString:@"&" intoString:&isBNs];
		isBNs = [isBNs substringFromIndex:5];
		book.iSBN = isBNs;
		
		
		//CONJURE ISBN FOR ANOTHER LINK
		NSURL *conjureSummary = [NSURL URLWithString:[NSString stringWithFormat:@"http://plus.syndetics.com/widget_response.php?id=oclctrial&isbn=%@&upc=&oclc=&enhancements=syn_summary,syn_series,syn_anotes,syn_awards,syn_toc,syn_dbchapter,syn_fiction,syn_pwreview,syn_ljreview,syn_sljreview,syn_blreview,syn_chreview,syn_hbreview,syn_kireview", book.iSBN]];
		responsedHTML = [NSString stringWithContentsOfURL:conjureSummary encoding: NSUTF8StringEncoding error:nil];
		
		//READ UP SUMMARY
		scan = [NSScanner scannerWithString:responsedHTML];
		[scan scanUpToString:@"Summary</div>" intoString:nil];
		
		[scan scanUpToString:@"<p>" intoString:nil];
		[scan scanUpToString:@"</p>" intoString:&summary];
		summary = [summary substringFromIndex:3];
		NSRange range = [summary rangeOfString:@"&nbsp"];
		
		if(range.location != NSNotFound) {
			summary = [summary stringByReplacingOccurrencesOfString:@"&nbsp" withString:@""];
		}
		book.summary = summary;
		
		//BIG IMAGE CONVERSION
		[self swapBigImageCover];
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
	@catch (NSException * e) 
	{
		
	}

}

- (void) swapBigImageCover 
{
	@try
	{
		NSScanner *scan = [NSScanner scannerWithString:book.imgURL];
		NSString *replace = @"";
		[scan scanUpToString:@"_" intoString:&replace];
		NSString *rest = @"";
		[scan scanUpToString:@".jpg" intoString:nil];
		[scan scanUpToString:@"" intoString:&rest];
		book.bigimgURL = [NSString stringWithFormat:@"%@_140%@", replace,rest];
	}
	@catch (NSException * e) 
	{
		book.bigimgURL = @"";
	}
}

- (void)viewDidLoad 
{
	self.title = @"Book Info";
	
	self.view.backgroundColor = RGB(255, 220, 194);
	
	// view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++) 
	{
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
	
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
	
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
	
	[self loadScrollViewWithPage:0];
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
	
    // replace the placeholder if necessary
	if (page==0) {
		BookViewController *controller1 = [viewControllers objectAtIndex:page];
		if ((NSNull *)controller1 == [NSNull null]&&book) {
			
			controller1 = [[BookViewController alloc] initWithPageNumber:page];
			[controller1 setBook:book];
			[book release];
			[viewControllers replaceObjectAtIndex:page withObject:controller1];
			[controller1 release];
		}
		// add the controller's view to the scroll view
		if (nil == controller1.view.superview) {
			CGRect frame = scrollView.frame;
			frame.origin.x = frame.size.width * page;
			frame.origin.y = 0;
			controller1.view.frame = frame;
			[scrollView addSubview:controller1.view];
		}
	}
    else if (page==1){
		LibraryMapViewController *controller2 = [viewControllers objectAtIndex:page];
		if ((NSNull *)controller2 == [NSNull null]&&book) {
			controller2 = [[LibraryMapViewController alloc] initWithPageNumber:page] ;
			[controller2 setBook:book];
			[book release];
			[viewControllers replaceObjectAtIndex:page withObject:controller2];
			[controller2 release];
		}
		if (nil == controller2.view.superview){
			CGRect frame = scrollView.frame;
			frame.origin.x = frame.size.width * page;
			frame.origin.y = 0;
			controller2.view.frame = frame;
			[scrollView addSubview:controller2.view];
		}
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender
{
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

@end
