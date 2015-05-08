//
//  SLTagFrameModel.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/25.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLTagFrameModel.h"
#import "NSString+Conveniently.h"

@implementation SLTagFrameModel

+ (instancetype)modelWithTags:(NSArray *)tags{
    return [[self alloc] initWithTags:tags];
}

- (instancetype)initWithTags:(NSArray *)tags{
    if(self = [super init]){
        _tags = tags;
        
        [self calculateFrame];
    }
    return self;
}

- (void)calculateFrame{
    if(_tags != nil && _tags.count > 0){
        CGFloat margin = 10.0;
        CGFloat tag_H = 20.0;
        CGFloat tag_Max_W = [UIScreen mainScreen].bounds.size.width - margin * 2;
        CGFloat tag_X = 0;
        CGFloat tag_Y = 0;
        CGFloat tag_W = 0;
        
        NSMutableArray *tagFrames = [NSMutableArray array];
        UIFont *tagFont = [UIFont systemFontOfSize:14.0];
        
        CGSize limitSize = CGSizeMake(tag_Max_W, tag_H);
        
        for(NSInteger index = 0; index < _tags.count; index ++){
            NSString *tag = _tags[index];
            tag_W = [tag sizeWithFont:tagFont limitSize:limitSize].width + margin;
            if(index == 0){
                tag_X = margin;
                tag_Y = margin;
            }else{
                CGRect prevTagFrame = CGRectFromString([tagFrames lastObject]);
                if(CGRectGetMaxX(prevTagFrame) + margin + tag_W > tag_Max_W - margin){ // 需要换行
                    tag_X = margin;
                    tag_Y = CGRectGetMaxY(prevTagFrame) + margin;
                }else{ // 无需换行
                    tag_Y = prevTagFrame.origin.y;
                    tag_X = CGRectGetMaxX(prevTagFrame) + margin;
                }
            }
            CGRect tagFrame = CGRectMake(tag_X, tag_Y, tag_W, tag_H);
            [tagFrames addObject:NSStringFromCGRect(tagFrame)];
        }
        
        _tagFrames = [tagFrames copy];
        
        CGRect lastTagFrame = CGRectFromString([_tagFrames lastObject]);
        _tagViewHeight = CGRectGetMaxY(lastTagFrame) + margin;
    }
}

@end
