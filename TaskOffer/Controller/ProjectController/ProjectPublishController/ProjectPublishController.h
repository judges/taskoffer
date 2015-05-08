//
//  ProjectPublishController.h
//  TaskOffer
//
//  Created by BourbonZ on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "BaseViewController.h"
#import "ProjectTagView.h"

@protocol ProjectPublishControllerDelegate <NSObject>

-(void)projectPublishSuccess;

@end
@interface ProjectPublishController : BaseViewController
{
    NSArray *itemArray;
    NSArray *priceArray;
    UIPickerView *pricePicker;
    NSString *priceTagString;
    CustomTable *publishTable;
    UIDatePicker *priceDatePicker;
    NSString *dateString;
    ProjectTagView *tagView;
    NSMutableString *tagString;
    NSMutableArray *picItemArray;
    UICollectionView *itemCollection;
    UILabel *placeLable;
    
    UILabel *tmpLabel;

}
-(UITableViewCell *)drawCellWithView:(UITableView *)tableView CellPath:(NSIndexPath *)indexPath;
-(void)showAlertView:(NSString *)message;

@property (nonatomic,weak) id<ProjectPublishControllerDelegate>delegate;
@end
