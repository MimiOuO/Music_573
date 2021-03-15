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
@property (nonatomic, strong) MioImageView *officialImg;
@property (nonatomic, strong) MioImageView *vipImg;
@property (nonatomic, strong) MioLabel *singerLab;
@property (nonatomic, strong) MioLabel *countLab;
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
        _officialImg = [MioImageView creatImgView:frame(-100, _nameLab.bottom + 5, 22, 12) inView:self image:@"playlist_zhengban" bgTintColorName:name_main radius:0];
        _vipImg = [MioImageView creatImgView:frame(-100, _nameLab.bottom + 5, 22, 12) inView:self image:@"playlist_vip" bgTintColorName:name_main radius:0];
        _singerLab = [MioLabel creatLabel:frame(_mvImg.right + 8, _nameLab.bottom + 2, self.width  - 136 - 45, 17) inView:self text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
        MioImageView *icon = [MioImageView creatImgView:frame(self.width - 46, 10, 22, 22) inView:self image:@"play" bgTintColorName:name_icon_three radius:0];
        _countLab = [MioLabel creatLabel:frame(self.width - 51, 34, 32, 17) inView:self text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentCenter];
    }
    return self;
}

- (void)setModel:(MioMusicModel *)model{
    [_cover sd_setImageWithURL:model.cover_image_path.mj_url placeholderImage:image(@"qxt_gequ")];
    _nameLab.text = model.title;
    _singerLab.text = model.singer_name;
    _countLab.text = model.hits_all;

    _flacImg.hidden = YES;
    _mvImg.hidden = YES;
    _officialImg.hidden = YES;
    _vipImg.hidden = YES;
    NSMutableArray *tagArr = [[NSMutableArray alloc] init];
    if (model.hasFlac) {
        _flacImg.hidden = NO;
        [tagArr addObject:_flacImg];
    }
    if (model.hasMV) {
        _mvImg.hidden = NO;
        [tagArr addObject:_mvImg];
    }
    if (model.official) {
        _officialImg.hidden = NO;
        [tagArr addObject:_officialImg];
    }
    if (model.need_vip) {
        _vipImg.hidden = NO;
        [tagArr addObject:_vipImg];
    }
    
    for (int i = 0;i < tagArr.count; i++) {
        ((UIView *)tagArr[i]).left = _cover.right + 8 + i * 26;
    }
    
    _singerLab.left = _cover.right + 8 + tagArr.count * 26;
    
}
@end

