//
//  QRCodeViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/17.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "QRCodeViewController.h"
//#import <QuartzCore/QuartzCore.h>
//#import "QREncoder.h"
#import "QRCodeGenerator.h"
#import "UIImageView+WebCache.h"
@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的二维码";
    
    UIImage *qrimage = [QRCodeGenerator qrImageForString:self.qrString imageSize:250 withPointType:QRPointRect withPositionType:QRPositionNormal withColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];

    
    UIImageView *QRImage = [[TouchImageView alloc] init];
    [QRImage setBounds:CGRectMake(0, 0, 250, 250)];
    [QRImage setCenter:self.view.center];
    QRImage.image = qrimage;
    [QRImage layer].magnificationFilter = kCAFilterNearest;
    [self.view addSubview:QRImage];
    
    if ([_qrString rangeOfString:kTOUserTag].location != NSNotFound)
    {
        UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, QRImage.frame.origin.y + QRImage.frame.size.height + 10, self.view.frame.size.width-20, 40)];
        endLabel.text = @"扫一扫上面的二维码图案,加我好友";
        endLabel.textAlignment = NSTextAlignmentCenter;
        endLabel.textColor = [UIColor grayColor];
        endLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.view addSubview:endLabel];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10 +64, 60, 60)];
        NSString *url = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,[[UserInfo sharedInfo] userHeadPicture]];
        [iconView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kDefaultIcon];
        [self.view addSubview:iconView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10 + 64, self.view.frame.size.width - 100, 60)];
        nameLabel.text = [[UserInfo sharedInfo] userName];
        [self.view addSubview:nameLabel];
    }
}

@end
