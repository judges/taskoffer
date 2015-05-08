//
//  SLConnectionMoreView.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionMoreView.h"
#import "NSString+Conveniently.h"

@interface SLConnectionMoreView()

@property (nonatomic, strong) NSMutableArray *mutableButtonItemTitles;
@property (nonatomic, strong) NSMutableArray *mutableButtonItems;
@property (nonatomic, strong) NSMutableArray *mutableButtonItemLines;
@property (nonatomic, assign) CGRect showFrame;

@end

@implementation SLConnectionMoreView

- (instancetype)initWithButtonItemTitles:(NSArray *)buttonItemTitles{
    if([self initWithFrame:CGRectZero]){
        [self.mutableButtonItemTitles addObjectsFromArray:buttonItemTitles];
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame buttonItemTitles:(NSArray *)buttonItemTitles{
    if([self initWithFrame:frame]){
        [self.mutableButtonItemTitles addObjectsFromArray:buttonItemTitles];
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.horizontalPosition = SLConnectionMoreViewHorizontalPositionRight;
        self.backgroundColor = [UIColor colorWithRed:36.0 / 255.0 green:91.0 / 255.0 blue:145.0 / 255.0 alpha:1.0];
    }
    return self;
}

- (NSMutableArray *)mutableButtonItemTitles{
    if(_mutableButtonItemTitles == nil){
        _mutableButtonItemTitles = [NSMutableArray array];
    }
    return _mutableButtonItemTitles;
}

- (NSMutableArray *)mutableButtonItems{
    if(_mutableButtonItems == nil){
        _mutableButtonItems = [NSMutableArray array];
    }
    return _mutableButtonItems;
}

- (NSMutableArray *)mutableButtonItemLines{
    if(_mutableButtonItemLines == nil){
        _mutableButtonItemLines = [NSMutableArray array];
    }
    return _mutableButtonItemLines;
}

- (void)addButtonItemWithTitle:(NSString *)title{
    if(![self.mutableButtonItemTitles containsObject:title]){
        [self.mutableButtonItemTitles addObject:title];
        [self setupSubViews];
    }
}

- (void)removeButtonItemWithTitle:(NSString *)title{
    if([self.mutableButtonItemTitles containsObject:title]){
        [self.mutableButtonItemTitles removeObject:title];
        [self setupSubViews];
    }
}

- (void)removeButtonItemWithIndex:(NSInteger)index{
    if(index >= 0 && index < self.mutableButtonItemTitles.count){
        [self.mutableButtonItemTitles removeObjectAtIndex:index];
        [self setupSubViews];
    }
}

- (void)replaceButtonItemTitle:(NSString *)title withIndex:(NSInteger)index{
    if(index >= 0 && index < self.mutableButtonItemTitles.count){
        UIButton *buttonItem = self.mutableButtonItems[index];
        [buttonItem setTitle:title forState:UIControlStateNormal];
        
        [self.mutableButtonItemTitles replaceObjectAtIndex:index withObject:title];
    }
}

- (NSString *)buttonItemTitleWithIndex:(NSInteger)index{
    if(index >= 0 && index < self.mutableButtonItemTitles.count){
        return self.mutableButtonItemTitles[index];
    }
    return nil;
}

- (NSInteger)buttonItemIndexWithTitle:(NSString *)title{
    if([self.mutableButtonItemTitles containsObject:title]){
        return [self.mutableButtonItemTitles indexOfObject:title];
    }
    return NSNotFound;
}

- (void)showInView:(UIView *)view{
    if(self.isDisplaying){
        [self hide];
    }else{
        [view addSubview:self];
    
        if(self.delegate && [self.delegate respondsToSelector:@selector(connectionMoreView:willShowWithAnimated:)]){
            [self.delegate connectionMoreView:self willShowWithAnimated:YES];
        }
        
        for(UIView *lineView in self.mutableButtonItemLines){
            lineView.hidden = NO;
        }
        
        for(UIButton *button in self.mutableButtonItems){
            button.hidden = NO;
        }
        
        __block typeof(self) bself = self;
        CGRect frame = self.showFrame;
        frame.size.height = 0;
        self.frame = frame;
        
        [UIView animateWithDuration:0.25 animations:^{
            bself.frame = bself.showFrame;
        } completion:^(BOOL finished) {
            _isDisplaying = YES;
            if(bself.delegate && [bself.delegate respondsToSelector:@selector(connectionMoreView:didShowWithAnimated:)]){
                [bself.delegate connectionMoreView:self didShowWithAnimated:YES];
            }
        }];
    }
}

- (void)hide{
    if(self.isDisplaying){
        if(self.delegate && [self.delegate respondsToSelector:@selector(connectionMoreView:willHideWithAnimated:)]){
            [self.delegate connectionMoreView:self willHideWithAnimated:YES];
        }
        
        for(UIView *lineView in self.mutableButtonItemLines){
            lineView.hidden = YES;
        }
        
        for(UIButton *button in self.mutableButtonItems){
            button.hidden = YES;
        }
        
        __block typeof(self) bself = self;
        CGRect frame = self.showFrame;
        frame.size.height = 0;
        
        [UIView animateWithDuration:0.25 animations:^{
            bself.frame = frame;
        } completion:^(BOOL finished) {
            _isDisplaying = NO;
            if(bself.delegate && [bself.delegate respondsToSelector:@selector(connectionMoreView:didHideWithAnimated:)]){
                [bself.delegate connectionMoreView:self didHideWithAnimated:YES];
            }
            [bself removeFromSuperview];
        }];
    }
}

- (void)setupSubViews{
    for(UIButton *button in self.mutableButtonItems){
        [button removeFromSuperview];
    }
    [self.mutableButtonItems removeAllObjects];
    
    for(UIView *view in self.mutableButtonItemLines){
        [view removeFromSuperview];
    }
    [self.mutableButtonItemLines removeAllObjects];
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    NSInteger buttonItemCount = self.mutableButtonItemTitles.count;
    NSString *maxLengthTitle = [self titleWithMaxLength];
    if(maxLengthTitle != nil){
        CGFloat buttonItem_H = 40.0;
        UIFont *buttonItemFont = [UIFont systemFontOfSize:16.0];
        CGFloat buttonItem_W = [maxLengthTitle sizeWithFont:buttonItemFont limitSize:CGSizeMake(150.0, buttonItem_H)].width;
        if(buttonItem_W < 100.0){
            buttonItem_W = 100.0;
        }
        for(NSInteger index = 0; index < buttonItemCount; index ++){
            NSString *title = self.mutableButtonItemTitles[index];
            UIButton *buttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonItem.titleLabel.font = buttonItemFont;
            [buttonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [buttonItem setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.75] forState:UIControlStateHighlighted];
            [buttonItem setTitle:title forState:UIControlStateNormal];
            buttonItem.tag = index;
            [buttonItem addTarget:self action:@selector(didClickButtonItem:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:buttonItem];
            CGFloat buttonItem_X = 10.0;
            CGFloat lineView_H = 0.5;
            
            CGFloat buttonItem_Y = (buttonItem_H + lineView_H) * index;
            buttonItem.frame = CGRectMake(buttonItem_X, buttonItem_Y, buttonItem_W, buttonItem_H);
            
            if(index > 0){
                UIView *lineView = [[UIView alloc] init];
                lineView.backgroundColor = [UIColor whiteColor];
                [self addSubview:lineView];
                CGFloat lineView_X = buttonItem_X;
                CGFloat lineView_W = buttonItem_W;
                CGFloat lineView_Y = buttonItem_Y - lineView_H;
                lineView.frame = CGRectMake(lineView_X, lineView_Y, lineView_W, lineView_H);
                [self.mutableButtonItemLines addObject:lineView];
            }
            
            [self.mutableButtonItems addObject:buttonItem];
        }
        
        width = buttonItem_W + 20.0;
        height = buttonItem_H * buttonItemCount;
    }
    
    CGRect frame = self.frame;
    frame.size = CGSizeMake(width, height);
    switch (self.horizontalPosition) {
        case SLConnectionMoreViewHorizontalPositionLeft:
            frame.origin.x = 0;
            break;
        case SLConnectionMoreViewHorizontalPositionCenter:
            frame.origin.x = ([UIScreen mainScreen].bounds.size.width - width) * 0.5;
            break;
        case SLConnectionMoreViewHorizontalPositionRight:
            frame.origin.x = [UIScreen mainScreen].bounds.size.width - width;
            break;
        default:
            break;
    }
    
    self.showFrame = frame;
}

- (NSString *)titleWithMaxLength{
    NSString *maxLengthTitle = nil;
    for(NSString *title in self.mutableButtonItemTitles){
        if(title.length > maxLengthTitle.length){
            maxLengthTitle = title;
        }
    }
    return maxLengthTitle;
}

- (void)didClickButtonItem:(UIButton *)buttonItem{
    if(self.delegate && [self.delegate respondsToSelector:@selector(connectionMoreView:didClickButtonItemAtIndex:)]){
        [self.delegate connectionMoreView:self didClickButtonItemAtIndex:buttonItem.tag];
    }
    [self hide];
}

@end
