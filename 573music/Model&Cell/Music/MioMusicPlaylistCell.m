//
//  MioMusicPlaylistCell.m
//  573music
//
//  Created by Mimio on 2021/1/13.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioMusicPlaylistCell.h"

@interface MioMusicPlaylistCell()
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) MioLabel *nameLab;
@property (nonatomic, strong) MioImageView *flacImg;
@property (nonatomic, strong) MioImageView *mvImg;
@property (nonatomic, strong) MioLabel *singerLab;
@end

@implementation MioMusicPlaylistCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = appClearColor;
        
        _nameLab = [MioLabel creatLabel:frame(Mar, 0, 0, 44) inView:self.contentView text:@"" colorName:name_text_one size:14 alignment:NSTextAlignmentLeft];
        _flacImg = [MioImageView creatImgView:frame(0,Mar, 22, 12) inView:self.contentView image:@"playlist_nondestructive" bgTintColorName:name_main radius:0];
        _mvImg = [MioImageView creatImgView:frame(0, Mar, 22, 12) inView:self.contentView image:@"playlist_mv" bgTintColorName:name_main radius:0];
        _singerLab = [MioLabel creatLabel:frame(0, 0, 0, 44) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
        MioImageView *icon = [MioImageView creatImgView:frame(KSW - 32, 14, 16, 16) inView:self.contentView image:@"liebiao_qingchu" bgTintColorName:name_icon_three radius:0];
        [icon whenTapped:^{
            if (self.deleteBlock) {
                self.deleteBlock(self);
            }
        }];
    }
    return self;
}

- (void)setModel:(MioMusicModel *)model{
    _nameLab.text = model.title;
    _singerLab.text = model.singer_name;
    _nameLab.width = [_nameLab.text widthForFont:Font(14)];
    if (_nameLab.width > (KSW - 54)*0.5 ) {
        _nameLab.width = (KSW - 54)*0.5;
    }
    
    if (model.hasFlac) {
        _flacImg.hidden = NO;
        _flacImg.left = _nameLab.right + 4;
        _mvImg.left = _flacImg.right + 4;
        if (model.hasMV) {
            _mvImg.hidden = NO;
            _singerLab.left = _mvImg.right + 4;
        }else{
            _mvImg.hidden = YES;
            _singerLab.left = _flacImg.right + 4;
        }
    }else{
        _flacImg.hidden = YES;
        _mvImg.left = _nameLab.right + 4;
        if (model.hasMV) {
            _mvImg.hidden = NO;
            _singerLab.left = _mvImg.right + 4;
        }else{
            _mvImg.hidden = YES;
            _singerLab.left = _nameLab.right + 4;
        }
    }
    _singerLab.width = [_singerLab.text widthForFont:Font(12)];
    if (_singerLab.width > (KSW - 54)*0.3 ) {
        _singerLab.width = (KSW - 54)*0.3;
    }
}

- (void)setIsplaying:(BOOL)isplaying{
    if (isplaying) {
        _singerLab.textColor = color_main;
        _nameLab.textColor = color_main;
    }else{
        _nameLab.textColor = color_text_one;
        _singerLab.textColor = color_text_two;
    }
}

@end
