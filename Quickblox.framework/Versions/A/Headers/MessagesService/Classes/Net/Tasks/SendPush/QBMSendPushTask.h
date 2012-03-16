//
//  QBMSendPushTask.h
//  MessagesService
//

//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBMSendPushTask : Task {
	NSUInteger subscriberID;
	NSUInteger userID;
	QBMPushMessage *pushMessage;
	QBMPushEvent *event;
}
@property (nonatomic) NSUInteger subscriberID;
@property (nonatomic) NSUInteger userID;
@property (nonatomic,retain) QBMPushMessage *pushMessage;
@property (nonatomic,retain) QBMPushEvent *event;

@end
