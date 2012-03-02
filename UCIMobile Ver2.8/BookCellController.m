//
//  BookCellController.m
//  UCIMobile
//
//  Created by Yoon Lee on 6/12/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "BookCellController.h"


@implementation BookCellController
@synthesize _titles, author, publisher, language, frontCover;
@synthesize standBy;
@synthesize decoy1, decoy2;
@synthesize indicatorCircle;

- (void)dealloc {
	[decoy1 release];
	decoy1 = nil;
	[decoy2 release];
	decoy2 = nil;
	[standBy release];
	standBy = nil;
	[_titles release];
	_titles = nil;
	[author release];
	author = nil;
	[language release];
	language = nil;
	[publisher release];
	publisher = nil;
    [super dealloc];
}


@end
