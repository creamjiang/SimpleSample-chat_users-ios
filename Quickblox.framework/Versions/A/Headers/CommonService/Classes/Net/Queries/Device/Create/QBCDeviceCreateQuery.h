//
//  QBCDeviceCreateQuery.h
//  CommonService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBCDeviceCreateQuery : QBCDeviceQuery {
	QBCDevice *device;
}
@property (nonatomic,retain) QBCDevice *device;

- (id)initWithDevice:(QBCDevice *)device;

@end