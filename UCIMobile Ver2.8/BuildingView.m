//
//  BuildingView.m
//  MyUCI
//
//  Created by Yoon Lee on 4/23/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import "BuildingView.h"
#import "ASIHTTPRequest.h"
#import "Reachability.h"

@implementation BuildingView
@synthesize _tableView, imageView;
@synthesize infoCenter, fetchedInfo;
@synthesize managedObjectContext;
@synthesize display;
@synthesize foundCallNumber;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
	NSArray *comps = nil;
	NSString *stringRejoined = nil;
	[self updateStatus];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//	[_tableView setDelegate:self];
	self._tableView.layer.cornerRadius = 13.0;
	self._tableView.layer.borderWidth = 2.0;
	self._tableView.layer.borderColor = [RGB(200, 200, 200) CGColor];
	NSArray *storeUnknown = [NSArray arrayWithObjects: @"94", @"233", @"96", @"817", @"802", @"515", @"516", @"902", @"90", @"903", @"3" @"308", @"95", @"832", @"843", @"611", @"835", @"813", @"811", @"821", @"827", @"810", @"812", @"59", @"2", @"829", @"7", @"506", @"214", @"839", @"5", @"801", @"231", @"232", @"234", @"236", @"4199", nil];
	
	self.title = @"Information";
	NSString *addrURL = @"";
	
	if ([storeUnknown containsObject:[display.numBuilding stringValue]]) 
    {
		addrURL = [NSString stringWithFormat:@"http://www.uci.edu/campusmap/building-images/%@.jpg", display.numBuilding];
	}
	else 
    {
		addrURL = [NSString stringWithFormat:@"https://eee.uci.edu/images/buildings/%@.jpg", display.numBuilding];
	}
	
	NSURL *givenURL = [NSURL URLWithString:addrURL];
	NSData *downloaded = [NSData dataWithContentsOfURL:givenURL];
	UIImage *imageToDiplay = [[UIImage alloc] initWithData:downloaded];
	if (imageToDiplay) {
		self.imageView.image = imageToDiplay;
	}
	else 
	{
		@try 
		{
			comps = [(NSString *)display.extendBname componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			stringRejoined = [comps componentsJoinedByString:@""];
		}
		@catch (NSException * e) {
			stringRejoined = display.extendBname;
		}
		
		addrURL = [NSString stringWithFormat:@"http://sites.google.com/site/uciiphone/%@.jpg", stringRejoined];
		givenURL = [NSURL URLWithString:addrURL];
		downloaded = [NSData dataWithContentsOfURL:givenURL];
		imageToDiplay = [[UIImage alloc] initWithData:downloaded];
		
		if (imageToDiplay) 
		{
			self.imageView.image = imageToDiplay;
		}
	}
	
	[imageToDiplay release];
	[self._tableView setBackgroundColor:[UIColor whiteColor]];
	self._tableView.sectionHeaderHeight = 35.0;
	
	//Temp Section
	int targetCreator = [infoCenter count]+1;
	NSArray *filterout = [NSArray arrayWithObjects:@"Bren Events Center", @"Police", @"KUCI Radio Station", @"Irvine Barclay Theatre", nil];
	NSArray *givenPhoneNumber = [NSArray arrayWithObjects:@"9498245000", @"9498241885", @"9498245824", @"9498544646", nil];
	NSString *phonenumber = @"";
	infoCenter = [[NSMutableArray alloc] init];
	
	[infoCenter addObject:[NSString stringWithFormat:@"%@", display.extendBname]];
	[infoCenter insertObject:@"Building Number" atIndex:targetCreator];
	if ([display.numBuilding intValue]==0) {
		if ([(NSString *)display.extendBname isEqualToString:@"DokDo"]) {
			[infoCenter insertObject:@"Dokdo (two islands) located in the East Sea is a part of (South) Korean territory." atIndex:targetCreator+1];
		}
		else {
			[infoCenter insertObject:@"No such building number exists. Please call contact number error below if you believe this to be an error." atIndex:targetCreator+1];
		}
		
	}
	else {
		[infoCenter insertObject:[display.numBuilding stringValue] atIndex:targetCreator+1];
	}
	
	
	[infoCenter insertObject:@"Operation Hours" atIndex:targetCreator+2];
	NSString *operation = (NSString *)display.operationHours;
	NSArray *temp = [operation componentsSeparatedByString:@" "];
	
	if ([temp containsObject:@"."]) {
		[infoCenter insertObject:@"Operating hours not available." atIndex:targetCreator+3];
	}
	else {
		[infoCenter insertObject:display.operationHours atIndex:targetCreator+3];
	}
	
	temp = [(NSString *)display.phoneContact componentsSeparatedByString:@" "];
	[infoCenter insertObject:@"Contact Phone Number" atIndex:targetCreator+4];
	if ([temp containsObject:@"."]) {
		[infoCenter insertObject:@"Contact number not found." atIndex:targetCreator+5];
		isHasContact = NO;
	}
	else {
		isHasContact = YES;
		@try {
			//divide by - sign, if any.
			//otherwise it will through exception.
			NSArray *partition = [(NSString *)display.phoneContact componentsSeparatedByString:@"-"];
			for (int i=0; i<[partition count]; i++) {
				phonenumber = [phonenumber stringByAppendingFormat:@"%@", [partition objectAtIndex:i]];
			}//
			 //						NSLog(@"트리 1:%@",phonenumber);
			@try {
				partition = [phonenumber componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				
				phonenumber = [partition componentsJoinedByString:@""];
				//NSLog(@"트리 2:%@",phonenumber);
				self.foundCallNumber = phonenumber;
			}
			@catch (NSException * e) {
				
			}
			
		}
		//since we have duplicated building number such as 0
		//we going to use extended building name instead to compare.
		@catch (NSException * e) {
			//course, multiple line not would be.
			//for dokdo
			if ([filterout containsObject:display.extendBname]) {
				self.foundCallNumber = [givenPhoneNumber objectAtIndex:[filterout indexOfObject:display.extendBname]];
			}
			else {
				self.foundCallNumber = nil;
			}
			
		}
		[infoCenter insertObject:display.phoneContact atIndex:targetCreator+5];
		
	}

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)updateStatus
{
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
	}
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex==0) {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat retVar = 0.0;
	
	switch (indexPath.row) {
		case 1:
			retVar = 20.0;
			break;
		case 3:
			retVar = 20.0;
			break;
		case 5:
			retVar = 20.0;
			break;
		default:
			retVar = 50.0;
			break;
	}
	return retVar;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [infoCenter count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	UIImage *theImage = nil;
    switch (indexPath.section) {
		case 0:
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			if (indexPath.row==1) {
				cell.textLabel.textAlignment = UITextAlignmentLeft;
				
			}
			else if(indexPath.row==2) {
				cell.textLabel.textAlignment = UITextAlignmentLeft;
			}
			
			cell.textLabel.text = [infoCenter objectAtIndex:indexPath.row];
			theImage = [UIImage imageNamed:@""];
			break;
		default:
			break;
	}
    // Configure the cell...
    cell.imageView.image = theImage;
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	int targetCreator = [infoCenter count];
//	NSArray *filterout = [NSArray arrayWithObjects:@"Bren Events Center", @"Police", @"KUCI Radio Station", @"Irvine Barclay Theatre", nil];
//	NSArray *givenPhoneNumber = [NSArray arrayWithObjects:@"9498245000", @"9498241885", @"9498245824", @"9498544646", nil];
//	NSString *phonenumber = @"";
	
	switch (indexPath.row) {
//		case 0:
//			
//			if (targetCreator==7) {
//				[infoCenter removeObjectAtIndex:targetCreator-1];
//				[infoCenter removeObjectAtIndex:targetCreator-2];
//				[infoCenter removeObjectAtIndex:targetCreator-3];
//				[infoCenter removeObjectAtIndex:targetCreator-4];
//				[infoCenter removeObjectAtIndex:targetCreator-5];
//				[infoCenter removeObjectAtIndex:targetCreator-6];
//				
//				NSArray *deletePathFinder = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:targetCreator-1 inSection:0], [NSIndexPath indexPathForRow:targetCreator-2 inSection:0], [NSIndexPath indexPathForRow:targetCreator-3 inSection:0], [NSIndexPath indexPathForRow:targetCreator-4 inSection:0],[NSIndexPath indexPathForRow:targetCreator-5 inSection:0],[NSIndexPath indexPathForRow:targetCreator-6 inSection:0], nil];
//				[self._tableView deleteRowsAtIndexPaths:deletePathFinder withRowAnimation:UITableViewRowAnimationFade];
//				self._tableView.sectionHeaderHeight = 45.0;
//			}
//			else {
//				[infoCenter insertObject:@"Building Number" atIndex:targetCreator];
//				if ([display.numBuilding intValue]==0) {
//					if ([(NSString *)display.extendBname isEqualToString:@"DokDo"]) {
//						[infoCenter insertObject:@"Dokdo (two islands) located in the East Sea is a part of (South) Korean territory." atIndex:targetCreator+1];
//					}
//					else {
//						[infoCenter insertObject:@"No such building number exists. Please call contact number error below if you believe this to be an error." atIndex:targetCreator+1];
//					}
//					
//				}
//				else {
//					[infoCenter insertObject:[display.numBuilding stringValue] atIndex:targetCreator+1];
//				}
//				
//				
//				[infoCenter insertObject:@"Operation Hours" atIndex:targetCreator+2];
//				NSString *operation = (NSString *)display.operationHours;
//				NSArray *temp = [operation componentsSeparatedByString:@" "];
//
//				if ([temp containsObject:@"."]) {
//					[infoCenter insertObject:@"Operating hours not available." atIndex:targetCreator+3];
//				}
//				else {
//					[infoCenter insertObject:display.operationHours atIndex:targetCreator+3];
//				}
//				
//				temp = [(NSString *)display.phoneContact componentsSeparatedByString:@" "];
//				[infoCenter insertObject:@"Contact Phone Number" atIndex:targetCreator+4];
//				if ([temp containsObject:@"."]) {
//					[infoCenter insertObject:@"Contact number not found." atIndex:targetCreator+5];
//					
//				}
//				else {
//					
//					@try {
//						//divide by - sign, if any.
//						//otherwise it will through exception.
//						NSArray *partition = [(NSString *)display.phoneContact componentsSeparatedByString:@"-"];
//						for (int i=0; i<[partition count]; i++) {
//							phonenumber = [phonenumber stringByAppendingFormat:@"%@", [partition objectAtIndex:i]];
//						}//
////						NSLog(@"트리 1:%@",phonenumber);
//						@try {
//							partition = [phonenumber componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//							
//							phonenumber = [partition componentsJoinedByString:@""];
//							//NSLog(@"트리 2:%@",phonenumber);
//							self.foundCallNumber = phonenumber;
//						}
//						@catch (NSException * e) {
//							
//						}
//						
//					}
//					//since we have duplicated building number such as 0
//					//we going to use extended building name instead to compare.
//					@catch (NSException * e) {
//						//course, multiple line not would be.
//						//for dokdo
//						if ([filterout containsObject:display.extendBname]) {
//							self.foundCallNumber = [givenPhoneNumber objectAtIndex:[filterout indexOfObject:display.extendBname]];
//						}
//						else {
//							self.foundCallNumber = nil;
//						}
//						
//					}
//					[infoCenter insertObject:display.phoneContact atIndex:targetCreator+5];
//					
//				}
//				
//				NSArray *pathFinder = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:targetCreator inSection:0], [NSIndexPath indexPathForRow:targetCreator+1 inSection:0],[NSIndexPath indexPathForRow:targetCreator+2 inSection:0],[NSIndexPath indexPathForRow:targetCreator+3 inSection:0],[NSIndexPath indexPathForRow:targetCreator+4 inSection:0],[NSIndexPath indexPathForRow:targetCreator+5 inSection:0], nil];
//				
//				[self._tableView beginUpdates];
//				[self._tableView insertRowsAtIndexPaths:pathFinder withRowAnimation:UITableViewRowAnimationTop];
//			}
//			[self._tableView endUpdates];
//			break;
		case 6:
			if ([infoCenter count]==7&&self.foundCallNumber&&isHasContact) {
				if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.foundCallNumber]]]) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"Calling Feature not supported by Device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[alert show];
					[alert release];
				}
			}
			break;
			
		default:
			break;
	}
	
	[self._tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	//color setting
	if (indexPath.row%2==0) {
		cell.backgroundColor = RGB(176, 198, 227);
	}
	else if (indexPath.row%2!=0){
		cell.backgroundColor = RGB(50, 79, 133);
	}
	
	//font and style setting
	switch (indexPath.row) {
		case 0:
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0];
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.textColor = RGB(80, 80, 80);
			break;
		case 1:
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.font = [UIFont boldSystemFontOfSize:11.0];
			cell.textLabel.textColor = RGB(255, 238, 76);
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.numberOfLines = 0;
			break;
		case 4:
			cell.textLabel.textAlignment = UITextAlignmentLeft;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.font = [UIFont systemFontOfSize:10.0];
			cell.textLabel.textColor = [UIColor blackColor];
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.numberOfLines = 0;
			break;
			
		case 3:
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.font = [UIFont boldSystemFontOfSize:11.0];
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.textColor = RGB(255, 238, 76);
			cell.textLabel.numberOfLines = 0;
			break;
		case 5:
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.font = [UIFont boldSystemFontOfSize:11.0];
			cell.textLabel.textColor = RGB(255, 238, 76);
			cell.textLabel.numberOfLines = 0;
			break;
		case 6:
			cell.textLabel.textAlignment = UITextAlignmentLeft;
			if (isHasContact) {
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			else {
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			cell.textLabel.textColor = [UIColor blackColor];
			cell.textLabel.font = [UIFont systemFontOfSize:10.0];
			cell.textLabel.numberOfLines = 0;
			break;
		default:
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.font = [UIFont systemFontOfSize:12.0];
			cell.textLabel.numberOfLines = 0;
			cell.textLabel.textColor = [UIColor blackColor];
			break;
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
	[self.navigationController popViewControllerAnimated:YES];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	_tableView = nil;
	imageView = nil;
	managedObjectContext = nil;
	infoCenter = nil;
	foundCallNumber = nil;
	isHasContact = YES;
}


- (void)dealloc {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[managedObjectContext release];
	[imageView release];
	[_tableView release];
	[infoCenter release];
	[super dealloc];
}


@end

