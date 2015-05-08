//
//  SLOptionPickerView.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/2.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLOptionPickerView, SLOptionModel;

@protocol SLOptionPickerViewDelegate <NSObject>

@optional

- (void)optionPickerView:(SLOptionPickerView *)optionPickerView didSelectOptionComplete:(SLOptionModel *)optionModel;

- (void)optionPickerViewDidClickCancel:(SLOptionPickerView *)optionPickerView;

@end

@interface SLOptionPickerView : UIView

@property (nonatomic, strong) SLOptionModel *selectedOptionModel;
@property (nonatomic, weak) id<SLOptionPickerViewDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *optionArray;

- (instancetype)initWithOptionArray:(NSArray *)optionArray;
+ (instancetype)optionPickerWithOptionArray:(NSArray *)optionArray;

- (void)showOptionPicker;

@end