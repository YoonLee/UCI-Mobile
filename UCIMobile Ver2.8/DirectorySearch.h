//
//  DirectorySearch.h
//  MyUCI
//
//  Created by Yoon Lee on 4/24/10.
//  Copyright 2010 University of California, Irvine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface DirectorySearch : UIViewController <UITableViewDelegate, UISearchBarDelegate> {
	IBOutlet UITableView *_tableView;
	IBOutlet UIView *loadingView;
	IBOutlet UIView *layerView;
	IBOutlet UIProgressView *progressBar;
	IBOutlet UIActivityIndicatorView *indicator;
	IBOutlet UISearchBar *searchBar;
	IBOutlet UILabel *statusText;
	
	NSMutableArray *directoryDB;

	NSTimer *timer;
	BOOL isNoResults;
	BOOL isClicked;

	NSMutableArray *path;
	NSMutableArray *dictionaryObject;
	NSManagedObjectContext *managedObjectContext;
}

@property(nonatomic, retain) IBOutlet UITableView *_tableView;
@property(nonatomic, retain) IBOutlet UIView *loadingView;
@property(nonatomic, retain) IBOutlet UIProgressView *progressBar;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property(nonatomic, retain) IBOutlet UIView *layerView;
@property(nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property(nonatomic, retain) IBOutlet UILabel *statusText;

@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSMutableArray *path;
@property(nonatomic, retain) NSMutableArray *dictionaryObject;

@property(nonatomic) BOOL isClicked;
- (void) requestURL:(NSString *)keywords;

@end
