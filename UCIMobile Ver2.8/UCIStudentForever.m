//
//  UCIStudentForever.m
//  MyUCI
//
//  Created by Yoon Lee on 4/17/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import "UCIStudentForever.h"
#import "FinalInfo.h"
#import "QuarterActivities.h"
#import "CampusMapRequest.h"
#import "ASIFormDataRequest.h"
#import "ClassLoader.h"
#import "AdditionalSchedule.h"
#import "EntireCourseEdit.h"
#import "UCICodeDataAppDelegate.h"

@implementation UCIStudentForever
@synthesize quarter_DB, whole_DB, final_DB;
@synthesize segment, managedObjectContext;
@synthesize isFirstLaunch;
@synthesize curCourse_DB, curFinal_DB, today_DB;
@synthesize curQuarterIndex;

- (void) insertionSort:(NSMutableArray *)list
{
    for (int i = 1; i < [list count]; i ++)
    {
        ClassInfo *curInfo = [list objectAtIndex:i];
        NSArray *chopTime = [curInfo.time componentsSeparatedByString:@":"];
        NSString *choopedTimeFirst = [chopTime objectAtIndex:0];
       
        int first = [choopedTimeFirst intValue];
        
        int j = i;
        
        while (j > 0) 
        {
            ClassInfo *earlyInfo = (ClassInfo *)[list objectAtIndex:(j - 1)];
            chopTime = [earlyInfo.time componentsSeparatedByString:@":"];
            NSString *choopedTimeSecond = [chopTime objectAtIndex:0];
            int second = [choopedTimeSecond intValue];
            
            if (first > second) 
            {
                break;
            }
            
            [list removeObjectAtIndex:j];
            [list insertObject:[list objectAtIndex:(j - 1)] atIndex:j];
            j--;
        }
        [list removeObjectAtIndex:j];
        [list insertObject:curInfo atIndex:j];
    }
}

- (void) displayByWeekDays:(id)sender
{
    CAKeyframeAnimation *bounceAnimate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    bounceAnimate.removedOnCompletion = NO;
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    UIView *launch = (UIView *)[self.view viewWithTag:7];
    [launch setHidden:!launch.hidden];
    
    if (!launch.hidden) 
    {
        CGPathMoveToPoint(thePath, NULL, 0, 0);
        CGPathAddLineToPoint(thePath, NULL, launch.center.x, launch.center.y);
    }
    
    bounceAnimate.path = thePath;
    bounceAnimate.duration = 0.25;
    CGPathRelease(thePath);
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.removedOnCompletion = NO;
    transformAnimation.duration = 0.25;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
    theGroup.delegate = self;
    theGroup.duration = 0.25;
    theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    theGroup.animations = [NSArray arrayWithObjects:bounceAnimate, transformAnimation, nil];
    [launch.layer addAnimation:theGroup forKey:@"foo"];    
}

