//
//  BuildingView.h
//  MyUCI
//
//  Created by Yoon Lee on 4/23/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CampusMapStorage.h"
#import <QuartzCore/QuartzCore.h>;

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
@interface BuildingView : UIViewController<UITableViewDelegate, UIAlertViewDelegate> {
	IBOutlet UIImageView *imageView;
	IBOutlet UITableView *_tableView;
	NSMutableArray *infoCenter;
	NSMutableArray *fetchedInfo;
	NSString *foundCallNumber;
	NSManagedObjectContext *managedObjectContext;
	
	CampusMapStorage *display;
	BOOL isHasContact;
}

@property(nonatomic, retain) IBOutlet UIImageView *imageView;
@property(nonatomic, retain) IBOutlet UITableView *_tableView;
@property(nonatomic, retain) NSMutableArray *infoCenter;
@property(nonatomic, retain) NSMutableArray *fetchedInfo;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSString *foundCallNumber;
@property(nonatomic, retain) CampusMapStorage *display;
- (void)updateStatus;

@end
