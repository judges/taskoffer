//
//  ChartContentView.h
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemView.h"
@class ChartContentView,ChartMessage;

@protocol ChartContentViewDelegate <NSObject>

-(void)chartContentViewLongPress:(ChartContentView *)chartView content:(NSString *)content;
-(void)chartContentViewTapPress:(ChartContentView *)chartView content:(NSString *)content;
//-(void)chartContentViewTapPressItemView:(ChartContentView *)chartView content:(NSString *)content;
@end

@interface ChartContentView : UIView
@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIView *faceView;
@property (nonatomic,strong) ChartMessage *chartMessage;
@property (nonatomic,weak) id <ChartContentViewDelegate> delegate;
@property (nonatomic,strong) UIImageView *picView;
@property (nonatomic,strong) UIImageView *soundWaveImg;

#pragma mark 推荐项目
@property (nonatomic,strong) ItemView *itemView;

@end
