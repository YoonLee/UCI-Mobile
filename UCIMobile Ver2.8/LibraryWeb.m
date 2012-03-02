//
//  LibraryWeb.m
//  UCIMobile
//
//  Created by Yoon Lee on 8/10/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "LibraryWeb.h"
#import "Reachability.h"

@implementation LibraryWeb
@synthesize webViews;

- (void)viewDidLoad 
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
	}
	
	NSURL *url = [NSURL URLWithString:@"http://www.lib.uci.edu/mobile/webkit/"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[webViews loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (IBAction) closeCurrentView
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc
{
    [super dealloc];
}


@end
