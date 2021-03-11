//
//  MioDJMusicTableCell.m
//  573music
//
//  Created by Mimio on 2021/2/20.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioDJMusicTableCell.h"

@interface MioDJMusicTableCell()
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) MioLabel *nameLab;
@property (nonatomic, strong) MioImageView *flacImg;
@property (nonatomic, strong) MioImageView *mvImg;
@property (nonatomic, strong) MioImageView *officialImg;
@property (nonatomic, strong) MioImageView *vipImg;
@property (nonatomic, strong) MioLabel *singerLab;
@property (nonatomic, strong) MioImageView *playCountIcon;
@property (nonatomic, strong) MioLabel *playCountLab;
@end

@implementation MioDJMusicTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = appClearColor;
        
        MioView *bg = [MioView creatView:frame(Mar, 0, KSW_Mar2, 66) inView:self.contentView bgColorName:name_card radius:6];
        _cover = [UIImageView creatImgView:frame(Mar, 0, 66, 66) inView:self.contentView image:@"" radius:6];
    
        _nameLab = [MioLabel creatLabel:frame(_cover.right + 8, 4, KSW - 84 - 30 , 40) inView:self.contentView text:@"" colorName:name_text_one size:16 alignment:NSTextAlignmentLeft];
        _nameLab.numberOfLines = 2;
        _flacImg = [MioImageView creatImgView:frame(_cover.right + 8, _nameLab.bottom + 5, 22, 12) inView:self.contentView image:@"playlist_nondestructive" bgTintColorName:name_main radius:0];
        _mvImg = [MioImageView creatImgView:frame(_flacImg.right + 4, _nameLab.bottom + 5, 22, 12) inView:self.contentView image:@"playlist_mv" bgTintColorName:name_main radius:0];
        _officialImg = [MioImageView creatImgView:frame(-100, _nameLab.bottom + 5, 22, 12) inView:self.contentView image:@"playlist_zhengban" bgTintColorName:name_main radius:0];
        _vipImg = [MioImageView creatImgView:frame(-100, _nameLab.bottom + 5, 22, 12) inView:self.contentView image:@"playlist_vip" bgTintColorName:name_main radius:0];
        _singerLab = [MioLabel creatLabel:frame(_mvImg.right + 8, _nameLab.bottom + 2, KSW - 136 - 45, 17) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
        _playCountIcon = [MioImageView creatImgView:frame(KSW_Mar - 12 - 40 - 12, 47.5, 14, 14) inView:self.contentView image:@"dj_bf" bgTintColorName:name_main radius:0];
        _playCountLab = [MioLabel creatLabel:frame(KSW_Mar - 40 -12, 47, 0, 15) inView:self.contentView text:@"" colorName:name_main size:12 alignment:NSTextAlignmentCenter];
    }
    return self;
}

- (void)setModel:(MioMusicModel *)model{
    [_cover sd_setImageWithURL:model.cover_image_path.mj_url placeholderImage:image(@"qxt_dj")];
    _nameLab.text = model.title;
    _singerLab.text = model.singer_name;

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
    
    _playCountLab.text = model.hits_all;
    _playCountLab.width = 40;//[model.hits_all widthForFont:Font(12)];
//    _playCountLab.left = KSW_Mar - 12 - _playCountLab.width;
    
}
@end
