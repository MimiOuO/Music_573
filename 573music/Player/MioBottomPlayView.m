//
//  MioPlayerView.m
//  573music
//
//  Created by Mimio on 2020/11/24.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioBottomPlayView.h"

@implementation MioBottomPlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = redTextColor;
            
        MioImageView *bottomImg = [MioImageView creatImgView:frame(0, 0, KSW, 50 + SafeBotH) inView:self skin:SkinName image:@"picture_bfq" radius:0];
//        UIButton *close = [UIButton creatBtn:frame(100, 0, 100, 50) inView:self bgColor:color_main     title:@"111" titleColor:appWhiteColor font:14 radius:5 action:^{
//            NSLog(@"23423423");
//
//        }];
        

    }
    return self;
}


@end
