//
//  LoginViewController.m
//  UCI
//
//  Created by Yoon Lee on 2/21/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "FinalInfo.h"
#import "UCIAppController.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "TroubleShoot.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation LoginViewController
@synthesize managedObjectContext, userInfo;
@synthesize ucidnetId, password, status, statusBar, parse;
@synthesize a, didLogin, imageView, disclaimer, log;

- (void)viewDidLoad 
{
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 180, 30)];
	label1.text = @"UCI Secure Web Login";
	label1.textAlignment = UITextAlignmentLeft;
	label1.textColor = [UIColor whiteColor];
	label1.font = [UIFont boldSystemFontOfSize:14];
	label1.backgroundColor = [UIColor clearColor];
	label1.tag = 1;
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 200, 30)];
	label2.text = @"Can't login? Click troubleshoot";
	label2.textAlignment = UITextAlignmentLeft;
	label2.textColor = [UIColor whiteColor];
	label2.font = [UIFont fontWithName:@"Georgia" size:12];
	label2.backgroundColor = [UIColor clearColor];
	label2.tag = 2;
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
	[imgView addSubview:label2];
	[imgView addSubview:label1];
	self.navigationItem.titleView = imgView;
	[imgView release];
	[label1 release];
	[label2 release];
	
	[self load];
	parse = [[ParseURL alloc] init];
	parse.context = self.managedObjectContext;
	self.title = @"Secure Login";
	UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
	self.navigationItem.rightBarButtonItem = clear;
	self.imageView.layer.cornerRadius = 10.0;
	self.imageView.layer.borderWidth = 3.0;
	self.imageView.layer.borderColor = [RGB(176,198,227) CGColor];
	self.log.layer.borderColor = [RGB(176,198,227) CGColor];
	self.log.layer.cornerRadius = 5.0;
	self.log.layer.borderWidth = 3.0;
	self.imageView.alpha = .90;
	[clear release];
	UIBarButtonItem *home = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:nil];
	self.navigationItem.backBarButtonItem = home;
	[home release];
	disclaimer.layer.cornerRadius = 10.0;
	disclaimer.editable = NO;
	self.disclaimer.layer.borderWidth = 3.0;
	self.disclaimer.layer.borderColor = [[UIColor whiteColor] CGColor];
	self.disclaimer.font = [UIFont systemFontOfSize:12];
	disclaimer.text = @"\nPrivacy Note: UCI Mobile does NOT store your information on anything except UCI servers. The phone uses proper WebAuth; therefore if you log in on your phone, it will clear your information if you have it stored on your PC. Please keep in mind to log out and clear information at the log in screen should you let someone else borrow your device.";
}

