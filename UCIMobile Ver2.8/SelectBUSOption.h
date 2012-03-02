//
//  SelectBUSOption.h
//  UCIMobile
//
//  Created by Yoon Lee on 7/25/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectBUSOptionViewControllerDelegate;

@interface SelectBUSOption : UIViewController <UITableViewDelegate>
{
	UITableView *_tableView;
	BOOL clicked;
	id <SelectBUSOptionViewControllerDelegate> delegate;
	
	NSMutableDictionary *cacheRoute;
	
	NSMutableArray *routes;
	NSMutableArray *stops;
	NSDictionary *routePtr;
	NSString *selectedRouteValue;
	IBOutlet UINavigationBar *_naviBar;
	
	int numberOfLines;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *_naviBar;
@property (nonatomic, retain) IBOutlet UITableView *_tableView;
@property (nonatomic, assign) id <SelectBUSOptionViewControllerDelegate> delegate;

@property (nonatomic, retain) NSMutableDictionary *cacheRoute;
@property (nonatomic, retain) NSMutableArray *routes;
@property (nonatomic, retain) NSMutableArray *stops;
@property (nonatomic, retain) NSDictionary *routePtr;

-(IBAction) selectRoute;
- (BOOL) isSummerSeason;
- (BOOL) isEndORStartSummerSession;
- (void) estimateShuttleTime:(UITableView *)tableView selectedIndexPath:(NSIndexPath *)indexPath;
- (void) initWithCurrentSeason;
- (void) leftOverTime:(NSString *)routeValue with:(NSString *)stopValue selectedIndexPath:(NSIndexPath *)indexPath;

@end

@protocol SelectBUSOptionViewControllerDelegate
@required
- (void) preferenceHasBeenFinish:(SelectBUSOption *)configure;

@end