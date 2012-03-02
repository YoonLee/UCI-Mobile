//
//  ClassInfo.h
//  MyUCI
//
//  Created by Yoon Lee on 4/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface ClassInfo :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * dept;
@property (nonatomic, retain) NSString * quarter;
@property (nonatomic, retain) NSString * instructor;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * num;
@property (nonatomic, retain) NSString * days;
@property (nonatomic, retain) NSNumber * unts;

@end



