//
//  ParseURL.m
//  Login
//
//  Created by Yoon Lee on 2/8/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

//To Do: Add Error exception
#import "ParseURL.h"
#import "ClassInfo.h"

@implementation ParseURL
@synthesize UCINetid;
@synthesize	passwd;
@synthesize url_auth;
@synthesize url_list;
@synthesize dba_schedule;
@synthesize dba_final;
@synthesize context;

//deallocates the pointers
- (void) dealloc 
{
	[context release];
	[url_auth release];
	[url_list release];
	[dba_schedule release];
	[dba_final release];
	[UCINetid release];
	[passwd release];
	[super dealloc];
}

//gatters log-in to the UCI-server
- (BOOL) requestToLogin
{	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: url_auth];
	//total 8 input exist
	[request setPostValue: @"http%3A%2F%2Fwww.reg.uci.edu%2Faccess%2Fstudent%2Fstudylist%2F%3Fseg%3DU" forKey: @"referer"];
	[request setPostValue: @"http%3A%2F%2Fwww.reg.uci.edu%2Faccess%2Fstudent%2Fstudylist%2F%3Fseg%3DU" forKey: @"return_url"];
	[request setPostValue: @"" forKey: @"info_text"];
	[request setPostValue: @"" forKey: @"info_url"];
	[request setPostValue: @"" forKey: @"submit_type"];
	
	[request setPostValue: UCINetid forKey: @"ucinetid"];
	[request setPostValue: passwd forKey: @"password"];
	[request setPostValue: @"Login" forKey: @"login_button"];
	[request startSynchronous];
	NSError *error = [request error];
	
	return !error?YES:NO;
}

//debug purpose: displays after log-in current source-code but also used for parse the proper quarter schedule
-(NSString *) viewableSourceAfterLogin 
{
	NSString *src;
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL: url_list];
	[request startSynchronous];
	NSError *error = [request error];
	
	//chk error state
	if (!error) 
		src = [request responseString];
	
	else 
		src = @"request caused error";
	//then you logout
	NSURL *url = [NSURL URLWithString:@"https://login.uci.edu/ucinetid/webauth_logout"];
	ASIFormDataRequest *logout = [ASIFormDataRequest requestWithURL:url];
	[logout startSynchronous];
	 
	return src;
}

- (BOOL) mainParser 
{
	//resetting method.
	//load core data, if data exist
	//then it wipes out.
	//since user click on the login button intend to 
	//access the system to update the course schedule
	//therefore deletion required.
	[self loadCourseContents:YES];
	[self loadCourseContents:NO];
	//gets the logined html code.
	NSString *chunkByEntireQuarter = [self viewableSourceAfterLogin];
	NSScanner *mainscan = [NSScanner scannerWithString:chunkByEntireQuarter];
	
	//if DBExist returns nil, which means database don't exist.
	//at this we may assume student entered incorrect key value such as password
	//and wrong password.
	NSString *isDBExist = nil;
	[mainscan scanUpToString:@"jumper" intoString:nil];
	[mainscan scanUpToString:@"Jump:" intoString:&isDBExist];
	if (!isDBExist) 
	{
		return NO;
	}
	//read until it reaches through end of document
	while (![mainscan isAtEnd]) 
	{
		//first, read until it reaches first '(fieldset)' and set to be nil
		[mainscan scanUpToString:@"<fieldset" intoString:nil];
		//gets the each quarter schedule that include final exam if exist
		NSString *chunkByEachQuarter = nil;
		[mainscan scanUpToString:@"</fieldset>" intoString:&chunkByEachQuarter];
		//send to method to filters out final exam if exist and schedules
		if (chunkByEachQuarter) 
		{
			[self filtersOutFinalandRest:chunkByEachQuarter];
		}
	}
	return YES;
} 

