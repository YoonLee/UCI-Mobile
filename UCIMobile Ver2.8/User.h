//
//  User.h
//  UCICodeData
//
//  Created by Yoon Lee on 3/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface User :  NSManagedObject  {
}

@property (nonatomic, retain) NSString * netID;
@property (nonatomic, retain) NSString * password;

@end



