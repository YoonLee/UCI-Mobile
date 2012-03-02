//
//  AdditionalSchedule.h
//  UCIMobile
//
//  Created by Yoon Lee on 12/12/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassInfo.h"

@interface AdditionalSchedule : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
	NSMutableArray *scheudles;
	NSArray *menus;
	NSManagedObjectContext *managedObjectContext;
	
	UIPickerView *pickerViews;
	UIToolbar *_toolbar;
	UINavigationBar *_toolbar2;
	NSArray *date;
	NSMutableDictionary *recordedDate;
	UITextField *capturedEvent;
	
	NSString *annotation;
	NSString *note;
	NSString *imgIndex;
}
@property(nonatomic, retain) UINavigationBar *_toolbar2;
@property(nonatomic, retain) NSString *annotation;
@property(nonatomic, retain) NSString *note;
@property(nonatomic, retain) NSString *imgIndex;

- (void) resignFadeOut:(id)sender;
- (void) initWithCoreData:(NSManagedObjectContext *) managedObject;
@end
