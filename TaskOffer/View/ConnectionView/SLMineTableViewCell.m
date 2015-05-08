//
//  SLMineTableViewCell.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/28.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLMineTableViewCell.h"
#import "SLSettingModel.h"

@interface SLMineTableViewCell()

@end

@implementation SLMineTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLMineTableViewCell";
    SLMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[SLMineTableViewCell alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.textLabel.font = [UIFont systemFontOfSize:16.0];
        
        self.hideTopLine = YES;
        self.hideBottomLine = YES;
    }
    return self;
}

- (void)setSettingModel:(SLSettingModel *)settingModel{
    _settingModel = settingModel;
    
    self.imageView.image = settingModel.icon;
    
    self.textLabel.text = settingModel.title;
}

@end
