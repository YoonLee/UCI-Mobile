//
//  ASUCIShuttleMap.m
//  UCIMobile
//
//  Created by Yoon Lee on 8/3/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "ASUCIShuttleMap.h"
#import "BUSStopAnnotation.h"
#import "BUSLIVEAnnotation.h"
#import "ASIFormDataRequest.h"
#import "TFHpple.h"
#import "UCIAppController.h"
#import "BUSAnnotationView.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>

@implementation ASUCIShuttleMap
@synthesize mapViews;
@synthesize indicatorView;
@synthesize routeLine = _routeLine;
@synthesize locateMe;
@synthesize busLoader;
@synthesize setOPTION;
@synthesize loadingLabel;
@synthesize loadingProgress, toolBar;

- (void)viewDidLoad 
{
	if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) 
	{
		//show an alert to let the user know that they can't connect...
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status" 
														message:@"Sorry, the network is not available.\nPlease try again later." 
													   delegate:nil 
											  cancelButtonTitle:nil 
											  otherButtonTitles:@"OK", nil];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[alert show];
		[alert release];
	}
	
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 220, 30)];
	label1.text = @"Anteater Express";
	label1.textAlignment = UITextAlignmentLeft;
	label1.textColor = [UIColor whiteColor];
	label1.font = [UIFont boldSystemFontOfSize:14];
	label1.backgroundColor = [UIColor clearColor];
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 220, 30)];
	label2.text = @"Select the route in the bottom";
	label2.textAlignment = UITextAlignmentLeft;
	label2.textColor = [UIColor whiteColor];
	label2.font = [UIFont fontWithName:@"Georgia" size:12];
	label2.backgroundColor = [UIColor clearColor];
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 60)];
	[imgView addSubview:label2];
	[imgView addSubview:label1];
	self.navigationItem.titleView = imgView;
	[imgView release];
	[label1 release];
	[label2 release];
	
	self.mapViews.mapType = MKMapTypeStandard;
	self.mapViews.showsUserLocation = YES;
	// zoom in on the route. 
	[self zoomInOnRoute];
	
	MKCoordinateRegion campusRegion;
	campusRegion.center.latitude = 33.646116;
	campusRegion.center.longitude = -117.842875;
	campusRegion.span.latitudeDelta = 0.0162872;
	campusRegion.span.longitudeDelta = 0.0169863;
	[self.mapViews setRegion:campusRegion animated:YES];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{	
    [super viewDidUnload];
}

//selectbustoptiondelegate
- (void) preferenceHasBeenFinish:(SelectBUSOption *)configure 
{
	NSString *filePath = nil;
	NSArray *annotations;
	NSDictionary *singleStop;
	NSString *coordinate;
	NSString *name;
	BUSStopAnnotation *annotation;
	NSString *longi;
	NSString *lati;
	NSMutableArray *addedAnnotations;
	
	//small thread starts... before it closes.
	if (configure.routePtr) 
	{
		filePath = [configure.routePtr objectForKey:@"2dLineName"];
		
		if (!filePath) 
		{
			return;
		}
		
		// create the overlay
		[self loadRoute:filePath];
		recieverRoute = configure.routePtr;
		// add the overlay to the map
		if (nil != self.routeLine) 
		{
			[self.mapViews addOverlay:self.routeLine];
			if ([self.mapViews.overlays count]>1) 
			{
				[self.mapViews removeOverlay:[self.mapViews.overlays objectAtIndex:0]];
			}
		}
		revieverStops = configure.stops;
		addedAnnotations = [[NSMutableArray alloc] init];
		
		for (int i=0; i<[revieverStops count]; i++) 
		{
			singleStop = [revieverStops objectAtIndex:i];
			coordinate = [singleStop objectForKey:@"coordinate"];
			name = [singleStop objectForKey:@"name"];
			annotations = [coordinate componentsSeparatedByString:@";"];
			
			annotation = [[BUSStopAnnotation alloc] init];
			lati = [annotations objectAtIndex:0];
			longi = [annotations objectAtIndex:1];
			
			[annotation initWithName:name forLongitude:longi forLatitude:lati];
			[addedAnnotations addObject:annotation];
			[annotation release];
		}
		if ([self.mapViews.annotations count]>0) 
		{
			[self.mapViews removeAnnotations:self.mapViews.annotations];
		}
		[self.mapViews addAnnotations:addedAnnotations];
		[addedAnnotations release];
	}
	
	//bus thread should start after this.
	//todo
	if (busLoader != nil)
	{
		[busLoader cancel];
		[self waitForBusThreadToFinish];
	}
	
	NSThread *busThread = [[NSThread alloc] initWithTarget:self selector:@selector(busObserver:) object:nil];
	self.busLoader = busThread;
	[busThread release];
	[self defaultCampusMapLocation];
	[busLoader start];
	
	[self dismissModalViewControllerAnimated:YES];
	loadingProgress.hidden = YES;
	loadingLabel.hidden = YES;
	//[configure release];
}

