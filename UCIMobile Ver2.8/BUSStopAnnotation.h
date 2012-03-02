//
//  BUSStopAnnotation.h
//  UCIMobile
//
//  Created by Yoon Lee on 7/30/10.
//  Copyright 2010 leeyc. All rights reserved.
//
#import <MapKit/MapKit.h>

@interface BUSStopAnnotation : NSObject <MKAnnotation> 
{
    NSNumber *latitude;
    NSNumber *longitude;
	NSString *name;
}

- (void) initWithName:(NSString *)names forLongitude:(NSString *)longitudes forLatitude:(NSString *)latitudes;

@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSString *name;

@end
