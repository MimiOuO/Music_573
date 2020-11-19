//
//  MioPopBaseView.m
//  jgsschool
//
//  Created by Mimio on 2020/9/1.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioPopBaseView.h"
#import "AppDelegate.h"

@interface MioPopBaseView()
@property (nonatomic, strong) UIView *bgView;
@end

@implementation MioPopBaseView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = rgba(0, 0, 0, 0.3);
        self.frame = frame(0, KSH, KSW, KSH);

        UIView *closeView = [UIView creatView:frame(0, 0, KSW, KSH - _height - SafeBotH) inView:self bgColor:appClearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        [closeView addGestureRecognizer:tap];

        _bgView = [UIView creatView:frame(0, KSH, KSW, _height + SafeBotH) inView:self bgColor:appWhiteColor];
        [_bgView addRoundedCorners:UIRectCornerTopRight|UIRectCornerTopLeft withRadii:CGSizeMake(16, 16)];

        UILabel *titleLab = [UILabel creatLabel:frame(0, 0, KSW, 50) inView:_bgView text:@"选择排行榜" color:subColor size:16];
        titleLab.textAlignment = NSTextAlignmentCenter;

    
    }
    return self;
}


- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.frame = CGRectMake(0, 0, KSW, KSH);
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.top = KSH - _height - SafeBotH;
    }];
}

- (void)hiddenView {
    
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.top = KSH;
    } completion:^(BOOL finished) {
        self.frame = CGRectMake(0, KSH, KSW, KSH);
    }];
}


@end
