//
//  QBMRegisterSubscriberWithDeviceTask.h
//  MessagesService
//

//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBCDevice;

@interface QBMRegisterSubscriberTask : Task {
	QBCDevice *device;
	QBUUser *user;
	QBMDeviceToken *deviceToken;
    NSString *testToken;
}
@property (nonatomic, retain) QBCDevice *device;
@property (nonatomic, retain) QBUUser *user;
@property (nonatomic, retain) QBMDeviceToken *deviceToken;
@property (nonatomic, retain) NSString *testToken;

@end
