//
//  UCIRSSReaderController.h
//  UCIMobile
//
//  Created by Yoon Lee on 8/10/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCIRSSReader.h"
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface UCIRSSReaderController : UITableViewController 
{
	UCIRSSReader *news;
	NSString *rss;
}

@property (nonatomic, retain) UCIRSSReader *news;
@property (nonatomic, retain) NSString *rss;
- (int) dayCalculator:(NSString *)newsArticleStringDate;

@end
