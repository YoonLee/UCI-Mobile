//
//  CreatorViewController.m
//  MyUCI
//
//  Created by Yoon Lee on 5/11/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import "CreatorViewController.h"
#import "Reachability.h"
#import "ClassLoader.h"

@implementation CreatorViewController
@synthesize _tableView, secondary;
@synthesize segment;

#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad 
{
	_tableView.backgroundColor = RGB(255, 255, 255);
	NSBundle *mainBundle = [NSBundle mainBundle];	
	selectedSound =  [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"noise" ofType:@"wav"]];
	[segment addTarget:self action:@selector(segmentChanges) forControlEvents:UIControlEventValueChanged];
	self.title = @"About UCI Mobile";
	self.secondary.titleView = segment;
	self.segment.selectedSegmentIndex = 0;
}

-(void) segmentChanges 
{
	
	[selectedSound play];
	if (segment.selectedSegmentIndex==0) 
	{
		self.secondary.prompt = @"Developer Profile";
	}
	else if(segment.selectedSegmentIndex==1) 
	{
		self.secondary.prompt = @"Contact Information";
	}
//	else {
//		self.secondary.prompt = @"Other References";
//	}
	
	[self._tableView reloadData];
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
    NSInteger retVar = 0;
	
	if (segment.selectedSegmentIndex==0) 
	{
		retVar = 17;
	}
	else if(segment.selectedSegmentIndex==1) 
	{
		retVar = 9;
	}
//	else {
//		retVar = 13;
//	}
	
	return retVar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat retVar = 0.0;
	if (segment.selectedSegmentIndex==0) 
	{
		switch (indexPath.row) 
		{
			case SECTION_NAME:
				retVar = 15.0;
				break;
			case ROW_REPRESENT_YOON:
				retVar = 10.0;
				break;
			case ROW_BOTTOM_YOON:
				retVar = 10.0;
				break;
			case ROW_REPRESENT_JUSTIN:
				retVar = 10.0;
				break;
			case ROW_BOTTOM_JUSTIN:
				retVar = 10.0;
				break;
			case ROW_REPRESENT_JOANNE:
				retVar = 10.0;
				break;
			case ROW_BOTTOM_JOANNE:
				retVar = 10.0;
				break;
			case 12:
				retVar = 3.0;
				break;
			case 13:
				retVar = 10.0;
				break;
			case 15:
				retVar = 10.0;
				break;
			case SECION_NAME_END:
				retVar = 15.0;
				break;
			case SEPARATESECTION1:
				retVar = 3.0;
				break;
			case SEPARATESECTION2:
				retVar = 3.0;
				break;
			default:
				retVar = 75.0;
				break;
		}
	}
	else if (segment.selectedSegmentIndex==1) 
	{
		switch (indexPath.row) 
		{
			case SECTION_CONTACT:
				retVar = 15.0;
				break;
			case ROW_REPRESENT_FEEDBACK:
				retVar = 10.0;
				break;
			case ROW_EMAIL_END:
				retVar = 10.0;
				break;
			case ROW_BLANK_FIRST:
				retVar = 3.0;
				break;
			case ROW_REPRESENT_FACEBOOK:
				retVar = 10.0;
				break;
			case ROW_FACEBOOK_END:
				retVar = 10.0;
				break;
			case SECTION_END:
				retVar = 15.0;
				break;
				
			default:
				retVar = 75.0;
				break;
		}
	}
//	else {
//		switch (indexPath.row) {
//			case SECTION_SPONSOR:
//				retVar = 15.0;
//				break;
//			case ROW_REPRESENT_UNICEF:
//				retVar = 10.0;
//				break;
//			case ROW_END_UNICEF:
//				retVar = 10.0;
//				break;
//			case ROW_EMPTY_LINE1:
//				retVar = 3.0;
//				break;
//			case ROW_REPRESENT_DOKDO:
//				retVar = 10.0;
//				break;
//			case ROW_END_DOKDO:
//				retVar = 10.0;
//				break;
//			case ROW_EMPTY_LINE2:
//				retVar = 3.0;
//				break;
//			case ROW_ADVERTISEPAGE_REPRESENT:
//				retVar = 10.0;
//				break;
//			case ROW_ADVERTISEPAGE_END:
//				retVar = 10.0;
//				break;
//			case SECTION_SPONSOR_END:
//				retVar = 15.0;
//				break;
//				
//			default:
//				retVar = 75.0;
//				break;
//		}
//	}
	
	
	return retVar;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	cell.textLabel.numberOfLines = 0;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryNone;
	//color pallet configure
	if (segment.selectedSegmentIndex==0) 
	{
		switch (indexPath.row) 
		{
			case SECTION_NAME:
				cell.backgroundColor = RGB(164, 198, 161);
				break;
			case ROW_REPRESENT_YOON:
				cell.backgroundColor = RGB(245, 245, 220);
				break;
			case ROW_BOTTOM_YOON:
				cell.backgroundColor = RGB(245, 245, 220);
				break;
			case ROW_REPRESENT_JUSTIN:
				cell.backgroundColor = RGB(245, 245, 220);
				break;
			case ROW_BOTTOM_JUSTIN:
				cell.backgroundColor = RGB(245, 245, 220);
				break;
			case ROW_REPRESENT_JOANNE:
				cell.backgroundColor = RGB(245, 245, 220);
				break;
			case ROW_BOTTOM_JOANNE:
				cell.backgroundColor = RGB(245, 245, 220);
				break;
			case 12:
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.backgroundColor = RGB(255, 255, 255);
				break;
			case 13:
				cell.backgroundColor = RGB(245, 245, 220);
				break;
			case 15:
				cell.backgroundColor = RGB(245, 245, 220);
				break;
			case SECION_NAME_END:
				cell.backgroundColor = RGB(164, 198, 161);
				break;
			case SEPARATESECTION1:
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.backgroundColor = RGB(255, 255, 255);
				break;
			case SEPARATESECTION2:
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.backgroundColor = RGB(255, 255, 255);
				break;
			default:
				cell.backgroundColor = RGB(255, 255, 255); 
				break;
		}
		
		switch (indexPath.row) 
		{
			case SECTION_NAME:
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.textLabel.textAlignment = UITextAlignmentCenter;
				cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				break;
			case SECION_NAME_END:
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.textLabel.textAlignment = UITextAlignmentRight;
				cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				break;
			case ROW_REPRESENT_YOON:
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.textLabel.textAlignment = UITextAlignmentLeft;
				cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:11.0];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				break;
			case ROW_REPRESENT_JUSTIN:
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.textLabel.textAlignment = UITextAlignmentLeft;
				cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:11.0];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				break;
			case ROW_REPRESENT_JOANNE:
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.textLabel.textAlignment = UITextAlignmentLeft;
				cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:11.0];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				break;
			case ROW_YOON:
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.textLabel.textAlignment = UITextAlignmentLeft;
				cell.textLabel.font = [UIFont boldSystemFontOfSize:11.0];
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
				break;
			case 13:
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.textLabel.textAlignment = UITextAlignmentLeft;
				cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:11.0];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				break;

			default:
				cell.textLabel.font = [UIFont boldSystemFontOfSize:11.0];
				cell.textLabel.textAlignment = UITextAlignmentLeft;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				break;
		}
	}
	else if (segment.selectedSegmentIndex==1) 
	{
		switch (indexPath.row) 
		{
			case SECTION_CONTACT:
				cell.backgroundColor = RGB(164, 198, 161);
				break;
			case ROW_REPRESENT_FEEDBACK:
				cell.backgroundColor = RGB(240, 255, 240);
				break;
			case ROW_EMAIL_END:
				cell.backgroundColor = RGB(240, 255, 240);
				break;
			case ROW_BLANK_FIRST:
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.backgroundColor = RGB(255, 255, 255);
				break;
			case ROW_REPRESENT_FACEBOOK:
				cell.backgroundColor = RGB(240, 255, 240);
				break;
			case ROW_FACEBOOK_END:
				cell.backgroundColor = RGB(240, 255, 240);
				break;
			case SECTION_END:
				cell.backgroundColor = RGB(164, 198, 161);
				break;
			default:
				cell.backgroundColor = RGB(255, 255, 255);
				break;
		}
		switch (indexPath.row)
		{
			case SECTION_CONTACT:
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.textLabel.textAlignment = UITextAlignmentCenter;
				cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0]; 
				break;
			case ROW_EMAIL:
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.textLabel.textAlignment = UITextAlignmentLeft;
				cell.textLabel.font = [UIFont boldSystemFontOfSize:11.0];
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
				break;
			case ROW_FACEBOOK:
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.textLabel.textAlignment = UITextAlignmentLeft;
				cell.textLabel.font = [UIFont boldSystemFontOfSize:11.0];
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
				break;

			case ROW_REPRESENT_FEEDBACK:
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.textLabel.textAlignment = UITextAlignmentLeft;
				cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:11.0];
				break;
			case ROW_REPRESENT_FACEBOOK:
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.textLabel.textAlignment = UITextAlignmentLeft;
				cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:11.0];
				break;
			case SECTION_END:
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.textLabel.textAlignment = UITextAlignmentRight;
				cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				break;
				
			default:
				break;
		}
	}