- (void) miniBttonAction:(id)sender
{    
	if (today_DB == nil) 
	{
		return;
	}
	
    UIButton *instance = (UIButton *)sender;
    UIView *launch = (UIView *)[self.view viewWithTag:7];
    [launch setHidden:!launch.hidden];
    
    switch (instance.tag) 
    {
        case 0:
            [self compareTodayDayOfWeek:@"Mo"];
            break;
        case 1:
            [self compareTodayDayOfWeek:@"Tu"];
            break;
        case 2:
            [self compareTodayDayOfWeek:@"We"];
            break;
        case 3:
            [self compareTodayDayOfWeek:@"Th"];
            break;
        case 4:
            [self compareTodayDayOfWeek:@"Fr"];
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad 
{
    // displays box...
    UIView *menuView = [[UIView alloc] init];
    [menuView setFrame:CGRectMake(10, 30, 300, 50)];
    [menuView setBackgroundColor:RGB(221, 226, 179)];
    [menuView setAlpha:.88];
    [menuView setTag:7];
    [menuView.layer setCornerRadius:7];
    
    [self.view addSubview:menuView];
    // shit series mon, tue, wed, thurs, fri buttons
    UIButton *mon = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *tue = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *wed = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *thu = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *fri = [UIButton buttonWithType:UIButtonTypeCustom];
    [mon setTag:0];
    [tue setTag:1];
    [wed setTag:2];
    [thu setTag:3];
    [fri setTag:4];
    
    [mon addTarget:self action:@selector(miniBttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [tue addTarget:self action:@selector(miniBttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [wed addTarget:self action:@selector(miniBttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [thu addTarget:self action:@selector(miniBttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [fri addTarget:self action:@selector(miniBttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [mon setFrame:CGRectMake(3, 3, 30, 30)];
    [tue setFrame:CGRectMake(35, 3, 30, 30)];
    [wed setFrame:CGRectMake(67, 3, 30, 30)];
    [thu setFrame:CGRectMake(99, 3, 30, 30)];
    [fri setFrame:CGRectMake(131, 3, 30, 30)];
    
    [mon setImage:[UIImage imageNamed:@"m.png"] forState:UIControlStateNormal];
    [tue setImage:[UIImage imageNamed:@"tu.png"] forState:UIControlStateNormal];
    [wed setImage:[UIImage imageNamed:@"w.png"] forState:UIControlStateNormal];
    [thu setImage:[UIImage imageNamed:@"th.png"] forState:UIControlStateNormal];
    [fri setImage:[UIImage imageNamed:@"f.png"] forState:UIControlStateNormal];
    
    [menuView addSubview:mon];
    [menuView addSubview:tue];
    [menuView addSubview:wed];
    [menuView addSubview:thu];
    [menuView addSubview:fri];
    [menuView setHidden:YES];
    
    [menuView release];
    
    UIImage *image = [UIImage imageNamed:@"opt.png"];
	
    UIButton *menuTrigger = [[UIButton alloc] initWithFrame:CGRectMake(150, 2, image.size.width, image.size.height)];
	[menuTrigger setImage:image forState:UIControlStateNormal];
    
    [menuTrigger addTarget:self action:@selector(displayByWeekDays:) forControlEvents:UIControlEventTouchUpInside];
    [menuTrigger setTag:5];
    [self.view addSubview:menuTrigger];
    [menuTrigger release];
    
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 180, 30)];
	label1.text = @"Course Listing";
	label1.textAlignment = UITextAlignmentLeft;
	label1.textColor = [UIColor whiteColor];
	label1.font = [UIFont boldSystemFontOfSize:14];
	label1.backgroundColor = [UIColor clearColor];
	label1.tag = 1;
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 180, 30)];
	label2.text = @"Displays today's schedule";
	label2.textAlignment = UITextAlignmentLeft;
	label2.textColor = [UIColor whiteColor];
	label2.font = [UIFont fontWithName:@"Georgia" size:12];
	label2.backgroundColor = [UIColor clearColor];
	label2.tag = 2;
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    
	[imgView addSubview:label2];
	[imgView addSubview:label1];
	self.navigationItem.titleView = imgView;
    [imgView setTag:7];
	[imgView release];
	[label1 release];
	[label2 release];
	
	self.tableView.backgroundColor = [UIColor clearColor];
	if (!self.fetchRequest) 
	{
		UIAlertView *alert = [[UIAlertView alloc] init];
		[alert setTitle:@"User Login Required"];
		[alert setMessage:@"User needs to login at least once to use this function."];
		[alert addButtonWithTitle:@"OK"];
		[alert setDelegate:self];
		[alert show];
		[alert release];
		return;
	}
	
    [self lookupQuarterSequence];
    
	NSBundle *mainBundle = [NSBundle mainBundle];	
	selectedSound =  [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"noise" ofType:@"wav"]];
	
	isFirstLaunch = YES;
	NSArray *option4Student = [NSArray arrayWithObjects:@"Today", @"Entire", nil];
	segment = [[UISegmentedControl alloc] initWithItems:option4Student];
	//sets default
	[segment setSegmentedControlStyle:UISegmentedControlStyleBar];
	[segment addTarget:self action:@selector(segmentManagement)forControlEvents:UIControlEventValueChanged];
	segment.selectedSegmentIndex = 0;
	UIBarButtonItem *rhsTab = [[UIBarButtonItem alloc] initWithCustomView:segment];
	[self.navigationItem setRightBarButtonItem:rhsTab animated:YES];
	
	[rhsTab release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	//	if (buttonIndex==0) 
	//	{
	//		[self.navigationController popViewControllerAnimated:YES];
	//	}
}

- (void) segmentManagement 
{
	[selectedSound play];
	
	for (UIView *view in self.navigationItem.titleView.subviews)
	{
		if ([view isKindOfClass:UIImageView.class]&&view.tag==7) 
		{
			[view removeFromSuperview];
		}
	}
	
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 180, 30)];
	
	label1.textAlignment = UITextAlignmentLeft;
	label1.textColor = [UIColor whiteColor];
	label1.font = [UIFont boldSystemFontOfSize:14];
	label1.backgroundColor = [UIColor clearColor];
	label1.tag = 1;
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 180, 30)];
	
	label2.textAlignment = UITextAlignmentLeft;
	label2.textColor = [UIColor whiteColor];
	label2.font = [UIFont fontWithName:@"Georgia" size:12];
	label2.backgroundColor = [UIColor clearColor];
	label2.tag = 2;
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    
    UIButton *recog = (UIButton *)[self.view viewWithTag:5];
    
	if (segment.selectedSegmentIndex==0) 
	{
        recog.hidden = NO;
		int found = [self weekFinder:[[quarter_DB objectAtIndex:curQuarterIndex] quarterStarts]];
		
		if (found==11) 
		{
			label1.text = @"Final Exam Week";
			label2.text = @"Good luck everyone!";
		}
		else
		{
			NSString *weekWithNumber = [NSString stringWithFormat:@"Week %d", found];
			label1.text = weekWithNumber;
			label2.text = @"Current schedule.";
		}
		
		[self compareTodayDayOfWeek];
		if (isQuarterOver)
		{
			label1.text = @"Quarter Finished";
			label2.text = @"Vacation break.";
		}
	}
	
	else if(segment.selectedSegmentIndex==1)
	{
        recog.hidden = YES;
		label1.text = @"Current quarter";
		label2.text = @"Displays quarter+final.";
		[self entireCourseSchedule];
	}
	// -_-..
	if (!isFirstLaunch) 
	{
		[self.tableView reloadData];
	}
	isFirstLaunch = NO;
	
	[imgView addSubview:label2];
	[imgView addSubview:label1];
	self.navigationItem.titleView = imgView;
    [imgView setTag:7];
	[imgView release];
	[label1 release];
	[label2 release];
}

- (NSInteger) weekFinder:(NSDate *)startingDate 
{
	NSString *dayOfWeek = [self getDayOfTheWeek:startingDate];
	NSInteger toSend = 0;
	
	if ([dayOfWeek isEqualToString:@"Mon"]) 
	{
		toSend = DayOfWeekMon;
	}
	else if([dayOfWeek isEqualToString:@"Tue"]) 
	{
		toSend = DayOfWeekTue;
	}
	else if([dayOfWeek isEqualToString:@"Wed"]) 
	{
		toSend = DayOfWeekWed;
	}
	else if([dayOfWeek isEqualToString:@"Thu"]) 
	{
		toSend = DayOfWeekThu;
	}
	else if([dayOfWeek isEqualToString:@"Fri"])
	{
		toSend = DayOfWeekFri;
	}
	else if([dayOfWeek isEqualToString:@"Sat"]) 
	{
		toSend = DayOfWeekSat;
	}
	else if([dayOfWeek isEqualToString:@"Sun"]) 
	{
		toSend = DayOfWeekSun;
	}
	
	NSMutableArray *listDayOfWeek = [[NSMutableArray alloc] init];
	[listDayOfWeek insertObject:startingDate atIndex:0];
	NSDate *runningDate = [self seekWeekOperation:toSend withStartDate:startingDate];
	[listDayOfWeek insertObject:runningDate atIndex:1];
	//now, whoever the first starting date has been read.
	//want to know specific sequence of 7days from now on.
	//index i start from 1, because first has been already
	//read. go until twelve weeks.
	for (int i=2; i<12; i++)
	{
		runningDate = [self seekWeekOperation:7 withStartDate:runningDate];
		[listDayOfWeek insertObject:runningDate atIndex:i];
	}
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"yyyy-MM-dd"];
	NSDate *today = [format dateFromString:[format stringFromDate:[NSDate date]]];
	
	for (int j=0,k=1; k<[listDayOfWeek count]; j++, k++) 
	{
		//if today is smaller or equal to date
		if ([today compare:[listDayOfWeek objectAtIndex:j]]==NSOrderedSame||([today compare:(NSDate *)[listDayOfWeek objectAtIndex:j]]==NSOrderedDescending && [today compare:(NSDate *)[listDayOfWeek objectAtIndex:k]]==NSOrderedAscending)) 
		{
			[format release];
			return j+1;
		}
	}
	[format release];
	return 0;
}

- (NSString *)getDayOfTheWeek:(NSDate *)date
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat: @"E"];
	
	NSString *formattedDateString = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	return formattedDateString;
}

- (NSDate *) seekWeekOperation:(NSInteger)begin withStartDate:(NSDate *)start 
{
	//return [start addTimeInterval:60*60*24*begin];
	return [start dateByAddingTimeInterval:60*60*24*begin];
}

- (void) compareTodayDayOfWeek:(NSString *)whatDay
{    
	NSPredicate *predicate;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
	[request setEntity:[NSEntityDescription entityForName:@"ClassInfo" inManagedObjectContext:self.managedObjectContext]];
    
    // Fetch with Afternoon part
    // Discussion: in SQL Table, the attribute Quarter has year and name of term.
    //             because UCI Adimission changes format sometimes for instance, 2011 Fall Quarter to Fall 2011 Quarter
    //             method lookupQuarterSequence returns the array which contains only year and name of term for searching through.
    predicate = [NSPredicate predicateWithFormat:@"(((quarter CONTAINS %@) AND (quarter CONTAINS %@)) AND (days CONTAINS %@) AND (time CONTAINS %@))", [yearAndQuarter objectAtIndex:0], [yearAndQuarter objectAtIndex:1], whatDay, @"p"];
    
	[request setPredicate:predicate];
    
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
										
										initWithKey:@"time" ascending:YES];
	
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	
	NSError *err;
    
	NSMutableArray *afternoon = [[self.managedObjectContext executeFetchRequest:request error:&err] mutableCopy];
    
	[request setEntity:[NSEntityDescription entityForName:@"ClassInfo" inManagedObjectContext:self.managedObjectContext]];
    
    // Fetch with Afternoon part
    // Discussion: in SQL Table, the attribute Quarter has year and name of term.
    //             because UCI Adimission changes format sometimes for instance, 2011 Fall Quarter to Fall 2011 Quarter
    //             method lookupQuarterSequence returns the array which contains only year and name of term for searching through.
    predicate = [NSPredicate predicateWithFormat:@"(((quarter CONTAINS %@) AND (quarter CONTAINS %@)) AND (days CONTAINS %@) AND NOT (time CONTAINS %@))", [yearAndQuarter objectAtIndex:0], [yearAndQuarter objectAtIndex:1], whatDay, @"p"];
    
	[request setPredicate:predicate];
    
	
	NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc]
                                         
                                         initWithKey:@"time" ascending:YES];
	
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor2]];
    NSMutableArray *morning = [[self.managedObjectContext executeFetchRequest:request error:&err] mutableCopy];
    
    [today_DB removeAllObjects];
    
    [self insertionSort:morning];
    [self insertionSort:afternoon];
    
    [today_DB addObjectsFromArray:morning];
    [today_DB addObjectsFromArray:afternoon];
    [self.tableView reloadData];
    
	[request release];
    [sortDescriptor release];
    [sortDescriptor2 release];

}

