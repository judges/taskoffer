//
//  SLCaseDetailTableViewDownloadInfoCell.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLCaseDetailTableViewDownloadInfoCell.h"
#import "SLHyperlinkLabel.h"
#import "HexColor.h"
#import "SLCaseDetailModel.h"

@interface SLCaseDetailTableViewDownloadInfoCell()

@property (weak, nonatomic) IBOutlet SLHyperlinkLabel *downloadUrlLabel;
@property (weak, nonatomic) IBOutlet UILabel *isOnlineLabel;

@end

@implementation SLCaseDetailTableViewDownloadInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLCaseDetailTableViewDownloadInfoCell";
    SLCaseDetailTableViewDownloadInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SLCaseDetailTableViewDownloadInfoCell class]) owner:self options:nil] firstObject];
        cell.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];

    }
    return cell;
}

- (void)setCaseDetailModel:(SLCaseDetailModel *)caseDetailModel{
    _caseDetailModel = caseDetailModel;
    if(caseDetailModel.isOnline){
        self.isOnlineLabel.text = @"已上线";
    }else{
        self.isOnlineLabel.text = @"未上线";
    }
    self.downloadUrlLabel.text = caseDetailModel.downloadLink;
}

- (void)awakeFromNib{
    self.downloadUrlLabel.textHighlightColor = [UIColor colorWithHexString:kDefaultBarColor];
    self.hideTopLine = YES;
    
    __block typeof(self) bself = self;
    self.downloadUrlLabel.hyperlinkLHandler = ^(NSURL *url){
        if(bself.delegate && [bself.delegate respondsToSelector:@selector(caseDetailTableViewDownloadInfoCell:didClickDownloadURL:)]){
            [bself.delegate caseDetailTableViewDownloadInfoCell:bself didClickDownloadURL:url];
        }
    };
}

@end
