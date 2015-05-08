//
//  SLHyperlinkLabel.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SLHyperlinkLabelDidClickHyperlinkLHandler)(NSURL *url);

@interface SLHyperlinkLabel : UILabel

@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong) UIColor *textHighlightColor;

@property (nonatomic, copy) SLHyperlinkLabelDidClickHyperlinkLHandler hyperlinkLHandler;

@end
