//
//  RosterController.m
//  Smile
//
//  Created by Evgeniy Shurakov on 23.05.09.
//  Copyright Evgeniy Shurakov 2009. All rights reserved.
//

#import "RosterController.h"
#import <QuartzCore/QuartzCore.h>
#import "XMPPClient.h"
#import "XMPPJID.h"
#import "XMPPUser.h"
#import "XMPPMessage.h"
#import "SettingsController.h"
#import "ChatViewController.h"
#import "SFHFKeychainUtils.h"
#import "Message.h"
#import "NSXMLElementAdditions.h"r

@implementation RosterController
@synthesize managedObjectContext;
@synthesize roster;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
		allRecieved = [[NSMutableDictionary alloc] init];
		NSBundle *mainBundle = [NSBundle mainBundle];
		selectedSound =  [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"pling" ofType:@"wav"]];
        // Custom initialization
		self.title = @"Buddy Chat";
		xmppClient = [[XMPPClient alloc] init];
		[xmppClient addDelegate: self];
		[xmppClient setAutoRoster: YES];
		[xmppClient setAutoPresence: YES];
		
		chatModels = [[NSMutableDictionary alloc] initWithCapacity:3];
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Connect" 
																				   style:UIBarButtonItemStylePlain 
																				  target:self
																				  action:@selector(toggleConnect:)] 
												  autorelease];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Setup" 
																				  style:UIBarButtonItemStylePlain 
																				 target:self
																				 action:@selector(setting:)] 
												 autorelease];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
	if (roster==nil||roster.count==0) 
	{
		[self notification:@"Configure account profile first."];
	}
}
- (void)setting:(id)sender
{
	for (UIView *view in self.navigationController.view.subviews) 
	{
		if ([view isKindOfClass:UINavigationBar.class]&&view.tag==777) 
		{
			[view removeFromSuperview];
		}
	}
	SettingsController *sc = [[SettingsController alloc] init];
	sc.managedObjectContext = self.managedObjectContext;
	[self.navigationController pushViewController:sc animated:YES];
	[sc release];
}

- (void)toggleConnect:(id)sender
{
	if (![xmppClient isAuthenticated])
	{
		for (UIView *view in self.navigationController.view.subviews) 
		{
			if ([view isKindOfClass:UINavigationBar.class]&&view.tag==777) 
			{
				[view removeFromSuperview];
			}
		}
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		self.title = @"Connecting...";
		NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
		
		NSString *login = [ud stringForKey:@"login"];
		
		NSError *error;
		NSString *password = [SFHFKeychainUtils getPasswordForUsername:@"default" andServiceName:@"Smile" error:&error];
		
		if ([login length] && [password length])
		{
			XMPPJID *jid = [XMPPJID jidWithString:login];
			[xmppClient setMyJID:jid];
			[xmppClient setPassword:password];
			
			if ([[jid domain] isEqualToString:@"gmail.com"]) 
			{
				[xmppClient setDomain:@"talk.google.com"];
			}
			// http://www.facebook.com/sitetour/chat.php
			// account->account setting->setting->username
			else if ([[jid domain] isEqualToString:@"chat.facebook.com"])
			{
				[xmppClient setDomain:@"chat.facebook.com"];
			}
			else if ([[jid domain] isEqualToString:@"uci.edu"])
			{
				[xmppClient setDomain:@"chat.nacs.uci.edu"];
			}
			else
			{
				[self notification:@"Not enrolled jabber server."];
				[self.tableView reloadData];
				return;
			}
			
			
			[xmppClient setAllowsSSLHostNameMismatch: YES];
			[xmppClient connect];
			
			[self.navigationItem.rightBarButtonItem setEnabled:NO];
		}
		else
		{
			[self notification:@"id and password needed."];
			[self.tableView reloadData];
		}
	}
	else
	{
		[xmppClient disconnect];
		[self.navigationItem.rightBarButtonItem setEnabled:NO];
	}
}

- (void)xmppClientDidDisconnect:(XMPPClient *)sender
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self.navigationItem.rightBarButtonItem setEnabled:YES];
	[self.navigationItem.rightBarButtonItem setTitle:@"Connect"];
	NSString *status;
	
	if ([sender streamError])
	{
		status = @"Lost internet connection.";
	}
	else
	{
		status = @"Disconnected. Return to main menu?";
	}
	
	[self notification:status];
	[self.tableView reloadData];
}

- (void)xmppClientDidNotConnect:(XMPPClient *)sender
{
	[self.navigationItem.rightBarButtonItem setEnabled:YES];
	
	//NSLog(@"---------- xmppClientDidNotConnect ----------");
	if([sender streamError])
	{
		NSLog(@"           error: %@", [sender streamError]);
	}
}

- (void)xmppClient:(XMPPClient *)sender didNotAuthenticate:(NSXMLElement *)error
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[xmppClient disconnect];
	
	[self notification:@"Failed authenticate."];
	[self.tableView reloadData];
}

- (void)xmppClientDidAuthenticate:(XMPPClient *)sender
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self.navigationItem.rightBarButtonItem setEnabled:YES];
	[self.navigationItem.rightBarButtonItem setTitle:@"Disconnect"];
	self.title = @"Buddy Chat";
}

- (void)xmppClientDidUpdateRoster:(XMPPClient *)sender
{
	self.roster = [sender sortedAvailableUsersByName];
	
	[self.tableView reloadData];	
}

