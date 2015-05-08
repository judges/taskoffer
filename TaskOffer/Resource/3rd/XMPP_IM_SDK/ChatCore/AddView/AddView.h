//
//  AddView.h
//  rndIM
//
//  Created by BourbonZ on 14/12/10.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addViewDelegate <NSObject>

@required
-(void)clickAddViewWithTake;
-(void)clickAddViewWithPhoto;
-(void)clickAddViewWithVcard;

@end

@interface AddView : UIView<UIScrollViewDelegate,addViewDelegate>

@property (nonatomic,strong) UIScrollView *addscroll;
@property (nonatomic,weak) id<addViewDelegate>delegate;

+(AddView *)sharedAddView;

@end
