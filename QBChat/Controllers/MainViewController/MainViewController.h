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

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, QBActionStatusDelegate, UIActionSheetDelegate, UIAlertViewDelegate,QBChatDelegate>{

    NSMutableArray* selectedUsersIndexPathes;
    NSMutableArray* chatRooms;
    
    NSTimer *sendPresenceTimer; 
    NSTimer *requestRoomsTimer;
    NSTimer *checkPrecenceTimer;
    
    UIImage *presenceStatusOffLine;
    UIImage *presenceStatusOnLine;
    
    NSMutableArray *images;
    
    int numberOfPeople;
}

@property (nonatomic, retain) IBOutlet UITableView *usersAndRoomsTableView;

- (void) retrieveUsers;
- (void) updateRooms;

- (IBAction) startChatAction:(id)sender;
- (void) startChatWithUsersWithRoomName:(NSString *)roomName;

@end
