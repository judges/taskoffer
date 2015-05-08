//
//  IMAttributedLabel.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/31.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "IMAttributedLabel.h"
#import <QuartzCore/QuartzCore.h>
#import <Availability.h>
#import "HexColor.h"

#define kIMLineBreakWordWrapTextWidthScalingFactor (M_PI / M_E)

static CGFloat const IMFLOAT_MAX = 100000;

const NSTextAlignment IMTextAlignmentLeft = NSTextAlignmentLeft;
const NSTextAlignment IMTextAlignmentCenter = NSTextAlignmentCenter;
const NSTextAlignment IMTextAlignmentRight = NSTextAlignmentRight;
const NSTextAlignment IMTextAlignmentJustified = NSTextAlignmentJustified;
const NSTextAlignment IMTextAlignmentNatural = NSTextAlignmentNatural;

const NSLineBreakMode IMLineBreakByWordWrapping = NSLineBreakByWordWrapping;
const NSLineBreakMode IMLineBreakByCharWrapping = NSLineBreakByCharWrapping;
const NSLineBreakMode IMLineBreakByClipping = NSLineBreakByClipping;
const NSLineBreakMode IMLineBreakByTruncatingHead = NSLineBreakByTruncatingHead;
const NSLineBreakMode IMLineBreakByTruncatingMiddle = NSLineBreakByTruncatingMiddle;
const NSLineBreakMode IMLineBreakByTruncatingTail = NSLineBreakByTruncatingTail;

typedef NSTextAlignment IMTextAlignment;
typedef NSLineBreakMode IMLineBreakMode;

static inline CTTextAlignment CTTextAlignmentFromIMTextAlignment(IMTextAlignment textAlignment){
    switch (textAlignment) {
        case NSTextAlignmentLeft:
            return kCTLeftTextAlignment;
        case NSTextAlignmentCenter:
            return kCTCenterTextAlignment;
        case NSTextAlignmentRight:
            return kCTRightTextAlignment;
        default:
            return kCTNaturalTextAlignment;
    }
}

static inline CTLineBreakMode CTLineBreakModeFromIMLineBreakMode(IMLineBreakMode lineBreakMode) {
    switch (lineBreakMode) {
        case NSLineBreakByWordWrapping:
            return kCTLineBreakByWordWrapping;
        case NSLineBreakByCharWrapping:
            return kCTLineBreakByCharWrapping;
        case NSLineBreakByClipping:
            return kCTLineBreakByClipping;
        case NSLineBreakByTruncatingHead:
            return kCTLineBreakByTruncatingHead;
        case NSLineBreakByTruncatingTail:
            return kCTLineBreakByTruncatingTail;
        case NSLineBreakByTruncatingMiddle:
            return kCTLineBreakByTruncatingMiddle;
        default:
            return 0;
    }
}

static inline CGFLOAT_TYPE CGFloat_ceil(CGFLOAT_TYPE cgFloat) {
#if CGFLOAT_IS_DOUBLE
    return ceil(cgFloat);
#else
    return ceilf(cgFloat);
#endif
}

static inline CGFLOAT_TYPE CGFloat_floor(CGFLOAT_TYPE cgFloat) {
#if CGFLOAT_IS_DOUBLE
    return floor(cgFloat);
#else
    return floorf(cgFloat);
#endif
}

static inline CGFLOAT_TYPE CGFloat_round(CGFLOAT_TYPE cgFloat) {
#if CGFLOAT_IS_DOUBLE
    return round(cgFloat);
#else
    return roundf(cgFloat);
#endif
}

static inline CGFloat IMFlushFactorForTextAlignment(NSTextAlignment textAlignment) {
    switch (textAlignment) {
        case IMTextAlignmentCenter:
            return 0.5;
        case IMTextAlignmentRight:
            return 1.0;
        case IMTextAlignmentLeft:
        default:
            return 0.0;
    }
}

static inline NSDictionary * NSAttributedStringAttributesFromAttributedLabel(IMAttributedLabel *attributedLabel) {
    NSMutableDictionary *mutableAttributes = [NSMutableDictionary dictionary];
    if ([NSMutableParagraphStyle class]) {
        [mutableAttributes setObject:attributedLabel.font forKey:(NSString *)kCTFontAttributeName];
        [mutableAttributes setObject:attributedLabel.textColor forKey:(NSString *)kCTForegroundColorAttributeName];
        [mutableAttributes setObject:@(attributedLabel.kern) forKey:(NSString *)kCTKernAttributeName];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = attributedLabel.textAlignment;
        paragraphStyle.lineSpacing = attributedLabel.lineSpacing;
        paragraphStyle.minimumLineHeight = attributedLabel.minimumLineHeight > 0 ? attributedLabel.minimumLineHeight : attributedLabel.font.lineHeight * attributedLabel.lineHeightMultiple;
        paragraphStyle.maximumLineHeight = attributedLabel.maximumLineHeight > 0 ? attributedLabel.maximumLineHeight : attributedLabel.font.lineHeight * attributedLabel.lineHeightMultiple;
        paragraphStyle.lineHeightMultiple = attributedLabel.lineHeightMultiple;
        paragraphStyle.firstLineHeadIndent = attributedLabel.firstLineIndent;
        paragraphStyle.headIndent = paragraphStyle.firstLineHeadIndent;
        paragraphStyle.lineBreakMode = attributedLabel.lineBreakMode;
        
        [mutableAttributes setObject:paragraphStyle forKey:(NSString *)kCTParagraphStyleAttributeName];
    } else {
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)attributedLabel.font.fontName, attributedLabel.font.pointSize, NULL);
        
        [mutableAttributes setObject:(__bridge id)font forKey:(NSString *)kCTFontAttributeName];
        CFRelease(font);
        
        [mutableAttributes setObject:(id)[attributedLabel.textColor CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
        
        [mutableAttributes setObject:@(attributedLabel.kern) forKey:(NSString *)kCTKernAttributeName];
        
        CTTextAlignment alignment = CTTextAlignmentFromIMTextAlignment(attributedLabel.textAlignment);
        CGFloat lineSpacing = attributedLabel.lineSpacing;
        CGFloat minimumLineHeight = attributedLabel.minimumLineHeight * attributedLabel.lineHeightMultiple;
        CGFloat maximumLineHeight = attributedLabel.maximumLineHeight * attributedLabel.lineHeightMultiple;
        CGFloat lineSpacingAdjustment = CGFloat_ceil(attributedLabel.font.lineHeight - attributedLabel.font.ascender + attributedLabel.font.descender);
        CGFloat lineHeightMultiple = attributedLabel.lineHeightMultiple;
        CGFloat firstLineIndent = attributedLabel.firstLineIndent;
        
        CTLineBreakMode lineBreakMode = CTLineBreakModeFromIMLineBreakMode(attributedLabel.lineBreakMode);
        
        CTParagraphStyleSetting paragraphStyles[12] = {
            {
                .spec = kCTParagraphStyleSpecifierAlignment,
                .valueSize = sizeof(CTTextAlignment),
                .value = (const void *)&alignment
            },
            {
                .spec = kCTParagraphStyleSpecifierLineBreakMode,
                .valueSize = sizeof(CTLineBreakMode),
                .value = (const void *)&lineBreakMode
            },
            {
                .spec = kCTParagraphStyleSpecifierLineSpacing,
                .valueSize = sizeof(CGFloat),
                .value = (const void *)&lineSpacing
            },
            {   .spec = kCTParagraphStyleSpecifierMinimumLineSpacing,
                .valueSize = sizeof(CGFloat),
                .value = (const void *)&minimumLineHeight
            },
            {   .spec = kCTParagraphStyleSpecifierMaximumLineSpacing,
                .valueSize = sizeof(CGFloat),
                .value = (const void *)&maximumLineHeight
            },
            {
                .spec = kCTParagraphStyleSpecifierLineSpacingAdjustment,
                .valueSize = sizeof (CGFloat),
                .value = (const void *)&lineSpacingAdjustment
            },
            {
                .spec = kCTParagraphStyleSpecifierLineHeightMultiple,
                .valueSize = sizeof(CGFloat),
                .value = (const void *)&lineHeightMultiple
            },
            {   .spec = kCTParagraphStyleSpecifierFirstLineHeadIndent,
                .valueSize = sizeof(CGFloat),
                .value = (const void *)&firstLineIndent
            }
        };
        
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(paragraphStyles, 12);
        
        [mutableAttributes setObject:(__bridge id)paragraphStyle forKey:(NSString *)kCTParagraphStyleAttributeName];
        
        CFRelease(paragraphStyle);
    }
    
    return [NSDictionary dictionaryWithDictionary:mutableAttributes];
}

