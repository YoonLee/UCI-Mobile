//
//  ThingsToDo.h
//  UCIMobile
//
//  Created by Yoon Lee on 12/14/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdditionalSchedule.h"
#import "ClassInfo.h"

@interface ThingsToDo : UIViewController 
{
	UITextView *textField;
	UIBarButtonItem *button;
	UIBarButtonItem *theme;
	AdditionalSchedule *instant;
	
	NSManagedObjectContext *context;
	ClassInfo *myclass;
	
	NSArray *imageSet;
}

@property(nonatomic, retain) IBOutlet UITextView *textField;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *button;
@property(nonatomic, retain) NSManagedObjectContext *context;
@property(nonatomic, retain) ClassInfo *myclass;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *theme;

- (IBAction) doneTask:(id)sender;
- (IBAction) chageTheme:(id)sender;
- (void)initWithContext:(AdditionalSchedule *)managed;
- (void)applyDisplay:(int)index;
@end
