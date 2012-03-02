//
//  EntireCourseEdit.m
//  UCIMobile
//
//  Created by Yoon Lee on 12/14/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "EntireCourseEdit.h"
#import "ClassInfo.h"
#import "MyScheduleWorkMap.h"
#import "ThingsToDo.h"

@implementation EntireCourseEdit
@synthesize edit;

- (void) initWithContext:(NSManagedObjectContext *) managedObject
{
	managedObjectContext = managedObject;
}

- (void)viewDidLoad 
{
	NSBundle *mainBundle = [NSBundle mainBundle];	
	selectedSound =  [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"noise" ofType:@"wav"]];
	if (!edit) 
	{
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 100, 30)];
		label.text = @"Events Display";
		label.textAlignment = UITextAlignmentLeft;
		label.textColor = [UIColor whiteColor];
		label.font = [UIFont boldSystemFontOfSize:14];
		label.backgroundColor = [UIColor clearColor];
		UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 100, 30)];
		label2.text = @"Schedule for today";
		label2.textAlignment = UITextAlignmentLeft;
		label2.textColor = [UIColor whiteColor];
		label2.font = [UIFont fontWithName:@"Georgia" size:12];
		label2.backgroundColor = [UIColor clearColor];
		UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
		[imgView addSubview:label2];
		[imgView addSubview:label];
		self.navigationItem.titleView = imgView;
		[imgView release];
		[label release];
		[label2 release];
	}
	else
	{
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 280, 30)];
		label.text = @"Entire- cx Course Edit";
		label.textAlignment = UITextAlignmentLeft;
		label.textColor = [UIColor whiteColor];
		label.font = [UIFont boldSystemFontOfSize:14];
		label.backgroundColor = [UIColor clearColor];
		UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 280, 30)];
		label2.text = @"Swipe to delete. Don't delete Current Schedule";
		label2.textAlignment = UITextAlignmentLeft;
		label2.textColor = [UIColor whiteColor];
		label2.font = [UIFont fontWithName:@"Georgia" size:12];
		label2.backgroundColor = [UIColor clearColor];
		UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 60)];
		[imgView addSubview:label2];
		[imgView addSubview:label];
		self.navigationItem.titleView = imgView;
		[imgView release];
		[label release];
		[label2 release];
	}

	[self fetchOperation];
	
	self.view.backgroundColor = [UIColor whiteColor];
	NSArray *items = [[NSArray alloc] initWithObjects:@"Today", @"Total",nil];
	
	if (!edit) 
	{
		segment = [[UISegmentedControl alloc] initWithItems:items];
		segment.segmentedControlStyle = UISegmentedControlStyleBar;
		
		[segment addTarget:self action:@selector(selectReload:) forControlEvents:UIControlEventValueChanged];
		segment.selectedSegmentIndex = 0;
		UIBarButtonItem *rhsSegment = [[UIBarButtonItem alloc] initWithCustomView:segment];
		self.navigationItem.rightBarButtonItem = rhsSegment;
		[rhsSegment release];
	}
	[items release];
}

- (void) selectReload:(id)sender
{
	[selectedSound play];
	if (segment.selectedSegmentIndex==0) 
	{
		capturesRuntimeModule = mySchedules;
	}
	else
	{
		capturesRuntimeModule = contextContents;
	}
	
	[self.tableView reloadData];
}

- (NSString *) dateOfToday
{
	NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
	NSDate *date = [NSDate date];
	[dateformatter setDateFormat:@"E"];
	NSString *today = [dateformatter stringFromDate:date];
	[dateformatter release];
	
	return today;
}

