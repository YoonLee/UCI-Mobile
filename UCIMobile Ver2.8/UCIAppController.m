//
//  UCIAppController.m
//  UCI
//
//  Created by Yoon Lee on 2/21/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import "UCIAppController.h"
#import "EntireMapView.h"
#import "UCIStudentForever.h"
#import "AcademicScheduleViewController.h"
#import "DirectorySearch.h"
#import "CreatorViewController.h"
#import "KUCIRadioStation.h"
#import "LibraryLookUp.h"
#import "RSSNewsChooserController.h"
#import "ClassLoader.h"
#import "SportsScheduler.h"
#import "RosterController.h"
#import "AdViewController.h"
#import "UCICodeDataAppDelegate.h"

//#import "FemaleProtectionTableController.h"


@implementation UCIAppController
@synthesize loginController;
@synthesize managedObjectContext;
@synthesize didLogin, loginBarButtonItem, userWantToLogin;
@synthesize imageview;
@synthesize smallArray;

- (void)viewDidLoad 
{	
	//[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(isHalloween:) userInfo:self repeats:YES];
    UCICodeDataAppDelegate *appDelegate = (UCICodeDataAppDelegate *)[UIApplication sharedApplication].delegate;
    [self setManagedObjectContext:appDelegate.managedObjectContext];
    
	UIColor *color = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"mainScreen.png"]];
	self.view.backgroundColor = color;
	[color release];
	[self.view sizeToFit];
	self.didLogin = NO;
	
	UIImage *image = [UIImage imageNamed:@"logo.png"];
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
	[button setImage:image forState:UIControlStateNormal];
	[button addTarget:self action:@selector(adForMe:) forControlEvents:UIControlEventTouchUpInside];
	
	self.navigationItem.titleView = button;
	[button release];
	
	self.navigationItem.titleView.alpha = .90;
    
	UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
	
	backBarButtonItem.title = @"Home";
	
	loginBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(loginView)];
	
	[self.navigationItem setBackBarButtonItem:backBarButtonItem];
    [self.navigationItem setRightBarButtonItem:loginBarButtonItem];
    
    [self.navigationController.navigationBar setTintColor:RGB(120, 177, 243)];
	[loginBarButtonItem release];
	[backBarButtonItem release];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIImageView * bttn1 = (UIImageView *)[self.view viewWithTag:10];
    UIImageView * bttn2 = (UIImageView *)[self.view viewWithTag:11];
    UIImageView * bttn3 = (UIImageView *)[self.view viewWithTag:12];
    UIImageView * bttn4 = (UIImageView *)[self.view viewWithTag:13];
    UIImageView * bttn5 = (UIImageView *)[self.view viewWithTag:14];
    UIImageView * bttn6 = (UIImageView *)[self.view viewWithTag:15];
    UIImageView * bttn7 = (UIImageView *)[self.view viewWithTag:16];
    UIImageView * bttn8 = (UIImageView *)[self.view viewWithTag:17];
    UIImageView * bttn9 = (UIImageView *)[self.view viewWithTag:18];
    UIImageView * bttn10 = (UIImageView *)[self.view viewWithTag:19];
    UIImageView * bttn11 = (UIImageView *)[self.view viewWithTag:20];
    UIImageView * bttn12 = (UIImageView *)[self.view viewWithTag:21];
    
    switch (toInterfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            [bttn1 setHidden:NO];
            [bttn2 setHidden:NO];
            [bttn3 setHidden:NO];
            [bttn4 setHidden:NO];
            [bttn5 setHidden:NO];
            [bttn6 setHidden:NO];
            [bttn7 setHidden:NO];
            [bttn8 setHidden:NO];
            [bttn9 setHidden:NO];
            [bttn10 setHidden:NO];
            [bttn11 setHidden:NO];
            [bttn12 setHidden:NO];
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            [bttn1 setHidden:YES];
            [bttn2 setHidden:YES];
            [bttn3 setHidden:YES];
            [bttn4 setHidden:YES];
            [bttn5 setHidden:YES];
            [bttn6 setHidden:YES];
            [bttn7 setHidden:YES];
            [bttn8 setHidden:YES];
            [bttn9 setHidden:YES];
            [bttn10 setHidden:YES];
            [bttn11 setHidden:YES];
            [bttn12 setHidden:YES];
            break;
    }
}

