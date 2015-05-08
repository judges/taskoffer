//
//  SLFriendCircleStatusFrameModel.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/18.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleStatusFrameModel.h"
#import "NSString+Conveniently.h"
#import "SLFriendCircleFont.h"

#define SLFriendCircleStatusFrameModelMargin 10.0
#define SLFriendCircleStatusFrameModelImageMargin 5.0

@interface SLFriendCircleStatusFrameModel()

@end

@implementation SLFriendCircleStatusFrameModel

+ (instancetype)modelWithFriendCircleStatusModel:(SLFriendCircleStatusModel *)friendCircleStatusModel{
    return [[self alloc] initWithFriendCircleStatusModel:friendCircleStatusModel];
}

-  (instancetype)initWithFriendCircleStatusModel:(SLFriendCircleStatusModel *)friendCircleStatusModel{
    if(self = [super init]){
        _friendCircleStatusModel = friendCircleStatusModel;
        
        [self recalculateFrame];
    }
    return self;
}

- (void)recalculateFrame{
    CGFloat icon_W = 40.0;
    CGFloat icon_H = icon_W;
    CGFloat icon_X = SLFriendCircleStatusFrameModelMargin;
    CGFloat icon_Y = SLFriendCircleStatusFrameModelMargin;
    _iconFrame = CGRectMake(icon_X, icon_Y, icon_W, icon_H);
    
    CGFloat dataTime_H = 25.0;
    CGFloat dataTime_W = [_friendCircleStatusModel.formatDateTime sizeWithFont:SLFriendCircleDateTimeFont limitSize:CGSizeMake(80.0, dataTime_H)].width;
    CGFloat dataTime_X = [UIScreen mainScreen].bounds.size.width - dataTime_W -  SLFriendCircleStatusFrameModelMargin;
    CGFloat dataTime_Y = icon_Y - 5.0;
    _dataTimeFrame = CGRectMake(dataTime_X, dataTime_Y, dataTime_W, dataTime_H);
    
    CGFloat nickName_W_MAX = [UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(_iconFrame) - dataTime_W - SLFriendCircleStatusFrameModelMargin * 3;
    CGFloat nickName_W = [_friendCircleStatusModel.userModel.displayName sizeWithFont:SLFriendCircleNickNameFont limitSize:CGSizeMake(nickName_W_MAX, MAXFLOAT)].width;
    CGFloat nickName_H = dataTime_H;
    CGFloat nickName_X = CGRectGetMaxX(_iconFrame) + SLFriendCircleStatusFrameModelMargin;
    CGFloat nickName_Y = dataTime_Y;
    _nickNameFrame = CGRectMake(nickName_X, nickName_Y, nickName_W, nickName_H);
    
    CGFloat companyAndJob_X = nickName_X;
    CGFloat companyAndJob_Y = CGRectGetMaxY(_nickNameFrame);
    CGFloat companyAndJob_H = 0;
    CGFloat companyAndJob_W = 0;
    CGFloat companyAndJob_Max_W = [UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(_iconFrame) - SLFriendCircleStatusFrameModelMargin * 2;
    if(_friendCircleStatusModel.companyAndJob.length > 0){
        companyAndJob_H = nickName_H;
        companyAndJob_W = [_friendCircleStatusModel.companyAndJob sizeWithFont:SLFriendCircleCompanyAndJobFont limitSize:CGSizeMake(companyAndJob_Max_W, companyAndJob_H)].width;
    }
    _companyAndJobFrame = CGRectMake(companyAndJob_X, companyAndJob_Y, companyAndJob_W, companyAndJob_H);
    
    CGFloat content_W = companyAndJob_Max_W;
    CGFloat content_H = 0;
    if(_friendCircleStatusModel.content.length > 0){
        content_H = [_friendCircleStatusModel.content sizeWithFont:SLFriendCircleContentFont limitSize:CGSizeMake(content_W, MAXFLOAT)].height + SLFriendCircleStatusFrameModelMargin * 0.5;
    }
    
    CGFloat content_X = nickName_X;
    CGFloat content_Y = CGRectGetMaxY(_companyAndJobFrame);
    _contentFrame = CGRectMake(content_X, content_Y, content_W, content_H);
    
    CGFloat imageCollection_W = content_W;
    CGFloat imageCollection_H = 0;
    CGFloat imageCollectionImageView_H = ([UIScreen mainScreen].bounds.size.width - 80.0) / 3;
    NSInteger imageCount = _friendCircleStatusModel.imageUrls.count;
    if(imageCount > 9){ // 最多只有9张图片
        imageCount = 9;
    }
    if(imageCount == 1 || imageCount == 4){
        imageCollection_H = imageCollectionImageView_H * 2 + SLFriendCircleStatusFrameModelImageMargin;
    }else if(imageCount > 0){
        NSInteger imageCollectionRow = (imageCount - 1) / 3 + 1;
        imageCollection_H = imageCollectionRow * imageCollectionImageView_H;
        if(imageCollectionRow - 1 > 0){
            imageCollection_H += SLFriendCircleStatusFrameModelImageMargin * (imageCollectionRow - 1);
        }
    }
    
    CGFloat imageCollection_X = content_X;
    CGFloat imageCollection_Y = content_Y;
    if(content_H == 0){
        imageCollection_Y += SLFriendCircleStatusFrameModelMargin * 0.5;
    }
    if(_friendCircleStatusModel.content.length > 0){
        imageCollection_Y = CGRectGetMaxY(_contentFrame) + SLFriendCircleStatusFrameModelMargin * 0.5;
    }
    _imageCollectionFrame = CGRectMake(imageCollection_X, imageCollection_Y, imageCollection_W, imageCollection_H);
    
    CGFloat commentButton_H = 27.0;
    CGFloat commentButton_W = 60.0;
    CGFloat commentButton_X = [UIScreen mainScreen].bounds.size.width - commentButton_W -SLFriendCircleStatusFrameModelMargin;
    CGFloat commentButton_Y = imageCollection_Y;
    if(_friendCircleStatusModel.imageUrls.count > 0){
        commentButton_Y = CGRectGetMaxY(_imageCollectionFrame) + SLFriendCircleStatusFrameModelMargin;
    }
    _commentButtonFrame = CGRectMake(commentButton_X, commentButton_Y, commentButton_W, commentButton_H);
    
    CGFloat applaudButton_H = commentButton_H;
    CGFloat applaudButton_W = commentButton_W;
    CGFloat applaudButton_X = commentButton_X - applaudButton_W - SLFriendCircleStatusFrameModelMargin;
    CGFloat applaudButton_Y = commentButton_Y;
    _applaudButtonFrame = CGRectMake(applaudButton_X, applaudButton_Y, applaudButton_W, applaudButton_H);
    
    CGFloat deleteButton_H = applaudButton_H;
    CGFloat deleteButton_W = commentButton_W;
    CGFloat deleteButton_Y = applaudButton_Y;
    CGFloat deleteButton_X = imageCollection_X;
    _deleteButtonFrame = CGRectMake(deleteButton_X, deleteButton_Y, deleteButton_W, deleteButton_H);
    
    _statusSectionHeight = CGRectGetMaxY(_deleteButtonFrame) + SLFriendCircleStatusFrameModelMargin;
}

@end
