//
//  SLTagView.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLTagView.h"
#import "HexColor.h"
#import "SLTagFrameModel.h"

@interface SLTagView()

@property (nonatomic, strong) NSArray *tagLabels;

@end

@implementation SLTagView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    NSMutableArray *temp = [NSMutableArray array];
    for(NSInteger index = 0; index < 5; index ++){
        UILabel *tagLabel = [[UILabel alloc] init];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.backgroundColor = [UIColor colorWithHexString:kDefaultTextColor];
        tagLabel.font = [UIFont systemFontOfSize:14.0];
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.adjustsFontSizeToFitWidth = YES;
        tagLabel.hidden = YES;
        tagLabel.layer.masksToBounds = YES;
        tagLabel.layer.cornerRadius = 3.0;
        [self addSubview:tagLabel];
        [temp addObject:tagLabel];
    }
    self.tagLabels = [temp copy];
}

- (void)setTagFrameModel:(SLTagFrameModel *)tagFrameModel{
    _tagFrameModel = tagFrameModel;
    for(NSInteger index = 0; index < tagFrameModel.tags.count; index ++){
        if(index < self.tagLabels.count){
            UILabel *label = self.tagLabels[index];
            label.text = tagFrameModel.tags[index];
            label.hidden = label.text.length == 0;
            label.frame = CGRectFromString(tagFrameModel.tagFrames[index]);
        }
    }
}

@end
