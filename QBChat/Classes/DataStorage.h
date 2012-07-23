//
//  DataStorage.h
//  SimpleSample-chat_users-ios
//
//  Created by Igor Khomenko on 5/21/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStorage : NSObject{
}
@property (nonatomic, copy) NSArray *users;
@property (nonatomic, retain) QBUUser *currentUser;

+ (DataStorage *) instance;

@end
