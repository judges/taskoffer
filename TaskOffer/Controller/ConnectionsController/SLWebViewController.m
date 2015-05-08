//
//  SLWebViewController.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLWebViewController.h"
#import "UIBarButtonItem+Image.h"
#import "MBProgressHUD+Conveniently.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface SLWebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NJKWebViewProgress *webViewProgress;
@property (nonatomic, strong) NJKWebViewProgressView *webViewProgressView;

@end

@implementation SLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"刷新" target:self action:@selector(didClickRefreshBarButtonItem:)];
    
    self.webView.frame = self.view.bounds;
    [self.view addSubview:self.webView];
    
    [self.navigationController.navigationBar addSubview:self.webViewProgressView];
}

- (void)setWebURL:(NSURL *)webURL{
    _webURL = webURL;
    self.title = webURL.absoluteString;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:webURL];
    [self.webView loadRequest:request];
}

- (NJKWebViewProgress *)webViewProgress{
    if(_webViewProgress == nil){
        _webViewProgress = [[NJKWebViewProgress alloc] init];
        _webViewProgress.webViewProxyDelegate = self;
        _webViewProgress.progressDelegate = self;
    }
    return _webViewProgress;
}

- (NJKWebViewProgressView *)webViewProgressView{
    if(_webViewProgressView == nil){
        CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
        CGRect webViewProgressViewFrame = CGRectMake(0, navigaitonBarBounds.size.height - 1.0, navigaitonBarBounds.size.width, 1.0);
        _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:webViewProgressViewFrame];
        _webViewProgressView.progress = 0;
    }
    return _webViewProgressView;
}

- (UIWebView *)webView{
    if(_webView == nil){
        _webView = [[UIWebView alloc] init];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self.webViewProgress;
    }
    return _webView;
}

- (void)didClickRefreshBarButtonItem:(UIBarButtonItem *)barButtonItem{
    [self.webView reload];
}

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [self.webViewProgressView setProgress:progress animated:YES];
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if(title != nil && title.length > 0){
        self.title = title;
    }
}

@end
