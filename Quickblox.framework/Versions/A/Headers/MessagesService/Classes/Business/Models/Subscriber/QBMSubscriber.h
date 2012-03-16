//
//  QBMSubscriber.h
//  MessagesService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBMSubscriber : Entity {
	NSUInteger deviceTokenID;
	NSUInteger userID;
    NSString *email;
}
/** Device token identifier */
@property (nonatomic) NSUInteger deviceTokenID;

/** User identifier */
@property (nonatomic) NSUInteger userID;

/** E-mail address where notification will be received if the notification involves sending email */
@property (nonatomic, retain) NSString *email;

@end