//map delegates
// mapView:viewForAnnotation: provides the view for each annotation.
// This method may be called for all or some of the added annotations.
// For MapKit provided annotations (eg. MKUserLocation) return nil to use the MapKit provided annotation view.
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation 
{
	if (recieverRoute == nil) 
	{
		return nil;
	}
	if ([annotation isKindOfClass:[BUSLIVEAnnotation class]]) 
	{
		static NSString *LiveBusAnnotationIdentifier = @"LiveBusAnnotationIdentifier";
		
		BUSAnnotationView *liveBusView = (BUSAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:LiveBusAnnotationIdentifier];
		
		if (liveBusView == nil) 
		{
			liveBusView = [[[BUSAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:LiveBusAnnotationIdentifier] autorelease];
		}
		liveBusView.canShowCallout = YES;
		liveBusView.annotation = annotation;
		
		return liveBusView;
	}
	
	else if ([annotation isKindOfClass:[BUSStopAnnotation class]]) 
	{
		static NSString *BusAnnotationIdentifier = @"BusAnnotationIdentifier";
		
		MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:BusAnnotationIdentifier];
		
		if (!pinView) 
		{
			MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:BusAnnotationIdentifier] autorelease];
			annotationView.canShowCallout = YES;
			
			UIImage *busStops = [UIImage imageNamed:@"BUS_STOP.png"];
			
			CGRect resizeRect;
            
            resizeRect.size = busStops.size;
            CGSize maxSize = CGRectInset(self.view.bounds,
                                         [ASUCIShuttleMap annotationPadding],
                                         [ASUCIShuttleMap annotationPadding]).size;
            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [ASUCIShuttleMap calloutHeight];
            if (resizeRect.size.width > maxSize.width)
                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
            if (resizeRect.size.height > maxSize.height)
                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
            
            resizeRect.origin = (CGPoint){0.0f, 0.0f};
            UIGraphicsBeginImageContext(resizeRect.size);
            [busStops drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            annotationView.image = resizedImage;
            annotationView.opaque = YES;
			annotationView.alpha = .60;
			
            return annotationView;
		}
		else
        {
            pinView.annotation = annotation;
        }
        return pinView;
	}
	
	
	return nil;
}

//overlay drawn
#pragma mark MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
	MKOverlayView* overlayView = nil;
	MKPolylineView *linear = nil;
	NSString *color;
	NSString *R = nil;
	NSString *G = nil;
	NSString *B = nil;
	NSArray *seperate;
	
	if(overlay == self.routeLine)
	{
		if (recieverRoute) 
		{
			color = [recieverRoute objectForKey:@"lineColor"];
			seperate = [color componentsSeparatedByString:@" "];
			R = [seperate objectAtIndex:0];
			G = [seperate objectAtIndex:1];
			B = [seperate objectAtIndex:2];
		}
		//if we have not yet created an overlay view for this overlay, create it now. 
		
		linear = [[[MKPolylineView alloc] initWithPolyline:self.routeLine] autorelease];
		
		linear.strokeColor = [self colorLineRGB:R :G :B];
		linear.lineWidth = 5;
		
		overlayView = linear;
	}
	
	return overlayView;
	
}

//Thread...
-(void) busObserver:(id)sender
{
	NSAutoreleasePool *fool = [[NSAutoreleasePool alloc] init];
	BOOL isEnd = NO;
	//NSLog(@"IS RUNNING?");
	while (!isEnd) 
	{
		//NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init]; 
		//NSLog(@"%@", self.navigationController.topViewController);
		if ([busLoader isCancelled]) 
		{
			isEnd = YES;
		}
		else if (!self.navigationController.topViewController) 
		{
			isEnd = YES;
		}
		
		else 
		{
			[self mutableLiveBUS];
			[NSThread sleepForTimeInterval:4.0];
		}
		//NSLog(@"RUNS");
		//[loopPool release];
	}
	//NSLog(@"kills");
	[fool release];
}

- (void)waitForBusThreadToFinish 
{
    while (busLoader && ![busLoader isFinished]) 
	{ // Wait for the thread to finish.
        [NSThread sleepForTimeInterval:0.05];
    }
}

