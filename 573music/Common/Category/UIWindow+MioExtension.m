//
//  UIWindow+MioExtension.m
//  jgsschool
//
//  Created by Mimio on 2020/9/3.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "UIWindow+MioExtension.h"
#import "UIView+MioExtension.h"
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