//	else {
//		switch (indexPath.row) {
//			case SECTION_SPONSOR:
//				cell.backgroundColor = RGB(164, 198, 161);
//				break;
//			case ROW_REPRESENT_UNICEF:
//				cell.backgroundColor = RGB(255, 228, 225);
//				break;
//			case ROW_END_UNICEF:
//				cell.backgroundColor = RGB(255, 228, 225);
//				break;
//			case ROW_REPRESENT_DOKDO:
//				cell.backgroundColor = RGB(255, 228, 225);
//				break;
//			case ROW_END_DOKDO:
//				cell.backgroundColor = RGB(255, 228, 225);
//				break;
//			case ROW_ADVERTISEPAGE_REPRESENT:
//				cell.backgroundColor = RGB(255, 228, 225);
//				break;
//			case ROW_ADVERTISEPAGE_END:
//				cell.backgroundColor = RGB(255, 228, 225);
//				break;
//			case SECTION_SPONSOR_END:
//				cell.backgroundColor = RGB(164, 198, 161);
//				break;
//			case ROW_EMPTY_LINE1:
//				cell.selectionStyle = UITableViewCellSelectionStyleNone;
//				cell.accessoryType = UITableViewCellAccessoryNone;
//				cell.backgroundColor = RGB(255, 255, 255);
//				break;
//			case ROW_EMPTY_LINE2:
//				cell.selectionStyle = UITableViewCellSelectionStyleNone;
//				cell.accessoryType = UITableViewCellAccessoryNone;
//				cell.backgroundColor = RGB(255, 255, 255);
//				break;
//				
//			default:
//				cell.backgroundColor = RGB(255, 255, 255); 
//				break;
//		}
//		//text setting
//		switch (indexPath.row) {
//			case SECTION_SPONSOR:
//				cell.selectionStyle = UITableViewCellSelectionStyleNone;
//				cell.accessoryType = UITableViewCellAccessoryNone;
//				cell.textLabel.textAlignment = UITextAlignmentCenter;
//				cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0];
//				break;
//			case ROW_REPRESENT_UNICEF:
//				cell.selectionStyle = UITableViewCellSelectionStyleNone;
//				cell.accessoryType = UITableViewCellAccessoryNone;
//				cell.textLabel.textAlignment = UITextAlignmentLeft;
//				cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:11.0];
//				break;
//			case ROW_UNICEF:
//				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//				cell.textLabel.font = [UIFont boldSystemFontOfSize:11.0];
//				cell.textLabel.textAlignment = UITextAlignmentLeft;
//				break;
//
//			case ROW_DOKDO:
//				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//				cell.textLabel.font = [UIFont boldSystemFontOfSize:11.0];
//				cell.textLabel.textAlignment = UITextAlignmentLeft;
//				break;
//				
//			case ROW_ADVERTISEPAGE:
//				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//				cell.textLabel.font = [UIFont boldSystemFontOfSize:11.0];
//				cell.textLabel.textAlignment = UITextAlignmentLeft;
//				break;
//
//			case ROW_REPRESENT_DOKDO:
//				cell.selectionStyle = UITableViewCellSelectionStyleNone;
//				cell.accessoryType = UITableViewCellAccessoryNone;
//				cell.textLabel.textAlignment = UITextAlignmentLeft;
//				cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:11.0];
//				break;
//			case ROW_ADVERTISEPAGE_REPRESENT:
//				cell.selectionStyle = UITableViewCellSelectionStyleNone;
//				cell.accessoryType = UITableViewCellAccessoryNone;
//				cell.textLabel.textAlignment = UITextAlignmentLeft;
//				cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:11.0];
//				break;
//			case SECTION_SPONSOR_END:
//				cell.selectionStyle = UITableViewCellSelectionStyleNone;
//				cell.accessoryType = UITableViewCellAccessoryNone;
//				cell.textLabel.textAlignment = UITextAlignmentRight;
//				cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0];
//				break;
//
//			default:
//				break;
//		}
//	}
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	
	if (segment.selectedSegmentIndex==0) 
	{
		switch (indexPath.row) 
		{
			case SECTION_NAME:
				cell.textLabel.text = @"DEVELOPERS";
				break;
			case ROW_REPRESENT_YOON:
				cell.textLabel.text = @"Profile";
				break;
			case ROW_REPRESENT_JUSTIN:
				cell.textLabel.text = @"Profile";
				break;
			case ROW_REPRESENT_JOANNE:
				cell.textLabel.text = @"Profile";
				break;
			case 13:
				cell.textLabel.text = @"Profile";
				break;

			case ROW_YOON:
				cell.imageView.image = [UIImage imageNamed:@"REPYOON.png"];
				cell.textLabel.text = @"Yoon Lee\nMajor: Computer Science\n[Master]Project Founder \nInterface Design, Code Implementation, and Development.";
				break;
			case ROW_JUSTIN:
				cell.imageView.image = nil;
				cell.textLabel.text = @"Justin Shaw\nMajor: Business Econ\nMinor:Information & Computer Science\nProject Founder\nUCI Relations, Marketing, and conceptualization.";
				break;
			case ROW_JOANNE:
				cell.imageView.image = nil;
				cell.textLabel.text = @"Andrew Beier\nMajor: Information & Computer Science\nMajor: Business Information Management\nOfficial UCI Shuttle Service Team. Bug Report Manager and Code Implementation Assistant";
				break;
			case 14:
				cell.imageView.image = nil;
				cell.textLabel.text = @"Joanne Yi\nMajor: Art History\nMinor:Digital Arts\nGraphical Artist\nMost existing artwork designed by Joanne Yi.";
				break;

			case SECION_NAME_END:
				cell.textLabel.text = @";- )";
				break;
				
			default:
				cell.textLabel.text = @"";
				
				break;
		}
	}
	else if (segment.selectedSegmentIndex==1)
	{
		cell.imageView.image = nil;
		switch (indexPath.row) 
		{
			case SECTION_CONTACT:
				cell.textLabel.text = @"CONTACT US";
				break;
			case ROW_REPRESENT_FEEDBACK:
				cell.textLabel.text = @"EMAIL US";
				break;
			case ROW_REPRESENT_FACEBOOK:
				cell.textLabel.text = @"BECOME A FACEBOOK FAN";
				break;
			case ROW_EMAIL:
				cell.textLabel.text = @"Send us suggestions and report bugs";
				break;
			case ROW_FACEBOOK:
				cell.textLabel.text = @"Connect with us for the latest updates and discussion";
				break;
			case SECTION_END:
				cell.textLabel.text = @";- )";
				break;
				
				
			default:
				cell.textLabel.text = @"";
				break;
		}
	}