//bus parse method
- (void) mutableLiveBUS 
{
	if ([recieverRoute count]==0) 
	{
		return;
	}
	NSString *value = [recieverRoute objectForKey:@"value"];
	
	value = [NSString stringWithFormat:@"http://public.syncromatics.com/xml.scrx?mode=track&route=%@&domain=ucishuttles.com", value];
	NSURL *url = [NSURL URLWithString:value];
	
	@try 
	{
		ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
		[request startSynchronous];
		TFHpple *tfhpple = [[TFHpple alloc] initWithXMLData:[request responseData]];
		NSArray *vehicles = [tfhpple search:@"//markers/route/vehicle"];
		NSString *latitude;
		NSString *longitude;
		NSString *heading;
		
		NSString *speed;
		NSString *name;
		
		NSMutableArray *liveAnnotation = [[NSMutableArray alloc] init];
		
		TFHppleElement *liveBUSinfo;
		
		for (int i=0; i<[vehicles count]; i++) 
		{
			liveBUSinfo = [vehicles objectAtIndex:i];
			
			latitude  =  [[liveBUSinfo attributes] objectForKey:@"latitude"];
			longitude =  [[liveBUSinfo attributes] objectForKey:@"longitude"];
			heading   =  [[liveBUSinfo attributes] objectForKey:@"heading"];	
			speed     =  [[liveBUSinfo attributes] objectForKey:@"speed"];
			name      =  [[liveBUSinfo attributes] objectForKey:@"name"];	
			
			//NSLog(@"name:%@ x:%@ y:%@ head:%@ speed:%@",name, latitude, longitude, heading, speed);
			BUSLIVEAnnotation *liveBUSAnnotation = [[BUSLIVEAnnotation alloc] init];
			[liveBUSAnnotation initWithName:name forLongitude:longitude forLatitude:latitude forDirection:heading forSpeed:speed];
			[liveAnnotation addObject:liveBUSAnnotation];
			[liveBUSAnnotation release];
		}
		//NSLog(@"%@", [request responseString]);
		
		//remove
		//NSLog(@"REMOVE BUS ROUTE");
		
		for (int j=0; j<[self.mapViews.annotations count]; j++) 
		{
			if ([[self.mapViews.annotations objectAtIndex:j] isKindOfClass:[BUSLIVEAnnotation class]]) 
			{
				[self.mapViews removeAnnotation:[self.mapViews.annotations objectAtIndex:j]];
			}
		}
		//then add
		//NSLog(@"ADD BUS ROUTE");
		[self.mapViews addAnnotations:liveAnnotation];
		
		[liveAnnotation release];
		[tfhpple release];
	}
	@catch (NSException * e) 
	{
		NSLog(@"ERROR CAUSED");
	}
}

#pragma mark -

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}
+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

- (void) optionThread:(id)sender
{
	if (!setOPTION) 
	{
		setOPTION = [[SelectBUSOption alloc] initWithNibName:@"SelectBUSOption" bundle:nil];
		setOPTION.delegate = self;
		[setOPTION initWithCurrentSeason];
	}
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
    setOPTION.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
#else
	setOPTION.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
#endif
	[self presentModalViewController:setOPTION animated:YES];
}

- (void) progressBarThread:(NSTimer *)sender
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	if (!isHIT&&loadingProgress.progress>0.780000) 
	{
		[NSTimer scheduledTimerWithTimeInterval:.004 target:self selector:@selector(optionThread:) userInfo:nil repeats:NO];
		isHIT = YES;
		//NSLog(@"play");
	}
	if (loadingProgress.progress!=1.0) 
	{
		loadingProgress.progress += 0.005;
		//NSLog(@"%f", loadingProgress.progress);
		return;
	}
	else
	{
		[sender invalidate];
		isHIT = NO;
		//NSLog(@"terminate");
	}
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//launches option view controller for user to setup the bus route
- (IBAction) setOption:(id)sender 
{
	loadingProgress.progress = 0.0;
	loadingProgress.hidden = NO;
	loadingLabel.hidden = NO;
	if (![busLoader isCancelled]) 
	{
		[busLoader cancel];
	}	
	[NSTimer scheduledTimerWithTimeInterval:0.0001 target:self selector:@selector(progressBarThread:) userInfo:nil repeats:YES];
}

