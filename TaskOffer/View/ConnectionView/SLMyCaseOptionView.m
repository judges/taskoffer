//
//  SLMyCaseOptionView.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/1.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLMyCaseOptionView.h"
#import "HexColor.h"

@interface SLMyCaseOptionView()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation SLMyCaseOptionView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.segmentedControl];
        
        self.backgroundColor = [UIColor colorWithHexString:kDefaultBarColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    frame = [UIScreen mainScreen].bounds;
    frame.origin.y = 64.0;
    frame.size.height = 40.0;
    [super setFrame:frame];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if(selectedIndex >= 0 && selectedIndex < self.segmentedControl.numberOfSegments){
        self.segmentedControl.selectedSegmentIndex = selectedIndex;
        [self didChangeSelectedIndexWithSegmentedControl:self.segmentedControl];
    }
}

- (UISegmentedControl *)segmentedControl{
    if(_segmentedControl == nil){
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"我的案例", @"收藏的案例"]];
        _segmentedControl.tintColor = [UIColor whiteColor];
        [_segmentedControl addTarget:self action:@selector(didChangeSelectedIndexWithSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (void)didChangeSelectedIndexWithSegmentedControl:(UISegmentedControl *)segmentedControl{
    if(self.delegate && [self.delegate respondsToSelector:@selector(myCaseOptionView:didChangeSelectedIndex:)]){
        [self.delegate myCaseOptionView:self didChangeSelectedIndex:segmentedControl.selectedSegmentIndex];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat segmentedControl_W = self.segmentedControl.bounds.size.width;
    CGFloat segmentedControl_H = self.segmentedControl.bounds.size.height;
    CGFloat segmentedControl_X = (self.bounds.size.width - segmentedControl_W) * 0.5;
    CGFloat segmentedControl_Y = (self.bounds.size.height - segmentedControl_H) * 0.5;
    self.segmentedControl.frame = CGRectMake(segmentedControl_X, segmentedControl_Y, segmentedControl_W, segmentedControl_H);
}

@end
