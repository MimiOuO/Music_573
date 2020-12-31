//
//  MioPlayerView.m
//  573music
//
//  Created by Mimio on 2020/11/24.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioBottomPlayView.h"

@interface MioBottomPlayView()
@property (nonatomic, strong) UIImageView *coverImg;
@property (nonatomic, strong) MioLabel *songNameLab;
@property (nonatomic, strong) MioLabel *singerLab;
@property (nonatomic, strong) MioButton *playListBtn;
@property (nonatomic, strong) MioButton *playBtn;
@property (nonatomic, strong) MioButton *playNextBtn;
@end

@implementation MioBottomPlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = redTextColor;
            
        MioImageView *bottomImg = [MioImageView creatImgView:frame(0, 0, KSW, 50 + SafeBotH) inView:self skin:SkinName image:@"picture_bfq" radius:0];
        UIImageView *bgImg = [UIImageView creatImgView:frame(11, -11, 60, 60) inView:self image:@"dfq_yy" radius:0];
        _coverImg = [UIImageView creatImgView:frame(Mar, -9, 50, 50) inView:self image:@"qxt_logo" radius:4];
        _songNameLab = [MioLabel creatLabel:frame(74, 6, KSW - 120 - 75, 20) inView:self text:@"573音乐" colorName:name_text_one boldSize:14 alignment:NSTextAlignmentLeft];
        _singerLab = [MioLabel creatLabel:frame(74, 26, KSW - 120 - 75, 14) inView:self text:@"欢迎来到573音乐" colorName:name_text_two size:14 alignment:NSTextAlignmentLeft];
        
        _playListBtn = [MioButton creatBtn:frame(KSW - 102 - 17, 14.5, 17, 17) inView:self bgImage:@"bfq_bflb" bgTintColorName:name_main action:^{
            
        }];
        _playBtn = [MioButton creatBtn:frame(KSW - 56 - 26, 11, 26, 26) inView:self bgImage:@"play_dibu" bgTintColorName:name_main action:^{
            
        }];
        _playNextBtn = [MioButton creatBtn:frame(KSW - 20 - 17, 14.5, 17, 17) inView:self bgImage:@"bfq_xys" bgTintColorName:name_main action:^{
            
        }];
    }
    return self;
}


@end
