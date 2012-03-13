//
//  MapViewController.h
//  SimpleSample-chat_users-ios
//
//  Created by Alexey Voitenko on 24.02.12.
//  Copyright (c) 2012 Injoit Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "CustomTableViewCellCell.h"

@class MyCustomAnnotationView;

@interface ViewController : UIViewController <ActionStatusDelegate, UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource> 
{

    UIViewController *loginController;
    UIViewController *registrationController;
    QBUUser *currentUser;
    UITextField* textField;
    UITableView* myTableView;
    IBOutlet CustomTableViewCellCell* _cell;
}

@property (nonatomic, retain) IBOutlet UIViewController *loginController;
@property (nonatomic, retain) IBOutlet UIViewController *registrationController;
@property (nonatomic, retain) QBUUser *currentUser;
@property (nonatomic, retain) IBOutlet UITextField* textField;
@property (nonatomic, retain) IBOutlet UITableView* myTableView;
@property (nonatomic, retain) IBOutlet CustomTableViewCellCell* _cell;
@property (nonatomic, assign) NSMutableArray* messages;
@property (nonatomic, assign) NSMutableArray* idArray;

- (IBAction) send: (id)sender;
- (void) searchGeoData:(NSTimer *) timer;
- (IBAction)textFieldDoneEditing:(id)sender;

@end
