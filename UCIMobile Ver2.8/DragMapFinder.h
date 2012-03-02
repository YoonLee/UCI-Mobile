//
//  DragMapFinder.h
//  UCIMobile
//
//  Created by Yoon Lee on 12/13/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DDAnnotation.h"
#import "DDAnnotationView.h"
#import "AdditionalSchedule.h"

@interface DragMapFinder : UIViewController <MKMapViewDelegate>
{
	MKMapView *mapViews;
	AdditionalSchedule *instance;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapViews;

- (void)coordinateChanged_:(NSNotification *)notification;
- (void) initWithInstance:(AdditionalSchedule *) instant;

@end
