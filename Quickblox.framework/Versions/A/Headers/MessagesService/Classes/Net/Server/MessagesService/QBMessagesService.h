//
//  QBMessagesService.h
//  MessagesService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>

/** QBMessagesService class declaration. */
/** Overview: this is a hub class for all Messages-related actions. */

@interface QBMessagesService : BaseService {
    
}



#pragma mark -
#pragma mark Device Token:Create

/** Create device token.
 
 */
+ (NSObject<Cancelable> *)registerDeviceToken:(QBMDeviceToken *)deviceToken withDelegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)registerDeviceToken:(QBMDeviceToken *)deviceToken withDelegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Subscriber:Create

/** Create Subscriber.
 
 */
+ (NSObject<Cancelable> *)createSubscriber:(QBMSubscriber *)subscriber withDelegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)createSubscriber:(QBMSubscriber *)subscriber withDelegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Event:Create 

/** Create an event
 
 @param event event to create
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBMEventResult class.
 */
+ (NSObject<Cancelable> *)createEvent:(QBMEvent *)event delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)createEvent:(QBMEvent *)event delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Event Subscription: Subscribe subscriber on an event

/** Subscribe Subscriber on an event
 
 @param subscriberID subscriber identifier
 @param eventID event identifier
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBMSubscribeOnEventResult class.
 */
+ (NSObject<Cancelable> *)subscribeSubscriber:(NSUInteger)subscriberID 
									 onEvent:(NSUInteger)eventID 
									delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)subscribeSubscriber:(NSUInteger)subscriberID 
									 onEvent:(NSUInteger)eventID 
									delegate:(NSObject<ActionStatusDelegate> *)delegate 
									 context:(void *)context;


#pragma mark -
#pragma mark Event Subscription: Subscribe all user subscribers to the event (by user_id)

/** Subscribe User on an event
 
 @param userID user identifier
 @param eventID event identifier
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBMSubscribeOnEventResult class.
 */
+ (NSObject<Cancelable> *)subscribeUser:(NSUInteger)userID 
							   onEvent:(NSUInteger)eventID 
							  delegate:(NSObject<ActionStatusDelegate> *)delegate;

+ (NSObject<Cancelable> *)subscribeUser:(NSUInteger)userID 
							   onEvent:(NSUInteger)eventID 
							  delegate:(NSObject<ActionStatusDelegate> *)delegate 
							   context:(void*)context;


#pragma mark -
#pragma mark Event:Fire

/** Fire an event
 
 @param eventID identifier of the event to fire
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of Result class.
 */
+ (NSObject<Cancelable> *)fireEvent:(NSUInteger)eventID delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)fireEvent:(NSUInteger)eventID delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Task:Register Subscriber

/** Create subscriber for existing user. 
 
 This method registers device and device token on the server if they are not registered yet, then creates a Subscriber and associates it with User. 
 
 @param user An instance of QBUUser to be associated with Subscriber
 @param device Device to subscribe
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBMRegisterSubscriberTaskResult class.
 */
+ (NSObject<Cancelable> *)TRegisterSubscriberForUser:(QBUUser *)user 
											  device:(QBCDevice *)device 
										    delegate:(NSObject<ActionStatusDelegate> *)delegate;


#pragma mark -
#pragma mark Task: Send Push

/** Send push message to external user
 
 @param pushMessage composed push message to send
 @param userID user identifier.
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBMSendPushTaskResult class.
 */
+ (NSObject<Cancelable> *)TSendPush:(QBMPushMessage *)pushMessage 
					         toUser:(NSUInteger)userID 
						   delegate:(NSObject<ActionStatusDelegate> *)delegate;




@end
