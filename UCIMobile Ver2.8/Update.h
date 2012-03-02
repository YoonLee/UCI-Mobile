//
//  Update.h
//  UCIMobile
//
//  Created by Yoon Lee on 6/25/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Update :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * isUpdated_;
@property (nonatomic, retain) NSNumber * isAvailable;
@property (nonatomic, retain) NSString * contents;
@property (nonatomic, retain) NSString * attribute;

@end



