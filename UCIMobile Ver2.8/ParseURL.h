//
//  ParseURL.h
//  Login
//
//  Created by Yoon Lee on 2/8/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "FinalInfo.h"
#import "ClassInfo.h"

@interface ParseURL : NSObject 
{
	//Client's default log-in identify and password
	NSString *UCINetid;
	NSString *passwd;
	
	//Direct address for uci webauth
	NSURL *url_auth;
	
	//Direct address for student access
	NSURL *url_list;
	
	BOOL badIDnPasswd;
	//Map the Class Schedule
	//@private
	NSMutableArray *dba_schedule;
	NSMutableArray *dba_final;
	NSManagedObjectContext *context;
	
	FinalInfo *finalInfo;
	ClassInfo *classInfo;
}

@property(nonatomic, retain) NSString *UCINetid;
@property(nonatomic, retain) NSString *passwd;
@property(nonatomic, retain) NSURL *url_auth;
@property(nonatomic, retain) NSURL *url_list;
@property(nonatomic, retain) NSMutableArray *dba_schedule;
@property(nonatomic, retain) NSMutableArray *dba_final;
@property(nonatomic, retain) NSManagedObjectContext *context;
//gatters log-in to the UCI-server
- (BOOL) requestToLogin;

//debug purpose: displays after log-in current source-code but also used for parse the proper quarter schedule
- (NSString *) viewableSourceAfterLogin;

- (void) addCourseContents:(NSString *)contents withOrder:(int)order withStatus:(BOOL)isFinal;
- (BOOL) loadCourseContents:(BOOL)isFinal;
- (void) removeCourseContents:(BOOL)isFinal withEraseAll:(BOOL)forALL;

- (BOOL) mainParser;
- (void) filtersOutFinalandRest:(NSString *)chunkEachQuarter;
@end
