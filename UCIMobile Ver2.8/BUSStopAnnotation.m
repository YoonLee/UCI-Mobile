//
//  BUSStopAnnotation.m
//  UCIMobile
//
//  Created by Yoon Lee on 7/30/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "BUSStopAnnotation.h"


@implementation BUSStopAnnotation

@synthesize latitude;
@synthesize longitude;
@synthesize name;

- (void) initWithName:(NSString *)names forLongitude:(NSString *)longitudes forLatitude:(NSString *)latitudes
{
	self.name = names;
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	self.longitude = [formatter numberFromString:longitudes];
	self.latitude = [formatter numberFromString:latitudes];
	[formatter release];
}

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [self.latitude floatValue];
    theCoordinate.longitude = [self.longitude floatValue];
	
    return theCoordinate; 
}

- (void)dealloc
{
    [super dealloc];
}

- (NSString *)title
{
    return self.name;
}

@end
