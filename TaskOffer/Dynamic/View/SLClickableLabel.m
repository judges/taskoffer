//
//  SLClickableLabel.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/29.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLClickableLabel.h"
#import "UIColor+Equalable.h"

@interface SLClickableLabel () <NSLayoutManagerDelegate>

@property (nonatomic, strong) NSLayoutManager *layoutManager;
@property (nonatomic, strong) NSTextContainer *textContainer;
@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, assign) BOOL isTouchMoved;
@property (nonatomic, assign) NSRange clickRange;

@property (nonatomic, strong) NSMutableArray *mutableClickableRanges;

@end

@implementation SLClickableLabel

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setupTextSystem];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self){
        [self setupTextSystem];
    }
    return self;
}

- (void)setupTextSystem{
    _mutableClickableRanges = [NSMutableArray array];
    
    self.textContainer = [[NSTextContainer alloc] init];
    self.textContainer.lineFragmentPadding = 0;
    self.textContainer.maximumNumberOfLines = self.numberOfLines;
    self.textContainer.lineBreakMode = self.lineBreakMode;
    self.textContainer.size = self.frame.size;
    
    self.layoutManager = [[NSLayoutManager alloc] init];
    self.layoutManager.delegate = self;
    [self.layoutManager addTextContainer:self.textContainer];
    
    [self.textContainer setLayoutManager:self.layoutManager];
    
    self.userInteractionEnabled = YES;
    
    [self updateTextStoreWithText];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self updateTextStoreWithText];
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self updateTextStoreWithText];
}

- (void)setClickableRange:(NSRange)range hightlightedBackgroundColor:(UIColor *)hightlightedBackgroundColor{
    SLClickableRange *clickableRange = [[SLClickableRange alloc] initWithRange:range rangeColor:hightlightedBackgroundColor];
    [self.mutableClickableRanges addObject:clickableRange];
}

- (void)setClickableRange:(NSRange)range{
    [self setClickableRange:range hightlightedBackgroundColor:nil];
}

- (void)setClickRange:(NSRange)clickRange{
    if(self.clickRange.length && !NSEqualRanges(self.clickRange, clickRange)){
        [self.textStorage removeAttribute:NSBackgroundColorAttributeName range:self.clickRange];
    }

    SLClickableRange *clickableRange =  [self rangeValueAtRange:clickRange];
    if (clickRange.length > 0 && clickableRange != nil && clickableRange.rangeColor != nil){
        [self.textStorage addAttribute:NSBackgroundColorAttributeName value:clickableRange.rangeColor range:clickRange];
    }
    _clickRange = clickRange;
    
    [self setNeedsDisplay];
}

- (void)updateTextStoreWithText{
    if (self.attributedText != nil){
        [self updateTextStoreWithAttributedString:self.attributedText];
    }else if (self.text != nil){
        [self updateTextStoreWithAttributedString:[[NSAttributedString alloc] initWithString:self.text attributes:[self attributesFromProperties]]];
    }else{
        [self updateTextStoreWithAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:[self attributesFromProperties]]];
    }
    
    [self setNeedsDisplay];
}

- (void)updateTextStoreWithAttributedString:(NSAttributedString *)attributedString{
    if (attributedString.length > 0){
        attributedString = [self sanitizeAttributedString:attributedString];
    }
    
    if (self.textStorage){
        [self.textStorage setAttributedString:attributedString];
    }else{
        self.textStorage = [[NSTextStorage alloc] initWithAttributedString:attributedString];
        [self.textStorage addLayoutManager:self.layoutManager];
        [self.layoutManager setTextStorage:self.textStorage];
    }
}

- (SLClickableRange *)rangeValueAtRange:(NSRange)range{
    for (SLClickableRange *clickableRange in self.mutableClickableRanges) {
        if (NSEqualRanges(clickableRange.range, range)) {
            return clickableRange;
        }
    }
    
    for (SLClickableRange *clickableRange in self.detectedClickableRanges) {
        if (NSEqualRanges(clickableRange.range, range)) {
            return clickableRange;
        }
    }
    return nil;
}


- (SLClickableRange *)rangeValueAtLocation:(CGPoint)location{
    if (self.textStorage.string.length == 0){
        return nil;
    }
    
    CGPoint textOffset;
    NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:self.textContainer];
    textOffset = [self calcTextOffsetForGlyphRange:glyphRange];
    location.x -= textOffset.x;
    location.y -= textOffset.y;
    
    NSUInteger touchedChar = [self.layoutManager glyphIndexForPoint:location inTextContainer:self.textContainer];
    
    NSRange lineRange;
    CGRect lineRect = [self.layoutManager lineFragmentUsedRectForGlyphAtIndex:touchedChar effectiveRange:&lineRange];
    if (CGRectContainsPoint(lineRect, location)){
        for (SLClickableRange *rangeValue in self.mutableClickableRanges){
            NSRange range = rangeValue.range;
            if ((touchedChar >= range.location) && touchedChar < (range.location + range.length)){
                return rangeValue;
            }
        }
        
        for (SLClickableRange *rangeValue in self.detectedClickableRanges){
            NSRange range = rangeValue.range;
            if ((touchedChar >= range.location) && touchedChar < (range.location + range.length)){
                return rangeValue;
            }
        }

    }
    return nil;
}

