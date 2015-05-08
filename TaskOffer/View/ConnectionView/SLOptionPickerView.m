//
//  SLOptionPickerView.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/2.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLOptionPickerView.h"
#import "HexColor.h"
#import "SLOptionModel.h"

typedef enum{
    SLOptionPickerViewToolBarItemTypeCancel = 1,
    SLOptionPickerViewToolBarItemTypeDone = 5
}SLOptionPickerViewToolBarItemType;

@interface SLOptionPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) NSArray *toolBarItems;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *coverView;

@end

@implementation SLOptionPickerView

+ (instancetype)optionPickerWithOptionArray:(NSArray *)optionArray{
    return [[self alloc] initWithOptionArray:optionArray];
}

- (instancetype)initWithOptionArray:(NSArray *)optionArray{
    if(self = [super initWithFrame:CGRectZero]){
        _optionArray = optionArray;
        [self addSubview:self.toolBar];
        [self addSubview:self.pickerView];
        [self addSubview:self.coverView];
        [self setup];
        
        if(optionArray.count > 0){
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            _selectedOptionModel = optionArray[0];
        }
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UIPickerView *)pickerView{
    if(_pickerView == nil){
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

- (UIView *)toolBar{
    if(_toolBar == nil){
        _toolBar = [[UIView alloc] init];
        _toolBar.backgroundColor = [UIColor colorWithRed:36.0 / 255.0 green:91.0 / 255.0 blue:145.0 / 255.0 alpha:1.0];
        NSArray *itemTitles = @[@"取消", @"", @"", @"", @"确定"];
        NSMutableArray *toolBarItems = [NSMutableArray array];
        for(NSInteger index = 0; index < itemTitles.count; index ++){
            NSString *itemTitle = itemTitles[index];
            
            UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
            [item setTitle:itemTitle forState:UIControlStateNormal];
            [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [item setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [item addTarget:self action:@selector(toolBarItmeClick:) forControlEvents:UIControlEventTouchUpInside];
            item.hidden = itemTitle.length == 0;
            if(index == (SLOptionPickerViewToolBarItemTypeCancel - 1) || index == (SLOptionPickerViewToolBarItemTypeDone - 1)){
                item.tag = index + 1;
            }
            [_toolBar addSubview:item];
            [toolBarItems addObject:item];
        }
        self.toolBarItems = [toolBarItems copy];
    }
    return _toolBar;
}

- (void)setup{
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    self.coverView = [[UIView alloc] initWithFrame:window.bounds];
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0.0;
    [self.coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTap:)]];
    [window addSubview:self.coverView];
    [window addSubview:self];
}

- (void)setFrame:(CGRect)frame{
    frame = [UIScreen mainScreen].bounds;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    frame.size.height = 200.0;
    [super setFrame:frame];
}

- (void)setSelectedOptionModel:(SLOptionModel *)selectedOptionModel{
    NSInteger index = 0;
    for(SLOptionModel *optionModel in self.optionArray){
        if([optionModel.optionKey isEqualToString:selectedOptionModel.optionKey]){
            _selectedOptionModel = selectedOptionModel;
            break;
        }
        index ++;
    }
    
    if(index < self.optionArray.count){
        [self.pickerView selectRow:index inComponent:0 animated:YES];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat toolBar_X = 0;
    CGFloat toolBar_Y = 0;
    CGFloat toolBar_H = 38.0;
    CGFloat toolBar_W = self.bounds.size.width;
    self.toolBar.frame = CGRectMake(toolBar_X, toolBar_Y, toolBar_W, toolBar_H);
    
    CGFloat pickerView_X = toolBar_X;
    CGFloat pickerView_Y = CGRectGetMaxY(self.toolBar.frame);
    CGFloat pickerView_W = toolBar_W;
    CGFloat pickerView_H = self.bounds.size.height - pickerView_Y;
    self.pickerView.frame = CGRectMake(pickerView_X, pickerView_Y, pickerView_W, pickerView_H);
    
    for(NSInteger index = 0; index < self.toolBarItems.count; index ++){
        CGFloat item_W = self.toolBar.bounds.size.width / self.toolBarItems.count;
        CGFloat item_H = self.toolBar.bounds.size.height;
        CGFloat item_X = item_W * index;
        CGFloat item_Y = 0;
        UIButton *item = self.toolBarItems[index];
        item.frame = CGRectMake(item_X, item_Y, item_W, item_H);
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.optionArray.count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    SLOptionModel *optionModel = self.optionArray[row];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:optionModel.optionValue];
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:16.0],
                                 NSForegroundColorAttributeName : [UIColor colorWithHexString:kDefaultBarColor]};
    [mutableAttributedString addAttributes:attributes range:NSMakeRange(0, optionModel.optionValue.length)];
    return [mutableAttributedString copy];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 45.0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _selectedOptionModel = self.optionArray[row];
}

- (void)toolBarItmeClick:(UIButton *)item{
    switch (item.tag) {
        case SLOptionPickerViewToolBarItemTypeCancel:
            if([self.delegate respondsToSelector:@selector(optionPickerViewDidClickCancel:)]){
                [self.delegate optionPickerViewDidClickCancel:self];
            }
            [self hideOptionPicker];
            break;
        case SLOptionPickerViewToolBarItemTypeDone:
            if([self.delegate respondsToSelector:@selector(optionPickerView:didSelectOptionComplete:)]){
                [self.delegate optionPickerView:self didSelectOptionComplete:self.selectedOptionModel];
            }
            [self hideOptionPicker];
            break;
        default:
            break;
    }
}

- (void)showOptionPicker{
    __block typeof(self) bself = self;
    self.coverView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        bself.coverView.alpha = 0.4;
        bself.transform = CGAffineTransformMakeTranslation(0, - bself.frame.size.height);
    }];
}

- (void)hideOptionPicker{
    __block typeof(self) bself = self;
    [UIView animateWithDuration:0.25 animations:^{
        bself.transform = CGAffineTransformIdentity;
        bself.coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        bself.coverView.hidden = YES;
    }];
}

- (void)coverViewTap:(UITapGestureRecognizer *)tapGestureRecognizer{
    if(tapGestureRecognizer.view == self.coverView){
        if([self.delegate respondsToSelector:@selector(optionPickerViewDidClickCancel:)]){
            [self.delegate optionPickerViewDidClickCancel:self];
        }
        [self hideOptionPicker];
    }
}

- (void)dealloc{
    [self.coverView removeFromSuperview];
}

@end
