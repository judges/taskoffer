//
//  SingleCollectionViewCell.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SingleCollectionViewCell.h"
#import "MJPhotoBrowser.h"
@implementation SingleCollectionViewCell
@synthesize imageView;
@synthesize delButton;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        imageView = [[UIImageView alloc] init];
//        imageView.userInteractionEnabled = YES;
//        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIcon:)]];
        [self addSubview:imageView];
        
        delButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [delButton setBackgroundImage:[UIImage imageNamed:@"删除"] forState:(UIControlStateNormal)];
        [delButton addTarget:self action:@selector(delButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:delButton];
    }
    return self;
}

-(void)delButtonClick
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickDeleButton:)])
    {
        [self.delegate clickDeleButton:self];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [imageView setFrame:CGRectMake(0, 0, 67.5f, 67.5f)];
    [delButton setBounds:CGRectMake(0, 0, 22.5f, 22.5f)];
    [delButton setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height-11.25f)];
}
-(void)clickIcon:(UITapGestureRecognizer *)tapg
{
//    if (tapg.state == UIGestureRecognizerStateBegan)
//    {
//        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//        // 弹出相册时显示的第一张图片是点击的图片
//        browser.currentPhotoIndex = 0;
//        // 设置所有的图片。photos是一个包含所有图片的数组。
//        
//        //    if (allPic.count > 0)
//        //    {
//        
//        
//        self.userInteractionEnabled = YES;
//        
//        NSMutableArray *allPic = [NSMutableArray array];
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString:url]; // 图片路径
//        photo.srcImageView = imageView; // 来源于哪个UIImageView
//        [allPic addObject:photo];
//        
//
//        
//        browser.photos = allPic;
//        
//        [browser show];
//    }
//
    
}
@end
