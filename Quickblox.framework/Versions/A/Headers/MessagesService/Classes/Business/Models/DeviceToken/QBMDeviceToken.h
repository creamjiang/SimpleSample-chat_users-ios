//
//  QBMDeviceToken.h
//  MessagesService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBMDeviceToken : Entity {
    NSUInteger appID;
    NSUInteger deviceID;
	NSString *token;
	BOOL test;
}
@property(nonatomic, retain) NSString *token;
@property(nonatomic) NSUInteger deviceID;
@property(nonatomic) NSUInteger appID;
@property(nonatomic) BOOL test;

@end