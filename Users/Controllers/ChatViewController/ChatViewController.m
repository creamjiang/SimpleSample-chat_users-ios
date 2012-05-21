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
@synthesize userOpponent;


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
    
	[QBChatService instance].delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Back button action
    UIBarButtonItem *backButton = [toolBar.items objectAtIndex:0];
    backButton.target = self;
    backButton.action = @selector(back:);
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
    QBChatMessage* message = [[QBChatMessage alloc] init];
    message.recipientJID = [[QBChatService instance] jidFromUser:userOpponent];
    message.senderJID = [[QBChatService instance] jidFromUser:[QBUsersService currentUser]];;
    message.text = messageTextField.text;
    
    // send message
    [[QBChatService instance] sendMessage:message];

    messageTextField.text = nil;
    [messageTextField resignFirstResponder];

    // reload table
    [messages addObject:message];
    [message release];
    [chatTableView reloadData];
	
}

// Back action
- (void)back:(id)sender
{
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
	
    UIImage *bgImage = nil;

    NSString *currentUserJid = [[QBChatService instance] jidFromUser:[QBUsersService currentUser]];
    
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
	
	
	cell.bgImageView.image = bgImage;
    

    cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", senderLogin, [[time description] substringToIndex:[time description].length-6]];
	
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


@end
