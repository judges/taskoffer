//
//  ProjectEditInfoController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/24.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ProjectEditInfoController.h"
#import "ProjectTagView.h"
#import "TOHttpHelper.h"
#import "CreateProjectCell.h"
@interface ProjectEditInfoController ()<UITextViewDelegate>
{
//    ProjectTagView *tagView;
}
@end

@implementation ProjectEditInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"项目编辑";
    
    
    
//    if (picItemArray.count == 0)
//    {
//        [self showAlertView:@"请先添加图片"];
//        return;
//    }
    
    dateString = [self.projectInfo.projectCloseDate stringByAppendingString:@" 00:00:00"];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    if (self.projectInfo.projectContent.length > 0)
    {
        placeLable.hidden = YES;
    }

    ///获取所有的价格标签
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"TO_PROJECT_PRICE" forKey:@"parentId"];
    
    [TOHttpHelper getUrl:kTOAllPriceTag parameters:dict showHUD:NO success:^(NSDictionary *dataDictionary) {
       
        priceArray = [dataDictionary objectForKey:@"info"];
        
        
        for (NSDictionary *tmp in priceArray)
        {
            if ([tmp.allValues.lastObject isEqualToString:self.projectInfo.projectPrice])
            {
                priceTagString = tmp.allKeys.lastObject;
                break;
            }
        }
        
    }];
    
    ///数据
    [TOHttpHelper getUrl:kTOALLAvailAble parameters:nil showHUD:NO success:^(NSDictionary *dataDictionary) {
       
        tagString = [NSMutableString string];
        NSArray *oldArray = [self.projectInfo.projectTags componentsSeparatedByString:@","];
        NSArray *array = [dataDictionary objectForKey:@"info"];
        
        if (oldArray.count != 0)
        {
            [tmpLabel setHidden:YES];
        }
        
        for (NSDictionary *tmp in array)
        {
            for (NSString *oldTag in oldArray)
            {
                if ([[tmp objectForKey:@"labelName"] isEqualToString:oldTag])
                {
                    tagString = [[tagString stringByAppendingFormat:@"%@,",[tmp objectForKey:@"labelCode"]] mutableCopy];
                    break;
                }
            }
        }
        if (tagString == nil || tagString.length == 0)
        {
            return ;
        }
        tagString = [[tagString substringToIndex:tagString.length-1] mutableCopy];
    }];
    
    

    
    NSString *picString = self.projectInfo.projectPicture;
    NSArray *arrary = [picString componentsSeparatedByString:@","];
    picItemArray = arrary.mutableCopy;
    [itemCollection reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark 项目编辑
-(void)publishItem:(NSMutableDictionary *)dict;
{
    NSString *string = kTOPublishProject;
    if ([self.title isEqualToString:@"项目编辑"])
    {
        string = kTOModifyProject;
        [dict setObject:self.projectInfo.projectID forKey:@"id"];
    }
    
    [TOHttpHelper postUrl:string parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
        
        if ([self.title isEqualToString:@"项目编辑"])
        {
            [super showAlertView:@"项目编辑成功"];
        }
        else
        {
            [super showAlertView:@"项目发布成功"];
        }
        
        if ([[dataDictionary objectForKey:@"message"] isEqualToString:@"success"])
        {
            [self.delegate projectPublishSuccess];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    } failure:^(NSError *error) {
        
        
        
    }];
    
}

#pragma mark UITableView
-(UITableViewCell *)drawCellWithView:(UITableView *)tableView CellPath:(NSIndexPath *)indexPath
{
    CreateProjectCell *cell = (CreateProjectCell *)[super drawCellWithView:tableView CellPath:indexPath];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.contentLabel.text = self.projectInfo.projectName;
        }
        else if (indexPath.row == 1)
        {
            cell.contentLabel.text = self.projectInfo.projectCloseDate;
        }
    }
    else if (indexPath.section== 1)
    {
        UITextView *view = (UITextView *)[cell.contentView viewWithTag:9001];
        
        [view setText:self.projectInfo.projectDescibe];
    }
    else if (indexPath.section == 2)
    {
        cell.contentLabel.text = self.projectInfo.projectPrice;
    }
    else if (indexPath.section == 3)
    {
        ProjectTagView *tmpTagView = (ProjectTagView *)[cell.contentView viewWithTag:9001];
        if (self.projectInfo.projectTags.length > 0)
        {
            if ([self.projectInfo.projectTags rangeOfString:@","].location == NSNotFound)
            {
                tmpTagView.tagArray = @[self.projectInfo.projectTags];
            }
            else
            {
                NSString *string = self.projectInfo.projectTags;
                tmpTagView.tagArray = [string componentsSeparatedByString:@","];
            }
        }
    }
    return cell;

}
#pragma mark UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    if ([text isEqualToString:@"\n"])
    {
        [textView endEditing:YES];
    }
    
    return YES;
}
@end
