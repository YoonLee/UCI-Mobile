//
//  KUCIRadioStation.m
//  UCIMobile
//
//  Created by Yoon Lee on 6/6/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "KUCIRadioStation.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>

@implementation KUCIRadioStation
@synthesize webview, textView, label1, label2, label3;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	UILabel *label12 = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 180, 30)];
	label12.text = @"KUCI Radio Station";
	label12.textAlignment = UITextAlignmentLeft;
	label12.textColor = [UIColor whiteColor];
	label12.font = [UIFont boldSystemFontOfSize:14];
	label12.backgroundColor = [UIColor clearColor];
	label12.tag = 1;
	UILabel *label23 = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 200, 30)];
	label23.text = @"88.9FM, Listen Live!";
	label23.textAlignment = UITextAlignmentLeft;
	label23.textColor = [UIColor whiteColor];
	label23.font = [UIFont fontWithName:@"Georgia" size:12];
	label23.backgroundColor = [UIColor clearColor];
	label23.tag = 2;
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
	[imgView addSubview:label23];
	[imgView addSubview:label12];
	self.navigationItem.titleView = imgView;
	[imgView release];
	[label12 release];
	[label23 release];
	
	NSBundle *mainBundle = [NSBundle mainBundle];	
	selectedSound =  [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"noise" ofType:@"wav"]];
	
	self.textView.layer.borderWidth = 5.0;
	self.textView.layer.cornerRadius = 15;
	self.label1.layer.cornerRadius = 5;	
	self.label2.layer.cornerRadius = 5;	
	self.label3.layer.cornerRadius = 5;	
	self.label1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	self.label2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	self.label3.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	self.label1.layer.borderWidth = 3;
	self.label2.layer.borderWidth = 3;
	self.label3.layer.borderWidth = 3;
	
	self.textView.font = [UIFont systemFontOfSize:11];
	self.textView.text = @"*KUCI's Philosophy and Mission\n\nKUCI started as a pirate radio station, because even back then, there were people sick of commercial radio. There are currently no independently owned commercial radio stations in the greater Los Angeles area. This is the reason that if you call up a commercial station and request a song, you won't hear it if it's not the flavor of the week. Public affairs shows are not immune to this, either. There are almost no people who are willing to express a non-politically correct opinion, because they are deathly afraid of losing sponsorship.\n\nWe are the last bastion against crappy, sound-alike radio in Orange County. We are the voice of freedom for all the independent music that gets snubbed by the major labels. We are the defenders of the faith for those who choose to express a different opinion. We are Corporate Rock's worst nightmare. We are KUCI.\n\n*KUCI Programming Policies\n\n1. NO MAINSTREAM MUSIC... we will not tolerate playing mainstream music, and even then, they better not have been TOO famous. We are pioneers and once the world discovers what we've been up to all along, we move on to the next band that needs to be heard.\n\n2. Our talk shows examine subjects mainstream radio won't. Our hosts dig deep into subjects that are interesting but somehow not \"interesting\" enough to warrant being on a mainstream station. We encourage expression of all kinds and it shows in our diverse talk programming.\n\n*KUCI History\n\nConceived in 1968 by engineering student Craig Will and was later turned over to Earl Arbuckle, who became KUCI's first Chief Engineer. In October of 1969, KUCI received test authority from the Federal Communications Commission (FCC) and made its initial broadcast. \"Sugar Sugar\" by the Archies was the first song played. On November 25, 1969 KUCI was granted its official broadcast license, transmitting 10 watts of power at 89.9 FM.\n\nIn 1972 KUCI offered its first news broadcast, while in 1974 the station began broadcasting 24 hours a day. By 1978 KUCI had been host to some noteworthy guests, including Jackson Browne, Ray Bradbury, Howard Baker, Cesar Chavez, Blue Oyster Cult, The Beach Boys, and Monty Python's Flying Circus. In the spring of 1979, an article in Billboard Magazine mentioned that KUCI airs jazz programming.\n\nIn August of 1981 KUCI had managed its way out of a threatening situation. Public radio KCRW in Santa Monica filed with the FCC to increase its power. Approval from the FCC meant that KUCI could no longer be heard from some remote areas on campus, let alone beyond Irvine. Successful efforts on the part of Sue Simone, station Manager, enabled KUCI to move from its original frequency of 89.9 fm to its current frequency of 88.9 fm on August 20, 1981.\n\nBy 1984, trouble seemed to be lurking once again. Station manager Josh Bleier revealed that KXLU, at Loyola-Marymount University in Los Angeles and sharing KUCI's frequency, had intentions to move its antenna to a higher location, which would essentially wipe-out KUCI's signal. This was the first documentation for the necessity to increase the station's power to \"class A,\" or a minimum of 100 watts.\n\nThe autumn of 1986 marked the beginning of efforts to raise money to replace KUCI's dying transmitter. With the threat of it sending out its last radio waves, a campaign was initiated to raise $7,000 for a new solid-state transmitter. KUCI staged a concert at a Los Angeles Club, the Music Machine, as well as a Jazz/Fusion concert at the Coach House in San Juan Capistrano. After many months of hard work by the staff of KUCI and some lobbying by the station management, KUCI was able to replace its dying transmitter and continue broadcasting.\n\nSeptember 1991, the FCC granted approval for the station to increase its power to 200 watts stereo, allowing KUCI to broadcast to more of Orange County than ever before and securing its place on the dial for future generations. On Monday, March 15, 1993, KUCI began broadcasting as a 200-watt station, and calls were immediately received from Mission Viejo and Westminster, opening the door to a larger Orange County audience.\n\nKUCI takes pride in setting trends, and in 1996 the station became one of the first to broadcast its signal over the Internet, opening KUCI up to a worldwide potential listening audience. As KUCI enters a new decade and a new millennium, the focus of the staff will be to continue to discover innovative and underrepresented music and information and to bring it commercial-free to Orange County and the world.";
	
	self.textView.editable = NO;
	UIColor *color = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Check.png"]];
	self.view.backgroundColor = color;
	[color release];
	[self.view sizeToFit];
	
	CGRect frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
	activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:frame];
	
	[activityIndicator sizeToFit];
	activityIndicator.autoresizingMask =(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin);
	
	UIBarButtonItem *loadingView = [[UIBarButtonItem alloc]initWithCustomView:activityIndicator];
	[activityIndicator initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	loadingView.target = self;
	self.navigationItem.rightBarButtonItem = loadingView;
	activityIndicator.hidden = YES;
}

-(IBAction) launchRadio:(id)sender {
	if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
		//show an alert to let the user know that they can't connect...
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status" 
														message:@"Sorry, the network is not available.\nPlease try again later." 
													   delegate:self 
											  cancelButtonTitle:nil 
											  otherButtonTitles:@"OK", nil];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[alert show];
		[alert release];
		return;
	}
	activityIndicator.hidden = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[selectedSound play];
	[activityIndicator startAnimating];
	[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(movement) userInfo:nil repeats:NO];
	NSURL *url = [NSURL URLWithString:@"http://streamer.kuci.org:8000/"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[webview loadRequest:request];
}

- (void) movement 
{
	[activityIndicator stopAnimating];
	activityIndicator.hidden = YES;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //NSLog(@"ORIENTATION CHANGED");
}

- (void)dealloc 
{
	activityIndicator = nil;
	[activityIndicator release];
	selectedSound = nil;
	[selectedSound release];
	self.textView = nil;
	[textView release];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self.webview release];
	webview = nil;
    [super dealloc];
}


@end