//shows campus location by button
- (IBAction) defaultCampusMapLocation 
{
	if (recieverRoute==nil) 
	{
		return;
	}
	
	NSString *lineCenterCoordinate = [recieverRoute objectForKey:@"centerCoordinate"];
	NSArray *listHolder = [lineCenterCoordinate componentsSeparatedByString:@";"];
	MKCoordinateRegion campusRegion;
	
	campusRegion.center.latitude = [[listHolder objectAtIndex:0] floatValue];
	campusRegion.center.longitude = [[listHolder objectAtIndex:1] floatValue];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	campusRegion.span.latitudeDelta = [[listHolder objectAtIndex:2] floatValue];
	campusRegion.span.longitudeDelta = [[listHolder objectAtIndex:3] floatValue];
	
	[self.mapViews setRegion:campusRegion animated:YES];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

//shows blue dot for my location
- (IBAction) reverseGeocodeCurrentLocation 
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	self.mapViews.showsUserLocation = YES;
	self.mapViews.userLocation.title = @"Current Location";
	[self.indicatorView startAnimating];  
	[self.locateMe setImage:[UIImage imageNamed:@""]];
	[self.locateMe setStyle:UIBarButtonItemStyleDone];
	[self.indicatorView setHidden:NO];
	[self.indicatorView setHidesWhenStopped:YES];
	
	MKCoordinateRegion meRegion;
	meRegion.center.latitude = mapViews.userLocation.location.coordinate.latitude;
	meRegion.center.longitude = mapViews.userLocation.location.coordinate.longitude;
	meRegion.span.latitudeDelta = 0.0052872;
	meRegion.span.longitudeDelta = 0.0059863;
	[self.mapViews setRegion:meRegion animated:YES];
	[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(movement) userInfo:nil repeats:NO];
}

//this will runs for 2 second
- (void) movement 
{
	[self.indicatorView stopAnimating];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self.locateMe setImage:[UIImage imageNamed:@"74-location.png"]];
	[self.locateMe setStyle:UIBarButtonItemStyleBordered];
}

//color palette
-(UIColor *) colorLineRGB:(NSString *)R :(NSString *)G :(NSString *)B 
{
	return [UIColor colorWithRed:[R floatValue]/255.0 green:[G floatValue]/255.0 blue:[B floatValue]/255.0 alpha:.75];
}

-(void) zoomInOnRoute
{
	[self.mapViews setVisibleMapRect:_routeRect];
}

// creates the route (MKPolyline) overlay
-(void) loadRoute:(NSString *)filePath
{
	NSString* fileRoot = [[NSBundle mainBundle] pathForResource:filePath ofType:@"csv"];
	
	NSString* fileContents = [NSString stringWithContentsOfFile:fileRoot encoding:NSUTF8StringEncoding error:nil];
	NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	
	// while we create the route points, we will also be calculating the bounding box of our route
	// so we can easily zoom in on it. 
	MKMapPoint northEastPoint = MKMapPointMake(0, 0); 
	MKMapPoint southWestPoint = MKMapPointMake(0, 0); 
	
	// create a c array of points. 
	MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * pointStrings.count);
	
	for(int idx = 0; idx < pointStrings.count; idx++)
	{
		// break the string down even further to latitude and longitude fields. 
		NSString* currentPointString = [pointStrings objectAtIndex:idx];
		NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]];
		
		CLLocationDegrees latitude  = [[latLonArr objectAtIndex:0] doubleValue];
		CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
		
		
		// create our coordinate and add it to the correct spot in the array 
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
		
		MKMapPoint point = MKMapPointForCoordinate(coordinate);
		
		
		
		// adjust the bounding box
		//
		
		// if it is the first point, just use them, since we have nothing to compare to yet. 
		if (idx == 0) 
		{
			northEastPoint = point;
			southWestPoint = point;
		}
		else 
		{
			if (point.x > northEastPoint.x) 
				northEastPoint.x = point.x;
			if(point.y > northEastPoint.y)
				northEastPoint.y = point.y;
			if (point.x < southWestPoint.x) 
				southWestPoint.x = point.x;
			if (point.y < southWestPoint.y) 
				southWestPoint.y = point.y;
		}
		
		pointArr[idx] = point;
	}
	
	// create the polyline based on the array of points. 
	self.routeLine = [MKPolyline polylineWithPoints:pointArr count:pointStrings.count];
	
	_routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, northEastPoint.x - southWestPoint.x, northEastPoint.y - southWestPoint.y);
	
	// clear the memory allocated earlier for the points
	free(pointArr);
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    switch (toInterfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            [toolBar setFrame:CGRectMake(0, 224, 320, 44)];
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            [toolBar setFrame:CGRectMake(0, 373, 480, 44)];
            break;
    }
}

- (void)dealloc 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[setOPTION release];
	setOPTION = nil;
	[indicatorView release];
	indicatorView = nil;
	[locateMe release];
	locateMe = nil;
	[_routeLine release];
	_routeLine = nil;
	[mapViews release];
	mapViews = nil;
	if (recieverRoute) 
	{
		//[recieverRoute release];
		recieverRoute = nil;
	}
	if (revieverStops)
	{
		//[revieverStops release];
		revieverStops = nil;
	}
    [super dealloc];
}

@end
