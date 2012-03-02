//
//  CreatorViewController.h
//  MyUCI
//
//  Created by Yoon Lee on 5/11/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "SoundEffect.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

typedef enum _Represent 
{
	SECTION_NAME = 0,
	SECTION_SPONSOR = 0,
	SECTION_CONTACT = 0,
	SEPARATESECTION1 = 4,
	ROW_REPRESENT_YOON = 5,
	ROW_YOON = 6,
	ROW_BOTTOM_YOON = 7,
	SEPARATESECTION2 = 8,
	ROW_REPRESENT_JUSTIN = 1,
	ROW_JUSTIN = 2,
	ROW_BOTTOM_JUSTIN = 3,
	ROW_REPRESENT_JOANNE = 9,
	ROW_JOANNE = 10,
	ROW_BOTTOM_JOANNE = 11,
	SECION_NAME_END = 16,
	ROW_REPRESENT_FEEDBACK = 1,
	ROW_EMAIL = 2,
	ROW_EMAIL_END = 3,
	ROW_BLANK_FIRST = 4,
	ROW_REPRESENT_FACEBOOK = 5,
	ROW_FACEBOOK = 6,
	ROW_FACEBOOK_END = 7,
	SECTION_END = 8,
	ROW_REPRESENT_UNICEF = 1,
	ROW_UNICEF = 2,
	ROW_END_UNICEF = 3,
	ROW_EMPTY_LINE1 = 4,
	ROW_REPRESENT_DOKDO = 5,
	ROW_DOKDO = 6,
	ROW_END_DOKDO = 7,
	ROW_EMPTY_LINE2 = 8,
	ROW_ADVERTISEPAGE_REPRESENT = 9,
	ROW_ADVERTISEPAGE = 10,
	ROW_ADVERTISEPAGE_END = 11,
	SECTION_SPONSOR_END = 12
} DeveloperInfoDisplay;

@interface CreatorViewController : UIViewController<UITableViewDelegate, MFMailComposeViewControllerDelegate, UINavigationBarDelegate>
{
	
	IBOutlet UISegmentedControl *segment;
	IBOutlet UITableView *_tableView;
	IBOutlet UINavigationItem *secondary;
	
	SoundEffect *selectedSound;
}

@property(nonatomic, retain) IBOutlet UISegmentedControl *segment;
@property(nonatomic, retain) IBOutlet UITableView *_tableView; 
@property(nonatomic, retain) IBOutlet UINavigationItem *secondary;

- (void) segmentChanges;
- (void) sendEmailToUs:(NSString *)recipient withName:(NSString *)name;

@end
