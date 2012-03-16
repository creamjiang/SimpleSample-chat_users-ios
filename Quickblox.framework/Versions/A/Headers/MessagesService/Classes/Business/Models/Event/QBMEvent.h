//
//  QBMEvent.h
//  MessagesService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>

/** QBMEvent class declaration. */
/** Overview: Base class of all events.
    Normally, you use concerte subsclasses, like QBMPushEvent.
 */

@interface QBMEvent : Entity {
	NSUInteger eventOwnerID;
	enum QBMEventType type;
	enum QBMEventActionType pushActionType;
	NSMutableDictionary *message;
}

/** Event owner identifier, normally you have one event owner for each application or entire account */
@property (nonatomic) NSUInteger eventOwnerID;

/** Event type */
@property (nonatomic) QBMEventType type;

@property (nonatomic) QBMEventActionType pushActionType;

@property (nonatomic,retain) NSMutableDictionary *message;

- (void)prepareMessage;


#pragma mark -
#pragma mark Converters

+ (enum QBMEventActionType)actionTypeFromString:(NSString*)actionType;
+ (NSString*)actionTypeToString:(enum QBMEventActionType)actionType;

+ (enum QBMEventType)eventTypeFromString:(NSString*)eventType;
+ (NSString*)eventTypeToString:(enum QBMEventType)eventType;

+ (NSString*)messageToString:(NSDictionary*)message;
+ (NSDictionary*)messageFromString:(NSString*)message;

@end