- (void) compareTodayDayOfWeek 
{
	if ([today_DB count]!=0) 
	{
		return;
	}
	NSDateFormatter *formatDayOfWeek = [[NSDateFormatter alloc] init];
	[formatDayOfWeek setDateFormat:@"E"];
	NSString *dateOftheWeektoday = [[formatDayOfWeek stringFromDate:[NSDate date]] stringByPaddingToLength:2 withString:@"" startingAtIndex:0];
    
	//if today is saturday or sunday, then just display next week monday schedule.
	if ([dateOftheWeektoday isEqualToString:@"Su"]||[dateOftheWeektoday isEqualToString:@"Sa"]) 
	{
		dateOftheWeektoday = @"Mo";
	}
	NSPredicate *predicate;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
	[request setEntity:[NSEntityDescription entityForName:@"ClassInfo" inManagedObjectContext:self.managedObjectContext]];
    
    // Fetch with Afternoon part
    // Discussion: in SQL Table, the attribute Quarter has year and name of term.
    //             because UCI Adimission changes format sometimes for instance, 2011 Fall Quarter to Fall 2011 Quarter
    //             method lookupQuarterSequence returns the array which contains only year and name of term for searching through.
    predicate = [NSPredicate predicateWithFormat:@"(((quarter CONTAINS %@) AND (quarter CONTAINS %@)) AND (days CONTAINS %@) AND (time CONTAINS %@))", [yearAndQuarter objectAtIndex:0], [yearAndQuarter objectAtIndex:1], dateOftheWeektoday, @"p"];
    
	[request setPredicate:predicate];
    
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
										
										initWithKey:@"time" ascending:YES];
	
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	
	NSError *err;
    
	NSMutableArray *afternoon = [[self.managedObjectContext executeFetchRequest:request error:&err] mutableCopy];
    
	[request setEntity:[NSEntityDescription entityForName:@"ClassInfo" inManagedObjectContext:self.managedObjectContext]];
    
    // Fetch with Afternoon part
    // Discussion: in SQL Table, the attribute Quarter has year and name of term.
    //             because UCI Adimission changes format sometimes for instance, 2011 Fall Quarter to Fall 2011 Quarter
    //             method lookupQuarterSequence returns the array which contains only year and name of term for searching through.
    predicate = [NSPredicate predicateWithFormat:@"(((quarter CONTAINS %@) AND (quarter CONTAINS %@)) AND (days CONTAINS %@) AND NOT (time CONTAINS %@))", [yearAndQuarter objectAtIndex:0], [yearAndQuarter objectAtIndex:1], dateOftheWeektoday, @"p"];
    
	[request setPredicate:predicate];
    
	
	NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc]
										
										initWithKey:@"time" ascending:YES];
	
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor2]];
    NSMutableArray *morning = [[self.managedObjectContext executeFetchRequest:request error:&err] mutableCopy];
    
    today_DB = [[NSMutableArray alloc] init];
    
    [self insertionSort:morning];
    [self insertionSort:afternoon];
    
    [today_DB addObjectsFromArray:morning];
    [today_DB addObjectsFromArray:afternoon];

	[formatDayOfWeek release];
	[request release];
    [sortDescriptor release];
    [sortDescriptor2 release];
}

- (void) entireCourseSchedule 
{
	
	NSPredicate *predicate;
	
	if (curCourse_DB) 
	{
		return;
	}
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"FinalInfo" inManagedObjectContext:self.managedObjectContext]];
    
	curFinal_DB = [[self.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    
	[request setEntity:[NSEntityDescription entityForName:@"ClassInfo" inManagedObjectContext:self.managedObjectContext]];    
    
    // Discussion: in SQL Table, the attribute Quarter has year and name of term.
    //             because UCI Adimission changes format sometimes for instance, 2011 Fall Quarter to Fall 2011 Quarter
    //             method lookupQuarterSequence returns the array which contains only year and name of term for searching through.
    predicate = [NSPredicate predicateWithFormat:@"((quarter CONTAINS %@) AND (quarter CONTAINS %@) AND (time CONTAINS %@))", [yearAndQuarter objectAtIndex:0], [yearAndQuarter objectAtIndex:1], @"p"];
	
	[request setPredicate:predicate];
	NSError *err = nil;
	
	NSMutableArray *afternoon = [[self.managedObjectContext executeFetchRequest:request error:&err] mutableCopy]; 
    // Fetch with Afternoon part
    // Discussion: in SQL Table, the attribute Quarter has year and name of term.
    //             because UCI Adimission changes format sometimes for instance, 2011 Fall Quarter to Fall 2011 Quarter
    //             method lookupQuarterSequence returns the array which contains only year and name of term for searching through.
    predicate = [NSPredicate predicateWithFormat:@"(((quarter CONTAINS %@) AND (quarter CONTAINS %@)) AND NOT (time CONTAINS %@))", [yearAndQuarter objectAtIndex:0], [yearAndQuarter objectAtIndex:1], @"p"];
    
	[request setPredicate:predicate];
    
	
	NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc]
                                         
                                         initWithKey:@"time" ascending:YES];
	
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor2]];
    NSMutableArray *morning = [[self.managedObjectContext executeFetchRequest:request error:&err] mutableCopy];
    [self insertionSort:morning];
    [self insertionSort:afternoon];
    
    curCourse_DB = [[NSMutableArray alloc] init];
    [curCourse_DB addObjectsFromArray:morning];
    [curCourse_DB addObjectsFromArray:afternoon];
    
	[sortDescriptor2 release];
	[request release];
}

//this method will find out the requested season, 
//returns the re-formatted style of the date;quarter
//represent in quarter activities and course represent quarter term are
//different.

- (void) lookupQuarterSequence 
{
	//current date and the time setting
	NSDateFormatter *formDate = [[NSDateFormatter alloc]init];
	[formDate setDateFormat:@"MM dd yyyy hh mm"];
	NSDate *today = [formDate dateFromString:[formDate stringFromDate:[NSDate date]]];
	//below statement are black-box purpose
	//	NSString *str = @"05 10 2010";
	//	NSDateFormatter *formDate = [[NSDateFormatter alloc]init];
	//	[formDate setDateFormat:@"MM dd yyyy"];
	//	NSDate *today = [formDate dateFromString:str];
	
	NSString *foundQuarter = @"";
	QuarterActivities *startDate = nil;
	QuarterActivities *endDate = nil;
	
	for (int i=0,j=1; j<[quarter_DB count]; i++,j++) 
	{
		//now look up query
		//condition of next quarter begins until at the end.
		//gets beginning quarter date term.
		startDate = (QuarterActivities *)[quarter_DB objectAtIndex:i];
		
		//gets ending quarter date term.
		endDate = (QuarterActivities *)[quarter_DB objectAtIndex:j];
		
		//NSLog(@"%@", [startDate.quarterStarts description]);
		//if today's date is equal to quarter start date or
		//start quarter < today's date < next quarter starts
		if ([today compare:[startDate quarterStarts]]==NSOrderedSame||([today compare:[startDate quarterStarts]]==NSOrderedDescending && [today compare:[endDate quarterStarts]]==NSOrderedAscending)) 
		{
			int days = [[endDate quarterStarts] timeIntervalSinceDate:today] / 86400;
			//days equal to 7 days or less then
			//display next quarter event.
			
			if (days <= 7)
			{
				foundQuarter = [endDate quarterRepresent];
				curQuarterIndex = i;
				isQuarterOver = YES;
				break;
			}
			
			curQuarterIndex = i;
			foundQuarter = [startDate quarterRepresent];
			break;
		}
		//else if case of
		//today is equal to last quarter listed in input or
		//last quarter < today then it goes to this condition statement.
		else
		{
			foundQuarter = [endDate quarterRepresent];
			curQuarterIndex = j;
		}
		
	}
	[formDate release];
	NSArray *order = [foundQuarter componentsSeparatedByString:@" "];
    NSString *year = nil;
    
    for (NSString *startQuarter in order) 
    {
        // quarter
        if ([startQuarter isEqualToString:@"Spring"]||[startQuarter isEqualToString:@"Winter"]||[startQuarter isEqualToString:@"Fall"]||[startQuarter isEqualToString:@"Summer"]) 
        {
            foundQuarter = startQuarter;
        }
        // year
        else if (![startQuarter isEqualToString:@"Quarter"])
        {
            year = startQuarter;
        }
    }
    
	yearAndQuarter = [[NSArray alloc] initWithObjects:year, foundQuarter, nil];
}

