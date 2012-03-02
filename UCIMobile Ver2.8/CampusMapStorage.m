
// 
//  CampusMapStorage.m
//  UCIMobileAccessCoreData
//
//  Created by Yoon Lee on 3/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CampusMapStorage.h"

@implementation CampusMapStorage 

@dynamic extendBname;
@dynamic abreviateBname;
@dynamic x_coordinate;
@dynamic y_coordinate;
@dynamic numBuilding;
@dynamic phoneContact;
@dynamic operationHours;

- (CLLocationCoordinate2D)coordinate 
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [self.y_coordinate floatValue];
    theCoordinate.longitude = [self.x_coordinate floatValue];
    return theCoordinate; 
}

- (void)dealloc 
{
    [super dealloc];
}

- (NSString *)title 
{
	
	NSString *annotationDisplay;
	
	if ([self.numBuilding intValue]==0) 
	{
		annotationDisplay = self.abreviateBname;
	}
	else 
	{
		annotationDisplay = [NSString stringWithFormat:@"%@ %@", self.abreviateBname, self.numBuilding];
	}

	return annotationDisplay;
}

// optional
- (NSString *)subtitle 
{
    return self.extendBname;
}

@end