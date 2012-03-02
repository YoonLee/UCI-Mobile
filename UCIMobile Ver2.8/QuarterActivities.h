//
//  QuarterActivities.h
//  MyUCI
//
//  Created by Yoon Lee on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface QuarterActivities :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * withoutDeanSignature;
@property (nonatomic, retain) NSString * submitCard;
@property (nonatomic, retain) NSString * payfeeOntime;
@property (nonatomic, retain) NSString * scheduleAvailable;
@property (nonatomic, retain) NSString * enrollelectricly;
@property (nonatomic, retain) NSString * holiday1;
@property (nonatomic, retain) NSString * waitlistRelease;
@property (nonatomic, retain) NSString * instructionbegin;
@property (nonatomic, retain) NSString * holiday2;
@property (nonatomic, retain) NSDate * quarterStarts;
@property (nonatomic, retain) NSString * finalDeadLine;
@property (nonatomic, retain) NSString * breaks;
@property (nonatomic, retain) NSString * quarterRepresent;
@property (nonatomic, retain) NSString * wAfterAssigns;
@property (nonatomic, retain) NSString * finalExamination;

@end



