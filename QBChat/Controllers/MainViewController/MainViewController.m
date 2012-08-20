//
//  MainViewController.m
//  SimpleSample-chat_users-ios
//
//  Created by Alexey on 21.04.12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "MainViewController.h"
#import "OCPromptView.h"

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
        chatRooms = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [chatRooms release];
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
	
	[QBChat instance].delegate = self;
    
    // send presens every 30 sec
    if([DataStorage instance].currentUser){
        
        // send presence
        if(sendPresenceTimer == nil){
            sendPresenceTimer = [[NSTimer scheduledTimerWithTimeInterval:30 
                                                                  target:self 
                                                                selector:@selector(sendPresence) 
                                                                userInfo:nil 
                                                                 repeats:YES] retain];
        }
        
        // retrieve rooms
        if(requestRoomsTimer == nil){
            requestRoomsTimer= [[NSTimer scheduledTimerWithTimeInterval:10 
                                                                 target:self 
                                                               selector:@selector(updateRooms) 
                                                               userInfo:nil 
                                                                repeats:YES] retain];
            [self updateRooms];
        }

    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [requestRoomsTimer invalidate];
    [requestRoomsTimer release];
    requestRoomsTimer = nil;
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
	
	[QBChat instance].delegate = self;
}

// send presence
- (void)sendPresence{
    // presence in Chat
    [[QBChat instance] sendPresence];
    
    // presence in QB
    [QBUsers userWithID:0 delegate:nil];
}

// retrieve all app users
- (void) retrieveUsers{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    PagedRequest* request = [[PagedRequest alloc] init];
    request.perPage = 5;
	[QBUsers usersWithPagedRequest:request delegate:self];
	[request release];
}

// update rooms
- (void)updateRooms
{
	[[QBChat instance] requestAllRooms];
}

// Start Chat button action
- (void)startChatAction:(id)sender
{
    // you must be loggedin for start chat
    if ([DataStorage instance].currentUser == nil){
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
        
    // 1 on 1 Chat
    }else if ([selectedUsersIndexPathes count] == 1){
        // start chat
		[self startChatWithUsersWithRoomName:nil];
        
    // Chat in room
    }else{ 
        // enter room name
		OCPromptView* alertView = [[OCPromptView alloc] initWithPrompt:@"Enter room name" 
                                                              delegate:self 
                                                     cancelButtonTitle:@"Cancel" 
                                                     acceptButtonTitle:@"Create"];
		alertView.tag = 1;
		[alertView show];
		[alertView release];
	}
}

// start chat with users
- (void)startChatWithUsersWithRoomName:(NSString *)roomName
{	
    // start tet-a-tet chat if one user has been choosed
	if ([selectedUsersIndexPathes count] == 1){
        // save opponent
        int row = [[selectedUsersIndexPathes objectAtIndex:0] intValue];
        
        ChatViewController *chatViewController = [[[ChatViewController alloc] init] autorelease];
        chatViewController.userOpponent = [[DataStorage instance].users objectAtIndex:row];
        
        // show Chat controller
		[self presentModalViewController:chatViewController animated:YES];
        
    // create chat room and start group chat
    }else {
        // strat & join room
		QBChatRoom* room = [[QBChat instance] newRoomWithName:roomName];
        // add users to room
        NSMutableArray *usersJids = [NSMutableArray array];
        for(NSNumber *userNumber in selectedUsersIndexPathes){
            int row = [userNumber intValue];
            QBUUser *user = [[DataStorage instance].users objectAtIndex:row];
            [usersJids addObject:[[QBChat instance] jidFromUser:user]];
        }
        [room addUsers:usersJids];
		
        [chatRooms addObject:room];
        [room release];
        
        ChatViewController *chatViewController = [[[ChatViewController alloc] init] autorelease];
		chatViewController.currentChatRoom = room;
		
        // show Chat controller
		[self presentModalViewController:chatViewController animated:YES];
	}
	
    // delete cheks
	[selectedUsersIndexPathes removeAllObjects];
    [usersAndRoomsTableView reloadData];
}


