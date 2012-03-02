    //
//  MyScheduleWorkMap.m
//  UCIMobile
//
//  Created by Yoon Lee on 12/14/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "MyScheduleWorkMap.h"
#import "DDAnnotation.h"

@implementation MyScheduleWorkMap

- (id) initWithCoordinates:(NSString *)coordinate withTitle:(NSString *)titled
{
	coordinates = coordinate;
	titles = titled;
	return self;
}

- (void)viewDidLoad 
{
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 280, 30)];
	label.text = @"Events Location Display";
	label.textAlignment = UITextAlignmentLeft;
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:14];
	label.backgroundColor = [UIColor clearColor];
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 280, 30)];
	label2.text = @"";
	label2.textAlignment = UITextAlignmentLeft;
	label2.textColor = [UIColor whiteColor];
	label2.font = [UIFont fontWithName:@"Georgia" size:12];
	label2.backgroundColor = [UIColor clearColor];
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 60)];
	[imgView addSubview:label2];
	[imgView addSubview:label];
	self.navigationItem.titleView = imgView;
	[imgView release];
	[label release];
	[label2 release];
	
	mapviews = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
	mapviews.delegate = self;
	
	NSArray *seperated = [coordinates componentsSeparatedByString:@","];
	MKCoordinateRegion campusRegion;
	
	campusRegion.center.latitude = [[seperated objectAtIndex:0] floatValue];
	campusRegion.center.longitude = [[seperated objectAtIndex:1] floatValue];
	campusRegion.span.latitudeDelta = 0.0362872;
	campusRegion.span.longitudeDelta = 0.0369863;
	
	[mapviews setRegion:campusRegion animated:YES];
	
	CLLocationCoordinate2D theCoordinate;
	theCoordinate.latitude = [[seperated objectAtIndex:0] floatValue];
    theCoordinate.longitude = [[seperated objectAtIndex:1] floatValue];
	
	DDAnnotation *annotation = [[[DDAnnotation alloc] initWithCoordinate:theCoordinate addressDictionary:nil] autorelease];
	annotation.title = titles;
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
	
	[mapviews addAnnotation:annotation];
	[self.view addSubview:mapviews];
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	static NSString* buldg = @"mylocation";
	MKPinAnnotationView* pinView = (MKPinAnnotationView *)
	[mapviews dequeueReusableAnnotationViewWithIdentifier:buldg];
	
	
	if (!pinView) 
	{
		pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:buldg] autorelease];
		pinView.pinColor = MKPinAnnotationColorRed;
		pinView.animatesDrop = YES;
		pinView.canShowCallout = YES;
		pinView.annotation = annotation;
		pinView.selected = YES;
		
		return pinView;
	}
	else
	{
		pinView.annotation = annotation;
	}
	
	return pinView;
}

- (void)dealloc
{
	mapviews.delegate = nil;
	[mapviews release];
    [super dealloc];
}


@end
