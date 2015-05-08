//
//  SLFriendCirclePersonStatusFrameModel.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/26.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCirclePersonStatusFrameModel.h"
#import "SLFriendCircleFont.h"
#import "NSString+Conveniently.h"
#import "NSDate+Conveniently.h"

@implementation SLFriendCirclePersonStatusFrameModel

+ (instancetype)modelWithFriendCircleStatusModel:(SLFriendCircleStatusModel *)friendCircleStatusModel{
    return [[self alloc] initWithFriendCircleStatusModel:friendCircleStatusModel];
}

- (instancetype)initWithFriendCircleStatusModel:(SLFriendCircleStatusModel *)friendCircleStatusModel{
    if(self = [super init]){
        _friendCircleStatusModel = friendCircleStatusModel;
        
        [self calculateFrame];
    }
    return self;
}

- (void)calculateFrame{
    CGFloat margin = 10.0;
    CGFloat leftView_W = 70.0;
    CGFloat leftView_Y = margin;
    CGFloat leftView_X = margin;
    
    CGFloat date_W = leftView_W;
    CGFloat date_H = 40.0;
    CGFloat date_X = 0;
    CGFloat date_Y = 0;
    _dateLabelFrame = CGRectMake(date_X, date_Y, date_W, date_H);
    
    CGFloat position_W = leftView_W;
    CGFloat position_H = 0;
    if(_friendCircleStatusModel.position != nil && _friendCircleStatusModel.position.length > 0){
        position_H = [_friendCircleStatusModel.position sizeWithFont:SLFriendCirclePersonStatusPositionFont limitSize:CGSizeMake(position_W, MAXFLOAT)].height;
    }
    CGFloat position_X = date_X;
    CGFloat position_Y = CGRectGetMaxY(_dateLabelFrame);
    _positionLabelFrame = CGRectMake(position_X, position_Y, position_W, position_H);
    
    CGFloat rightView_W = [UIScreen mainScreen].bounds.size.width - leftView_W - margin * 2.5;
    CGFloat rightView_Y = leftView_Y;
    CGFloat rightView_X = leftView_W + margin * 1.5;
    
    CGFloat imageView_W = 0;
    CGFloat imageView_H = 0;
    CGFloat imageView_X = 0;
    CGFloat imageView_Y = 0;
    if(_friendCircleStatusModel.imageUrls.count > 0){
        imageView_W = 82.0;
        imageView_H = imageView_W;
    }
    _imageViewFrame = CGRectMake(imageView_X, imageView_Y, imageView_W, imageView_H);
    
    CGFloat imageCount_W = rightView_W - imageView_W;
    if(_friendCircleStatusModel.imageUrls.count > 0){
        imageCount_W -= margin * 0.5;
    }
    CGFloat imageCount_H = 0;
    CGFloat imageCount_X = 0;
    if(_friendCircleStatusModel.imageUrls.count > 0){
        imageCount_X = CGRectGetMaxX(_imageViewFrame) + margin * 0.5;
    }
    
    if(_friendCircleStatusModel.imageUrls.count >= 4){
        imageCount_H = [[NSString stringWithFormat:@"共%ld张", (long)_friendCircleStatusModel.imageUrls.count] sizeWithFont:SLFriendCirclePersonStatusImageCountFont limitSize:CGSizeZero].height;
    }
    CGFloat imageCount_Y = imageView_H - imageCount_H;
    _imageCountLabelFrame = CGRectMake(imageCount_X, imageCount_Y, imageCount_W, imageCount_H);
    
    CGFloat content_W = imageCount_W;
    CGFloat content_Y = imageView_Y;
    CGFloat content_X = imageCount_X;
    CGFloat content_H = [_friendCircleStatusModel.content sizeWithFont:SLFriendCirclePersonStatusContentFont limitSize:CGSizeMake(content_W, date_H + position_H)].height;
    if(_friendCircleStatusModel.imageUrls.count > 0){
        content_H = [_friendCircleStatusModel.content sizeWithFont:SLFriendCirclePersonStatusContentFont limitSize:CGSizeMake(content_W, imageView_H - imageCount_H)].height;
    }
    
    CGFloat leftView_H = CGRectGetMaxY(_positionLabelFrame);
    if(_friendCircleStatusModel.position != nil && _friendCircleStatusModel.position.length > 0){
        leftView_H += margin;
    }
    CGFloat rightView_H = content_H + margin;
    if(_friendCircleStatusModel.imageUrls.count > 0){
        rightView_H = imageView_H;
    }
    
    if(leftView_H > rightView_H){
        rightView_H = leftView_H;
    }else{
        leftView_H = rightView_H;
    }
    
    _leftViewFrame = CGRectMake(leftView_X, leftView_Y, leftView_W, leftView_H);
    _rightViewFrame = CGRectMake(rightView_X, rightView_Y, rightView_W, rightView_H);
    
    CGFloat contentLabel_X = 0;
    CGFloat contentLabel_Y = 0;
    if(_friendCircleStatusModel.imageUrls.count == 0){
        content_H = rightView_H;
        contentLabel_X = margin * 0.5;
        contentLabel_Y = margin * 0.5;
    }
    _contentViewFrame = CGRectMake(content_X, content_Y, content_W, content_H);
    
    CGFloat contentLabel_W = content_W - contentLabel_X * 2;
    CGFloat contentLabel_H = content_H - contentLabel_Y * 2;
    _contentLabelFrame = CGRectMake(contentLabel_X, contentLabel_Y, contentLabel_W, contentLabel_H);
    
    _rowHeight = MAX(leftView_H, rightView_H) + margin;
    
    if(_friendCircleStatusModel.dayLinkMonth != nil && _friendCircleStatusModel.dayLinkMonth.length > 0){
        _dateAttributedString = [[NSMutableAttributedString alloc] initWithString:_friendCircleStatusModel.dayLinkMonth];
        
        [_dateAttributedString addAttribute:NSFontAttributeName value:SLFriendCirclePersonStatusDateDayFont range:NSMakeRange(0, 2)];
        [_dateAttributedString addAttribute:NSForegroundColorAttributeName value:SLFriendCirclePersonStatusDateDayColor range:NSMakeRange(0, 2)];
        if(_friendCircleStatusModel.dayLinkMonth.length > 2){
            [_dateAttributedString addAttribute:NSFontAttributeName value:SLFriendCirclePersonStatusDateMonthFont range:NSMakeRange(2, _friendCircleStatusModel.dayLinkMonth.length - 2)];
            [_dateAttributedString addAttribute:NSForegroundColorAttributeName value:SLFriendCirclePersonStatusDateMonthColor range:NSMakeRange(0, _friendCircleStatusModel.dayLinkMonth.length - 2)];
        }
    }
}

@end
