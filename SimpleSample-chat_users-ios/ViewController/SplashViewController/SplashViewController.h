//
//  SpalshViewController.h
//  SimpleSample-chat_users-ios
//
//  Created by Ruslan on 9/18/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//
//
// This class creates QuickBlox session in order to use QuickBlox API.
// Then hides splash screen & show main controller that shows how to work
// with QuickBlox Chat module (in particular, how to organize 1-1 chat, multiple chat in room)
//

#import <UIKit/UIKit.h>

@interface SplashViewController : UIViewController<QBActionStatusDelegate>

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void) hideSplash;

@end
