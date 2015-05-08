//
//  SLAboutViewController.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/29.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLAboutViewController.h"

@interface SLAboutViewController ()

@end

@implementation SLAboutViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"关于我们";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 64.0, self.view.bounds.size.width - 20.0, 50.0)];
    aboutLabel.textAlignment = NSTextAlignmentLeft;
    aboutLabel.textColor = [UIColor blackColor];
    aboutLabel.text = @"托付是专注于IT服务的商务社交平台";
    aboutLabel.numberOfLines = 0;
    aboutLabel.font = [UIFont systemFontOfSize:18.0];
    
    [self.view addSubview:aboutLabel];
}

@end
