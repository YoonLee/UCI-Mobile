//
//  Book.h
//  UCIMobile
//
//  Created by Yoon Lee on 6/11/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Book : NSObject {
	//Book Class
	//1: IMAGE OF FRONT COVER
	//2: TITLE
	//3: AUTHOR
	//4: PUBLISHER
	//5: STATUS
	//6: LOCATION
	//7: LANGUAGE
	//8: ISBN
	
	NSString *imgURL;
	NSString *title;
	NSString *author;
	NSString *publisher;
	NSString *status;
	NSString *location;
	NSString *language;
	NSString *summary;
	NSString *urlInfo;
	NSString *bigimgURL;
	NSString *callNumber;
	NSString *oCLCs;
	NSString *iSBN;
	UIImage *resourceImage;
	
	NSString *floor;
	BOOL left;
}

@property(nonatomic, retain) NSString *imgURL;
@property(nonatomic, retain) NSString *floor;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *author;
@property(nonatomic, retain) NSString *publisher;
@property(nonatomic, retain) NSString *status;
@property(nonatomic, retain) NSString *location;
@property(nonatomic, retain) NSString *language;
@property(nonatomic, retain) NSString *summary;
@property(nonatomic, retain) NSString *urlInfo;
@property(nonatomic, retain) NSString *bigimgURL;
@property(nonatomic, retain) NSString *callNumber;
@property(nonatomic, retain) NSString *oCLCs;
@property(nonatomic, retain) NSString *iSBN;

@property(nonatomic) BOOL left;
@property(nonatomic, retain) UIImage *resourceImage;

@end
