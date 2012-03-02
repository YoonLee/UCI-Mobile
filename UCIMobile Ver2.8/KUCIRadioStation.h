//
//  KUCIRadioStation.h
//  UCIMobile
//
//  Created by Yoon Lee on 6/6/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundEffect.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface KUCIRadioStation : UIViewController<UIWebViewDelegate> {

	IBOutlet UIWebView *webview;
	IBOutlet UITextView *textView;
	UILabel *label1;
	UILabel *label2;
	UILabel *label3;
	SoundEffect *selectedSound;
	UIActivityIndicatorView *activityIndicator;
}

@property(nonatomic, retain) IBOutlet UIWebView *webview;
@property(nonatomic, retain) IBOutlet UITextView *textView;
@property(nonatomic, retain) IBOutlet UILabel *label1;
@property(nonatomic, retain) IBOutlet UILabel *label2;
@property(nonatomic, retain) IBOutlet UILabel *label3;
-(IBAction) launchRadio:(id)sender;

@end
