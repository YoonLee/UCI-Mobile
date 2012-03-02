//
//  SplashUCI.m
//  MyUCI
//
//  Created by Yoon Lee on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SplashUCI.h"
//#import "InputGen.h"

@implementation SplashUCI


@synthesize imageview;
@synthesize delegate;

- (void)viewDidLoad 
{
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

//	InputGen *gen = [[InputGen alloc] initWithContext:managedObjectContext];
//	[gen setSchedule];
//	[gen release];
    
    [self.delegate didTriggerHasBeenDone:NO withSplashViewController:nil];
	[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fadeScreen:) userInfo:nil repeats:NO];
}

- (void)fadeScreen:(id)sender
{
    [self.delegate didTriggerHasBeenDone:NO withSplashViewController:nil];
	[UIView beginAnimations:nil context:nil]; // begins animation block
	[UIView setAnimationDuration:0.75];        // sets animation duration
	[UIView setAnimationDelegate:self];        // sets delegate for this block
	[UIView setAnimationDidStopSelector:@selector(finishedFading)];   // calls the finishedFading method when the animation is done (or done fading out)	
	self.view.alpha = 0.0;
	[UIView commitAnimations];
}

- (void) finishedFading
{
    [self.delegate didTriggerHasBeenDone:NO withSplashViewController:nil];
	[UIView beginAnimations:nil context:nil]; // begins animation block
	[UIView setAnimationDuration:.75];        // sets animation duration
	self.view.alpha = 1.0;   // fades the view to 1.0 alpha over 0.75 seconds
	[UIView commitAnimations];   // commits the animation block.  This Block is done.
    
    [self.delegate didTriggerHasBeenDone:YES withSplashViewController:self];
}

- (void)dealloc 
{
	[imageview release];
	[super dealloc];
}


@end
