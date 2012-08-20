//
//  ChatViewController.h
//  SimpleSample-chat_users-ios
//
//  Created by Alexey on 21.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainViewController.h"
#import "SMMessageViewTableCell.h"

@class MainViewController;

@interface ChatViewController : UIViewController <QBChatDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, QBActionStatusDelegate>
{
    NSMutableArray* messages;
}

@property (nonatomic, assign) IBOutlet UITextField* messageTextField;
@property (nonatomic, assign) IBOutlet UITableView* chatTableView;
@property (nonatomic, assign) IBOutlet UIToolbar *toolBar;

@property (nonatomic, assign) QBUUser *userOpponent;
@property (nonatomic, assign) QBChatRoom *currentChatRoom;

- (void)back:(id)sender;
- (void)leaveChat:(id)sender;
- (IBAction)sendMessage:(id)sender;

@end