//	else {
//		switch (indexPath.row) {
//			case SECTION_SPONSOR:
//				cell.textLabel.text = @"SPONSORSHIP";
//				break;
//			case ROW_REPRESENT_UNICEF:
//				cell.textLabel.text = @"UNICEF";
//				break;
//			case ROW_REPRESENT_DOKDO:
//				cell.textLabel.text = @"Korean Island DokDo";
//				break;
//			case ROW_ADVERTISEPAGE_REPRESENT:
//				cell.textLabel.text = @"Advertisement";
//				break;
//			case ROW_UNICEF:
//				cell.textLabel.text = @"UNICEF is guided by the Convention on the Rights of the Child and strives to establish children's rights as enduring ethical principles and international standards of behaviour towards children. Visit their website to obtain more information.";
//				break;
//			case ROW_DOKDO:
//				cell.textLabel.text = @"Get more information about this Korean Island.";
//				break;
//			case ROW_ADVERTISEPAGE:
//				cell.textLabel.text = @"Inquire about promoting your campus organization.";
//				break;
//			case SECTION_SPONSOR_END:
//				cell.textLabel.text = @";- )";
//				break;
//
//			default:
//				cell.textLabel.text = @"";
//				break;
//		}
//	}

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	ClassLoader *support;
	
	if (self.segment.selectedSegmentIndex==0)
	{
		[self._tableView deselectRowAtIndexPath:indexPath animated:YES];
		switch (indexPath.row) 
		{
			case 0:
				
				break;
			case ROW_YOON:
				[self sendEmailToUs:@"byobyohae@gmail.com" withName:@"Yoon Lee"];
				break;
			default:
				break;
		}
	}
	else if (self.segment.selectedSegmentIndex==1) 
	{
		[self._tableView deselectRowAtIndexPath:indexPath animated:YES];
		switch (indexPath.row) 
		{
			case ROW_EMAIL:
				[self sendEmailToUs:@"byobyohae@gmail.com" withName:@"Yoon Lee"];
				break;
			case ROW_FACEBOOK:
				//may want to open up the web view or
				//provide facebook api to operate this.
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
					return;
				}
				support = [[ClassLoader alloc] initWithNibName:@"ClassLoader" bundle:nil];
				support.link = @"http://www.facebook.com/pages/UCI-Mobile-App/113860121960876?ref=ts";
				support.name = @"UCIMobile FB";
				[self.navigationController pushViewController:support animated:YES];
				[support release];
				break;
			default:
				break;
		}
	}
