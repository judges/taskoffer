//
//  IMAttributedLabel.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/31.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

typedef NS_ENUM(NSInteger, IMAttributedLabelVerticalAlignment) {
    IMAttributedLabelVerticalAlignmentCenter   = 0,
    IMAttributedLabelVerticalAlignmentTop      = 1,
    IMAttributedLabelVerticalAlignmentBottom   = 2,
};

@class IMAttributedLabel;

typedef void(^IMAttributedTextSelectedHandler)(IMAttributedLabel *attributedLabel, NSTextCheckingResult *result);
typedef void(^IMAttributedTextTapHandler)(IMAttributedLabel *attributedLabel, NSString *text);

@protocol IMAttributedLabelDelegate <NSObject>

@optional
- (void)attributedLabel:(IMAttributedLabel *)attributedLabel didSelectedLinkWithURL:(NSURL *)url andRange:(NSRange)range;

- (void)attributedLabel:(IMAttributedLabel *)attributedLabel didSelectedLinkWithAddress:(NSDictionary *)addressComponents andRange:(NSRange)range;

- (void)attributedLabel:(IMAttributedLabel *)attributedLabel didSelectedLinkWithPhoneNumber:(NSString *)phoneNumber andRange:(NSRange)range;

- (void)attributedLabel:(IMAttributedLabel *)attributedLabel didSelectedLinkWithDate:(NSDate *)date andRange:(NSRange)range;

- (void)attributedLabel:(IMAttributedLabel *)attributedLabel didSelectedLinkWithDate:(NSDate *)date timeZone:(NSTimeZone *)timeZone duration:(NSTimeInterval)duration andRange:(NSRange)range;

- (void)attributedLabel:(IMAttributedLabel *)attributedLabel didSelectedLinkWithTransitInformation:(NSDictionary *)components andRange:(NSRange)range;

- (void)attributedLabel:(IMAttributedLabel *)attributedLabel didSelectedLinkWithTextCheckingResult:(NSTextCheckingResult *)textCheckingResult;

// 当参数enableTapAttributedText为YES时可用
- (void)attributedLabel:(IMAttributedLabel *)attributedLabel didTapText:(NSString *)text;

@end


@interface IMAttributedLabel : UILabel

@property (nonatomic, weak) id<IMAttributedLabelDelegate> delegate;

// emoji表情相关
@property (nonatomic, assign, getter = isEmojiEnabled) BOOL emojiEnabled; // 是否使用emoji表情
@property (nonatomic, copy) NSString *emojiRegex; // 匹配emoji表情的正则
@property (nonatomic, copy) NSString *emojiFile; // 存储emoji表情对的json文件
@property (nonatomic, copy) NSString *emojiText; // 含有emoji表情的文本
@property (nonatomic, assign, getter = isEnableTapAttributedText) BOOL enableTapAttributedText; // 是否可以点击文字（整个Label上的文字），添加的链接除外，默认NO

@property (nonatomic, copy) IMAttributedTextSelectedHandler textSelectedHandler;
// 当参数enableTapAttributedText为YES时可用
@property (nonatomic, copy) IMAttributedTextTapHandler textTapHandler;

@property (nonatomic, assign) NSTextCheckingTypes textCheckingTypes;
@property (nonatomic, strong, readonly) NSArray *links;

@property (nonatomic, strong) NSDictionary *linkAttributes;
@property (nonatomic, strong) NSDictionary *activeLinkAttributes;
@property (nonatomic, strong) NSDictionary *inactiveLinkAttributes;

@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGFloat highlightedShadowRadius;
@property (nonatomic, assign) CGSize highlightedShadowOffset;
@property (nonatomic, strong) UIColor *highlightedShadowColor;

@property (nonatomic, assign) CGFloat kern;
@property (nonatomic, assign) CGFloat firstLineIndent;
@property (nonatomic, assign) CGFloat lineSpacing; // 行间距，默认2.0
@property (nonatomic, assign) CGFloat minimumLineHeight;
@property (nonatomic, assign) CGFloat maximumLineHeight;
@property (nonatomic, assign) CGFloat lineHeightMultiple;
@property (nonatomic, assign) UIEdgeInsets textInsets;

@property (nonatomic, assign) IMAttributedLabelVerticalAlignment verticalAlignment;
@property (nonatomic, copy) NSString *truncationTokenString;
@property (nonatomic, strong) NSDictionary *truncationTokenStringAttributes;

@property (nonatomic, copy) NSAttributedString *attributedText;

+ (CGSize)sizeThatFitsAttributedString:(NSAttributedString *)attributedString withConstraints:(CGSize)size limitedToNumberOfLines:(NSUInteger)numberOfLines;

- (void)setNormalStringText:(NSString *)normalStringText;
- (void)setNormalStringText:(NSString *)normalStringText attributedBlock:(NSMutableAttributedString *(^)(NSMutableAttributedString *mutableAttributedString))attributedBlock;

- (void)setAttributedStringText:(NSMutableAttributedString *)attributedStringText attributedBlock:(NSMutableAttributedString *(^)(NSMutableAttributedString *mutableAttributedString))attributedBlock;

- (void)addLinkWithTextCheckingResult:(NSTextCheckingResult *)textCheckingResult;
- (void)addLinkWithTextCheckingResult:(NSTextCheckingResult *)textCheckingResult attributes:(NSDictionary *)attributes;
- (void)addLinkWithTextCheckingResults:(NSArray *)textCheckingResults attributes:(NSDictionary *)attributes;

- (void)addLinkToURL:(NSURL *)url withRange:(NSRange)range;
- (void)addLinkToAddress:(NSDictionary *)addressComponents withRange:(NSRange)range;
- (void)addLinkToPhoneNumber:(NSString *)phoneNumber withRange:(NSRange)range;
- (void)addLinkToDate:(NSDate *)date withRange:(NSRange)range;
- (void)addLinkToDate:(NSDate *)date timeZone:(NSTimeZone *)timeZone duration:(NSTimeInterval)duration withRange:(NSRange)range;
- (void)addLinkToTransitInformation:(NSDictionary *)components withRange:(NSRange)range;

@end

UIKIT_EXTERN NSString * const kIMStrikeOutAttributeName;
UIKIT_EXTERN NSString * const kIMBackgroundFillColorAttributeName;
UIKIT_EXTERN NSString * const kIMBackgroundFillPaddingAttributeName;
UIKIT_EXTERN NSString * const kIMBackgroundStrokeColorAttributeName;
UIKIT_EXTERN NSString * const kIMBackgroundLineWidthAttributeName;
UIKIT_EXTERN NSString * const kIMBackgroundCornerRadiusAttributeName;
UIKIT_EXTERN NSString * const kIMGlyphAttributeImageName;
UIKIT_EXTERN CGFloat const kIMEmojiOriginYOffsetRatioWithLineHeight;