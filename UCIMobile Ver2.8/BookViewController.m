//
//  BookViewController.m
//  UCIMobile
//
//  Created by Yoon Lee on 6/17/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "BookViewController.h"

@implementation BookViewController
@synthesize _textView, _tableView, imageView;
@synthesize book;

typedef enum _PAGECONTROLLERS 
{
	FIRSTPAGE = 1,
	SECONDPAGE = 2,
}FORPAGECONTROLL;

typedef enum _TABLEVIEWCONTENTS 
{
	CELLFIRSTLINE = 0,
	CELLLOCATION = 1,
	CELLCALLNUM = 2,
	CELLSTATUS = 3,
	CELLLASTLINE = 4
}FORTABLECONTENTS;

// Load the view nib and initialize the pageNumber ivar.
- (id)initWithPageNumber:(int)page {
	
	if (page==0) {
		if (self = [super initWithNibName:@"BookViewController" bundle:nil]) {
			pageNumber = page;
		}
	}
	
    return self;
}

- (void)dealloc {
	[imageView release];
	imageView = nil;
    [super dealloc];
}

- (void)viewDidLoad {
	self._tableView.layer.cornerRadius = 15;
	self.imageView.layer.cornerRadius = 5;
	self._textView.layer.cornerRadius = 15.0;
	//self._textView.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:12];
	self._textView.font = [UIFont systemFontOfSize:12];
	self._textView.textColor = [UIColor blackColor];
	if (book.summary) {
		self._textView.text = book.summary;
	}
	else {
		self._textView.text = @"NO SUMMARY EXIST.";
	}
	
	NSURL *givenURL = [NSURL URLWithString:book.bigimgURL];
	NSData *downloaded = [NSData dataWithContentsOfURL:givenURL];
	UIImage *imageToDiplay = [[UIImage alloc] initWithData:downloaded];
	
	//self.view.backgroundColor = RGB(205, 186, 150);
	self.view.backgroundColor = RGB(255, 255, 255);
	self._tableView.backgroundColor = RGB(255, 255, 255);
	self.imageView.image = imageToDiplay;
	self.imageView.layer.masksToBounds = YES;
	[imageToDiplay release];
	self._textView.editable = NO;
	self.view.layer.borderWidth = 3;
	self.view.layer.borderColor = [RGB(197, 204, 212) CGColor];
	self._textView.layer.borderWidth = 2;
	self._textView.layer.borderColor = [RGB(197, 204, 212) CGColor];
	self.imageView.layer.borderWidth = 2;
	self.imageView.layer.borderColor = [RGB(197, 204, 212) CGColor];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	
	return 5;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    NSString *curStatus = @"";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	switch (indexPath.row)
	{
		case CELLFIRSTLINE:
			cell.textLabel.text = @"";
			break;
		case CELLLASTLINE:
			cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:12];
			cell.textLabel.textAlignment = UITextAlignmentRight;
			if (book.iSBN) 
			{
				cell.textLabel.text = [NSString stringWithFormat:@"ISBN: %@", book.iSBN];
			}
			else 
			{
				cell.textLabel.text = @"NO ISBN FOUND";
			}
			
			
			break;
		case CELLLOCATION:
			cell.textLabel.numberOfLines = 0;
			cell.imageView.image = [UIImage imageNamed:@"build10.png"];
			cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:12];
			if ([book.location isEqualToString:@"SCI Bar"]) {
				book.location = [NSString stringWithFormat:@"SCI Bar(SCIENCE LIBRARY)"];
			}
			cell.textLabel.text = [NSString stringWithFormat:@"LOCATE: %@", book.location];
			break;
		case CELLCALLNUM:
			cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:12];
			cell.textLabel.numberOfLines = 0;
			cell.textLabel.text = [NSString stringWithFormat:@"CALLNUM: %@", book.callNumber];
			cell.imageView.image = [UIImage imageNamed:@"infom.png"];
			break;
		case CELLSTATUS:
			cell.textLabel.numberOfLines = 0;
			cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:12];
			if ([book.status isEqualToString:@"(NOT CHCKD OUT)"]) 
			{
				curStatus = @"BOOK IS AVAILABLE";
			}
			else if ([book.status isEqualToString:@"LIB USE ONLY"])
			{
				curStatus = @"LIBRARY USE ONLY";
			}
			else 
			{
				curStatus = [NSString stringWithFormat:@"%@ HOLD BY SOMEONE", book.status];
			}
			
			cell.textLabel.text = [NSString stringWithFormat:@"STATUS: %@", curStatus];
			break;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[self._tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	CGFloat retVar;
	
	switch (indexPath.row) 
	{
		case CELLFIRSTLINE:
			retVar = 18.0;
			break;
		case CELLLASTLINE:
			retVar = 18.0;
			break;
		default:
			retVar = 40.0;
			break;
	}
	
	return retVar;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case CELLFIRSTLINE:
			cell.backgroundColor = RGB(255, 241, 194);
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			break;
		case CELLLASTLINE:
			cell.backgroundColor = RGB(255, 241, 194);
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			break;
		case CELLSTATUS:
			if ([book.status isEqualToString:@"(NOT CHCKD OUT)"]) {
				cell.textLabel.textColor = RGB(154, 205, 50);
				cell.imageView.image = [UIImage imageNamed:@"OkaytoCheckOut.png"];
			}
			else {
				cell.textLabel.textColor = RGB(142, 35, 35);
				cell.imageView.image = [UIImage imageNamed:@"NOTAVAILABLE.png"];
			}
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.backgroundColor = RGB(205, 231, 243);
			break;
			
		default:
			cell.backgroundColor = RGB(255, 255, 255);
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			break;
	}
}
- (void)viewDidUnload {
    [super viewDidUnload];
	
}

@end
