//
//  ProjectDialogueView.h
//  TaskOffer
//
//  Created by BourbonZ on 15/4/10.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProjectDialogueViewDelegate <NSObject>

-(void)clickProjectDialogueView;

@end
@interface ProjectDialogueView : UIView

@property (nonatomic,weak) id <ProjectDialogueViewDelegate>delegate;
@end
