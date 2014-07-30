//
//  JKAppDelegate.m
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKAppDelegate.h"
#import "JKHomeViewController.h"
#import <GoogleAnalytics-iOS-SDK/GAI.h>

static NSString *const kTrackingPreferenceKey = @"allowTracking";
static NSString *const kTrackingDay = @"kTrackingDay";
static NSString * const kGiftUserDefault = @"kGiftUserDefault";

@interface JKAppDelegate()
<
FacebookManagerDelegate
>

@property (strong, nonatomic) JKNavigationViewController *navController;

@end

@implementation JKAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [JKReachabilityManager sharedInstance];

    [MagicalRecord setupCoreDataStack];
    
    [GMSServices provideAPIKey:SETTINGS_GOOGLE_MAP_API_TOKEN];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NSDictionary *appDefaults = @{kTrackingPreferenceKey: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    if ([[NSDate date] compare:[[NSUserDefaults standardUserDefaults] valueForKey:kTrackingDay]] == NSOrderedAscending) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kGiftUserDefault];
    }
    // User must be able to opt out of tracking
    [GAI sharedInstance].optOut = ![[NSUserDefaults standardUserDefaults] boolForKey:kTrackingPreferenceKey];
    
    [self setUpGoogleAnalytic];
    
    [FacebookManager sharedInstance].delegate = self;
    [[FacebookManager sharedInstance] openSessionWithAllowLoginUI:NO];
    
    [Crittercism enableWithAppID:SETTING_CRITTERCISM_APP_ID];
    
    IIViewDeckController *deckController = [self generateControllerStack];
    self.leftController = deckController.leftController;
    self.centerController = deckController.centerController;
    self.navController = (JKNavigationViewController *)deckController.centerController;

    self.window.rootViewController = deckController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:kTrackingDay];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (IIViewDeckController*)generateControllerStack {
    
    JKLeftMenuViewController* leftController = [[JKLeftMenuViewController alloc] init];
    JKHomeViewController* centralVievController = [[JKHomeViewController alloc] init];
    JKNavigationViewController* centralNavController = [[JKNavigationViewController alloc] initWithRootViewController:centralVievController];
    JKBookmarkViewController* rightController = [[JKBookmarkViewController alloc] init];
    
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:centralNavController leftViewController:leftController rightViewController:rightController];
    
    [deckController setNavigationControllerBehavior:IIViewDeckNavigationControllerIntegrated];
    [deckController setCenterhiddenInteractivity:IIViewDeckCenterHiddenNotUserInteractiveWithTapToCloseBouncing];
    
    deckController.rightSize = 40;
    
    return deckController;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([[NSDate date] compare:[[NSUserDefaults standardUserDefaults] valueForKey:kTrackingDay]] == NSOrderedAscending) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kGiftUserDefault];
    }
    [GAI sharedInstance].optOut = ![[NSUserDefaults standardUserDefaults] boolForKey:kTrackingPreferenceKey];
        
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[FBSession activeSession] close];
    // Saves changes in the application's managed object context before the application terminates.
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:kTrackingDay];
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"JKShop" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"JKShop.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma - Facebook

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

#pragma mark - Helper

+ (JKAppDelegate *)getRootViewController{
    return (JKAppDelegate* )[[[[UIApplication sharedApplication] delegate] window] rootViewController];
}

- (void)showAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"JK Shop"
                                                    message:@"Login to have fully feature supported!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (void)setUpGoogleAnalytic
{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Create tracker instance.
    [[GAI sharedInstance] trackerWithTrackingId:SETTING_GAI_APP_ID];
    
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
}

@end
