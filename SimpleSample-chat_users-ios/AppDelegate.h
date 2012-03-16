//
//  AppDelegate.h
//  SimpleSample-chat_users-ios
//
//  Created by Alexey Voitenko on 24.02.12.
//  Copyright (c) 2012 Injoit Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatViewController;
@class SplashController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, ActionStatusDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) SplashController* splashController;
@property (strong, nonatomic) ChatViewController *viewController;

@end
