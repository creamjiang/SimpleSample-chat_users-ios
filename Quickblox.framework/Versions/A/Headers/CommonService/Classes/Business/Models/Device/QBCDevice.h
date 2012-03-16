//
//  QBCDevice.h
//  CommonService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBCDevice : Entity {
	NSString *UDID;
    NSString *platform;
}
@property (nonatomic,retain) NSString *UDID;
@property (nonatomic,retain) NSString *platform;

- (id)initWithCurrentDevice;
- (id)initWithDeviceUDID:(NSString *)UDID;

@end