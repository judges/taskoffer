//
//  SLAlertView.m
//  XMPPIM
//
//  Created by wshaolin on 15/1/4.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLAlertView.h"

@implementation SLAlertView

+ (void)showWithMessage:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle{
    
    SLAlertView *alertView = [[self alloc] initWithTitle:@"" message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
    [alertView show];
}

@end
