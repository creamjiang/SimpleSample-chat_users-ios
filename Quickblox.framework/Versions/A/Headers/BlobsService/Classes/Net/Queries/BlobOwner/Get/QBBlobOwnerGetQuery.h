//
//  BLBlobOwnerGetQuery.h
//  BlobsService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBBlobOwnerGetQuery : QBBlobOwnerQuery {
	NSUInteger blobOwnerID;
}
@property (nonatomic) NSUInteger blobOwnerID;
-(QBBlobOwnerGetQuery*)initWithBlobOwnerID:(NSUInteger)ID;
@end
