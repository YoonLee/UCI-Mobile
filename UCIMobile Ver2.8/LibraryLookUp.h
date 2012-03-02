//
//  LibraryLookUp.h
//  UCIMobile
//
//  Created by Yoon Lee on 6/11/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"
#import <QuartzCore/QuartzCore.h>
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@class BookCellController;

@interface LibraryLookUp : UIViewController<UITableViewDelegate, UISearchBarDelegate, IconDownloaderDelegate, UIScrollViewDelegate> {
	IBOutlet UITableView *_tableView;
	IBOutlet UISearchBar *_searchBar;
	IBOutlet UIView *layerView;
	IBOutlet BookCellController *bookCell;
	IBOutlet UIActivityIndicatorView *indicatorCircle;
	
	NSMutableArray *searchedResults;
	NSMutableDictionary *imageDownloadsInProgress;
	
	int mutableInteger;
	int maximum; 
	BOOL isReachEnd;
	BOOL dontLoadMore;
	BookCellController *copier;
	NSTimer *timer;
}

@property(nonatomic, retain) IBOutlet UITableView *_tableView;
@property(nonatomic, retain) IBOutlet UISearchBar *_searchBar;
@property(nonatomic, retain) NSMutableArray *searchedResults;
@property(nonatomic, retain) IBOutlet UIView *layerView;
@property(nonatomic, retain) IBOutlet BookCellController *bookCell;
@property(nonatomic, retain) BookCellController *copier;
@property(nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

- (BOOL)requestNextBookSearch:(NSString *)withKeywords;
- (BOOL)requestBookSearch:(NSString *)withKeywords;
- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end
