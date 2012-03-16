//
//  QBCommonService.h
//  CommonService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBCommonService : BaseService {

}

#pragma mark -
#pragma mark Device:Create

/**
 Create device
 
 Type of Result - QBCDeviceResult
 
 @param device An instance of QBCDevice, describing the device to be created.
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBCDeviceResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+(NSObject<Cancelable> *)createDevice:(QBCDevice *)device delegate:(NSObject<ActionStatusDelegate> *)delegate;
+(NSObject<Cancelable> *)createDevice:(QBCDevice *)device delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Device:Get by ID

/**
 Retrieve device by identifier
 
 Type of Result - QBCDeviceResult
 
 @param deviceID ID of device to be retrieved.
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBCDeviceResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+(NSObject<Cancelable> *)getDeviceByID:(NSUInteger)deviceID delegate:(NSObject<ActionStatusDelegate> *)delegate;
+(NSObject<Cancelable> *)getDeviceByID:(NSUInteger)deviceID delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Device:Delete

/**
 Delete device by identifier
 
 Type of Result - QBCDeviceResult
 
 @param deviceID ID of device to be deleted.
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBCDeviceResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+(NSObject<Cancelable> *)deleteDeviceByID:(NSUInteger)deviceID delegate:(NSObject<ActionStatusDelegate> *)delegate;
+(NSObject<Cancelable> *)deleteDeviceByID:(NSUInteger)deviceID delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;

@end