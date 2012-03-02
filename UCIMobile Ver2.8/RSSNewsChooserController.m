//
//  RSSNewsChooserController.m
//  UCIMobile
//
//  Created by Yoon Lee on 8/13/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "RSSNewsChooserController.h"
#import "UCIRSSReaderController.h"

@implementation RSSNewsChooserController
@synthesize contents;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
	// basic structure
	// contents (NSArray) collection of content
	// content  (NSDictionary) Contains: (String)name, address, category
	NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"RSSList" ofType:@"plist"];
	
	contents = [NSArray arrayWithContentsOfFile:plistPath];
	[contents retain];
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"RSSLogo.png"]];
	self.navigationItem.titleView = imageView;
	[imageView release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
	NSInteger retVar = 0;
	
	if (section == 0) 
	{
		retVar = 9;
	}
	else 
	{
		retVar = 13;
	}
	
	return retVar;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSDictionary *content = nil;
	
	switch (indexPath.section) 
	{
		case 0:
			content = [contents objectAtIndex:indexPath.row];
			if ([[content objectForKey:@"category"] isEqualToString:@"news"])
			{
				cell.textLabel.text = [content objectForKey:@"name"];
				cell.imageView.image = [UIImage imageNamed:@"rssLabel.png"];
			}
			break;
			
		case 1:
			content = [contents objectAtIndex:indexPath.row+9];
			if ([[content objectForKey:@"category"] isEqualToString:@"Schools"])
			{
				cell.textLabel.text = [content objectForKey:@"name"];
				cell.imageView.image = [UIImage imageNamed:@"rssLabel.png"];
			}
			break;
		default:
			cell.textLabel.text = @"";
			break;
	}
	
    // Configure the cell...
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSDictionary *content = nil;
	NSString *url = @"";
	UCIRSSReaderController *reader = nil;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	switch (indexPath.section) 
	{
		case 0:
			content = [contents objectAtIndex:indexPath.row];
			if ([[content objectForKey:@"category"] isEqualToString:@"news"])
			{
				url = [content objectForKey:@"address"];
				reader = [[UCIRSSReaderController alloc] initWithNibName:@"UCIRSSReaderController" bundle:nil];
				reader.rss = url;
				[self.navigationController pushViewController:reader animated:YES];
				[reader release];
			}
			
			break;
			
		case 1:
			content = [contents objectAtIndex:indexPath.row+9];
			if ([[content objectForKey:@"category"] isEqualToString:@"Schools"])
			{
				url = [content objectForKey:@"address"];
				reader = [[UCIRSSReaderController alloc] initWithNibName:@"UCIRSSReaderController" bundle:nil];
				reader.rss = url;
				[self.navigationController pushViewController:reader animated:YES];
				[reader release];
			}
			
			break;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *retVar = @"";
	
	switch (section) 
	{
		case 0:
			retVar = @"Categories:";
			break;
		case 1:
			retVar = @"Schools:";
			break;
	}
	
	return retVar;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSString *retVar = @"";
	
	switch (section) 
	{
		case 1:
			retVar = @"Now it's even easier to stay on top of the news from UC Irvine. Subscribe to one of UCI's RSS (Really Simple Syndication) feeds, customized by category, and our news and feature headlines will be automatically delivered to your mobile. Just click on the RSS link for the category of interest.";
			break;
		default:
			retVar = @"";
			break;
	}
	
	return retVar;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"ORIENTATION CHANGED");
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	contents = nil;
    [super dealloc];
}


@end

