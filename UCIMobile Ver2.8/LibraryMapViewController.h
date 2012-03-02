//
//  LibraryMapViewController.h
//  UCIMobile
//
//  Created by Yoon Lee on 6/20/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "SoundEffect.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
@interface LibraryMapViewController : UIViewController<MKMapViewDelegate, UIWebViewDelegate> {
	Book *book;
	
	UIWebView *webViews;
	MKMapView *mapView;
	UISegmentedControl *segment;
	int pageNumber;
	BOOL isLangsons;
	
	SoundEffect *selectedSound;
	UILabel *direction;
	UILabel *direction2;
}

@property(nonatomic, retain) Book *book;
@property(nonatomic, retain) IBOutlet UIWebView *webViews;
@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) IBOutlet UISegmentedControl *segment;
@property(nonatomic, retain) IBOutlet UILabel *direction;
@property(nonatomic, retain) IBOutlet UILabel *direction2;
- (id)initWithPageNumber:(int)page;
- (BOOL) locateMELibrary;
- (void) segmentChanges:(BOOL)isLangson;
- (void) segmentManagement;

@end
