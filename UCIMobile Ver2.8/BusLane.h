//
//  BusLane.h
//  MyUCI
//
//  Created by Yoon Lee on 4/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class BusSchedule;
@class BusStop;

@interface BusLane :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * duration1;
@property (nonatomic, retain) NSString * laneName;
@property (nonatomic, retain) NSNumber * duration2;
@property (nonatomic, retain) BusSchedule * responderSchedule;
@property (nonatomic, retain) NSSet* selectedBusStop;

@end


@interface BusLane (CoreDataGeneratedAccessors)
- (void)addSelectedBusStopObject:(BusStop *)value;
- (void)removeSelectedBusStopObject:(BusStop *)value;
- (void)addSelectedBusStop:(NSSet *)value;
- (void)removeSelectedBusStop:(NSSet *)value;

@end

