//
//  ChartCell.h
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartContentView.h"
#import "UIImageView+WebCache.h"
#import "RegexKitLite.h"
#import "SeparateByArray.h"
#import "ChartCellFrame.h"
#import "FileItemTableCell.h"
@class ChartCell;

@protocol ChartCellDelegate <NSObject>

-(void)chartCell:(ChartCell *)chartCell tapContent:(NSString *)content;
-(void)reloadCellInputView:(ChartCell *)chartCell;

///点击推荐的内容
-(void)clickChartItem:(ChartCell *)chartCell taoContentID:(NSString *)contentID andType:(NSString *)type;

///点击头像
-(void)clickChatIcon:(ChartCell *)cell;

///点击长按之后出现的删除按钮
-(void)clickDeteItemWithLongPress:(ChartCell *)cell;
///点击长按之后出现的编辑按钮
-(void)clickEditItemWithLongPress:(ChartCell *)cell;
@end


@interface ChartCell : FileItemTableCell
@property (nonatomic,strong) ChartCellFrame *cellFrame;
@property (nonatomic,weak) id<ChartCellDelegate> delegate;


@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) ChartContentView *chartView;
@property (nonatomic,strong) ChartContentView *currentChartView;
@property (nonatomic,strong) NSString *contentStr;
@property (nonatomic,strong) UILabel *nameLabel;





@end
