//
//  BLBlobOwnerDeleteQuery.h
//  BlobsService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBBlobOwnerDeleteQuery : QBBlobOwnerQuery {
	NSUInteger blobOwnerID;
}
@property (nonatomic) NSUInteger blobOwnerID;
-(QBBlobOwnerDeleteQuery*)initWithBlobOwnerID:(NSUInteger)ID;
@end
