//
//  SplashController.h
//  SimpleSample-users-ios
//
//  Created by Danil on 04.10.11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

@interface SplashController : UIViewController <ActionStatusDelegate>{
}
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *wheel;

- (void)hideSplash;

@end