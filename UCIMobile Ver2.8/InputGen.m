//
//  InputGen.m
//  UCIMobile
//
//  Created by Yoon Lee on 12/20/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "InputGen.h"
#import "QuarterActivities.h"


@implementation InputGen

- (id) initWithContext:(NSManagedObjectContext *) context
{
	managedContext = context;
	return self;
}

- (void) setSchedule
{
	QuarterActivities *newElement = (QuarterActivities *)[NSEntityDescription insertNewObjectForEntityForName:@"QuarterActivities" inManagedObjectContext:managedContext];
	NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
	[dateformatter setDateFormat:@"YYYY-MM-dd"];
	NSDate *storeDate = [dateformatter dateFromString:@"2011-06-21"];
	newElement.quarterStarts = storeDate;
	newElement.quarterRepresent = @"Summer 2011";
	
	newElement = (QuarterActivities *)[NSEntityDescription insertNewObjectForEntityForName:@"QuarterActivities" inManagedObjectContext:managedContext];
	[dateformatter setDateFormat:@"YYYY-MM-dd"];
	storeDate = [dateformatter dateFromString:@"2011-09-19"];
	newElement.quarterStarts = storeDate;
	newElement.quarterRepresent = @"Fall 2011";
	
	newElement = (QuarterActivities *)[NSEntityDescription insertNewObjectForEntityForName:@"QuarterActivities" inManagedObjectContext:managedContext];
	[dateformatter setDateFormat:@"YYYY-MM-dd"];
	storeDate = [dateformatter dateFromString:@"2012-01-04"];
	newElement.quarterStarts = storeDate;
	newElement.quarterRepresent = @"Winter 2012";
	
	newElement = (QuarterActivities *)[NSEntityDescription insertNewObjectForEntityForName:@"QuarterActivities" inManagedObjectContext:managedContext];
	[dateformatter setDateFormat:@"YYYY-MM-dd"];
	storeDate = [dateformatter dateFromString:@"2012-03-28"];
	newElement.quarterStarts = storeDate;
	newElement.quarterRepresent = @"Spring 2012";
	
	[dateformatter release];
	
	[managedContext save:nil];
}

- (void) dealloc
{
	[super dealloc];
}

@end
