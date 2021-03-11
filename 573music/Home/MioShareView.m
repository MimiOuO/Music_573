//
//  MioShareView.m
//  573music
//
//  Created by Mimio on 2021/3/11.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioShareView.h"
#import "SGWebView.h"
@implementation MioShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = appWhiteColor;
        SGWebView * webView = [SGWebView webViewWithFrame:CGRectMake(0, StatusH, KSW,  KSH - StatusH)];
        webView.backgroundColor = appClearColor;
        webView.progressViewColor = color_main;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://216.250.254.49:88/api/share?code=87270071"]]];
        [self addSubview:webView];
 
        UIView *coverView = [UIView creatView:frame(0, NavH, KSW, KSH - NavH) inView:self bgColor:appClearColor radius:0];
        
        
        [coverView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imglongTapClick:)]];
    }
    return self;
}

-(void)imglongTapClick:(UILongPressGestureRecognizer*)gesture
{
    if(gesture.state==UIGestureRecognizerStateBegan)
    {
        UIActionSheet*actionSheet = [[UIActionSheet alloc]initWithTitle:@"保存图片"delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"保存图片到手机",nil];

        actionSheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;

        [actionSheet showInView:self];

        UIImageView*img = (UIImageView*)[gesture view];

    }

}

- (void)actionSheet:(UIActionSheet*)actionSheet didDismissWithButtonIndex:  (NSInteger)buttonIndex

{

    if(buttonIndex ==0) {
        UIGraphicsBeginImageContext(self.bounds.size); //currentView当前的view

        [self.layer renderInContext:UIGraphicsGetCurrentContext()];

        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);

        [UIWindow showSuccess:@"已成功保存到相册"];

    }

}

@end
