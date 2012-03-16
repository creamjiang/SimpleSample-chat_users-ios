//
//  QBMSubscribeOnEventByUserIDQuery.h
//  MessagesService
//
//  Created by Igor Khomenko on 2/14/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBMSubscribeOnEventByUserIDQuery : QBMessagesServiceQuery{
    NSUInteger eventID;
    NSUInteger userID;
}
@property (nonatomic) NSUInteger eventID;
@property (nonatomic) NSUInteger userID;

@end
