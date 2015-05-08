//
//  SetInfoViewController.h
//  TaskOffer
//
//  Created by BourbonZ on 15/4/3.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "BaseViewController.h"

@protocol SetInfoViewControllerDelegate <NSObject>

-(void)setInfoSuccess:(NSString *)value withTag:(NSInteger)tagTmp;
-(void)setInfoSuccess:(NSString *)value withKey:(NSString *)key;

@end
@interface SetInfoViewController : BaseViewController

///设置的标题
@property (nonatomic,copy) NSString *controllerTitle;
///设置tag值
@property (nonatomic,assign) NSInteger tagTmp;

///设置的key值
@property (nonatomic,copy) NSString *tmpKey;

@property (nonatomic,weak) id<SetInfoViewControllerDelegate>delegate;


@property (nonatomic,copy) NSString *placeString;

@end
