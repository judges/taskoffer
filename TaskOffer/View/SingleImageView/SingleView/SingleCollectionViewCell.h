//
//  SingleCollectionViewCell.h
//  TaskOffer
//
//  Created by BourbonZ on 15/3/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SingleCollectionViewCell;
@protocol SingleVieDelegate <NSObject>

-(void)clickDeleButton:(SingleCollectionViewCell *)sender;
@end
@interface SingleCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *delButton;
@property (nonatomic,weak) id <SingleVieDelegate>delegate;



@end
