//
//  MyScheduleWorkMap.h
//  UCIMobile
//
//  Created by Yoon Lee on 12/14/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MyScheduleWorkMap : UIViewController <MKMapViewDelegate>
{
	MKMapView *mapviews;
	NSString *coordinates;
	NSString *titles;
}

- (id) initWithCoordinates:(NSString *)coordinate withTitle:(NSString *)titled;

@end
