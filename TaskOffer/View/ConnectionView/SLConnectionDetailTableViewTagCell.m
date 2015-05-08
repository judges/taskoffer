//
//  SLConnectionDetailTableViewTagCell.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionDetailTableViewTagCell.h"
#import "SLTagView.h"
#import "HexColor.h"
@interface SLConnectionDetailTableViewTagCell()

@property (nonatomic, strong) SLTagView *tagsView;

@end

@implementation SLConnectionDetailTableViewTagCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLConnectionDetailTableViewTagCell";
    SLConnectionDetailTableViewTagCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[self alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.tagsView];
        self.hideTopLine = YES;
        self.hideBottomLine = NO;
    }
    return self;
}

- (void)setTagFrameModel:(SLTagFrameModel *)tagFrameModel{
    _tagFrameModel = tagFrameModel;
    self.tagsView.tagFrameModel = tagFrameModel;
}

- (SLTagView *)tagsView{
    if(_tagsView == nil){
        _tagsView = [[SLTagView alloc] init];
    }
    return _tagsView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.tagsView.frame = self.bounds;
}

@end
