//
//  SLFriendCircleSendStatusViewCell.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/25.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleSendStatusViewCell.h"
#import "SLFriendCircleFont.h"
#import "SLFriendCircleSendStatusTableViewModel.h"

@interface SLFriendCircleSendStatusViewCell()

@property (nonatomic, strong) UIView *topLineView;

@end

@implementation SLFriendCircleSendStatusViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLFriendCircleSendStatusViewCell";
    SLFriendCircleSendStatusViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[self alloc]  initWithReuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (UIView *)topLineView{
    if(_topLineView == nil){
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = SLGrayColor;
    }
    return _topLineView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.topLineView];
        self.textLabel.font = [UIFont systemFontOfSize:18.0];
        self.backgroundView = nil;
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.hideTopLine = YES;
    }
    return self;
}

- (void)setTableViewModel:(SLFriendCircleSendStatusTableViewModel *)tableViewModel{
    _tableViewModel = tableViewModel;
    if(tableViewModel.iconName != nil && tableViewModel.iconName.length > 0){
        self.imageView.image = [UIImage imageNamed:tableViewModel.iconName];
    }else{
        self.imageView.image = nil;
    }
    self.textLabel.text = tableViewModel.title;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect topLineViewFrame = self.bounds;
    topLineViewFrame.size.height = 0.6;
    self.topLineView.frame = topLineViewFrame;
}

@end
