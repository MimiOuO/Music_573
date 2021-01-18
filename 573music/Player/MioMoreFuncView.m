//
//  MioMoreFuncView.m
//  573music
//
//  Created by Mimio on 2021/1/15.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioMoreFuncView.h"
#import "MioSingerVC.h"
#import "MioAlbumVC.h"
#import "MioFeedBackVC.h"
@interface MioMoreFuncView()
@property (nonatomic, strong) UIView *bgView;
@end

@implementation MioMoreFuncView

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
        
        UILabel *titleLab = [UILabel creatLabel:frame(0, 0, KSW, 50) inView:_bgView text:@"更多功能" color:color_text_one size:16];
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
    NSArray *imgArr = @[@"more_singer",@"more_album",@"more_forward",@"more_back",@"more_feedback"];
    NSArray *titleArr = @[@"歌手",@"专辑",@"歌词快退",@"歌词快进",@"反馈"];
    
    if ([_model.album_id intValue] < 0) {
        imgArr = @[@"more_singer",@"more_forward",@"more_back",@"more_feedback"];
        titleArr = @[@"歌手",@"歌词快退",@"歌词快进",@"反馈"];
    }
    
    for (int i = 0;i < titleArr.count; i++) {
        UIView *bgView = [UIView creatView:frame((KSW - 48*titleArr.count - 26*(titleArr.count - 1))/2 + i * 74 , 73, 48, 48) inView:_bgView bgColor:color_sup_four radius:6];
        MioImageView *icon = [MioImageView creatImgView:frame(13, 13, 22, 22) inView:bgView image:imgArr[i] bgTintColorName:name_icon_one radius:0];
        MioLabel *title = [MioLabel creatLabel:frame(bgView.left - 5, 123, 58, 17) inView:_bgView text:titleArr[i] colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
        [bgView whenTapped:^{
            if (Equals(titleArr[i], @"歌手")) {
                [self hiddenView];
                MioSingerVC *vc = [[MioSingerVC alloc] init];
                vc.singerId = _model.singer_id;
                [_fatherVC.navigationController pushViewController:vc animated:YES];
            }
            if (Equals(titleArr[i], @"专辑")) {
                [self hiddenView];
                MioAlbumVC *vc = [[MioAlbumVC alloc] init];
                vc.album_id = _model.album_id;
                [_fatherVC.navigationController pushViewController:vc animated:YES];
            }
            if (Equals(titleArr[i], @"歌词快退")) {
                _lrcView.adjustLrcSec = _lrcView.adjustLrcSec - 1;
                [self showTip];
            }
            if (Equals(titleArr[i], @"歌词快进")) {
                _lrcView.adjustLrcSec = _lrcView.adjustLrcSec + 1;
                [self showTip];
            }
            if (Equals(titleArr[i], @"反馈")) {
                [self hiddenView];
                MioFeedBackVC *vc = [[MioFeedBackVC alloc] init];
                [_fatherVC.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    
    
}

-(void)showTip{
    if (_lrcView.adjustLrcSec == 0) {
        [UIWindow showInfo:@"歌词还原"];
    }else if(_lrcView.adjustLrcSec < 0) {
        [UIWindow showInfo:[NSString stringWithFormat:@"歌词延后%ld秒",-(long)_lrcView.adjustLrcSec]];
    }else{
        [UIWindow showInfo:[NSString stringWithFormat:@"歌词提前%ld秒",(long)_lrcView.adjustLrcSec]];
    }
}

@end
