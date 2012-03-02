// 
//  Updates.m
//  UCIMobile
//
//  Created by Yoon Lee on 6/26/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import "Updates.h"


@implementation Updates 

@dynamic storedDate;
@dynamic isUpdated_;

-(NSString *)description {
	return [NSString stringWithFormat:@"%@ %@", [self.storedDate description], [self.isUpdated_ description]];
}
@end
