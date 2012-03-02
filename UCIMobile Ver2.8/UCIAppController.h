//
//  UCIAppController.h
//  UCI
//
//  Created by Yoon Lee on 2/21/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import "LoginViewController.h"
#import "ASUCIShuttleMap.h"
#import <QuartzCore/QuartzCore.h>

@interface UCIAppController : UIViewController
{
	LoginViewController *loginController;
	NSManagedObjectContext *managedObjectContext;
	NSMutableArray *fetchedFinal;
	NSMutableArray *fetchedCourse;
	UIBarButtonItem *loginBarButtonItem;
	BOOL userWantToLogin;
	IBOutlet UIImageView *imageview;
	
	
	NSArray *smallArray;
	
	@private BOOL didLogin;
}

@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) LoginViewController *loginController;
@property(nonatomic) BOOL didLogin;
@property(nonatomic, retain) UIBarButtonItem *loginBarButtonItem;
@property(nonatomic, retain) IBOutlet UIImageView *imageview;
@property(nonatomic) BOOL userWantToLogin;
@property(nonatomic, retain) NSArray *smallArray;

- (void) setYouYES:(BOOL)successLogin;
- (void) loginView;
- (IBAction) classView:(id)sender;
- (IBAction) loadAbout:(id)sender;
- (IBAction) entireMapView:(id)sender;
- (IBAction) loadCalendar:(id)sender;
- (IBAction) directorySearch:(id)sender;
- (IBAction) loadBusView:(id)sender;
- (IBAction) loadKUCIRadio:(id)sender;
- (IBAction) loadLibrary:(id)sender;
- (IBAction) loadNewsReader:(id)sender;
- (IBAction)loadChat:(id)sender;
//- (IBAction) loadFemaleProtection:(id)sender;
- (IBAction) loadWikipedia:(id)sender;
- (IBAction) loadSportsCrap:(id)sender;
- (IBAction)loadScheduleOfClassWeb:(id)sender;

@end