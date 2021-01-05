//
//  MioMusicView.m
//  573music
//
//  Created by Mimio on 2021/1/4.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioMusicView.h"

@interface MioMusicView()
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) MioLabel *nameLab;
@property (nonatomic, strong) MioImageView *flacImg;
@property (nonatomic, strong) MioImageView *mvImg;
@property (nonatomic, strong) MioLabel *singerLab;
@end

@implementation MioMusicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cover = [UIImageView creatImgView:frame(0, 0, 60, 60) inView:self image:@"" radius:4];
    
        _nameLab = [MioLabel creatLabel:frame(_cover.right + 8, 10, self.width  - 84 - 45, 22) inView:self text:@"" colorName:name_text_one size:16 alignment:NSTextAlignmentLeft];
        _flacImg = [MioImageView creatImgView:frame(_cover.right + 8, _nameLab.bottom + 5, 22, 12) inView:self image:@"playlist_nondestructive" bgTintColorName:name_main radius:0];
        _mvImg = [MioImageView creatImgView:frame(_flacImg.right + 4, _nameLab.bottom + 5, 22, 12) inView:self image:@"playlist_mv" bgTintColorName:name_main radius:0];
        _singerLab = [MioLabel creatLabel:frame(_mvImg.right + 8, _nameLab.bottom + 2, self.width  - 136 - 45, 17) inView:self text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
        UIImageView *icon = [UIImageView creatImgView:frame(self.width - 46, 29, 22, 22) inView:self image:@"play" radius:0];
    }
    return self;
}

- (void)setModel:(MioMusicModel *)model{
    [_cover sd_setImageWithURL:model.cover_image_path.mj_url placeholderImage:image(@"qxt_gequ")];
    _nameLab.text = model.title;
    _singerLab.text = model.singer_name;
    if (model.hasFlac) {
        _flacImg.hidden = NO;
        _mvImg.left = 94;
        if (model.hasMV) {
            _mvImg.hidden = NO;
            _singerLab.left = 120;
        }else{
            _mvImg.hidden = YES;
            _singerLab.left = 94;
        }
    }else{
        _flacImg.hidden = YES;
        _mvImg.left = 68;
        if (model.hasMV) {
            _mvImg.hidden = NO;
            _singerLab.left = 94;
        }else{
            _mvImg.hidden = YES;
            _singerLab.left = 68;
        }
    }
}
@end