static inline NSAttributedString * NSAttributedStringByScalingFontSize(NSAttributedString *attributedString, CGFloat scale) {
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    [mutableAttributedString enumerateAttribute:(NSString *)kCTFontAttributeName inRange:NSMakeRange(0, [mutableAttributedString length]) options:0 usingBlock:^(id value, NSRange range, BOOL * __unused stop) {
        UIFont *font = (UIFont *)value;
        if (font != nil) {
            NSString *fontName = nil;
            CGFloat pointSize = 0;
            
            if([font isKindOfClass:[UIFont class]]) {
                fontName = font.fontName;
                pointSize = font.pointSize;
            }else{
                fontName = (NSString *)CFBridgingRelease(CTFontCopyName((__bridge CTFontRef)font, kCTFontPostScriptNameKey));
                pointSize = CTFontGetSize((__bridge CTFontRef)font);
            }
            
            [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:range];
            CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, CGFloat_floor(pointSize * scale), NULL);
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:range];
            CFRelease(fontRef);
        }
    }];
    
    return mutableAttributedString;
}

static inline NSAttributedString * NSAttributedStringBySettingColorFromContext(NSAttributedString *attributedString, UIColor *color) {
    if (color == nil) {
        return attributedString;
    }
    
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    [mutableAttributedString enumerateAttribute:(NSString *)kCTForegroundColorFromContextAttributeName inRange:NSMakeRange(0, [mutableAttributedString length]) options:0 usingBlock:^(id value, NSRange range, __unused BOOL *stop) {
        BOOL usesColorFromContext = (BOOL)value;
        if (usesColorFromContext) {
            [mutableAttributedString setAttributes:[NSDictionary dictionaryWithObject:color forKey:(NSString *)kCTForegroundColorAttributeName] range:range];
            [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorFromContextAttributeName range:range];
        }
    }];
    
    return mutableAttributedString;
}

static inline CGSize CTFramesetterSuggestFrameSizeForAttributedStringWithConstraints(CTFramesetterRef framesetter, NSAttributedString *attributedString, CGSize size, NSUInteger numberOfLines) {
    CFRange rangeToSize = CFRangeMake(0, (CFIndex)[attributedString length]);
    CGSize constraints = CGSizeMake(size.width, IMFLOAT_MAX);
    
    if (numberOfLines == 1) {
        constraints = CGSizeMake(IMFLOAT_MAX, IMFLOAT_MAX);
    }else if (numberOfLines > 0) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0.0f, 0.0f, constraints.width, IMFLOAT_MAX));
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CFArrayRef lines = CTFrameGetLines(frame);
        
        if (CFArrayGetCount(lines) > 0) {
            NSInteger lastVisibleLineIndex = MIN((CFIndex)numberOfLines, CFArrayGetCount(lines)) - 1;
            CTLineRef lastVisibleLine = CFArrayGetValueAtIndex(lines, lastVisibleLineIndex);
            
            CFRange rangeToLayout = CTLineGetStringRange(lastVisibleLine);
            rangeToSize = CFRangeMake(0, rangeToLayout.location + rangeToLayout.length);
        }
        
        CFRelease(frame);
        CFRelease(path);
    }
    
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, rangeToSize, NULL, constraints, NULL);
    
    return CGSizeMake(CGFloat_ceil(suggestedSize.width), CGFloat_ceil(suggestedSize.height));
}

typedef struct IMGlyphMetrics {
    CGFloat ascent;
    CGFloat descent;
    CGFloat width;
} IMGlyphMetrics, *IMGlyphMetricsRef;

static void deallocCallback(void *ref) {
    free(ref), ref = NULL;
}

static CGFloat ascentCallback(void *ref) {
    IMGlyphMetricsRef glyphMetricsRef = (IMGlyphMetricsRef)ref;
    return glyphMetricsRef->ascent;
}

static CGFloat descentCallback(void *ref) {
    IMGlyphMetricsRef glyphMetricsRef = (IMGlyphMetricsRef)ref;
    return glyphMetricsRef->descent;
}

static CGFloat widthCallback(void *ref) {
    IMGlyphMetricsRef glyphMetricsRef = (IMGlyphMetricsRef)ref;
    return glyphMetricsRef->width;
}

@interface IMAttributedLabel(){
@private
    BOOL _needFramesetter;
    CTFramesetterRef _normalFramesetter;
    CTFramesetterRef _highlightedFramesetter;
    NSAttributedString *_attributedText;
}

@property (nonatomic, copy) NSAttributedString *inactiveAttributedText;
@property (nonatomic, copy) NSAttributedString *renderedAttributedText;

@property (nonatomic, strong) NSDataDetector *dataDetector;
@property (nonatomic, strong) NSArray *links;
@property (nonatomic, strong) NSTextCheckingResult *activeLink;
@property (nonatomic, strong) NSArray *accessibilityElements;

@property (nonatomic, strong) NSRegularExpression *emojiRegularExpression;
@property (nonatomic, strong) NSDictionary *emojiDictionary;

@end


