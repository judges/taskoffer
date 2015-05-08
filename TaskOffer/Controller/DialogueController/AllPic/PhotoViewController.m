//
//  PhotoViewController.m
//  XMPPIM
//
//  Created by BourbonZ on 15/1/26.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "PhotoViewController.h"
#import "XMPPMessageInfo.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
@interface PhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSArray *picArray;
}
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"聊天图片";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:(UICollectionViewScrollDirectionVertical)];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    [self.view addSubview:collectionView];
    
    picArray = [[XMPPHelper sharedHelper] selectAllSomeModelMessageWithWho:self.currentName andChatType:self.type andMessageType:kPhoto];
    
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
#pragma mark UICollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return picArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(55, 55);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < picArray.count; i++)
    {
        MJPhoto *photo = [[MJPhoto alloc] init];
        NSString *urlStr = [[picArray objectAtIndex:i] body];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@".jpg" withString:@"_org.jpg"];
        photo.url = [NSURL URLWithString:urlStr];
        photo.index = i;
        [array addObject:photo];
    }
    
    
    
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    photoBrowser.photos =array;
    photoBrowser.currentPhotoIndex =indexPath.row;
    [photoBrowser show];

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    XMPPMessageInfo *info = [picArray objectAtIndex:indexPath.row];

    UIImageView *view = [[TouchImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    NSURL *url = [NSURL URLWithString:[info body]];
    [view sd_setImageWithURL:url placeholderImage:kDefaultIcon];
    [cell.contentView addSubview:view];
    return cell;
}

@end
