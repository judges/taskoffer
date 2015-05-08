//
//  SLAlertView.h
//  XMPPIM
//
//  Created by wshaolin on 15/1/4.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLAlertView : UIAlertView

+ (void)showWithMessage:(NSString *)message delegate:(id<UIAlertViewDelegate>) delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;

@end
