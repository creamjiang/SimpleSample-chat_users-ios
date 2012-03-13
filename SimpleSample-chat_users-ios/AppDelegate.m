//
//  AppDelegate.m
//  SimpleSample-chat_users-ios
//
//  Created by Alexey Voitenko on 24.02.12.
//  Copyright (c) 2012 Injoit Ltd. All rights reserved.
//

#import "AppDelegate.h"

#import "ChatViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

#pragma mark -
#pragma mark ActionStatusDelegate

- (void)completedWithResult:(Result *)result{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if([result isKindOfClass:[QBAAuthSessionCreationResult class]])
    {
        if(result.success)
        {
            NSLog(@"QBAAuthSessionCreationResult, success");
            
            self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
            // Override point for customization after application launch.

                self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
            
            self.window.rootViewController = self.viewController;
            [self.window makeKeyAndVisible];
            
        }
        else
        {
            NSLog(@"QBAAuthSessionCreationResult, errors=%@", result.errors);
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Did not authorized" 
                                                            message:[NSString stringWithFormat:@"%@", result.errors] 
                                                           delegate:nil
                                                  cancelButtonTitle:@"Okey" 
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Auth App
    [QBAuthService authorizeAppId:appID key:authKey secret:authSecret delegate:self];
    
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
