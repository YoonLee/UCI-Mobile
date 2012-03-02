//
//  AdditionalSchedule.m
//  UCIMobile
//
//  Created by Yoon Lee on 12/12/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "AdditionalSchedule.h"
#import "DragMapFinder.h"
#import "ThingsToDo.h"
#import "EntireCourseEdit.h"
#import <QuartzCore/QuartzCore.h>

@implementation AdditionalSchedule
@synthesize annotation, _toolbar2;
@synthesize note, imgIndex;

#pragma mark -
#pragma mark View lifecycle

- (void) initWithCoreData:(NSManagedObjectContext *) managedObject
{
	managedObjectContext = managedObject;
}

- (void)viewDidLoad 
{
	note = nil;
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 180, 30)];
	label1.text = @"Event Adder";
	label1.textAlignment = UITextAlignmentLeft;
	label1.textColor = [UIColor whiteColor];
	label1.font = [UIFont boldSystemFontOfSize:14];
	label1.backgroundColor = [UIColor clearColor];
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 180, 30)];
	label2.text = @"Setting for Schedule";
	label2.textAlignment = UITextAlignmentLeft;
	label2.textColor = [UIColor whiteColor];
	label2.font = [UIFont fontWithName:@"Georgia" size:12];
	label2.backgroundColor = [UIColor clearColor];
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
	[imgView addSubview:label2];
	[imgView addSubview:label1];
	self.navigationItem.titleView = imgView;
	[imgView release];
	[label1 release];
	[label2 release];
	
	_toolbar2 = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 375, 320, 43)];
	_toolbar2.barStyle = UIBarStyleBlackTranslucent;
	UINavigationItem *navItem = [[UINavigationItem alloc] init];
	UIBarButtonItem *saveTarget = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveQuery:)];
	navItem.rightBarButtonItem = saveTarget;
	[saveTarget release];
	[_toolbar2 pushNavigationItem:navItem animated:YES];
	[navItem release];
	recordedDate = [[NSMutableDictionary alloc] init];
	date = [[NSArray alloc] initWithObjects:@"Mon", @"Tue", @"Wed", @"Thur", @"Fri", @"Sat", @"Sun", nil];
	[recordedDate setObject:@"Mon" forKey:@"date"];
	[recordedDate setObject:@"00" forKey:@"hour"];
	[recordedDate setObject:@"00" forKey:@"min"];
	[recordedDate setObject:@"am" forKey:@"noon"];
	pickerViews = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 240, 320, 300)];
	pickerViews.showsSelectionIndicator = YES;
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 160, 30)];
	label.font = [UIFont boldSystemFontOfSize:13];
	label.text = @"          HOUR          MIN";
	label.textColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor clearColor];
	UIBarButtonItem *toolBarTitle = [[UIBarButtonItem alloc] initWithCustomView:label];
	
	[label release];
	
	pickerViews.delegate = self;
	pickerViews.dataSource = self;
	CGRect rect = CGRectZero;
	rect.size.height = 44;
	rect.size.width = 320;
	rect.origin.x = 0;
	rect.origin.y = 200;
	
	_toolbar = [[UIToolbar alloc] initWithFrame:rect];
	_toolbar.tintColor = [UIColor darkTextColor];
	_toolbar.alpha = .75;
	
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(resignFadeOut:)];
	
	NSArray *contents = [NSArray arrayWithObjects: done, toolBarTitle, nil];
	[done release];
	[_toolbar setItems:contents];
	
	//add created toobar on the view
	[self.view addSubview:_toolbar];
	[self.view addSubview:pickerViews];
	_toolbar.hidden = YES;
	pickerViews.hidden = YES;
	
	scheudles = [[NSMutableArray alloc] init];
	menus = [[NSArray alloc] initWithObjects:@"Event", @"Time", @"Location", @"Note", nil];
    [super viewDidLoad];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
	self.navigationItem.rightBarButtonItem = edit;
	[edit release];
	[toolBarTitle release];
	self.tableView.scrollEnabled = NO;
	[self.view addSubview:_toolbar2];
}

