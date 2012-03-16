//
//  QBMEventFireQuery.h
//  MessagesService
//

//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBMEventFireQuery : QBMEventQuery {
	NSUInteger eventID;
}
@property (nonatomic) NSUInteger eventID;

- (id)initWithEventID:(NSUInteger)eventID;

@end
