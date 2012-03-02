//
//  ChooseTheme.h
//  UCIMobile
//
//  Created by Yoon Lee on 12/15/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThingsToDo.h"

@interface ChooseTheme : UITableViewController <UITableViewDelegate>
{
	ThingsToDo *instance;
}

- (void)initThingstoDo:(ThingsToDo *)thingsTodo;

@end
