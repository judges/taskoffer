//
//  SetSexInfoViewController.h
//  TaskOffer
//
//  Created by BourbonZ on 15/4/22.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetSexInfoViewControllerDelegate <NSObject>

-(void)setUserSexSuccess:(NSString *)sex;

@end
@interface SetSexInfoViewController : UITableViewController

@property (nonatomic,weak) id<SetSexInfoViewControllerDelegate>delegate;

@end
