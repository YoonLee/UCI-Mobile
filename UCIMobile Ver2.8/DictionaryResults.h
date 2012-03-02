//
//  DictionaryResults.h
//  MyUCI
//
//  Created by Yoon Lee on 5/4/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface DictionaryResults :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * homepage;
@property (nonatomic, retain) NSString * major;
@property (nonatomic, retain) NSString * ucinetID;
@property (nonatomic, retain) NSString * alphabetIndex;
@property (nonatomic, retain) NSString * officeHRs;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;

@end