- (void) filtersOutFinalandRest:(NSString *)chunkEachQuarter 
{
	int i = 0;
	
	NSCharacterSet *toBeSkiped = [NSCharacterSet characterSetWithCharactersInString: @">"];
	NSScanner *scan = [NSScanner scannerWithString:chunkEachQuarter];
	//read until it reaches 'Enrolled Classes' set to be nil
	NSString *quarter;
	//read until it reaches "\>" set
	//then we need to read up to character '>'
	//but pointer still points to that we need to skip it.
	//so we add extra step to skip for that character to read out clear.
	[scan scanUpToString:@"\">" intoString:nil];
	[scan scanUpToCharactersFromSet:toBeSkiped intoString:nil];
	[scan setCharactersToBeSkipped:toBeSkiped];
	//now pointer of scan is locate after ">"
	//we need to read until tag reaches </a> to read out quarter.
	[scan scanUpToString:@"</a>" intoString:&quarter];
	
	//reinitiate
	scan = [NSScanner scannerWithString:chunkEachQuarter];

	//at this point we need to save final exam if it exist
	//read until through identity of final exam.
	NSString *pureSchedule = nil;
	[scan scanUpToString:@"Total" intoString:&pureSchedule];
	
	NSString *reallyEmpty = nil;
	[scan scanUpToString:@"Class Finals" intoString:&reallyEmpty];
	if (!reallyEmpty) 
	{
		return;
	}
	NSString *finalExamRef = nil;
	//if final exam exist
	//then read it
	[scan scanUpToString:@"backToTop" intoString:&finalExamRef];
	if (finalExamRef)
	{
		//load method to do final parse
		NSScanner *finalScanner = [NSScanner scannerWithString:finalExamRef];
		NSString *finalExamDate = @"";
        
		while (![finalScanner isAtEnd]) 
		{
			[finalScanner scanUpToString:@"<td>" intoString:nil];
			[finalScanner scanUpToCharactersFromSet: toBeSkiped intoString: nil];
			[finalScanner setCharactersToBeSkipped: toBeSkiped];
			
			if ([finalScanner scanUpToString:@"</td>" intoString:&finalExamRef]) 
			{
				finalExamRef = [finalExamRef stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
				
				//adding final exam schedule to managed object
                switch (i) 
                {
                    case 1:
                    case 2:
                        [self addCourseContents:finalExamRef withOrder:i withStatus:YES];
                        break;
                    case 3:
                        finalExamDate = finalExamRef;
                        
                        for (int k = 0; k < 2; k ++) 
                        {
                            [finalScanner scanUpToString:@"<td>" intoString:nil];
                            [finalScanner scanUpToCharactersFromSet: toBeSkiped intoString: nil];
                            [finalScanner setCharactersToBeSkipped: toBeSkiped];
                            
                            [finalScanner scanUpToString:@"</td>" intoString:&finalExamRef];
                            finalExamRef = [finalExamRef stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                            
                            finalExamDate = [NSString stringWithFormat:@"%@ %@", finalExamDate, finalExamRef];
                        }
                        [self addCourseContents:finalExamDate withOrder:i withStatus:YES];
                        break;
                    case 4:
                        [self addCourseContents:quarter withOrder:83 withStatus:YES];
                        i = 0;
                        break;
                }
                
				i++;
			}
		}
	}
	if (finalExamRef) 
    {
		//now move back to the pointer where it was
		scan = [NSScanner scannerWithString:pureSchedule];
	}
	else 
    {
		scan = [NSScanner scannerWithString:chunkEachQuarter];
	}
	
	//custom
	NSString *element;
	NSString *nextLine;
	
	while(![scan isAtEnd])
	{
		int j = 12;
		
		if([scan scanUpToString:@"valign=\"top\"" intoString:nil]) 
		{
			[scan scanUpToCharactersFromSet:toBeSkiped intoString:nil];
			[scan setCharactersToBeSkipped: toBeSkiped];
			[scan scanUpToString:@"<tr " intoString:&nextLine];
			
			NSScanner *scan1 = [NSScanner scannerWithString:nextLine];
			
			while(j>0) 
            {				
				[scan1 scanUpToString:@"<td>" intoString:nil];
				[scan1 scanUpToCharactersFromSet: toBeSkiped intoString: nil];
				[scan1 setCharactersToBeSkipped: toBeSkiped];
				[scan1 scanUpToString:@"</td>" intoString: &element];
				
				NSRange range = [element rangeOfString:@"<tr><td>"];
				
				if(range.location != NSNotFound) 
                {
					NSScanner *inner_scan = [NSScanner scannerWithString: element];
					//now do the substring
					[inner_scan scanUpToCharactersFromSet:toBeSkiped intoString:nil];
					[inner_scan setCharactersToBeSkipped: toBeSkiped];
					[inner_scan scanUpToCharactersFromSet:toBeSkiped intoString:nil];
					[inner_scan setCharactersToBeSkipped: toBeSkiped];
					[inner_scan scanUpToCharactersFromSet:toBeSkiped intoString:nil];
					[inner_scan setCharactersToBeSkipped: toBeSkiped];
					
					[inner_scan scanUpToString:@"" intoString:&element];
					if (j==3) {
					NSArray *comps = [element componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
					element = [comps componentsJoinedByString:@""];
					}

					else 
                    {
						element = [element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
					}
				}
				[self addCourseContents:element withOrder:j withStatus:NO];
				//back to the original place for the iterate
				j--;
			}
			[self addCourseContents:quarter withOrder:83 withStatus:NO];
		}
	}
}

- (void) addCourseContents:(NSString *)contents withOrder:(int)order withStatus:(BOOL)isFinal 
{
	//현제 하나밖에 안쓸거이기 때문에...
	//로드를 해노쿠... (그래야 로드하면서 배열 숫자가 잡힘.)
	//로드하는 숫자가 1이상이 아닐때만...애드 가능하도록 
	//모이런 심플한 메커니즘...
	NSError *error;
	//모델링에 카피	
	if (isFinal) 
    {
		//final exam entity object setting part
		if(!dba_final) 
        {
			dba_final = [[NSMutableArray alloc] init];
		}
		
		switch (order) 
		{
			case 1:
				//at the begining of reading final exam information,
				//it needs to create instance object
				finalInfo= (FinalInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"FinalInfo" inManagedObjectContext:context];
				[finalInfo setFdept:contents];
				break;
			case 2:
				[finalInfo setFcourse:contents];
				break;
			case 3:
				//at the end, it needs to store entity contents
				//in the arraylist.
				//* save with corresponds year term 
				[finalInfo setFdate:contents];
				break;
			case 83:
				[finalInfo setQuarter:contents];
				[dba_final addObject:finalInfo];
				if([context save:&error]) 
                {
					
				}
				break;
				
		}
	}
	else 
	{
		if (!dba_schedule) 
		{
			dba_schedule = [[NSMutableArray alloc] init];
		}
		NSNumberFormatter *f = nil;
        NSArray *arrayComponent = nil;
        NSScanner *scan = nil;
		//reqular course object setting
		switch (order) 
		{
			case 1:
				[classInfo setInstructor:contents];
				break;
			case 2:
				[classInfo setLocation:contents];
				break;
			case 3:
				[classInfo setTime:contents];
				break;
			case 4:
                arrayComponent = [contents componentsSeparatedByString:@"&nbsp;"];
                contents = @"";
                for (NSString *str in arrayComponent) 
                {
                    if (![str isEqualToString:@""]) 
                    {
                        contents = [NSString stringWithFormat:@"%@ %@", contents, str];
                    }
                }
                
				[classInfo setDays:contents];
				break;
			case 5:
				//[classInfo setOpt:contents];
				break;
			case 6:
				f = [[NSNumberFormatter alloc] init];
				[f setNumberStyle:NSNumberFormatterDecimalStyle];
				[classInfo setUnts:[f numberFromString:contents]];
				[f release];
				break;
			case 7:
				//[classInfo setSec:contents];
				break;
			case 8:
				[classInfo setType:contents];
				break;
			case 9:
				[classInfo setTitle:contents];
				break;
			case 10:
				[classInfo setNum:contents];
				break;
			case 11:
				[classInfo setDept:contents];
				break;
			case 12:
				classInfo= (ClassInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"ClassInfo" inManagedObjectContext:context];
                 scan = [NSScanner scannerWithString:contents];
                [scan setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@">"]];
                [scan scanUpToString:@">" intoString:nil];
                [scan scanUpToString:@"<" intoString:&contents];
                contents = [contents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				[classInfo setCode:contents];
				break;
				//my identity 83 wa haha
			case 83:
				[classInfo setQuarter:contents];
				[dba_schedule addObject:classInfo];
				if([context save:&error]) 
                {
					
				}
				break;
		}
	}
}

- (BOOL) loadCourseContents:(BOOL)isFinal 
{
	if(isFinal) 
    {
		NSFetchRequest *requestFinal = [[NSFetchRequest alloc] init];
		NSEntityDescription *fEntity = [NSEntityDescription entityForName:@"FinalInfo" inManagedObjectContext:context];
		[requestFinal setEntity:fEntity];
		NSError *error = nil;
		//Loading
		self.dba_final = [[self.context executeFetchRequest:requestFinal error:&error] mutableCopy];
		[dba_final release];
		//if fetched value exist
		//means, it needs to delete the entire data
		//if it is not, then good to go just add it.
		if([dba_final count] > 0) 
			[self removeCourseContents:YES withEraseAll:YES];
		
		[requestFinal release];
		return [dba_final count]>0?YES:NO;
	}
	else 
    {
		NSFetchRequest *requestCourse = [[NSFetchRequest alloc] init];
		NSEntityDescription *cEntity = [NSEntityDescription entityForName:@"ClassInfo" inManagedObjectContext:context];
		
		[requestCourse setEntity:cEntity];
		NSError *error = nil;
		[self setDba_schedule:[[context executeFetchRequest:requestCourse error:&error] mutableCopy]];
		
		if([dba_schedule count] > 0) {
			[self removeCourseContents:NO withEraseAll:YES];
		} 
		
		[requestCourse release];
		return [dba_schedule count]>0?YES:NO;
	}
}

- (void) removeCourseContents:(BOOL)isFinal withEraseAll:(BOOL)forALL
{
	NSError *error = nil;
	if (isFinal) 
    {
		NSFetchRequest *requestFinal = [[NSFetchRequest alloc] init];
		NSEntityDescription *fEntity = [NSEntityDescription entityForName:@"FinalInfo" inManagedObjectContext:context];
		[requestFinal setEntity:fEntity];
		
		
		NSMutableArray *fHolder = [[context executeFetchRequest:requestFinal error:&error] mutableCopy];
		for(int i=0;i<[fHolder count];i++) 
        {
			[context deleteObject:[dba_final objectAtIndex:i]];
			[context save:&error];
		}
        
		dba_final = [[context executeFetchRequest:requestFinal error:&error] mutableCopy];
		
		[fHolder release];
		[requestFinal release];
	}
	else 
    {
		NSFetchRequest *requestCourse = [[NSFetchRequest alloc] init];
		NSEntityDescription *cEntity = [NSEntityDescription entityForName:@"ClassInfo" inManagedObjectContext:context];
		[requestCourse setEntity:cEntity];
		;
		NSError *error = nil;
		NSMutableArray *courseHolder = [[context executeFetchRequest:requestCourse error:&error] mutableCopy];
		
		for(int i=0;i<[courseHolder count];i++) {
			[context deleteObject:[dba_schedule objectAtIndex:i]];
		}
		
		dba_schedule = [[context executeFetchRequest:requestCourse error:&error] mutableCopy];
		
		[courseHolder release];
		[requestCourse release];
	}
	[context save:&error];
}

@end
