//
//  QBMSubscriberCreateQuery.h
//  MessagesService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBMSubscriberCreateQuery : QBMSubscriberQuery {
	QBMSubscriber *subscriber;
}
@property (nonatomic, retain) QBMSubscriber *subscriber;

- (id)initWithSubscriber:(QBMSubscriber *)subscriber;

@end
