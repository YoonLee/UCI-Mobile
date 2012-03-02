//
//  UCIRSSReader.m
//  UCIMobile
//
//  Created by Yoon Lee on 8/10/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "UCIRSSReader.h"


@implementation UCIRSSReader
@synthesize items, item, keyholder;

- (id) initWithURL:(NSURL *)url
{
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	parser.delegate = self;
	
	//declare items
	items = [[NSMutableArray alloc] init];
	
	//parsing start at this point
	[parser parse];
	[parser release];
	keyholder = nil;
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	//* hierarchy *//
	
	//items [NSMutableArray]
	//(* has )
	//item [NSMutableDictionary]
	//(* has )
	//strings
	
	if ([elementName isEqualToString:@"item"]) 
	{
		item = [[NSMutableDictionary alloc] init];
		itemFound = YES;
		return;
	}
	else 
	{
		keyholder = nil;
	}
	
	if (itemFound) 
	{
		if ([elementName isEqualToString:@"title"]) 
		{
			keyholder = elementName;
		}
		else if ([elementName isEqualToString:@"link"]) 
		{
			keyholder = elementName;
		}
		else if ([elementName isEqualToString:@"description"]) 
		{
			keyholder = elementName;
		}
		else if ([elementName isEqualToString:@"pubDate"]) 
		{
			keyholder = elementName;
			itemFound = NO;
			signalToAdd = YES;
		}

	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	//every end of item add to items array and release item object
	//item should be lastly found and keyholder should contains the value
	if (signalToAdd) 
	{
		[items addObject:item];
		[item release];
		signalToAdd = NO;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	//hit enabled then reads contents
	if (keyholder) 
	{
		[item setValue:string forKey:keyholder];
		keyholder = nil;
	}
}

- (void)dealloc 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[items release];
    [super dealloc];
}

@end