- (void) fetchOperation
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ClassInfo" inManagedObjectContext:managedObjectContext];
	request.entity = entityDescription;
	NSError *err = nil;
	entireQuery = [[managedObjectContext executeFetchRequest:request error:&err] mutableCopy];
	NSPredicate *predicate = nil;
	predicate = [NSPredicate predicateWithFormat:@"type MATCHES %@", @"EVENT"];
	[request setPredicate:predicate];
	contextContents = [[managedObjectContext executeFetchRequest:request error:&err] mutableCopy];
	NSString *today = [self dateOfToday];
	//NSLog(@"%@", today);
	predicate = [NSPredicate predicateWithFormat:@"type MATCHES %@ and time CONTAINS %@", @"EVENT", today];
	[request setPredicate:predicate];
	mySchedules = [[managedObjectContext executeFetchRequest:request error:&err] mutableCopy];
	[request release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger retSize = 0;
	if (!edit) 
	{
		retSize = capturesRuntimeModule.count;
	}
	else
	{
		retSize = entireQuery.count;
	}
	
	return retSize;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger retSize = 0;
	retSize = 5;
	
	return retSize;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.textLabel.text = @"";
	
	if (!edit)
	{
		ClassInfo *found;
		found = [capturesRuntimeModule objectAtIndex:indexPath.section];
		switch (indexPath.row) 
		{
			case 0:
				cell.textLabel.text = found.title;
				break;
			case 1:
				cell.textLabel.text = [NSString stringWithFormat:@" Event time: (%@)", found.time];
				break;
			case 2:
				cell.textLabel.text = @"Display Notes";
				break;
			case 3:
				cell.textLabel.text = [NSString stringWithFormat:@"*in a Location (%@)", found.location];
				break;
		}
	}
	else
	{
		ClassInfo *found = [entireQuery objectAtIndex:indexPath.section];
		switch (indexPath.row) 
		{
			case 0:
				cell.textLabel.text = found.title;
				break;
			case 1:
				cell.textLabel.text = found.time;
				break;
			case 2:
				cell.textLabel.text = found.instructor;
				break;
			case 3:
				cell.textLabel.text = found.location;
				break;
		}
	}
	
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat retVar = 0.0;
	
	switch (indexPath.row) 
	{
		case 0:
		case 4:
			retVar = 20.0;
			break;
			
		default:
			retVar = 40.0;
			break;
	}
	
	return retVar;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// two cases.
	// displaying setted schedule.
	// displaying everything except for setted schedule.
	cell.imageView.image = nil;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
	
	switch (indexPath.row) 
	{
		case 0:
		case 4:
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.backgroundColor = RGB(162, 205, 90);
			break;
		case 1:
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.imageView.image = [UIImage imageNamed:@"month.png"];
			cell.backgroundColor = RGB(255, 255, 255);
			break;
			
		case 3:
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			cell.backgroundColor = RGB(255, 245, 238);
			cell.imageView.image = [UIImage imageNamed:@"map-pin.png"];
			break;
			
		case 2:
			cell.imageView.image = [UIImage imageNamed:@"clipboard--pencil.png"];
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			cell.backgroundColor = RGB(255, 255, 255);
			break;
	}
	
	if (edit) 
	{
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	ClassInfo *found = [capturesRuntimeModule objectAtIndex:indexPath.section];
	MyScheduleWorkMap *map = nil;
	ThingsToDo *things = nil;
	
	if (!edit) 
	{
		switch (indexPath.row)
		{
			case 2:
				things = [[ThingsToDo alloc] init];
				things.context = managedObjectContext;
				things.myclass = found;
				[self.navigationController pushViewController:things animated:YES];
				[things release];
				[tableView deselectRowAtIndexPath:indexPath animated:YES];
				break;
			case 3:
				map = [[MyScheduleWorkMap alloc] initWithCoordinates:found.location withTitle:found.title];
				[self.navigationController pushViewController:map animated:YES];
				[tableView deselectRowAtIndexPath:indexPath animated:YES];
				[map release];
				break;
				
			default:
				break;
		}
	}
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (edit&&(indexPath.row!=0||indexPath.row!=4))
	{
		return UITableViewCellEditingStyleDelete;
	}
	
	return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If row is deleted, remove it from the list.
    if (edit&&editingStyle == UITableViewCellEditingStyleDelete) 
	{
		ClassInfo *deleteClass = [entireQuery objectAtIndex:indexPath.section];
		[entireQuery removeObjectAtIndex:indexPath.section];
		[tv reloadData];
		[managedObjectContext deleteObject:deleteClass];
		[managedObjectContext save:nil];
    }
}

- (void)dealloc 
{
	[segment release];
	[selectedSound release];
	selectedSound = nil;
    [super dealloc];
}


@end
