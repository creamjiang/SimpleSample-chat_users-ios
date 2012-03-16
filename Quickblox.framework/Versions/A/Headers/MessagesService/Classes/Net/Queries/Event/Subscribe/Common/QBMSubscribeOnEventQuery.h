//
//  QBMSubscribeOnEventQuery.h
//  MessagesService
//

//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBMSubscribeOnEventQuery : QBMessagesServiceQuery {
	NSUInteger eventID;
	NSUInteger subscriberID;
}
@property (nonatomic) NSUInteger eventID;
@property (nonatomic) NSUInteger subscriberID;

@end
