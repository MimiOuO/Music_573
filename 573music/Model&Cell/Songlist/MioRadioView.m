//
//  MioRadioView.m
//  573music
//
//  Created by Mimio on 2021/1/5.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioRadioView.h"

@implementation MioRadioView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)setModel:(MioSongListModel *)model{
    UIImageView *cover = [UIImageView creatImgView:frame(0, 0, 90, 90) inView:self image:@"" radius:4];
    [cover sd_setImageWithURL:[model.cover_image_path mj_url] placeholderImage:image(@"qxt_zhuanji")];
    MioView *tipBg = [MioView creatView:frame(0, 0, 26, 13) inView:self bgColorName:name_main radius:0];
    [tipBg addRoundedCorners:UIRectCornerTopLeft|UIRectCornerBottomRight withRadii:CGSizeMake(4, 4)];
    UILabel *tipLab = [UILabel creatLabel:frame(0, 0, 26, 13) inView:self text:@"电台" color:appWhiteColor size:8 alignment:NSTextAlignmentCenter];
    UIImageView *playIcon = [UIImageView creatImgView:frame(36, 36, 18, 18) inView:self image:@"shipinbofan" radius:0];
    MioLabel *titleLab = [MioLabel creatLabel:frame(0, 94, 90, 30) inView:self text:model.title colorName:name_text_one size:12 alignment:NSTextAlignmentLeft];
    if ([titleLab.text widthForFont:Font(12)] > self.width) {
        titleLab.height = 30;
    }else{
        titleLab.height = 17;
    }
}

@end
