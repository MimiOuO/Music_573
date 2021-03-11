//
//  UIWindow+MioExtension.m
//  jgsschool
//
//  Created by Mimio on 2020/9/3.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "UIWindow+MioExtension.h"
#import "UIView+MioExtension.h"
#import "SGWebView.h"
#import "MioShareResultVC.h"
#import "MioNavView.h"
#import "MioShareView.h"
//#import <HXPhotoPicker/HXPhotoCommon.h>

@implementation UIWindow (MioExtension)
+(void)showInfo:(NSString *)text{
    CGFloat hudW = [text widthForFont:[UIFont systemFontOfSize:14]];// [UILabel hx_getTextWidthWithText:text height:15 fontSize:14];
    if (hudW > KSW - 60) {
        hudW = KSW - 60;
    }
    
    CGFloat hudH = [text heightForFont:[UIFont systemFontOfSize:14] width:hudW]; //[UILabel hx_getTextHeightWithText:text width:hudW fontSize:14];
    if (hudW < 100) {
        hudW = 100;
    }
    MioHUD *hud = [[MioHUD alloc] initWithFrame:CGRectMake(0, 0, hudW + 20, 110 + hudH - 15) imageName:@"infoHud" text:text];
    hud.alpha = 0;
    
       
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    

    hud.center = CGPointMake(KSW / 2, KSH / 2);
    hud.transform = CGAffineTransformMakeScale(0.4, 0.4);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:0 animations:^{
        hud.alpha = 1;
        hud.transform = CGAffineTransformIdentity;
    } completion:nil];
    [UIView cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(handleGraceTimer) withObject:nil afterDelay:1.75f inModes:@[NSRunLoopCommonModes]];
}

+(void)showSuccess:(NSString *)text{
    CGFloat hudW = [text widthForFont:[UIFont systemFontOfSize:14]];// [UILabel hx_getTextWidthWithText:text height:15 fontSize:14];
    if (hudW > KSW - 60) {
        hudW = KSW - 60;
    }
    
    CGFloat hudH = [text heightForFont:[UIFont systemFontOfSize:14] width:hudW]; //[UILabel hx_getTextHeightWithText:text width:hudW fontSize:14];
    if (hudW < 100) {
        hudW = 100;
    }
    MioHUD *hud = [[MioHUD alloc] initWithFrame:CGRectMake(0, 0, hudW + 20, 110 + hudH - 15) imageName:@"successHud" text:text];
    hud.alpha = 0;
    
       
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    

    hud.center = CGPointMake(KSW / 2, KSH / 2);
    hud.transform = CGAffineTransformMakeScale(0.4, 0.4);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:0 animations:^{
        hud.alpha = 1;
        hud.transform = CGAffineTransformIdentity;
    } completion:nil];
    [UIView cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(handleGraceTimer) withObject:nil afterDelay:1.75f inModes:@[NSRunLoopCommonModes]];
}

+(void)showLoading{
 

    CGFloat width = 95;
    CGFloat height = 95;

    MioHUD *hud = [[MioHUD alloc] initWithFrame:CGRectMake(0, 0, width, height) imageName:nil text:nil];
    [hud showloading];
    hud.alpha = 1;
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.center = CGPointMake(KSW / 2, KSH / 2);
//    if (immediately) {
//        hud.alpha = 1;
//    }else {
    hud.transform = CGAffineTransformMakeScale(0.4, 0.4);
    [UIWindow animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:0 animations:^{
        hud.alpha = 1;
        hud.transform = CGAffineTransformIdentity;
    } completion:nil];
//    }
}

+(void)showLoading:(NSString *)text{
    CGFloat hudW = [text widthForFont:[UIFont systemFontOfSize:14]];
    if (hudW > KSW - 60) {
        hudW = KSH - 60;
    }
    
    CGFloat hudH = [text heightForFont:[UIFont systemFontOfSize:14] width:hudW];
    CGFloat width = 110;
    CGFloat height = width + hudH - 15;
    if (!text) {
        width = 95;
        height = 95;
    }
    MioHUD *hud = [[MioHUD alloc] initWithFrame:CGRectMake(0, 0, width, height) imageName:nil text:text];
    [hud showloading];
    hud.alpha = 1;
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.center = CGPointMake(KSW / 2, KSH / 2);
//    if (immediately) {
//        hud.alpha = 1;
//    }else {
    hud.transform = CGAffineTransformMakeScale(0.4, 0.4);
    [UIWindow animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:0 animations:^{
        hud.alpha = 1;
        hud.transform = CGAffineTransformIdentity;
    } completion:nil];
//    }
}

