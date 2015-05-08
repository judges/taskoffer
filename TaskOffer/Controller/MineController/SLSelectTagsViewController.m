//
//  SLSelectTagsViewController.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/28.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLSelectTagsViewController.h"
#import "SLSelectTagFrameModel.h"
#import "SLRootTableView.h"
#import "SLSelectTagsTableViewCell.h"
#import "SLConnectionDetailTableSectionHeaderView.h"
#import "SLConnectionHTTPHandler.h"

@interface SLSelectTagsViewController ()<UITableViewDataSource, UITableViewDelegate, SLSelectTagsTableViewCellDelegate>

@property (nonatomic, strong) SLSelectTagFrameModel *selectTagFrameModel;
@property (nonatomic, strong) SLRootTableView *tableView;

@end

@implementation SLSelectTagsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"添加标签";
    }
    return self;
}

- (SLRootTableView *)tableView{
    if(_tableView == nil){
        _tableView = [[SLRootTableView alloc] initWithDefaultFrameStyle:UITableViewStyleGrouped dataSource:self delegate:self];
        _tableView.allowsSelection = NO;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    __block typeof(self) bself = self;
    [SLConnectionHTTPHandler GETTAllTagsWithSuccess:^(SLSelectTagFrameModel *selectTagFrameModel) {
        bself.selectTagFrameModel = selectTagFrameModel;
        [bself.tableView reloadData];
    } failure:^(NSString *errorMessage) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.selectTagFrameModel != nil && self.selectTagFrameModel.tagModels.count > 0){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLSelectTagsTableViewCell *cell = [SLSelectTagsTableViewCell cellWithTableView:tableView];
    cell.oldSelectedTags = self.selectedTags;
    cell.selectTagFrameModel = self.selectTagFrameModel;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.selectTagFrameModel.tagViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SLConnectionDetailTableSectionHeaderView *view = [SLConnectionDetailTableSectionHeaderView sectionHeaderViewWithTableView:tableView];
    view.title = @"请选择您的标签";
    view.hideMoreButton = YES;
    view.hideTopLine = YES;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)selectTagsTableViewCell:(SLSelectTagsTableViewCell *)selectTagsTableViewCell didSelectedTags:(NSArray *)selectedTags{
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectTagsViewController:didSelectedTags:)]){
        [self.delegate selectTagsViewController:self didSelectedTags:selectedTags];
    }
}

@end
