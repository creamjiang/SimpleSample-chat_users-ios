//
//  AppDelegate.m
//  SimpleSample-chat_users-ios
//
//  Created by Ruslan on 9/18/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "SplashViewController.h"

@implementation AppDelegate
@synthesize navigationController;
@synthesize window = _window;

- (void)dealloc
{
    [navigationController release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set QuickBlox credentials (You must create application in admin.quickblox.com)
    [QBSettings setApplicationID:92];
    [QBSettings setAuthorizationKey:@"wJHdOcQSxXQGWx5"];
    [QBSettings setAuthorizationSecret:@"BTFsj7Rtt27DAmT"];
    //
    // Additional setup
    [QBSettings setRestAPIVersion:@"0.1.1"]; // version of server API
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    MainViewController *mainViewController = [[[MainViewController alloc] init] autorelease];
    [mainViewController setTitle:@"Main menu"];
    mainViewController.navigationController.hidesBottomBarWhenPushed = NO;
    
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:mainViewController] autorelease];
    [self.window setRootViewController:self.navigationController];
    
    // Show Splash
    SplashViewController *splashViewController = [[SplashViewController alloc] init];
    [splashViewController setDelegate:mainViewController];
    [self.navigationController presentModalViewController:splashViewController animated:NO];
    [splashViewController release];
    
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

@end
