//
//  UCICodeDataAppDelegate.m
//  UCICodeData
//
//  Created by Yoon Lee on 3/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "UCICodeDataAppDelegate.h"


@implementation UCICodeDataAppDelegate

@synthesize window;
@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{  
	SplashUCI *splash = [[SplashUCI alloc] initWithNibName:@"SplashUCI" bundle:nil];
    [splash setDelegate:self];
    
	//debug
	[managedObjectContext release];
	[window addSubview:splash.view];
    [splash.view setTag:7];
    
	[window makeKeyAndVisible];
}

- (void) didTriggerHasBeenDone:(BOOL)isDone withSplashViewController:(UIViewController *)pullView
{
    if (isDone) 
    {
        UIView *splashedView = (UIView *)[window viewWithTag:7];
        [splashedView removeFromSuperview];
        [pullView release];
        
        UCIAppController *appViewController = [[UCIAppController alloc] initWithNibName:@"UCIMobileAppMain" bundle:nil];
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:appViewController];
        
        [window addSubview:naviController.view];
        [appViewController release];
    }
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application 
{
    NSError *error = nil;
    if (managedObjectContext != nil) 
	{
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) 
		{
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext 
{
	
    if (managedObjectContext != nil) 
	{
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) 
	{
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel 
{
	
    if (managedObjectModel != nil)
	{
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator 
{
	
    if (persistentStoreCoordinator != nil) 
	{
        return persistentStoreCoordinator;
    }
	
	NSString *currentVersion = @"UCIDB1.7.3.sqlite";
	//1:path for current old-sqlite locate
	NSString *storePath = [self.applicationDocumentsDirectory stringByAppendingPathComponent:currentVersion];
	//it would be UCIDB.sqlite->UCIDB1.7.1.sqlite->UCIDB1.7.2.sqlite and so on after the update.
	NSArray *pastVersionContainer = [NSArray arrayWithObjects:@"UCIDB.sqlite", @"UCIDB1.7.1.sqlite", @"UCIDB1.7.2.sqlite", nil];
	
	//NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	BOOL isOldFileExist = NO;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	for (int i=0; i<[pastVersionContainer count]; i++) 
	{
		NSString *contentsStorePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:[pastVersionContainer objectAtIndex:i]];
		if ([fileManager fileExistsAtPath:contentsStorePath]) 
		{
			//set boolean value yes
			//remove found value
			isOldFileExist = YES;
			[fileManager removeItemAtPath:contentsStorePath error:NULL];
		}
	}
	//old file exist and newer file not found
	if (isOldFileExist||![fileManager fileExistsAtPath:storePath]) 
	{
		//here defaultStorePath should have newer name convension.
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"UCIDB1.7.3" ofType:@"sqlite"];
		if (defaultStorePath) 
		{
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	//new file installation detail
	//NSLog(@"%@", storePath);
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) 
	{
		
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory 
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
	[managedObjectContext release];
	[managedObjectModel release];
	[persistentStoreCoordinator release];
	
	[window release];
	[super dealloc];
}


@end

