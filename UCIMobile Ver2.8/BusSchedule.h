//
//  BusSchedule.h
//  MyUCI
//
//  Created by Yoon Lee on 4/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class BusLane;

@interface BusSchedule :  NSManagedObject  
{
}

@property (nonatomic, retain) BusLane * representsBusLane;

@end