@implementation IMAttributedLabel

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]){
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder{
    
    if (self = [super initWithCoder:coder]){
        [self _init];
    }
    
    return self;
}

- (void)_init{
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = NO;
    self.lineBreakMode = NSLineBreakByCharWrapping;
    
    self.lineHeightMultiple = 1.0;
    self.lineSpacing = 2.0; //默认行间距
    self.textCheckingTypes = NSTextCheckingAllTypes;
    self.links = [NSArray array];
    self.emojiFile = @"facemap.json";
    
    NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
    [mutableLinkAttributes setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    NSMutableDictionary *mutableInactiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableInactiveLinkAttributes setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    // 可点击的链接的文字颜色
    UIColor *linkColor = [UIColor colorWithHexString:kDefaultBarColor];
    
    // 点击时候的背景色
    UIColor *selectedBackgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [mutableActiveLinkAttributes setValue:(__bridge id)selectedBackgroundColor.CGColor forKey:(NSString *)kIMBackgroundFillColorAttributeName];
    
    if ([NSMutableParagraphStyle class]) {
        [mutableLinkAttributes setObject:linkColor forKey:(NSString *)kCTForegroundColorAttributeName];
        [mutableActiveLinkAttributes setObject:linkColor forKey:(NSString *)kCTForegroundColorAttributeName];
        [mutableInactiveLinkAttributes setObject:[UIColor grayColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    } else {
        [mutableLinkAttributes setObject:(__bridge id)[linkColor CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
        [mutableActiveLinkAttributes setObject:(__bridge id)[linkColor CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
        [mutableInactiveLinkAttributes setObject:(__bridge id)[[UIColor grayColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    }
    self.linkAttributes = [mutableLinkAttributes copy];
    
    self.activeLinkAttributes = [mutableActiveLinkAttributes copy];
    
    self.inactiveLinkAttributes = [mutableInactiveLinkAttributes copy];

    self.emojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _emojiEnabled = YES;
    _enableTapAttributedText = NO;
    self.verticalAlignment = IMAttributedLabelVerticalAlignmentCenter;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode{
    [super setLineBreakMode:lineBreakMode];
    
    [self setEmojiText:self.emojiText];
}

- (void)setEmojiEnabled:(BOOL)emojiEnabled{
    _emojiEnabled = emojiEnabled;
    
    [self setEmojiText:self.emojiText];
}

- (void)setEmojiRegex:(NSString *)emojiRegex{
    _emojiRegex = emojiRegex;
    if(emojiRegex != nil && emojiRegex.length > 0){
        self.emojiRegularExpression = [[NSRegularExpression alloc] initWithPattern:emojiRegex options:NSRegularExpressionCaseInsensitive error:nil];
    }else{
        self.emojiRegularExpression = nil;
    }
    
    [self setEmojiText:self.emojiText];
}

- (void)setEmojiFile:(NSString *)emojiFile{
    _emojiFile = emojiFile;
    if(emojiFile != nil && emojiFile.length > 0){
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:emojiFile ofType:nil]];
        NSMutableDictionary *emojiDictionary = [[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil] mutableCopy];
        emojiDictionary[@"[已点赞]"] = @"connection_dynamic_liked";
        self.emojiDictionary = [emojiDictionary copy];
    }else{
        self.emojiDictionary = nil;
    }
    
    [self setEmojiText:self.emojiText];
}

- (void)setEmojiText:(NSString*)emojiText{
    _emojiText = emojiText;
    if(emojiText != nil && emojiText.length > 0){
        NSMutableAttributedString *mutableAttributedString = nil;
        if (self.emojiEnabled) {
            mutableAttributedString = [self mutableAttributeStringWithEmojiText:emojiText];
        }else{
            mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:emojiText];
        }
        [self setAttributedStringText:mutableAttributedString attributedBlock:nil];
    }else{
        self.text = emojiText;
    }
}

- (NSMutableAttributedString *)mutableAttributeStringWithEmojiText:(NSString*)emojiText{
    
    NSArray *emojis = [self.emojiRegularExpression matchesInString:emojiText options:NSMatchingWithTransparentBounds range:NSMakeRange(0, [emojiText length])];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
    
    NSUInteger location = 0;
    
    CGFloat emojiWith = self.font.lineHeight;
    
    for (NSTextCheckingResult *result in emojis) {
        NSRange range = result.range;
        NSString *string = [emojiText substringWithRange:NSMakeRange(location, range.location - location)];
        NSMutableAttributedString *mutableAttributedSubString = [[NSMutableAttributedString alloc] initWithString:string];
        [mutableAttributedString appendAttributedString:mutableAttributedSubString];
        
        location = range.location + range.length;
        
        NSString *emojiKey = [emojiText substringWithRange:range];
        
        NSString *emojiImageName = self.emojiDictionary[emojiKey];
        if (emojiImageName != nil && emojiImageName.length > 0) {
            NSMutableAttributedString *replaceMutableAttributedString = [[NSMutableAttributedString alloc] initWithString:@"\uFFFC"];
            NSRange range = NSMakeRange([mutableAttributedString length], 1);
            [mutableAttributedString appendAttributedString:replaceMutableAttributedString];
           
            // 定义回调函数
            CTRunDelegateCallbacks callbacks;
            callbacks.version = kCTRunDelegateCurrentVersion;
            callbacks.getAscent = ascentCallback;
            callbacks.getDescent = descentCallback;
            callbacks.getWidth = widthCallback;
            callbacks.dealloc = deallocCallback;
            
            // 设置需要绘制表情图片的大小
            IMGlyphMetricsRef glyphMetricsRef = malloc(sizeof(IMGlyphMetrics));
            glyphMetricsRef -> width = emojiWith;
            glyphMetricsRef -> ascent = glyphMetricsRef -> width;
            glyphMetricsRef -> descent = 0.0;
            
            CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, glyphMetricsRef);
            
            [mutableAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)delegate range:range];
            CFRelease(delegate);
            
            // 设置自定义属性，绘制的时候需要用到
            [mutableAttributedString addAttribute:kIMGlyphAttributeImageName value:emojiImageName range:range];
        } else {
            NSMutableAttributedString *originalMutableAttributedString = [[NSMutableAttributedString alloc] initWithString:emojiKey];
            [mutableAttributedString appendAttributedString:originalMutableAttributedString];
        }
    }
    
    if (location < emojiText.length) {
        NSRange range = NSMakeRange(location, [emojiText length] - location);
        [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[emojiText substringWithRange:range]]];
    }
    return mutableAttributedString;
}

+ (CGSize)sizeThatFitsAttributedString:(NSAttributedString *)attributedString withConstraints:(CGSize)size limitedToNumberOfLines:(NSUInteger)numberOfLines{
    if (attributedString == nil) {
        return CGSizeZero;
    }
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    
    CGSize calculatedSize = CTFramesetterSuggestFrameSizeForAttributedStringWithConstraints(framesetter, attributedString, size, numberOfLines);
    
    CFRelease(framesetter);
    
    return calculatedSize;
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    if(![_attributedText isEqualToAttributedString:attributedText]){
        _attributedText = attributedText;
        
        [self setNeedFramesetter];
        [self setNeedsDisplay];
        
        [self invalidateIntrinsicContentSize];
    }
}

- (NSAttributedString *)attributedText{
    return _attributedText;
}

- (NSAttributedString *)renderedAttributedText {
    if (_renderedAttributedText == nil) {
        _renderedAttributedText = NSAttributedStringBySettingColorFromContext(self.attributedText, self.textColor);
    }
    
    return _renderedAttributedText;
}

- (void)setLinks:(NSArray *)links {
    _links = links;
    
    self.accessibilityElements = nil;
}

- (void)setNeedFramesetter {
    _renderedAttributedText = nil;
    _needFramesetter = YES;
}

- (CTFramesetterRef)normalFramesetter {
    if (_needFramesetter) {
        @synchronized(self) {
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.renderedAttributedText);
            [self setNormalFramesetter:framesetter];
            [self setHighlightedFramesetter:nil];
            _needFramesetter = NO;
            
            if (framesetter) {
                CFRelease(framesetter);
            }
        }
    }
    
    return _normalFramesetter;
}

- (void)setNormalFramesetter:(CTFramesetterRef)normalFramesetter {
    if (normalFramesetter) {
        CFRetain(normalFramesetter);
    }
    
    if (_normalFramesetter) {
        CFRelease(_normalFramesetter);
    }
    
    _normalFramesetter = normalFramesetter;
}

- (CTFramesetterRef)highlightedFramesetter {
    return _highlightedFramesetter;
}

- (void)setHighlightedFramesetter:(CTFramesetterRef)highlightedFramesetter {
    if (highlightedFramesetter) {
        CFRetain(highlightedFramesetter);
    }
    
    if (_highlightedFramesetter) {
        CFRelease(_highlightedFramesetter);
    }
    
    _highlightedFramesetter = highlightedFramesetter;
}

- (CGFloat)leading {
    return self.lineSpacing;
}

- (void)setLeading:(CGFloat)leading {
    self.lineSpacing = leading;
}

- (void)setTextCheckingTypes:(NSTextCheckingTypes)textCheckingTypes{
    _textCheckingTypes = textCheckingTypes;
    self.dataDetector = nil;
    if(textCheckingTypes){
       self.dataDetector = [NSDataDetector dataDetectorWithTypes:textCheckingTypes error:nil];
    }
}

- (void)addLinkWithTextCheckingResult:(NSTextCheckingResult *)textCheckingResult attributes:(NSDictionary *)attributes{
    [self addLinkWithTextCheckingResults:[NSArray arrayWithObject:textCheckingResult] attributes:attributes];
}

- (void)addLinkWithTextCheckingResults:(NSArray *)textCheckingResults attributes:(NSDictionary *)attributes{
    NSMutableArray *mutableLinks = [NSMutableArray arrayWithArray:self.links];
    if (attributes != nil) {
        NSMutableAttributedString *mutableAttributedString = [self.attributedText mutableCopy];
        for (NSTextCheckingResult *result in textCheckingResults) {
            [mutableAttributedString addAttributes:attributes range:result.range];
        }
        
        self.attributedText = mutableAttributedString;
        [self setNeedsDisplay];
    }
    [mutableLinks addObjectsFromArray:textCheckingResults];
    
    self.links = [NSArray arrayWithArray:mutableLinks];
}

- (void)addLinkWithTextCheckingResult:(NSTextCheckingResult *)textCheckingResult {
    [self addLinkWithTextCheckingResult:textCheckingResult attributes:self.linkAttributes];
}

- (void)addLinkToURL:(NSURL *)url withRange:(NSRange)range{
    [self addLinkWithTextCheckingResult:[NSTextCheckingResult linkCheckingResultWithRange:range URL:url]];
}

- (void)addLinkToAddress:(NSDictionary *)addressComponents withRange:(NSRange)range{
    [self addLinkWithTextCheckingResult:[NSTextCheckingResult addressCheckingResultWithRange:range components:addressComponents]];
}

- (void)addLinkToPhoneNumber:(NSString *)phoneNumber withRange:(NSRange)range{
    [self addLinkWithTextCheckingResult:[NSTextCheckingResult phoneNumberCheckingResultWithRange:range phoneNumber:phoneNumber]];
}

- (void)addLinkToDate:(NSDate *)date withRange:(NSRange)range{
    [self addLinkWithTextCheckingResult:[NSTextCheckingResult dateCheckingResultWithRange:range date:date]];
}

- (void)addLinkToDate:(NSDate *)date timeZone:(NSTimeZone *)timeZone duration:(NSTimeInterval)duration withRange:(NSRange)range{
    [self addLinkWithTextCheckingResult:[NSTextCheckingResult dateCheckingResultWithRange:range date:date timeZone:timeZone duration:duration]];
}

- (void)addLinkToTransitInformation:(NSDictionary *)components withRange:(NSRange)range{
    [self addLinkWithTextCheckingResult:[NSTextCheckingResult transitInformationCheckingResultWithRange:range components:components]];
}

- (NSTextCheckingResult *)linkAtCharacterIndex:(CFIndex)idx {
    NSEnumerator *enumerator = [self.links reverseObjectEnumerator];
    NSTextCheckingResult *result = nil;
    while ((result = [enumerator nextObject])) {
        if (NSLocationInRange((NSUInteger)idx, result.range)) {
            return result;
        }
    }
    
    return nil;
}

- (NSTextCheckingResult *)linkAtPoint:(CGPoint)point {
    CFIndex index = [self characterIndexAtPoint:point];
    
    return [self linkAtCharacterIndex:index];
}

- (CFIndex)characterIndexAtPoint:(CGPoint)point {
    if (!CGRectContainsPoint(self.bounds, point)) {
        return NSNotFound;
    }
    
    CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    if (!CGRectContainsPoint(textRect, point)) {
        return NSNotFound;
    }
    
    CGFloat flushFactor = IMFlushFactorForTextAlignment(self.textAlignment);
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    point = CGPointMake(point.x, textRect.size.height - point.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    CTFrameRef frame = CTFramesetterCreateFrame([self normalFramesetter], CFRangeMake(0, (CFIndex)[self.attributedText length]), path, NULL);
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    CFIndex index = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex ++) {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        CGFloat penOffset = (CGFloat)CTLineGetPenOffsetForFlush(line, flushFactor, textRect.size.width);
        
        CGFloat ascent = 0;
        CGFloat descent = 0;
        CGFloat leading = 0;
        CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = (CGFloat)floor(lineOrigin.y - descent);
        CGFloat yMax = (CGFloat)ceil(lineOrigin.y + ascent);
    
        if (point.y > yMax) {
            break;
        }
        if (point.y >= yMin) {
            if (point.x >= penOffset && point.x <= penOffset + width) {
                CGPoint relativePoint = CGPointMake(point.x - penOffset, point.y - lineOrigin.y);
                index = CTLineGetStringIndexForPosition(line, relativePoint);
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    
    return index;
}

- (CGRect)boundingRectForCharacterRange:(NSRange)range {
    NSMutableAttributedString *mutableAttributedString = [self.attributedText mutableCopy];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:mutableAttributedString];
    
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
    [layoutManager addTextContainer:textContainer];
    
    NSRange glyphRange;
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
    
    return [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
}

- (void)drawFramesetter:(CTFramesetterRef)framesetter attributedString:(NSAttributedString *)attributedString textRange:(CFRange)textRange inRect:(CGRect)rect context:(CGContextRef)context{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, textRange, path, NULL);
    
    [self drawBackground:frame inRect:rect context:context];
    
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    BOOL truncateLastLine = (self.lineBreakMode == IMLineBreakByTruncatingHead || self.lineBreakMode == IMLineBreakByTruncatingMiddle || self.lineBreakMode == IMLineBreakByTruncatingTail);
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex ++) {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        lineOrigin = CGPointMake(CGFloat_ceil(lineOrigin.x), CGFloat_ceil(lineOrigin.y));
        
        CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        CGFloat descent = 0.0;
        CTLineGetTypographicBounds((CTLineRef)line, NULL, &descent, NULL);
        
        CGFloat flushFactor = IMFlushFactorForTextAlignment(self.textAlignment);
        
        if (lineIndex == numberOfLines - 1 && truncateLastLine) {
            CFRange lastLineRange = CTLineGetStringRange(line);
            
            if (!(lastLineRange.length == 0 && lastLineRange.location == 0) && lastLineRange.location + lastLineRange.length < textRange.location + textRange.length) {
                CTLineTruncationType truncationType;
                CFIndex truncationAttributePosition = lastLineRange.location;
                IMLineBreakMode lineBreakMode = self.lineBreakMode;
                
                if (numberOfLines != 1) {
                    lineBreakMode = IMLineBreakByTruncatingTail;
                }
                
                switch (lineBreakMode) {
                    case IMLineBreakByTruncatingHead:
                        truncationType = kCTLineTruncationStart;
                        break;
                    case IMLineBreakByTruncatingMiddle:
                        truncationType = kCTLineTruncationMiddle;
                        truncationAttributePosition += (lastLineRange.length / 2);
                        break;
                    case IMLineBreakByTruncatingTail:
                    default:
                        truncationType = kCTLineTruncationEnd;
                        truncationAttributePosition += (lastLineRange.length - 1);
                        break;
                }
                
                NSString *truncationTokenString = self.truncationTokenString;
                if (truncationTokenString == nil) {
                    truncationTokenString = @"\u2026";
                }
                
                NSDictionary *truncationTokenStringAttributes = self.truncationTokenStringAttributes;
                if (truncationTokenStringAttributes == nil) {
                    truncationTokenStringAttributes = [attributedString attributesAtIndex:(NSUInteger)truncationAttributePosition effectiveRange:NULL];
                }
                
                NSAttributedString *attributedTokenString = [[NSAttributedString alloc] initWithString:truncationTokenString attributes:truncationTokenStringAttributes];
                CTLineRef truncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attributedTokenString);
                
                NSMutableAttributedString *truncationString = [[attributedString attributedSubstringFromRange:NSMakeRange((NSUInteger)lastLineRange.location, (NSUInteger)lastLineRange.length)] mutableCopy];
                if (lastLineRange.length > 0) {
                    unichar lastCharacter = [[truncationString string] characterAtIndex:(NSUInteger)(lastLineRange.length - 1)];
                    if ([[NSCharacterSet newlineCharacterSet] characterIsMember:lastCharacter]){
                        [truncationString deleteCharactersInRange:NSMakeRange((NSUInteger)(lastLineRange.length - 1), 1)];
                    }
                }
                [truncationString appendAttributedString:attributedTokenString];
                CTLineRef truncationLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)truncationString);
                
                CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, rect.size.width, truncationType, truncationToken);
                if (!truncatedLine) {
                    truncatedLine = CFRetain(truncationToken);
                }
                
                CGFloat penOffset = (CGFloat)CTLineGetPenOffsetForFlush(truncatedLine, flushFactor, rect.size.width);
                CGContextSetTextPosition(context, penOffset, lineOrigin.y - descent - self.font.descender - 2.0);
                CTLineDraw(truncatedLine, context);
                
                CFRelease(truncatedLine);
                CFRelease(truncationLine);
                CFRelease(truncationToken);
            } else {
                CGFloat penOffset = (CGFloat)CTLineGetPenOffsetForFlush(line, flushFactor, rect.size.width);
                CGContextSetTextPosition(context, penOffset, lineOrigin.y - descent - self.font.descender - 2.0);
                CTLineDraw(line, context);
            }
        } else {
            CGFloat penOffset = (CGFloat)CTLineGetPenOffsetForFlush(line, flushFactor, rect.size.width);
            CGContextSetTextPosition(context, penOffset, lineOrigin.y - descent - self.font.descender - 2.0);
            CTLineDraw(line, context);
        }
    }
    
    [self drawStrike:frame inRect:rect context:context];
    
    [self drawWithFrame:frame inRect:rect context:context];
    
    CFRelease(frame);
    CFRelease(path);
}

- (void)drawWithFrame:(CTFrameRef)frame inRect:(CGRect)rect context:(CGContextRef)context{
    CGFloat emojiOriginYOffset = self.font.lineHeight * kIMEmojiOriginYOffsetRatioWithLineHeight;
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    CGFloat flushFactor = IMFlushFactorForTextAlignment(self.textAlignment);
    
    CFIndex lineIndex = 0;
    for (id line in lines) {
        CGFloat ascent = 0;
        CGFloat descent = 0;
        CGFloat leading = 0;
        
        CGFloat width = (CGFloat)CTLineGetTypographicBounds((__bridge CTLineRef)line, &ascent, &descent, &leading);
        CGRect lineBounds = CGRectMake(0, 0, width, ascent + descent + leading);
        
        lineBounds.origin.x = origins[lineIndex].x;
        lineBounds.origin.y = origins[lineIndex].y;
        
        CGFloat penOffset = (CGFloat)CTLineGetPenOffsetForFlush((__bridge CTLineRef)line, flushFactor, rect.size.width);
        
        for (id lineGetGlyphRuns in (__bridge NSArray *)CTLineGetGlyphRuns((__bridge CTLineRef)line)) {
            NSDictionary *attributes = (__bridge NSDictionary *)CTRunGetAttributes((__bridge CTRunRef) lineGetGlyphRuns);
            NSString *emojiImageName = attributes[kIMGlyphAttributeImageName];
            if (emojiImageName != nil && emojiImageName.length > 0) {
                CGRect runBounds = CGRectZero;
                CGFloat runAscent = 0;
                CGFloat runDescent = 0;
                
                runBounds.size.width = (CGFloat)CTRunGetTypographicBounds((__bridge CTRunRef)lineGetGlyphRuns, CFRangeMake(0, 0), &runAscent, &runDescent, NULL);
                runBounds.size.height = runAscent + runDescent;
                
                CGFloat xOffset = 0;
                CFRange glyphRange = CTRunGetStringRange((__bridge CTRunRef)lineGetGlyphRuns);
                switch (CTRunGetStatus((__bridge CTRunRef)lineGetGlyphRuns)) {
                    case kCTRunStatusRightToLeft:
                        xOffset = CTLineGetOffsetForStringIndex((__bridge CTLineRef)line, glyphRange.location + glyphRange.length, NULL);
                        break;
                    default:
                        xOffset = CTLineGetOffsetForStringIndex((__bridge CTLineRef)line, glyphRange.location, NULL);
                        break;
                }
                runBounds.origin.x = penOffset + xOffset;
                runBounds.origin.y = origins[lineIndex].y;
                runBounds.origin.y -= runDescent + 3.0;
                
                UIImage *image = [UIImage imageNamed:emojiImageName];
                runBounds.origin.y -= emojiOriginYOffset;
                CGContextDrawImage(context, runBounds, image.CGImage);
            }
        }
        
        lineIndex ++;
    }
}

- (void)drawBackground:(CTFrameRef)frame inRect:(CGRect)rect context:(CGContextRef)context{
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    CGFloat flushFactor = IMFlushFactorForTextAlignment(self.textAlignment);
    
    CFIndex lineIndex = 0;
    for (id line in lines) {
        CGFloat ascent = 0;
        CGFloat descent = 0;
        CGFloat leading = 0;
        CGFloat width = (CGFloat)CTLineGetTypographicBounds((__bridge CTLineRef)line, &ascent, &descent, &leading) ;
        CGRect lineBounds = CGRectMake(rect.origin.x, rect.origin.y, width, ascent + descent + leading) ;
        
        CGFloat penOffset = (CGFloat)CTLineGetPenOffsetForFlush((__bridge CTLineRef)line, flushFactor, rect.size.width);
        
        lineBounds.origin.x += origins[lineIndex].x;
        lineBounds.origin.y += origins[lineIndex].y;
        
        for (id glyphRun in (__bridge NSArray *)CTLineGetGlyphRuns((__bridge CTLineRef)line)) {
            NSDictionary *attributes = (__bridge NSDictionary *)CTRunGetAttributes((__bridge CTRunRef) glyphRun);
            CGColorRef strokeColor = (__bridge CGColorRef)[attributes objectForKey:kIMBackgroundStrokeColorAttributeName];
            CGColorRef fillColor = (__bridge CGColorRef)[attributes objectForKey:kIMBackgroundFillColorAttributeName];
            UIEdgeInsets fillPadding = [[attributes objectForKey:kIMBackgroundFillPaddingAttributeName] UIEdgeInsetsValue];
            CGFloat cornerRadius = [[attributes objectForKey:kIMBackgroundCornerRadiusAttributeName] floatValue];
            CGFloat lineWidth = [[attributes objectForKey:kIMBackgroundLineWidthAttributeName] floatValue];
            
            if (strokeColor || fillColor) {
                CGRect runBounds = CGRectZero;
                CGFloat runAscent = 0;
                CGFloat runDescent = 0;
                
                runBounds.size.width = (CGFloat)CTRunGetTypographicBounds((__bridge CTRunRef)glyphRun, CFRangeMake(0, 0), &runAscent, &runDescent, NULL) + fillPadding.left + fillPadding.right;
                runBounds.size.height = runAscent + runDescent + fillPadding.top + fillPadding.bottom;
                
                CGFloat xOffset = 0;
                CFRange glyphRange = CTRunGetStringRange((__bridge CTRunRef)glyphRun);
                switch (CTRunGetStatus((__bridge CTRunRef)glyphRun)) {
                    case kCTRunStatusRightToLeft:
                        xOffset = CTLineGetOffsetForStringIndex((__bridge CTLineRef)line, glyphRange.location + glyphRange.length, NULL);
                        break;
                    default:
                        xOffset = CTLineGetOffsetForStringIndex((__bridge CTLineRef)line, glyphRange.location, NULL);
                        break;
                }
                
                runBounds.origin.x = penOffset + xOffset - fillPadding.left;
                runBounds.origin.y = origins[lineIndex].y + fillPadding.bottom - runDescent;
                
                if (CGRectGetWidth(runBounds) > CGRectGetWidth(lineBounds)) {
                    runBounds.size.width = CGRectGetWidth(lineBounds);
                }
                
                CGPathRef path = [[UIBezierPath bezierPathWithRoundedRect:CGRectInset(CGRectInset(runBounds, -1.0, -1.0), lineWidth, lineWidth) cornerRadius:cornerRadius] CGPath];
                
                CGContextSetLineJoin(context, kCGLineJoinRound);
                
                if (fillColor) {
                    CGContextSetFillColorWithColor(context, fillColor);
                    CGContextAddPath(context, path);
                    CGContextFillPath(context);
                }
                
                if (strokeColor) {
                    CGContextSetStrokeColorWithColor(context, strokeColor);
                    CGContextAddPath(context, path);
                    CGContextStrokePath(context);
                }
            }
        }
        
        lineIndex ++;
    }
}

- (void)drawStrike:(CTFrameRef)frame inRect:(__unused CGRect)rect context:(CGContextRef)context{
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    CGFloat flushFactor = IMFlushFactorForTextAlignment(self.textAlignment);
    
    CFIndex lineIndex = 0;
    for (id line in lines) {
        CGFloat ascent = 0.0f, descent = 0.0f, leading = 0.0f;
        CGFloat width = (CGFloat)CTLineGetTypographicBounds((__bridge CTLineRef)line, &ascent, &descent, &leading) ;
        CGRect lineBounds = CGRectMake(0.0f, 0.0f, width, ascent + descent + leading) ;
        lineBounds.origin.x = origins[lineIndex].x;
        lineBounds.origin.y = origins[lineIndex].y;
        
        CGFloat penOffset = (CGFloat)CTLineGetPenOffsetForFlush((__bridge CTLineRef)line, flushFactor, rect.size.width);
        
        for (id glyphRun in (__bridge NSArray *)CTLineGetGlyphRuns((__bridge CTLineRef)line)) {
            NSDictionary *attributes = (__bridge NSDictionary *)CTRunGetAttributes((__bridge CTRunRef) glyphRun);
            BOOL strikeOut = [[attributes objectForKey:kIMStrikeOutAttributeName] boolValue];
            NSInteger superscriptStyle = [[attributes objectForKey:(id)kCTSuperscriptAttributeName] integerValue];
            
            if (strikeOut) {
                CGRect runBounds = CGRectZero;
                CGFloat runAscent = 0.0f;
                CGFloat runDescent = 0.0f;
                
                runBounds.size.width = (CGFloat)CTRunGetTypographicBounds((__bridge CTRunRef)glyphRun, CFRangeMake(0, 0), &runAscent, &runDescent, NULL);
                runBounds.size.height = runAscent + runDescent;
                
                CGFloat xOffset = 0.0f;
                CFRange glyphRange = CTRunGetStringRange((__bridge CTRunRef)glyphRun);
                switch (CTRunGetStatus((__bridge CTRunRef)glyphRun)) {
                    case kCTRunStatusRightToLeft:
                        xOffset = CTLineGetOffsetForStringIndex((__bridge CTLineRef)line, glyphRange.location + glyphRange.length, NULL);
                        break;
                    default:
                        xOffset = CTLineGetOffsetForStringIndex((__bridge CTLineRef)line, glyphRange.location, NULL);
                        break;
                }
                runBounds.origin.x = penOffset + xOffset;
                runBounds.origin.y = origins[lineIndex].y;
                runBounds.origin.y -= runDescent;
                
                if (CGRectGetWidth(runBounds) > CGRectGetWidth(lineBounds)) {
                    runBounds.size.width = CGRectGetWidth(lineBounds);
                }
                
                switch (superscriptStyle) {
                    case 1:
                        runBounds.origin.y -= runAscent * 0.47f;
                        break;
                    case -1:
                        runBounds.origin.y += runAscent * 0.25f;
                        break;
                    default:
                        break;
                }
                
                id color = [attributes objectForKey:(id)kCTForegroundColorAttributeName];
                if (color) {
                    if ([color isKindOfClass:[UIColor class]]) {
                        CGContextSetStrokeColorWithColor(context, [color CGColor]);
                    } else {
                        CGContextSetStrokeColorWithColor(context, (__bridge CGColorRef)color);
                    }
                } else {
                    CGContextSetGrayStrokeColor(context, 0.0f, 1.0);
                }
                
                CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)self.font.fontName, self.font.pointSize, NULL);
                CGContextSetLineWidth(context, CTFontGetUnderlineThickness(font));
                CFRelease(font);
                
                CGFloat y = CGFloat_round(runBounds.origin.y + runBounds.size.height / 2.0f);
                CGContextMoveToPoint(context, runBounds.origin.x, y);
                CGContextAddLineToPoint(context, runBounds.origin.x + runBounds.size.width, y);
                
                CGContextStrokePath(context);
            }
        }
        
        lineIndex ++;
    }
}

