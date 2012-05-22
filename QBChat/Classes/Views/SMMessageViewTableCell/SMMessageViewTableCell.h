//
//  SMMessageViewTableCell.h
//  SimpleSample-chat_users-ios
//
//  Created by Alexey on 21.04.12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SMMessageViewTableCell : UITableViewCell {
	UILabel	*senderAndTimeLabel;
	UITextView *messageContentView;
	UIImageView *bgImageView;
}

@property (nonatomic,assign) UILabel *senderAndTimeLabel;
@property (nonatomic,assign) UITextView *messageContentView;
@property (nonatomic,assign) UIImageView *bgImageView;

@end
