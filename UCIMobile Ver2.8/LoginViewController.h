//
//  LoginViewController.h
//  UCI
//
//  Created by Yoon Lee on 2/21/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import "ParseURL.h"

@class UCIAppController;
@interface LoginViewController : UIViewController <UIAlertViewDelegate>{
	IBOutlet UITextField *ucidnetId;
	IBOutlet UITextField *password;
	IBOutlet UILabel *status;
	IBOutlet UIActivityIndicatorView *statusBar;
	IBOutlet UIImageView *imageView;
	IBOutlet UITextView *disclaimer;
	UIButton *log;
	NSURL *authURL;
	NSURL *listURL;
	
	ParseURL *parse;
	
	NSManagedObjectContext *managedObjectContext;
	NSMutableArray *userInfo;
	UCIAppController *a;
	
	@private BOOL didLogin;
}
//test case
@property(nonatomic, retain) UCIAppController *a;
@property(nonatomic, retain) IBOutlet UIButton *log;
@property (nonatomic, retain) ParseURL *parse;
@property (nonatomic, assign) UITextField *ucidnetId;
@property (nonatomic, assign) UITextField *password;
@property (nonatomic, assign) UILabel *status;
@property (nonatomic, assign) UIActivityIndicatorView *statusBar;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *userInfo;
@property (nonatomic) BOOL didLogin;
@property (nonatomic, retain) IBOutlet UITextView *disclaimer;
- (IBAction) keyboardEnterDone:(id)sender;
- (IBAction) loginRequest:(id)sender;
- (IBAction) textFieldEntered;
- (IBAction) troubleShooting:(id)sender;
- (void) addwithNetID:(NSString *)netID andPasswd:(NSString *)passwd;
- (void) remove;
- (int) load;

@end