- (void)adForMe:(id)sender
{
	AdViewController *adViewcontroller = [[AdViewController alloc] init];
	[self.navigationController pushViewController:adViewcontroller animated:YES];
	[adViewcontroller release];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{	
	managedObjectContext = nil;
	loginController = nil;
	fetchedFinal = nil;
	fetchedCourse = nil;
}

- (void)loginView 
{
	loginController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
	loginController.managedObjectContext = self.managedObjectContext;
	
	[self.navigationController pushViewController:loginController animated:YES];
	loginController.a = self;
	
	[self.loginController release];
}

- (IBAction)classView:(id)sender 
{
	UCIStudentForever *scheduleMaster = [[UCIStudentForever alloc] initWithStyle:UITableViewStyleGrouped];
	[scheduleMaster setManagedObjectContext:self.managedObjectContext];
	
	[self.navigationController pushViewController:scheduleMaster animated:YES];
	[scheduleMaster release];
}

- (IBAction)loadAbout:(id)sender 
{
	CreatorViewController *a = [[CreatorViewController alloc] initWithNibName:@"CreatorViewController" bundle:nil];
	[self.navigationController pushViewController:a animated:YES];
	[a release];
}

- (IBAction)loadChat:(id)sender 
{	
	RosterController *rc = [[RosterController alloc] initWithStyle:UITableViewStyleGrouped];	
	UINavigationController *rnc = [[UINavigationController alloc] initWithRootViewController:rc];
	rc.managedObjectContext = self.managedObjectContext;
	[rc release];
	
	[self presentModalViewController:rnc animated:YES];
}

- (IBAction)loadScheduleOfClassWeb:(id)sender
{
    ClassLoader *search = [[ClassLoader alloc] initWithNibName:@"ClassLoader" bundle:nil];
	search.name = @"Schedule Of Classes";
	search.link = @"http://websoc.reg.uci.edu/perl/WebSoc";
	[self.navigationController pushViewController:search animated:YES];
	[search release];
}

- (void) setYouYES:(BOOL)successLogin
{
	if (successLogin) 
	{
		loginBarButtonItem.title = @"Logout";
	}
	else 
	{
		loginBarButtonItem.title = @"Login";
	}
}

- (IBAction)entireMapView:(id)sender 
{
	EntireMapView *entire = [[EntireMapView alloc] initWithNibName:@"EntireMapView" bundle:nil];
	entire.managedObjectContext = self.managedObjectContext;
	
	[self.navigationController pushViewController:entire animated:YES];
	[entire release];
}

- (IBAction)loadCalendar:(id)sender 
{
	AcademicScheduleViewController *schedule = [[AcademicScheduleViewController alloc] initWithStyle:UITableViewStylePlain];
	[schedule setManagedObjectContext:self.managedObjectContext];
	[self.navigationController pushViewController:schedule animated:YES];
	
	[schedule release];
}

- (IBAction) directorySearch:(id)sender 
{
	DirectorySearch *directory = [[DirectorySearch alloc] initWithNibName:@"DirectorySearch" bundle:nil];
	[directory setManagedObjectContext:self.managedObjectContext];
	
	[self.navigationController pushViewController:directory animated:YES];
	[directory release];
}

- (IBAction) loadBusView:(id)sender 
{
	ASUCIShuttleMap *busLoader = [[ASUCIShuttleMap alloc] initWithNibName:@"ASUCIShuttleMap" bundle:nil];
	[self.navigationController pushViewController:busLoader animated:YES];
	[busLoader release];
}

- (IBAction) loadKUCIRadio:(id)sender 
{
	KUCIRadioStation *radioStar = [[KUCIRadioStation alloc] initWithNibName:@"KUCIRadioStation" bundle:nil];
	[self.navigationController pushViewController:radioStar animated:YES];
	[radioStar release];
}

- (IBAction) loadLibrary:(id)sender 
{
	LibraryLookUp *vpn = [[LibraryLookUp alloc] initWithNibName:@"LibraryLookUp" bundle:nil];
	[self.navigationController pushViewController:vpn animated:YES];
	[vpn release];
}

- (IBAction) loadNewsReader:(id)sender
{
	RSSNewsChooserController *rssNews = [[RSSNewsChooserController alloc] initWithNibName:@"RSSNewsChooserController" bundle:nil];
	[self.navigationController pushViewController:rssNews animated:YES];
	[rssNews release];
}

//- (IBAction) loadFemaleProtection:(id)sender
//{
//	FemaleProtectionTableController *femaleProtection = [[FemaleProtectionTableController alloc] initWithNibName:@"FemaleProtectionTableController" bundle:nil];
//	[self.navigationController pushViewController:femaleProtection animated:YES];
//	[femaleProtection release];
//}

- (IBAction) loadWikipedia:(id)sender
{
	ClassLoader *search = [[ClassLoader alloc] initWithNibName:@"ClassLoader" bundle:nil];
	search.name = @"Wikipedia";
	search.link = @"http://www.wikipedia.org/";
	[self.navigationController pushViewController:search animated:YES];
	[search release];
}

- (IBAction) loadSportsCrap:(id)sender
{
	SportsScheduler *sport = [[SportsScheduler alloc] initWithStyle:UITableViewStyleGrouped];
	[self.navigationController pushViewController:sport animated:YES];
	[sport release];
}

- (void) isHalloween:(id)sender
{
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MM-dd"];
	// today is halloween
	NSDate *halloween = [format dateFromString:@"10-31"];
	NSDate *prepare = [format dateFromString:@"10-22"];
	// Debug
	//NSDate *rightNow = [format dateFromString:@"10-23"];
//	NSLog(@"%@", rightNow);
    NSDate *rightNow = [format dateFromString:[format stringFromDate:[NSDate date]]];
	//NSLog(@"%@", rightNow);
	if (([rightNow compare:halloween]==NSOrderedAscending&&[rightNow compare:prepare]==NSOrderedDescending)||[rightNow compare:halloween]==NSOrderedSame ||[rightNow compare:prepare]==NSOrderedSame )
	{
		CATransition *transition = [CATransition animation];
		transition.duration = 4.0;
		transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		transition.type = kCATransitionReveal;
		transition.delegate = self;
		
		UIImage *image1 = [UIImage imageNamed:@"h1.png"];
		UIImage *image2 = [UIImage imageNamed:@"h2.png"];
		UIImage *image3 = [UIImage imageNamed:@"h3.png"];
		UIImage *image4 = [UIImage imageNamed:@"h4.png"];
		UIImage *image5 = [UIImage imageNamed:@"hallow.png"];
		
		UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image1];
		UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image2];
		UIImageView *imageView3 = [[UIImageView alloc] initWithImage:image3];
		UIImageView *imageView4 = [[UIImageView alloc] initWithImage:image4];
		UIImageView *imageView5 = [[UIImageView alloc] initWithImage:image5];
		
		smallArray = [[NSArray alloc] initWithObjects:imageView1, imageView2, imageView3, imageView4, imageView5, nil];
		// location
		imageView1.frame = CGRectMake(5, 10, 64, 64);
		imageView1.opaque = NO;
		[imageView1.layer addAnimation:transition forKey:nil];
		
		imageView2.frame = CGRectMake(260, 10, 64, 64);
		imageView2.opaque = NO;
		[imageView2.layer addAnimation:transition forKey:nil];

		imageView3.frame = CGRectMake(260, 300, 64, 64);
		imageView3.opaque = NO;
		transition.type = kCATransitionFromRight;
		[imageView3.layer addAnimation:transition forKey:nil];
		
		imageView4.frame = CGRectMake(5, 300, 64, 64);
		imageView4.opaque = NO;
		transition.type = kCATransitionMoveIn;
		[imageView4.layer addAnimation:transition forKey:nil];
		
		imageView5.frame = CGRectMake(35, 290, 200, 50);
		imageView5.opaque = NO;
		transition.type = kCATransitionMoveIn;
		[imageView5.layer addAnimation:transition forKey:nil];
		
		[self.view addSubview:imageView1];
		[self.view addSubview:imageView2];
		[self.view addSubview:imageView3];
		[self.view addSubview:imageView4];
		[self.view addSubview:imageView5];
		
		[imageView1 release];
		[imageView2 release];
		[imageView3 release];
		[imageView4 release];
		[imageView5 release];
		//NSLog(@"invalidate it!");
		[sender invalidate];
		//[NSThread sleepForTimeInterval:5.0];
		[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(fadeAway:) userInfo:self repeats:YES];
	}
	
	[format release];
	[sender invalidate];
}

- (void) fadeAway:(id)sender
{	
	for (UIView *imageView in smallArray) 
	{
		imageView.alpha = .20;
		[imageView removeFromSuperview];
	}
	
	[smallArray release];
	[sender invalidate];
}

- (void) viewWillAppear:(BOOL)animated
{
    //[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
}

- (void) dealloc 
{
	[loginController release];
	[fetchedFinal release];
	[fetchedCourse release];
	[loginBarButtonItem release];
	userWantToLogin = NO;
	[imageview release];
	[super dealloc];
}


@end
