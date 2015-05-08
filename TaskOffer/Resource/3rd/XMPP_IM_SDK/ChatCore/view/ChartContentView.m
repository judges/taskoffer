//
//  ChartContentView.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#define kContentStartMargin 25
#import "ChartContentView.h"
#import "ChartMessage.h"
@implementation ChartContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backImageView=[[UIImageView alloc]init];
        self.backImageView.userInteractionEnabled=YES;
        [self addSubview:self.backImageView];
        
        self.contentLabel=[[UILabel alloc]init];
        self.contentLabel.numberOfLines=0;
        self.contentLabel.textAlignment=NSTextAlignmentLeft;
        self.contentLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
//        [self addSubview:self.contentLabel];

        self.picView = [[TouchImageView alloc] init];
        [self.picView setContentMode:(UIViewContentModeScaleAspectFit)];
        self.picView.layer.cornerRadius = 10.0f;
        self.picView.layer.masksToBounds = NO;
        self.picView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.picView];
        
        self.faceView = [[UIView alloc] init];
        self.faceView.layer.cornerRadius = 10.0f;
        [self addSubview:self.faceView];
        
        self.itemView = [[ItemView alloc] init];
        [self addSubview:self.itemView];
        
        [self addGestureRecognizer: [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)]];

        UITapGestureRecognizer *tapCell = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)];
        [self addGestureRecognizer:tapCell];
        
//        self.itemView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tapItemView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressItemView:)];
//        [tapCell requireGestureRecognizerToFail:tapItemView];
//        [self.itemView addGestureRecognizer:tapItemView];
        
        self.soundWaveImg = [[UIImageView alloc] init];
        self.soundWaveImg.hidden = YES;
        [self addSubview:self.soundWaveImg];
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    ///音波图片
    if (self.chartMessage.messageType == kMessageTo)
    {
        self.soundWaveImg.bounds = CGRectMake(0, 0, 12.5f, 22);
        self.soundWaveImg.center = CGPointMake(self.frame.size.width-22, self.frame.size.height/2);
        self.soundWaveImg.image = [UIImage imageNamed:@"本人语音"];
    }
    else
    {
        self.soundWaveImg.bounds = CGRectMake(0, 0, 12.5f, 22);
        self.soundWaveImg.center = CGPointMake(22, self.frame.size.height/2);
        self.soundWaveImg.image = [UIImage imageNamed:@"对方语音"];
    }

    
    self.backImageView.frame=self.bounds;
    CGFloat contentLabelX=0;
    if(self.chartMessage.messageType==kMessageFrom)
    {
        contentLabelX=kContentStartMargin*0.8 + 2;
    }
    else if(self.chartMessage.messageType==kMessageTo)
    {
        contentLabelX=kContentStartMargin*0.5;
    }
    

    self.contentLabel.frame=CGRectMake(contentLabelX, -3, self.frame.size.width-kContentStartMargin-5, self.frame.size.height);

    self.picView.frame = CGRectMake(contentLabelX-2, 3, self.frame.size.width-kContentStartMargin-5, self.frame.size.height-15);
    self.faceView.frame = self.contentLabel.frame;
    self.itemView.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y-100, self.contentLabel.frame.size.width, self.contentLabel.frame.size.height);
    
}
-(void)longTap:(UILongPressGestureRecognizer *)longTap
{
    if([self.delegate respondsToSelector:@selector(chartContentViewLongPress:content:)]){
        
        [self.delegate chartContentViewLongPress:self content:self.contentLabel.text];
    }
}
-(void)tapPress:(UILongPressGestureRecognizer *)tapPress
{
    if([self.delegate respondsToSelector:@selector(chartContentViewTapPress:content:)]){
        
        NSString *_tmpPath = self.contentLabel.text;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[_tmpPath dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
        if (dict != nil)
        {
            _tmpPath = [dict objectForKey:@"content"];
        }
        NSArray *array = [_tmpPath componentsSeparatedByString:@"/"];
        NSString *path = [array lastObject];
        path = [path stringByReplacingOccurrencesOfString:@".amr" withString:@".wav"];
        [self.delegate chartContentViewTapPress:self content:path];
    }
}
//-(void)tapPressItemView:(UITapGestureRecognizer *)tapg
//{
//    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(chartContentViewTapPressItemView:content:)])
//    {
//        [self.delegate chartContentViewTapPressItemView:self content:nil];
//    }
//}
@end
