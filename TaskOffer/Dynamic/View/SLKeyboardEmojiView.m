//
//  SLKeyboardEmojiView.m
//  XMPPIM
//
//  Created by wshaolin on 15/1/3.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLKeyboardEmojiView.h"
#import "SLEmojiModel.h"
#import "SLFriendCircleFont.h"
#import "SLKeyboardEmojiPageView.h"
#import "SLConnectionButton.h"

@interface SLKeyboardEmojiView()<SLKeyboardEmojiPageViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) SLConnectionButton *sendButton;
@property (nonatomic, strong) NSArray *emojiArray;
@property (nonatomic, strong) NSArray *emojiPageViewArray;
@property (nonatomic, assign) NSInteger totalPage;

@end

@implementation SLKeyboardEmojiView

- (NSArray *)emojiArray{
    if(_emojiArray == nil){
        NSData *emojiData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"facemap.json" ofType:nil]];
        NSDictionary *emojiDictionary = [NSJSONSerialization JSONObjectWithData:emojiData options:(NSJSONReadingMutableLeaves) error:nil];
        NSMutableArray *tempArray = [NSMutableArray array];
        if(emojiDictionary != nil && emojiDictionary.count > 0){
            for(NSString *key in [emojiDictionary allKeys]){
                SLEmojiModel *emojiModel = [[SLEmojiModel alloc] initWithEmojiKey:key emojiImageName:emojiDictionary[key]];
                [tempArray addObject:emojiModel];
            }
        }
        // 排序
        [tempArray sortUsingComparator:^NSComparisonResult(SLEmojiModel *obj1, SLEmojiModel *obj2) {
            NSUInteger length = 3;
            NSInteger value1 = [[obj1.emojiImageName substringWithRange:NSMakeRange(obj1.emojiImageName.length - length, length)] integerValue];
            NSInteger value2 = [[obj2.emojiImageName substringWithRange:NSMakeRange(obj2.emojiImageName.length - length, length)] integerValue];
            
            return value1 > value2;
        }];
        _emojiArray = [tempArray copy];
    }
    return _emojiArray;
}

- (NSInteger)totalPage{
    if(_totalPage == 0){
        _totalPage = self.emojiArray.count / (SLKeyboardEmojiPageViewEmojiCount - 1);
        if(self.emojiArray.count % (SLKeyboardEmojiPageViewEmojiCount - 1) > 0){
            _totalPage ++;
        }
    }
    return _totalPage;
}

- (UIScrollView *)scrollView{
    if(_scrollView == nil){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        
        NSMutableArray *tempEmojiPageViewArray = [NSMutableArray array];
        for(NSInteger index = 0; index < self.totalPage; index ++){
            NSUInteger location = index * (SLKeyboardEmojiPageViewEmojiCount - 2);
            NSUInteger length = SLKeyboardEmojiPageViewEmojiCount - 1;
            if(location + length > self.emojiArray.count){
                length = self.emojiArray.count - location;
            }
            NSArray *subEmojiArray = [self.emojiArray subarrayWithRange:NSMakeRange(location, length)];
            SLKeyboardEmojiPageView *keyboardEmojiPageView = [[SLKeyboardEmojiPageView alloc] initWithFrame:CGRectZero emojiArray:subEmojiArray];
            keyboardEmojiPageView.delegate = self;
            
            [_scrollView addSubview:keyboardEmojiPageView];
            [tempEmojiPageViewArray addObject:keyboardEmojiPageView];
        }
        self.emojiPageViewArray = [tempEmojiPageViewArray copy];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if(_pageControl == nil){
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = self.totalPage;
        _pageControl.currentPage = 0;
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = SLBlackColor;
        _pageControl.enabled = NO;
    }
    return _pageControl;
}

- (SLConnectionButton *)sendButton{
    if(_sendButton == nil){
        _sendButton = [SLConnectionButton buttonWithType:UIButtonTypeCustom];
        _sendButton.title = @"发送";
        _sendButton.fontSize = 15.0;
        _sendButton.layer.masksToBounds = NO;
        _sendButton.layer.cornerRadius = 0;
        _sendButton.backgroundColor = [UIColor colorWithRed:36.0 / 255.0 green:91.0 / 255.0 blue:145.0 / 255.0 alpha:1.0];
        [_sendButton addTarget:self action:@selector(sendButtonClick:)];
    }
    return _sendButton;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:236.0/ 255.0 green:238.0/ 255.0 blue:241.0/ 255.0 alpha:1.0];
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        [self addSubview:self.sendButton];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)sendButtonClick:(UIButton *)button{
    if(self.delegate && [self.delegate respondsToSelector:@selector(keyboardEmojiViewDidClickSendButton:)]){
        [self.delegate keyboardEmojiViewDidClickSendButton:self];
    }
}

- (void)keyboardEmojiPageView:(SLKeyboardEmojiPageView *)keyboardEmojiPageView didSelectedEmoji:(NSString *)emojiKey{
    if(self.delegate && [self.delegate respondsToSelector:@selector(keyboardEmojiView:didSelectedEmoji:)]){
        [self.delegate keyboardEmojiView:self didSelectedEmoji:emojiKey];
    }
}

- (void)keyboardEmojiPageViewDidClickDeleteButton:(SLKeyboardEmojiPageView *)keyboardEmojiPageView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(keyboardEmojiViewDidClickDeleteButton:)]){
        [self.delegate keyboardEmojiViewDidClickDeleteButton:self];
    }
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x = 0;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.size.height = 190.0;
    [super setFrame:frame];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat magin = 10.0;
    
    CGFloat sendButton_W = 60.0;
    CGFloat sendButton_H = 30.0;
    CGFloat sendButton_X = self.bounds.size.width - sendButton_W - magin;
    CGFloat sendButton_Y = self.bounds.size.height - sendButton_H - magin;
    self.sendButton.frame = CGRectMake(sendButton_X, sendButton_Y, sendButton_W, sendButton_H);
    
    CGFloat pageControl_H = sendButton_H;
    CGFloat pageControl_Y = sendButton_Y;
    CGFloat pageControl_X = sendButton_W + magin * 2;
    CGFloat pageControl_W = self.bounds.size.width - pageControl_X * 2;
    self.pageControl.frame = CGRectMake(pageControl_X, pageControl_Y, pageControl_W, pageControl_H);
    
    CGFloat scrollView_W = self.bounds.size.width;
    CGFloat scrollView_H = self.bounds.size.height - sendButton_H - magin;
    CGFloat scrollView_X = 0;
    CGFloat scrollView_Y = 0;
    self.scrollView.frame = CGRectMake(scrollView_X, scrollView_Y, scrollView_W, scrollView_H);
    self.scrollView.contentSize = CGSizeMake(self.totalPage * scrollView_W, 0);
    
    CGFloat emojiPageView_W = scrollView_W;
    CGFloat emojiPageView_H = scrollView_H;
    CGFloat emojiPageView_Y = scrollView_Y;
    for(NSInteger index = 0; index < self.emojiPageViewArray.count; index ++){
        CGFloat emojiPageView_X = index * emojiPageView_W;
        SLKeyboardEmojiPageView *keyboardEmojiPageView = self.emojiPageViewArray[index];
        keyboardEmojiPageView.frame = CGRectMake(emojiPageView_X, emojiPageView_Y, emojiPageView_W, emojiPageView_H);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
}

@end
