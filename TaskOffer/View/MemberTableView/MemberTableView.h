//
//  MemberTableView.h
//  TaskOffer
//
//  Created by BourbonZ on 15/4/8.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectInfo;
@protocol MemberTableViewDelegate <NSObject>

@optional
-(void)clickMemberOnIndex:(NSIndexPath *)index withProjectInfo:(UserInfo *)projectInfo;

@end

@interface MemberTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *memberArray;

@property (nonatomic,weak) id<MemberTableViewDelegate>memberDelegate;

@end
