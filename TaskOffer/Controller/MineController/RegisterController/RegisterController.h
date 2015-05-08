//
//  RegisterController.h
//  TaskOffer
//
//  Created by BourbonZ on 15/3/18.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "BaseViewController.h"

@protocol  RegisterControllerDelegate <NSObject>

-(void)closeRegisterView;

@end

@interface RegisterController : BaseViewController
@property (nonatomic,weak) id<RegisterControllerDelegate>delegate;

@end
