//
//  BlobOwnerQuery.h
//  BlobsService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBBlobOwnerQuery : QBBlobsServiceQuery {
@protected
	QBBlobOwner* blobOwner;
}
@property (nonatomic,readonly) QBBlobOwner* blobOwner;
-(id)initWithBLBlobOwner:(QBBlobOwner*)owner;
@end
