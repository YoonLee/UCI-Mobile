//
//  UCIStudentForever.h
//  MyUCI
//
//  Created by Yoon Lee on 4/17/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#import "SoundEffect.h"
#import "ClassInfo.h"

typedef enum _DayOfWeek 
{
	DayOfWeekSun = 1,
	DayOfWeekSat = 2,
	DayOfWeekFri = 3,
	DayOfWeekThu = 4,
	DayOfWeekWed = 5,
	DayOfWeekTue = 6,
	DayOfWeekMon = 7	
} DayOfWeek;

@interface UCIStudentForever : UITableViewController<UITableViewDelegate> 
{
	//Data Base: Array Holders
	//First, Today's class
	//Second, Entire Today's class
	//Third, Final Exam
	NSMutableArray *today_DB;
	NSArray *whole_DB;
	NSArray *final_DB;
    NSArray *yearAndQuarter;
    
	NSMutableArray *quarter_DB;
	NSMutableArray *curCourse_DB;
	NSMutableArray *curFinal_DB;
	
	UISegmentedControl *segment;
	NSManagedObjectContext *managedObjectContext;
	
	BOOL isFirstLaunch;
	BOOL isQuarterOver;
	NSInteger curQuarterIndex;
	SoundEffect *selectedSound;
}

@property(nonatomic, retain) NSArray *today_DB;
@property(nonatomic, retain) NSArray *whole_DB;
@property(nonatomic, retain) NSArray *final_DB;
@property(nonatomic, retain) UISegmentedControl *segment;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSMutableArray *quarter_DB;

@property(nonatomic, retain) NSMutableArray *curCourse_DB;
@property(nonatomic, retain) NSMutableArray *curFinal_DB;

@property(nonatomic) BOOL isFirstLaunch;
@property(nonatomic) NSInteger curQuarterIndex;

- (NSString *) homepieYearFinder:(ClassInfo *)course;
- (void) segmentManagement;
- (void) compareTodayDayOfWeek;
- (void) entireCourseSchedule;
- (BOOL) fetchRequest;
- (void) lookupQuarterSequence;
- (NSInteger) weekFinder:(NSDate *)startingDate;
- (NSString *) getDayOfTheWeek:(NSDate *)date;
- (NSDate *) seekWeekOperation:(NSInteger)begin withStartDate:(NSDate *)start;
- (NSString *) pluralCheck:(BOOL)isUnit withIntValue:(NSNumber *)number;
- (NSString *) nearleastTodaysClass;
- (void) compareTodayDayOfWeek:(NSString *)whatDay;

@end
