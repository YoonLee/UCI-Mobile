//
//  BUSLIVEAnnotation.h
//  UCIMobile
//
//  Created by Yoon Lee on 7/30/10.
//  Copyright 2010 leeyc. All rights reserved.
//
#import <MapKit/MapKit.h>


@interface BUSLIVEAnnotation : NSObject <MKAnnotation> 
{
	NSNumber *latitude;
    NSNumber *longitude;
	NSString *name;
	NSString *heading;
	NSString *speed;
}

- (void) initWithName:(NSString *)names forLongitude:(NSString *)longitudes forLatitude:(NSString *)latitudes forDirection:(NSString *)headings forSpeed:(NSString *)speeds;

@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *heading;
@property (nonatomic, retain) NSString *speed;
@end
