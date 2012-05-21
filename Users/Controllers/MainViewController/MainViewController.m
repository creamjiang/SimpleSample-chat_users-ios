//
//  MainViewController.m
//  SimpleSample-chat_users-ios
//
//  Created by Alexey on 21.04.12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize usersAndRoomsTableView;


#pragma mark -
#pragma mark UIViewController's & UIView's life cycles

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundle{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundle];
    if(self){
        // Do any additional setup after loading the view, typically from a nib.
        selectedUsersIndexPathes = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
	[selectedUsersIndexPathes release];
    
    [sendPresenceTimer release];

	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    usersAndRoomsTableView.layer.borderColor = [[UIColor grayColor] CGColor];
    usersAndRoomsTableView.layer.borderWidth = 1;
    usersAndRoomsTableView.layer.cornerRadius = 10;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qbApplicationDidAuth) name:kQBApplicationDidAuth object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[QBChatService instance].delegate = self;
    
    // send presens every 30 sec
    if([QBUsersService currentUser]){
        
        // send presence
        if(sendPresenceTimer == nil){
            sendPresenceTimer = [[NSTimer scheduledTimerWithTimeInterval:30 
                                                                  target:self 
                                                                selector:@selector(sendPresence) 
                                                                userInfo:nil 
                                                                 repeats:YES] retain];
            [sendPresenceTimer fire];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [sendPresenceTimer invalidate];
    [sendPresenceTimer release];
    sendPresenceTimer = nil;
}

- (void)viewDidUnload
{
    self.usersAndRoomsTableView = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark -
#pragma mark Basic methods

- (void)qbApplicationDidAuth{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    
    // get users
	[self retrieveUsers];
	
	[QBChatService instance].delegate = self;
}

// send presence
- (void)sendPresence{
    [[QBChatService instance] sendPresence];
}

// retrieve all app users
- (void) retrieveUsers{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    PagedRequest* request = [[PagedRequest alloc] init];
    request.perPage = 100;
	[QBUsersService getUsersWithPagedRequest:request delegate:self];
	[request release];
}

// Start Chat button action
- (void)startChatAction:(id)sender
{
    
    // you must be loggedin for start chat
    if ([QBUsersService currentUser] == nil){
		UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"You must be logged in for this action"]
																 delegate:self 
														cancelButtonTitle:@"Cancel" 
												   destructiveButtonTitle:nil 
														otherButtonTitles:@"Log in", @"Sign up", nil ];
		[actionSheet showInView:self.view];
		[actionSheet release];
        
        return;
	}
	
    
    // if no one user has been choosed
	if (![selectedUsersIndexPathes count]) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"You must choose at least one user for chat" 
													   delegate:nil 
											  cancelButtonTitle:@"Okay" 
											  otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
        
        return;
	
    }
	
        
    // start chat
    [self startChatWithUsersWithRoomName:nil];
}

// start chat with users
- (void)startChatWithUsersWithRoomName:(NSString *)roomName
{	
    // start tet-a-tet chat 
    
    // save opponent
    int row = [[selectedUsersIndexPathes objectAtIndex:0] intValue];
    
    ChatViewController *chatViewController = [[[ChatViewController alloc] init] autorelease];
    chatViewController.userOpponent = [[DataStorage instance].users objectAtIndex:row];

    // show Chat controller
    [self presentModalViewController:chatViewController animated:YES];

	
    // delete cheks
	[selectedUsersIndexPathes removeAllObjects];
    [usersAndRoomsTableView reloadData];
}


#pragma mark -
#pragma mark Table View Data Source Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* SimpleTableIdentifier2 = @"UserTableIdentifier";
    
    // create cell
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier2];
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier2] autorelease];
    }
    
     // set user name
    QBUUser *user = [[DataStorage instance].users objectAtIndex:[indexPath row]];
    cell.textLabel.text = user.login;
    cell.detailTextLabel.text = user.fullName;
    
    NSNumber *row = [NSNumber numberWithInt:indexPath.row];
    
    //select/deselect cell
    if ([selectedUsersIndexPathes containsObject:row]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DataStorage instance].users count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Users";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [usersAndRoomsTableView deselectRowAtIndexPath:indexPath animated:YES];

    // add selected user index path or remove it from selected users array
    
    NSNumber *row = [NSNumber numberWithInt:indexPath.row];
    
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone){
        
        [selectedUsersIndexPathes removeAllObjects];
        
        [selectedUsersIndexPathes addObject:row];
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        
        [tableView reloadData];
    }else {
        [selectedUsersIndexPathes removeObject:row];
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    }
}


#pragma mark -
#pragma mark ActionStatusDelegate

- (void)completedWithResult:(Result *)result
{
	if([result isKindOfClass:[QBUUserPagedResult class]])
    {
        if (result.success)
        {
            QBUUserPagedResult *usersSearchRes = (QBUUserPagedResult *)result;
            
            // store users
            [DataStorage instance].users = usersSearchRes.users;
            
            // reload table
            [usersAndRoomsTableView reloadData];
        }
	}
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


#pragma mark -
#pragma mark UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) 
	{
		case 0:
			// show login controller
			[self presentModalViewController:[[[LoginViewController alloc] init] autorelease] animated:YES];
			break;
			
		case 1:
			// show reg controller
			[self presentModalViewController:[[[RegistrationViewController alloc] init] autorelease] animated:YES];
			break;
			
		default:
			break;
	}
}


#pragma mark -
#pragma mark QBChatService delegate


/**
 didNotLogin fired when login process did not finished successfully
 */
- (void)chatDidLogin
{
    // do something
}

/**
 didNotLogin fired when login process did not finished successfully
 */
- (void)chatDidNotLogin
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                    message:@"chatDidNotLogin have called" 
                                                   delegate:nil cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil, nil];
	[alert show];
	[alert release];
}

/**
 didFailWithError fired when connection error occurs
 
 @param error Error code from QBChatServiceError enum
 */
- (void)chatDidFailWithError:(int)error
{
	NSLog(@"chatDidFailWithError, %d", error);
}

/**
 didReceiveMessage fired when new message was received from QBChatService
 
 @param message Message received from QBChatService
 */
-(void)chatDidReceiveMessage:(QBChatMessage *)message
{
    int messageSenderID = [[[message.senderJID componentsSeparatedByString:@"-"] objectAtIndex:0] intValue];
	
    // search from who message
	for (int i = 0; i<[[DataStorage instance].users count];i++){
		int userID = ((QBUUser *)[[DataStorage instance].users objectAtIndex:i]).ID; 
		
        if (messageSenderID == userID){
			NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:1];
			[usersAndRoomsTableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.2];
			break;
		}
	}
}

@end
