//
//  SpecificViewController.h
//  MyUCI
//
//  Created by Yoon Lee on 4/29/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "DictionaryResults.h"
#import "DirectorySearch.h"

@interface SpecificViewController : UITableViewController<UITableViewDelegate, MFMailComposeViewControllerDelegate> {

	IBOutlet UILabel *_name;
	IBOutlet UILabel *_major;
	IBOutlet UILabel *_level;
	IBOutlet UILabel *_Fmajor;
	IBOutlet UILabel *_Flevel;
	IBOutlet UILabel *_sendMe;
	
	IBOutlet UILabel *_nameEXT;
	IBOutlet UILabel *_majorEXT;
	IBOutlet UITableViewCell *nameTagCell;
	
	IBOutlet UILabel *_webpie;
	IBOutlet UIButton *_directHP;
	IBOutlet UITableViewCell *contactTagCell;
	
	IBOutlet UILabel *identify;
	
	NSString *person;
	NSString *personMajor;
	NSString *personID;
	NSString *emailPersonal;
	NSMutableArray *savesObject;
	NSManagedObjectContext *managedContext;
	
	NSString *_pTitle;
	NSString *hpaddress;
	BOOL hasHP;
	
	IBOutlet UIImageView *imageobject;
	IBOutlet UIImageView *imageobject1;
	IBOutlet UIImageView *imageobject2;
	NSString *urlToImage;
	DirectorySearch *setter;
}

- (BOOL) hasPersonalWebpage;

- (IBAction) openWebPage;

- (NSString *) conversion:(NSString *)str withDecode:(NSString *)tpyrcne withState:(NSInteger)mt;

- (NSString *) asciiMater:(NSString *)decode;

- (void) sendEmailToUs;

@property(nonatomic, retain) IBOutlet UILabel *_name;
@property(nonatomic, retain) IBOutlet UILabel *_major;
@property(nonatomic, retain) IBOutlet UILabel *_level;
@property(nonatomic, retain) IBOutlet UILabel *_Fmajor;
@property(nonatomic, retain) IBOutlet UILabel *_Flevel;
@property(nonatomic, retain) IBOutlet UILabel *_sendMe;
@property(nonatomic, retain) IBOutlet UILabel *_nameEXT;
@property(nonatomic, retain) IBOutlet UILabel *_majorEXT;
@property(nonatomic, retain) IBOutlet UILabel *identify;
@property(nonatomic, retain) IBOutlet UILabel *_webpie;
@property(nonatomic, retain) IBOutlet UIButton *_directHP;

@property(nonatomic, retain) IBOutlet UITableViewCell *nameTagCell;
@property(nonatomic, retain) IBOutlet UITableViewCell *contactTagCell;

@property(nonatomic, retain) NSString *person;
@property(nonatomic, retain) NSString *personID;
@property(nonatomic, retain) NSString *emailPersonal;
@property(nonatomic, retain) NSString *personMajor;
@property(nonatomic, retain) NSMutableArray *savesObject;
@property(nonatomic, retain) NSManagedObjectContext *managedContext;


@property(nonatomic, retain) IBOutlet UIImageView *imageobject;
@property(nonatomic, retain) IBOutlet UIImageView *imageobject1;
@property(nonatomic, retain) IBOutlet UIImageView *imageobject2;
@property(nonatomic, retain) NSString *urlToImage;
@property(nonatomic, retain) DirectorySearch *setter;

@property(nonatomic, retain) NSString *_pTitle;
@property(nonatomic, retain) NSString *hpaddress;
@end
