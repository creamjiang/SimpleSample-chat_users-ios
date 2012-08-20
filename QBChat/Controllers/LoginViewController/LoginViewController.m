//
//  LoginViewController.m
//  SimpleSample-chat_users-ios
//
//  Created by Igor Khomenko on 04.10.11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
@synthesize login;
@synthesize password;
@synthesize activityIndicator;

- (void)viewDidUnload{
    [self setLogin:nil];
    [self setPassword:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)next:(id)sender{
     // Authenticate user
    [QBUsers logInWithUserLogin:login.text password:password.text delegate:self context:password.text];
    
    [activityIndicator startAnimating];
}

- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
-(void)completedWithResult:(Result *)result context:(void *)contextInfo{
    
    // QuickBlox user authorization result
    if([result isKindOfClass:[QBUUserLogInResult class]]){

        // Success result
		if(result.success){
            
            QBUUserLogInResult *res = (QBUUserLogInResult *)result;
            
            // Login to Chat
            res.user.password = (NSString *)contextInfo;
			[[QBChat instance] loginWithUser:res.user];
            
            // save current user
            [DataStorage instance].currentUser = res.user;
            
            
            // Register as subscriber for Push Notifications
            [QBMessages TRegisterSubscriptionWithDelegate:self];
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentification successful"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
		
        // show Errors
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                            message:[result.errors description]
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
    
    [activityIndicator stopAnimating];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)_textField{
    [_textField resignFirstResponder];
    [self next:nil];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [password resignFirstResponder];
    [login resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[NSNotificationCenter defaultCenter] postNotificationName:kQBUserDidAuth object:nil];
    [self dismissModalViewControllerAnimated:YES];
}

@end