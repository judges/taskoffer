//
//  SLActionSheet.m
//  UIDemo
//
//  Created by wshaolin on 15/4/5.
//  Copyright (c) 2015年 rnd. All rights reserved.
//

#import "SLActionSheet.h"

@class SLActionSheetViewCancelItem, SLActionSheetViewItem;

@protocol SLActionSheetViewCancelItemDelegate <NSObject>

@optional
- (void)actionSheetViewCancelItemDidClickCancel:(SLActionSheetViewCancelItem *)cancelItem;

@end

@protocol SLActionSheetViewItemDelegate <NSObject>

@optional
- (void)actionSheetViewItem:(SLActionSheetViewItem *)actionSheetViewItem clickedItemButtonAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface SLActionSheetViewItemButton : UIButton

@property (nonatomic, assign, getter = isDestructiveButton) BOOL destructiveButton;

@end

@implementation SLActionSheetViewItemButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.titleLabel.font = [UIFont systemFontOfSize:18.0];
        self.destructiveButton = NO;
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 20.0, 0, 20.0);
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{
    if(highlighted){
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
    [super setHighlighted:highlighted];
}

- (void)setDestructiveButton:(BOOL)destructiveButton{
    _destructiveButton = destructiveButton;
    if(destructiveButton){
        [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

@end

@interface SLActionSheetViewItem : UITableViewCell

@property (nonatomic, copy) NSString *itemTitle;
@property (nonatomic, assign, getter = isHideTopLine) BOOL hideTopLine;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<SLActionSheetViewItemDelegate> delegate;
@property (nonatomic, assign, getter = isDestructiveButton) BOOL destructiveButton;

+ (instancetype)viewItemForTableView:(UITableView *)tableView;

@end

@interface SLActionSheetViewItem()

@property (nonatomic, strong) SLActionSheetViewItemButton *itemButton;
@property (nonatomic, strong) UIView *topLineView;

@end

@implementation SLActionSheetViewItem

+ (instancetype)viewItemForTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLActionSheetViewItem";
    SLActionSheetViewItem *viewItem = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(viewItem == nil){
        viewItem = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return viewItem;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.itemButton];
        [self.contentView addSubview:self.topLineView];
        
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

- (SLActionSheetViewItemButton *)itemButton{
    if(_itemButton == nil){
        _itemButton = [SLActionSheetViewItemButton buttonWithType:UIButtonTypeCustom];
        [_itemButton addTarget:self action:@selector(didClickItemButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _itemButton;
}

- (UIView *)topLineView{
    if(_topLineView == nil){
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _topLineView;
}

- (void)setItemTitle:(NSString *)itemTitle{
    _itemTitle = itemTitle;
    [self.itemButton setTitle:itemTitle forState:UIControlStateNormal];
}

- (void)setHideTopLine:(BOOL)hideTopLine{
    _hideTopLine = hideTopLine;
    self.topLineView.hidden = hideTopLine;
}

- (void)setDestructiveButton:(BOOL)destructiveButton{
    _destructiveButton = destructiveButton;
    self.itemButton.destructiveButton = destructiveButton;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect topLineViewFrame = self.bounds;
    topLineViewFrame.size.height = 0.5;
    self.topLineView.frame = topLineViewFrame;
    
    if(self.hideTopLine){
        self.itemButton.frame = self.bounds;
    }else{
        CGRect itemButtonFrame = self.bounds;
        itemButtonFrame.origin.y = CGRectGetMaxY(topLineViewFrame);
        itemButtonFrame.size.height = self.bounds.size.height - itemButtonFrame.origin.y;
        self.itemButton.frame = itemButtonFrame;
    }
}

- (void)didClickItemButton:(SLActionSheetViewItemButton *)itemButton{
    if(self.delegate && [self.delegate respondsToSelector:@selector(actionSheetViewItem:clickedItemButtonAtIndexPath:)]){
        [self.delegate actionSheetViewItem:self clickedItemButtonAtIndexPath:self.indexPath];
    }
}

@end

@interface SLActionSheetViewCancelItem : UIView

@property (nonatomic, copy) NSString *canelTitle;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, weak) id<SLActionSheetViewCancelItemDelegate> delegate;

@end

@interface SLActionSheetViewCancelItem()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) SLActionSheetViewItemButton *cancelItemButton;

@end

@implementation SLActionSheetViewCancelItem

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.lineView];
        [self addSubview:self.cancelItemButton];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UIView *)lineView{
    if(_lineView == nil){
        _lineView = [[UIView alloc] init];
    }
    return _lineView;
}

- (SLActionSheetViewItemButton *)cancelItemButton{
    if(_cancelItemButton == nil){
        _cancelItemButton = [SLActionSheetViewItemButton buttonWithType:UIButtonTypeCustom];
        [_cancelItemButton addTarget:self action:@selector(didClickCancelItemButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelItemButton;
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x = 0;
    frame.size.height = 50.0;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    [super setFrame:frame];
}

- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.lineView.backgroundColor = lineColor;
}

- (void)setCanelTitle:(NSString *)canelTitle{
    _canelTitle = canelTitle;
    [self.cancelItemButton setTitle:canelTitle forState:UIControlStateNormal];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat lineView_X = 0;
    CGFloat lineView_Y = 0;
    CGFloat lineView_W = self.bounds.size.width;
    CGFloat lineView_H = 5.0;
    self.lineView.frame = CGRectMake(lineView_X, lineView_Y, lineView_W, lineView_H);
    
    CGFloat cancelItemButton_X = 0;
    CGFloat cancelItemButton_Y = CGRectGetMaxY(self.lineView.frame);
    CGFloat cancelItemButton_W = lineView_W;
    CGFloat cancelItemButton_H = self.bounds.size.height - cancelItemButton_Y;
    self.cancelItemButton.frame = CGRectMake(cancelItemButton_X, cancelItemButton_Y, cancelItemButton_W, cancelItemButton_H);
}

- (void)didClickCancelItemButton:(SLActionSheetViewItemButton *)itemButton{
    if(self.delegate && [self.delegate respondsToSelector:@selector(actionSheetViewCancelItemDidClickCancel:)]){
        [self.delegate actionSheetViewCancelItemDidClickCancel:self];
    }
}

@end

@interface SLActionSheet()<UITableViewDataSource, UITableViewDelegate, SLActionSheetViewItemDelegate, SLActionSheetViewCancelItemDelegate>

@property (nonatomic, strong) NSMutableArray *otherButtonTitles;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) SLActionSheetViewCancelItem *cancelItem;
@property (nonatomic, strong) SLActionSheetViewItemButton *titleItem;
@property (nonatomic, strong) NSNumber *clickedButtonIndex;
@property (nonatomic, assign, getter = isShowDestructiveButton) BOOL showDestructiveButton;

@end

@implementation SLActionSheet

- (instancetype)initWithOtherButtonTitles:(NSString *)otherButtonTitles, ...{
    va_list args;
    va_start(args, otherButtonTitles);
    NSArray *otherButtonTitles_ = [self arrayWithVariable:otherButtonTitles andVarList:args];
    va_end(args);
    
    return [self initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:otherButtonTitles_];
}

- (instancetype)initWithDestructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    va_list args;
    va_start(args, otherButtonTitles);
    NSArray *otherButtonTitles_ = [self arrayWithVariable:otherButtonTitles andVarList:args];
    va_end(args);
    
    return [self initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles_];
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<SLActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    va_list args;
    va_start(args, otherButtonTitles);
    NSArray *otherButtonTitles_ = [self arrayWithVariable:otherButtonTitles andVarList:args];
    va_end(args);
    
    if([self initWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles_]){
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles{
    if([self initWithFrame:CGRectZero]){
        // title
        _title = [self validTitleWithTitle:title];
        if(_title != nil && _title.length > 0){
            self.titleItem = [[SLActionSheetViewItemButton alloc] init];
            self.titleItem.titleLabel.font = [UIFont systemFontOfSize:14.0];
            self.titleItem.titleLabel.numberOfLines = 2;
            [self.titleItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.titleItem setTitle:_title forState:UIControlStateNormal];
            self.titleItem.userInteractionEnabled = NO;
            self.titleItem.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60.0);
            self.tableView.tableHeaderView = self.titleItem;
        }
        
        // destructiveButton
        NSString *_destructiveButtonTitle = [self validTitleWithTitle:destructiveButtonTitle];
        if(_destructiveButtonTitle != nil && _destructiveButtonTitle.length > 0){
            self.showDestructiveButton = YES;
            [self.otherButtonTitles addObject:_destructiveButtonTitle];
        }
        
        // otherButton
        [self.otherButtonTitles addObjectsFromArray:otherButtonTitles];
        
        // cancelButton
        NSString *_cancelButtonTitle = [self validTitleWithTitle:cancelButtonTitle];
        if(_cancelButtonTitle != nil && _cancelButtonTitle.length > 0){
            self.cancelItem = [[SLActionSheetViewCancelItem alloc] init];
            self.cancelItem.lineColor = [UIColor colorWithWhite:0 alpha:0.2];
            self.cancelItem.canelTitle = _cancelButtonTitle;
            self.cancelItem.delegate = self;
            [super addSubview:self.cancelItem];
        }
        
        // 布局
        [self layoutButtonItems];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [super setBackgroundColor:[UIColor whiteColor]];
        
        _otherButtonTitles = [NSMutableArray array];
        [super addSubview:self.tableView];
        
        _coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0;
        _coverView.hidden = YES;
        // 添加手势，用于取消
        [_coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCoverView:)]];
    }
    return self;
}

- (UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.bounces = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        _tableView.allowsMultipleSelection = NO;
    }
    return _tableView;
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == - 1){
        return self.cancelItem.canelTitle;
    }else if(buttonIndex >= 0 && buttonIndex < self.otherButtonTitles.count){
        return self.otherButtonTitles[buttonIndex];
    }else{
        return nil;
    }
}

- (NSInteger)addButtonWithTitle:(NSString *)title{
    NSString *validTitle = [self validTitleWithTitle:title];
    if(validTitle != nil && validTitle.length > 0){
        [self.otherButtonTitles addObject:validTitle];
        [self layoutButtonItems];
        return self.otherButtonTitles.count - 1;
    }
    return NSNotFound;
}

- (void)setFrame:(CGRect)frame{
    // 不允许外界设置frame
}

- (NSInteger)numberOfButtons{
    if(self.cancelItem == nil){
        return self.otherButtonTitles.count;
    }
    return self.otherButtonTitles.count + 1;
}

- (NSInteger)cancelButtonIndex{
    if(self.cancelItem != nil){
        return -1;
    }
    return NSNotFound;
}

- (NSInteger)destructiveButtonIndex{
    if(self.showDestructiveButton){
        return 0;
    }
    return NSNotFound;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.otherButtonTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLActionSheetViewItem *viewItem = [SLActionSheetViewItem viewItemForTableView:tableView];
    viewItem.itemTitle = self.otherButtonTitles[indexPath.row];
    viewItem.indexPath = indexPath;
    viewItem.delegate = self;
    
    if(self.showDestructiveButton){
        viewItem.destructiveButton = indexPath.row == 0;
    }
    
    if(self.titleItem == nil){
        viewItem.hideTopLine = indexPath.row == 0;
    }
    return viewItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)actionSheetViewCancelItemDidClickCancel:(SLActionSheetViewCancelItem *)cancelItem{
    self.clickedButtonIndex = [NSNumber numberWithInteger:-1];
    if(self.delegate && [self.delegate respondsToSelector:@selector(actionSheetCancel:)]){
        [self.delegate actionSheetCancel:self];
    }
    [self hide];
}

- (void)actionSheetViewItem:(SLActionSheetViewItem *)actionSheetViewItem clickedItemButtonAtIndexPath:(NSIndexPath *)indexPath{
    self.clickedButtonIndex = [NSNumber numberWithInteger:indexPath.row];
    if(self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]){
        [self.delegate actionSheet:self clickedButtonAtIndex:indexPath.row];
    }
    [self hide];
}

