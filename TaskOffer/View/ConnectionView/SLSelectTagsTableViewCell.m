//
//  SLSelectTagsTableViewCell.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/28.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLSelectTagsTableViewCell.h"
#import "SLSelectTagFrameModel.h"
#import "MBProgressHUD+Conveniently.h"
#import "HexColor.h"

@interface SLSelectTagsButton : UIButton

@property (nonatomic, copy) NSString *title;

- (void)addTarget:(id)target action:(SEL)action;

@end

@implementation SLSelectTagsButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3.0;
        
        self.layer.borderColor = [UIColor colorWithHexString:kDefaultTextColor].CGColor;
        self.layer.borderWidth = 1.0;
        
        [self setTitleColor:[UIColor colorWithHexString:kDefaultTextColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if(selected){
        self.backgroundColor = [UIColor colorWithHexString:kDefaultTextColor];
        self.layer.borderWidth = 0.0;
    }else{
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1.0;
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)addTarget:(id)target action:(SEL)action{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchDown];
}

@end

@interface SLSelectTagsTableViewCell()

@property (nonatomic, strong) NSMutableArray *selectedTags;

@end

@implementation SLSelectTagsTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLSelectTagsTableViewCell";
    SLSelectTagsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[self alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (NSMutableArray *)selectedTags{
    if(_selectedTags == nil){
        _selectedTags = [NSMutableArray array];
    }
    return _selectedTags;
}

- (void)setOldSelectedTags:(NSArray *)oldSelectedTags{
    _oldSelectedTags = oldSelectedTags;
    
    if(oldSelectedTags != nil && oldSelectedTags.count > 0){
        [self.selectedTags addObjectsFromArray:oldSelectedTags];
    }
}

- (void)setSelectTagFrameModel:(SLSelectTagFrameModel *)selectTagFrameModel{
    _selectTagFrameModel = selectTagFrameModel;
    
    for(NSInteger index = 0;  index < selectTagFrameModel.tagModels.count; index ++){
        SLTagModel *tagModel = selectTagFrameModel.tagModels[index];
        SLSelectTagsButton *selectTagsButton = [SLSelectTagsButton buttonWithType:UIButtonTypeCustom];
        selectTagsButton.selected = [self isSelectedWithTagModel:tagModel];
        selectTagsButton.title = tagModel.tagName;
        selectTagsButton.tag = index;
        selectTagsButton.frame = CGRectFromString(selectTagFrameModel.tagFrames[index]);
        [selectTagsButton addTarget:self action:@selector(didClickSelectTagsButton:)];
        [self addSubview:selectTagsButton];
    }
}

- (BOOL)isSelectedWithTagModel:(SLTagModel *)tagModel{
    BOOL isSelected = NO;
    for(SLTagModel *oldTagModel in self.oldSelectedTags){
        if([tagModel.tagCode isEqualToString:oldTagModel.tagCode]){
            isSelected = YES;
            break;
        }
    }
    return isSelected;
}

- (void)didClickSelectTagsButton:(SLSelectTagsButton *)selectTagsButton{
    if(self.selectedTags.count >= 5 && !selectTagsButton.selected){
        [MBProgressHUD showWithError:@"最多只能选择5个标签"];
    }else{
        selectTagsButton.selected = !selectTagsButton.selected;
        SLTagModel *tagModel = self.selectTagFrameModel.tagModels[selectTagsButton.tag];
        if(selectTagsButton.selected){
            [self.selectedTags addObject:tagModel];
        }else{
            for(SLTagModel *selectedTagModel in self.selectedTags){
                if([selectedTagModel.tagCode isEqualToString:tagModel.tagCode]){
                    [self.selectedTags removeObject:selectedTagModel];
                    break;
                }
            }
        }
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(selectTagsTableViewCell:didSelectedTags:)]){
            [self.delegate selectTagsTableViewCell:self didSelectedTags:[self.selectedTags copy]];
        }
    }
}

@end

