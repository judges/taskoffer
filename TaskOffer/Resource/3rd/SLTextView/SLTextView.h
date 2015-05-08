//
//  SLTextView.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/19.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SLTextViewPlaceholderPosition){
    SLTextViewPlaceholderPositionTop,
    SLTextViewPlaceholderPositionMiddle,
    SLTextViewPlaceholderPositionBottom
};

@interface SLTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) CGPoint placeholderOffset;

@property (nonatomic, assign) SLTextViewPlaceholderPosition placeholderPosition;

@end
