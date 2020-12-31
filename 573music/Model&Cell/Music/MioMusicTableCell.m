//
//  MioMusicTableCell.m
//  573music
//
//  Created by Mimio on 2020/12/17.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMusicTableCell.h"

@interface MioMusicTableCell()
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) MioLabel *nameLab;
@property (nonatomic, strong) MioImageView *flacImg;
@property (nonatomic, strong) MioImageView *mvImg;
@property (nonatomic, strong) MioLabel *singerLab;
@end

@implementation MioMusicTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = appClearColor;
        _cover = [UIImageView creatImgView:frame(Mar, 6, 60, 60) inView:self.contentView image:@"" radius:4];
    
        _nameLab = [MioLabel creatLabel:frame(_cover.right + 8, 16, KSW - 84 - 45, 22) inView:self.contentView text:@"" colorName:name_text_one size:16 alignment:NSTextAlignmentLeft];
        _flacImg = [MioImageView creatImgView:frame(_cover.right + 8, _nameLab.bottom + 5, 22, 12) inView:self.contentView image:@"playlist_nondestructive" bgTintColorName:name_main radius:0];
        _mvImg = [MioImageView creatImgView:frame(_flacImg.right + 4, _nameLab.bottom + 5, 22, 12) inView:self.contentView image:@"playlist_mv" bgTintColorName:name_main radius:0];
        _singerLab = [MioLabel creatLabel:frame(_mvImg.right + 8, _nameLab.bottom + 2, KSW - 136 - 45, 17) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
        UIImageView *icon = [UIImageView creatImgView:frame(KSW - 46, 25, 22, 22) inView:self.contentView image:@"play" radius:0];
    }
    return self;
}

- (void)setModel:(MioMusicModel *)model{
    [_cover sd_setImageWithURL:model.cover_image_path.mj_url placeholderImage:image(@"qxt_gequ")];
    _nameLab.text = model.title;
    _singerLab.text = model.singer_name;
    if (model.hasFlac) {
        _flacImg.hidden = NO;
        _mvImg.left = 110;
        if (model.hasMV) {
            _mvImg.hidden = NO;
            _singerLab.left = 136;
        }else{
            _mvImg.hidden = YES;
            _singerLab.left = 110;
        }
    }else{
        _flacImg.hidden = YES;
        _mvImg.left = 84;
        if (model.hasMV) {
            _mvImg.hidden = NO;
            _singerLab.left = 110;
        }else{
            _mvImg.hidden = YES;
            _singerLab.left = 84;
        }
    }
}

@end