#pragma mark - IMAttributedLabel

- (void)setNormalStringText:(NSString *)normalStringText{
    [self setNormalStringText:normalStringText attributedBlock:nil];
}

- (void)setAttributedStringText:(NSMutableAttributedString *)attributedStringText{
    self.attributedText = attributedStringText;
    self.activeLink = nil;
    
    self.links = [NSArray array];
    
    if (self.textCheckingTypes != 0) {
        __weak __typeof(self) wself = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __strong __typeof(wself) sself = wself;
            if(sself.dataDetector != nil){
                NSArray *results = [sself.dataDetector matchesInString:attributedStringText.string options:0 range:NSMakeRange(0, attributedStringText.length)];
                if ([results count] > 0) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if ([sself.attributedText.string isEqualToString:attributedStringText.string]) {
                            [sself addLinkWithTextCheckingResults:results attributes:sself.linkAttributes];
                        }
                    });
                }
            }
        });
        
        if (&NSLinkAttributeName) {
            [self.attributedText enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(id value, __unused NSRange range, __unused BOOL *stop) {
                if (value != nil) {
                    NSURL *url = nil;
                    if([value isKindOfClass:[NSString class]]){
                        url = [NSURL URLWithString:value];
                    }else{
                        url = value;
                    }
                    [self addLinkToURL:url withRange:range];
                }
            }];
        }
        self.text = self.attributedText.string;
    }
}

