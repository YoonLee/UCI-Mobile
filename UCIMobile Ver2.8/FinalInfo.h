//
//  FinalInfo.h
//  MyUCI
//
//  Created by Yoon Lee on 4/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface FinalInfo :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * fdept;
@property (nonatomic, retain) NSString * fcourse;
@property (nonatomic, retain) NSString * fdate;
@property (nonatomic, retain) NSString * quarter;

@end



