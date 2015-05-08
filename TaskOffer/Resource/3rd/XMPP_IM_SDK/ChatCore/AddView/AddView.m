//
//  AddView.m
//  rndIM
//
//  Created by BourbonZ on 14/12/10.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "AddView.h"
static AddView *addView;
@implementation AddView
@synthesize addscroll;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(AddView *)sharedAddView
{
    if (addView == nil)
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        addView = [[AddView alloc] initWithFrame:CGRectMake(0, window.frame.size.height - 216+80, [[[UIApplication sharedApplication] keyWindow] frame].size.width, 216-80)];
    }
    return addView;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        int width = self.frame.size.width;
        int height = self.frame.size.height;

        addscroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        addscroll.pagingEnabled = YES;
        addscroll.showsHorizontalScrollIndicator = NO;
        addscroll.delegate = self;
        
        UIImage *photo          = [UIImage imageNamed:@"发送图片.png"];
        UIImage *photoSelect    = [UIImage imageNamed:@"发送图片点击事件.png"];
        UIImage *location       = [UIImage imageNamed:@"分享位置.png"];
        UIImage *locationSelect = [UIImage imageNamed:@"分享位置点击事件.png"];
        UIImage *vcard          = [UIImage imageNamed:@"发送名片.png"];
        UIImage *vcardSelect    = [UIImage imageNamed:@"发送名片点击事件.png"];
        
        for (int i = 0; i < 1; i++)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
            
            UIButton *takeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [takeButton setImage:photo forState:(UIControlStateNormal)];
            [takeButton setImage:photoSelect forState:(UIControlStateSelected)];
            [takeButton setFrame:CGRectMake(42.5f, 40, 50, 50)];
            [view addSubview:takeButton];
            [takeButton addTarget:self action:@selector(clickTakePhoto) forControlEvents:(UIControlEventTouchUpInside)];
            UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(42.5f, 90, 50, 50)];
            [photoLabel setText:@"发送图片"];
            [photoLabel setFont:[UIFont systemFontOfSize:12.0f]];
            [view addSubview:photoLabel];
            
            UIButton *photoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [photoButton setImage:location forState:(UIControlStateNormal)];
            [photoButton setImage:locationSelect forState:(UIControlStateSelected)];
            [photoButton setFrame:CGRectMake(42.5f * 2 + 50, 40, 50, 50)];
//            [view addSubview:photoButton];
            [photoButton addTarget:self action:@selector(clickPhotoAlbum) forControlEvents:(UIControlEventTouchUpInside)];
            UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(42.5f * 2 + 50, 90, 50, 50)];
            [locationLabel setText:@"拍摄照片"];
            [locationLabel setFont:[UIFont systemFontOfSize:12.0f]];
//            [view addSubview:locationLabel];
            
            UIButton *vcardButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [vcardButton setImage:vcard forState:(UIControlStateNormal)];
            [vcardButton setImage:vcardSelect forState:(UIControlStateSelected)];
            [vcardButton setFrame:CGRectMake([[[UIApplication sharedApplication] keyWindow] frame].size.width-92.5f, 40, 50, 50)];
            [view addSubview:vcardButton];
            [vcardButton addTarget:self action:@selector(clickVcardButton) forControlEvents:(UIControlEventTouchUpInside)];
            UILabel *vcardLabel = [[UILabel alloc] initWithFrame:CGRectMake([[[UIApplication sharedApplication] keyWindow] frame].size.width-92.5f, 90, 50, 50)];
            [vcardLabel setText:@"拍摄照片"];
            [vcardLabel setFont:[UIFont systemFontOfSize:12.0f]];
            [view addSubview:vcardLabel];
            
            [addscroll addSubview:view];
        }

        addscroll.contentSize = CGSizeMake(width, height);

        [self addSubview:addscroll];
        
    }
    return self;
}

-(void)clickTakePhoto
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickAddViewWithTake)])
    {
        [self.delegate clickAddViewWithTake];
    }
}

-(void)clickPhotoAlbum
{
//    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickAddViewWithPhoto)])
//    {
//        [self.delegate clickAddViewWithPhoto];
//    }
}
-(void)clickVcardButton
{
//    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickAddViewWithVcard)])
//    {
//        [self.delegate clickAddViewWithVcard];
//    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickAddViewWithPhoto)])
    {
        [self.delegate clickAddViewWithPhoto];
    }
}
@end
