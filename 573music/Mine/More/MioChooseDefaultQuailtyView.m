//
//  MioChooseDefaultQuailtyView.m
//  573music
//
//  Created by Mimio on 2021/1/18.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioChooseDefaultQuailtyView.h"
@interface MioChooseDefaultQuailtyView()
@property (nonatomic, strong) UIView *bgView;
@end

@implementation MioChooseDefaultQuailtyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = appClearColor;

        self.frame = frame(0, KSH, KSW, KSH);
        UIView *closeView = [UIView creatView:frame(0, 0, KSW, KSH - 210 - SafeBotH) inView:self bgColor:appClearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        [closeView addGestureRecognizer:tap];
        
        _bgView = [UIView creatView:frame(0, KSH - 210 - SafeBotH, KSW, 210 + SafeBotH) inView:self bgColor:appWhiteColor];
        MioImageView *bgImg = [MioImageView creatImgView:frame(0, 0, KSW, KSH) inView:_bgView skin:SkinName image:@"picture" radius:0];
        [_bgView addRoundedCorners:UIRectCornerTopRight|UIRectCornerTopLeft withRadii:CGSizeMake(16, 16)];
        
        UILabel *titleLab = [UILabel creatLabel:frame(0, 0, KSW, 50) inView:_bgView text:@"选择音质" color:color_text_one size:16];
        titleLab.textAlignment = NSTextAlignmentCenter;
        UIView *splitView = [UIView creatView:frame(0, 51, KSW, 0.5) inView:_bgView bgColor:color_split];
        
        UIButton *closeBtn = [UIButton creatBtn:frame(0, 160, KSW, 50 + SafeBotH) inView:_bgView bgColor:appClearColor title:@"关闭" titleColor:color_text_one font:14 radius:0 action:^{
            [self hiddenView];
        }];
    }
    return self;
}

- (void)show{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self creatUI];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, KSW, KSH);
    }];
}

- (void)hiddenView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, KSH, KSW, KSH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)creatUI{
    
    NSArray *titleArr = @[@"标清",@"高清",@"无损"];
    NSArray *imgArr = @[@"yz_bz",@"yz_gq",@"yz_ws"];
    
    for (int i = 0;i < titleArr.count; i++) {
        
        UIView *bgView = [UIView creatView:frame((KSW - 48*titleArr.count - 26*(titleArr.count - 1))/2 + i * 74 , 73, 48, 48) inView:_bgView bgColor:Equals(titleArr[i], [userdefault objectForKey:@"defaultQuailty"])?color_sup_one:color_sup_four radius:6];
        MioImageView *icon = [MioImageView creatImgView:frame(13, 13, 22, 22) inView:bgView image:imgArr[i] bgTintColorName:Equals(titleArr[i], [userdefault objectForKey:@"defaultQuailty"])?name_main:name_icon_one radius:0];
        MioLabel *title = [MioLabel creatLabel:frame(bgView.left - 5, 123, 58, 17) inView:_bgView text:titleArr[i] colorName:Equals(titleArr[i], [userdefault objectForKey:@"defaultQuailty"])?name_main:name_text_one size:12 alignment:NSTextAlignmentCenter];
        WEAKSELF;
        [bgView whenTapped:^{
            [userdefault setObject:titleArr[i] forKey:@"defaultQuailty"];
            if ([self.delegate respondsToSelector:@selector(changeDefaultQuailty)]) {
                [self.delegate changeDefaultQuailty];
            }
            [weakSelf hiddenView];
        }];
    }
}

@end

