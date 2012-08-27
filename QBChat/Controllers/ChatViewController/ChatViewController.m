//
//  ChatViewController.m
//  SimpleSample-chat_users-ios
//
//  Created by Alexey on 21.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize messageTextField, chatTableView, toolBar;
@synthesize userOpponent, currentChatRoom;


#pragma mark -
#pragma mark UIViewController's & UIView's life cycles

- (id)init
{
	self = [super init];
	if (self){
		messages = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id)initWithOpponent:(QBUUser *)opponent
{
	self = [super init];
	if (self){
        
        userOpponent = opponent;
        //============ massages init ============
        
        key = [[NSString alloc] initWithFormat:@"%d%d", [DataStorage instance].currentUser.ID, userOpponent.ID];
        
        standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
        if([NSKeyedUnarchiver unarchiveObjectWithData:[standardUserDefaults objectForKey:key]]){
            messages = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[standardUserDefaults objectForKey:key]]];
        }else{
            messages = [[NSMutableArray alloc] init];
        }
	}
	return self;
}

- (void)dealloc
{
    
    [messages release];
    
	[super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    // reload chat table
	[chatTableView reloadData];
    
	[QBChat instance].delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Back button action
    UIBarButtonItem *backButton = [toolBar.items objectAtIndex:0];
    backButton.target = self;
    backButton.action = @selector(back:);
    
    // leave chat button action
    UIBarButtonItem *leavChatButton = [toolBar.items objectAtIndex:2];
    leavChatButton.target = self;
    leavChatButton.action = @selector(leaveChat:);
}

- (void)viewDidUnload
{
    self.toolBar = nil;
    self.messageTextField = nil;
    self.chatTableView = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Basic methods

// Send message action
-(void)sendMessage:(id)sender
{
    // this is Room
	if (currentChatRoom){
        // send message to room
		[[QBChat instance] sendMessage:messageTextField.text toRoom:currentChatRoom];
        
		messageTextField.text = nil;
		[messageTextField resignFirstResponder];
        
    // tet a tet
    }else {
		QBChatMessage* message = [[QBChatMessage alloc] init];
		message.recipientJID = [[QBChat instance] jidFromUser:userOpponent];
		message.senderJID = [[QBChat instance] jidFromUser:[DataStorage instance].currentUser];
		message.text = messageTextField.text;
		
        // send message
		[[QBChat instance] sendMessage:message];
        
        messageTextField.text = nil;
		[messageTextField resignFirstResponder];
        
		// reload table
		[messages addObject:message];
        [message release];
		[chatTableView reloadData];
        
        NSData *serializedObject = [NSKeyedArchiver archivedDataWithRootObject:messages];
        [standardUserDefaults setObject:serializedObject forKey:key];
        [standardUserDefaults synchronize];
        
        // if user didn't do anything last 2 mins - hi offline -> send push to him
        NSDate *nowDate = [NSDate date];
        NSTimeInterval nowTime = [nowDate timeIntervalSince1970];
        if(nowTime - [userOpponent.lastRequestAt timeIntervalSince1970] > 60*2){
            
            // Create message
			NSString *mesage = messageTextField.text;
			//
			NSMutableDictionary *payload = [NSMutableDictionary dictionary];
			NSMutableDictionary *aps = [NSMutableDictionary dictionary];
			[aps setObject:@"default" forKey:QBMPushMessageSoundKey];
			[aps setObject:mesage forKey:QBMPushMessageAlertKey];
			[payload setObject:aps forKey:QBMPushMessageApsKey];
			//
			QBMPushMessage *message = [[QBMPushMessage alloc] initWithPayload:payload];
			
            BOOL isDevEnv = NO;
#ifdef DEBUG
            isDevEnv = YES;
#endif
            
			// Send push
			[QBMessages TSendPush:message
                          toUsers:[NSString stringWithFormat:@"%d", userOpponent.ID]
         isDevelopmentEnvironment:isDevEnv
                         delegate:self];
            
            [message release];

        }
	}
}

// Back action
- (void)back:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}


// Leave chat action
- (void)leaveChat:(id)sender{
	[[QBChat instance] leaveRoom:currentChatRoom];
    
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITableView delegate

static CGFloat padding = 20.0;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	QBChatMessage *messageBody = [messages objectAtIndex:[indexPath row]];
	
	static NSString *CellIdentifier = @"MessageCellIdentifier";
	
	SMMessageViewTableCell *cell = (SMMessageViewTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[SMMessageViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSString *sender = [messageBody senderJID];
    NSString *senderLogin;
    @try {
        senderLogin = [[[[sender componentsSeparatedByString:@"@"] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2];
    }
    @catch (NSException *exception) {
        senderLogin = sender;
    }
    
    
	NSString *message = [messageBody text];
	NSString *time = [[messageBody datetime] description];
	NSString *recipient = [messageBody recipientJID];
	
	CGSize textSize = { 260.0, 10000.0 };
	CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:13]
					  constrainedToSize:textSize 
						  lineBreakMode:UILineBreakModeWordWrap];
	
	size.width += (padding/2);
	
	cell.messageContentView.text = message;
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.userInteractionEnabled = NO;
	
    
    
	NSString* chatRoomJID = [currentChatRoom getRoomName];
	
	NSRange range = [sender rangeOfString:@"/" options:NSCaseInsensitiveSearch];
	
	NSString *senderNotFull = sender;
	if (range.location != NSNotFound){
		senderNotFull = [sender substringWithRange: NSMakeRange(0, [sender rangeOfString: @"/"].location)];
	}
	
    UIImage *bgImage = nil;
	if ([senderNotFull isEqualToString:chatRoomJID]){
		bgImage = [[UIImage imageNamed:@"orange.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
		
		[cell.messageContentView setFrame:CGRectMake(padding, padding*2, size.width+padding, size.height+padding)];
		
		[cell.bgImageView setFrame:CGRectMake( cell.messageContentView.frame.origin.x - padding/2, 
											  cell.messageContentView.frame.origin.y - padding/2, 
											  size.width+padding, 
											  size.height+padding)];
        
        cell.senderAndTimeLabel.textAlignment = UITextAlignmentLeft;
        
    }else {
        NSString *currentUserJid = [[QBChat instance] jidFromUser:[DataStorage instance].currentUser];
        
		if ([sender isEqualToString:currentUserJid] || [recipient isEqualToString:currentUserJid]) {
			if ([sender isEqualToString:currentUserJid]) { // left aligned
                
				bgImage = [[UIImage imageNamed:@"orange.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
                
				[cell.messageContentView setFrame:CGRectMake(padding, padding*2, size.width+padding, size.height+padding)];
                
				[cell.bgImageView setFrame:CGRectMake( cell.messageContentView.frame.origin.x - padding/2, 
													  cell.messageContentView.frame.origin.y - padding/2, 
													  size.width+padding, 
													  size.height+padding)];
                
                cell.senderAndTimeLabel.textAlignment = UITextAlignmentLeft;
                
			} else {
                
				bgImage = [[UIImage imageNamed:@"aqua.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
                
				[cell.messageContentView setFrame:CGRectMake(320 - size.width - padding, 
                                                             padding*2, 
                                                             size.width+padding, 
                                                             size.height+padding)];
                
				[cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2, 
                                                      cell.messageContentView.frame.origin.y - padding/2, 
                                                      size.width+padding, 
                                                      size.height+padding)];
                
                cell.senderAndTimeLabel.textAlignment = UITextAlignmentRight;
			}
		}
	}
	
	cell.bgImageView.image = bgImage;
    
    
	if (currentChatRoom){
		NSRange range = [sender rangeOfString:@"/" options:NSCaseInsensitiveSearch];
		if (range.location != NSNotFound){
			NSArray *myArray = [sender componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
			cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", [myArray objectAtIndex:1], [[time description] substringToIndex:[time description].length-6]];
		}else{
			cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", senderLogin, [[time description] substringToIndex:[time description].length-6]];
		}
	}else {
		cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", senderLogin, [[time description] substringToIndex:[time description].length-6]];
	}
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [messages count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *msg = ((QBChatMessage *)[messages objectAtIndex:indexPath.row]).text;
	CGSize  textSize = { 260.0, 10000.0 };
	CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:13]
			  constrainedToSize:textSize 
				  lineBreakMode:UILineBreakModeWordWrap];
	
	size.height += padding;
	return size.height+padding+5;
}


#pragma mark -
#pragma mark QBChatServiceDelegate

/**
didReceiveMessage fired when new message was received from QBChatService

@param message Message received from QBChatService
*/
- (void)chatDidReceiveMessage:(QBChatMessage *)message
{
    // add message to table
	[messages addObject:message];
    
    if (key) {
        
        NSData *serializedObject = [NSKeyedArchiver archivedDataWithRootObject:messages];
        [standardUserDefaults setObject:serializedObject forKey:key];
        [standardUserDefaults synchronize];
    }

    
    // reload table
	[chatTableView reloadData];
	[chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] 
                         atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

/**
 didNotSendMessage fired when message cannot be send to offline user
 
 @param message Message passed to sendMessage method into QBChatService
 */
- (void)chatDidNotSendMessage:(QBChatMessage *)message{
    // do something
}


/**
 didFailWithError fired when connection error occurs
 
 @param error Error code from QBChatServiceError enum
 */
- (void)chatDidFailWithError:(int)error
{
	NSLog(@"chatDidFailWithError, %d", error);
}



#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
-(void)completedWithResult:(Result *)result{
    // QuickBlox send push result
    if([result isKindOfClass:[QBMSendPushTaskResult class]]){
        
        // Success result
        if(result.success){

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
}


@end
