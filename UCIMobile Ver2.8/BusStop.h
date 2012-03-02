//
//  BusStop.h
//  MyUCI
//
//  Created by Yoon Lee on 4/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class BusLane;

@interface BusStop :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * stopID;
@property (nonatomic, retain) NSNumber * y_coordinate;
@property (nonatomic, retain) NSNumber * transferLane;
@property (nonatomic, retain) NSString * representName;
@property (nonatomic, retain) NSDate * midtimelineDB;
@property (nonatomic, retain) NSDate * starttimelineDB;
@property (nonatomic, retain) NSDate * finaltimelineDB;
@property (nonatomic, retain) NSNumber * x_coordinate;
@property (nonatomic, retain) NSString * representDetailName;
@property (nonatomic, retain) NSSet* responderLane;

@end


@interface BusStop (CoreDataGeneratedAccessors)
- (void)addResponderLaneObject:(BusLane *)value;
- (void)removeResponderLaneObject:(BusLane *)value;
- (void)addResponderLane:(NSSet *)value;
- (void)removeResponderLane:(NSSet *)value;

@end

