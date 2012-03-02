//
//  SelectedAcademicScheduleController.h
//  MyUCI
//
//  Created by Yoon Lee on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface SelectedAcademicScheduleController : UITableViewController <UITableViewDelegate>{
	NSMutableArray *recievedInformation;
	int byPassRowNumber;
}
@property(nonatomic, retain) NSMutableArray *recievedInformation;
@property(nonatomic) int byPassRowNumber;

@end
