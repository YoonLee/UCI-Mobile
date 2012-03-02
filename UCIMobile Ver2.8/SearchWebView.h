//
//  SearchWebView.h
//  UCIMobile
//
//  Created by Yoon Lee on 8/9/10.
//  Copyright 2010 leeyc. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIWebView (SearchWebView) 

- (NSString *)highlightAllOccurencesOfString:(NSString*)str;
- (void)removeAllHighlights;

@end
