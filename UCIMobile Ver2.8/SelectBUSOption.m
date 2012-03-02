//
//  SelectBUSOption.m
//  UCIMobile
//
//  Created by Yoon Lee on 7/25/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "SelectBUSOption.h"
#import <QuartzCore/QuartzCore.h>
#import "TFHpple.h"
#import "ASIFormDataRequest.h"

@implementation SelectBUSOption
@synthesize _tableView;
@synthesize delegate;
@synthesize cacheRoute, routes, stops;
@synthesize routePtr;
@synthesize _naviBar;
#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 280, 30)];
	label1.text = @"Target the Route to display live Map";
	label1.textAlignment = UITextAlignmentLeft;
	label1.textColor = [UIColor whiteColor];
	label1.font = [UIFont boldSystemFontOfSize:14];
	label1.backgroundColor = [UIColor clearColor];
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 280, 30)];
	label2.text = @"Check the BUS arrival time in bottom section";
	label2.textAlignment = UITextAlignmentLeft;
	label2.textColor = [UIColor whiteColor];
	label2.font = [UIFont fontWithName:@"Georgia" size:12];
	label2.backgroundColor = [UIColor clearColor];
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 60)];
	[imgView addSubview:label2];
	[imgView addSubview:label1];
	self._naviBar.topItem.titleView = imgView;
	[imgView release];
	[label1 release];
	[label2 release];
	
	numberOfLines = 1;
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    if (clicked)
	{
		return 2;
	}
	else 
	{
		return 1;
	}
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
	
	NSInteger retVar = 0;
	switch (section) 
	{
		case 0:
			retVar = [routes count];
			break;
		case 1:
			//of course size of stops
			retVar = [stops count];
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	UIImage *image = nil;
	NSString *route = nil;
	NSDictionary *lane = nil;
	NSDictionary *stop = nil;

	switch (indexPath.section) 
	{
		case 0:
			lane = [routes objectAtIndex:indexPath.row];
			route = [lane objectForKey:@"routeName"];
			
			//image might move to will display image method.
			
			if ([route isEqualToString:@"VDC/VDCN Summer"]) 
			{
				image = [UIImage imageNamed:@"VDC_Summer.png"];
			}
			else if ([route isEqualToString:@"Main Campus"])
			{
				image = [UIImage imageNamed:@"main.png"];
			}
			else if ([route isEqualToString:@"Newport"]) 
			{
				image = [UIImage imageNamed:@"newport.png"];
			}
			else if ([route isEqualToString:@"PW-Carlson"]) 
			{
				image = [UIImage imageNamed:@"PW.png"];
			}
			else if ([route isEqualToString:@"VDC-Admin"]) 
			{
				image = [UIImage imageNamed:@"VDC.png"];
			}
			else if ([route isEqualToString:@"VDC Norte"]) 
			{
				image = [UIImage imageNamed:@"VDCN.png"];
			}
			else if ([route isEqualToString:@"AV-Admin-ARC"]) 
			{
				image = [UIImage imageNamed:@"AVADMIN.png"];
			}
			else if ([route isEqualToString:@"Puerta Del Sol Summer"]) 
			{
				image = [UIImage imageNamed:@"PuertaSummer.png"];
			}
			else if ([route isEqualToString:@"Camino Del Sol"]) 
			{
				image = [UIImage imageNamed:@"Camino.png"];
			}
			else if ([route isEqualToString:@"Saturday ISC-Train"])
			{
				image = [UIImage imageNamed:@"Trail.png"];
			}
			else 
			{
				image = [UIImage imageNamed:@"night.png"];
			}
			
			cell.imageView.image = image;
			cell.imageView.layer.masksToBounds = YES;
			cell.imageView.layer.borderColor = [[UIColor blackColor] CGColor];
			cell.imageView.layer.borderWidth = 1.0;
			cell.imageView.layer.cornerRadius = 7.0;
			cell.textLabel.text = route;
			cell.detailTextLabel.text = @"";
			break;
			
		case 1:
			//hasEstimateYet = [stop objectForKey:@"estimate"];
			cell.imageView.image = nil;
			cell.textLabel.numberOfLines = 0;
			cell.detailTextLabel.numberOfLines = 0;
			stop = [stops objectAtIndex:indexPath.row];
			cell.textLabel.text = [stop objectForKey:@"name"];
			if (![stop objectForKey:@"estimate"]||[[stop objectForKey:@"estimate"] isEqualToString:@""]) 
			{
				cell.detailTextLabel.text = @"";
			}
			else 
			{
				cell.detailTextLabel.text = [stop objectForKey:@"estimate"];
			}
			break;
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	NSDictionary *route;
	NSString *isSelected;
	
	cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
	
	switch (indexPath.section) 
	{
		case 0:
			route = [routes objectAtIndex:indexPath.row];
			isSelected = [route objectForKey:@"selected"];
			//NSLog(@"will display cell : %@", isSelected);
			
			if ([isSelected isEqualToString:@"0"]) 
			{
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			break;
			
		case 1:
			cell.accessoryType = UITableViewCellAccessoryNone;
			break;
	}
}

-(IBAction) selectRoute 
{	
	[self.delegate preferenceHasBeenFinish:self];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSDictionary *stop;
	NSString *stopValue;
	NSDictionary *route;
	NSDictionary *otherRoute;
	NSString *isSelected;
	NSUInteger sectionIndex = 1;
	UITableViewCell *cell = [self._tableView cellForRowAtIndexPath:indexPath];
	int countSelected = 0;
	NSArray *visibleCell;
	UITableViewCell *celllookup;
	
	switch (indexPath.section) 
	{
			//displays routine of shuttle
		case 0:	
			//do action
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			route  = [routes objectAtIndex:indexPath.row];
			isSelected = [route objectForKey:@"selected"];
			selectedRouteValue = [route objectForKey:@"value"];
			
			//if it is already selected... need to remark deselected
			//default is set for all '0' by the way
			if ([isSelected isEqualToString:@"1"]) 
			{
				//animation start
				[tableView beginUpdates];
				[route setValue:@"0" forKey:@"selected"];
				cell.accessoryType = UITableViewCellAccessoryNone;
				//deselect everything
				[tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
				clicked = NO;
			}
			//else it is not selected... need to mark selected
			else {
				for (int i=0; i<[routes count]; i++) 
				{
					otherRoute = [routes objectAtIndex:i];
					isSelected = [otherRoute objectForKey:@"selected"];
					if ([isSelected isEqualToString:@"1"]) 
					{
						[otherRoute setValue:@"0" forKey:@"selected"];
						countSelected ++;
					}
				}
				
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
				[route setValue:@"1" forKey:@"selected"];
				stops = [route objectForKey:@"stops"];
				self.routePtr = route;
				//NSLog(@"%d", [routes retainCount]);
				//[route release];
				if (countSelected > 0)
				{
					clicked = YES;
					visibleCell = [self._tableView visibleCells];
					for (int j=0; j<[visibleCell count]; j++)
					{
						celllookup = [visibleCell objectAtIndex:j];
						if (celllookup.accessoryType==UITableViewCellAccessoryCheckmark) 
						{
							celllookup.accessoryType = UITableViewCellAccessoryNone;
						}
					}
					cell.accessoryType = UITableViewCellAccessoryCheckmark;
					
					[self._tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
					[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
					return;
				}
				else 
				{
					//animation start
					[tableView beginUpdates];
					[tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
					clicked = YES;
				}
			}
			
			//commit animation
			[tableView endUpdates];		
			
			break;
			//displays estimated arrival time selected routine.
		case 1:
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			//do action
			//refreshes when it selects
			stop = [stops objectAtIndex:indexPath.row];
			stopValue = [stop objectForKey:@"value"];
			[self leftOverTime:selectedRouteValue with:stopValue selectedIndexPath:indexPath];
			break;
	}	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{	
	NSString *script;
	
	switch (section) 
	{
		case 0:
			script = @"Select the Shuttle Route to display and estimate arrival times for the destination.";
			break;
		default:
			script = @"Estimated arrival time for each destination.";
			break;
	}
	return script;
}

- (void) estimateShuttleTime:(UITableView *)tableView selectedIndexPath:(NSIndexPath *)indexPath 
{	
	NSUInteger sectionIndex = 1;
	
	UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
	
	
	NSDictionary *route  = [routes objectAtIndex:indexPath.row];
	stops = [route objectForKey:@"stops"];
	
	[tableView beginUpdates];
	
	if (selectedCell.accessoryType == UITableViewCellAccessoryNone) 
	{
		[tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
		clicked = NO;
		//to do, fetch start once it get selected.
	}
	else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark)
	{
		[tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
		clicked = YES;
		//to do, remove start once it get selected.
	}
	
	[tableView endUpdates];
}

- (void) leftOverTime:(NSString *)routeValue with:(NSString *)stopValue selectedIndexPath:(NSIndexPath *)indexPath 
{
	//NSLog(@"%@", stopValue);
	NSString *address = [NSString stringWithFormat:@"http://public.syncromatics.com/xml.scrx?mode=arrivals&route=%@&stop=%@&domain=ucishuttles.com", routeValue, stopValue];
	//NSString *address = @"http://sites.google.com/site/ucimobilesimulator/xml.scrx.xml";
	//NSString *address = [NSString stringWithFormat:@"http://sites.google.com/site/ucimobilesimulator/%@.xml", stopValue];
	NSURL *url = [NSURL URLWithString:address];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request startSynchronous];
	
	TFHpple *tfhpple = [[TFHpple alloc] initWithXMLData:[request responseData]];
	TFHppleElement *element;
	NSArray *time = [tfhpple search:@"/reply"];
	NSArray *child;
	NSDictionary *busEstimate;
	NSString *estimateTime = @"";
	@try 
	{
		element = [time objectAtIndex:0];
		//NSLog(@"%@", [element description]);
		child = [element childArray];
		
		for (int i=0; i<[child count]; i++) 
		{
			element = [child objectAtIndex:i];
			//NSLog(@"%@",[element description]);
			
			busEstimate = [element attributes];
			
			estimateTime = [estimateTime stringByAppendingFormat:@"%d: BUS#%@ arrives in %@ min\n", i+1, [busEstimate objectForKey:@"vehicle"], [busEstimate objectForKey:@"value"]];
			numberOfLines = i+1;
			//NSLog(@"%@", estimateTime);
		}
	}
	@catch (NSException * e) 
	{
		estimateTime = @"No predictions available.";
		numberOfLines = 1;
	}
	
	if ([estimateTime isEqualToString:@""]) 
	{
		estimateTime = @"No predictions available.";
		numberOfLines = 1;
	}
	NSDictionary *stop = [stops objectAtIndex:indexPath.row];
	[stop setValue:estimateTime forKey:@"estimate"];
	
	[self._tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects: indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
	[tfhpple release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	CGFloat retVar = 0;
	NSDictionary *stop;
	NSString *hasSomething;
	
	switch (indexPath.section) {
		case 0:
			retVar = 45.0;
			break;
			
		case 1:
			stop = [stops objectAtIndex:indexPath.row];
			hasSomething = [stop objectForKey:@"estimate"];
			if (!hasSomething||[hasSomething isEqualToString:@""]) 
			{
				retVar = 45.0;
			}
			else {
				if (numberOfLines==1) 
				{
					retVar = 45.0;
				}
				else if (numberOfLines==2) 
				{
					retVar = 65.0;
				}
				else 
				{
					retVar = 75.0;
				}
			}
			break;
	}
	
	return retVar;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void) initWithCurrentSeason 
{
	//bundle import
	//one: color line
	//two: stops immage annotation
	if ([cacheRoute count]>0) 
	{
		return;
	}
	
	NSURL *myserver = [NSURL URLWithString:@"https://sites.google.com/site/ucimobilesimulator/Bus_1.7.7.plist"];
	
	self.cacheRoute = [[NSMutableDictionary alloc] initWithContentsOfURL:myserver];
	//NSString *path = [[NSBundle mainBundle] pathForResource:@"Bus_1.7.7" ofType:@"plist"];
	//self.cacheRoute = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	
	if ([self isSummerSeason]) 
	{
		NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
		
		for (NSDictionary *contents in [cacheRoute objectForKey:@"Entire Routes"]) 
		{
			if ([[contents objectForKey:@"summer"] isEqualToString:@"1"]) 
			{
				[filteredArray addObject:contents];
			}
		}
		
		routes = [[NSMutableArray alloc] initWithArray:filteredArray];
		[filteredArray release];
	}
	else
	{
		NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
		
		for (NSDictionary *contents in [cacheRoute objectForKey:@"Entire Routes"]) 
		{
			if ([[contents objectForKey:@"summer"] isEqualToString:@"0"]) 
			{
				[filteredArray addObject:contents];
			}
		}
		
		routes = [[NSMutableArray alloc] initWithArray:filteredArray];
		[filteredArray release];
	}

}

//7 ~ 8 Yes it is whole summer!
- (BOOL) isSummerSeason 
{
	NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
	[dateformatter setDateFormat:@"MM"];
	NSString *prediction = [dateformatter stringFromDate:[NSDate date]];
	
	if ([prediction isEqualToString:@"07"]||[prediction isEqualToString:@"08"]) 
	{
		[dateformatter release];
		return YES;
	}
	[dateformatter release];
	return NO;
}

//6, 9 Yes it is begin and end summer!
- (BOOL) isEndORStartSummerSession
{
	NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
	[dateformatter setDateFormat:@"MM"];
	NSString *prediction = [dateformatter stringFromDate:[NSDate date]];
	
	if ([prediction isEqualToString:@"06"]||[prediction isEqualToString:@"09"]) 
	{
		[dateformatter release];
		return YES;
	}
	
	
	[dateformatter release];
	return NO;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

- (void) dealloc 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[routes release];
	routes = nil;
	[stops release];
	stops = nil;
	selectedRouteValue = nil;
	[cacheRoute release];
	cacheRoute = nil;
    [super dealloc];
}

@end