- (void) clear 
{
	UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Notice"];
	[alert setMessage:@"User information will be removed."];
	[alert addButtonWithTitle:@"OK"];
	[alert addButtonWithTitle:@"Cancel"];
	[alert setDelegate:self];
	[alert show];
	[alert release];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	
	switch (buttonIndex) 
	{
			//OK button from UIAlert
		case 0:
			ucidnetId.text = @"";
			password.text = @"";
			[self remove];
			[a setYouYES:NO];
			[parse loadCourseContents:YES];
			[parse loadCourseContents:NO];
			break;
		case 1:
			[alertView dismissWithClickedButtonIndex:1 animated:YES];
			break;
	}
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (IBAction)loginRequest:(id)sender
{	
	self.navigationItem.hidesBackButton = YES;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[status setHidden: YES];
	[statusBar setHidden: NO];
	[statusBar startAnimating];
	
	for (UIView* viewed in self.view.subviews)
	{
		if ([viewed isKindOfClass:[UIView class]])
		{
			[viewed resignFirstResponder];
		}
	}
	//많약 테스트필드의 아이디가 바뀌게 되면,
	//이용자가 바뀐걸로 감지함.
	[self remove];
	[self addwithNetID:self.ucidnetId.text andPasswd:self.password.text];
	
	if(![[ucidnetId text] isEqualToString:@""])	
	{
		if(![[password text] isEqualToString:@""]) 
		{
			[statusBar startAnimating];
			[parse setUrl_auth:[NSURL URLWithString:@"https://login.uci.edu/ucinetid/webauth"]];
			[parse setUrl_list:[NSURL URLWithString:@"http://www.reg.uci.edu/access/student/studylist/?seg=U"]];
			[parse setUCINetid:[ucidnetId text]];
			[parse setPasswd:[password text]];
			//Now start
			
			if([parse requestToLogin]) 
			{
				if(![parse mainParser]) 
				{
					[status setTextColor:[UIColor yellowColor]];
					[status setText:@"Student credentials invalid."];
					ucidnetId.text = @"";
					password.text = @"";
					[self remove];
					[a setYouYES:NO];
					[parse loadCourseContents:YES];
					[parse loadCourseContents:NO];
					
					[status setHidden: NO];
					[statusBar setHidden: YES];
					[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
					self.navigationItem.hidesBackButton = NO;
					return;
				}
			}
			else 
			{
				[status setTextColor:[UIColor yellowColor]];
				[status setText:@"Internet connection is not available."];
				[status setHidden: NO];
				[statusBar setHidden: YES];
				[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
				self.navigationItem.hidesBackButton = NO;
				return;
			}
			//relate to logout button -_-
			[a setYouYES:YES];
			[statusBar stopAnimating];
			[statusBar setHidden: YES];
			[self.navigationController popViewControllerAnimated:YES];
		}
		else 
		{
			[status setTextColor:[UIColor yellowColor]];
			[status setText:@"Please insert password."];
			[status setHidden: NO];
			[statusBar setHidden: YES];
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			self.navigationItem.hidesBackButton = NO;
			return;
		}
		
	}
	else 
	{
		[status setTextColor:[UIColor yellowColor]];
		[status setText:@"Please insert id and password."];
		[status setHidden: NO];
		[statusBar setHidden: YES];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		self.navigationItem.hidesBackButton = NO;
		return;
	}
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	self.navigationItem.hidesBackButton = NO;
}


- (IBAction) keyboardEnterDone:(id)sender 
{
	self.navigationItem.backBarButtonItem.enabled = YES;
	[sender resignFirstResponder];
}

- (IBAction) textFieldEntered 
{
	
	if (self.ucidnetId.editing||self.password.editing) 
	{
		self.navigationItem.backBarButtonItem.enabled = NO;
	
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{

	for (UIView* viewed in self.view.subviews) 
	{
		if (![viewed isKindOfClass:[UIImageView class]])
		{
			[viewed resignFirstResponder];
			self.navigationItem.backBarButtonItem.enabled = YES;
		}
	}

}

- (void) addwithNetID:(NSString *)netID andPasswd:(NSString *)passwd
{
	//현제 하나밖에 안쓸거이기 때문에...
	//로드를 해노쿠... (그래야 로드하면서 배열 숫자가 잡힘.)
	//로드하는 숫자가 1이상이 아닐때만...애드 가능하도록 
	//모이런 심플한 메커니즘...
	if(self.load <1) {
		//if something was wrong then don't save it.
		if ([netID isEqualToString:@""]||[passwd isEqualToString:@""]) 
		{
			return;
		}
		if(!userInfo)
		{
			userInfo = [[NSMutableArray alloc] init];
		}
		User *u = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedObjectContext];
		
		u.netID = netID;
		u.password = passwd;
		
		NSError *error;
		if([managedObjectContext save:&error]) 
		{
			
		}
		[userInfo insertObject:u atIndex:0];
	}
}

- (void) remove 
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext];
	request.entity = entity;
	NSError *error;
	NSMutableArray *results = [[managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
	User *u = nil;
	if([results count] > 0)
	{
		u = (User *)[userInfo objectAtIndex:0];
		if(![self.ucidnetId.text isEqualToString:u.netID]) 
		{
			[managedObjectContext deleteObject:[userInfo objectAtIndex:0]];
			[managedObjectContext save:&error];
		}
	}
	[results release];
	[request release];
}

- (int) load
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext];
	request.entity = entity;
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	[self setUserInfo:mutableFetchResults];
	[request release];
	[mutableFetchResults release];
	User *u = nil;
	if([userInfo count] > 0) 
	{
		u = (User *)[userInfo objectAtIndex:0];
		[self.ucidnetId setText:u.netID];
		[self.password setText:u.password];
	}
	return [userInfo count];
}

- (void)viewDidUnload 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	ucidnetId = nil;
	password = nil;
	status = nil;
	statusBar = nil;
	parse = nil;
	
}

- (IBAction) troubleShooting:(id)sender
{
	TroubleShoot *troubleShoot = [[TroubleShoot alloc] initWithNibName:@"TroubleShoot" bundle:nil];

	troubleShoot.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:troubleShoot animated:YES];
	[troubleShoot release];
}

- (void)dealloc 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[disclaimer release];
	disclaimer = nil;
	[parse release];
	[a release];
	[super dealloc];
	
}


@end
