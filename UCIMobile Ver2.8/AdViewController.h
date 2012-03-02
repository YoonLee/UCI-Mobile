//
//  AdViewController.h
//  UCIMobile
//
//  Created by Yoon Lee on 12/20/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface AdViewController : UIViewController <ADBannerViewDelegate>
{
	ADBannerView *banner;
}

@property(nonatomic, retain) IBOutlet ADBannerView *banner;

@end