#pragma mark -
#pragma mark Table View Data Source Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 2 sections
	if ([chatRooms count] > 0)
	{
        // users
		if (indexPath.section == 1)
		{
			static NSString* SimpleTableIdentifier1 = @"UserTableIdentifier";
            
            // create cell
			UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier1];
			if (cell == nil){
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier1] autorelease];
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
            
            // rooms
        }else {
			static NSString* SimpleTableIdentifier = @"RoomTableIdentifier";
			
            // create cell
			UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
			if (cell == nil){
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier] autorelease];
			}
			
            // set room name
            QBChatRoom* room = [chatRooms objectAtIndex:[indexPath row]];
            cell.textLabel.text = room.name;
            
			return cell;
		}
        
    }else {
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([chatRooms count] > 0)
	{
		if (section == 0)
		{
			return [chatRooms count];
		}
		else
		{
			return [[DataStorage instance].users count];
		}
	}
	else 
	{
		return [[DataStorage instance].users count];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if ([chatRooms count] > 0)
	{
		return 2;
	}
	else 
	{
		return 1;
	}
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if ([chatRooms count] > 0)
	{
		if (section == 0)
		{
			return @"Public rooms";
		}
		else 
		{
			return @"Users";
		}
	}
	else 
	{
		return @"Users";
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [usersAndRoomsTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2 sections (users & rooms)
    if(tableView.numberOfSections == 2){
        if (indexPath.section == 0)
        {
            // enter to room
            QBChatRoom* room = [chatRooms objectAtIndex:[indexPath row]];
            [room joinRoom];
            
            ChatViewController *chatViewController = [[[ChatViewController alloc] init] autorelease];
            
            // save room
            chatViewController.currentChatRoom = room;
            
            // show Chat controller
            [self presentModalViewController:chatViewController animated:YES];
        }
        else if (indexPath.section == 1)
        {
            // add selected user index path or remove it from selected users array
            
            NSNumber *row = [NSNumber numberWithInt:indexPath.row];
            
            if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone){
                [selectedUsersIndexPathes addObject:row];
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            }else {
                [selectedUsersIndexPathes removeObject:row];
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            }
        } 
        
        // 1 section (users)
    }else{
        // add selected user index path or remove it from selected users array
        
        NSNumber *row = [NSNumber numberWithInt:indexPath.row];
        
        if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone){
            [selectedUsersIndexPathes addObject:row];
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            [selectedUsersIndexPathes removeObject:row];
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        }
    }
}


#pragma mark -
#pragma mark QBActionStatusDelegate

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
#pragma mark UIAlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Enter room name alert
	if (alertView.tag == 1)
	{
		if (buttonIndex == 1)
		{
			if ([[((OCPromptView*)alertView) enteredText] length] > 0)
			{
                // start chat in room
				[self startChatWithUsersWithRoomName:[((OCPromptView*)alertView) enteredText]];
			}
			else 
			{
                // you must enter room name 
				UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
																message:@"Please, enter room name" 
															   delegate:nil 
													  cancelButtonTitle:@"Ok" 
													  otherButtonTitles:nil, nil];
				[alert show];
				[alert release];
			}
		}
	}
}


#pragma mark -
#pragma mark QBChatService delegate

/**
 Called in case receiving list of avaible to join rooms. Array rooms contains jids NSString type
 */
- (void)chatDidReceiveListOfRooms:(NSArray *)rooms
{
    
    // remove not existed
    NSMutableArray *array = [NSMutableArray arrayWithArray:chatRooms];
    for(QBChatRoom *oldRoom in array){
        if(![rooms containsObject:oldRoom]){
            [chatRooms removeObject:oldRoom];
        }
    }
    
    // add new rooms
    for(QBChatRoom *newRoom in rooms){
        if(![chatRooms containsObject:newRoom]){
            [chatRooms addObject:newRoom]; 
        }
    }
	
    // reload table
    [usersAndRoomsTableView reloadData];
}

/**
 didNotLogin fired when login process did not finished successfully
 */
- (void)chatDidLogin
{
    // do something if need
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
