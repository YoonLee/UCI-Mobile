//
//  DataSource.m
//  UCIMobile
//
//  Created by Yoon Lee on 6/17/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "DataSource.h"
#import "SynthesizeSingleton.h"

@implementation DataSource

SYNTHESIZE_SINGLETON_FOR_CLASS(DataSource);

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		dataPages = [[NSArray alloc] initWithObjects:
					 [NSDictionary dictionaryWithObjectsAndKeys:
					  @"Page 1", @"pageName",
					  @"Some text for page 1", @"pageText",
					  nil],
					 [NSDictionary dictionaryWithObjectsAndKeys:
					  @"Page 2", @"pageName",
					  @"Some text for page 2", @"pageText",
					  nil],
					 [NSDictionary dictionaryWithObjectsAndKeys:
					  @"Page 3", @"pageName",
					  @"Some text for page 3", @"pageText",
					  nil],
					 [NSDictionary dictionaryWithObjectsAndKeys:
					  @"Page 4", @"pageName",
					  @"Some text for page 4", @"pageText",
					  nil],
					 [NSDictionary dictionaryWithObjectsAndKeys:
					  @"Page 5", @"pageName",
					  @"Some text for page 5", @"pageText",
					  nil],
					 nil];
	}
	return self;
}

- (NSInteger)numDataPages
{
	return [dataPages count];
}

- (NSDictionary *)dataForPage:(NSInteger)pageIndex
{
	return [dataPages objectAtIndex:pageIndex];
}

@end

