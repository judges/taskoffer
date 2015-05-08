//
//  TouchImageView.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/30.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "TouchImageView.h"
#import "MJPhotoBrowser.h"
@implementation TouchImageView
{
    NSMutableArray *allPic;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init
{
    if (self == [super init])
    {
      
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
//    MJPhoto *photo = [[MJPhoto alloc] init];
//    photo.url = [NSURL URLWithString:self.picUrl]; // 图片路径
//    photo.srcImageView = self; // 来源于哪个UIImageView

    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    // 弹出相册时显示的第一张图片是点击的图片
    browser.currentPhotoIndex = self.picTag;
    // 设置所有的图片。photos是一个包含所有图片的数组。
    
//    if (allPic.count > 0)
//    {
        browser.photos = allPic;
//    }
//    else
//    {
//        browser.photos = [NSArray arrayWithObject:photo];
//    }
    
    [browser show];
}

-(void)setPicArray:(NSArray *)picArray
{
    self.userInteractionEnabled = YES;
    
    allPic = [NSMutableArray array];
    for (NSString *url in picArray)
    {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = self; // 来源于哪个UIImageView
        [allPic addObject:photo];
    }
}
@end
