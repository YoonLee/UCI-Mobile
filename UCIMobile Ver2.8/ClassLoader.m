//
//  ClassLoader.m
//  UCIMobile
//
//  Created by Yoon Lee on 8/8/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "ClassLoader.h"
#import "SearchWebView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ClassLoader
@synthesize site, link, name, searchBar, badge;

- (void)viewDidLoad 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	if ([self.name isEqualToString:@"Wikipedia"]) 
	{
		UIImageView *imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"wikilogo.png"]];
		self.navigationItem.titleView = imageView;
		[imageView release];
	}
	else 
	{
		self.title = self.name;
	}
    
	NSURL *url = [NSURL URLWithString:self.link];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.site loadRequest:request];
	self.site.backgroundColor = [UIColor clearColor];
	isOperate = NO;
	badge.layer.cornerRadius = 7.0;
	badge.hidden = YES;
	badge.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	badge.layer.borderWidth = 2.0;
    
    [self.site setScalesPageToFit:YES];
	
    self.site.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	
}

- (IBAction) searchWebTextContent
{
	if (!isOperate) 
	{
		[self.navigationController setNavigationBarHidden:YES animated:YES];
		self.searchBar.hidden = NO;
		self.badge.hidden = NO;
		isOperate = YES;
	}
	else 
	{
		[self.navigationController setNavigationBarHidden:NO animated:YES];
		self.searchBar.hidden = YES;
		self.badge.hidden = YES;
		isOperate = NO;
	}
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.searchBar.hidden = YES;
	self.badge.hidden = YES;
	isOperate = NO;
	[self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[self.site removeAllHighlights];
	if (![searchText isEqualToString:@""]) 
	{
		self.badge.hidden = NO;
		self.badge.text = [self.site highlightAllOccurencesOfString:searchText];
	}
	else 
	{
		self.badge.text = @"0";
	}

	// called when text changes (including clear)	
}

- (void)dealloc 
{	 
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[badge release];
	[searchBar release];
	[site release];
    [super dealloc];
}


@end
