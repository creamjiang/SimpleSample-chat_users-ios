//
//  QBCDeviceGetQuery.h
//  CommonService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBCDeviceGetQuery : QBCDeviceQuery {
	NSUInteger deviceID;
}
@property (nonatomic) NSUInteger deviceID;

- (id)initWithDeviceID:(NSUInteger)deviceID;

@end