//
//  WCPluginAboutViewController.m
//  IPAPatch
//
//  Created by 吴昕 on 10/08/2017.
//  Copyright © 2017 Weibo. All rights reserved.
//

#import "WCPluginAboutViewController.h"

@interface WCPluginAboutViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webview;
@end

@implementation WCPluginAboutViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webview = [UIWebView new];
    self.webview.delegate = self;
    self.webview.backgroundColor = [UIColor clearColor];
    self.webview.opaque = NO;
    self.webview.scalesPageToFit = YES;
    self.webview.mediaPlaybackRequiresUserAction = YES;
    self.webview.allowsInlineMediaPlayback = NO;
    self.webview.suppressesIncrementalRendering = YES;
    self.webview.frame =  CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
 
//    id preferences = [self.webview valueForKeyPath:[self decrypt : @"_RMGVIMZ2.4ILDHVI5RVD._DV45RVD.KIVUVIVMXVH"]]; //_internal.browserView._webView.preferences
//    SEL selector = NSSelectorFromString([self decrypt : @"_KLHGxZXSVnLWV2xSZM3VWmLGRURXZGRLM"]); //_postCacheModelChangedNotification
//    [preferences performSelector:selector];
    
    self.webview.scrollView.contentInset = UIEdgeInsetsZero;
    self.webview.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    self.webview.scrollView.contentOffset = CGPointZero;
    self.webview.scrollView.bounces = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.webview];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://m.baidu.com"]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGRect frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    if (self.webview) {
        self.webview.frame = frame;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"shouldStartLoadWithRequest : %@\n", request.URL.absoluteString);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

}

@end
