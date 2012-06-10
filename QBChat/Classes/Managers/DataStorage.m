//
//  DataStorage.m
//  SimpleSample-chat_users-ios
//
//  Created by Igor Khomenko on 5/21/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#define kCachedMessages @"kCachedMessages"

#import "DataStorage.h"

static DataStorage *instance_;

@implementation DataStorage
@synthesize users;

+ (DataStorage *) instance{
    @synchronized(self) {
        if( instance_ == nil ) {
            instance_ = [[self alloc] init];
        }
    }
    
    return instance_;
}

- (void)dealloc{
    [users release];
    [super dealloc];
}


// save messages for opponent or room
- (void)addMessageToCache:(QBChatMessage *)message{
    NSString *opponentOrRoomJID = message.senderJID;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // get dictionary of cached messages
    NSMutableDictionary *cachedMessagesDictionary = [[defaults objectForKey:kCachedMessages] mutableCopy];
    if(cachedMessagesDictionary == nil){
        cachedMessagesDictionary = [[NSMutableDictionary alloc] init];
    }
    
    // get array if cashed messages for opponent/room
    NSMutableArray *listOfCachedMessage = [[cachedMessagesDictionary objectForKey:opponentOrRoomJID] mutableCopy];
    if(listOfCachedMessage == nil){
        listOfCachedMessage = [[NSMutableArray alloc] init];
    }
    
    // add message
    [listOfCachedMessage addObject:message];
    
    // save list of messages
    [cachedMessagesDictionary setObject:listOfCachedMessage forKey:opponentOrRoomJID];
    [listOfCachedMessage release];
    
    // safe cache
    [defaults setObject:cachedMessagesDictionary forKey:kCachedMessages];
    [defaults synchronize];
    
    [cachedMessagesDictionary release];
}

// get cashed messages
- (NSArray *)cashedMessagesForOpponentOrRoomJID:(NSString *)opponentOrRoomJID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:kCachedMessages] objectForKey:opponentOrRoomJID];
}

@end