//	else 
//	{
//		[self._tableView deselectRowAtIndexPath:indexPath animated:YES];
//		if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) 
//		{
//			//show an alert to let the user know that they can't connect...
//			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status" 
//															message:@"Sorry, the network is not available.\nPlease try again later." 
//														   delegate:nil 
//												  cancelButtonTitle:nil 
//												  otherButtonTitles:@"OK", nil];
//			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//			[alert show];
//			[alert release];
//			return;
//		}
//		switch (indexPath.row) 
//		{
//			case ROW_UNICEF:
//				support = [[SupportViewController alloc] initWithNibName:@"SupportViewController" bundle:nil];
//				[self.navigationController pushViewController:support animated:YES];
//				request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://secure.unicefusa.org/site/Donation2?idb=1432746538&df_id=1621&1621.donation=form1"]];
//				[support.webview loadRequest:request];
//				[support release];
//				break;
//			case ROW_DOKDO:
//				support = [[SupportViewController alloc] initWithNibName:@"SupportViewController" bundle:nil];
//				[self.navigationController pushViewController:support animated:YES];
//				request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://knol.google.com/k/why-is-dokdo-a-korean-island-and-takeshima-a-fiction#"]];
//				[support.webview loadRequest:request];
//				[support release];
//				break;
//			case ROW_ADVERTISEPAGE:
//				[self sendEmailToUs:@"byobyohae@gmail.com" withName:@"Yoon Lee"];
//				break;
//
//			default:
//				break;
//		}
//	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void) sendEmailToUs:(NSString *)recipient withName:(NSString *)name 
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	NSArray *toRecipients = [NSArray arrayWithObject:recipient];
	[picker setToRecipients:toRecipients];
	
	// Fill out the email body text
	NSString *emailBody = [NSString stringWithFormat:@"Dear %@\n\n\nSincerely, ", name];
	picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
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
			alert.title = @"Message has failed to send.";
			[alert show];
			break;
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[alert release];
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"ORIENTATION CHANGED");
}

- (void)viewDidUnload 
{
	_tableView = nil;	
}

- (void)dealloc 
{
	[selectedSound release];
	[super dealloc];
}


@end

