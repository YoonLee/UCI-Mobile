//
//  TroubleShoot.h
//  UCIMobile
//
//  Created by Yoon Lee on 9/13/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface TroubleShoot : UIViewController <MFMailComposeViewControllerDelegate>
{
	UITextView *textView;
	UILabel *label1;
	UIButton *label2;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UILabel *label1;
@property (nonatomic, retain) IBOutlet UIButton *label2;

- (IBAction) sendEmail:(id)sender;

@end