+(void)showMaskLoading:(NSString *)text{
    CGFloat hudW = [text widthForFont:[UIFont systemFontOfSize:14]];
    if (hudW > KSW - 60) {
        hudW = KSH - 60;
    }
    
    CGFloat hudH = [text heightForFont:[UIFont systemFontOfSize:14] width:hudW];
    CGFloat width = 110;
    CGFloat height = width + hudH - 15;
    if (!text) {
        width = 95;
        height = 95;
    }
    
    MioHUD *hud = [[MioHUD alloc] initWithFrame:CGRectMake(0, 0, width, height) imageName:nil text:text];
    [hud showloading];
    hud.alpha = 1;
    
    MioBgView *hudView = [[MioBgView alloc] initWithFrame:frame(0, 0, KSW, KSH)];
    
    [[UIApplication sharedApplication].keyWindow addSubview:hudView];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.center = CGPointMake(KSW / 2, KSH / 2);
//    if (immediately) {
//        hud.alpha = 1;
//    }else {
    hud.transform = CGAffineTransformMakeScale(0.4, 0.4);
    [UIWindow animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:0 animations:^{
        hud.alpha = 1;
        hud.transform = CGAffineTransformIdentity;
    } completion:nil];
//    }
}

+(void)hiddenLoading{
    [UIWindow cancelPreviousPerformRequestsWithTarget:self];
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[MioHUD class]] || [view isKindOfClass:[MioBgView class]]) {
            
            [UIWindow animateWithDuration:0.3 animations:^{
                    view.alpha = 0;
                    view.transform = CGAffineTransformMakeScale(0.5, 0.5);
                } completion:^(BOOL finished) {
                    [view removeFromSuperview];
                }];

        }
    }
}

+(void)hiddenEnterLoading{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[MioHUD class]] || [view isKindOfClass:[MioBgView class]]) {
            if (view.width < 100) {
                [UIWindow animateWithDuration:0.3 animations:^{
                        view.alpha = 0;
                        view.transform = CGAffineTransformMakeScale(0.5, 0.5);
                    } completion:^(BOOL finished) {
                        [view removeFromSuperview];
                    }];
            }
        }
    }
}

