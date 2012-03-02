// 
//  TimeSchedule.m
//  UCIMobile
//
//  Created by Yoon Lee on 6/26/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import "TimeSchedule.h"


@implementation TimeSchedule 

@dynamic hour1;
@dynamic nameOfPlace;
@dynamic dayOfweek;
@dynamic hour2;
@dynamic phoneCall;

-(NSString *)description {
	return [NSString stringWithFormat:@"\nHOUR1:%@\nHOUR2:%@\nNAMEOFPLACE:%@\nDAYOFWEEK:%@\nPHONECALL:%@", self.hour1, self.hour2, self.nameOfPlace, self.dayOfweek, self.phoneCall];
}
@end
