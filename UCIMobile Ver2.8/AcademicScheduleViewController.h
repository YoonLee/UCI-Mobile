//
//  AcademicScheduleViewController.h
//  MyUCI
//
//  Created by Yoon Lee on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcademicScheduleViewController : UITableViewController {
	NSManagedObjectContext *managedObjectContext;
	NSMutableArray *recieverQuarterActivities;
}
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSMutableArray *recieverQuarterActivities;

@end