+ (void)handleGraceTimer {
    [UIWindow cancelPreviousPerformRequestsWithTarget:self];
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[MioHUD class]] || [view isKindOfClass:[MioBgView class]]) {
            [UIWindow animateWithDuration:0.25f animations:^{
                view.alpha = 0;
                view.transform = CGAffineTransformMakeScale(0.5, 0.5);
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
    }
}

+(void)showMessage:(NSString *)message withTitle:(NSString *)title
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;

    
    UIView *bgView = [UIView creatView:frame(0, 0, KSW, KSH) inView:window bgColor:rgba(0, 0, 0, 0.3) radius:0];


    MioView *view = [MioView creatView:frame(40, 0, KSW - 80, KSH) inView:bgView bgColorName:name_hud radius:8];


    MioLabel *titleLab = [MioLabel creatLabel:frame(0, 0, KSW -  80, 50) inView:view text:title colorName:name_text_one boldSize:16 alignment:NSTextAlignmentCenter];
    MioView *split = [MioView creatView:frame(0, 49.5, KSW - 80, 0.5) inView:view bgColorName:name_split radius:0];
    MioLabel *tip = [MioLabel creatLabel:frame(Mar, 60, KSW_Mar2 -  80, 0) inView:view text:message colorName:name_text_one size:14 alignment:NSTextAlignmentLeft];
    tip.numberOfLines = 0;


    UIButton *knowBtn = [UIButton creatBtn:frame(20, tip.bottom + 20, view.width - 40, 38) inView:view bgColor:color_main title:@"我知道了" titleColor:appWhiteColor font:14 radius:6 action:^{
        [UIView animateWithDuration:0.3 animations:^{
            bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
    }];

    tip.height = [tip.text heightForFont:Font(14) width:KSW_Mar2 - 80];
    view.height = tip.height + 60 + 20 + 38 + 16;
    view.centerY = KSH/2;
    knowBtn.top = tip.bottom + 20;
}

+(void)showLucky{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *bgView = [UIView creatView:frame(0, 0, KSW, KSH) inView:window bgColor:rgba(0, 0, 0, 0.5) radius:0];

    CGFloat webViewX = 0;
    CGFloat webViewY = 0;
    CGFloat webViewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat webViewH = KSH;
    SGWebView * webView = [SGWebView webViewWithFrame:CGRectMake(webViewX, webViewY, webViewW, webViewH)];
    webView.backgroundColor = appClearColor;
    webView.progressViewColor = color_main;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://216.250.254.49:88/api/lottery_page"]]];
    [bgView addSubview:webView];

 
    UIButton *clickBtn = [UIButton creatBtn:frame(50, KSH * 0.4, KSW - 100, KSH * 0.3) inView:bgView bgImage:@"" action:^{
        [webView.wkWebView evaluateJavaScript:@"getLottery()" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        }];
        [MioPostReq(api_lottery, @{@"k":@"v"}) success:^(NSDictionary *result){
        } failure:^(NSString *errorInfo) {}];
    }];

    UIButton *closeBtn = [UIButton creatBtn:frame(KSW2 - 20, KSH * 0.8, 40, 40) inView:bgView bgImage:@"tc_gb" action:^{
        [UIView animateWithDuration:0.3 animations:^{
            bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
            PostNotice(@"refreshInfo");
        }];
    }];
}


+(void)showShare{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *bgView = [UIView creatView:frame(0, 0, KSW, KSH) inView:window bgColor:rgba(0, 0, 0, 0.3) radius:0];

    MioView *view = [MioView creatView:frame(KSW/2 - 285/2, KSH/2 - 179, 285, 340) inView:bgView bgColorName:name_hud radius:8];

    UILabel *title = [UILabel creatLabel:frame(0, 12, 285, 22) inView:view text:@"分享好友领会员VIP" color:color_main boldSize:16 alignment:NSTextAlignmentCenter];
    
    UILabel *tip1 = [UILabel creatLabel:frame(0, 55, 285, 20) inView:view text:@"你已经分享给0个好友" color:color_text_two size:14 alignment:NSTextAlignmentCenter];
    
    [MioGetReq(api_userInfo, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        tip1.text = [NSString stringWithFormat:@"你已经分享给%@个好友",data[@"invitee_num"]];
    } failure:^(NSString *errorInfo) {}];
    
    UIImageView *img = [UIImageView creatImgView:frame(54, 83, 177, 177) inView:view image:@"vip_15" radius:0];
    UILabel *tip3 = [UILabel creatLabel:frame(0, 242, 285, 20) inView:view text:@"好友可得7天VIP会员" color:color_main size:12 alignment:NSTextAlignmentCenter];
    
    UIButton *shareBtn = [UIButton creatBtn:frame(20, 270,245, 38) inView:view bgColor:color_main title:@"参加活动" titleColor:appWhiteColor font:14 radius:6 action:^{
        if (!islogin) {
            PostNotice(@"login");
            return;
        }

        [view removeFromSuperview];
        MioShareView *shareView = [[MioShareView alloc] initWithFrame:frame(0, 0, KSW, KSH)];
        [bgView addSubview:shareView];

        MioNavView *navView = [[MioNavView alloc] initWithFrame:frame(0, 0, KSW, NavH)];
        [shareView addSubview:navView];
        
        [navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
        [navView.centerButton setTitle:@"分享得会员" forState:UIControlStateNormal];
        navView.leftButtonBlock = ^{
            [bgView removeFromSuperview];
        };
        
    }];
    
    UILabel *tip2 = [UILabel creatLabel:frame(0, 312, 285, 20) inView:view text:@"（注册需填写邀请码，否则无效）" color:color_text_two size:10 alignment:NSTextAlignmentCenter];

    
    UIButton *closeBtn = [UIButton creatBtn:frame(KSW2 - 20, KSH * 0.8, 40, 40) inView:bgView bgImage:@"tc_gb" action:^{
        [UIView animateWithDuration:0.3 animations:^{
            bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
    }];
}



+(void)showNewVersion:(NSString *)message link:(NSString *)url
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
   
    
    UIView *bgView = [UIView creatView:frame(0, 0, KSW, KSH) inView:window bgColor:rgba(0, 0, 0, 0.3) radius:0];
    MioView *view = [MioView creatView:frame(40, 0, KSW - 80, KSH) inView:bgView bgColorName:name_hud radius:8];
    
//    UIImageView *icon = [UIImageView creatImgView:frame(20, view.top - 13, ksw, 69) inView:bgView image:@"gengxin_yinfu" radius:0];
    MioImageView *icon = [MioImageView creatImgView:frame(20, view.top - 13, KSW - 50, 80) inView:bgView image:@"gengxin_yinfu" bgTintColorName:name_main radius:0];
    
    MioLabel *titleLab1 = [MioLabel creatLabel:frame(0, 68, KSW -  80, 14) inView:view text:@"Discover new version" colorName:name_text_two size:10 alignment:NSTextAlignmentCenter];
    MioLabel *titleLab2 = [MioLabel creatLabel:frame(0, 84, KSW -  80, 34) inView:view text:@"发现新版本" colorName:name_text_one size:24 alignment:NSTextAlignmentCenter];
    
    MioLabel *tip = [MioLabel creatLabel:frame(20, 136, KSW - 130, 0) inView:view text:message colorName:name_text_one size:14 alignment:NSTextAlignmentLeft];
    tip.numberOfLines = 0;

    
    UIButton *knowBtn = [UIButton creatBtn:frame(20, tip.bottom + 20, view.width - 40, 38) inView:view bgColor:color_main title:@"立即更新" titleColor:appWhiteColor font:14 radius:6 action:^{
        [[UIApplication sharedApplication] openURL:url.mj_url];
    }];
    
    UIButton *ignoreBtn = [UIButton creatBtn:frame(20, knowBtn.bottom + 10, view.width - 40, 38) inView:view bgColor:appClearColor title:@"忽略此版本" titleColor:color_text_two font:14 radius:6 action:^{
        [UIView animateWithDuration:0.3 animations:^{
            bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
    }];
    
    tip.height = [tip.text heightForFont:Font(14) width:KSW - 130];
    view.height = tip.height + 136 + 130;
    view.centerY = KSH/2;
    knowBtn.top = tip.bottom + 20;
    ignoreBtn.top = knowBtn.bottom + 15;
    icon.top = view.top - 13;

}


+(void)showOnlyWifiTip{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIWindow showMessage:@"当前网络模式为“仅WIFI可用”,不能访问网络" withTitle:@"提示"];
    });
}


@end




@interface MioHUD ()
@property (copy, nonatomic) NSString *imageName;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;
@property (strong, nonatomic) UILabel *titleLb;
@property (strong, nonatomic) UIActivityIndicatorView *loading;
@end

@implementation MioHUD

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        _text = text;
        self.imageName = imageName;
//        self.layer.masksToBounds = NO;
//        self.layer.cornerRadius = 5;
        [self addSubview:self.visualEffectView];
        [self setup];
    }
    return self;
}

