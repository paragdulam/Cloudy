//
//  AppDelegate.m
//  Cloudy
//
//  Created by Parag Dulam on 23/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize dropboxSession;
@synthesize liveConnectClient;
@synthesize callBackViewController;

-(BOOL) application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            //auth Done
            if (![[[[url absoluteString] componentsSeparatedByString:@"/"] lastObject] isEqualToString:@"cancel"]) {
                [callBackViewController authenticationDoneForSession:[DBSession sharedSession]];
                return YES;
            } else {
                [callBackViewController authenticationCancelledManuallyForSession:[DBSession sharedSession]];
                return NO;
            }
        }
    }
    return NO;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    DDMenuController *menuController = [[DDMenuController alloc] init];
    CLAccountsTableViewController *leftbaseViewController = [[CLAccountsTableViewController alloc] init];
    UINavigationController *leftNavController = [[UINavigationController alloc] initWithRootViewController:leftbaseViewController];
    
    CLBrowserTableViewController *rootbaseViewController = [[CLBrowserTableViewController alloc] init];
    UINavigationController *rootNavController = [[UINavigationController alloc] initWithRootViewController:rootbaseViewController];

    menuController.leftViewController = leftNavController;
    menuController.rootViewController = rootNavController;
    self.window.rootViewController = menuController;
    
    
    DBSession *session = [[DBSession alloc] initWithAppKey:DROPBOX_APP_KEY
                                                 appSecret:DROPBOX_APP_SECRET_KEY
                                                      root:kDBRootDropbox];
    session.delegate = self;
    self.dropboxSession = session;
    [DBSession setSharedSession:dropboxSession];
    
    LiveConnectClient *client = [[LiveConnectClient alloc] initWithClientId:SKYDRIVE_CLIENT_ID delegate:self];
    self.liveConnectClient = client;
    
    [CLCacheManager initialSetup];

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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - DBSessionDelegate

- (void)sessionDidReceiveAuthorizationFailure:(DBSession *)session userId:(NSString *)userId
{
    
}


#pragma mark - LiveAuthDelegate


- (void) authCompleted: (LiveConnectSessionStatus) status
               session: (LiveConnectSession *) session
             userState: (id) userState
{
    NSLog(@"authCompleted");
}

// This is invoked when the original method call fails.
- (void) authFailed: (NSError *) error
          userState: (id)userState
{
    NSLog(@"authFailed");
}


@end
