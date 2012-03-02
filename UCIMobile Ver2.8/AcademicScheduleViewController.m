//
//  AcademicScheduleViewController.m
//  MyUCI
//
//  Created by Yoon Lee on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AcademicScheduleViewController.h"
#import "QuarterActivities.h"
#import "SelectedAcademicScheduleController.h"

@implementation AcademicScheduleViewController
@synthesize managedObjectContext;
@synthesize recieverQuarterActivities;
#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 220, 30)];
	label1.text = @"UCI Academic Calendar";
	label1.textAlignment = UITextAlignmentLeft;
	label1.textColor = [UIColor whiteColor];
	label1.font = [UIFont boldSystemFontOfSize:14];
	label1.backgroundColor = [UIColor clearColor];
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 220, 30)];
	label2.text = @"Information about important date";
	label2.textAlignment = UITextAlignmentLeft;
	label2.textColor = [UIColor whiteColor];
	label2.font = [UIFont fontWithName:@"Georgia" size:12];
	label2.backgroundColor = [UIColor clearColor];
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 60)];
	[imgView addSubview:label2];
	[imgView addSubview:label1];
	self.navigationItem.titleView = imgView;
	[imgView release];
	[label1 release];
	[label2 release];
	
	NSError *err = nil;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"QuarterActivities" inManagedObjectContext:self.managedObjectContext]];
	self.recieverQuarterActivities = [[self.managedObjectContext executeFetchRequest:request error:&err] mutableCopy];
	[request release];
	self.tableView.rowHeight = 70.0;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.recieverQuarterActivities count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	QuarterActivities *quarters = (QuarterActivities *)[self.recieverQuarterActivities objectAtIndex:indexPath.row];
	
    // Configure the cell...
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
	cell.textLabel.text = [NSString stringWithFormat:@"   %@", [quarters quarterRepresent]];
	UIImage *image = nil;
	int num = indexPath.row%4;
	switch (num) {
		case 0:
			image = [UIImage imageNamed:@"spr.png"];
			break;
		case 1:
			image = [UIImage imageNamed:@"sp.png"];
			break;
		case 2:
			image = [UIImage imageNamed:@"fall.png"];
			break;
		case 3:
			image = [UIImage imageNamed:@"wint.png"];
			break;

	}
	cell.imageView.image = image;
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SelectedAcademicScheduleController *letsView = [[SelectedAcademicScheduleController alloc] initWithStyle:UITableViewStyleGrouped];
	[letsView setByPassRowNumber:indexPath.row];
	[letsView setRecievedInformation:recieverQuarterActivities];
	[self.navigationController pushViewController:letsView animated:YES];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	[letsView release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	managedObjectContext = nil;
	recieverQuarterActivities = nil;
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
	[managedObjectContext release];
	[recieverQuarterActivities release];
	[super dealloc];
}


@end

