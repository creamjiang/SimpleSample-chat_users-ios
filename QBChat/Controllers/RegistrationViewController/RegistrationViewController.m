//
//  RegistrationViewController.m
//  SimpleSample-chat_users-ios
//
//  Created by Igor Khomenko on 04.10.11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "RegistrationViewController.h"


@implementation RegistrationViewController
@synthesize userName;
@synthesize password;
@synthesize retypePassword;
@synthesize activityIndicator;

- (void)dealloc
{
    [userName release];
    [password release];
    [retypePassword release];
    [activityIndicator release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setUserName:nil];
    [self setPassword:nil];
    [self setRetypePassword:nil];
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
	 
    // Register user
    QBUUser *user = [[QBUUser alloc] init];       
	user.password = password.text;
    user.login = userName.text;
	
	[activityIndicator startAnimating];
    
	[QBUsersService createUser:user delegate:self];
    [user release];
}

- (IBAction)back:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark ActionStatusDelegate

-(void)completedWithResult:(Result*)result
{
    if([result isKindOfClass:[QBUUserResult class]])
    {
		QBUUserResult *res = (QBUUserResult *)result;
        
		if(res.success)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration successful. Please now sign in." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [alert release];
		}
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error happened" 
                                                            message:[NSString stringWithFormat:@"%@",result.errors] 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Okay" 
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
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


#pragma mark
#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     [self dismissModalViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [password resignFirstResponder];
    [retypePassword resignFirstResponder];
    [userName resignFirstResponder];
}

@end