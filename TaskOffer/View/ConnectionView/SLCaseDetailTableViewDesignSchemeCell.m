//
//  SLCaseDetailTableViewDesignSchemeCell.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLCaseDetailTableViewDesignSchemeCell.h"
#import "UIImageView+SetImage.h"
#import "SLCaseDetailFrameModel.h"
#import "MJPhotoBrowser.h"
#import "HexColor.h"
#import "SLTaskImageView.h"
#import "SLHTTPServerHandler.h"

@interface SLCaseDetailTableViewDesignSchemeView : UIView

@property (nonatomic, assign) NSArray *URLs;

@end

@interface SLCaseDetailTableViewDesignSchemeView()

@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation SLCaseDetailTableViewDesignSchemeView

- (void)setURLs:(NSArray *)URLs{
    _URLs = URLs;
    for(SLTaskImageView *imageView in self.imageViewArray){
        [imageView removeFromSuperview];
    }
    [self.imageViewArray removeAllObjects];
    [self.photos removeAllObjects];
    
    if(URLs != nil && URLs.count > 0){
        CGFloat imgaeView_W = 90.0;
        CGFloat imgaeView_H = imgaeView_W;
        CGFloat imgaeView_Y = 0;
        for(NSInteger index = 0; index < URLs.count; index ++){
            SLTaskImageView *imageView = [[SLTaskImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            imageView.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
            imageView.tag = index;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImageView:)]];
            [imageView setImageWithURL:URLs[index]];
            CGFloat imgaeView_X = (imgaeView_W + 15.0) * index;
            imageView.frame = CGRectMake(imgaeView_X, imgaeView_Y, imgaeView_W, imgaeView_H);
            [self addSubview:imageView];
            [self.imageViewArray addObject:imageView];
            
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:SLHTTPServerLargeImageURL(URLs[index])];
            photo.srcImageView = imageView;
            photo.index = (int)index;
            [self.photos addObject:photo];
        }
    }
    
    [self setFrame:self.frame];
}

- (void)setFrame:(CGRect)frame{
    frame.size.height = 90.0;
    frame.size.width = frame.size.height * self.URLs.count + 15.0 * (self.URLs.count - 1);
    [super setFrame:frame];
}

- (NSMutableArray *)imageViewArray{
    if(_imageViewArray == nil){
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

- (NSMutableArray *)photos{
    if(_photos == nil){
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (void)didTapImageView:(UITapGestureRecognizer *)tapGestureRecognizer{
    if([tapGestureRecognizer.view isKindOfClass:[SLTaskImageView class]]){
        MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
        photoBrowser.photos = [self.photos copy];
        photoBrowser.currentPhotoIndex = tapGestureRecognizer.view.tag;
        [photoBrowser show];
    }
}

@end


@interface SLCaseDetailTableViewDesignSchemeCell()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SLCaseDetailTableViewDesignSchemeView *designSchemeView;

@end

@implementation SLCaseDetailTableViewDesignSchemeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLCaseDetailTableViewDesignSchemeCell";
    SLCaseDetailTableViewDesignSchemeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[self alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.scrollView];
        
        self.hideTopLine = YES;
        self.hideBottomLine = NO;
    }
    return self;
}

- (void)setCaseDetailFrameModel:(SLCaseDetailFrameModel *)caseDetailFrameModel{
    _caseDetailFrameModel = caseDetailFrameModel;
    self.designSchemeView.URLs = caseDetailFrameModel.caseDetailModel.designSchemeUrl;
    self.scrollView.contentSize = CGSizeMake(self.designSchemeView.bounds.size.width, 0);
}

- (UIScrollView *)scrollView{
    if(_scrollView == nil){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView addSubview:self.designSchemeView];
    }
    return _scrollView;
}

- (SLCaseDetailTableViewDesignSchemeView *)designSchemeView{
    if(_designSchemeView == nil){
        _designSchemeView = [[SLCaseDetailTableViewDesignSchemeView alloc] init];
    }
    return _designSchemeView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat scrollView_X = 10.0;
    CGFloat scrollView_Y = scrollView_X;
    CGFloat scrollView_H = 90.0;
    CGFloat scrollView_W = self.bounds.size.width - scrollView_X * 2;
    self.scrollView.frame = CGRectMake(scrollView_X, scrollView_Y, scrollView_W, scrollView_H);
}

@end
