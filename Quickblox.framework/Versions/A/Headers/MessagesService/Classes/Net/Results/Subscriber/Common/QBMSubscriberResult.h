//
//  QBMSubscriberResult.h
//  MessagesService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBMSubscriberResult : QBMessagesServiceResult {
	
}
/** An Subscriber */
@property (nonatomic,readonly) QBMSubscriber *subscriber;
@end
