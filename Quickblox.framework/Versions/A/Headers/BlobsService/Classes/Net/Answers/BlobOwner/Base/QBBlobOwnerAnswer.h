//
//  BlobOwnerAnswer.h
//  BlobsService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBBlobOwnerAnswer : QBBlobsServiceAnswer {}

@property (nonatomic,readonly) QBBlobOwner* blobOwner;
@end
