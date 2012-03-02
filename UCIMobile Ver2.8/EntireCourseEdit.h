//
//  EntireCourseEdit.h
//  UCIMobile
//
//  Created by Yoon Lee on 12/14/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundEffect.h"
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface EntireCourseEdit : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
	NSManagedObjectContext *managedObjectContext;
	NSMutableArray *contextContents;
	NSMutableArray *mySchedules;
	NSMutableArray *capturesRuntimeModule;
	NSMutableArray *entireQuery;
	UISegmentedControl *segment;
	SoundEffect *selectedSound;
	
	bool edit;
}

@property(nonatomic, assign) bool edit;
- (void) initWithContext:(NSManagedObjectContext *) managedObject;
- (void) fetchOperation;
- (NSString *) dateOfToday;
@end
