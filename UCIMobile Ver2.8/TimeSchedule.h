//
//  TimeSchedule.h
//  UCIMobile
//
//  Created by Yoon Lee on 6/26/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface TimeSchedule :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * hour1;
@property (nonatomic, retain) NSString * nameOfPlace;
@property (nonatomic, retain) NSString * dayOfweek;
@property (nonatomic, retain) NSString * hour2;
@property (nonatomic, retain) NSString * phoneCall;

@end