- (void)setNormalStringText:(NSString *)normalStringText attributedBlock:(NSMutableAttributedString *(^)(NSMutableAttributedString *))attributedBlock{
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:normalStringText attributes:NSAttributedStringAttributesFromAttributedLabel(self)];
    if(attributedBlock){
        mutableAttributedString = attributedBlock(mutableAttributedString);
    }
    
    [self setAttributedText:mutableAttributedString];
}

- (void)setAttributedStringText:(NSMutableAttributedString *)attributedStringText attributedBlock:(NSMutableAttributedString *(^)(NSMutableAttributedString *))attributedBlock{

    [attributedStringText addAttributes:NSAttributedStringAttributesFromAttributedLabel(self) range:NSMakeRange(0, [attributedStringText length])];
    if(attributedBlock){
        attributedStringText = attributedBlock(attributedStringText);
    }
    
    [self setAttributedText:attributedStringText];
}

- (void)setActiveLink:(NSTextCheckingResult *)activeLink {
    _activeLink = activeLink;
    if (activeLink != nil && [self.activeLinkAttributes count] > 0) {
        if (self.inactiveAttributedText == nil) {
            self.inactiveAttributedText = [self.attributedText copy];
        }
        
        NSMutableAttributedString *mutableAttributedString = [self.inactiveAttributedText mutableCopy];
        if (self.activeLink.range.length > 0 && NSLocationInRange(NSMaxRange(self.activeLink.range) - 1, NSMakeRange(0, [self.inactiveAttributedText length]))) {
            [mutableAttributedString addAttributes:self.activeLinkAttributes range:self.activeLink.range];
        }
        
        self.attributedText = mutableAttributedString;
        [self setNeedsDisplay];
        
        [CATransaction flush];
    } else if (self.inactiveAttributedText) {
        self.attributedText = self.inactiveAttributedText;
        self.inactiveAttributedText = nil;
        
        [self setNeedsDisplay];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (UIColor *)textColor {
    UIColor *color = [super textColor];
    if (color == nil) {
        color = [UIColor blackColor];
    }
    return color;
}

- (void)setTextColor:(UIColor *)textColor {
    UIColor *oldTextColor = self.textColor;
    [super setTextColor:textColor];
    
    if (textColor != oldTextColor) {
        [self setNeedFramesetter];
        [self setNeedsDisplay];
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines{
    bounds = UIEdgeInsetsInsetRect(bounds, self.textInsets);
    if (self.attributedText == nil) {
        return [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    }
    
    CGRect textRect = bounds;
    
    textRect.size.height = MAX(self.font.pointSize * 2.0f, bounds.size.height);
    
    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints([self normalFramesetter], CFRangeMake(0, (CFIndex)[self.attributedText length]), NULL, textRect.size, NULL);
    textSize = CGSizeMake(CGFloat_ceil(textSize.width), CGFloat_ceil(textSize.height));
    
    if (textSize.height < textRect.size.height) {
        CGFloat yOffset = 0.0f;
        switch (self.verticalAlignment) {
            case IMAttributedLabelVerticalAlignmentCenter:
                yOffset = CGFloat_floor((bounds.size.height - textSize.height) / 2.0);
                break;
            case IMAttributedLabelVerticalAlignmentBottom:
                yOffset = bounds.size.height - textSize.height;
                break;
            case IMAttributedLabelVerticalAlignmentTop:
            default:
                break;
        }
        
        textRect.origin.y += yOffset;
    }
    
    return textRect;
}

- (void)drawTextInRect:(CGRect)rect {
    CGRect insetRect = UIEdgeInsetsInsetRect(rect, self.textInsets);
    if (self.attributedText == nil) {
        [super drawTextInRect:insetRect];
        return;
    }
    
    NSAttributedString *originalAttributedText = nil;
    
    if (self.adjustsFontSizeToFitWidth && self.numberOfLines > 0) {
        CGSize maxSize = (self.numberOfLines > 1) ? CGSizeMake(IMFLOAT_MAX, IMFLOAT_MAX) : CGSizeZero;
        
        CGFloat textWidth = [self sizeThatFits:maxSize].width;
        CGFloat availableWidth = self.frame.size.width * self.numberOfLines;
        if (self.numberOfLines > 1 && self.lineBreakMode == IMLineBreakByWordWrapping) {
            textWidth *= kIMLineBreakWordWrapTextWidthScalingFactor;
        }
        
        if (textWidth > availableWidth && textWidth > 0.0f) {
            originalAttributedText = [self.attributedText copy];
            
            CGFloat scaleFactor = availableWidth / textWidth;
            if ([self respondsToSelector:@selector(minimumScaleFactor)] && self.minimumScaleFactor > scaleFactor) {
                scaleFactor = self.minimumScaleFactor;
            }
            
            self.attributedText = NSAttributedStringByScalingFontSize(self.attributedText, scaleFactor);
        }
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0.0f, insetRect.size.height);
        CGContextScaleCTM(context, 1.0f, -1.0f);
    
        CFRange textRange = CFRangeMake(0, (CFIndex)[self.attributedText length]);
    
        CGRect textRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    
        CGContextTranslateCTM(context, insetRect.origin.x, insetRect.size.height - textRect.origin.y - textRect.size.height);
    
        if (self.shadowColor && !self.highlighted) {
            CGContextSetShadowWithColor(context, self.shadowOffset, self.shadowRadius, [self.shadowColor CGColor]);
        } else if (self.highlightedShadowColor) {
            CGContextSetShadowWithColor(context, self.highlightedShadowOffset, self.highlightedShadowRadius, [self.highlightedShadowColor CGColor]);
        }
    
        if (self.highlightedTextColor && self.highlighted) {
            NSMutableAttributedString *highlightAttributedString = [self.renderedAttributedText mutableCopy];
            [highlightAttributedString addAttribute:(__bridge NSString *)kCTForegroundColorAttributeName value:(id)[self.highlightedTextColor CGColor] range:NSMakeRange(0, highlightAttributedString.length)];
        
            if (![self highlightedFramesetter]) {
                CTFramesetterRef highlightedFramesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)highlightAttributedString);
                [self setHighlightedFramesetter:highlightedFramesetter];
                CFRelease(highlightedFramesetter);
            }
        
            [self drawFramesetter:[self highlightedFramesetter] attributedString:highlightAttributedString textRange:textRange inRect:textRect context:context];
        } else {
            [self drawFramesetter:[self normalFramesetter] attributedString:self.renderedAttributedText textRange:textRange inRect:textRect context:context];
        }
    
        if (originalAttributedText != nil) {
            _attributedText = originalAttributedText;
        }
    }
    CGContextRestoreGState(context);
}

- (BOOL)isAccessibilityElement {
    return NO;
}

- (NSInteger)accessibilityElementCount {
    return (NSInteger)[[self accessibilityElements] count];
}

- (id)accessibilityElementAtIndex:(NSInteger)index {
    return [[self accessibilityElements] objectAtIndex:(NSUInteger)index];
}

- (NSInteger)indexOfAccessibilityElement:(id)element {
    return (NSInteger)[[self accessibilityElements] indexOfObject:element];
}

- (NSArray *)accessibilityElements {
    if (_accessibilityElements == nil) {
        @synchronized(self) {
            NSMutableArray *mutableAccessibilityItems = [NSMutableArray array];
            
            for (NSTextCheckingResult *result in self.links) {
                NSString *sourceText = [self.text isKindOfClass:[NSString class]] ? self.text : [(NSAttributedString *)self.text string];
                
                NSString *accessibilityLabel = [sourceText substringWithRange:result.range];
                NSString *accessibilityValue = nil;
                
                switch (result.resultType) {
                    case NSTextCheckingTypeLink:
                        accessibilityValue = result.URL.absoluteString;
                        break;
                    case NSTextCheckingTypePhoneNumber:
                        accessibilityValue = result.phoneNumber;
                        break;
                    case NSTextCheckingTypeDate:
                        accessibilityValue = [NSDateFormatter localizedStringFromDate:result.date dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle];
                        break;
                    default:
                        break;
                }
                
                if (accessibilityLabel) {
                    UIAccessibilityElement *linkElement = [[UIAccessibilityElement alloc] initWithAccessibilityContainer:self];
                    linkElement.accessibilityTraits = UIAccessibilityTraitLink;
                    linkElement.accessibilityFrame = [self convertRect:[self boundingRectForCharacterRange:result.range] toView:self.window];
                    
                    if (![accessibilityLabel isEqualToString:accessibilityValue]) {
                        linkElement.accessibilityValue = accessibilityValue;
                    }
                    
                    [mutableAccessibilityItems addObject:linkElement];
                }
            }
            
            UIAccessibilityElement *baseElement = [[UIAccessibilityElement alloc] initWithAccessibilityContainer:self];
            baseElement.accessibilityLabel = [super accessibilityLabel];
            baseElement.accessibilityHint = [super accessibilityHint];
            baseElement.accessibilityValue = [super accessibilityValue];
            baseElement.accessibilityFrame = [self convertRect:self.bounds toView:self.window];
            baseElement.accessibilityTraits = [super accessibilityTraits];
            
            [mutableAccessibilityItems addObject:baseElement];
            
            self.accessibilityElements = [NSArray arrayWithArray:mutableAccessibilityItems];
        }
    }
    
    return _accessibilityElements;
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (!self.attributedText) {
        return [super sizeThatFits:size];
    } else {
        size = CTFramesetterSuggestFrameSizeForAttributedStringWithConstraints([self normalFramesetter], self.attributedText, size, (NSUInteger)self.numberOfLines);
        size.width += self.textInsets.left + self.textInsets.right;
        size.height += self.textInsets.top + self.textInsets.bottom + 1;
        return size;
    }
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:[super intrinsicContentSize]];
}

- (void)tintColorDidChange {
    if(self.inactiveLinkAttributes != nil && self.inactiveLinkAttributes.count > 0){
        NSDictionary *removeAttributes = self.inactiveLinkAttributes;
        NSDictionary *addAttributes = self.linkAttributes;
        if(self.tintAdjustmentMode == UIViewTintAdjustmentModeDimmed){
            removeAttributes = self.linkAttributes;
            addAttributes = self.inactiveLinkAttributes;
        }
        
        NSMutableAttributedString *mutableAttributedString = [self.attributedText mutableCopy];
        for (NSTextCheckingResult *result in self.links) {
            [removeAttributes enumerateKeysAndObjectsUsingBlock:^(NSString *name, __unused id value, __unused BOOL *stop) {
                [mutableAttributedString removeAttribute:name range:result.range];
            }];
        
            if (addAttributes != nil) {
                [mutableAttributedString addAttributes:addAttributes range:result.range];
            }
        }
        
        self.attributedText = mutableAttributedString;
        [self setNeedsDisplay];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    self.activeLink = [self linkAtPoint:[touch locationInView:self]];
    
    if (self.activeLink == nil) {
        if(self.isEnableTapAttributedText){
            CGColorRef colorRef = (__bridge CGColorRef)(self.activeLinkAttributes[kIMBackgroundFillColorAttributeName]);
            self.backgroundColor = [UIColor colorWithCGColor:colorRef];
        }
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.activeLink != nil) {
        UITouch *touch = [touches anyObject];
        if (self.activeLink != [self linkAtPoint:[touch locationInView:self]]) {
            self.activeLink = nil;
        }
    } else {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.activeLink != nil) {
        NSTextCheckingResult *result = self.activeLink;
        self.activeLink = nil;
        
        switch (result.resultType) {
            case NSTextCheckingTypeLink:
                if (self.delegate && [self.delegate respondsToSelector:@selector(attributedLabel:didSelectedLinkWithURL:andRange:)]) {
                    [self.delegate attributedLabel:self didSelectedLinkWithURL:result.URL andRange:result.range];
                }
                break;
            case NSTextCheckingTypeAddress:
                if (self.delegate && [self.delegate respondsToSelector:@selector(attributedLabel:didSelectedLinkWithAddress:andRange:)]) {
                    [self.delegate attributedLabel:self didSelectedLinkWithAddress:result.addressComponents andRange:result.range];
                }
                break;
            case NSTextCheckingTypePhoneNumber:
                if (self.delegate && [self.delegate respondsToSelector:@selector(attributedLabel:didSelectedLinkWithPhoneNumber:andRange:)]) {
                    [self.delegate attributedLabel:self didSelectedLinkWithPhoneNumber:result.phoneNumber andRange:result.range];
                }
                break;
            case NSTextCheckingTypeDate:
                if (result.timeZone && self.delegate && [self.delegate respondsToSelector:@selector(attributedLabel:didSelectedLinkWithDate:timeZone:duration:andRange:)]) {
                    [self.delegate attributedLabel:self didSelectedLinkWithDate:result.date timeZone:result.timeZone duration:result.duration andRange:result.range];
                } else if (self.delegate && [self.delegate respondsToSelector:@selector(attributedLabel:didSelectedLinkWithDate:andRange:)]) {
                    [self.delegate attributedLabel:self didSelectedLinkWithDate:result.date andRange:result.range];
                }
                break;
            case NSTextCheckingTypeTransitInformation:
                if (self.delegate && [self.delegate respondsToSelector:@selector(attributedLabel:didSelectedLinkWithTransitInformation:andRange:)]) {
                    [self.delegate attributedLabel:self didSelectedLinkWithTransitInformation:result.components andRange:result.range];
                }
                break;
            default:
                break;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(attributedLabel:didSelectedLinkWithTextCheckingResult:)]) {
            [self.delegate attributedLabel:self didSelectedLinkWithTextCheckingResult:result];
        }
        
        if(self.textSelectedHandler){
            self.textSelectedHandler(self, result);
        }
    } else {
        if(self.isEnableTapAttributedText){
            if(self.delegate && [self.delegate respondsToSelector:@selector(attributedLabel:didTapText:)]){
                [self.delegate attributedLabel:self didTapText:self.emojiText];
            }
        
            if(self.textTapHandler){
                self.textTapHandler(self, self.emojiText);
            }
        
            self.backgroundColor = [UIColor clearColor];
        }
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.activeLink != nil) {
        self.activeLink = nil;
    }else{
        if(self.isEnableTapAttributedText){
            self.backgroundColor = [UIColor clearColor];
        }
        [super touchesCancelled:touches withEvent:event];
    }
}

- (void)dealloc {
    if (_normalFramesetter) {
        CFRelease(_normalFramesetter);
    }
    
    if (_highlightedFramesetter) {
        CFRelease(_highlightedFramesetter);
    }
}

@end

NSString * const kIMStrikeOutAttributeName = @"IMStrikeOutAttributeName";
NSString * const kIMBackgroundFillColorAttributeName = @"IMBackgroundFillColorAttributeName";
NSString * const kIMBackgroundFillPaddingAttributeName = @"IMBackgroundFillPaddingAttributeName";
NSString * const kIMBackgroundStrokeColorAttributeName = @"IMBackgroundStrokeColorAttributeName";
NSString * const kIMBackgroundLineWidthAttributeName = @"IMBackgroundLineWidthAttributeName";
NSString * const kIMBackgroundCornerRadiusAttributeName = @"IMBackgroundCornerRadiusAttributeName";
NSString * const kIMGlyphAttributeImageName = @"IMGlyphAttributeImageName";
CGFloat const kIMEmojiOriginYOffsetRatioWithLineHeight = 0.1;

