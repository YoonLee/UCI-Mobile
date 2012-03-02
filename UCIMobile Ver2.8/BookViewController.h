//
//  BookViewController.h
//  UCIMobile
//
//  Created by Yoon Lee on 6/17/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Book.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface BookViewController : UIViewController <UITableViewDelegate, UITextViewDelegate>{
	int pageNumber;
	UIImageView *imageView;
	UITableView *_tableView;
	UITextView *_textView;
	Book *book;
}

- (id)initWithPageNumber:(int)page;

@property(nonatomic, retain) IBOutlet UIImageView *imageView;
@property(nonatomic, retain) IBOutlet UITableView *_tableView;
@property(nonatomic, retain) IBOutlet UITextView *_textView;
@property(nonatomic, retain) Book *book;

@end
