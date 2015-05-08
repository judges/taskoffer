//
//  SLActionSheet.h
//  UIDemo
//
//  Created by wshaolin on 15/4/5.
//  Copyright (c) 2015年 rnd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLActionSheet;

@protocol SLActionSheetDelegate <NSObject>

@optional

- (void)actionSheet:(SLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)actionSheetCancel:(SLActionSheet *)actionSheet;

- (void)willPresentActionSheet:(SLActionSheet *)actionSheet;
- (void)didPresentActionSheet:(SLActionSheet *)actionSheet;

- (void)actionSheet:(SLActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)actionSheet:(SLActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end

@interface SLActionSheet : UIView

@property (nonatomic, weak) id<SLActionSheetDelegate> delegate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, assign, readonly) NSInteger numberOfButtons;
@property (nonatomic, assign, readonly) NSInteger cancelButtonIndex; // 如果cancelButtonTitle值不为nil且长度大于0，不为空格和Tab制表符，则cancelButtonIndex = -1，否则cancelButtonIndex = NSNotFound
@property (nonatomic, assign, readonly) NSInteger destructiveButtonIndex; // 如果destructiveButtonTitle值为nil或者长度等于0或者为空格或者为Tab制表符，则destructiveButtonIndex = NSNotFound

- (instancetype)initWithOtherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION; // cancelButtonTitle默认为"取消"，title为nil，destructiveButtonTitle为nil

- (instancetype)initWithDestructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION; // cancelButtonTitle默认为"取消"，title为nil

- (instancetype)initWithTitle:(NSString *)title delegate:(id<SLActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION; // 如果title为nil或者长度等于0，则不显示title；如果cancelButtonTitle为nil或者长度等于0，则不显示cancelButton；如果destructiveButtonTitle为nil或者长度等于0，则不显示destructiveButton，otherButtonTitles的值不能为nil或者""，以及空格和Tab制表符

- (NSInteger)addButtonWithTitle:(NSString *)title;
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex; // cancelButton的索引是-1;

- (void)show;

@end