- (BOOL) fetchRequest 
{
	//Request to be ready
	//First we need to get current quarter schedule.
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"ClassInfo" inManagedObjectContext:managedObjectContext];
	request.entity = entity;
	NSError *err = nil;
	whole_DB = [self.managedObjectContext executeFetchRequest:request error:&err];
	entity = [NSEntityDescription entityForName:@"QuarterActivities" inManagedObjectContext:managedObjectContext];
	request.entity = entity;
	quarter_DB = [[self.managedObjectContext executeFetchRequest:request error:&err] mutableCopy];
	[request release];
	
	return [whole_DB count]>0?YES:NO;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	// Return the number of sections.
	if (segment.selectedSegmentIndex==0) 
	{
		return [today_DB count] + 1;
	}
	else 
	{
		return [curCourse_DB count] + [curFinal_DB count];
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	// Return the number of rows in the section.
	NSInteger retVar = 0;
	if (segment.selectedSegmentIndex==0) 
	{
		switch (section) 
		{
			case 0:
				retVar = 3;
				break;
			default:
				retVar = 7;
				break;
		}
	}
	else 
	{
		if (section < [curCourse_DB count]) 
		{
			retVar = 7;
		}
		else 
		{
			retVar = 5;
		}
	}
	
	return retVar;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	if (segment.selectedSegmentIndex==0) 
	{
		if (indexPath.section!=0) 
		{
			switch (indexPath.row) 
			{
				case 0:
					cell.textLabel.textAlignment = UITextAlignmentLeft;
					cell.backgroundColor = RGB(162, 205, 90);
					cell.accessoryType = UITableViewCellAccessoryNone;
					cell.textLabel.textColor = [UIColor blackColor];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					break;
				case 4:
					cell.textLabel.textAlignment = UITextAlignmentLeft;
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					cell.selectionStyle = UITableViewCellSelectionStyleBlue;
					cell.backgroundColor = RGB(255, 245, 238);
					cell.textLabel.textColor = [UIColor blackColor];
					break;
				case 5:
					cell.textLabel.textAlignment = UITextAlignmentLeft;
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					cell.selectionStyle = UITableViewCellSelectionStyleBlue;
					cell.backgroundColor = RGB(255, 245, 238);
					cell.textLabel.textColor = [UIColor blackColor];
					break;
				case 6:
					cell.textLabel.textAlignment = UITextAlignmentRight;
					cell.backgroundColor = RGB(162, 205, 90);
					cell.accessoryType = UITableViewCellAccessoryNone;
					cell.textLabel.textColor = [UIColor blackColor];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					break;
				default:
					cell.textLabel.textAlignment = UITextAlignmentLeft;
					cell.backgroundColor = RGB(255, 255, 255);
					cell.accessoryType = UITableViewCellAccessoryNone;
					cell.textLabel.textColor = [UIColor blackColor];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					break;
			}
		}
		// section 0
		else 
		{
			switch (indexPath.row) 
			{
				case 0:
					cell.textLabel.textAlignment = UITextAlignmentLeft;
					cell.accessoryType = UITableViewCellAccessoryNone;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					cell.backgroundColor = RGB(176, 198, 227);
					break;
				case 1:
					cell.textLabel.textAlignment = UITextAlignmentLeft;
					cell.accessoryType = UITableViewCellAccessoryNone;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					cell.backgroundColor = RGB(255, 255, 255);
					cell.textLabel.textColor = [UIColor blackColor];
					break;
				case 2:
					cell.textLabel.textAlignment = UITextAlignmentRight;
					cell.accessoryType = UITableViewCellAccessoryNone;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					cell.backgroundColor = RGB(176, 198, 227);
					break;
			}
		}
		
	}
	else 
	{
		//this is the part for when the segement were selected "entire"
		//want to show the course listing rather than final exam schedule.
		if (indexPath.section < [curCourse_DB count]) 
		{
			switch (indexPath.row) 
			{
				case 0:
					cell.textLabel.textAlignment = UITextAlignmentLeft;
					cell.backgroundColor = RGB(162, 205, 90);
					cell.accessoryType = UITableViewCellAccessoryNone;
					cell.textLabel.textColor = [UIColor blackColor];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					break;
				case 4:
					cell.textLabel.textAlignment = UITextAlignmentLeft;
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					cell.selectionStyle = UITableViewCellSelectionStyleBlue;
					cell.backgroundColor = RGB(255, 245, 238);
					cell.textLabel.textColor = [UIColor blackColor];
					break;
				case 5:
					cell.textLabel.textAlignment = UITextAlignmentLeft;
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					cell.selectionStyle = UITableViewCellSelectionStyleBlue;
					cell.backgroundColor = RGB(255, 245, 238);
					cell.textLabel.textColor = [UIColor blackColor];
					break;
				case 6:
					cell.textLabel.textAlignment = UITextAlignmentRight;
					cell.backgroundColor = RGB(162, 205, 90);
					cell.accessoryType = UITableViewCellAccessoryNone;
					cell.textLabel.textColor = [UIColor blackColor];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					break;
					
				default:
					cell.textLabel.textAlignment = UITextAlignmentLeft;
					cell.backgroundColor = RGB(255, 255, 255);
					cell.textLabel.textColor = [UIColor blackColor];
					cell.accessoryType = UITableViewCellAccessoryNone;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					break;
			}
		}
		//this is the part for when passing through final exam schedule section to display.
		else 
		{
			switch (indexPath.row) 
			{
				case 0:
					cell.textLabel.textAlignment = UITextAlignmentLeft;
					cell.backgroundColor = RGB(162, 205, 90);
					cell.textLabel.textColor = [UIColor blackColor];
					cell.accessoryType = UITableViewCellAccessoryNone;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					break;
				case 4:
					cell.textLabel.textAlignment = UITextAlignmentRight;
					cell.backgroundColor = RGB(162, 205, 90);
					cell.textLabel.textColor = [UIColor blackColor];
					cell.accessoryType = UITableViewCellAccessoryNone;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					break;
					
				default:
					cell.textLabel.textAlignment = UITextAlignmentLeft;
					cell.backgroundColor = RGB(	255,255,240);
					cell.textLabel.textColor = RGB(244,164,96);
					cell.accessoryType = UITableViewCellAccessoryNone;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					break;
			}
		}
	}
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	//[cell.textLabel setFont: [UIFont fontWithName:@"Georgia" size:16.0]];
	[cell.textLabel setFont:[UIFont boldSystemFontOfSize:13]];
	UIImage* theImage = nil;
	FinalInfo *final;
	ClassInfo *course;
	NSString *fStore;
	NSString *typeOfCourse;
	NSString *dateStore;
	NSDateFormatter *dateformatter;
	NSScanner *scan;
	NSDate *today;
	NSDate *future;
	
	if (segment.selectedSegmentIndex==0) 
	{
		if (indexPath.section!=0) 
		{
			course = (ClassInfo *) [today_DB objectAtIndex:indexPath.section-1];
			switch (indexPath.row) 
			{
					//CONFIGURE TYPE OF COURSE
				case 0:
					//format would be department and number
					//*
					//ACT   Activity		COL	Colloquium
					//DIS	Discussion		FLD	Field Work
					//LAB	Laboratory		LEC	Lecture
					//QIZ	Quiz		    RES	Research
					//SEM	Seminar		    STU	Studio
					//TAP	Tutorial Assistance Program		TUT	Tutorial
					
					if ([course.type isEqualToString:@"LEC"]) 
					{
						typeOfCourse = @"LECTURE";
					}
					else if ([course.type isEqualToString:@"DIS"]) 
					{
						typeOfCourse = @"DISCUSSION";
					}
					else if ([course.type isEqualToString:@"LAB"]) 
					{
						typeOfCourse = @"LABORATORY";
					}
					else if ([course.type isEqualToString:@"ACT"]) 
					{
						typeOfCourse = @"ACTIVITY";
					}
					else if ([course.type isEqualToString:@"COL"]) 
					{
						typeOfCourse = @"COLLOQUIUM";
					}
					else if ([course.type isEqualToString:@"FLD"]) 
					{
						typeOfCourse = @"FILEDWORK";
					}
					else if ([course.type isEqualToString:@"QIZ"]) 
					{
						typeOfCourse = @"QUIZ";
					}
					else if ([course.type isEqualToString:@"RES"]) 
					{
						typeOfCourse = @"RESEARCH";
					}
					else if ([course.type isEqualToString:@"SEM"]) 
					{
						typeOfCourse = @"SEMINAR";
					}
					else if ([course.type isEqualToString:@"STU"]) 
					{
						typeOfCourse = @"STUDIO";
					}
					else if ([course.type isEqualToString:@"TAP"]) 
					{
						typeOfCourse = @"TUTORIAL ASSISTANCE";
					}
					else if ([course.type isEqualToString:@"TUT"]) 
					{
						typeOfCourse = @"TUTORIAL";
					}
					else 
					{
						typeOfCourse = @"UNKNOWN";
					}
					@try {
						cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@", typeOfCourse, course.dept, course.num];
					}
					@catch (NSException * e) {
						cell.textLabel.text = @"SPECIAL";
					}
					
					cell.imageView.image = nil;
					break;
					
					//CONFIGURE IMAGE WITH COURSE TITLE
				case 1:
					@try 
                {
                    cell.textLabel.text = course.title;
                }
					@catch (NSException * e) 
                {
                    cell.textLabel.text = @"NO TITLE!";
                }
					
					if ([course.type isEqualToString:@"LEC"]) 
                    {
						theImage = [UIImage imageNamed:@"book--pencil.png"];
					}
					else if ([course.type isEqualToString:@"DIS"]) 
                    {
						theImage = [UIImage imageNamed:@"clipboard--pencil.png"];
					}
					else if ([course.type isEqualToString:@"LAB"]) 
                    {
						theImage = [UIImage imageNamed:@"flask--pencil.png"];
					}
					else 
                    {
						theImage = [UIImage imageNamed:@"flask--pencil.png"];
					}
					
					cell.imageView.image = theImage;
					break;
					//CONFIGURE IMAGE AND THE TYPE OF DAYS
				case 2:
					@try 
                {
                    NSArray *sep = [course.days componentsSeparatedByString:@" "];
                    NSString *yoilStore = @"";
                    
                    for (int u=0; u<[sep count]; u++) 
                    {
                        NSString *yoil = [sep objectAtIndex:u];
                        if ([yoil isEqualToString:@"Mo"]) 
                        {
                            yoil = @"MON";
                        }
                        else if ([yoil isEqualToString:@"Tu"]) 
                        {
                            yoil = @"TUE";
                        }
                        else if ([yoil isEqualToString:@"We"]) 
                        {
                            yoil = @"WED";
                        }
                        else if ([yoil isEqualToString:@"Th"]) 
                        {
                            yoil = @"THU";
                        }
                        else if ([yoil isEqualToString:@"Fr"]) 
                        {
                            yoil = @"FRI";
                        }
                        yoilStore = [yoilStore stringByAppendingFormat:@"%@ ", yoil];
                    }
                    cell.textLabel.text = yoilStore;
                }
					@catch (NSException * e) 
                {
                    cell.textLabel.text = @"DATE VAVRIES";
                }
					
					theImage = [UIImage imageNamed:@"month.png"];
					cell.imageView.image = theImage;
					break;
				case 3:
					@try 
                {
                    cell.textLabel.text = course.time;
                }
					@catch (NSException * e) 
                {
                    cell.textLabel.text = @"TIME VARIES";
                }
					
					theImage = [UIImage imageNamed:@"clocks.png"];
					cell.imageView.image = theImage;
					break;
				case 4:
					@try 
                {
                    cell.textLabel.text = course.instructor;
                }
					@catch (NSException * e) 
                {
                    cell.textLabel.text = @"N/A";
                }
					
					theImage = [UIImage imageNamed:@"user_gray.png"];
					cell.imageView.image = theImage;
					break;
				case 5:
					@try 
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"*in %@ (Map)", course.location];
                }
					@catch (NSException * e) 
                {
                    cell.textLabel.text = @"N/A";
                }
					
					theImage = [UIImage imageNamed:@"map-pin.png"];
					cell.imageView.image = theImage;
					break;
				case 6:
					@try 
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", course.unts, [self pluralCheck:YES withIntValue:course.unts]];
                }
					@catch (NSException * e) 
                {
                    cell.textLabel.text = @"";
                }
					
					cell.imageView.image = nil;
					break;
					
			}
		}
		else 
        {
			switch (indexPath.row) 
            {
				case 0:
					cell.textLabel.numberOfLines = 0;
					cell.textLabel.text = @"Message Board";
					cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
					break;
				case 1:
					cell.textLabel.numberOfLines = 0;
					NSDateFormatter *format = [[NSDateFormatter alloc] init];
					[format setDateFormat:@"E, MMM dd, yyyy"];		
					NSString *quickPlural = @"class";
					if ([today_DB count]>1) 
					{
						quickPlural = @"classes";
					}
					
					cell.textLabel.text = [NSString stringWithFormat:@"Today's Date: %@\nYou have %d %@ \n%@", [format stringFromDate:[NSDate date]], [today_DB count], quickPlural, [self nearleastTodaysClass]];
					cell.textLabel.font = [UIFont boldSystemFontOfSize:11];
					[format release];
					break;
				case 2:
					cell.textLabel.numberOfLines = 0;
					cell.textLabel.text = @"Today's Agenda";
					cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
					break;
			}
			cell.imageView.image = nil;
		}
		
	}
	else if (segment.selectedSegmentIndex==1) 
    {
		if(indexPath.section<[curCourse_DB count])
		{
			course = (ClassInfo *) [curCourse_DB objectAtIndex:indexPath.section];
			switch (indexPath.row) 
			{
				case 0:
					//format would be department and number
					//*
					//ACT   Activity		COL	Colloquium
					//DIS	Discussion		FLD	Field Work
					//LAB	Laboratory		LEC	Lecture
					//QIZ	Quiz		    RES	Research
					//SEM	Seminar		    STU	Studio
					//TAP	Tutorial Assistance Program		TUT	Tutorial
					
					if ([course.type isEqualToString:@"LEC"]) {
						typeOfCourse = @"LECTURE";
					}
					else if ([course.type isEqualToString:@"DIS"]) {
						typeOfCourse = @"DISCUSSION";
					}
					else if ([course.type isEqualToString:@"LAB"]) {
						typeOfCourse = @"LABORATORY";
					}
					else if ([course.type isEqualToString:@"ACT"]) {
						typeOfCourse = @"ACTIVITY";
					}
					else if ([course.type isEqualToString:@"COL"]) {
						typeOfCourse = @"COLLOQUIUM";
					}
					else if ([course.type isEqualToString:@"FLD"]) {
						typeOfCourse = @"FILEDWORK";
					}
					else if ([course.type isEqualToString:@"QIZ"]) {
						typeOfCourse = @"QUIZ";
					}
					else if ([course.type isEqualToString:@"RES"]) {
						typeOfCourse = @"RESEARCH";
					}
					else if ([course.type isEqualToString:@"SEM"]) {
						typeOfCourse = @"SEMINAR";
					}
					else if ([course.type isEqualToString:@"STU"]) {
						typeOfCourse = @"STUDIO";
					}
					else if ([course.type isEqualToString:@"TAP"]) {
						typeOfCourse = @"TUTORIAL ASSISTANCE";
					}
					else if ([course.type isEqualToString:@"TUT"]) {
						typeOfCourse = @"TUTORIAL";
					}
					else {
						typeOfCourse = @"UNKNOWN";
					}
					@try {
						cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@", typeOfCourse, course.dept, course.num];
					}
					@catch (NSException * e) {
						cell.textLabel.text = @"SPECIAL";
					}
					
					cell.imageView.image = nil;
					break;
					
					//CONFIGURE IMAGE WITH COURSE TITLE
				case 1:
					@try {
						cell.textLabel.text = course.title;
					}
					@catch (NSException * e) {
						cell.textLabel.text = @"NO TITLE!";
					}
					
					if ([course.type isEqualToString:@"LEC"]) {
						theImage = [UIImage imageNamed:@"book--pencil.png"];
					}
					else if ([course.type isEqualToString:@"DIS"]) {
						theImage = [UIImage imageNamed:@"clipboard--pencil.png"];
					}
					else if ([course.type isEqualToString:@"LAB"]) {
						theImage = [UIImage imageNamed:@"flask--pencil.png"];
					}
					else {
						theImage = [UIImage imageNamed:@"flask--pencil.png"];
					}
					
					cell.imageView.image = theImage;
					break;
					//CONFIGURE IMAGE AND THE TYPE OF DAYS
				case 2:
					@try {
						NSArray *sep = [course.days componentsSeparatedByString:@" "];
						NSString *yoilStore = @"";
						for (int u=0; u<[sep count]; u++) {
							NSString *yoil = [sep objectAtIndex:u];
							if ([yoil isEqualToString:@"Mo"]) {
								yoil = @"MON";
							}
							else if ([yoil isEqualToString:@"Tu"]) {
								yoil = @"TUE";
							}
							else if ([yoil isEqualToString:@"We"]) {
								yoil = @"WED";
							}
							else if ([yoil isEqualToString:@"Th"]) {
								yoil = @"THU";
							}
							else if ([yoil isEqualToString:@"Fr"]) {
								yoil = @"FRI";
							}
							
							yoilStore = [yoilStore stringByAppendingFormat:@"%@  ", yoil];
						}
						cell.textLabel.text = yoilStore;
					}
					@catch (NSException * e) {
						cell.textLabel.text = @"DATE VAVRIES";
					}
					
					theImage = [UIImage imageNamed:@"month.png"];
					cell.imageView.image = theImage;
					break;
				case 3:
					@try {
						cell.textLabel.text = course.time;
					}
					@catch (NSException * e) {
						cell.textLabel.text = @"TIME VARIES";
					}
					
					theImage = [UIImage imageNamed:@"clocks.png"];
					cell.imageView.image = theImage;
					break;
				case 4:
					@try {
						cell.textLabel.text = course.instructor;
					}
					@catch (NSException * e) {
						cell.textLabel.text = @"N/A";
					}
					
					theImage = [UIImage imageNamed:@"user_gray.png"];
					cell.imageView.image = theImage;
					break;
				case 5:
					@try {
						cell.textLabel.text = [NSString stringWithFormat:@"*in %@ (Map)", course.location];
					}
					@catch (NSException * e) {
						cell.textLabel.text = @"N/A";
					}
					
					theImage = [UIImage imageNamed:@"map-pin.png"];
					cell.imageView.image = theImage;
					break;
				case 6:
					@try {
						cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", course.unts, [self pluralCheck:YES withIntValue:course.unts]];
					}
					@catch (NSException * e) {
						cell.textLabel.text = @"";
					}
					
					cell.imageView.image = nil;
					break;
			}
		}
		
		//final view part
		else if(indexPath.section>=[curFinal_DB count]){
			final = (FinalInfo *)[curFinal_DB objectAtIndex:(indexPath.section - [curCourse_DB count])];
			switch (indexPath.row) {
				case 0:
					@try {
						cell.textLabel.text = [NSString stringWithFormat:@"Final Exam for %@", final.fdept];
					}
					@catch (NSException * e) {
						cell.textLabel.text = @"N/A";
					}
					cell.imageView.image = nil;
					break;
				case 1:
					@try {
						fStore = final.fdept;
						cell.textLabel.text = fStore;
					}
					@catch (NSException * e) {
						cell.textLabel.text = @"N/A";
					}
					
					theImage = [UIImage imageNamed:@"building-medium.png"];
					cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:11.0];
					cell.imageView.image = theImage;
					break;
				case 2:
					@try {
						fStore = final.fcourse;
						cell.textLabel.text = fStore;
					}
					@catch (NSException * e) {
						cell.textLabel.text = @"N/A";
					}
					
					theImage = [UIImage imageNamed:@"paper-bag--pencil.png"];
					cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:11.0];
					cell.imageView.image = theImage;
					break;
				case 3:
					@try {
						cell.textLabel.text = final.fdate;
					}
					@catch (NSException * e) {
						cell.textLabel.text = @"N/A";
					}
					
					cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:11.0];
					theImage = [UIImage imageNamed:@"month.png"];
					cell.imageView.image = theImage;
					break;
				case 4:
					@try 
				{
					dateformatter = [[NSDateFormatter alloc] init];
					[dateformatter setDateFormat:@"MMMM dd"];
					//small parser part
					if (final.fdate==nil) 
					{
						cell.textLabel.text = @"TBA";
					}
					else
					{
						NSRange range;
						range = [final.fdate rangeOfString:@"TBA"];
						BOOL hasTBA = NO;
						if(range.location != NSNotFound) 
						{
							hasTBA = YES;
						}
						if (!hasTBA) 
						{
							scan = [NSScanner scannerWithString:(NSString *)final.fdate];
							
							[scan scanUpToString:@" " intoString:nil];
							[scan scanUpToString:@"," intoString:&dateStore];
							
							today = [dateformatter dateFromString:[dateformatter stringFromDate:[NSDate date]]];
							future = [dateformatter dateFromString:dateStore];
							int days = 0;
							days = [future timeIntervalSinceDate:today] / 86400;
							
							[dateformatter release];
							
							NSString *res = @"";
							
							if (days<0) 
							{
								// not expired yet
								if (days>-80) 
								{
									res = @"Finished";
								}
								else
								{
									res = @"Standby Mode";
								}
							}
							else
							{
								res = [NSString stringWithFormat:@"%d days left", days];
							}
							
							cell.textLabel.text = res;
						}
						else
						{
							cell.textLabel.text = @"TBA";
						}
                        
					}
				}
					@catch (NSException * e) 
				{
					cell.textLabel.text = @"N/A";
				}
					
					cell.imageView.image = nil;
					break;
			}
		}
	}
    return cell;	
}

