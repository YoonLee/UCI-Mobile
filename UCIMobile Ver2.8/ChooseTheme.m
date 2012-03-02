//
//  ChooseTheme.m
//  UCIMobile
//
//  Created by Yoon Lee on 12/15/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "ChooseTheme.h"


@implementation ChooseTheme


#pragma mark -
#pragma mark Initialization

- (void)viewDidLoad 
{
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)initThingstoDo:(ThingsToDo *)thingsTodo
{
	instance = thingsTodo;
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
    return 4;
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
    
    // Configure the cell...
    
	switch (indexPath.row) 
	{
		case 0:
			cell.textLabel.text = @"heart";
			break;
		case 1:
			cell.textLabel.text = @"cloud";
			break;
		case 2:
			cell.textLabel.text = @"animal";
			break;
		case 3:
			cell.textLabel.text = @"scratch note";
			break;
	}
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	for (UITableViewCell *cellModule in tableView.visibleCells) 
	{
		if (cellModule.accessoryType==UITableViewCellAccessoryCheckmark) 
		{
			cellModule.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	
	// chages display
	[instance applyDisplay:indexPath.row];
	cell.accessoryType=UITableViewCellAccessoryCheckmark;
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc 
{
    [super dealloc];
}


@end

