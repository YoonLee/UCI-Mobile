//
//  LibraryWeb.h
//  UCIMobile
//
//  Created by Yoon Lee on 8/10/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LibraryWeb : UIViewController <UIWebViewDelegate>
{
	UIWebView *webViews;
}

@property (nonatomic, retain) IBOutlet UIWebView *webViews;

- (IBAction) closeCurrentView;
@end
