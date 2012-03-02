//
//  EntireMapView.m
//  MyUCI
//
//  Created by Yoon Lee on 3/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EntireMapView.h"
#import "CampusMapStorage.h"
#import "CampusMapRequest.h"

@implementation EntireMapView
@synthesize managedObjectContext, storeEntireMap;
@synthesize filteredContents, savedSearchTerm, searchWasActive, savedScopeButtonIndex;
@synthesize _tableView;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
	
    [self fetchTheMap];
	self.filteredContents = [NSMutableArray arrayWithCapacity:[self.storeEntireMap count]];
	
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 180, 30)];
	label1.text = @"UCI Building Search";
	label1.textAlignment = UITextAlignmentLeft;
	label1.textColor = [UIColor whiteColor];
	label1.font = [UIFont boldSystemFontOfSize:14];
	label1.backgroundColor = [UIColor clearColor];
	label1.tag = 1;
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 200, 30)];
	label2.text = @"Search the location of building";
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
	
	//restore search setting
	if (self.savedSearchTerm) 
	{
		[self.searchDisplayController setActive:self.searchWasActive];
		[self.searchDisplayController.searchBar setSelectedScopeButtonIndex:savedScopeButtonIndex];
		[self.searchDisplayController.searchBar setText:savedSearchTerm];
		
		self.savedSearchTerm = nil;
	}
	
	[self._tableView reloadData];
	self._tableView.scrollEnabled = YES;
	[super viewDidLoad];
}

- (void)fetchTheMap
{
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"CampusMapStorage" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	NSError *err = nil;
	storeEntireMap = [[managedObjectContext executeFetchRequest:request error:&err] mutableCopy];
	
	[request release];
}

- (void)viewWillAppear:(BOOL)animated
{
	
    [super viewWillAppear:animated];
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
    if (tableView == self.searchDisplayController.searchResultsTableView) 
	{
		return [self.filteredContents count];
	}
	else 
	{
		return [self.storeEntireMap count];
	}
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
	
	CampusMapStorage *campus = nil;
	
	if (tableView == self.searchDisplayController.searchResultsTableView) 
	{
		campus = (CampusMapStorage *)[self.filteredContents objectAtIndex:indexPath.row];
	}
	else 
	{
		campus = (CampusMapStorage *)[storeEntireMap objectAtIndex:indexPath.row];
	}
	NSString *buildingNumber = [NSString stringWithFormat:@"%@",campus.numBuilding];
	
	if ([buildingNumber isEqualToString:@"0"]) 
	{
		buildingNumber = @"";
	}
	
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ %@" ,campus.abreviateBname, buildingNumber];
	cell.detailTextLabel.text = campus.extendBname;
	
	
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row%2!=0)
	{
		cell.backgroundColor = RGB(239, 239, 239);
		cell.imageView.image = [UIImage imageNamed:@"building-low.png"];
	}
	
	else if (indexPath.row%2==0)
	{
		cell.backgroundColor = RGB(204, 204, 204);
		cell.imageView.image = [UIImage imageNamed:@"building.png"];
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	self.navigationItem.hidesBackButton = YES;
	//google api launch by its location part
	CampusMapStorage *campus = nil;
	CampusMapRequest *request = [[CampusMapRequest alloc] initWithNibName:@"CampusMapRequest" bundle:nil];
	
	if (tableView == self.searchDisplayController.searchResultsTableView) 
	{
		campus = (CampusMapStorage *)[self.filteredContents objectAtIndex:indexPath.row];
	}
	else 
	{
		campus = (CampusMapStorage *)[storeEntireMap objectAtIndex:indexPath.row];
	}
	request.context = self.managedObjectContext;
	//[managedObjectContext release];
	request.directMapPosition = campus;
	
	[request setIsEntireMapView:YES];
	[self.navigationController pushViewController:request animated:YES];
	[self._tableView deselectRowAtIndexPath:indexPath animated:YES];
	[request release];
	[campus release];
	self.navigationItem.hidesBackButton = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 60.0;
}

- (void)filteredContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
	//update the filtered array based on the search text and scope.
	[self.filteredContents removeAllObjects];
	
	for (CampusMapStorage *campus in storeEntireMap) 
	{
		if([scope isEqualToString:@"Bldg Abbr"]) 
		{
			NSComparisonResult result = [campus.abreviateBname compare:searchText options: (NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
			if (result==NSOrderedSame) 
			{
				[self.filteredContents addObject:campus];
			}
		}
		else if([scope isEqualToString:@"Bldg Num"]) 
		{
			NSComparisonResult result = [[campus.numBuilding stringValue] compare:searchText options: (NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
			if (result==NSOrderedSame) 
			{
				[self.filteredContents addObject:campus];
			}
		}
		else if([scope isEqualToString:@"Bldg Full Name"])
		{
			NSComparisonResult result = [campus.extendBname compare:searchText options: (NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
			if (result==NSOrderedSame) 
			{
				[self.filteredContents addObject:campus];
			}
		}
		
		
	}
}

//delegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	[self filteredContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
	return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption 
{
	[self filteredContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
}

- (void)viewDidUnload
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	managedObjectContext = nil;
	storeEntireMap = nil;
	filteredContents = nil;
	savedSearchTerm = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

- (void)dealloc 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[storeEntireMap release];
	[filteredContents release];
	[savedSearchTerm release];
	[super dealloc];
	
}


@end

