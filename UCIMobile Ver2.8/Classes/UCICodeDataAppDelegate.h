//
//  UCICodeDataAppDelegate.h
//  UCICodeData
//
//  Created by Yoon Lee on 3/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "Reachability.h"
#import "UCIAppController.h"
#import "SplashUCI.h"

@interface UCICodeDataAppDelegate : NSObject <UIApplicationDelegate, SplashDelegate> 
{

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
    IBOutlet UIWindow *window;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
- (NSString *)applicationDocumentsDirectory;

@end