- (NSString *) homepieYearFinder:(ClassInfo *)course 
{
    NSString *year;
	NSString *num;
	
	@try 
	{		
		//Winter, Spring, Summer, Fall
		year = [yearAndQuarter objectAtIndex:1];
		year = [year lowercaseString];
		num = [yearAndQuarter objectAtIndex:0];
		num = [num substringFromIndex:2];
		
		if ([year isEqualToString:@"fall"]) 
		{
			year = @"f";
			
		}
		else if ([year isEqualToString:@"winter"])
		{
			year = @"w";
		}
		else if ([year isEqualToString:@"spring"])
		{
			year = @"s";
		}
		//else is summer or error
		else 
		{
//			for (int i=0; i<[yearAndQuarter count]; i++) 
//			{
//				year = [store objectAtIndex:i];
//				if ([year isEqualToString:@"I"]) 
//				{
//					year = @"y";
//				}
//				else if ([year isEqualToString:@"II"])
//				{
//					year = @"z";
//				}
//				else 
//				{
            year = @"m";
//				}
//			}
		}
	}
	@catch (NSException * e) 
	{
		
	}
	year = [NSString stringWithFormat:@"%@%@", num, year];
  
	NSString *webpie = course.code;
	webpie = [NSString stringWithFormat:@"https://eee.uci.edu/%@/%@/", year, webpie];
	
	return webpie;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ClassInfo *course;
	ClassLoader *loader;
	
	if (segment.selectedSegmentIndex==0) 
	{
		if (indexPath.section!=0) 
		{
			course = (ClassInfo *) [today_DB objectAtIndex:indexPath.section-1];
			switch (indexPath.row) 
			{
				case 4:
					loader = [[ClassLoader alloc] initWithNibName:@"ClassLoader" bundle:nil];
					loader.link = [self homepieYearFinder:course];
					loader.name =  [NSString stringWithFormat:@"%@:%@%@", course.type, course.dept, course.num];
					[self.navigationController pushViewController:loader animated:YES];
					[loader release];
					[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
					break;
				default:
					break;
			}
		}
	}
	else 
	{
		if(indexPath.section<[curCourse_DB count])
		{
			course = (ClassInfo *) [curCourse_DB objectAtIndex:indexPath.section];
			switch (indexPath.row) 
			{
				case 4:
					loader = [[ClassLoader alloc] initWithNibName:@"ClassLoader" bundle:nil];
					loader.link = [self homepieYearFinder:course];
					loader.name =  [NSString stringWithFormat:@"%@:%@%@", course.type, course.dept, course.num];
					[self.navigationController pushViewController:loader animated:YES];
					[loader release];
					[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
					break;
				default:
					break;
			}
		}
	}
	
	if(indexPath.row==5) 
	{
		CampusMapRequest *mapView = [[CampusMapRequest alloc] init];
		mapView.context = self.managedObjectContext;
		ClassInfo *course = nil;
		
		if (segment.selectedSegmentIndex==0) 
		{
			course = (ClassInfo *)[today_DB objectAtIndex:indexPath.section-1];
		}
		else if (segment.selectedSegmentIndex==1)
		{
			course = (ClassInfo *)[curCourse_DB objectAtIndex:indexPath.section];
		}
		
		[mapView setRequestToSearch:[course location]];
		[self.navigationController pushViewController:mapView animated:YES];
		[mapView release];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	CGFloat retVar;
	if (segment.selectedSegmentIndex==0) 
	{
		if (indexPath.section!=0) 
		{
			switch (indexPath.row) 
			{
				case 0:
					retVar = 20.0;
					break;
				case 6:
					retVar = 20.0;
					break;
					
				default:
					retVar = 45.0;
					break;
			}
		}
		else 
		{
			switch (indexPath.row) 
			{
				case 1:
                    retVar = [[self nearleastTodaysClass] length] > 11?80:60;
					break;
				default:
					retVar = 15.0;
					break;
			}
		}
		
	}
	else 
	{
		//this is the part for when the segement were selected "entire"
		//want to show the course listing rather than final exam schedule.
		if (indexPath.section < [curCourse_DB count]) 
		{
			switch (indexPath.row) 
			{
				case 0:
					retVar = 20.0;
					break;
				case 6:
					retVar = 20.0;
					break;
					
				default:
					retVar = 45.0;
					break;
			}
		}
		//this is the part for when passing through final exam schedule section to display.
		else {
			switch (indexPath.row) 
			{
				case 0:
					retVar = 20.0;
					break;
				case 4:
					retVar = 20.0;
					break;
					
				default:
					retVar = 45.0;
					break;
			}
		}
	}
	return retVar;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}

- (NSString *)pluralCheck:(BOOL)isUnit withIntValue:(NSNumber *)number 
{
	
	NSString *retVar;
	
	if (isUnit) 
	{
		if ([number doubleValue]>1.0) {
			retVar = @"units";
		}
		else {
			retVar = @"unit";
		}
	}
	else 
	{
		if ([number intValue]>1) 
		{
			retVar = [NSString stringWithFormat:@"%d days remaining", [number intValue]];
		}
		else 
		{
			if ([number intValue]<0) 
			{
				retVar = [NSString stringWithFormat:@"completed", [number intValue]];
			}
			else if([number intValue]==0) 
			{
				retVar = [NSString stringWithFormat:@"good luck!"];
			}
			else {
				retVar = [NSString stringWithFormat:@"%d day remaining", [number intValue]];
			}
			
		}
	}
	
	return retVar;
}

- (NSString *) nearleastTodaysClass 
{
	NSString *results = @"";
	ClassInfo *foundNearleastCourse = nil;
	//Let's get today's hour
	if (today_DB.count == 0)
	{
		return @"You don't have any classes today.";
	}
	@try 
	{
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"HH:mm"];
		
		NSDate *rightNow = [format dateFromString:[format stringFromDate:[NSDate date]]];
		//
		// DEBUG
		
		// current time
		//NSDate *rightNow = [format dateFromString:@"08:00"];
		
		NSDate *convertedDate;
		NSRange range;
		
		// course identity
		ClassInfo *courseHolder = (ClassInfo *)[today_DB objectAtIndex:0];
		
		NSArray *timeobject = [courseHolder.time componentsSeparatedByString:@"-"];
		
		// very first class time that are separated
		// starting point from begin.
		NSString *sepTimeObject = [timeobject objectAtIndex:0];
		NSMutableArray *storeMinimal = [[NSMutableArray alloc] init];
		
		// run until today's class data base exist
		for (int i=0; i<[today_DB count]; i++) 
		{
			courseHolder = (ClassInfo *)[today_DB objectAtIndex:i];
			timeobject = [courseHolder.time componentsSeparatedByString:@"-"];
			sepTimeObject = [timeobject objectAtIndex:0];
			
			// is contain 'p'?
			range = [courseHolder.time rangeOfString:@"p"];
			if(range.location != NSNotFound) 
			{
				// if it is yes, then read until ':' reaches.
				timeobject = [sepTimeObject componentsSeparatedByString:@":"];
				// if it is not yet 12pm clock 
				// but if it is 12pm clock? ex) 11:00-12:20p
				// 11:00 does not contains the p.
				// but it will reach here because of 12:20p contains the 'p'
				// so the answer to this question is,
				if (![[timeobject objectAtIndex:0] isEqualToString:@"12"]&&![[timeobject objectAtIndex:0] isEqualToString:@"11"]&&![[timeobject objectAtIndex:0] isEqualToString:@"10"]&&![[timeobject objectAtIndex:0] isEqualToString:@"9"])
				{
					sepTimeObject = [NSString stringWithFormat:@"%d:%@", [(NSString *)[timeobject objectAtIndex:0] intValue] + 12, [timeobject objectAtIndex:1]];
				}
			}
			
			convertedDate = [format dateFromString:sepTimeObject];
			
			//NSLog(@"%@", sepTimeObject);
			//run > now || run == now
			if ([convertedDate compare:rightNow]==NSOrderedDescending||[convertedDate compare:rightNow]==NSOrderedSame)
			{
				[storeMinimal addObject:courseHolder];
				//NSLog(@"찾아낸 값들 : %@", [convertedDate description]); 
			}
		}
		
		if ([storeMinimal count]!=0)
		{
			courseHolder = (ClassInfo *)[storeMinimal objectAtIndex:0];
			
			timeobject = [courseHolder.time componentsSeparatedByString:@"-"];
			sepTimeObject = [timeobject objectAtIndex:0];
			
			range = [courseHolder.time rangeOfString:@"p"];
			if(range.location != NSNotFound) 
			{
				timeobject = [sepTimeObject componentsSeparatedByString:@":"];
				if (![[timeobject objectAtIndex:0] isEqualToString:@"12"]&&![[timeobject objectAtIndex:0] isEqualToString:@"11"]&&![[timeobject objectAtIndex:0] isEqualToString:@"10"]&&![[timeobject objectAtIndex:0] isEqualToString:@"9"])
				{
					sepTimeObject = [NSString stringWithFormat:@"%d:%@", [(NSString *)[timeobject objectAtIndex:0] intValue] + 12, [timeobject objectAtIndex:1]];
				}
			}
			
			NSDate *minimum = [format dateFromString:sepTimeObject];
			//	NSLog(@"시작 최소값 : %@", [minimum description]); 
			for (int k=0; k<[storeMinimal count]; k++) 
			{
				courseHolder = (ClassInfo *)[storeMinimal objectAtIndex:k];
				timeobject = [courseHolder.time componentsSeparatedByString:@"-"];
				sepTimeObject = [timeobject objectAtIndex:0];
				
				range = [courseHolder.time rangeOfString:@"p"];
				if(range.location != NSNotFound) 
				{
					timeobject = [sepTimeObject componentsSeparatedByString:@":"];
					if (![[timeobject objectAtIndex:0] isEqualToString:@"12"]&&![[timeobject objectAtIndex:0] isEqualToString:@"11"]&&![[timeobject objectAtIndex:0] isEqualToString:@"10"]&&![[timeobject objectAtIndex:0] isEqualToString:@"9"])
					{
						sepTimeObject = [NSString stringWithFormat:@"%d:%@", [(NSString *)[timeobject objectAtIndex:0] intValue] + 12, [timeobject objectAtIndex:1]];
					}
				}
				//NSLog(@"sepTimeObject: %@", [sepTimeObject description]); 
				convertedDate = [format dateFromString:sepTimeObject];
				
				//min>run value || min == run
				if ([minimum compare:convertedDate]==NSOrderedDescending||[convertedDate compare:minimum]==NSOrderedSame) 
				{
					minimum = convertedDate;
					foundNearleastCourse = courseHolder;
				}
			}
			//NSLog(@"찾아낸 최소값 : %@", [minimum description]); 
		}
		[format release];
		[storeMinimal release];
		
		if (foundNearleastCourse) 
		{
			results = [NSString stringWithFormat:@"Next: [%@] %@ %@ at %@\nWhere: [Building/Room#] *%@", [foundNearleastCourse.type capitalizedString], [foundNearleastCourse.dept capitalizedString], foundNearleastCourse.num, foundNearleastCourse.time, foundNearleastCourse.location];
		}
		else 
		{
			results = @"Finished!";
		}
	}
	
	@catch (NSException * e) 
	{
		results = @"";
	}
	
	//NSLog(@"%@", results);
	return results;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	UIView *result = nil;
	
	if (section==0&&segment.selectedSegmentIndex==0) 
	{
		result = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
		result.backgroundColor = [UIColor clearColor];
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(137, -5, 50, 50)];
		lbl.text = @"Events";
		lbl.font = [UIFont boldSystemFontOfSize:14];
		lbl.backgroundColor = [UIColor clearColor];
		UIButton *add = [UIButton buttonWithType:UIButtonTypeContactAdd];
		add.frame = CGRectMake(10, 5, 30, 30);
		UIButton *event = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		event.frame = CGRectMake(280, 5, 30, 30);
		[add addTarget:self action:@selector(addSchedule:) forControlEvents:UIControlEventTouchUpInside];
		[event addTarget:self action:@selector(showEvent:) forControlEvents:UIControlEventTouchUpInside];
		
		[result addSubview:add];
		[result addSubview:event];
		[result addSubview:lbl];
		
		[lbl release];
	}
	
	return result;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *result = nil;
	
	if (section==0&&segment.selectedSegmentIndex==1) 
	{
		result = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
		result.backgroundColor = [UIColor clearColor];
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(137, -5, 50, 50)];
		lbl.text = @"Events";
		lbl.font = [UIFont boldSystemFontOfSize:14];
		lbl.backgroundColor = [UIColor clearColor];
		UIButton *add = [UIButton buttonWithType:UIButtonTypeContactAdd];
		add.frame = CGRectMake(10, 5, 30, 30);
		UIButton *event = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		event.frame = CGRectMake(280, 5, 30, 30);
		[add addTarget:self action:@selector(addSchedule:) forControlEvents:UIControlEventTouchUpInside];
		[event addTarget:self action:@selector(showEvent:) forControlEvents:UIControlEventTouchUpInside];
		
		[result addSubview:add];
		[result addSubview:event];
		[result addSubview:lbl];
		[lbl release];
	}
	
	return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	CGFloat ret = 0.0;
	
	if (section==0&&segment.selectedSegmentIndex==0) 
	{
		ret = 30.0;
	}
	
	return ret;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	CGFloat ret = 0.0;
	
	if (section==0&&segment.selectedSegmentIndex==1) 
	{
		ret = 40.0;
	}
	
	return ret;
}

