//
//  DataSource.h
//  UCIMobile
//
//  Created by Yoon Lee on 6/17/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject {
	NSArray *dataPages;
}

+ (DataSource *)sharedDataSource;
- (NSInteger)numDataPages;
- (NSDictionary *)dataForPage:(NSInteger)pageIndex;

@end