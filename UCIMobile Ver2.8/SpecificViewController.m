//
//  SpecificViewController.m
//  MyUCI
//
//  Created by Yoon Lee on 4/29/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import "SpecificViewController.h"
#import "ASIFormDataRequest.h"
#import "TFHpple.h"
#import "ClassLoader.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"

@implementation SpecificViewController
@synthesize _name, _major, _level, _Fmajor, _Flevel, _majorEXT,_nameEXT, _sendMe;
@synthesize savesObject, managedContext, nameTagCell, contactTagCell;
@synthesize personMajor, person, personID, emailPersonal;
@synthesize _pTitle, hpaddress, identify;
@synthesize _webpie, _directHP, setter;

@synthesize imageobject, imageobject1, imageobject2, urlToImage;
#pragma mark -
#pragma mark View lifecycle


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
	self.tableView.sectionHeaderHeight = 30.0;
	self.tableView.sectionFooterHeight = 40.0;
	self.title = @"Personal Info";
	UIBarButtonItem *home = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStylePlain target:self action:nil];
	self.navigationItem.backBarButtonItem = home;
	[home release];
	
	self.tableView.backgroundColor = [UIColor grayColor];

	[self hasPersonalWebpage];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
    return (section==1)?1:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	return indexPath.section==0?200.0:60.0;
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
    static NSString *PersonalContact = @"PersonalCard";
    static NSString *ContactInformation = @"Contact";
    nameTagCell = [tableView dequeueReusableCellWithIdentifier:PersonalContact];
    contactTagCell = [tableView dequeueReusableCellWithIdentifier:ContactInformation];
	
	UITableViewCell *cell = nil;
	
	switch (indexPath.section) 
	{
		case 0:
			if (!nameTagCell) 
			{
				nameTagCell = [[UITableViewCell alloc] init];
				[[NSBundle mainBundle] loadNibNamed:@"DisplayCard" owner:self options:nil];
			}
			nameTagCell.selectionStyle = UITableViewCellSelectionStyleNone;
			nameTagCell.backgroundColor = [UIColor lightGrayColor];
			cell = nameTagCell;
			_name.numberOfLines = 0;
			
			_name.text = person;
			
			identify.text = [NSString stringWithFormat:@"'%@'",[personID lowercaseString]];
			
			_major.text = personMajor;
			
			_level.text = _pTitle;
			if (hasHP) 
			{
				_webpie.hidden = NO;
				_directHP.hidden = NO;
			}
			else 
			{
				_webpie.hidden = YES;
				_directHP.hidden = YES;
			}
			//if person has image then
			//it show person's picture fetch out from the server
			if (self.urlToImage) 
			{
				NSURL *givenURL = [NSURL URLWithString:self.urlToImage];
				NSData *downloaded = [NSData dataWithContentsOfURL:givenURL];
				UIImage *imageToDiplay = [[UIImage alloc] initWithData:downloaded];
				imageobject2.layer.cornerRadius = 10.0;
				imageobject2.alpha = .8;
				imageobject2.layer.masksToBounds = YES;
				imageobject2.image = imageToDiplay;	
				[imageToDiplay release];
				imageobject.hidden = YES;
				imageobject1.hidden = YES;
			}
			
			
			break;
		case 1:
			if (!contactTagCell) 
			{
				contactTagCell = [[UITableViewCell alloc] init];
				[[NSBundle mainBundle] loadNibNamed:@"DisplayCard" owner:self options:nil];
			}
			self.tableView.rowHeight = 60.0;
			contactTagCell.backgroundColor = [UIColor lightGrayColor];
			
			cell = contactTagCell;
			
			_sendMe.text = @"Email me";
			
			break;
	}
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	switch (indexPath.section) 
	{
		case 0:
			break;
		case 1:
			[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
			self.navigationItem.hidesBackButton = YES;
			if (!self.emailPersonal) 
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:[NSString stringWithFormat:@"A person %@ email account not existing", person] delegate:nil cancelButtonTitle:@"Confirm" otherButtonTitles:nil];
				[alert show];
				[alert release];
				self.navigationItem.hidesBackButton = NO;
			}
			else 
			{
				[self sendEmailToUs];
			}
			break;
	}
}

