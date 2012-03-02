//
//  SplashUCI.h
//  MyUCI
//
//  Created by Yoon Lee on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SplashDelegate
@required
- (void) didTriggerHasBeenDone:(BOOL)isDone withSplashViewController:(UIViewController *)pullView;

@end

@interface SplashUCI : UIViewController 
{
	IBOutlet UIImageView *imageview;
    
    id<SplashDelegate> delegate;
}
@property(nonatomic, retain) id<SplashDelegate> delegate;
@property(nonatomic, retain) IBOutlet UIImageView *imageview;

@end
