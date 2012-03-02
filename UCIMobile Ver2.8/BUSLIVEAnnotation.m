//
//  BUSLIVEAnnotation.m
//  UCIMobile
//
//  Created by Yoon Lee on 7/30/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "BUSLIVEAnnotation.h"


@implementation BUSLIVEAnnotation

@synthesize latitude;
@synthesize longitude;
@synthesize name;
@synthesize heading;
@synthesize speed;

- (void) initWithName:(NSString *)names forLongitude:(NSString *)longitudes forLatitude:(NSString *)latitudes forDirection:(NSString *)headings forSpeed:(NSString *)speeds
{
	self.name = names;
	self.heading = headings;
	self.speed = speeds;
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
    return [NSString stringWithFormat:@"BUS#%@", self.name];
}

// optional
- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"heading:%@", self.heading];
}

@end