- (void)viewDidUnload 
{
	_name = nil;
	_major = nil;
	_level = nil;
	_Fmajor = nil;
	_Flevel = nil;
	_majorEXT = nil;
	_nameEXT = nil;
	_sendMe = nil;
	savesObject = nil;
	managedContext = nil;
	nameTagCell = nil;
	contactTagCell = nil;
	_pTitle = nil;
	hpaddress = nil;
	_webpie = nil;
	_directHP = nil;
}

- (BOOL) hasPersonalWebpage 
{
	hasHP = NO;
	self.urlToImage = nil;
	//conversion for the html that when the keywords requested,
	//if any empty space require to replace with '+' mark instead.
	
	NSURL *url = [NSURL URLWithString:@"http://directory.uci.edu/index.php?form_type=advanced_search"];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:self.personID forKey:@"form_ucinetid"];
	[request setPostValue:@"exact" forKey:@"form_ucinetid_filter"];
	[request setPostValue:@"Search" forKey:@"advanced_submit"];
	[request startSynchronous];
	
	NSData *dataIndividual = [request responseData];
	TFHppleElement *element = nil;
	TFHpple *apple = [[[TFHpple alloc] initWithHTMLData:dataIndividual] autorelease];
	NSArray *professor = [apple search:@"//tr[1]/td[2]/span"];
	NSArray *homepage = [apple search:@"//div[2]/a"];
	NSArray *images = [apple search:@"//img"];
	self.emailPersonal = nil;
	//READING HAS TWO PHASES
	//ONE DECODE1, TWO DECODE2
	//PHASE 1: GET THE CODE FROM SERVER (DECODE1)
	//PHASE 2: GET THE CODE FROM SERVER (DECODE2)
	//TO DO CASE WHAT IF PEOPLE DON'T HAVE THEIR EMAIL??
	NSString *entirePage = [request responseString];
	NSScanner *scanemail = [NSScanner scannerWithString:entirePage];
	
	NSString *existence = nil;
	
	[scanemail scanUpToString:@"document.write" intoString:nil];
	[scanemail scanUpToString:@"('" intoString:&existence];
	
	if (!existence) 
	{
		//NSLog(@"NO EMAIL FOUND");
	}
	else 
	{
		//Debuging purpose
		NSString *compile = @"";
		[scanemail scanUpToString:@");" intoString:&compile];
		
		scanemail = [NSScanner scannerWithString:compile];
		NSString *decodeStr1 = @"";
		NSCharacterSet *toBeSkiped = [NSCharacterSet characterSetWithCharactersInString: @"'"];
		
		[scanemail scanUpToString:@"('" intoString:nil];
		[scanemail scanUpToCharactersFromSet:toBeSkiped intoString:nil];
		[scanemail setCharactersToBeSkipped:toBeSkiped];
		[scanemail scanUpToString:@"'," intoString:&decodeStr1];
		
		NSString *decodeStr2 = @"";
		
		scanemail = [NSScanner scannerWithString:entirePage];
		//NSLog(@"\nDECODE1: %@", decodeStr1);
		[scanemail scanUpToString:@"var tpyrcne = '" intoString:nil];
		[scanemail scanUpToString:@"var fixed" intoString:&decodeStr2];
		//NSLog(@"\nDECODE2: %@", decodeStr2);
		
		decodeStr2 = [decodeStr2 substringFromIndex:15];
		decodeStr2 = [decodeStr2 substringToIndex:decodeStr2.length - 7];
		
		self.emailPersonal = [self asciiMater:[self conversion:decodeStr1 withDecode:decodeStr2 withState:1]];
	}
	//BELOW HAS DOWNLOAD PERSONAL IMAGES AND CHECKING STATUS OF
	//PERSON CONTAINING HOMEPAGE OR NOT.
	TFHppleElement *imgElement = nil;
	
	if ([images count]>3) 
	{
		imgElement = [images objectAtIndex:3];
		self.urlToImage = [[imgElement attributes] objectForKey:@"src"];
	}
	
	if ([homepage count]>3) 
	{
		element = [homepage objectAtIndex:3];
		self.hpaddress = [element content];
		NSString *searchForMe = @"Update";
		NSRange range = [[element content] rangeOfString : searchForMe];
		
		if (range.location != NSNotFound) 
		{
			hasHP = NO;
		}
		else 
		{
			hasHP = YES;
		}
	}
	
	//level or vitae of people
	if ([professor count]>0) 
	{
		element = [professor objectAtIndex:0];
		self._pTitle = [element content];
	}
	
	else 
	{
		
		professor = [apple search:@"//p[3]/span[2]"];
		if ([professor count]==0) 
		{
			self._pTitle = @"N/A";
			return YES;
		}
		element = [professor objectAtIndex:0];
		
		self._pTitle = [element content];
		if ([(NSString *)[element content] isEqualToString:@"SR"]) 
		{
			self._pTitle = @"Senior";
		}
		else if([(NSString *)[element content] isEqualToString:@"JR"]) 
		{
			self._pTitle = @"Junior";
		}
		else if([(NSString *)[element content] isEqualToString:@"SO"]) 
		{
			self._pTitle = @"Sophomore";
		}
		else if([(NSString *)[element content] isEqualToString:@"FR"]) 
		{
			self._pTitle = @"Freshmen";
		}
	}
	
	element = nil;
	return YES;
}

