//
//  SelectedAcademicScheduleController.m
//  MyUCI
//
//  Created by Yoon Lee on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SelectedAcademicScheduleController.h"
#import "QuarterActivities.h"

@implementation SelectedAcademicScheduleController
@synthesize recievedInformation;
@synthesize byPassRowNumber;

#pragma mark -
#pragma mark Initialization

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	QuarterActivities *quarter = (QuarterActivities *)[recievedInformation objectAtIndex:byPassRowNumber];
	
	self.tableView.backgroundColor = RGB(255, 255, 255);
	self.title = quarter.quarterRepresent;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0) {
		return 12;
	}
	else if(section == 1) {
		return 8;
	}
	else {
		return 3;
	}
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *represent;
	
	if (section==0) {
		represent = @"Quarter Activities";
	}
	else if(section==1) {
		represent = @"Last Day to";
	}
	else {
		represent = @"Holidays";
	}
	
	return represent;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat retVar = 0.0;
	
	switch (indexPath.section) {
		case 0:
			if (indexPath.row%2!=0) {
				retVar = 50.0;
				break;
			}
			else if (indexPath.row%2==0){
				retVar = 20.0;
				break;
			}
			
			break;
		case 1:
			if (indexPath.row%2!=0) {
				retVar = 50.0;
				break;
			}
			else if (indexPath.row%2==0){
				retVar = 20.0;
				break;
			}
			break;
		case 2:
			if (indexPath.row==0) {
				retVar = 20.0;
			}
			else {
				retVar = 60.0;
			}
			break;
	}
	
	return retVar;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			//if the row is odd number
			if (indexPath.row%2!=0) {
				//cell.indentationLevel = 0;
				cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
				cell.imageView.image = [UIImage imageNamed:@"calendar--arrow.png"];
				cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:11];
				cell.backgroundColor = RGB(239, 239, 239);
			}
			//else if the row is even number
			else if (indexPath.row%2==0){
				//cell.indentationLevel = 7;
				cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
				cell.imageView.image = nil;
				cell.backgroundColor = RGB(204, 204, 204);
			}
			break;
		case 1:
			//if the row is odd number
			if (indexPath.row%2!=0) {
				//cell.indentationLevel = 0;
				cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
				cell.imageView.image = [UIImage imageNamed:@"calendar--arrow.png"];
				cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:11];
				cell.backgroundColor = RGB(239, 239, 239);
			}
			//else if the row is even number
			else if (indexPath.row%2==0){
				//cell.indentationLevel = 7;
				cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
				cell.imageView.image = nil;
				cell.backgroundColor = RGB(204, 204, 204);
			}
			break;
		case 2:
			if (indexPath.row==0) {
				cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
				cell.imageView.image = nil;
				cell.backgroundColor = RGB(204, 204, 204);
			}
			else {
				cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
				cell.imageView.image = [UIImage imageNamed:@"christmas-tree.png"];
				cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:11];
				cell.backgroundColor = RGB(239, 239, 239);
			}
			
			break;
			
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	static NSString *CellID2 = @"Yoon";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellID2];
	
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		
	}
	
	if (cell2 == nil) {
		cell2 = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID2] autorelease];
		cell2.textLabel.textAlignment = UITextAlignmentCenter;
	}
	
	QuarterActivities *quarter = (QuarterActivities *)[recievedInformation objectAtIndex:byPassRowNumber];

	//Default Section
	cell.detailTextLabel.numberOfLines = 0;
	cell.textLabel.numberOfLines = 0;
	cell2.accessoryType = UITableViewCellAccessoryNone;
	cell2.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	switch (indexPath.section) {
		case 0:
			cell.textLabel.numberOfLines = 0;
			switch (indexPath.row) {
				case 0:
					cell2.textLabel.text = @"Instruction Begins";
					return cell2;
				case 1:
					cell.textLabel.text = quarter.instructionbegin;
					cell.detailTextLabel.text = @"First day of class";
					break;
				case 2:
					cell2.textLabel.text = @"Last Day to Change Courses";
					return cell2;
				case 3:
					cell.textLabel.text = quarter.withoutDeanSignature;
					cell.detailTextLabel.text = @"Add or Drop a class without dean's signature approval";
					break;
				case 4:
					cell2.textLabel.text = @"'W' Assigned After";
					return cell2;
				case 5:
					cell.textLabel.text = quarter.wAfterAssigns;
					cell.detailTextLabel.text = @"Grade of 'W' assigned if dropped after this date";
					break;
				case 6:
					cell2.textLabel.text = @"Next schedule avilable";
					return cell2;
				case 7:
					cell.textLabel.text = quarter.scheduleAvailable;
					cell.detailTextLabel.text = @"Next quarter schedule is released to WebSOC";
					break;
				case 8:
					cell2.textLabel.text = @"Final Examinations";
					return cell2;
				case 9:
					cell.textLabel.text = quarter.finalExamination;
					cell.detailTextLabel.text = @"Course Final Examinations";
					break;
				case 10:
					cell2.textLabel.text = @"Grade Releases";
					return cell2;
				case 11:
					cell.textLabel.text = quarter.waitlistRelease;
					cell.detailTextLabel.text = @"Final course grades posted to Student Access";
					break;
			}
			break;
		case 1:
			switch (indexPath.row) {
				case 0:
					cell2.textLabel.text = @"Enroll Electronically Until";
					return cell2;
				case 1:
					cell.textLabel.text = quarter.enrollelectricly;
					cell.detailTextLabel.text = @"Enroll electronically via EAD WebReg";
					break;
				case 2:
					cell2.textLabel.text = @"Pay Fee on Time";
					return cell2;
				case 3:
					cell.textLabel.text = quarter.payfeeOntime;
					cell.detailTextLabel.text = @"$50 fee after this date; classes dropped";
					break;
				case 4:
					cell2.textLabel.text = @"Submit card without $3 fee";
					return cell2;
				case 5:
					cell.textLabel.text = quarter.submitCard;
					cell.detailTextLabel.text = @"Registrar's office charges after this date";
					break;
				case 6:
					cell2.textLabel.text = @"Final deadline to pay fee";
					return cell2;
				case 7:
					cell.textLabel.text = quarter.finalDeadLine;
					cell.detailTextLabel.text = @"Loss of student status after date";
					break;
					
			}
			break;
		case 2:
			switch (indexPath.row)
		{
				case 0:
					cell2.textLabel.text = @"Holidays";
					return cell2;
				case 1:
					cell.textLabel.text = quarter.holiday1;
					cell.detailTextLabel.text = @"";
					break;
				case 2:
					cell.textLabel.text = quarter.holiday2;
					cell.detailTextLabel.text = @"";
					break;
			}
	}
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	byPassRowNumber = 0;
	recievedInformation = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

- (void)dealloc {
	[recievedInformation release];
	[super dealloc];
}


@end

