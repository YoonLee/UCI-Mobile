//
//  CampusMapRequest.m
//  UCIMobileAccessCoreData
//
//  Created by Yoon Lee on 3/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CampusMapRequest.h"
#import "CampusMapStorage.h"
#import "BuildingView.h"
#import "Reachability.h"

@implementation CampusMapRequest
@synthesize context, mapView, 
storeForFetchedMapInfo, annotationQuery, requestToSearch, storeFoundDeptNum;
@synthesize isEntireMapView, directMapPosition, seeking, locateMe;


- (void) viewDidLoad 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self updateStatus];
	self.title = @"Campus";
	[self prepare];
}

- (void) prepare 
{
	//tester case
	self.mapView.showsUserLocation = YES; 	
	self.mapView.mapType = MKMapTypeStandard;
	//#1 data fetch part
	[self fetchCampusMap];
	//#2 annotation data in array part
	self.annotationQuery = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
	
	if (isEntireMapView)
	{
		[self.mapView removeAnnotations:self.mapView.annotations];
		[annotationQuery addObject:directMapPosition];
		[directMapPosition release];
		//c is used for reciever, so there is no counfusion
		innerSideSelected = [self.annotationQuery objectAtIndex:0];
		
		[self.mapView addAnnotation:innerSideSelected];
		return;
	}
	[self lookUpFromQuery];
	[self.mapView removeAnnotations:self.mapView.annotations];
	
	innerSideSelected = [self.annotationQuery objectAtIndex:0];
	[self.mapView addAnnotation: innerSideSelected];
}

- (void)updateStatus
{
	if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) 
	{
		//show an alert to let the user know that they can't connect...
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status" 
														message:@"Sorry, the network is not available.\nPlease try again later." 
													   delegate:self 
											  cancelButtonTitle:nil 
											  otherButtonTitles:@"OK", nil];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[alert show];
		[alert release];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if (buttonIndex==0) 
	{
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (BOOL) fetchCampusMap 
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"CampusMapStorage" inManagedObjectContext:context];
	[request setEntity:entity];
	
	NSError *err;
	storeForFetchedMapInfo = [[context executeFetchRequest:request error:&err] mutableCopy];
	
	[request release];
	
	return [storeForFetchedMapInfo count]>0?YES:NO;
}

- (IBAction) defaultCampusMapLocation 
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	MKCoordinateRegion campusRegion;
	campusRegion.center.latitude = 33.646116;
	campusRegion.center.longitude = -117.842875;
	campusRegion.span.latitudeDelta = 0.0062872;
	campusRegion.span.longitudeDelta = 0.0069863;
	
	[self.mapView setRegion:campusRegion animated:YES];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (IBAction) reverseGeocodeCurrentLocation 
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	self.mapView.showsUserLocation = YES;
	self.mapView.userLocation.title = @"Current Location";
	[self.seeking startAnimating];  
	[reverseGeocoder start];//ok
	[self.locateMe setImage:[UIImage imageNamed:@""]];
	[self.locateMe setStyle:UIBarButtonItemStyleDone];
	[self.seeking setHidden:NO];
	[self.seeking setHidesWhenStopped:YES];
	
	MKCoordinateRegion meRegion;
	meRegion.center.latitude = mapView.userLocation.location.coordinate.latitude;
	meRegion.center.longitude = mapView.userLocation.location.coordinate.longitude;
	meRegion.span.latitudeDelta = 0.0052872;
	meRegion.span.longitudeDelta = 0.0059863;
	[self.mapView setRegion:meRegion animated:YES];
	[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(movement) userInfo:nil repeats:NO];
}

- (void) movement 
{
	[self.seeking stopAnimating];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self.locateMe setImage:[UIImage imageNamed:@"74-location.png"]];
	[self.locateMe setStyle:UIBarButtonItemStyleBordered];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) lookUpFromQuery 
{
	NSScanner *scan = [NSScanner scannerWithString:requestToSearch];
	NSString *abreBname;
	
	[scan scanUpToString:@" " intoString:&abreBname];
	//Just for now on do linear search instead using NSPredicate
	//[storeForFetchedMapInfo filterUsingPredicate:predicate];
	for (int i=0;i<[storeForFetchedMapInfo count];i++) 
	{
		CampusMapStorage *s = (CampusMapStorage *)[storeForFetchedMapInfo objectAtIndex:i];
		if ([[s abreviateBname] isEqualToString:abreBname]) 
		{
			if ([annotationQuery count] > 1) 
			{
				[annotationQuery removeLastObject];
			}
			
			[annotationQuery addObject:s];
			storeFoundDeptNum = (NSNumber *)[s numBuilding];
			break;
		}
	}
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CampusMapStorage class]])
	{
        static NSString* buldg = @"building";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
		[mapView dequeueReusableAnnotationViewWithIdentifier:buldg];
        if (!pinView) 
		{
			MKPinAnnotationView *customPinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:buldg] autorelease];
			customPinView.pinColor = MKPinAnnotationColorRed;
			customPinView.animatesDrop = YES;
			customPinView.canShowCallout = YES;
			customPinView.selected = YES;
            
			UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			[rightButton addTarget:self
                            action:@selector(launchImageView)
                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
			
			MKCoordinateRegion campusRegion;
			CampusMapStorage *c = [self.annotationQuery objectAtIndex:0];
			campusRegion.center.latitude = [c.y_coordinate floatValue];
			campusRegion.center.longitude = [c.x_coordinate floatValue];
			campusRegion.span.latitudeDelta = 0.0052872;
			campusRegion.span.longitudeDelta = 0.0059863;
			[self.mapView setRegion:campusRegion animated:NO];
            return customPinView;
        }
        else 
		{
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

- (void) descriptionAndLocateCourse 
{
	if (isEntireMapView) 
	{
		[self.mapView removeAnnotations:self.mapView.annotations];
		[annotationQuery addObject:directMapPosition];
		[directMapPosition release];
		//c is used for reciever, so there is no counfusion
		innerSideSelected = [self.annotationQuery objectAtIndex:0];
		
		[self.mapView addAnnotation:innerSideSelected];
		return;
	}
	[self lookUpFromQuery];
	[self.mapView removeAnnotations:self.mapView.annotations];
	
	innerSideSelected = [self.annotationQuery objectAtIndex:0];
	[self.mapView addAnnotation: innerSideSelected];
}

- (void) launchImageView 
{
	BuildingView *information = [[BuildingView alloc] initWithNibName:@"BuildingView" bundle:nil];
	if (isEntireMapView)
	{
		information.display = directMapPosition;
		[directMapPosition release];
	}
	else 
	{
		information.display = innerSideSelected;
		[innerSideSelected release];
	}
	
	[self.navigationController pushViewController:information animated:YES];
	
	[information release];
}

- (void) viewDidUnload 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	mapView = nil;
	context = nil;
	reverseGeocoder = nil;
	annotationQuery = nil;
	requestToSearch = nil;
	storeFoundDeptNum = nil;
	innerSideSelected = nil;
	isEntireMapView = NO;
}

- (void)didReceiveMemoryWarning 
{	
    [super didReceiveMemoryWarning];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

- (void) dealloc 
{
	[annotationQuery release];
	[context release];//ok
	[storeForFetchedMapInfo release];//ok
	mapView.delegate = nil;
	reverseGeocoder.delegate = nil;
	[super dealloc];
	
}

@end
