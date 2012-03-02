//
//  ClassLoader.h
//  UCIMobile
//
//  Created by Yoon Lee on 8/8/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ClassLoader : UIViewController <UIWebViewDelegate, UISearchBarDelegate>
{
	UIWebView *site;
	NSString *link;
	NSString *name;
	UISearchBar *searchBar;
	BOOL isOperate;
	UILabel *badge;
}

@property (nonatomic, retain) IBOutlet UIWebView *site;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) IBOutlet UILabel *badge;

- (IBAction) searchWebTextContent;

@end
