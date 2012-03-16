//
//  QBCDeviceDeleteQuery.h
//  CommonService
//
//  Created by Igor Khomenko on 2/7/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBCDeviceDeleteQuery : QBCDeviceQuery{
	NSUInteger deviceID;
}
@property (nonatomic) NSUInteger deviceID;

- (id)initWithDeviceID:(NSUInteger)deviceID;

@end