- (void)setup {
    UIImage *image = self.imageName.length ? [UIImage imageNamed:self.imageName] : nil;
    self.isImage = image != nil;
    if ([HXPhotoCommon photoCommon].isDark) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    self.imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:self.imageView];
    if ([HXPhotoCommon photoCommon].isDark) {
        self.imageView.tintColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    }
    
    self.titleLb = [[UILabel alloc] init];
    self.titleLb.text = self.text;
    self.titleLb.textColor = [HXPhotoCommon photoCommon].isDark ? [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1] : [UIColor whiteColor];
    self.titleLb.textAlignment = NSTextAlignmentCenter;
    self.titleLb.font = [UIFont systemFontOfSize:14];
    self.titleLb.numberOfLines = 0;
    [self addSubview:self.titleLb];
}
- (void)setText:(NSString *)text {
    _text = text;
    self.titleLb.text = text;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat imgW = self.imageView.image.size.width;
    if (imgW <= 0) imgW = 37;
    CGFloat imgH = self.imageView.image.size.height;
    if (imgH <= 0) imgH = 37;
    CGFloat imgCenterX = self.frame.size.width / 2;
    self.imageView.frame = CGRectMake(0, 20, imgW, imgH);
    self.imageView.center = CGPointMake(imgCenterX, self.imageView.center.y);
    
    self.titleLb.mj_x = 10;
    self.titleLb.mj_y = CGRectGetMaxY(self.imageView.frame) + 10;
    self.titleLb.mj_w = self.frame.size.width - 20;
    self.titleLb.mj_h = [self.titleLb.text heightForFont:[UIFont systemFontOfSize:14] width:self.titleLb.mj_w];
    if (self.text.length) {
        self.mj_h = CGRectGetMaxY(self.titleLb.frame) + 20;
    }
    if (_loading) {
        if (self.text) {
            self.loading.frame = self.imageView.frame;
        }else {
            self.loading.frame = self.bounds;
        }
    }
}
- (UIActivityIndicatorView *)loading {
    if (!_loading) {
        _loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
#ifdef __IPHONE_13_0
        if ([HXPhotoCommon photoCommon].isDark) {
            if (@available(iOS 13.0, *)) {
                _loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;
            } else {
                _loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            }
            _loading.color = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
        }
#endif
        [_loading startAnimating];
    }
    return _loading;
}
- (void)showloading {
    [self addSubview:self.loading];
    self.imageView.hidden = YES;
}

- (UIVisualEffectView *)visualEffectView {
    if (!_visualEffectView) {
        if ([HXPhotoCommon photoCommon].isDark) {
            UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            _visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
        }else {
            UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            _visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
        }
        _visualEffectView.frame = self.bounds;
        _visualEffectView.layer.masksToBounds = YES;
        _visualEffectView.layer.cornerRadius = 5;
    }
    return _visualEffectView;
}

@end

@interface MioBgView ()
@end

@implementation MioBgView

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


@end
