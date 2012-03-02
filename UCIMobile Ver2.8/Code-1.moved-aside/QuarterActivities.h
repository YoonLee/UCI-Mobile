//
//  QuarterActivities.h
//  MyUCI
//
//  Created by Yoon Lee on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface QuarterActivities :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * finalExamination;
@property (nonatomic, retain) NSString * instructionbegin;
@property (nonatomic, retain) NSString * withoutDeanSignature;
@property (nonatomic, retain) NSString * wAfterAssigns;
@property (nonatomic, retain) NSString * quarterRepresent;
@property (nonatomic, retain) NSString * waitlistRelease;

@end



