//
//  SearchWebView.m
//  UCIMobile
//
//  Created by Yoon Lee on 8/9/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "SearchWebView.h"


@implementation UIWebView (SearchWebView)

- (NSString *)highlightAllOccurencesOfString:(NSString *)str
{
	if (str.length < 4) 
	{
		return @"0";
	}
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"SearchWebView" ofType:@"js"];
	NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	[self stringByEvaluatingJavaScriptFromString:jsCode];
	
	NSString *startSearch = [NSString stringWithFormat:@"MyApp_HighlightAllOccurencesOfString('%@')",str];
    [self stringByEvaluatingJavaScriptFromString:startSearch];

	NSString *result = [self stringByEvaluatingJavaScriptFromString:@"MyApp_SearchResultCount"];
	
	return result;
}

- (void) removeAllHighlights
{
	[self stringByEvaluatingJavaScriptFromString:@"MyApp_RemoveAllHighlights()"];
}

@end
