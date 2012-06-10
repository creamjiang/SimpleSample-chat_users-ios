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

- (void)dealloc
{
    [login release];
    [password release];
    [activityIndicator release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setLogin:nil];
    [self setPassword:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)next:(id)sender
{
    QBUUser *qbUser = [[QBUUser alloc] init];      
    qbUser.login = login.text;
	qbUser.password = password.text;
    
    // authenticate
    [QBUsersService authenticateUser:qbUser delegate:self];
    
    [qbUser release];
    
    [activityIndicator startAnimating];
}

- (IBAction)back:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark ActionStatusDelegate

-(void)completedWithResult:(Result *)result
{
    if([result isKindOfClass:[QBUUserAuthenticateResult class]])
    {
		QBUUserAuthenticateResult *res = (QBUUserAuthenticateResult *)result;
		if(res.success)
        {
            // Login to Chat
			[[QBChatService instance] login];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentification successful" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [alert release];
		}
        else 
        if(401 == result.status)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentification unsuccessful. Not registered." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [alert release];
           
        }
        else
        {
            NSLog(@"Errors=%@", result.errors);
        }
    }
    
    [activityIndicator stopAnimating];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)_textField
{
    [_textField resignFirstResponder];
    [self next:nil];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [password resignFirstResponder];
    [login resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kQBUserDidAuth object:nil];
    [self dismissModalViewControllerAnimated:YES];
}

@end