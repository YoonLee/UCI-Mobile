//
//  SportsScheduler.h
//  UCIMobile
//
//  Created by Yoon Lee on 9/25/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface SportsScheduler : UITableViewController <UITableViewDelegate>
{
	NSMutableArray *allEvents;
}

@property(nonatomic, retain) NSMutableArray *allEvents;

@end
