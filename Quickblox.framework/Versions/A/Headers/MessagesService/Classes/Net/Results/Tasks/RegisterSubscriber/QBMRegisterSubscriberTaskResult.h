//
//  QBMRegisterDeviceSubscriberTaskResult.h
//  MessagesService
//

//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBMRegisterSubscriberTaskResult : TaskResult {
	QBMSubscriber *subscriber;
}
@property (nonatomic,retain) QBMSubscriber *subscriber;
@end
