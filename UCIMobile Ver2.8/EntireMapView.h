//
//  EntireMapView.h
//  MyUCI
//
//  Created by Yoon Lee on 3/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
typedef enum _DOKDO {
	DOKDO = 134
}DOKDOS;

@interface EntireMapView : UIViewController <UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIAlertViewDelegate>{
	NSManagedObjectContext *managedObjectContext;
	NSMutableArray *storeEntireMap;
	NSMutableArray *filteredContents;
	
	NSString *savedSearchTerm;
	NSInteger savedScopeButtonIndex;
	BOOL searchWasActive;
	
	IBOutlet UITableView *_tableView;
}
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSMutableArray *storeEntireMap;
@property(nonatomic, retain) NSMutableArray *filteredContents;

@property(nonatomic, retain) NSString *savedSearchTerm;
@property(nonatomic) BOOL searchWasActive;
@property(nonatomic) NSInteger savedScopeButtonIndex;
@property(nonatomic, retain) IBOutlet UITableView *_tableView;
- (void)fetchTheMap;

@end
