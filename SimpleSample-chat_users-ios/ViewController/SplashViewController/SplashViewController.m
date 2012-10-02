//
//  SpalshViewController.m
//  SimpleSample-chat_users-ios
//
//  Created by Ruslan on 9/18/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController
@synthesize activityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Your app connects to QuickBlox server here.
    //
    // QuickBlox session creation
    QBASessionCreationRequest *extendedAuthRequest = [[[QBASessionCreationRequest alloc] init] autorelease];
	extendedAuthRequest.devicePlatorm = DevicePlatformiOS;
	extendedAuthRequest.deviceUDID = [[UIDevice currentDevice] uniqueIdentifier];
    
	[QBAuth createSessionWithExtendedRequest:extendedAuthRequest delegate:self];
}

-(void)hideSplash{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [activityIndicator release];
    [super dealloc];
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
- (void)completedWithResult:(Result *)result{
    
    // QuickBlox session creation  result
    if([result isKindOfClass:[QBAAuthSessionCreationResult class]]){
        
        // Success result
        if(result.success){
            
            // hide splash
            [self performSelector:@selector(hideSplash) withObject:nil afterDelay:0.5];
        }
    }
}

@end
