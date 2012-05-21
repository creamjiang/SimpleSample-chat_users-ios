//
//  AppDelegate.h
//  Users
//
//  Created by Alexey on 21.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

@end
