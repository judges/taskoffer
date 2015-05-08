//
//  TagsViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/18.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "TagsViewController.h"
#import "SelecTagCollectionCell.h"
#import "TOHttpHelper.h"
#import "SLTagFrameModel.h"

@interface TagsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation TagsViewController
{
    NSMutableArray *selectTagsArray;
    NSMutableArray *tagsArray;
}
@synthesize isCompleteInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickSaveButton)];
    
    ///collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    UICollectionView *tagView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [tagView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    tagView.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
    [tagView setDataSource:self];
    [tagView setDelegate:self];

    [tagView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.view addSubview:tagView];

    
    tagsArray = [NSMutableArray array];
    selectTagsArray = [NSMutableArray array];

    ///数据
    
    [TOHttpHelper postUrl:kTOALLAvailAble parameters:nil showHUD:YES success:^(NSDictionary *dataDictionary) {
        
        tagsArray = [[dataDictionary objectForKey:@"info"] mutableCopy];
        [tagView reloadData];
        
    } failure:^(NSError *error) {
        
        
        
    }];
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
#pragma mark 点击保存按钮
-(void)clickSaveButton
{
    if (selectTagsArray.count > 5)
    {
        [HUDView showHUDWithText:@"标签最多选择5个"];
        return;
    }
    
    if (isCompleteInfo)
    {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(selectTagsSuccess:)])
        {
            [self.delegate selectTagsSuccess:selectTagsArray];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(selectTagsSuccess:)])
            {
                [self.delegate selectTagsSuccess:selectTagsArray];
            }
        }];
    }
}
#pragma mark UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return tagsArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 30);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIButton *tabButton = (UIButton *)[cell.contentView viewWithTag:9001];
    tabButton.selected = tabButton.selected == YES ? NO : YES;
    
    NSDictionary *info = [tagsArray objectAtIndex:indexPath.row];
    if ([selectTagsArray containsObject:info])
    {
        [selectTagsArray removeObject:info];
    }
    else
    {
        [selectTagsArray addObject:info];
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCell = @"collection";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    for (UIView *tmp in cell.contentView.subviews)
    {
        [tmp removeFromSuperview];
    }
    NSDictionary *tagDict = [tagsArray objectAtIndex:indexPath.row];
    
    UIButton *tagButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [tagButton setFrame:CGRectMake(0, 0, 60, 30)];
    [tagButton setTitle:[tagDict objectForKey:@"labelName"] forState:(UIControlStateNormal)];
    [tagButton setBackgroundImage:[UIImage imageNamed:@"标签背景"] forState:(UIControlStateSelected)];
    [tagButton setBackgroundImage:nil forState:(UIControlStateNormal)];
    [tagButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    [tagButton setTitleColor:[UIColor colorWithHexString:kDefaultTextColor] forState:(UIControlStateNormal)];
    tagButton.layer.borderWidth = 1.0f;
    tagButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    tagButton.layer.borderColor = [[UIColor colorWithHexString:kDefaultTextColor] CGColor];
    tagButton.tag = 9001;
    tagButton.userInteractionEnabled = NO;
    [cell.contentView addSubview:tagButton];
    
    
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 38)];
    [label setText:@"  请选择您的标签"];
    [label setTextColor:[UIColor colorWithHexString:kDefaultTextColor]];
    [label setFont:[UIFont systemFontOfSize:13.0f]];
    [view addSubview:label];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, self.view.frame.size.width, 1)];
    [lineView setBackgroundColor:[UIColor colorWithHexString:kDefaultTextColor]];
    [view addSubview:lineView];
    
    return view;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 40);
}
@end
