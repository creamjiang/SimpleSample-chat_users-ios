//
//  DataStorage.m
//  SimpleSample-chat_users-ios
//
//  Created by Igor Khomenko on 5/21/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

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

@end
