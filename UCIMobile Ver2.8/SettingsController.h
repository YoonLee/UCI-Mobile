//
//  SettingsController.h
//  Smile
//
//  Created by Evgeniy Shurakov on 23.05.09.
//  Copyright Evgeniy Shurakov 2009. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsController : UITableViewController 
{
	NSArray *servers;
	NSMutableDictionary *targets;
	NSManagedObjectContext *managedObjectContext;
}

@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
- (NSArray *) fetch;
@end