- (void) addSchedule:(id)sender
{
	AdditionalSchedule *additional = [[AdditionalSchedule alloc] initWithStyle:UITableViewStyleGrouped];
	[additional initWithCoreData:self.managedObjectContext];
	additional.title = @"Back";
	[self.navigationController pushViewController:additional animated:YES];
	[additional release];
}

- (void) showEvent:(id)sender
{
	EntireCourseEdit *entire = [[EntireCourseEdit alloc] initWithStyle:UITableViewStyleGrouped];
	[entire initWithContext:managedObjectContext];
	
	[self.navigationController pushViewController:entire animated:YES];
	[entire release];
}

- (void)viewDidUnload 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	today_DB = nil;
	whole_DB = nil;
	segment = nil;
	final_DB = nil;
	managedObjectContext = nil;
	curCourse_DB = nil;
	curFinal_DB = nil;
	quarter_DB = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIButton *menuTrigger = (UIButton *)[self.view viewWithTag:5];
    UIView *menuFrame = [self.view viewWithTag:7];
    UIImage *image = [UIImage imageNamed:@"opt.png"];
    
    switch (toInterfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            [menuTrigger setFrame:CGRectMake(150, 2, image.size.width, image.size.height)];
            [menuFrame setFrame:CGRectMake(10, 30, 300, 50)];
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            [menuTrigger setFrame:CGRectMake(300, 25, image.size.width, image.size.height)];
            [menuFrame setFrame:CGRectMake(170, 50, 300, 50)];
            break;
    }
}

- (void)dealloc
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[selectedSound release];
	selectedSound = nil;
	[today_DB release];	
	[curCourse_DB release];
	[curFinal_DB release];
	
	[quarter_DB release];
	
	[segment release];
	segment = nil;
	
	[super dealloc];
}

@end

