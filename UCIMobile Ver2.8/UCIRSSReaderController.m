//
//  UCIRSSReaderController.m
//  UCIMobile
//
//  Created by Yoon Lee on 8/10/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "UCIRSSReaderController.h"
#import "ClassLoader.h"
#import <QuartzCore/QuartzCore.h>

#define FONT_SIZE 12.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 13.0

@implementation UCIRSSReaderController
@synthesize news, rss;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSURL *url = [NSURL URLWithString:rss];
	news = [[UCIRSSReader alloc] initWithURL:url];
	self.title = @"RSS NewsFeed";
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
    return [news.items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat retVar;
	
	NSString *text1 = [[news.items objectAtIndex:indexPath.row] objectForKey:@"title"];
	NSString *text2 = [[news.items objectAtIndex:indexPath.row] objectForKey:@"description"];
	NSString *text3 = [[news.items objectAtIndex:indexPath.row] objectForKey:@"pubDate"];
	
	CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
	CGSize size1 = [text1 sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	CGSize size2 = [text2 sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	CGSize size3 = [text3 sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	retVar = MAX(size1.height + size2.height + size3.height + 7, 70.0f);
	
	return retVar + 4;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	NSString *titleOfScript = [[news.items objectAtIndex:indexPath.row] objectForKey:@"title"];
	titleOfScript = [titleOfScript stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    cell.textLabel.text = titleOfScript;
	NSString *date = [[news.items objectAtIndex:indexPath.row] objectForKey:@"pubDate"];
	date = [date substringToIndex:date.length-9];

	NSString *description = [[news.items objectAtIndex:indexPath.row] objectForKey:@"description"];
	description = [description stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	NSString *retDate;
	int days = [self dayCalculator:[[news.items objectAtIndex:indexPath.row] objectForKey:@"pubDate"]];
	
	UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newRSS.png"]] autorelease];
	
	//if news post date is less than 2 display image
	if (days==0) 
	{
		retDate = @"posted today";
		[cell addSubview:imageView];
		cell.accessoryView = imageView;
	}
	else if (days == 1) 
	{
		retDate = @"  *1 day ago";
		[cell addSubview:imageView];
		cell.accessoryView = imageView;		
	}
	else if (days < 7)
	{
		retDate = [NSString stringWithFormat:@"%@  *%d days ago", date, days];
		[cell addSubview:imageView];
		cell.accessoryView = imageView;
	}
	else if (days > 7&&days < 30)
	{
		retDate = [NSString stringWithFormat:@"%@  *about week(s) ago", date];
		cell.accessoryView = nil;
	}
	else if (days > 30&&days < 60)
	{
		retDate = [NSString stringWithFormat:@"%@  *about a month ago", date];
		cell.accessoryView = nil;
	}
	else
	{
		retDate = [NSString stringWithFormat:@"%@  *about months ago", date];
		cell.accessoryView = nil;
	}




	NSString *withDate = [NSString stringWithFormat:@"%@\n-%@",description , retDate];
	cell.detailTextLabel.text = withDate;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.textLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
	cell.textLabel.textColor = RGB(52, 78, 134);
	cell.backgroundColor = RGB(237, 239, 234);
	cell.detailTextLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
	cell.textLabel.numberOfLines = 0;
	cell.detailTextLabel.numberOfLines = 0;
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
	cell.detailTextLabel.minimumFontSize = FONT_SIZE;
	cell.textLabel.minimumFontSize = FONT_SIZE;
}

- (int) dayCalculator:(NSString *)newsArticleStringDate
{
	int days = 0;
	
	NSDate *today = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

	[formatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss"];
	
	today = [formatter dateFromString:[formatter stringFromDate:today]];
	newsArticleStringDate = [newsArticleStringDate substringToIndex:newsArticleStringDate.length - 6];
	
	NSDate *future = [formatter dateFromString:newsArticleStringDate];
	//NSLog(@"%@ <=> %@", [future description], [today description]);
	
	days = [today timeIntervalSinceDate:future] / 86400;
	[formatter release];
	
	return days;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	ClassLoader *loadNewsFeed = [[ClassLoader alloc] initWithNibName:@"ClassLoader" bundle:nil];
	loadNewsFeed.name = @"Detail View";
	loadNewsFeed.link = [[news.items objectAtIndex:indexPath.row] objectForKey:@"link"];
	[self.navigationController pushViewController:loadNewsFeed animated:YES];
	[loadNewsFeed release];
}

- (void)dealloc 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	rss = nil;
	[news release];
    [super dealloc];
}


@end

