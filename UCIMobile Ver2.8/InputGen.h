//
//  InputGen.h
//  UCIMobile
//
//  Created by Yoon Lee on 12/20/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InputGen : NSObject 
{
	NSManagedObjectContext *managedContext;
}

- (void) setSchedule;
- (id) initWithContext:(NSManagedObjectContext *) context;
@end
