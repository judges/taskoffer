//
//  FaceView.m
//  rndIM
//
//  Created by BourbonZ on 14/12/9.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "FaceView.h"
#import "ImageViewWithName.h"
static FaceView *tmpView;
@implementation FaceView
@synthesize faceView;
@synthesize delegate;
@synthesize control;
+(FaceView *)sharedFaceView
{
    if (tmpView == nil)
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        tmpView = [[FaceView alloc] initWithFrame:CGRectMake(0, window.frame.size.height - 216+80, [[[UIApplication sharedApplication] keyWindow] frame].size.width, 216-80)];
    }
    return tmpView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        int width = self.frame.size.width;
        int height = self.frame.size.height;
        
        faceView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        faceView.pagingEnabled = YES;
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.delegate = self;
        
        int size = 28;
        int m = 0;
        int n = 0;
        for (int i = 0 ; i < 6; i ++)
        {
            UIView *face = [[UIView alloc] initWithFrame:CGRectMake(width * i, 0, width, height-40)];
            for (int j = 0; j < 3; j++)
            {
                for (int k = 0; k < 7; k++)
                {
                    NSString *picName = @"f_static_";
                    if (n < 10)
                    {
                        picName = [picName stringByAppendingFormat:@"00%d",n];
                    }
                    else if (n >= 10 && n < 100)
                    {
                        picName = [picName stringByAppendingFormat:@"0%d",n];
                    }
                    else
                    {
                        picName = [picName stringByAppendingFormat:@"%d",n];
                    }
                    
                    if (m == i * 21 + 20)
                    {
                        picName = @"faceDelete";
                    }
                    else
                    {
                        n = n + 1;
                    }
                    

                    UIImage *pic = [UIImage imageNamed:picName];
                    
                    ImageViewWithName *picView = [[ImageViewWithName alloc] initWithImage:pic];
                    picView.imageName = picName;
                    picView.tag = m;
                    UITapGestureRecognizer *tapg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
                    tapg.numberOfTapsRequired = 1;
                    tapg.numberOfTouchesRequired = 1;
                    if (pic)
                    {
                        picView.userInteractionEnabled = YES;
                        [picView addGestureRecognizer:tapg];
                    }
                    float tmpSize =  ([[[UIApplication sharedApplication] keyWindow] frame].size.width-7*size-30)/6;
                    [picView setFrame:CGRectMake(k * (size + tmpSize)+15, j * size+10, size, size)];
                    [face addSubview:picView];
                    m = m + 1;

                }
            }
            
            [faceView addSubview:face];
        }
        
        
        
        
        control = [[UIPageControl alloc] initWithFrame:CGRectMake(110, 100, 100, 16)];
        control.numberOfPages = 6;
        control.currentPage = 0;
        control.userInteractionEnabled = YES;
        [control addTarget:self action:@selector(controlChange:) forControlEvents:(UIControlEventValueChanged)];
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button setTitle:@"发送" forState:(UIControlStateNormal)];
        [button setFrame:CGRectMake([[[UIApplication sharedApplication] keyWindow] frame].size.width-70, 100, 60, 30)];
        [button addTarget:self action:@selector(clickSendButton:) forControlEvents:(UIControlEventTouchUpInside)];
        button.backgroundColor = [UIColor blackColor];
        [faceView setContentSize:CGSizeMake(width * 6, height)];
        [self addSubview:faceView];
        [self addSubview:button];
        
        [self addSubview:control];
        
    }
    return self;
}
-(void)clickSendButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickFaceViewSendButton)])
    {
        [self.delegate clickFaceViewSendButton];
    }
}
-(void)clickImage:(UITapGestureRecognizer *)tapge
{
    if ([self.delegate respondsToSelector:@selector(clickFaceViewItem:withName:)])
    {
        ImageViewWithName *imageView = (ImageViewWithName *)[tapge view];
        [self.delegate clickFaceViewItem:imageView.image withName:imageView.imageName];
    }
}
-(void)controlChange:(UIPageControl *)pageControl
{
    int page = pageControl.currentPage;
    CGPoint point = CGPointMake(page * self.frame.size.width, 0);
    [faceView setContentOffset:point animated:YES];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    int i = point.x/300;
    control.currentPage = i;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
