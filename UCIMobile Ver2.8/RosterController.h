//
//  RosterController.h
//  Smile
//
//  Created by Evgeniy Shurakov on 23.05.09.
//  Copyright 2009 MooN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundEffect.h"
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
@class XMPPClient;

@interface RosterController : UITableViewController <UITableViewDelegate, UITableViewDataSource> 
{
	XMPPClient *xmppClient;	
	NSArray *roster;
	BOOL state;
	
	NSMutableDictionary *allRecieved;
	SoundEffect *selectedSound;
	NSMutableArray *allRecievedChatFromJID;
	NSManagedObjectContext *managedObjectContext;
	// key:JID, value:msgs
@private
	NSMutableDictionary *chatModels;
}

- (void)notification:(NSString *)msg;
@property(nonatomic, retain) NSArray *roster;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@end
