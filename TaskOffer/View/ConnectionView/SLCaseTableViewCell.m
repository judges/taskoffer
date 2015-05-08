//
//  SLCaseTableViewCell.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLCaseTableViewCell.h"
#import "SLCaseCellImageView.h"
#import "HexColor.h"
#import "SLCaseDetailModel.h"
#import "UIImageView+SetImage.h"
#import "SLTaskImageView.h"

@interface SLCaseTableViewCell()<SLCaseCellToolViewDelegate>

@property (weak, nonatomic) IBOutlet SLCaseCellImageView *imagesView;
@property (weak, nonatomic) IBOutlet SLTaskImageView *caseLogoView;
@property (weak, nonatomic) IBOutlet UILabel *caseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *developmentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *technicalSchemeLabel;
@property (weak, nonatomic) IBOutlet UILabel *developmentPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@end

@implementation SLCaseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLCaseTableViewCell";
    SLCaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SLCaseTableViewCell class]) owner:self options:nil] firstObject];
        cell.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
    }
    return cell;
}

- (void)awakeFromNib{
    self.enableEditor = NO;
}

- (void)setCaseDetailModel:(SLCaseDetailModel *)caseDetailModel{
    _caseDetailModel = caseDetailModel;
    
    [self.caseLogoView setImageWithURL:caseDetailModel.caseLogo placeholderImage:kDefaultIcon];
    self.imagesView.imgaeURLs = caseDetailModel.designSchemeUrl;
    self.caseNameLabel.text = caseDetailModel.caseName;
    if(caseDetailModel.developmentTime.length > 0){
        self.developmentTimeLabel.text = [NSString stringWithFormat:@"%@个月", caseDetailModel.developmentTime];
    }else{
        self.developmentTimeLabel.text = nil;
    }
    self.technicalSchemeLabel.text = caseDetailModel.technicalScheme;
    self.developmentPriceLabel.text = caseDetailModel.referencePrice;
    
    self.downloadButton.hidden = !caseDetailModel.isValidURL;
}

- (IBAction)didClickEditButton:(UIButton *)button {
    if(self.delegate && [self.delegate respondsToSelector:@selector(caseTableViewCell:didClickEditButtonAtIndexPath:)]){
        [self.delegate caseTableViewCell:self didClickEditButtonAtIndexPath:self.indexPath];
    }
}

- (void)setEnableEditor:(BOOL)enableEditor{
    _enableEditor = enableEditor;
    self.editButton.hidden = !enableEditor;
}

@end
