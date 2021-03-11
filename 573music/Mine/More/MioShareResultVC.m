//
//  MioShareResultVC.m
//  573music
//
//  Created by Mimio on 2021/3/8.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioShareResultVC.h"
#import "SGWebView.h"
#import <QuartzCore/QuartzCore.h>

@interface MioShareResultVC () <SGWebViewDelegate>
@property (nonatomic , strong) SGWebView *webView;
@property (nonatomic, strong) UIImageView *sentImg;
@end

@implementation MioShareResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    

    [self setupWebView];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"分享得会员" forState:UIControlStateNormal];
    WEAKSELF;
    self.navView.leftButtonBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
}

// 添加webView，加载扫描过来的内容
- (void)setupWebView {
    CGFloat webViewX = 0;
    CGFloat webViewY = StatusH;
    CGFloat webViewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat webViewH = KSH - StatusH;
    self.webView = [SGWebView webViewWithFrame:CGRectMake(webViewX, webViewY, webViewW, webViewH)];
//    if (self.comeFromVC == ScanSuccessJumpComeFromWB) {
        _webView.progressViewColor = color_main;
//    };
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.jump_URL]]];
    _webView.SGQRCodeDelegate = self;
    [self.view addSubview:_webView];
    
    


    UIView *coverView = [UIView creatView:frame(0, NavH, KSW, KSH - NavH) inView:self.view bgColor:appClearColor radius:0];
    
    [coverView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imglongTapClick:)]];

}

-(void)imglongTapClick:(UILongPressGestureRecognizer*)gesture
{
    if(gesture.state==UIGestureRecognizerStateBegan)
    {
        UIActionSheet*actionSheet = [[UIActionSheet alloc]initWithTitle:@"保存图片"delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"保存图片到手机",nil];

        actionSheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;

        [actionSheet showInView:self];

        UIImageView*img = (UIImageView*)[gesture view];

        _sentImg= img;

    }

}

- (void)actionSheet:(UIActionSheet*)actionSheet didDismissWithButtonIndex:  (NSInteger)buttonIndex

{

    if(buttonIndex ==0) {
        UIGraphicsBeginImageContext(self.view.bounds.size); //currentView当前的view

        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];

        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);

        [UIWindow showSuccess:@"已成功保存到相册"];

    }

}


@end
