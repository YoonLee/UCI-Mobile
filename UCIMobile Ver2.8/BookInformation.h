//
//  BookInformation.h
//  UCIMobile
//
//  Created by Yoon Lee on 6/17/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import <QuartzCore/QuartzCore.h>
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface BookInformation : UIViewController<UIScrollViewDelegate, UIWebViewDelegate> {
	Book *book;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIPageControl *pageControl;
	NSMutableArray *viewControllers;
	
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
	
	int temporaryLoadIndex;

}

@property (nonatomic, retain) Book *book;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;

- (void) initWithContents:(Book *)book;
- (IBAction) changePage:(id)sender;
- (void) swapBigImageCover;

@end