- (void)xmppClient:(XMPPClient *)sender didReceiveBuddyRequest:(XMPPJID *)jid
{
	[sender addBuddy:jid withNickname:nil];
}

- (void)xmppClient:(XMPPClient *)sender didReceiveMessage:(XMPPMessage *)message
{
	NSString *messageStr = [[message elementForName:@"body"] stringValue];
	
	if (messageStr) 
	{
		BOOL inOtherViewController = NO;
		XMPPJID *msgJID = [message from];
		NSMutableArray *recvSenderMSGs = [allRecieved objectForKey:msgJID];
		Message *msg = [[Message alloc] init];
		msg.text = messageStr;
		
		time_t now; 
		time(&now);
		
		msg.timestamp = now;
		
		if (!recvSenderMSGs) 
		{
			recvSenderMSGs = [[[NSMutableArray alloc] init] autorelease];
		}
		
		[recvSenderMSGs addObject:msg];
		[allRecieved setObject:recvSenderMSGs forKey:msgJID];
		
		// if current view is not roster screen
		for (UIViewController *viewControl in [self.navigationController viewControllers])
		{
			if ([viewControl isKindOfClass:ChatViewController.class]) 
			{
				if ([[(ChatViewController *)viewControl opJID].user isEqualToString:msgJID.user]) 
				{
					[(ChatViewController *)viewControl newMSGs:msg];
				}
				inOtherViewController = YES;
			}
		}
		
		if (!inOtherViewController) 
		{
			[selectedSound play];
		}
		
		[self.tableView reloadData];
		[msg release];
	}
}


#
# pragma mark Table view methods
#

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [roster count];
}

// Display customization

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	XMPPUser *user = [roster objectAtIndex:indexPath.row];
	NSMutableArray *msgs = [allRecieved objectForKey:user.jid];
	cell.accessoryView = nil;
	
	if (msgs!=nil&&[msgs count]>0) 
	{
		int unreadMSGs = 0;
		
		for (Message *msg in msgs) 
		{
			if (msg.isNew) 
			{
				unreadMSGs ++;
			}
		}
		
		if (unreadMSGs!=0) 
		{
			UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notice.png"]] autorelease];
			cell.accessoryView = imageView;
			cell.accessoryView.backgroundColor = [UIColor clearColor];
			UILabel *emblem = [[[UILabel alloc] initWithFrame:CGRectMake(4, 0, 15, 15)] autorelease];
			emblem.backgroundColor = [UIColor clearColor];
			emblem.textColor = [UIColor whiteColor];
			emblem.textAlignment = UITextAlignmentCenter;
			emblem.font = [UIFont systemFontOfSize:9];
			emblem.text = [NSString stringWithFormat:@"%d", unreadMSGs];
			[cell.accessoryView addSubview:emblem];
			
		}
	}
	
	cell.imageView.image = nil;
	
	if (user.portrait) 
	{
		cell.imageView.image = user.portrait;
		cell.imageView.layer.cornerRadius = 8.0;
		cell.imageView.layer.borderWidth = 1.0;
		cell.imageView.layer.borderColor = [[UIColor blackColor] CGColor];
		cell.imageView.layer.masksToBounds = YES;
		cell.imageView.layer.opaque = NO;
		cell.textLabel.textColor = [UIColor blackColor];
	}
	cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	XMPPUser *user = [roster objectAtIndex:indexPath.row];
	
	cell.textLabel.text = user.displayName;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	XMPPUser *user = [roster objectAtIndex:indexPath.row];
	NSMutableArray *msgs = [allRecieved objectForKey:user.jid];
	ChatViewController *chatView = [[ChatViewController alloc] initWithXmppClient:xmppClient andOpponentChat:msgs andJid:user.jid];
	[self.navigationController pushViewController:chatView animated:YES];
	chatView.title = user.displayName;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	cell.accessoryView = nil;
	[chatView release];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
	//NSLog(@"%f At the top", scrollView.contentOffset.y);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50.0;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)kills:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)notification:(NSString *)msg
{
	UINavigationBar *smallBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 450, 320, 30)];
	UILabel *script = [[UILabel alloc] initWithFrame:CGRectMake(15, 6, 280, 15)];
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"return" style:UIBarButtonItemStyleBordered target:self action:@selector(kills:)];
	UINavigationItem *navItem = [[UINavigationItem alloc] init];
	
	navItem.rightBarButtonItem = button;
	[smallBar addSubview:script];
	smallBar.backgroundColor = [UIColor clearColor];
	smallBar.barStyle = UIBarStyleBlackTranslucent;
	[smallBar pushNavigationItem:navItem animated:YES];
	
	script.text = msg;
	script.font = [UIFont systemFontOfSize:12];
	script.textColor = [UIColor whiteColor];
	script.backgroundColor = [UIColor clearColor];
	smallBar.tag = 777;
	[self.navigationController.view addSubview:smallBar];
	[button release];
	[navItem release];
	[script release];
	[smallBar release];
	self.title = @"Buddy Chat";
	self.roster = nil;
}

- (void)viewDidUnload 
{
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"ORIENTATION CHANGED");
}

- (void)dealloc
{
	[selectedSound release];
	[allRecieved release];
	[chatModels release];
	[xmppClient removeDelegate: self];
	[xmppClient release];
    [super dealloc];
}


@end
