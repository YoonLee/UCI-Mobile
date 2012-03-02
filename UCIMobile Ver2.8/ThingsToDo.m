//
//  ThingsToDo.m
//  UCIMobile
//
//  Created by Yoon Lee on 12/14/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "ThingsToDo.h"
#import "ChooseTheme.h"
#import <QuartzCore/QuartzCore.h>

@implementation ThingsToDo
@synthesize textField, button, context, myclass, theme;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
	
	NSArray *theme1 = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"n1_1.png"], [UIImage imageNamed:@"n1_2.png"], nil];
	NSArray *theme2 = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"n2_1.png"], [UIImage imageNamed:@"n2_2.png"], nil];
	NSArray *theme3 = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"n3_1.png"], [UIImage imageNamed:@"n3_2.png"], nil];
	NSArray *theme4 = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"n4_1.png"], [UIImage imageNamed:@"n4_2.png"], nil];
	
	imageSet = [[NSArray alloc] initWithObjects:theme1, theme2, theme3, theme4,nil];
	
	[theme1 release];
	[theme2 release];
	[theme3 release];
	[theme4 release];
	
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 280, 30)];
	label1.text = @"Notes Adder";
	label1.textAlignment = UITextAlignmentLeft;
	label1.textColor = [UIColor whiteColor];
	label1.font = [UIFont boldSystemFontOfSize:14];
	label1.backgroundColor = [UIColor clearColor];
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 280, 30)];
	label2.text = @"Write down something and save";
	label2.textAlignment = UITextAlignmentLeft;
	label2.textColor = [UIColor whiteColor];
	label2.font = [UIFont fontWithName:@"Georgia" size:12];
	label2.backgroundColor = [UIColor clearColor];
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 60)];
	[imgView addSubview:label2];
	[imgView addSubview:label1];
	self.navigationItem.titleView = imgView;
	[imgView release];
	[label1 release];
	[label2 release];
	
    [super viewDidLoad];
	UIBarButtonItem *rhs = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finish:)];
	self.navigationItem.rightBarButtonItem = rhs;
	
	if (myclass==nil) 
	{
		self.textField.text = @"";
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -2, 320, 34)];
		
		// default
		imageView.image = [[imageSet objectAtIndex:1] objectAtIndex:0];
		UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 343, 320, 32)];
		imageView2.image = [[imageSet objectAtIndex:1] objectAtIndex:1];
		self.textField.frame = CGRectMake(0, imageView.frame.size.height, 320, 400);
		imageView.tag = 777;
		imageView2.tag = 778;
		[self.view addSubview:imageView];
		[self.view addSubview:imageView2];
		[imageView release];
		[imageView2 release];
		
		instant.imgIndex = @"1";
	}
	else
	{
		// load the image
		[self applyDisplay:[myclass.num intValue]];
		self.textField.text = myclass.instructor;
	}
	
	[rhs release];
}

- (void)applyDisplay:(int)index
{
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -2, 320, 34)];
	UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 343, 320, 32)];
	self.textField.frame = CGRectMake(0, imageView.frame.size.height, 320, 400);
	
	// kills
	for (UIView *view in self.view.subviews) 
	{
		if (view.tag==777||view.tag==778) 
		{
			[view removeFromSuperview];
		}
	}
	
	if (index==0) 
	{
		// animation
		imageView.animationImages = [imageSet objectAtIndex:index];
		imageView2.animationImages = [imageSet objectAtIndex:index];
		imageView.animationDuration = 1.0;
		imageView2.animationDuration = 1.0;
		[imageView startAnimating];
		[imageView2 startAnimating];
	}
	else
	{
		// top
		imageView.image = [[imageSet objectAtIndex:index] objectAtIndex:0];
		// bottom
		imageView2.image = [[imageSet objectAtIndex:index] objectAtIndex:1];
	}
	
	imageView.tag = 777;
	imageView2.tag = 778;
	[self.view addSubview:imageView];
	[self.view addSubview:imageView2];
	[imageView release];
	[imageView2 release];

	
	if (myclass==nil)
	{
		// send state to the origginal destination.
		instant.imgIndex = [NSString stringWithFormat:@"%d", index];
	}
	else
	{
		myclass.num = [NSString stringWithFormat:@"%d", index];
	}
}

#pragma mark -
#pragma mark Memory management
- (void)finish:(id)sender
{
	[textField resignFirstResponder];
}

- (void)initWithContext:(AdditionalSchedule *)managed
{
	instant = managed;
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (IBAction) doneTask:(id)sender
{
	// save to the query and then dismisses it.
	if (myclass!=nil) 
	{
		myclass.instructor = textField.text;
		
		[context refreshObject:myclass mergeChanges:YES];
		[context save:nil];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save" message:@"Re-Saved" delegate:nil cancelButtonTitle:@"Confirm" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		instant.note = textField.text;
		[instant.tableView reloadData];
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) chageTheme:(id)sender
{
	ChooseTheme *chooseTheme = [[ChooseTheme alloc] initWithStyle:UITableViewStyleGrouped];
	[self.navigationController pushViewController:chooseTheme animated:YES];
	[chooseTheme initThingstoDo:self];
	[chooseTheme release];
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc
{
	[imageSet release];
	myclass = nil;
	[button release];
	[textField release];
    [super dealloc];
}

@end
