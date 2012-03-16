//
//  QBMDeviceTokenCreateQuery.h
//  MessagesService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBMDeviceTokenCreateQuery : QBMDeviceTokenQuery {
	QBMDeviceToken *deviceToken;
}
@property (nonatomic, retain) QBMDeviceToken *deviceToken;

- (id)initWithDeviceToken:(QBMDeviceToken *)token;

@end
