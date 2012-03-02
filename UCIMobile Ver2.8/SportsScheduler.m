//
//  SportsScheduler.m
//  UCIMobile
//
//  Created by Yoon Lee on 9/25/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "SportsScheduler.h"
#import <QuartzCore/QuartzCore.h>
#import "ClassLoader.h"

@implementation SportsScheduler
@synthesize allEvents;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
	NSString *pathSportFile = [[NSBundle mainBundle] pathForResource:@"BREN" ofType:@"plist"];
	NSArray *instance = [[NSArray alloc] initWithContentsOfFile:pathSportFile];
	allEvents = [[NSMutableArray alloc] initWithArray:instance];
	[instance release];
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 280, 30)];
	label1.text = @"UCI Atheletic Webpages";
	label1.textAlignment = UITextAlignmentLeft;
	label1.textColor = [UIColor whiteColor];
	label1.font = [UIFont boldSystemFontOfSize:14];
	label1.backgroundColor = [UIColor clearColor];
	label1.tag = 1;
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 280, 30)];
	label2.text = @"Information UCI Atheletic and Bren Event";
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
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    return [allEvents count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSInteger retVar = 0;
	NSArray *categories = nil;
	NSDictionary *gender = nil;
	
    // Return the number of rows in the section.
	switch (section) 
	{
		case 0:
			gender = [allEvents objectAtIndex:section];
			categories = [NSArray arrayWithArray:[gender objectForKey:@"genre"]];
			retVar = categories.count;
			break;
		case 1:
			gender = [allEvents objectAtIndex:section];
			categories = [NSArray arrayWithArray:[gender objectForKey:@"genre"]];
			retVar = categories.count;
			break;
		case 2:
			gender = [allEvents objectAtIndex:section];
			categories = [NSArray arrayWithArray:[gender objectForKey:@"genre"]];
			retVar = categories.count;
			break;
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
	
	NSDictionary *gender = nil;
	
	NSMutableArray *sports = nil;
	NSMutableDictionary *detail = nil;
	NSString *sport = @"";
	
    // Configure the cell...
	switch (indexPath.section) 
	{
		case 0:
			gender = [allEvents objectAtIndex:indexPath.section];
			sports = [gender objectForKey:@"genre"];
			detail = [sports objectAtIndex:indexPath.row];
			sport = [detail objectForKey:@"sport"];
			cell.textLabel.text = sport;
			break;
		case 1:
			gender = [allEvents objectAtIndex:indexPath.section];
			sports = [gender objectForKey:@"genre"];
			detail = [sports objectAtIndex:indexPath.row];
			sport = [detail objectForKey:@"sport"];
			cell.textLabel.text = sport;
			break;
		case 2:
			gender = [allEvents objectAtIndex:indexPath.section];
			sports = [gender objectForKey:@"genre"];
			detail = [sports objectAtIndex:indexPath.row];
			sport = [detail objectForKey:@"sport"];
			cell.textLabel.text = sport;
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{	
	// celll type declare
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	cell.textLabel.textColor = [UIColor blackColor];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSDictionary *gender = nil;
	
	NSMutableArray *sports = nil;
	NSMutableDictionary *detail = nil;
	ClassLoader *websiteLoader;
	
	switch (indexPath.section) 
	{
		case 0:
			gender = [allEvents objectAtIndex:indexPath.section];
			sports = [gender objectForKey:@"genre"];
			detail = [sports objectAtIndex:indexPath.row];
			websiteLoader = [[ClassLoader alloc] initWithNibName:@"ClassLoader" bundle:nil];
			websiteLoader.link = [detail objectForKey:@"website"];
			websiteLoader.name = [detail objectForKey:@"sport"];
			[self.navigationController pushViewController:websiteLoader animated:YES];
			[websiteLoader release];
			break;
		case 1:
			gender = [allEvents objectAtIndex:indexPath.section];
			sports = [gender objectForKey:@"genre"];
			detail = [sports objectAtIndex:indexPath.row];
			websiteLoader = [[ClassLoader alloc] initWithNibName:@"ClassLoader" bundle:nil];
			websiteLoader.link = [detail objectForKey:@"website"];
			websiteLoader.name = [detail objectForKey:@"sport"];
			[self.navigationController pushViewController:websiteLoader animated:YES];
			[websiteLoader release];
			break;
		case 2:
			gender = [allEvents objectAtIndex:indexPath.section];
			sports = [gender objectForKey:@"genre"];
			detail = [sports objectAtIndex:indexPath.row];
			websiteLoader = [[ClassLoader alloc] initWithNibName:@"ClassLoader" bundle:nil];
			websiteLoader.link = [detail objectForKey:@"website"];
			websiteLoader.name = @"Bren Event";
			[self.navigationController pushViewController:websiteLoader animated:YES];
			[websiteLoader release];
			break;
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *retStr = @"";
	
	switch (section) 
	{
		case 0:
			retStr = @"Women's";
			break;
		case 1:
			retStr = @"Men's";
			break;
		case 2:
			retStr = @"Bren Events";
			break;
	}
	
	return retStr;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSString *retStr = @"";
	
	switch (section) 
	{
		case 1:
			retStr = @"UC Irvine’s Department of Intercollegiate Athletics enriches students’ education and personal growth by providing opportunities to participate in competitive NCAA Division I athletics. Intercollegiate Athletics is committed to the welfare of student-athletes and staff and promotes excellence in athletic and academic performance, sportsmanship, diversity and gender equity. Intercollegiate Athletics also supports the University of California’s mission of public service and generates a unifying spirit among students, faculty, staff and alumni that transcends communities, cultures and generations.";
			break;
			
		case 2:
			retStr = @"An elegantly designed, modern arena on the campus of the University of California, Irvine, the Bren Events Center provides an exciting and prestigious location in Orange County for a full array of musical, performance, exhibition, sporting, and other public events.";
			break;
		default:
			break;
	}
	
	return retStr;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"ORIENTATION CHANGED");
}

- (void)dealloc 
{
	[allEvents release];
	allEvents = nil;
    [super dealloc];
}


@end

