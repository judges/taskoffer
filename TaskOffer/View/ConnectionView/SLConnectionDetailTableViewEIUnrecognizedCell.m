//
//  SLConnectionDetailTableViewEIUnrecognizedCell.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionDetailTableViewEIUnrecognizedCell.h"
#import "SLEnterpriseInformationFrameModel.h"
#import "HexColor.h"

@interface SLConnectionDetailTableViewEIUnrecognizedCell()

@property (nonatomic, strong) UILabel *companyDepartmentLabel;
@property (nonatomic, strong) UILabel *companyStaffSizeLabel;
@property (nonatomic, strong) UILabel *companyAddressLabel;
@property (nonatomic, strong) UILabel *companyIntroductionLabel;

@end

@implementation SLConnectionDetailTableViewEIUnrecognizedCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLConnectionDetailTableViewEIUnrecognizedCell";
    SLConnectionDetailTableViewEIUnrecognizedCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[self alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.companyDepartmentLabel];
        [self.contentView addSubview:self.companyStaffSizeLabel];
        [self.contentView addSubview:self.companyAddressLabel];
        [self.contentView addSubview:self.companyIntroductionLabel];
        self.hideTopLine = YES;
        self.hideBottomLine = NO;
    }
    return self;
}

- (void)setFrameModel:(SLEnterpriseInformationFrameModel *)frameModel{
    _frameModel = frameModel;
    self.companyDepartmentLabel.frame = frameModel.departmentFrame;
    self.companyDepartmentLabel.text = frameModel.eiModel.department;
    
    self.companyStaffSizeLabel.frame = frameModel.staffSizeFrame;
    if(frameModel.eiModel.staffSize.length > 0 && ![frameModel.eiModel.staffSize isEqualToString:@"尚未完善"]){
        BOOL noRenWord = [frameModel.eiModel.staffSize rangeOfString:@"人"].location == NSNotFound; // 公司规模中是否含有人字
        NSString *staffSizeString = [NSString stringWithFormat:@"公司规模：%@", frameModel.eiModel.staffSize];
        if(noRenWord){
            staffSizeString = [NSString stringWithFormat:@"%@人", staffSizeString];
        }
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:staffSizeString];
        [attributedText addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, 5)];
        if(noRenWord){
            [attributedText addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(staffSizeString.length - 1, 1)];
        }
        if(staffSizeString.length > (5 + noRenWord)){
            [attributedText addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0], NSForegroundColorAttributeName : [UIColor colorWithHexString:kDefaultOrgangeColor]} range:NSMakeRange(5, staffSizeString.length - (5 + noRenWord))];
        }
        self.companyStaffSizeLabel.attributedText = [attributedText copy];
    }else{
        NSString *staffSizeString = [NSString stringWithFormat:@"公司规模：%@", frameModel.eiModel.staffSize];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:staffSizeString];
        [attributedText addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, attributedText.string.length)];
        self.companyStaffSizeLabel.attributedText = [attributedText copy];
    }
    
    self.companyAddressLabel.frame = frameModel.addressFrame;
    self.companyAddressLabel.text = [NSString stringWithFormat:@"公司地址：%@", frameModel.eiModel.address];
    
    self.companyIntroductionLabel.frame = frameModel.introductionFrame;
    self.companyIntroductionLabel.text = frameModel.eiModel.introduction;
}

- (UILabel *)companyDepartmentLabel{
    if(_companyDepartmentLabel == nil){
        _companyDepartmentLabel = [[UILabel alloc] init];
        _companyDepartmentLabel.textAlignment = NSTextAlignmentLeft;
        _companyDepartmentLabel.textColor = [UIColor blackColor];
        _companyDepartmentLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _companyDepartmentLabel.numberOfLines = 0;
    }
    return _companyDepartmentLabel;
}

- (UILabel *)companyStaffSizeLabel{
    if(_companyStaffSizeLabel == nil){
        _companyStaffSizeLabel = [[UILabel alloc] init];
        _companyStaffSizeLabel.textAlignment = NSTextAlignmentLeft;
        _companyStaffSizeLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _companyStaffSizeLabel;
}

- (UILabel *)companyAddressLabel{
    if(_companyAddressLabel == nil){
        _companyAddressLabel = [[UILabel alloc] init];
        _companyAddressLabel.textAlignment = NSTextAlignmentLeft;
        _companyAddressLabel.textColor = [UIColor grayColor];
        _companyAddressLabel.font = [UIFont systemFontOfSize:15.0];
        _companyAddressLabel.numberOfLines = 0;
    }
    return _companyAddressLabel;
}

- (UILabel *)companyIntroductionLabel{
    if(_companyIntroductionLabel == nil){
        _companyIntroductionLabel = [[UILabel alloc] init];
        _companyIntroductionLabel.textAlignment = NSTextAlignmentLeft;
        _companyIntroductionLabel.textColor = [UIColor darkGrayColor];
        _companyIntroductionLabel.font = [UIFont systemFontOfSize:15.0];
        _companyIntroductionLabel.numberOfLines = 0;
    }
    return _companyIntroductionLabel;
}

@end
