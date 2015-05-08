//
//  SLFriendCircleStatusDetailSectionView.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/28.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleStatusDetailSectionView.h"
#import "HexColor.h"
#import "IMAttributedLabel.h"

@interface SLFriendCircleStatusDetailSectionView()

@property (nonatomic, strong) IMAttributedLabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation SLFriendCircleStatusDetailSectionView

+ (instancetype)statusDetailSectionViewWithTableView:(UITableView *)tableView{
    static NSString *reusableIdentifier = @"SLFriendCircleStatusDetailSectionView";
    SLFriendCircleStatusDetailSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusableIdentifier];
    if(view == nil){
        view = [[self alloc] initWithReuseIdentifier:reusableIdentifier];
    }
    return view;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.lineView];
        
        self.backgroundView = nil;
        self.contentView.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
    }
    return self;
}

- (IMAttributedLabel *)contentLabel{
    if(_contentLabel == nil){
        _contentLabel = [[IMAttributedLabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = [UIColor colorWithHexString:kDefaultBarColor];
        _contentLabel.font = [UIFont systemFontOfSize:15.0];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIView *)lineView{
    if(_lineView == nil){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _lineView;
}

- (void)setApplaudNicknameString:(NSString *)applaudNicknameString{
    _applaudNicknameString = applaudNicknameString;
    self.contentLabel.emojiText = applaudNicknameString;
}

-(void)setHideLine:(BOOL)hideLine{
    _hideLine = hideLine;
    self.lineView.hidden = hideLine;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat contentLabel_X = 10.0;
    CGFloat contentLabel_Y = 0;
    CGFloat contentLabel_W = self.bounds.size.width - contentLabel_X * 2;
    CGFloat contentLabel_H = self.bounds.size.height - 0.5;
    self.contentLabel.frame = CGRectMake(contentLabel_X, contentLabel_Y, contentLabel_W, contentLabel_H);
    
    CGFloat lineView_X = 10.0;
    CGFloat lineView_H = 0.5;
    CGFloat lineView_Y = self.bounds.size.height - lineView_H;
    CGFloat lineView_W = self.bounds.size.width - lineView_X;
    self.lineView.frame = CGRectMake(lineView_X, lineView_Y, lineView_W, lineView_H);
}

@end
