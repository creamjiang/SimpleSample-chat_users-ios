//
//  SplashController.m
//  SimpleSample-users-ios
//
//  Created by Danil on 04.10.11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "SplashController.h"

#import "AppDelegate.h"

@implementation SplashController
@synthesize wheel = _wheel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)dealloc
{
	[super dealloc];
}

- (void)viewDidUnload{
    self.wheel = nil;

    [super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Create extended application authorization request (for push notifications)
    QBASessionCreationRequest *extendedAuthRequest = [[QBASessionCreationRequest alloc] init];
	extendedAuthRequest.devicePlatorm = DevicePlatformiOS;
	extendedAuthRequest.deviceUDID = [[UIDevice currentDevice] uniqueIdentifier];
    
    // QuickBlox application authorization
	[QBAuth createSessionWithExtendedRequest:extendedAuthRequest delegate:self];
}

- (void)hideSplash
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kQBApplicationDidAuth object:nil];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark ActionStatusDelegate

- (void)completedWithResult:(Result *)result{
    
    if([result isKindOfClass:[QBAAuthSessionCreationResult class]]){
        if(result.success){
            [self performSelector:@selector(hideSplash) withObject:nil afterDelay:0.5];
        }
    }
}

@end