- (void)show{
    if(self.superview != nil){
        [self removeFromSuperview];
    }
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self.coverView];
    [window addSubview:self];
    
    __block typeof(self) bself = self;
    self.coverView.hidden = NO;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(willPresentActionSheet:)]){
        [self.delegate willPresentActionSheet:self];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        bself.coverView.alpha = 0.2;
        bself.transform = CGAffineTransformMakeTranslation(0, -bself.bounds.size.height);
    } completion:^(BOOL finished) {
        if(bself.delegate && [bself.delegate respondsToSelector:@selector(didPresentActionSheet:)]){
            [bself.delegate didPresentActionSheet:bself];
        }
    }];
}

- (void)hide{
    __block typeof(self) bself = self;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)]){
        [self.delegate actionSheet:self willDismissWithButtonIndex:self.clickedButtonIndex.integerValue];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        bself.coverView.alpha = 0;
        bself.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        bself.coverView.hidden = YES;
        if(bself.delegate && [bself.delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]){
            [bself.delegate actionSheet:bself didDismissWithButtonIndex:bself.clickedButtonIndex.integerValue];
        }
        [bself.coverView removeFromSuperview];
        [bself removeFromSuperview];
    }];
}

- (void)layoutButtonItems{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat rowHeight = [self tableView:self.tableView heightForRowAtIndexPath:nil];
    CGFloat tableView_H = rowHeight * self.otherButtonTitles.count;
    if(self.titleItem != nil){
        tableView_H += self.titleItem.bounds.size.height;
    }
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    if(tableView_H > [UIScreen mainScreen].bounds.size.height - statusBarHeight - rowHeight * 3){
        tableView_H = [UIScreen mainScreen].bounds.size.height - statusBarHeight - rowHeight * 3;
        NSInteger row = tableView_H / rowHeight;
        tableView_H = rowHeight * row;
    }
    
    self.tableView.frame = CGRectMake(0, 0, width, tableView_H);
    
    CGFloat height = CGRectGetMaxY(self.tableView.frame);
    
    if(self.cancelItem != nil){
        CGFloat cancelItem_Y = CGRectGetMaxY(self.tableView.frame);
        self.cancelItem.frame = CGRectMake(0, cancelItem_Y, 0, 0);
        height = CGRectGetMaxY(self.cancelItem.frame);
    }
    
    [super setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, width, height)];
    [self.tableView reloadData];
}