- (CGPoint)calcTextOffsetForGlyphRange:(NSRange)glyphRange{
    CGPoint textOffset = CGPointZero;
    
    CGRect textBounds = [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:self.textContainer];
    CGFloat paddingHeight = (self.bounds.size.height - textBounds.size.height) / 2.0f;
    if (paddingHeight > 0){
        textOffset.y = paddingHeight;
    }
    
    return textOffset;
}

- (NSDictionary *)attributesFromProperties{
    NSShadow *shadow = shadow = [[NSShadow alloc] init];
    if (self.shadowColor != nil){
        shadow.shadowColor = self.shadowColor;
        shadow.shadowOffset = self.shadowOffset;
    }else{
        shadow.shadowOffset = CGSizeMake(0, -1);
        shadow.shadowColor = nil;
    }
    
    UIColor *colour = self.textColor;
    if (!self.isEnabled){
        colour = [UIColor lightGrayColor];
    }else if (self.isHighlighted){
        colour = self.highlightedTextColor;
    }
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = self.textAlignment;

    return @{NSFontAttributeName : self.font,
             NSForegroundColorAttributeName : colour,
             NSShadowAttributeName : shadow,
             NSParagraphStyleAttributeName : paragraph
            };
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines{
    CGSize savedTextContainerSize = self.textContainer.size;
    NSInteger savedTextContainerNumberOfLines = self.textContainer.maximumNumberOfLines;
    
    self.textContainer.size = bounds.size;
    self.textContainer.maximumNumberOfLines = numberOfLines;
    
    CGRect textBounds = CGRectZero;
    @try{
        NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:self.textContainer];
        textBounds = [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:self.textContainer];
        textBounds.origin = bounds.origin;
        textBounds.size.width = ceilf(textBounds.size.width);
        textBounds.size.height = ceilf(textBounds.size.height);
    }@finally{
        self.textContainer.size = savedTextContainerSize;
        self.textContainer.maximumNumberOfLines = savedTextContainerNumberOfLines;
    }
    
    return textBounds;
}

- (void)drawTextInRect:(CGRect)rect{
    CGPoint textOffset;
    NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:self.textContainer];
    textOffset = [self calcTextOffsetForGlyphRange:glyphRange];

    [self.layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:textOffset];
    [self.layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:textOffset];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.textContainer.size = self.bounds.size;
}

- (void)setBounds:(CGRect)bounds{
    [super setBounds:bounds];
    self.textContainer.size = self.bounds.size;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines{
    [super setNumberOfLines:numberOfLines];
    self.textContainer.maximumNumberOfLines = numberOfLines;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode{
    [super setLineBreakMode:lineBreakMode];
    self.textContainer.lineBreakMode = lineBreakMode;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textContainer.size = self.bounds.size;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.isTouchMoved = NO;
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    SLClickableRange *touchedRange = [self rangeValueAtLocation:touchLocation];
    
    if (touchedRange != nil){
        self.clickRange = touchedRange.range;
    }else{
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    self.isTouchMoved = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (self.isTouchMoved){
        self.clickRange = NSMakeRange(0, 0);
        return;
    }
    
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    SLClickableRange *touchedRange = [self rangeValueAtLocation:touchLocation];
    
    if (touchedRange != nil){
        if (self.tapHandler) {
            self.tapHandler(touchedRange.range, [[self.attributedText string] substringWithRange:touchedRange.range]);
        }
    }else{
        [super touchesBegan:touches withEvent:event];
    }
    
    self.clickRange = NSMakeRange(0, 0);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    self.clickRange = NSMakeRange(0, 0);
}

-(BOOL)layoutManager:(NSLayoutManager *)layoutManager shouldBreakLineByWordBeforeCharacterAtIndex:(NSUInteger)charIndex{
    NSRange range;
    NSURL *linkURL = [layoutManager.textStorage attribute:NSLinkAttributeName atIndex:charIndex effectiveRange:&range];
    
    return !(linkURL && (charIndex > range.location) && (charIndex <= NSMaxRange(range)));
}


- (NSAttributedString *)sanitizeAttributedString:(NSAttributedString *)attributedString{
    NSRange range;
    NSParagraphStyle *paragraphStyle = [attributedString attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:&range];
    
    if (paragraphStyle == nil){
        return attributedString;
    }
    
    NSMutableParagraphStyle *mutableParagraphStyle = [paragraphStyle mutableCopy];
    mutableParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSMutableAttributedString *restyled = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    [restyled addAttribute:NSParagraphStyleAttributeName value:mutableParagraphStyle range:NSMakeRange(0, restyled.length)];
    
    return restyled;
}

- (NSArray *)clickableRanges{
    return [self.mutableClickableRanges copy];
}

- (void)removeAllClickableRanges{
    self.tapHandler = nil;
    
    [self.mutableClickableRanges removeAllObjects];
    _detectedClickableRanges = nil;
    
    [self setNeedsDisplay];
}

@end


@implementation SLClickableRange

- (instancetype)initWithRange:(NSRange)range rangeColor:(UIColor *)rangeColor{
    if(self = [super init]){
        _range = range;
        _rangeColor = rangeColor;
    }
    return self;
}

@end