- (IBAction) openWebPage 
{
	self.navigationItem.hidesBackButton = YES;
	ClassLoader *hpPage = [[ClassLoader alloc] initWithNibName:@"ClassLoader" bundle:nil];
	hpPage.link = self.hpaddress;
	hpPage.name = self.person;
	[self.navigationController pushViewController:hpPage animated:YES];
	[hpPage release];
	self.navigationItem.hidesBackButton = NO;
}

- (NSString *) conversion:(NSString *)str withDecode:(NSString *)tpyrcne withState:(NSInteger)mt
{
	
	if ([str isEqualToString:@"&nbsp;"]) 
	{
		return @"&nbsp";
	}
	NSString *fixed = @"&#;0987654321";
	NSString *decoded = @"";
	
	for (int i=0; i<str.length; i++) 
	{
		
		NSRange range = [fixed rangeOfString:[NSString stringWithFormat:@"%c", [str characterAtIndex:i]]];
		NSString *s = [NSString stringWithFormat:@"%d",range.location];
		int index = [s intValue];
		NSString *data = [NSString stringWithFormat:@"%c", [tpyrcne characterAtIndex:index]];
		
		decoded = [decoded stringByAppendingString:data];
	}
	
	if (mt) 
	{
		//the address meant to be giving user to give hyper address.
		//but since we don't need that.
		return decoded;
	}
	else 
	{
		return decoded;
	}
}

- (NSString *) asciiMater:(NSString *)decode 
{
	NSArray *seperator = [decode componentsSeparatedByString:@"&#"];
	NSString *email = @"";
	for (int i=0; i<[seperator count]; i++) 
	{
		char c = [(NSString *)[seperator objectAtIndex:i] intValue];
		email = [email stringByAppendingString:[NSString stringWithFormat:@"%c", c]];
	}
	
	return email;
}

- (void) sendEmailToUs 
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	NSArray *toRecipients = [NSArray arrayWithObject:self.emailPersonal];
	[picker setToRecipients:toRecipients];
	
	// Fill out the email body text
	NSString *emailBody = [NSString stringWithFormat:@"Dear %@\n\n\nSincerely, ", person];
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

//delegates from MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{	
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
			alert.title = @"Message failed to send.";
			[alert show];
			break;
	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[alert release];
	[self dismissModalViewControllerAnimated:YES];
	self.navigationItem.hidesBackButton = NO;
}

- (void)dealloc {
	setter.isClicked = NO;
	[setter release];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self.emailPersonal release];
	[_name release];
	[_major release];
	[_level release];
	[_Fmajor release];
	[_Flevel release];
	[_majorEXT release];
	[_nameEXT release];
	[_sendMe release];
	[savesObject release];
	[nameTagCell release];
	[contactTagCell release];
	[_pTitle release];
	[hpaddress release];
	[_webpie release];
	[_directHP release];
	
	[imageobject release];
	[imageobject1 release];
	[imageobject2 release];
	imageobject = nil;
	imageobject1 = nil;
	imageobject2 = nil;
	[super dealloc];
}

@end

