//
//  RSSNewsChooserController.h
//  UCIMobile
//
//  Created by Yoon Lee on 8/13/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RSSNewsChooserController : UITableViewController <UITableViewDelegate>
{
	NSArray *contents;
}

@property (nonatomic, retain) NSArray *contents;

@end
