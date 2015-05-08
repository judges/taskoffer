//
//  SLClickableLabel.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/29.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SLClickableLabelTapHandler)(NSRange range, NSString *tapText);

@interface SLClickableRange : NSObject

@property (nonatomic, assign, readonly) NSRange range;
@property (nonatomic, strong, readonly) UIColor *rangeColor;

- (instancetype)initWithRange:(NSRange)range rangeColor:(UIColor *)rangeColor;

@end

@interface SLClickableLabel : UILabel

@property (nonatomic, copy, readonly) NSArray *clickableRanges;
@property (nonatomic, copy, readonly) NSArray *detectedClickableRanges;
@property (nonatomic, copy) SLClickableLabelTapHandler tapHandler;

- (void)setClickableRange:(NSRange)range;
- (void)setClickableRange:(NSRange)range hightlightedBackgroundColor:(UIColor *)hightlightedBackgroundColor;

- (void)removeAllClickableRanges;

@end
