//
//  FaceView.h
//  rndIM
//
//  Created by BourbonZ on 14/12/9.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol clickFaceViewDelegate <NSObject>

@required;
-(void)clickFaceViewItem:(UIImage *)image withName:(NSString *)imageName;
-(void)clickFaceViewSendButton;

@end
@interface FaceView : UIView<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *faceView;
@property (nonatomic,strong) UIPageControl *control;

@property (nonatomic,weak) id<clickFaceViewDelegate>delegate;

+(FaceView *)sharedFaceView;
@end
