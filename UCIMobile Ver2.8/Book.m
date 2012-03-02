//
//  Book.m
//  UCIMobile
//
//  Created by Yoon Lee on 6/11/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "Book.h"

@implementation Book
@synthesize imgURL;
@synthesize title, author, publisher;
@synthesize status;
@synthesize location;
@synthesize language, floor;

@synthesize resourceImage;
@synthesize summary;
@synthesize urlInfo;
@synthesize bigimgURL, callNumber;
@synthesize left, oCLCs, iSBN;

- (NSString *) description {
	return [NSString stringWithFormat:@"\nBOOKURL:%@\nURL:%@\nBIGURL:%@\nTITLE: %@\nAUTHOR: %@\nPUBLISHER: %@\nSTATUS: %@\nLOCATION: %@\nLANGUAGE: %@\nCALLNUM: %@\nSUMMARY: %@\nFLOOR: %@\nOCLC: %@\nISBN: %@",urlInfo ,imgURL, bigimgURL,title, author, publisher, status, location, language, callNumber, summary, floor, oCLCs, iSBN];
}

- (void) dealloc {
	[iSBN release];
	iSBN = nil;
	[oCLCs release];
	oCLCs = nil;
	[floor release];
	floor = nil;
	[callNumber release];
	callNumber = nil;
	[bigimgURL release];
	bigimgURL = nil;
	[urlInfo release];
	urlInfo = nil;
	[imgURL release];
	imgURL = nil;
	[title release];
	title = nil;
	[author release];
	author = nil;
	[publisher release];
	publisher = nil;
	[status release];
	status = nil;
	[location release];
	location = nil;
	[language release];
	language = nil;
	[summary release];
	summary = nil;
	[resourceImage release];
	resourceImage = nil;
	[super dealloc];
}
@end
