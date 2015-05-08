//
//  SLAddCaseSelectImageView.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLAddCaseSelectImageView;

@protocol SLAddCaseSelectImageViewDelegate <NSObject>

@optional

- (void)addCaseSelectImageViewDidClickAddButton:(SLAddCaseSelectImageView *)addCaseSelectImageView;

- (void)addCaseSelectImageView:(SLAddCaseSelectImageView *)addCaseSelectImageView didClickCancelButtonWithIndex:(NSUInteger)index;

- (void)addCaseSelectImageView:(SLAddCaseSelectImageView *)addCaseSelectImageView didChangeHeight:(CGFloat)height;

@end

@interface SLAddCaseSelectImageView : UIView

@property (nonatomic, strong) NSArray *selectedImages;
@property (nonatomic, weak) id<SLAddCaseSelectImageViewDelegate> delegate;
@property (nonatomic, copy) NSString *title;

@end
