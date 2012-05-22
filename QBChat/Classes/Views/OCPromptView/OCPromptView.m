//
//  OCPromptView.m
//  Users
//
//  Created by Alexey on 16.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OCPromptView.h"

@implementation OCPromptView
@synthesize textField;

- (NSString *)enteredText {
    return textField.text;
}

- (id)initWithPrompt:(NSString *)prompt delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle acceptButtonTitle:(NSString *)acceptTitle 
{
    if (self = [super initWithTitle:prompt message:@"\n" delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:acceptTitle, nil]) 
	{
		UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 31.0)]; 
        [theTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [theTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [theTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [theTextField setBackgroundColor:[UIColor clearColor]];
        [theTextField setTextAlignment:UITextAlignmentCenter];
		[theTextField setTextColor:[UIColor blackColor]];
		
        [self addSubview:theTextField];
		
        self.textField = theTextField;
        [theTextField release];
		
        // if not >= 4.0
        NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
        if (![sysVersion compare:@"4.0" options:NSNumericSearch] == NSOrderedDescending) 
		{
            CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 130.0); 
            [self setTransform:translate];
		}
    }
    return self;
}

- (void)dealloc {
    [textField release];
    [super dealloc];
}

- (void)show {
    [textField becomeFirstResponder];
    [super show];
}

@end
