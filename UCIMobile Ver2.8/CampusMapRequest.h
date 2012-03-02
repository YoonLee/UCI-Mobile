//
//  CampusMapRequest.h
//  UCIMobileAccessCoreData
//
//  Created by Yoon Lee on 3/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CampusMapStorage.h"

@interface CampusMapRequest : UIViewController <UIAlertViewDelegate, MKMapViewDelegate> 
{
	NSManagedObjectContext *context;
	IBOutlet MKMapView *mapView;
	MKReverseGeocoder *reverseGeocoder;
	NSMutableArray *storeForFetchedMapInfo;
	
	NSMutableArray *annotationQuery;
	NSString *requestToSearch;
	BOOL isEntireMapView;
	NSNumber *storeFoundDeptNum;
	
	CampusMapStorage *directMapPosition;
	CampusMapStorage *innerSideSelected;
	
	IBOutlet UIBarButtonItem *locateMe;
	IBOutlet UIActivityIndicatorView *seeking;
}

@property(nonatomic, retain) NSManagedObjectContext *context;
@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *storeForFetchedMapInfo;
@property (nonatomic, retain) NSMutableArray *annotationQuery;
@property (nonatomic, retain) NSString* requestToSearch;
@property (nonatomic, retain) NSNumber *storeFoundDeptNum;
@property (nonatomic, retain) CampusMapStorage *directMapPosition;
@property (nonatomic) BOOL isEntireMapView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *seeking;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *locateMe;



- (BOOL) fetchCampusMap;
- (IBAction) defaultCampusMapLocation;
- (IBAction) reverseGeocodeCurrentLocation;
- (void) descriptionAndLocateCourse;
- (void) lookUpFromQuery;
- (void) launchImageView;
- (void) prepare;
//- (void)reachabilityChanged:(NSNotification *)note;
- (void)updateStatus;

@end
