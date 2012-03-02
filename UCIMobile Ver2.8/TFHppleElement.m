//
//  TFHppleElement.m
//  Hpple
//
//  Created by Geoffrey Grosenbach on 1/31/09.
//
//  Copyright (c) 2009 Topfunky Corporation, http://topfunky.com
//
//  MIT LICENSE
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "TFHppleElement.h"

NSString * const TFHppleNodeContentKey           = @"nodeContent";
NSString * const TFHppleNodeNameKey              = @"nodeName";
NSString * const TFHppleNodeAttributeArrayKey    = @"nodeAttributeArray";
NSString * const TFHppleNodeAttributeNameKey     = @"attributeName";
NSString * const TFHppleNodeChildArray = @"nodeChildArray";

@implementation TFHppleElement
@synthesize isException;

- (void) dealloc
{
	[node release];
	
	[super dealloc];
}

- (id) initWithNode:(NSDictionary *) theNode
{
	if (!(self = [super init]))
		return nil;
	
	[theNode retain];
	node = theNode;
	
	return self;
}

- (NSArray*)childArray {
	id dicts = [node objectForKey:TFHppleNodeChildArray];
	NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
	
	TFHppleElement* temp;
	//if(![dicts isKindOfClass:[NSDictionary class]]){ return nil;}
	
	for(NSDictionary* dict in dicts){
		temp = [[TFHppleElement alloc] initWithNode:dict];
		[result addObject:temp];
		[temp release];
	}
	
	return result;
}

- (NSString *) content
{
	return [node objectForKey:TFHppleNodeContentKey];
}


- (NSString *) tagName
{
	return [node objectForKey:TFHppleNodeNameKey];
}

- (NSDictionary *) attributes
{
	NSMutableDictionary * translatedAttributes = [NSMutableDictionary dictionary];
	for (NSDictionary * attributeDict in [node objectForKey:TFHppleNodeAttributeArrayKey]) {
		@try {
			[translatedAttributes setObject:[attributeDict objectForKey:TFHppleNodeContentKey]
									 forKey:[attributeDict objectForKey:TFHppleNodeAttributeNameKey]];		
		}
		@catch (NSException * e) {
			isException = YES;
			NSLog(@"CAUGHT EXCEPTION");

			return node;
		}
	}
	
	return translatedAttributes;
}

- (NSString *) objectForKey:(NSString *) theKey
{
	NSString *store = @"";
	
	if (isException) {
		@try {
			store = [[node objectForKey:TFHppleNodeAttributeArrayKey] description];
			
			NSScanner *scan = [NSScanner scannerWithString:store];
			
			[scan scanUpToString:@"http://" intoString:nil];
			[scan scanUpToString:@"\";" intoString:&store];
		}
		@catch (NSException * e) {
			NSLog(@"SECONDARY EXCEPTION CAUSED");
		}

	}
	else {
		store = [[self attributes] objectForKey:theKey];
	}
	
	return store;
}

- (int) count 
{
	return [node count];
}

- (id) description
{
	return [node description];
}

- (BOOL) hasNextValue 
{
	return [[self attributes] objectForKey:@"value"] == nil;
}

- (BOOL) hasNextContent
{
	return [[self attributes] objectForKey:@"nodeContent"] == nil;
}

- (BOOL) findBUSkey:(NSString *) theKey
{
	return NO;
}

@end
