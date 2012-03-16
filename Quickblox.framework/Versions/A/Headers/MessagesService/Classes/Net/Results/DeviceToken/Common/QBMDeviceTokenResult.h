//
//  QBMDeviceTokenResult.h
//  MessagesService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBMDeviceTokenResult : QBMessagesServiceResult {

}
@property (nonatomic,readonly) QBMDeviceToken *deviceToken;

@end
