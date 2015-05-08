//
//  SLConnectionButton.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLConnectionButton : UIButton

@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, copy) NSString *title;

- (void)addTarget:(id)target action:(SEL)action;

@end
