//
//  TroubleShoot.m
//  UCIMobile
//
//  Created by Yoon Lee on 9/13/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "TroubleShoot.h"
#import <QuartzCore/QuartzCore.h>


@implementation TroubleShoot
@synthesize textView;
@synthesize label1;
@synthesize label2;

- (void)viewDidLoad 
{
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
	toolbar.tintColor = [UIColor blackColor];
	toolbar.alpha = .65;
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeThatCrab:)];
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:15];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.text = @"Login Trouble Issue";
	titleLabel.textAlignment = UITextAlignmentCenter;
	UIBarButtonItem *label = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
	
    toolbar.items = [NSArray arrayWithObjects:done, label, nil];
	
	[self.view addSubview:toolbar];
	[toolbar release];
	[label release];
	[titleLabel release];
	[done release];
	
	self.textView.font = [UIFont fontWithName:@"Georgia" size:13];
	self.textView.layer.borderColor = [RGB(108, 153, 221) CGColor];
	self.textView.layer.borderWidth = 3.0;
	self.textView.layer.cornerRadius = 3.0;
	label1.textColor = [UIColor whiteColor];
	
	self.view.backgroundColor = [UIColor blackColor];
	
	[super viewDidLoad];
}

- (void) closeThatCrab:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (IBAction) sendEmail:(id)sender

{	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	NSArray *toRecipients = [NSArray arrayWithObject:@"UCIMobile@gmail.com"];
	[picker setToRecipients:toRecipients];
	
	// Fill out the email body text
	NSString *emailBody = [NSString stringWithFormat:@"Dear %@\n\n\nSincerely, ", @"Developer"];
	[picker setMessageBody:emailBody isHTML:NO];
	picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

//delegates from MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	// Notifies users about errors associated with the interface
	UIAlertView *alert = [[UIAlertView alloc]init];
	[alert addButtonWithTitle:@"Confirm"];
	
	switch (result)
	{
		case MFMailComposeResultSaved:
			alert.title = @"Message has been saved.";
			[alert show];
			break;
		case MFMailComposeResultSent:
			alert.title = @"Message has been sent.";
			[alert show];
			break;
		case MFMailComposeResultFailed:
			alert.title = @"Message has failed to send.";
			[alert show];
			break;
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[alert release];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc 
{
	[textView release];
	[label1 release];
	[label2 release];
    [super dealloc];
}


@end
