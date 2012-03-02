//
//  UCIRSSReader.h
//  UCIMobile
//
//  Created by Yoon Lee on 8/10/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UCIRSSReader : NSObject <NSXMLParserDelegate>
{
	//array content of items
	NSMutableArray *items;
	//item contents
	NSDictionary *item;
	
	//hold for keys of dictionary
	NSString *keyholder;
	BOOL itemFound;
	BOOL signalToAdd;
}

@property(nonatomic, retain) NSMutableArray *items;
@property(nonatomic, retain) NSDictionary *item;
@property(nonatomic, retain) NSString *keyholder;

@end
