//
//  MioUserAgreementVC.m
//  DuoDuoPeiwan
//
//  Created by Mimio on 2019/10/21.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioUserAgreementVC.h"
#import <WebKit/WebKit.h>
@interface MioUserAgreementVC()

@end

@implementation MioUserAgreementVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
//    [self.navView.centerButton setTitle:@"用户协议" forState:UIControlStateNormal];
    
//    self.tabBarController.tabBar.hidden = YES;
    //    wkwebview属性的集合
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    //    webview一些首选项的配置
    WKPreferences *preferences = [[WKPreferences alloc]init];
    //    在没有用户交互的情况下，是否允许js打开窗口，macOS默认是yes，iOS默认是no
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    //    webview的最小字体大小
    //    preferences.minimumFontSize = 40.0;
    
    configuration.preferences = preferences;
    
    WKWebView * webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavH, KSW, KSH - NavH) configuration:configuration];
    //    self.webView.UIDelegate = self;
    //    self.webView.navigationDelegate = self;
    [self.view addSubview:webView];
//     = @"https://duoduo.apphw.com/policy.html";
    NSString *urlString = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    [webView loadRequest:request];
}
@end
