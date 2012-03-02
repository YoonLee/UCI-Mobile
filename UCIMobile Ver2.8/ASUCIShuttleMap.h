//
//  ASUCIShuttleMap.h
//  UCIMobile
//
//  Created by Yoon Lee on 8/3/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SelectBUSOption.h"

@interface ASUCIShuttleMap : UIViewController <MKMapViewDelegate, SelectBUSOptionViewControllerDelegate> 
{
	MKMapView *mapViews;
	// the data representing the route points. 
	MKPolyline* _routeLine;
	
	// the rect that bounds the loaded points
	MKMapRect _routeRect;
	
	UIActivityIndicatorView *indicatorView;
	
	UIBarButtonItem *locateMe;
	
	NSDictionary *recieverRoute;
	NSMutableArray *revieverStops;
	
	NSThread *busLoader;
	
	
	SelectBUSOption *setOPTION;
	
	UILabel *loadingLabel;
	UIProgressView *loadingProgress;
	BOOL isHIT;
    
    IBOutlet UIToolbar *toolBar;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapViews;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;

@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *locateMe;
@property (nonatomic, retain) NSThread *busLoader;
@property (nonatomic, retain) SelectBUSOption *setOPTION;

@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *loadingProgress;

// load the points of the route from the data source, in this case
// a CSV file. 
-(void) loadRoute:(NSString *)filePath;
-(UIColor *) colorLineRGB:(NSString *)R :(NSString *)G :(NSString *)B;
- (void) mutableLiveBUS;
- (void)waitForBusThreadToFinish;
- (IBAction) reverseGeocodeCurrentLocation;
- (IBAction) defaultCampusMapLocation;

// use the computed _routeRect to zoom in on the route. 
- (void) zoomInOnRoute;
- (IBAction) setOption:(id)sender;
+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;

@end