- (void)didTapCoverView:(UITapGestureRecognizer *)tapGestureRecognizer{
    if(tapGestureRecognizer.view == self.coverView){
        self.clickedButtonIndex = [NSNumber numberWithInteger:NSNotFound];
        [self hide];
    }
}

- (NSString *)validTitleWithTitle:(NSString *)title{
    NSString *validTitle = title;
    if(validTitle != nil){
        validTitle = [validTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
        validTitle = [validTitle stringByReplacingOccurrencesOfString:@"  " withString:@""];
    }
    return validTitle;
}

- (NSArray *)arrayWithVariable:(NSString *)variable andVarList:(va_list)varList{
    NSMutableArray *array = [NSMutableArray array];
    NSString *validTitle = [self validTitleWithTitle:variable];
    if(validTitle != nil && validTitle.length > 0){
        [array addObject:validTitle];
    }
    
    NSString *title = nil;
    while((title = va_arg(varList, NSString *)))  {
        validTitle = [self validTitleWithTitle:title];
        if(validTitle != nil && validTitle.length > 0){
            [array addObject:validTitle];
        }
    }
    return  [array copy];
}

#pragma mark - 不允许添加子控件

- (void)addSubview:(UIView *)view{
    
}

- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview{
    
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index{
    
}

- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview{
    
}

- (void)exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2{
    
}

#pragma mark - 不允许通过tag获取子控件，防止外界改变自控件的属性

- (UIView *)viewWithTag:(NSInteger)tag{
    return nil;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    
}

@end
