//
//  MainViewController.h
//  SimpleSample-chat_users-ios
//
//  Created by Alexey on 21.04.12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewController.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"

@class ChatViewController;
@class LoginViewController;
@class RegistrationViewController;

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ActionStatusDelegate, UIActionSheetDelegate, UIAlertViewDelegate,QBChatServiceDelegate>{

    NSMutableArray* selectedUsersIndexPathes;
    
    NSTimer *sendPresenceTimer; 
}

@property (nonatomic, retain) IBOutlet UITableView *usersAndRoomsTableView;

- (void) retrieveUsers;

- (IBAction) startChatAction:(id)sender;
- (void) startChatWithUsersWithRoomName:(NSString *)roomName;

@end