- (void) editAction:(id)sender
{
	EntireCourseEdit *courses = [[EntireCourseEdit alloc] initWithStyle:UITableViewStyleGrouped];
	[courses initWithContext:managedObjectContext];
	courses.edit = YES;
	[self.navigationController pushViewController:courses animated:YES];
	[courses release];
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
    return menus.count;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES; 
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{	
	if (textField.tag!=1)
	{
		if (!_toolbar.hidden||!pickerViews.hidden) 
		{
			[self resignFadeOut:nil];
			return;
		}
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	capturedEvent = textField;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.textLabel.frame = CGRectMake(5, 0, 50, 50);
	BOOL hasCreated = NO;
	UITextField *textField = nil;
	
	for (UIView *view in cell.contentView.subviews) 
	{
		// if it is already there then we no longer need to allocate them.
		if ([view isKindOfClass:[UITextField class]]&&view.tag==indexPath.row) 
		{
			textField = (UITextField *)view;
		}
	}
	
	if (textField==nil)
	{
		textField = [[UITextField alloc] init];
		// default schema
		textField.delegate = self;
		textField.textAlignment = UITextAlignmentRight;
		textField.frame = CGRectMake(65, 11, 220, 50);
		textField.keyboardType = UIKeyboardTypeDefault;
		textField.returnKeyType = UIReturnKeyDone;
		hasCreated = YES;
	}
	
	textField.tag = indexPath.row;
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.imageView.image = nil;
	
	NSString *dates = nil;
	textField.enabled = NO;
	
	switch (indexPath.row) 
	{
		case 0:
			cell.imageView.image =  [UIImage imageNamed:@"envelope--pencil.png"];
			textField.enabled = YES;
			break;
		case 1:
			cell.imageView.image =  [UIImage imageNamed:@"month.png"];
			
			dates = [NSString stringWithFormat:@"%@, %@:%@ %@", [recordedDate objectForKey:@"date"], [recordedDate objectForKey:@"hour"], [recordedDate objectForKey:@"min"], [recordedDate objectForKey:@"noon"]];
			textField.text = dates;
			break;
		case 2:
			cell.imageView.image =  [UIImage imageNamed:@"map-pin.png"];
			
			if (annotation==nil) 
			{
				textField.textColor = [UIColor redColor];
				textField.font = [UIFont boldSystemFontOfSize:13];
				textField.text = @"Required";
			}
			else
			{
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
				textField.textColor = [UIColor blackColor];
				textField.frame = CGRectMake(65, 11, 200, 50);
				textField.font = [UIFont boldSystemFontOfSize:13];
				textField.text = @"Place Captured";
			}
			break;
		case 3:
			cell.imageView.image = [UIImage imageNamed:@"clipboard--pencil.png"];
			
			if (note==nil) 
			{
				textField.textColor = [UIColor redColor];
				textField.font = [UIFont boldSystemFontOfSize:13];
				textField.text = @"Required";
			}
			else
			{
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
				textField.textColor = [UIColor blackColor];
				textField.frame = CGRectMake(65, 11, 200, 50);
				textField.font = [UIFont boldSystemFontOfSize:13];
				textField.text = @"Note Captured";
			}
			break;
	}
	
	if (hasCreated) 
	{
		[cell.contentView addSubview:textField];
		[textField release];
	}
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
    cell.textLabel.text = [menus objectAtIndex:indexPath.row];
    // Configure the cell...
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	CATransition *transition = nil;
	DragMapFinder *locateMe = nil;
	ThingsToDo *notes = nil;
	
	switch (indexPath.row) 
	{
		case 0:
			break;
		case 1:
			for (UIView *view in [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0]].contentView.subviews) 
			{
				if ([view isKindOfClass:[UITextField class]]) 
				{
					[view resignFirstResponder];
				}
			}
			if (!_toolbar.hidden||!pickerViews.hidden) 
			{
				[self resignFadeOut:nil];
				[tableView deselectRowAtIndexPath:indexPath animated:YES];
				return;
			}
			// First create a CATransition object to describe the transition
			transition = [CATransition animation];
			transition.duration = 0.45;
			transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
			transition.type = kCATransitionReveal;
			transition.delegate = self;
			_toolbar.hidden = NO;
			pickerViews.hidden = NO;
			[self.view bringSubviewToFront:pickerViews];
			[_toolbar.layer addAnimation:transition forKey:nil];
			transition.type = kCATransitionMoveIn;
			[pickerViews.layer addAnimation:transition forKey:nil];
			break;
		case 2:
			locateMe = [[DragMapFinder alloc] init];
			[locateMe initWithInstance:self];
			[self.navigationController pushViewController:locateMe animated:YES];
			[locateMe release];
			break;
		case 3:
			notes = [[ThingsToDo alloc] initWithNibName:@"ThingsToDo" bundle:nil];
			[notes initWithContext:self];
			[self.navigationController pushViewController:notes animated:YES];
			[notes release];
			break;
			
			
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) resignFadeOut:(id)sender
{
	// First create a CATransition object to describe the transition
	CATransition *transition = [CATransition animation];
	transition.duration = 0.40;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionReveal;
	transition.delegate = self;
	[_toolbar.layer addAnimation:transition forKey:nil];
	transition.type = kCATransitionMoveIn;
	[pickerViews.layer addAnimation:transition forKey:nil];
	
	_toolbar.hidden = YES;
	pickerViews.hidden = YES;
	[self.tableView reloadData];
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

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 4;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	NSInteger retCnt = 0;
	
	switch (component) 
	{
		case 0:
			retCnt = 7;
			break;
		case 1:
			retCnt = 24;
			break;
		case 2:
			retCnt = 60;
			break;
		case 3:
			retCnt = 2;
			break;
			
	}
	
	return retCnt;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *str = @"";
	
	switch (component) 
	{
		case 0:
			str = [date objectAtIndex:row];
			break;
		case 1:
			if (row<9) 
			{
				str = [NSString stringWithFormat:@"0%d", row+1];
			}
			else
			{
				str = [NSString stringWithFormat:@"%d", row+1];
			}
			break;
		case 2:
			if (row<9) 
			{
				str = [NSString stringWithFormat:@"0%d", row+1];
			}
			else
			{
				str = [NSString stringWithFormat:@"%d", row+1];
			}
			break;
		case 3:
			str = row==0?@"am":@"pm";
			break;
			
	}
	
	return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSString *str = @"";
	
	switch (component) 
	{
		case 0:
			str = [date objectAtIndex:row];
			[recordedDate setObject:str forKey:@"date"];
			break;
		case 1:
			if (row<9) 
			{
				str = [NSString stringWithFormat:@"0%d", row+1];
			}
			else
			{
				str = [NSString stringWithFormat:@"%d", row+1];
			}
			[recordedDate setObject:str forKey:@"hour"];
			break;
		case 2:
			if (row<9) 
			{
				str = [NSString stringWithFormat:@"0%d", row+1];
			}
			else
			{
				str = [NSString stringWithFormat:@"%d", row+1];
			}
			[recordedDate setObject:str forKey:@"min"];
			break;
		case 3:
			str = row==0?@"am":@"pm";
			[recordedDate setObject:str forKey:@"noon"];
			break;
	}
	
	[self.tableView reloadData];
}

- (void)saveQuery:(id)sender
{
	NSString *dates = [NSString stringWithFormat:@"%@, %@:%@ %@", [recordedDate objectForKey:@"date"], [recordedDate objectForKey:@"hour"], [recordedDate objectForKey:@"min"], [recordedDate objectForKey:@"noon"]];
	
	if (dates==NULL||[dates isEqualToString:@""]||[capturedEvent.text isEqualToString:@""]||capturedEvent==NULL||annotation==nil) 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please fully provide information" delegate:nil cancelButtonTitle:@"Confirm" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	ClassInfo *mySchedule = (ClassInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"ClassInfo" inManagedObjectContext:managedObjectContext];
	
	// title of event
	mySchedule.title = capturedEvent.text;
	// date setting
	mySchedule.time = dates;
	// location
	mySchedule.location = annotation;
	// notes
	mySchedule.instructor = note;
	mySchedule.num = imgIndex;
	// entity id
	mySchedule.type = @"EVENT";
	
	[managedObjectContext save:nil];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saving.." message:@"Saved" delegate:nil cancelButtonTitle:@"Confirm" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)dealloc 
{
	[scheudles release];
	[pickerViews release];
	[date release];
	[recordedDate release];
	[_toolbar release];
	[_toolbar2 release];
	[menus release];
    [super dealloc];
}

@end

