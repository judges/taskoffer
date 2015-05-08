//
//  SLAddCaseFormView.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLAddCaseFormView.h"

@class SLAddCaseFormItemView;

@protocol SLAddCaseFormItemViewDelegate <NSObject>

@optional
- (void)addCaseFormItemViewDidTapTextField:(SLAddCaseFormItemView *)addCaseFormItemView;

@end

@interface SLAddCaseFormItemView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign, getter = isHideBottomLine) BOOL hideBottomLine;
@property (nonatomic, assign, getter = isEnableInput) BOOL enableInput;
@property (nonatomic, weak) id<SLAddCaseFormItemViewDelegate> deledate;
@property (nonatomic, assign) UIKeyboardType keyboardType;

@end

@interface SLAddCaseFormItemView()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UITapGestureRecognizer *textFieldTapGestureRecognizer;

@end

@implementation SLAddCaseFormItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.titleLabel];
        [self addSubview:self.textField];
        [self addSubview:self.bottomLineView];
        self.enableInput = YES;
        self.keyboardType = UIKeyboardTypeDefault;
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
    if(title != nil){
        self.textField.placeholder = [NSString stringWithFormat:@"请输入%@", title];
    }
}

- (void)setText:(NSString *)text{
    self.textField.text = text;
}

- (void)setHideBottomLine:(BOOL)hideBottomLine{
    _hideBottomLine = hideBottomLine;
    self.bottomLineView.hidden = hideBottomLine;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType{
    _keyboardType = keyboardType;
    self.textField.keyboardType = keyboardType;
}

- (NSString *)text{
    return self.textField.text;
}

- (UILabel *)titleLabel{
    if(_titleLabel == nil){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _titleLabel;
}

- (UITextField *)textField{
    if(_textField == nil){
        _textField = [[UITextField alloc] init];
        _textField.font = self.titleLabel.font;
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.delegate = self;
    }
    return _textField;
}

- (UIView *)bottomLineView{
    if(_bottomLineView == nil){
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _bottomLineView;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(!self.enableInput){
        if(self.deledate && [self.deledate respondsToSelector:@selector(addCaseFormItemViewDidTapTextField:)]){
            [self.deledate addCaseFormItemViewDidTapTextField:self];
        }
    }
    return self.enableInput;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat bottomLineView_X = 10.0;
    CGFloat bottomLineView_H = 0.5;
    CGFloat bottomLineView_Y = self.bounds.size.height - bottomLineView_H;
    CGFloat bottomLineView_W = self.bounds.size.width - bottomLineView_X;
    self.bottomLineView.frame = CGRectMake(bottomLineView_X, bottomLineView_Y, bottomLineView_W, bottomLineView_H);
    
    CGFloat titleLabel_X = bottomLineView_X;
    CGFloat titleLabel_H = bottomLineView_Y;
    CGFloat titleLabel_Y = 0;
    CGFloat titleLabel_W = 90.0;
    self.titleLabel.frame = CGRectMake(titleLabel_X, titleLabel_Y, titleLabel_W, titleLabel_H);
    
    CGFloat textField_X = CGRectGetMaxX(self.titleLabel.frame) + titleLabel_X;
    CGFloat textField_Y = titleLabel_Y;
    CGFloat textField_H = titleLabel_H;
    CGFloat textField_W = self.bounds.size.width - textField_X - titleLabel_X;
    self.textField.frame = CGRectMake(textField_X, textField_Y, textField_W, textField_H);
}

@end

@interface SLAddCaseFormView()<SLAddCaseFormItemViewDelegate>

@property (nonatomic, strong) NSMutableArray *formItems;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation SLAddCaseFormView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (NSMutableArray *)formItems{
    if(_formItems == nil){
        _formItems = [NSMutableArray array];
    }
    return _formItems;
}

- (void)setupSubviews{
    NSArray *formItemTitles = @[@"案例名称", @"开发周期(月)", @"技术方案", @"开发价格"];
    for(NSInteger index = 0; index < formItemTitles.count; index ++){
        NSString *title = formItemTitles[index];
        SLAddCaseFormItemView *formItemView = [[SLAddCaseFormItemView alloc] init];
        formItemView.title = title;
        [self addSubview:formItemView];
        [self.formItems addObject:formItemView];
        if(index == formItemTitles.count  - 1){
            formItemView.enableInput = NO;
            formItemView.deledate = self;
        }
        if(index == 1){
            formItemView.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    
    self.topLineView = [[UIView alloc] init];
    //self.topLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    self.topLineView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.topLineView];
    
    self.bottomLineView = [[UIView alloc] init];
    //self.bottomLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    self.bottomLineView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bottomLineView];
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x = 0;
    frame.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 161.0);
    [super setFrame:frame];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat formItemView_X = 0;
    CGFloat formItemView_H = (self.bounds.size.height - 0.5) / self.formItems.count;
    CGFloat formItemView_W = self.bounds.size.width;
    
    for(NSInteger index = 0; index < self.formItems.count; index ++){
        SLAddCaseFormItemView *formItemView = self.formItems[index];
        CGFloat formItemView_Y = formItemView_H * index + 0.5;
        formItemView.frame = CGRectMake(formItemView_X, formItemView_Y, formItemView_W, formItemView_H);
        if(index == self.formItems.count - 1){
            formItemView.hideBottomLine = YES;
        }
    }
    
    CGRect topLineFrame = self.bounds;
    topLineFrame.size.height = 0.5;
    self.topLineView.frame = topLineFrame;
    
    CGRect bottomLineFrame = self.bounds;
    bottomLineFrame.size.height = 0.5;
    bottomLineFrame.origin.y = self.bounds.size.height - bottomLineFrame.size.height;
    self.bottomLineView.frame = bottomLineFrame;
}

- (void)setProjectName:(NSString *)projectName{
    [self formItemViewWithIndex:0].text = projectName;
}

- (NSString *)projectName{
    return [self formItemViewWithIndex:0].text;
}

- (void)setDevelopmentTime:(NSString *)developmentTime{
    [self formItemViewWithIndex:1].text = developmentTime;
}

- (NSString *)developmentTime{
    return [self formItemViewWithIndex:1].text;
}

- (void)setTechnicalScheme:(NSString *)technicalScheme{
    [self formItemViewWithIndex:2].text = technicalScheme;
}

- (NSString *)technicalScheme{
    return [self formItemViewWithIndex:2].text;
}

- (void)setDevelopmentPrice:(NSString *)developmentPrice{
    [self formItemViewWithIndex:3].text = developmentPrice;
}

- (NSString *)developmentPrice{
    return [self formItemViewWithIndex:3].text;
}

- (SLAddCaseFormItemView *)formItemViewWithIndex:(NSUInteger)index{
    return (SLAddCaseFormItemView *)self.formItems[index];
}

- (void)addCaseFormItemViewDidTapTextField:(SLAddCaseFormItemView *)addCaseFormItemView{
    [self endEditing:YES];
    if(self.delegate && [self.delegate respondsToSelector:@selector(addCaseFormViewDevelopmentPriceDidBeginSelect:)]){
        [self.delegate addCaseFormViewDevelopmentPriceDidBeginSelect:self];
    }
}

@end
