//
//  BookCellController.h
//  UCIMobile
//
//  Created by Yoon Lee on 6/12/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BookCellController : UITableViewCell {
	IBOutlet UILabel *_titles;
	IBOutlet UILabel *author;
	IBOutlet UILabel *language;
	IBOutlet UILabel *publisher;
	IBOutlet UIImageView *frontCover;
	
	IBOutlet UILabel *standBy;

	IBOutlet UILabel *decoy1;
	IBOutlet UILabel *decoy2;
	IBOutlet UIActivityIndicatorView *indicatorCircle;
}

@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorCircle;
@property(nonatomic, retain) IBOutlet UIImageView *frontCover;
@property(nonatomic, retain) IBOutlet UILabel *_titles;
@property(nonatomic, retain) IBOutlet UILabel *author;
@property(nonatomic, retain) IBOutlet UILabel *language;
@property(nonatomic, retain) IBOutlet UILabel *publisher;
@property(nonatomic, retain) IBOutlet UILabel *standBy;

@property(nonatomic, retain) IBOutlet UILabel *decoy1;
@property(nonatomic, retain) IBOutlet UILabel *decoy2;

@end
